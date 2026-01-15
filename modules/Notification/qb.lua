local module = {}

function module.notify(title, description, duration, notifyType, icon, iconColor)
    return Dep.object.Functions.Notify(message, notifyType, duration)
end

return module