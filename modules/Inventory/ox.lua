local module = {}
local inventory = exports['ox_inventory']

function module.addItem(source, item, count, metadata, slot)
    return inventory:AddItem(source, item, count, metadata, slot)
end

function module.removeItem(source, item, count, metadata, slot)
    return inventory:RemoveItem(source, item, count, metadata, slot)
end

function module.hasItem(source, item)
    return inventory:Search(source, 'count', item)
end

function module.canCarryItem(source, item, count, metadata)
    return inventory:CanCarryItem(source, item, count, metadata)
end

return module