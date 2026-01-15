local MDT =  {}

function MDT.GetCallsign(source, callsignType)
    return impl.getCallsign(source, callsignType)
end

return MDT