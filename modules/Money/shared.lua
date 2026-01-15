local Money = {}

---Adds money to a player's account.
---@param source The player's source ID.
---@param type The type of money (e.g., 'cash', 'bank').
---@param amount The amount of money to add.
---@return boolean success Whether the money was added successfully.
function Money.AddMoney(source, type, amount)
    return impl.addMoney(source, type, amount)
end

---Removes money from a player's account.
---@param source The player's source ID.
---@param type The type of money (e.g., 'cash', 'bank').
---@param amount The amount of money to remove.
---@return boolean success Whether the money was removed successfully.
function Money.RemoveMoney(source, type, amount)
    return impl.removeMoney(source, type, amount)
end

---Retrieves the amount of money a player has in a specific account.
---@param source The player's source ID.
---@param type The type of money (e.g., 'cash', 'bank').
---@return number amount The amount of money the player has.
function Money.GetMoney(source, type)
    return impl.getMoney(source, type)
end

return Money


