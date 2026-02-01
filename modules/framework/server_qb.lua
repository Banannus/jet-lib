local Framework, QBCore = {}, Dep.framework.object

local function ConvertMoneyType(moneyType)
    if moneyType == 'money' then return 'cash' end
    return moneyType
end

function Framework.GetPlayerData(source)
    local Player = QBCore.Functions.GetPlayer(source).PlayerData
    if not Player then return false end

    return {
        source = source,
        character = {
            firstname = Player.charinfo.firstname,
            lastname = Player.charinfo.lastname,
            fullname = Player.charinfo.firstname .. ' ' .. Player.charinfo.lastname,
            gender = Player.charinfo.gender == 0 and 'male' or 'female',
        },
        job = {
            name = Player.job.name,
            label = Player.job.label,
            grade = Player.job.grade.level,
            gradeLabel = Player.job.grade.name,
            isBoss = Player.job.isboss
        },
        identifier = Player.citizenid
    }
end

function Framework.AddMoney(source, moneyType, amount)
    moneyType = ConvertMoneyType(moneyType)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.Functions.AddMoney(moneyType, amount)
end

function Framework.RemoveMoney(source, moneyType, amount)
    moneyType = ConvertMoneyType(moneyType)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.Functions.RemoveMoney(moneyType, amount)
end

function Framework.GetMoney(source, moneyType)
    moneyType = ConvertMoneyType(moneyType)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.PlayerData.money[moneyType] or 0
end

return Framework