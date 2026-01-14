local Inventory = {}

function Inventory.AddItem(source, item, count, metadata, slot)
    return impl.AddItem(source, item, count, metadata, slot)
end

function Inventory.RemoveItem(source, item, count, metadata, slot)
    return impl.RemoveItem(source, item, count, metadata, slot)
end

function Inventory.HasItem(source, item)
    return impl.HasItem(source, item)
end

function Inventory.CanCarryItem(source, item, count, metadata)
    return impl.CanCarryItem(source, item, count, metadata)
end

return Inventory