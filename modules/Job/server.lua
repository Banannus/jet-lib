local module = {}

function module.hasJob(source, filter)
    local playerJob = jetCache.players[source] and jetCache.players[source].job
    if not playerJob then return false end
    
    local filterType = type(filter)
    if filterType == 'string' then
        return playerJob.name == filter
    elseif filterType == 'table' then
        for i = 1, #filter do
            if filter[i] == playerJob.name then
                return true
            end
        end
    end
    
    return false
end

function module.getPlayerJob(source)
    local playerJob = jetCache.players[source] and jetCache.players[source].job
    return playerJob and playerJob.name or nil
end

function module.runActionForJob(jobName, action)
    if not jetCache.jobs[jobName] then return end
    for i = 1, #jetCache.jobs[jobName] do
        action(jetCache.jobs[jobName][i])
    end
end

function module.getJobCount(jobName)
    return jetCache.jobs[jobName] and #jetCache.jobs[jobName] or 0
end

function module.getJobPlayers(jobName)
    return jetCache.jobs[jobName] or {}
end

function module.getJobData(source)
    return jetCache.players[source] and jetCache.players[source].job or nil
end

return module