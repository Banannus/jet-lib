--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

local Util = {}

---@generic T
---@param cb fun(): T?
---@param errMessage string?
---@param timeout? number | false Error out after `~x` ms. Defaults to 1000, unless set to `false`.
---@return T
---@async
function Util.WaitFor(cb, errMessage, timeout)
    local value = cb()

    if value ~= nil then return value end

    if timeout or timeout == nil then
        if type(timeout) ~= 'number' then timeout = 1000 end
    end

    local start = timeout and GetGameTimer()

    while value == nil do
        Wait(0)

        local elapsed = timeout and GetGameTimer() - start

        if elapsed and elapsed > timeout then
            return error(('%s (waited %.1fms)'):format(errMessage or 'failed to resolve callback', elapsed), 2)
        end

        value = cb()
    end

    return value
end

function Util.GenerateRandomPlate(checkIfExists, seed)
    seed = seed or "1AA111AA"

    local CHARSET_NUMBERS, CHARSET_LETTERS = "0123456789", "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local attempts = 0

    while attempts < 20 do
        local i, plate = 0, ""

        while i <= seed:len() do
            local char = seed:sub(i, i)

            if char == "A" then
                local randLetterPos = math.random(1, #CHARSET_LETTERS)
                local randLetter = CHARSET_LETTERS:sub(randLetterPos, randLetterPos)
                plate = plate .. randLetter
            elseif char == "1" then
                local randNumberPos = math.random(1, #CHARSET_NUMBERS)
                local randNumber = CHARSET_NUMBERS:sub(randNumberPos, randNumberPos)
                plate = plate .. randNumber
            elseif char == "^" then
                i = i + 1
                if i <= seed:len() then plate = plate .. seed:sub(i, i) end
            else
                plate = plate .. char
            end

            i = i + 1
        end

        plate = plate:upper()

        if plate:len() > 8 then
            error("^1[ERROR] You are generating a plate with more than 8 characters.")
            return false
        end

        if not checkIfExists then return plate end

        local vehiclesTable = nil
        if Dep.framework == 'esx' then
            vehiclesTable = 'owned_vehicles'
        else
            vehiclesTable = 'player_vehicles'
        end

        local result = MySQL.scalar.await(
            "SELECT plate FROM " .. vehiclesTable .. " WHERE plate = ?", {
                plate,
            })
        if not result then return plate end

        attempts = attempts + 1
    end

    return false
end

return Util