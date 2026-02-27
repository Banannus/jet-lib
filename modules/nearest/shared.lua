--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

local Nearest = {}

---@param Coords vector3 The coords to check from.
---@param MaxDistance? number The max distance to check.
---@param IncludePlayerVehicle? boolean Whether or not to include the player's current vehicle. Ignored on the server.
---@return number? Vehicle
---@return vector3? VehicleCoords
function Nearest.Vehicle(Coords, MaxDistance, IncludePlayerVehicle)
	local Vehicles = GetGamePool('CVehicle')
	local ClosestVehicle, ClosestCoords
	MaxDistance = MaxDistance or 2.0

	for i = 1, #Vehicles do
		local Vehicle = Vehicles[i]

		if Jet.context == 'server' or not cache.vehicle or Vehicle ~= cache.vehicle or IncludePlayerVehicle then
			local VehicleCoords = GetEntityCoords(Vehicle)
			local distance = #(Coords - VehicleCoords)

			if distance < MaxDistance then
				MaxDistance = distance
				ClosestVehicle = Vehicle
				ClosestCoords = VehicleCoords
			end
		end
	end

	return ClosestVehicle, ClosestCoords
end

return Nearest