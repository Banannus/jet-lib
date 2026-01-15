local module = {}

function module.getCallsign(source, callsignType)
    local identifier = Jet.Player.GetIdentifier(source)
    if not identifier then return nil end
    return exports['tk_mdt']:getCallsign(identifier, callsignType) or ""
end

return module