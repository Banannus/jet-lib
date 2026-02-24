local Object, Inventory = Dep.inventory.object, {}

function Inventory.AddItem(source, item, count, metadata, slot)
    return Object:AddItem(source, item, count, metadata, slot)
end

function Inventory.RemoveItem(source, item, count, metadata, slot)
    return Object:RemoveItem(source, item, count, metadata, slot)
end

function Inventory.GetItemCount(source, item, metadata)
    return Object:Search(source, 'count', item, metadata)
end

function Inventory.CanCarryItem(source, item, count)
    return Object:CanCarryItem(source, item, count)
end

function Inventory.GetInventory(source)
    return Object:GetInventory(source)
end

return Inventory