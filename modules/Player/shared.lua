local Player = {}

---Gets the player object for a given source
---@param source number The source ID of the player
---@return table player The player object
function Player.GetPlayer(source)
    return impl.getPlayer(source)
end

---Gets the identifier of a player for a given type
---@param source number The source ID of the player
---@return string|nil identifier The player's identifier or nil if not found
function Player.GetIdentifier(source)
    return impl.getIdentifier(source)
end

---Checks if a player has a specific job
---@param source number The source ID of the player
---@param filter string|table The job name or a list of job names to check against
---@return boolean hasJob Whether the player has the specified job
function Player.HasJob(source, filter)
    return impl.hasJob(source, filter)
end

---Checks if a player has a specific job grade
---@param source number The source ID of the player
---@param jobName string The job name to check
---@param gradeLevel number The minimum grade level required
---@return boolean hasGrade Whether the player meets the grade requirement
function Player.HasGrade(source, jobName, gradeLevel)
    return impl.hasGrade(source, jobName, gradeLevel)
end

---Checks if a player is a boss of a specific job
---@param source number The source ID of the player
---@param jobName string The job name to check
---@return boolean isBoss Whether the player is a boss
function Player.IsBoss(source, jobName)
    return impl.isBoss(source, jobName)
end

---Gets detailed player data
---@param source number The source ID of the player
---@return table|nil playerData A table containing player data or nil if not found
function Player.GetPlayerData(source)
    return impl.getPlayerData(source)
end

return Player