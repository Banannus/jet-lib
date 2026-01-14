local QB = {}

function QB.addMoney(source, type, amount)
    local qbPlayer = QBCore.Functions.GetPlayer(source)
    return qbPlayer.Functions.AddMoney(type, amount) 
end

return QB
