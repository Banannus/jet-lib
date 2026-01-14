--[[
    Jet-lib Callback System (Server-side)
    Adapted from ox_lib callback system
]]

local Callback = {}
local pendingCallbacks = {}
local registeredCallbacks = {}
local cbEvent = '__jet_cb_%s'
local callbackTimeout = GetConvarInt('jet:callbackTimeout', 30000)
local resourceName = GetCurrentResourceName()

-- Handle callback responses from clients
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
        TriggerClientEvent(cbEvent:format(resource), source, key, 'cb_invalid')
    end
end)

---@param _ any
---@param event string
---@param playerId number
---@param cb function|false
---@param ... any
---@return ...
local function triggerClientCallback(_, event, playerId, cb, ...)
    if not DoesPlayerExist(playerId --[[@as string]]) then
        error(("target playerId '%s' does not exist"):format(playerId))
    end

    local key = ('%s:%s:%s'):format(event, math.random(0, 100000), playerId)
    
    -- Keep generating keys until we find a unique one
    while pendingCallbacks[key] do
        key = ('%s:%s:%s'):format(event, math.random(0, 100000), playerId)
    end

    TriggerClientEvent('jet:validateCallback', playerId, event, resourceName, key)
    TriggerClientEvent(cbEvent:format(event), playerId, resourceName, key, ...)

    -- Handle async vs sync callbacks
    if not cb then
        -- Synchronous - use promise-like approach
        local finished = false
        local result = {}
        
        pendingCallbacks[key] = function(response, ...)
            if response == 'cb_invalid' then
                error(("callback '%s' does not exist on client"):format(event))
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
                print(("Callback '%s' does not exist on client"):format(event))
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
---@param playerId number  
---@param cb? function
---@param ... any
---@return ...
function Callback.Trigger(event, playerId, cb, ...)
    if cb then
        local cbType = type(cb)
        if cbType == 'table' and getmetatable(cb) and getmetatable(cb).__call then
            cbType = 'function'
        end
        assert(cbType == 'function', ("expected callback to be a function (received %s)"):format(cbType))
    end

    return triggerClientCallback(nil, event, playerId, cb, ...)
end

-- Await version (synchronous)
---@param event string
---@param playerId number
---@param ... any
---@return ...
function Callback.Await(event, playerId, ...)
    return triggerClientCallback(nil, event, playerId, false, ...)
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
        local response = { callbackResponse(pcall(cb, source, ...)) }
        TriggerClientEvent(cbEvent:format(resource), source, key, table.unpack(response))
    end)
end

return Callback
