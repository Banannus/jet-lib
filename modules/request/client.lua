--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

local Request = {}

---@async
---@generic T : string | number
---@param request function
---@param hasLoaded function
---@param assetType string
---@param asset T
---@param timeout? number
local function StreamingRequest(request, hasLoaded, assetType, asset, timeout)
    if hasLoaded(asset) then return asset end

    request(asset)

    return Jet.WaitFor(function()
        if hasLoaded(asset) then return asset end
    end, ("failed to load %s '%s' - this may be caused by\n- too many loaded assets\n- oversized, invalid, or corrupted assets"):format(assetType, asset), timeout or 30000)
end

---@param model number | string
---@param timeout number? Approximate milliseconds to wait for the model to load. Default is 10000.
---@return number model
function Request.Model(model, timeout)
    if type(model) ~= 'number' then model = joaat(model) end
    if HasModelLoaded(model) then return model end

    if not IsModelValid(model) and not IsModelInCdimage(model) then
        error(("attempted to load invalid model '%s'"):format(model))
    end

    return StreamingRequest(RequestModel, HasModelLoaded, 'model', model, timeout)
end

---@param animDict string
---@param timeout number? Approximate milliseconds to wait for the dictionary to load. Default is 10000.
function Request.AnimDict(animDict, timeout)
    if HasAnimDictLoaded(animDict) then return animDict end

    if type(animDict) ~= 'string' then
        error(("expected animDict to have type 'string' (received %s)"):format(type(animDict)))
    end

    if not DoesAnimDictExist(animDict) then
        error(("attempted to load invalid animDict '%s'"):format(animDict))
    end

    return StreamingRequest(RequestAnimDict, HasAnimDictLoaded, 'animDict', animDict, timeout)
end

---@param ptFxName string
---@param timeout number? Approximate milliseconds to wait for the particle effect to load. Default is 10000.
---@return string ptFxName
function Request.NamedPtfxAsset(ptFxName, timeout)
    if HasNamedPtfxAssetLoaded(ptFxName) then return ptFxName end

    if type(ptFxName) ~= 'string' then
        error(("expected ptFxName to have type 'string' (received %s)"):format(type(ptFxName)))
    end

    return StreamingRequest(RequestNamedPtfxAsset, HasNamedPtfxAssetLoaded, 'ptFxName', ptFxName, timeout)
end

return Request