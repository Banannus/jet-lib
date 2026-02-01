local Framework, ESX = {}, Dep.framework.object

local function ConvertMoneyType(moneyType)
    if moneyType == 'cash' then return 'money' end
    return moneyType
end

function Framework.GetPlayerData(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    return {
        source = source,
        character = {
            firstName = xPlayer.variables.firstName,
            lastName = xPlayer.variables.lastName,
            fullName = xPlayer.variables.firstName .. ' ' .. xPlayer.variables.lastName,
            gender = xPlayer.sex == 0 and 'male' or 'female'
        },
        job = {
            name = xPlayer.job.name,
            label = xPlayer.job.label,
            grade = xPlayer.job.grade,
            gradeLabel = xPlayer.job.grade_label,
            isBoss = xPlayer.job.grade_name == 'boss'
        },
        identifier = xPlayer.identifier
    }
end

function Framework.AddMoney(source, moneyType, amount)
    moneyType = ConvertMoneyType(moneyType)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.addAccountMoney(moneyType, amount)
end

function Framework.RemoveMoney(source, moneyType, amount)
    moneyType = ConvertMoneyType(moneyType)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.removeAccountMoney(moneyType, amount)
end

function Framework.GetMoney(source, moneyType)
    moneyType = ConvertMoneyType(moneyType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local account = xPlayer.getAccount(moneyType)
    return account and account.money or 0
end

return Framework