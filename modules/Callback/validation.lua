--[[
    Jet-lib Callback System - Validation
    Based on ox_lib callback system
]]

local registeredCallbacks = {}
local resourceName = cache and cache.resource or GetCurrentResourceName()

AddEventHandler('onResourceStop', function(stoppedResourceName)
    if resourceName == stoppedResourceName then return end

    for callbackName, resource in pairs(registeredCallbacks) do
        if resource == stoppedResourceName then
            registeredCallbacks[callbackName] = nil
        end
    end
end)

---For internal use only.
---Sets a callback event as registered to a specific resource, preventing it from
---being overwritten. Any unknown callbacks will return an error to the caller.
---@param callbackName string
---@param isValid boolean
local function setValidCallback(callbackName, isValid)
    local invokingResourceName = GetInvokingResource() or resourceName
    local callbackResource = registeredCallbacks[callbackName]

    if callbackResource then
        if not isValid then
            registeredCallbacks[callbackName] = nil
            return
        end

        if callbackResource == invokingResourceName then return end

        local errMessage = ("^1resource '%s' attempted to overwrite callback '%s' owned by resource '%s'^0"):format(invokingResourceName, callbackName, callbackResource)

        return print(('^1SCRIPT ERROR: %s^0\n%s'):format(errMessage,
            Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString()) or ''))
    end

    registeredCallbacks[callbackName] = invokingResourceName
end

local function isCallbackValid(callbackName)
    return registeredCallbacks[callbackName] == GetInvokingResource() or resourceName
end

local cbEvent = '__jet_cb_%s'

RegisterNetEvent('jet:validateCallback', function(callbackName, invokingResource, key)
    if registeredCallbacks[callbackName] then return end

    local event = cbEvent:format(invokingResource)

    if IsDuplicityVersion() then
        return TriggerClientEvent(event, source, key, 'cb_invalid')
    end

    TriggerServerEvent(event, key, 'cb_invalid')
end)

return {
    setValidCallback = setValidCallback,
    isCallbackValid = isCallbackValid,
    registeredCallbacks = registeredCallbacks
}
