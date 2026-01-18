if Dep.framework == 'esx' then
    RegisterNetEvent('esx:playerLoaded', function()
        TriggerEvent('jet-lib:playerLoaded')
    end)
end

if Dep.framework == 'qb' then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        TriggerEvent('jet-lib:playerLoaded')
    end)
end

RegisterNetEvent('jet-lib:client:notify', function(title, description, duration, notifyType, icon, iconColor)
    Jet.Notification.Notify(title, description, duration, notifyType, icon, iconColor)
end)

