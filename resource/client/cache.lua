local jetCache = _ENV.jetCache

function jetCache:set(key, value)
	if value ~= self[key] then
		TriggerEvent(('jet-lib:jetCache:%s'):format(key), value, self[key])
		self[key] = value

		return true
	end
end

local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetPedInVehicleSeat = GetPedInVehicleSeat
local GetVehicleMaxNumberOfPassengers = GetVehicleMaxNumberOfPassengers
local GetMount = GetMount
local IsPedOnMount = IsPedOnMount
local GetCurrentPedWeapon = GetCurrentPedWeapon

CreateThread(function()
	while true do
		local ped = PlayerPedId()
		jetCache:set('ped', ped)

		-- If the player's ped is changed, the ped value may return 0 during the transition. If the value is 0, skip all checks.
		if ped ~= 0 then
			local vehicle = GetVehiclePedIsIn(ped, false)

			if vehicle > 0 then
				if vehicle ~= jetCache.vehicle then
					jetCache:set('seat', false)
				end

				jetCache:set('vehicle', vehicle)

				if not jetCache.seat or GetPedInVehicleSeat(vehicle, jetCache.seat) ~= ped then
					for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
						if GetPedInVehicleSeat(vehicle, i) == ped then
							jetCache:set('seat', i)
							break
						end
					end
				end
			else
				jetCache:set('vehicle', false)
				jetCache:set('seat', false)
			end

			local hasWeapon, currentWeapon = GetCurrentPedWeapon(ped, true)
			jetCache:set('weapon', (hasWeapon and currentWeapon ~= 0) and currentWeapon or false)
		end

	Wait(100)
    end
end)

RegisterNetEvent('jet-lib:client:onJobChange', function(newJob, oldJob)
	if newJob then
		jetCache:set('job', {
			name = newJob.name,
			label = newJob.label,
			grade = newJob.grade,
			grade_name = newJob.grade_name,
			grade_label = newJob.grade_label,
			data = newJob
		})
	else
		jetCache:set('job', false)
	end
end)
