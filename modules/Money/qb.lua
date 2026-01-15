local module = {}

local function convertMoneyType(moneyType)
    if moneyType == 'money' and Deb.framework == 'qb' then
        return 'cash'
    elseif moneyType == 'cash' and Deb.framework == 'esx' then
        return 'money'
    else
        return moneyType
    end
end

function module.addMoney(source, moneyType, amount)
    local player = Jet.Player.GetPlayer(source)
    return player.Functions.AddMoney(convertMoneyType(moneyType), amount)
end

function module.removeMoney(source, moneyType, amount)
    local player = Jet.Player.GetPlayer(source)
    return player.Functions.RemoveMoney(convertMoneyType(moneyType), amount)
end

function module.getMoney(source, moneyType)
    local player = Jet.Player.GetPlayer(source)
    return player.PlayerData.money[convertMoneyType(moneyType)] or 0
end

return module