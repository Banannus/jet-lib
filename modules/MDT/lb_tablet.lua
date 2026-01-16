local module = {}

function module.getCallsign(source, callsignType)
    local identifier = Jet.Player.GetIdentifier(source)
    if not identifier then return nil end
    return exports['lb-tablet']:GetPoliceCallSign(identifier) or "OFFICER_" .. tostring(source)
end

return module