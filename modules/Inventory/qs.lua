local module = {}
local inventory = exports['qs-inventory']

function module.addItem(source, item, count, metadata, slot)
    return inventory:AddItem(source, item, count, slot or false, metadata or false)
end

function module.removeItem(source, item, count, metadata, slot)
    return inventory:RemoveItem(source, item, count, slot or false, metadata or false)
end

function module.hasItem(source, item)
    return inventory:GetItemTotalAmount(source, item) or 0
end

function module.canCarryItem(source, item, count, metadata)
    return inventory:CanCarryItem(source, item, count)
end

function module.getInventory(source)
    return inventory:GetInventory(source)
end

return module