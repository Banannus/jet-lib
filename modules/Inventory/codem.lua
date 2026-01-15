local module = {}
local inventory = exports['codem-inventory']

function module.addItem(source, item, count, metadata, slot)
    return inventory:AddItem(source, item, count, slot or false, metadata or false)
end

function module.removeItem(source, item, count, metadata, slot)
    return inventory:RemoveItem(source, item, count, slot or false)
end

function module.hasItem(source, item)
    return inventory:GetItemsTotalAmount(source, item)
end

function module.canCarryItem(source, item, count, metadata)
    return true
end

return module