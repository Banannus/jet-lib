local module = {}

local function getQBInventory()
    for resourceName, id in ipairs(Registry.dependencies.inventory) do
        if GetResourceState(resourceName) == 'started' then
            return exports[resourceName]
        end
    end
end

local inventory = getQBInventory()

function module.addItem(source, item, count, metadata, slot)
    inventory:AddItem(source, item, count, slot or false, metadata or false)
    TriggerClientEvent(inventory ..":client:ItemBox", source, QBCore.Shared.Items[item], "add", count)
    return 
end

function module.removeItem(source, item, count, metadata, slot)
    inventory:RemoveItem(source, item, count, slot or false, metadata or false)
    TriggerClientEvent(inventory ..":client:ItemBox", source, QBCore.Shared.Items[item], "remove", count)
    return
end

function module.hasItem(source, item)
    return inventory:GetItemCount(source, item) or 0
end

function module.canCarryItem(source, item, count, metadata)
    return inventory:CanAddItem(source, item, count)
end

return module