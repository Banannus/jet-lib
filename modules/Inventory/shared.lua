local Inventory = {}

---Adds an item to the player's inventory
---@param source number The player server ID
---@param item string The item name
---@param count number The item count to add
---@param metadata? table Optional item metadata
---@param slot? number Optional specific slot number
---@return boolean success Whether the item was added successfully
function Inventory.AddItem(source, item, count, metadata, slot)
    return impl.addItem(source, item, count, metadata, slot)
end

---Removes an item from the player's inventory  
---@param source number The player server ID
---@param item string The item name
---@param count number The item count to remove
---@param metadata? table Optional item metadata
---@param slot? number Optional specific slot number
---@return boolean success Whether the item was removed successfully
function Inventory.RemoveItem(source, item, count, metadata, slot)
    return impl.removeItem(source, item, count, metadata, slot)
end

---Checks if the player has a specific item
---@param source number The player server ID
---@param item string The item name to check
---@return number itemCount The amount of items found
function Inventory.HasItem(source, item)
    return impl.hasItem(source, item)
end

---Checks if the player can carry a specific item
---@param source number The player server ID
---@param item string The item name
---@param count number The item count to check
---@param metadata? table Optional item metadata
---@return boolean canCarry Whether the player can carry the item
function Inventory.CanCarryItem(source, item, count, metadata)
    return impl.canCarryItem(source, item, count, metadata)
end

---Retrieves the player's entire inventory
---@param source number The player server ID
---@return table inventory The player's inventory items
function Inventory.GetInventory(source)
    return impl.getInventory(source)
end

return Inventory