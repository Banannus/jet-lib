local module = {}

function module.notify(title, description, duration, notifyType, icon, iconColor)
    return Dep.object.ShowNotification(description, notifyType, duration, title)
end

return module