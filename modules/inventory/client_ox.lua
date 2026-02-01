local Object, Inventory = Dep.inventory.object, {}

function Inventory.OpenInventory(invType, data)
    return Object:openInventory(invType, data)
end

function Inventory.CloseInventory()
    return Object:closeInventory()
end

function Inventory.GetItemCount(item, metadata)
    return Object:Search('count', item, metadata)
end

function Inventory.GetInventory()
    return Object:GetPlayerItems()
end

return Inventory