local module = {}

function module.addMoney(source, type, amount)
    local xPlayer = Dep.object.GetPlayerFromId(source)
    return xPlayer.addAccountMoney(type, amount)
end

return module