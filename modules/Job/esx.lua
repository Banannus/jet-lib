local jobCache, lastJobs, playerJobs = {}, {}, {}
local module = {}

local function onJobChange(src, newJob, oldJob)
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

    TriggerEvent('mani-bridge:server:onJobChange', src, newJob, oldJob)
    TriggerClientEvent('mani-bridge:client:onJobChange', src, newJob, oldJob)
end

CreateThread(function()
    AddEventHandler('esx:setJob', function(source, job, lastJob) onJobChange(source, job, lastJob) end)
    AddEventHandler('playerDropped', function() onJobChange(source, nil, playerJobs[source] and { name = playerJobs[source] } or nil) end)
end)

function module.runActionForJob(job, action)
    if not JobCache[job] then return end
    for i = 1, #JobCache[job] do
        action(JobCache[job][i])
    end
end

function module.getJobCount(job)
    return jobCache[job] and #jobCache[job] or 0
end