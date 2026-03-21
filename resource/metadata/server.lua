local identifiers, metadata, updated = {}, {}, {}

CreateThread(function()
    local querySuccess, data = pcall(function() return MySQL.query.await('SELECT * FROM `jet_metadata`') end)
    if not querySuccess then
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS `jet_metadata` (
                `identifier` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
                `metadata` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
                PRIMARY KEY (`identifier`) USING BTREE,
                UNIQUE INDEX `identifier` (`identifier`) USING BTREE
            )
            COLLATE='utf8mb4_general_ci'
            ENGINE=InnoDB;
        ]])

        data = {}
    end

    for i = 1, #data do
        metadata[data[i].identifier] = json.decode(data[i].metadata)
    end

    local Players = GetPlayers()
    for i = 1, #Players do
        local source = tonumber(Players[i])
        local playerData = Jet.Framework.GetPlayerData(source)
        if playerData then
            identifiers[source] = playerData.identifier
        end
    end
end)

---@param source number
---@param key string
---@param value any
function Jet.SetMetaData(source, key, value)
    local identifier = identifiers[source]
    if not identifier then return end

    metadata[identifier] = metadata[identifier] or {}
    if metadata[identifier][key] == value then return end

    metadata[identifier][key] = value
    updated[identifier] = true
end

---@param source number
---@param key string
---@param amount number
function Jet.AddMetaData(source, key, amount)
    local identifier = identifiers[source]
    if not identifier then return end

    metadata[identifier] = metadata[identifier] or {}
    metadata[identifier][key] = (metadata[identifier][key] or 0) + amount
    updated[identifier] = true
end

---@param source number
---@param key string
---@param default any
---@return any
function Jet.GetMetaData(source, key, default)
    local identifier = identifiers[source]
    if not identifier then return default end

    if not metadata[identifier] or metadata[identifier][key] == nil then return default end
    return metadata[identifier][key]
end

AddEventHandler('jet:server:playerLoaded', function(source, playerData) identifiers[source] = playerData.identifier end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local identifier = identifiers[source]
    if not identifier then return end

    Wait(250) -- Wait for any potential pending metadata updates to complete

    if updated[identifier] then
        local encoded = json.encode(metadata[identifier] or {})
        MySQL.update([[
            INSERT INTO `jet_metadata` (`identifier`, `metadata`)
            VALUES (?, ?)
            ON DUPLICATE KEY UPDATE `metadata` = VALUES(`metadata`)
        ]], { identifier, encoded })
        updated[identifier] = nil
    end

    identifiers[source] = nil
end)