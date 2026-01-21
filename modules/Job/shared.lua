local Job = {}

---Check if a player has a specific job
---@param source number The source ID of the player
---@param filter string|table The job name or a list of job names to check against
---@return boolean hasJob Whether the player has the specified job
function Job.HasJob(source, filter)
    if Jet.context == 'server' then
        return impl.hasJob(source, filter)
    else
        return impl.hasJob(filter)
    end
end

---Get player's current job name
---@param source number The source ID of the player (server-side only)
---@return string|nil jobName The player's current job name or nil
function Job.GetPlayerJob(source)
    if Jet.context == 'server' then
        return impl.getPlayerJob(source)
    else
        return impl.getPlayerJob()
    end
end

---Run an action for all players with a specific job (server-side only)
---@param jobName string The job name to filter by
---@param action function The function to run for each player (receives player data table)
function Job.RunActionForJob(jobName, action)
    if Jet.context ~= 'server' then
        error('RunActionForJob can only be called on server-side')
        return
    end
    return impl.runActionForJob(jobName, action)
end

---Get count of online players with a specific job (server-side only)
---@param jobName string The job name to count
---@return number count The number of players with the specified job
function Job.GetJobCount(jobName)
    if Jet.context ~= 'server' then
        error('GetJobCount can only be called on server-side')
        return 0
    end
    return impl.getJobCount(jobName)
end

---Get all online players with a specific job (server-side only)
---@param jobName string The job name to filter by
---@return table players Array of player data tables with Source and Grade
function Job.GetJobPlayers(jobName)
    if Jet.context ~= 'server' then
        error('GetJobPlayers can only be called on server-side')
        return {}
    end
    return impl.getJobPlayers(jobName)
end

---Get the entire job cache (server-side only)
---@return table jobCache Table of all jobs with their online players
function Job.GetCache()
    if Jet.context ~= 'server' then
        error('GetCache can only be called on server-side')
        return {}
    end
    return impl.getCache()
end

---Get detailed job data for a player
---@param source number The source ID of the player (server-side only)
---@return table|nil jobData Detailed job information or nil
function Job.GetJobData(source)
    if Jet.context == 'server' then
        return impl.getJobData(source)
    else
        return impl.getJobData()
    end
end

return Job
