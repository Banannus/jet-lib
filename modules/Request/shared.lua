local Request = {}

function Request.Model(model, timeout)
    return impl.model(model, timeout)
end

function Request.AnimDict(animDict, timeout)
    return impl.animDict(animDict, timeout)
end

function Request.NamedPtfxAsset(ptFxName, timeout)
    return impl.namedPtfxAsset(ptFxName, timeout)
end

return Request