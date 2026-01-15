local module = {}

function module.getPlayer(source)
    return Dep.object.GetPlayerFromId(source)
end

function module.getIdentifier(source)
    local player = Dep.object.GetPlayerFromId(source)
    return player and player.identifier or nil
end

function module.hasJob(source, filter)
    local filterType = type(filter)
    local player = Dep.object.GetPlayerFromId(source)

    if filterType == 'string' then
        if player.job.name == filter then
            return true
        end
    end

    if filterType == 'table' then
        for _, job in ipairs(filter) do
            if player.job.name == job then
                return true
            end
        end
    end
end

function module.hasGrade(source, jobName, gradeLevel)
    local player = Dep.object.GetPlayerFromId(source)
    if player.job.name ~= jobName then return false end
    if player.job.grade.level >= gradeLevel then return true end
    return false
end

function module.isBoss(source, jobName)
    local player = Dep.object.GetPlayerFromId(source)
    if player.job.name ~= jobName then return false end
    return player.job.grade_name == 'boss'
end

function module.getPlayerData(source)
    local player = Dep.object.GetPlayerFromId(source)
    if not player then return nil end

    return {
        source = source,
        identifier = player.identifier,
        character = {
            firstName = player.variables.firstName,
            lastName = player.variables.lastName,
            fullName = player.variables.firstName .. ' ' .. player.variables.lastName,
            gender = player.sex == 0 and 'male' or 'female'
        },
        job = {
            name = player.job.name,
            label = player.job.label,
            grade = player.job.grade.level,
            gradeLabel = player.job.grade_label,
            IsBoss = player.job.grade_name == 'boss'
        },
    }
end

return module