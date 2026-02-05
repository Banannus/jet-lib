--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

local cache = _ENV.cache
cache.playerId = PlayerId()
cache.serverId = GetPlayerServerId(cache.playerId)

function cache:set(key, value)
	if value ~= self[key] then
		TriggerEvent(('jet-lib:cache:%s'):format(key), value, self[key])
		self[key] = value

		return true
	end
end

local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetPedInVehicleSeat = GetPedInVehicleSeat
local GetVehicleMaxNumberOfPassengers = GetVehicleMaxNumberOfPassengers
local GetCurrentPedWeapon = GetCurrentPedWeapon

CreateThread(function()
	while true do
		local ped = PlayerPedId()
		cache:set('ped', ped)

		local vehicle = GetVehiclePedIsIn(ped, false)

		if vehicle > 0 then
			if vehicle ~= cache.vehicle then
				cache:set('seat', false)
			end

			cache:set('vehicle', vehicle)

			if not cache.seat or GetPedInVehicleSeat(vehicle, cache.seat) ~= ped then
				for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
					if GetPedInVehicleSeat(vehicle, i) == ped then
						cache:set('seat', i)
						break
					end
				end
			end
		else
			cache:set('vehicle', false)
			cache:set('seat', false)
		end

		local hasWeapon, currentWeapon = GetCurrentPedWeapon(ped, true)

		cache:set('weapon', hasWeapon and currentWeapon or false)

		Wait(100)
	end
end)

function Jet.cache(key)
	return cache[key]
end

RegisterNetEvent('jet-lib:client:onJobChange', function(newJob, oldJob)
	if newJob then
		cache:set('job', {
			name = newJob.name,
			label = newJob.label,
			grade = newJob.grade,
			grade_name = newJob.grade_name or newJob.gradeLabel,
			grade_label = newJob.grade_label or newJob.gradeLabel,
			isBoss = newJob.isBoss or newJob.grade_name == 'boss'
		})
		cache:set('grade', newJob.grade)
	else
		cache:set('job', nil)
		cache:set('grade', nil)
	end
end)
