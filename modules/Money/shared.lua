local Money = {}

function Money.AddMoney(source, type, amount)
    return impl.addMoney(source, type, amount)
end

return Money