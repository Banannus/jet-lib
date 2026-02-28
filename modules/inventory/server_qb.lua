local Object, Inventory = Jet.dep.inventory.object, {}

function Inventory.AddItem(source, item, count, metadata, slot)
    return Object:AddItem(source, item, count, slot, metadata)
end

function Inventory.RemoveItem(source, item, count, metadata, slot)
    return Object:RemoveItem(source, item, count, slot)
end

function Inventory.GetItemCount(source, item, metadata)
    return Object:GetItemCount(source, item)
end

function Inventory.CanCarryItem(source, item, count)
    return Object:CanAddItem(source, item, count)
end

function Inventory.GetInventory(source)
    return Object:GetInventory(source)
end

return Inventory