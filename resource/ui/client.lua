function Jet.Notify(data)
    if Config.Overwrite.notify == "ox" then
        return exports.ox_lib:notify(data)
    elseif Config.Overwrite.notify == "qb" then
        return exports['qb-core']:Notify(data)
    else
        print("Notification: " .. data.title .. " - " .. data.description)
    end
end

function Jet.ProgressBar(data)
    if Config.Overwrite.notify == "ox" then
        return exports.ox_lib:progressBar(data)
    elseif Config.Overwrite.notify == "qb" then
        return exports['qb-core']:Progressbar(data)
    else
        print("ProgressBar: " .. data.label .. " - " .. data.duration .. "ms")
    end
end

function Jet.ShowTextUI(data)
    -- data = { text = string, icon = string, alignIcon = string, keybind = { key = string, color = string } }
    SendNUIMessage({
        action = 'setVisibleText',
        data = {
            text = data.text or '',
            icon = data.icon,
            alignIcon = data.alignIcon,
            position = data.position or 'middle-right',
            color = data.color or '#2A2A2A',
            style = data.style or {},
            keybind = data.keybind
        }
    })
end

function Jet.HideTextUI()
    SendNUIMessage({
        action = 'setVisibleText',
        data = false
    })
end