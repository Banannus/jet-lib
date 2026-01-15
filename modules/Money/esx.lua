local module = {}

local function convertMoneyType(moneyType)
    if moneyType == 'money' and Dep.framework == 'qb' then
        return 'cash'
    elseif moneyType == 'cash' and Dep.framework == 'esx' then
        return 'money'
    else
        return moneyType
    end
end

function module.addMoney(source, moneyType, amount)
    local player = Jet.Player.GetPlayer(source)
    return player.addAccountMoney(convertMoneyType(moneyType), amount)
end

function module.removeMoney(source, moneyType, amount)
    local player = Jet.Player.GetPlayer(source)
    return player.removeAccountMoney(convertMoneyType(moneyType), amount)
end

function module.getMoney(source, moneyType)
    local player = Jet.Player.GetPlayer(source)
    local account = player.getAccount(convertMoneyType(moneyType))
    return account and account.money or 0
end

return module