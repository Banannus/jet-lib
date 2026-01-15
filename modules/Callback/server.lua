--[[
    Jet-lib Callback System (Server-side)
    Based on ox_lib callback system
]]

local validation = require 'modules.Callback.validation'
local pendingCallbacks = {}
local cbEvent = '__jet_cb_%s'
local callbackTimeout = GetConvarInt('jet:callbackTimeout', 30000)
local resourceName = cache and cache.resource or GetCurrentResourceName()

RegisterNetEvent(cbEvent:format(resourceName), function(key, ...)
    local cb = pendingCallbacks[key]

    if not cb then return end

    pendingCallbacks[key] = nil

    cb(...)
end)

---@param _ any
---@param event string
---@param playerId number
---@param cb function|false
---@param ... any
---@return ...
local function triggerClientCallback(_, event, playerId, cb, ...)
    assert(DoesPlayerExist(playerId --[[@as string]]), ("target playerId '%s' does not exist"):format(playerId))

    local key

    repeat
        key = ('%s:%s:%s'):format(event, math.random(0, 100000), playerId)
    until not pendingCallbacks[key]

    TriggerClientEvent('jet:validateCallback', playerId, event, resourceName, key)
    TriggerClientEvent(cbEvent:format(event), playerId, resourceName, key, ...)

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
Callback.Trigger = function(event, playerId, cb, ...)
    if not cb then
        print(("callback event '%s' does not have a function to callback to and will instead await\nuse Callback.Await or a regular event to remove this warning"):format(event))
    else
        local cbType = type(cb)

        if cbType == 'table' and getmetatable(cb) and getmetatable(cb).__call then
            cbType = 'function'
        end

        assert(cbType == 'function', ("expected argument 3 to have type 'function' (received %s)"):format(cbType))
    end

    return triggerClientCallback(nil, event, playerId, cb, ...)
end

---@param event string
---@param playerId number
--- Sends an event to a client and halts the current thread until a response is returned.
function Callback.Await(event, playerId, ...)
    return triggerClientCallback(nil, event, playerId, false, ...)
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
---Registers an event handler and callback function to respond to client requests.
function Callback.Register(name, cb)
    local event = cbEvent:format(name)

    validation.setValidCallback(name, true)

    RegisterNetEvent(event, function(resource, key, ...)
        TriggerClientEvent(cbEvent:format(resource), source, key, callbackResponse(pcall(cb, source, ...)))
    end)
end

-- Expose validation functions
Callback.setValidCallback = validation.setValidCallback
Callback.isCallbackValid = validation.isCallbackValid

return Callback
