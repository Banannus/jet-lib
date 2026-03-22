local JobCache, LastJobs, PlayerJobs = {}, {}, {}

local function OnJobChange(src, newJob, oldJob)
    if oldJob then
        LastJobs[src] = oldJob.name
        JobCache[oldJob.name] = JobCache[oldJob.name] or {}
        for i = 1, #JobCache[oldJob.name] do
            if JobCache[oldJob.name][i].Source == src then
                table.remove(JobCache[oldJob.name], i)
                break
            end
        end
    end

    if newJob then
        PlayerJobs[src] = newJob.name
        JobCache[newJob.name] = JobCache[newJob.name] or {}
        JobCache[newJob.name][#JobCache[newJob.name] + 1] = { Source = src, Grade = newJob.grade }
    end

    TriggerEvent('jet-lib:server:onJobChange', src, newJob, oldJob)
    TriggerClientEvent('jet-lib:client:onJobChange', src, newJob, oldJob)
end

CreateThread(function()
    if Dep.framework.value == 'esx' then
        AddEventHandler('esx:setJob', function(source, job, lastJob) OnJobChange(source, job, lastJob) end)
        AddEventHandler('esx:playerLoaded', function (source, xPlayer, isNew) OnJobChange(source, xPlayer.job, nil) end)
    elseif Dep.framework.value == 'qb' or Dep.framework.value == 'qbx' then
        RegisterNetEvent('QBCore:Server:OnJobUpdate', function(src, job) OnJobChange(src, job, LastJobs[src]) end)
        RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function() local src = source local Player = Dep.framework.object.Functions.GetPlayer(src) if Player then OnJobChange(src, Player.PlayerData.job, nil) end end)
    end

    AddEventHandler('playerDropped', function() OnJobChange(source, nil, PlayerJobs[source] and { name = PlayerJobs[source] } or nil) end)

    local Players = GetPlayers()
    for i = 1, #Players do
        local source = tonumber(Players[i])
        local playerData = Jet.Framework.GetPlayerData(source)
        if playerData then OnJobChange(source, playerData.job, nil) end
    end
end)

---@param job string
---@param action fun(playerData: table)
function Jet.RunActionForJob(job, action)
    if not JobCache[job] then return end
    for i = 1, #JobCache[job] do
        action(JobCache[job][i])
    end
end

---@param job string
---@return number
function Jet.GetJobCount(job)
    return JobCache[job] and #JobCache[job] or 0
end