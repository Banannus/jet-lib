if Deb.framework == 'esx' then
    RegisterNetEvent('esx:playerLoaded', function()
        TriggerClientEvent('jet-lib:playerLoaded')
    end)
end

if Dep.framework == 'qb' then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        TriggerClientEvent('jet-lib:playerLoaded')
    end)
end

RegisterNetEvent('playerDropped', function()
    TriggerClientEvent('jet-lib:playerUnload')
end)

