local module = {}

function module.getCallsign(source, callsignType)
    local player = Dep.object.GetPlayerData(source)
    if not player then return nil end
    return player.metadata['callsign'] or "OFFICER_" .. tostring(source)
end

return module