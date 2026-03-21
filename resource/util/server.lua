local function onPlayerLoaded(source)
    local playerData = Jet.Framework.GetPlayerData(source)
    TriggerClientEvent('jet:client:playerLoaded', source, playerData)
    TriggerEvent('jet:server:playerLoaded', source, playerData)
end

if Dep.framework.value == 'esx' then
    AddEventHandler('esx:playerLoaded', function(source)
        onPlayerLoaded(source)
    end)
elseif Dep.framework.value == 'qb' then
    AddEventHandler('QBCore:Server:OnPlayerLoaded', function()
        onPlayerLoaded(source)
    end)
end