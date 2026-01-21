local jetCache = _ENV.jetCache

if not jetCache.players then
    jetCache.players = {}
end

if not jetCache.jobs then
    jetCache.jobs = {}
end

_ENV.JobCache = {}
_ENV.LastJobs = {}

local function OnJobChange(src, newJob, oldJob)
    if oldJob then
        LastJobs[src] = oldJob.name
        if JobCache[oldJob.name] then
            for i = 1, #JobCache[oldJob.name] do
                if JobCache[oldJob.name][i].Source == src then
                    table.remove(JobCache[oldJob.name], i)
                    break
                end
            end
        end
        jetCache.jobs[oldJob.name] = JobCache[oldJob.name]
    end

    if not jetCache.players[src] then jetCache.players[src] = {} end

    if newJob then
        JobCache[newJob.name] = JobCache[newJob.name] or {}
        JobCache[newJob.name][#JobCache[newJob.name] + 1] = { Source = src, Grade = newJob.grade, JobData = newJob }
        jetCache.players[src].job = { name = newJob.name, grade = newJob.grade, label = newJob.label, data = newJob }
        jetCache.jobs[newJob.name] = JobCache[newJob.name]
    else
        jetCache.players[src].job = nil
    end

    TriggerEvent('jet-lib:server:onJobChange', src, newJob, oldJob)
    TriggerClientEvent('jet-lib:client:onJobChange', src, newJob, oldJob)
end

CreateThread(function()
    if Dep.framework == 'esx' then
        AddEventHandler('esx:setJob', function(source, job, lastJob) OnJobChange(source, job, lastJob) end)
        AddEventHandler('esx:playerLoaded', function (source, xPlayer, isNew) OnJobChange(source, xPlayer.job, nil) end)
    elseif Dep.framework == 'qb' or Config.Framework == 'qbx' then
        RegisterNetEvent('QBCore:Server:OnJobUpdate', function(src, job) OnJobChange(src, job, LastJobs[src]) end)
        RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function() local src = source local Player = Dep.object.Functions.GetPlayer(src) if Player then OnJobChange(src, Player.PlayerData.job, nil) end end)
    end

    AddEventHandler('playerDropped', function() 
        local src = source
        local playerJob = jetCache.players[src] and jetCache.players[src].job
        if playerJob then OnJobChange(src, nil, playerJob.data or { name = playerJob.name }) end
        jetCache.players[src] = nil
        LastJobs[src] = nil
    end)
end)