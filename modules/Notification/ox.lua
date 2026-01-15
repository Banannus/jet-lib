local module = {}

function module.notify(title, description, duration, notifyType, icon, iconColor)
    return lib.notify({
        title = title,
        description = description,
        type = notifyType,
        duration = duration,
        icon = icon,
        iconColor = iconColor or 'blue',
    })
end

return module