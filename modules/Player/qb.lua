local module = {}

function module.getPlayer(source)
    return Deb.object.Functions.GetPlayer(source)
end

function module.getIdentifier(source)
    local player = module.getPlayer(source)
    return player and player.PlayerData.citizenid or nil
end

function module.hasJob(source, filter)
    local filterType = type(filter)
    local player = module.getPlayer(source)

    if filterType == 'string' then
        for _, jobTypes in pairs({ 'job', 'gang'}) do
            if player.PlayerData[jobTypes] and player.PlayerData[jobTypes].name == filter then
                return true
            end
        end
    end

    if filterType == 'table' then
        for _, job in ipairs(filter) do
            for _, jobTypes in pairs({ 'job', 'gang'}) do
                if player.PlayerData[jobTypes] and player.PlayerData[jobTypes].name == job then
                    return true
                end
            end
        end
    end
    return false
end

function module.hasGrade(source, jobName, gradeLevel)
    local player = module.getPlayer(source)
    if player.PlayerData.job ~= jobName then return false end
    if player.PlayerData.job.grade.level >= gradeLevel then return true end
    return false
end

function module.isBoss(source, jobName)
    local player = module.getPlayer(source)
    if player.PlayerData.job.isboss then return true end
    if player.PlayerData.gang.isboss then return true end
    return false
end

function module.getPlayerData(source)
    local player = module.getPlayer(source).PlayerData
    if not player then return nil end

    return {
        source = source,
        identifier = player.PlayerData.citizenid,
        character = {
            firstName = player.charinfo.firstname,
            lastName = player.charinfo.lastname,
            fullName = player.charinfo.firstname .. ' ' .. player.charinfo.lastname,
            gender = player.charinfo.gender == 0 and 'male' or 'female'
        },
        job =  {
            name = player.job.name,
            label = player.job.label,
            grade = player.job.grade.level,
            gradeLabel = player.job.grade.name,
            isBoss = player.job.isboss
        },
        gang = {
            name = player.gang.name,
            label = player.gang.label,
            grade = player.gang.grade.level,
            gradeLabel = player.gang.grade.name,
            isBoss = player.gang.isboss
        }
    }
end

return module

