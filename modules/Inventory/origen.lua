local module = {}
local inventory = exports['origen-inventory']

function module.addItem(source, item, count, metadata, slot)
    return inventory:addItem(source, item, count, metadata, slot)
end

function module.removeItem(source, item, count, metadata, slot)
    return inventory:removeItem(source, item, count, metadata, slot)
end

function module.hasItem(source, item)
    return inventory:getItemCount(source, item, false, false) or 0 
end

function module.canCarryItem(source, item, count, metadata)
    return inventory:canCarryItem(source, item, count)
end

return module