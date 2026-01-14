--[[
    Jet-lib Callback System (Client-side)
    Adapted from ox_lib callback system
]]

local Callback = {}
local pendingCallbacks = {}
local registeredCallbacks = {}
local timers = {}
local cbEvent = '__jet_cb_%s'
local callbackTimeout = GetConvarInt('jet:callbackTimeout', 30000)
local resourceName = GetCurrentResourceName()

-- Handle callback responses from server
RegisterNetEvent(cbEvent:format(resourceName), function(key, ...)
    local cb = pendingCallbacks[key]
    if not cb then return end
    
    pendingCallbacks[key] = nil
    cb(...)
end)

-- Validate callback exists
RegisterNetEvent('jet:validateCallback', function(event, resource, key)
    local callback = registeredCallbacks[event]
    if not callback then
        TriggerServerEvent(cbEvent:format(resource), key, 'cb_invalid')
    end
end)

-- Event timer for rate limiting
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

    local key = ('%s:%s'):format(event, math.random(0, 100000))
    
    -- Keep generating keys until we find a unique one
    while pendingCallbacks[key] do
        key = ('%s:%s'):format(event, math.random(0, 100000))
    end

    TriggerServerEvent('jet:validateCallback', event, resourceName, key)
    TriggerServerEvent(cbEvent:format(event), resourceName, key, ...)

    -- Handle async vs sync callbacks
    if not cb then
        -- Synchronous - use promise-like approach
        local finished = false
        local result = {}
        
        pendingCallbacks[key] = function(response, ...)
            if response == 'cb_invalid' then
                error(("callback '%s' does not exist on server"):format(event))
            end
            
            result = { response, ... }
            finished = true
        end

        -- Timeout handling
        local startTime = GetGameTimer()
        while not finished do
            if GetGameTimer() - startTime > callbackTimeout then
                pendingCallbacks[key] = nil
                error(("callback event '%s' timed out"):format(event))
            end
            Wait(0)
        end

        return table.unpack(result)
    else
        -- Asynchronous - use callback function
        pendingCallbacks[key] = function(response, ...)
            if response == 'cb_invalid' then
                print(("Callback '%s' does not exist on server"):format(event))
                return
            end
            
            cb(response, ...)
        end
        
        -- Clean up after timeout
        SetTimeout(callbackTimeout, function()
            if pendingCallbacks[key] then
                pendingCallbacks[key] = nil
                print(("Callback '%s' timed out"):format(event))
            end
        end)
    end
end

-- Main callback function (can be called directly)
---@param event string
---@param delay? number | false prevent the event from being called for the given time
---@param cb? function
---@param ... any
---@return ...
function Callback.Trigger(event, delay, cb, ...)
    if not cb then
        print(("callback event '%s' does not have a function to callback to and will instead await"):format(event))
    else
        local cbType = type(cb)
        if cbType == 'table' and getmetatable(cb) and getmetatable(cb).__call then
            cbType = 'function'
        end
        assert(cbType == 'function', ("expected callback to be a function (received %s)"):format(cbType))
    end

    return triggerServerCallback(nil, event, delay, cb, ...)
end

-- Await version (synchronous)
---@param event string
---@param delay? number | false prevent the event from being called for the given time
---@param ... any
---@return ...
function Callback.Await(event, delay, ...)
    return triggerServerCallback(nil, event, delay, false, ...)
end

-- Safe callback response handler
local function callbackResponse(success, result, ...)
    if not success then
        if result then
            print(('^1SCRIPT ERROR: %s^0'):format(result))
        end
        return false
    end
    return result, ...
end

-- Register a callback handler
---@param name string
---@param cb function
function Callback.Register(name, cb)
    assert(type(name) == 'string', 'Callback name must be a string')
    assert(type(cb) == 'function', 'Callback handler must be a function')
    
    local event = cbEvent:format(name)
    registeredCallbacks[name] = true
    
    RegisterNetEvent(event, function(resource, key, ...)
        local response = { callbackResponse(pcall(cb, ...)) }
        TriggerServerEvent(cbEvent:format(resource), key, table.unpack(response))
    end)
end

return Callback
