--[[
    Jet-lib Callback System (Client-side)
    Based on ox_lib callback system
]]

local validation = require 'modules.Callback.validation'
local pendingCallbacks = {}
local timers = {}
local cbEvent = '__jet_cb_%s'
local callbackTimeout = GetConvarInt('jet:callbackTimeout', 30000)
local resourceName = cache and cache.resource or GetCurrentResourceName()

RegisterNetEvent(cbEvent:format(resourceName), function(key, ...)
    if source == '' then return end

    local cb = pendingCallbacks[key]

    if not cb then return end

    pendingCallbacks[key] = nil

    cb(...)
end)

---@param event string
---@param delay? number | false prevent the event from being called for the given time
local function eventTimer(event, delay)
    if delay and type(delay) == 'number' and delay > 0 then
        local time = GetGameTimer()

        if (timers[event] or 0) > time then
            return false
        end

        timers[event] = time + delay
    end

    return true
end

---@param _ any
---@param event string
---@param delay number | false | nil
---@param cb function | false
---@param ... any
---@return ...
local function triggerServerCallback(_, event, delay, cb, ...)
    if not eventTimer(event, delay) then return end

    local key

    repeat
        key = ('%s:%s'):format(event, math.random(0, 100000))
    until not pendingCallbacks[key]

    TriggerServerEvent('jet:validateCallback', event, resourceName, key)
    TriggerServerEvent(cbEvent:format(event), resourceName, key, ...)

    ---@type promise | false
    local promise = not cb and promise.new()

    pendingCallbacks[key] = function(response, ...)
        if response == 'cb_invalid' then
            response = ("callback '%s' does not exist"):format(event)

            return promise and promise:reject(response) or error(response)
        end

        response = { response, ... }

        if promise then
            return promise:resolve(response)
        end

        if cb then
            cb(table.unpack(response))
        end
    end

    if promise then
        SetTimeout(callbackTimeout, function() promise:reject(("callback event '%s' timed out"):format(key)) end)

        return table.unpack(Citizen.Await(promise))
    end
end

local Callback = {}

-- Main callback trigger
Callback.Trigger = function(event, delay, cb, ...)
    if not cb then
        print(("callback event '%s' does not have a function to callback to and will instead await\nuse Callback.Await or a regular event to remove this warning"):format(event))
    else
        local cbType = type(cb)

        if cbType == 'table' and getmetatable(cb) and getmetatable(cb).__call then
            cbType = 'function'
        end

        assert(cbType == 'function', ("expected argument 3 to have type 'function' (received %s)"):format(cbType))
    end

    return triggerServerCallback(nil, event, delay, cb, ...)
end

---@param event string
---@param delay? number | false prevent the event from being called for the given time.
---Sends an event to the server and halts the current thread until a response is returned.
function Callback.Await(event, delay, ...)
    return triggerServerCallback(nil, event, delay, false, ...)
end

local function callbackResponse(success, result, ...)
    if not success then
        if result then
            return print(('^1SCRIPT ERROR: %s^0\n%s'):format(result,
                Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString()) or ''))
        end

        return false
    end

    return result, ...
end

local pcall = pcall

---@param name string
---@param cb function
---Registers an event handler and callback function to respond to server requests.
function Callback.Register(name, cb)
    local event = cbEvent:format(name)

    validation.setValidCallback(name, true)

    RegisterNetEvent(event, function(resource, key, ...)
        TriggerServerEvent(cbEvent:format(resource), key, callbackResponse(pcall(cb, ...)))
    end)
end

-- Expose validation functions
Callback.setValidCallback = validation.setValidCallback
Callback.isCallbackValid = validation.isCallbackValid

return Callback
