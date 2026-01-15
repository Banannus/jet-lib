local module = {}

function module.addItem(source, item, count, metadata, slot)
    local player = Jet.Player.GetPlayer(source)
    return player.addInventoryItem(item, count, metadata, slot)
end

function module.removeItem(source, item, count, metadata, slot)
    local player = Jet.Player.GetPlayer(source)
    return player.removeInventoryItem(item, count, metadata or false, slot or false)
end

function module.hasItem(source, item)
    local player = Jet.Player.GetPlayer(source)
    local itemData = player.getInventoryItem(item)
    if itemData then return itemData.count or itemData.amount else return 0 end
end

function module.canCarryItem(source, item, count, metadata)
    local player = Jet.Player.GetPlayer(source)
    local cItem = player.getInventoryItem(item)
    if cItem then
        local newWeight = player.getWeight() + (cItem.weight * count)
        return newWeight <= player.getMaxWeight()
    end
    return false
end

return module