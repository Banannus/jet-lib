local Callback = {}

function Callback.Trigger(...)
    return impl.Trigger(...)
end

function Callback.Await(...)
    return impl.Await(...)
end

function Callback.Register(...)
    return impl.Register(...)
end

function Callback.setValidCallback(...)
    return impl.setValidCallback(...)
end

function Callback.isCallbackValid(...)
    return impl.isCallbackValid(...)
end

return Callback
