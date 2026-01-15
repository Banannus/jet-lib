--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

local Vehicle = {}

---@class VehicleProperties
---@field model? number
---@field plate? string
---@field plateIndex? number
---@field bodyHealth? number
---@field engineHealth? number
---@field tankHealth? number
---@field fuelLevel? number
---@field oilLevel? number
---@field dirtLevel? number
---@field paintType1? number
---@field paintType2? number
---@field color1? number | number[]
---@field color2? number | number[]
---@field pearlescentColor? number
---@field interiorColor? number
---@field dashboardColor? number
---@field wheelColor? number
---@field wheelWidth? number
---@field wheelSize? number
---@field wheels? number
---@field windowTint? number
---@field xenonColor? number
---@field neonEnabled? boolean[]
---@field neonColor? number | number[]
---@field extras? table<number | string, 0 | 1>
---@field tyreSmokeColor? number | number[]
---@field modSpoilers? number
---@field modFrontBumper? number
---@field modRearBumper? number
---@field modSideSkirt? number
---@field modExhaust? number
---@field modFrame? number
---@field modGrille? number
---@field modHood? number
---@field modFender? number
---@field modRightFender? number
---@field modRoof? number
---@field modEngine? number
---@field modBrakes? number
---@field modTransmission? number
---@field modHorns? number
---@field modSuspension? number
---@field modArmor? number
---@field modNitrous? number
---@field modTurbo? boolean
---@field modSubwoofer? boolean
---@field modSmokeEnabled? boolean
---@field modHydraulics? boolean
---@field modXenon? boolean
---@field modFrontWheels? number
---@field modBackWheels? number
---@field modCustomTiresF? boolean
---@field modCustomTiresR? boolean
---@field modPlateHolder? number
---@field modVanityPlate? number
---@field modTrimA? number
---@field modOrnaments? number
---@field modDashboard? number
---@field modDial? number
---@field modDoorSpeaker? number
---@field modSeats? number
---@field modSteeringWheel? number
---@field modShifterLeavers? number
---@field modAPlate? number
---@field modSpeakers? number
---@field modTrunk? number
---@field modHydrolic? number
---@field modEngineBlock? number
---@field modAirFilter? number
---@field modStruts? number
---@field modArchCover? number
---@field modAerials? number
---@field modTrimB? number
---@field modTank? number
---@field modWindows? number
---@field modDoorR? number
---@field modLivery? number
---@field modRoofLivery? number
---@field modLightbar? number
---@field livery? number
---@field windows? number[]
---@field doors? number[]
---@field tyres? table<number | string, 1 | 2>
---@field bulletProofTyres? boolean
---@field driftTyres? boolean
---@field convertibleDown? boolean

---@param Vehicle number
---@param Props VehicleProperties
---@param FixVehicle? boolean Fix the Vehicle after Props have been set. Usually required when adding extras.
---@return boolean isEntityOwner True if the entity is networked and the client is the current entity owner.
function Vehicle.SetProperties(Vehicle, Props, FixVehicle)
    if not DoesEntityExist(Vehicle) then
        error(("Unable to set Vehicle properties for '%s' (entity does not exist)"):format(Vehicle))
    end

    local colorPrimary, colorSecondary = GetVehicleColours(Vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(Vehicle)

    SetVehicleModKit(Vehicle, 0)

    if Props.extras then
        for id, disable in pairs(Props.extras) do
            SetVehicleExtra(Vehicle, tonumber(id) --[[@as number]], disable == 1)
        end
    end

    if Props.plate then
        SetVehicleNumberPlateText(Vehicle, Props.plate)
    end

    if Props.plateIndex then
        SetVehicleNumberPlateTextIndex(Vehicle, Props.plateIndex)
    end

    if Props.bodyHealth then
        SetVehicleBodyHealth(Vehicle, Props.bodyHealth + 0.0)
    end

    if Props.engineHealth then
        SetVehicleEngineHealth(Vehicle, Props.engineHealth + 0.0)
    end

    if Props.tankHealth then
        SetVehiclePetrolTankHealth(Vehicle, Props.tankHealth + 0.0)
    end

    if Props.fuelLevel then
        SetVehicleFuelLevel(Vehicle, Props.fuelLevel + 0.0)
    end

    if Props.oilLevel then
        SetVehicleOilLevel(Vehicle, Props.oilLevel + 0.0)
    end

    if Props.dirtLevel then
        SetVehicleDirtLevel(Vehicle, Props.dirtLevel + 0.0)
    end

    if Props.color1 then
        if type(Props.color1) == 'number' then
            ClearVehicleCustomPrimaryColour(Vehicle)
            SetVehicleColours(Vehicle, Props.color1 --[[@as number]], colorSecondary --[[@as number]])
        else
            if Props.paintType1 then SetVehicleModColor_1(Vehicle, Props.paintType1, 0, Props.pearlescentColor or 0) end

            SetVehicleCustomPrimaryColour(Vehicle, Props.color1[1], Props.color1[2], Props.color1[3])
        end
    end

    if Props.color2 then
        if type(Props.color2) == 'number' then
            ClearVehicleCustomSecondaryColour(Vehicle)
            SetVehicleColours(Vehicle, Props.color1 or colorPrimary --[[@as number]], Props.color2 --[[@as number]])
        else
            if Props.paintType2 then SetVehicleModColor_2(Vehicle, Props.paintType2, 0) end

            SetVehicleCustomSecondaryColour(Vehicle, Props.color2[1], Props.color2[2], Props.color2[3])
        end
    end

    if Props.pearlescentColor or Props.wheelColor then
        SetVehicleExtraColours(Vehicle, Props.pearlescentColor or pearlescentColor, Props.wheelColor or wheelColor)
    end

    if Props.interiorColor then
        SetVehicleInteriorColor(Vehicle, Props.interiorColor)
    end

    if Props.dashboardColor then
        SetVehicleDashboardColor(Vehicle, Props.dashboardColor)
    end

    if Props.wheels then
        SetVehicleWheelType(Vehicle, Props.wheels)
    end

    if Props.wheelSize then
        SetVehicleWheelSize(Vehicle, Props.wheelSize)
    end

    if Props.wheelWidth then
        SetVehicleWheelWidth(Vehicle, Props.wheelWidth)
    end

    if Props.windowTint then
        SetVehicleWindowTint(Vehicle, Props.windowTint)
    end

    if Props.neonEnabled then
        for i = 1, #Props.neonEnabled do
            SetVehicleNeonLightEnabled(Vehicle, i - 1, Props.neonEnabled[i])
        end
    end

    if Props.windows then
        for i = 1, #Props.windows do
            RemoveVehicleWindow(Vehicle, Props.windows[i])
        end
    end

    if Props.doors then
        for i = 1, #Props.doors do
            SetVehicleDoorBroken(Vehicle, Props.doors[i], true)
        end
    end

    if Props.tyres then
        for tyre, state in pairs(Props.tyres) do
            SetVehicleTyreBurst(Vehicle, tonumber(tyre) --[[@as number]], state == 2, 1000.0)
        end
    end

    if Props.neonColor then
        SetVehicleNeonLightsColour(Vehicle, Props.neonColor[1], Props.neonColor[2], Props.neonColor[3])
    end

    if Props.modSmokeEnabled ~= nil then
        ToggleVehicleMod(Vehicle, 20, Props.modSmokeEnabled)
    end

    if Props.tyreSmokeColor then
        SetVehicleTyreSmokeColor(Vehicle, Props.tyreSmokeColor[1], Props.tyreSmokeColor[2], Props.tyreSmokeColor[3])
    end

    if Props.modSpoilers then
        SetVehicleMod(Vehicle, 0, Props.modSpoilers, false)
    end

    if Props.modFrontBumper then
        SetVehicleMod(Vehicle, 1, Props.modFrontBumper, false)
    end

    if Props.modRearBumper then
        SetVehicleMod(Vehicle, 2, Props.modRearBumper, false)
    end

    if Props.modSideSkirt then
        SetVehicleMod(Vehicle, 3, Props.modSideSkirt, false)
    end

    if Props.modExhaust then
        SetVehicleMod(Vehicle, 4, Props.modExhaust, false)
    end

    if Props.modFrame then
        SetVehicleMod(Vehicle, 5, Props.modFrame, false)
    end

    if Props.modGrille then
        SetVehicleMod(Vehicle, 6, Props.modGrille, false)
    end

    if Props.modHood then
        SetVehicleMod(Vehicle, 7, Props.modHood, false)
    end

    if Props.modFender then
        SetVehicleMod(Vehicle, 8, Props.modFender, false)
    end

    if Props.modRightFender then
        SetVehicleMod(Vehicle, 9, Props.modRightFender, false)
    end

    if Props.modRoof then
        SetVehicleMod(Vehicle, 10, Props.modRoof, false)
    end

    if Props.modEngine then
        SetVehicleMod(Vehicle, 11, Props.modEngine, false)
    end

    if Props.modBrakes then
        SetVehicleMod(Vehicle, 12, Props.modBrakes, false)
    end

    if Props.modTransmission then
        SetVehicleMod(Vehicle, 13, Props.modTransmission, false)
    end

    if Props.modHorns then
        SetVehicleMod(Vehicle, 14, Props.modHorns, false)
    end

    if Props.modSuspension then
        SetVehicleMod(Vehicle, 15, Props.modSuspension, false)
    end

    if Props.modArmor then
        SetVehicleMod(Vehicle, 16, Props.modArmor, false)
    end

    if Props.modNitrous then
        SetVehicleMod(Vehicle, 17, Props.modNitrous, false)
    end

    if Props.modTurbo ~= nil then
        ToggleVehicleMod(Vehicle, 18, Props.modTurbo)
    end

    if Props.modSubwoofer ~= nil then
        ToggleVehicleMod(Vehicle, 19, Props.modSubwoofer)
    end

    if Props.modHydraulics ~= nil then
        ToggleVehicleMod(Vehicle, 21, Props.modHydraulics)
    end

    if Props.modXenon ~= nil then
        ToggleVehicleMod(Vehicle, 22, Props.modXenon)
    end

    if Props.xenonColor then
        SetVehicleXenonLightsColor(Vehicle, Props.xenonColor)
    end

    if Props.modFrontWheels then
        SetVehicleMod(Vehicle, 23, Props.modFrontWheels, Props.modCustomTiresF)
    end

    if Props.modBackWheels then
        SetVehicleMod(Vehicle, 24, Props.modBackWheels, Props.modCustomTiresR)
    end

    if Props.modPlateHolder then
        SetVehicleMod(Vehicle, 25, Props.modPlateHolder, false)
    end

    if Props.modVanityPlate then
        SetVehicleMod(Vehicle, 26, Props.modVanityPlate, false)
    end

    if Props.modTrimA then
        SetVehicleMod(Vehicle, 27, Props.modTrimA, false)
    end

    if Props.modOrnaments then
        SetVehicleMod(Vehicle, 28, Props.modOrnaments, false)
    end

    if Props.modDashboard then
        SetVehicleMod(Vehicle, 29, Props.modDashboard, false)
    end

    if Props.modDial then
        SetVehicleMod(Vehicle, 30, Props.modDial, false)
    end

    if Props.modDoorSpeaker then
        SetVehicleMod(Vehicle, 31, Props.modDoorSpeaker, false)
    end

    if Props.modSeats then
        SetVehicleMod(Vehicle, 32, Props.modSeats, false)
    end

    if Props.modSteeringWheel then
        SetVehicleMod(Vehicle, 33, Props.modSteeringWheel, false)
    end

    if Props.modShifterLeavers then
        SetVehicleMod(Vehicle, 34, Props.modShifterLeavers, false)
    end

    if Props.modAPlate then
        SetVehicleMod(Vehicle, 35, Props.modAPlate, false)
    end

    if Props.modSpeakers then
        SetVehicleMod(Vehicle, 36, Props.modSpeakers, false)
    end

    if Props.modTrunk then
        SetVehicleMod(Vehicle, 37, Props.modTrunk, false)
    end

    if Props.modHydrolic then
        SetVehicleMod(Vehicle, 38, Props.modHydrolic, false)
    end

    if Props.modEngineBlock then
        SetVehicleMod(Vehicle, 39, Props.modEngineBlock, false)
    end

    if Props.modAirFilter then
        SetVehicleMod(Vehicle, 40, Props.modAirFilter, false)
    end

    if Props.modStruts then
        SetVehicleMod(Vehicle, 41, Props.modStruts, false)
    end

    if Props.modArchCover then
        SetVehicleMod(Vehicle, 42, Props.modArchCover, false)
    end

    if Props.modAerials then
        SetVehicleMod(Vehicle, 43, Props.modAerials, false)
    end

    if Props.modTrimB then
        SetVehicleMod(Vehicle, 44, Props.modTrimB, false)
    end

    if Props.modTank then
        SetVehicleMod(Vehicle, 45, Props.modTank, false)
    end

    if Props.modWindows then
        SetVehicleMod(Vehicle, 46, Props.modWindows, false)
    end

    if Props.modDoorR then
        SetVehicleMod(Vehicle, 47, Props.modDoorR, false)
    end

    if Props.modLivery then
        SetVehicleMod(Vehicle, 48, Props.modLivery, false)
    end

    if Props.modRoofLivery then
        SetVehicleRoofLivery(Vehicle, Props.modRoofLivery)
    end

    if Props.modLightbar then
        SetVehicleMod(Vehicle, 49, Props.modLightbar, false)
    end

    if Props.livery then
        SetVehicleLivery(Vehicle, Props.livery)
    end

    if Props.bulletProofTyres ~= nil then
        SetVehicleTyresCanBurst(Vehicle, Props.bulletProofTyres)
    end
    if Props.convertibleDown then
        LowerConvertibleRoof(Vehicle, true)
    end

    if Props.driftTyres then
        SetDriftTyresEnabled(Vehicle, true)
    end

    if FixVehicle then
        SetVehicleFixed(Vehicle)
    end

    return not NetworkGetEntityIsNetworked(Vehicle) or NetworkGetEntityOwner(Vehicle) == cache.playerId
end

---@param Vehicle number
---@return VehicleProperties?
function Vehicle.GetProperties(Vehicle)
    if DoesEntityExist(Vehicle) then
        ---@type number | number[], number | number[]
        local colorPrimary, colorSecondary = GetVehicleColours(Vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(Vehicle)
        local paintType1 = GetVehicleModColor_1(Vehicle)
        local paintType2 = GetVehicleModColor_2(Vehicle)

        if GetIsVehiclePrimaryColourCustom(Vehicle) then
            colorPrimary = { GetVehicleCustomPrimaryColour(Vehicle) }
        end

        if GetIsVehicleSecondaryColourCustom(Vehicle) then
            colorSecondary = { GetVehicleCustomSecondaryColour(Vehicle) }
        end

        local extras = {}

        for i = 1, 15 do
            if DoesExtraExist(Vehicle, i) then
                extras[i] = IsVehicleExtraTurnedOn(Vehicle, i) and 0 or 1
            end
        end

        local damage = {
            windows = {},
            doors = {},
            tyres = {},
        }

        local windows = 0

        for i = 0, 7 do
            RollUpWindow(Vehicle, i)

            if not IsVehicleWindowIntact(Vehicle, i) then
                windows += 1
                damage.windows[windows] = i
            end
        end

        local doors = 0

        for i = 0, 5 do
            if IsVehicleDoorDamaged(Vehicle, i) then
                doors += 1
                damage.doors[doors] = i
            end
        end

        for i = 0, 7 do
            if IsVehicleTyreBurst(Vehicle, i, false) then
                damage.tyres[i] = IsVehicleTyreBurst(Vehicle, i, true) and 2 or 1
            end
        end

        local neons = {}

        for i = 0, 3 do
            neons[i + 1] = IsVehicleNeonLightEnabled(Vehicle, i)
        end
        return {
            model = GetEntityModel(Vehicle),
            plate = GetVehicleNumberPlateText(Vehicle),
            plateIndex = GetVehicleNumberPlateTextIndex(Vehicle),
            bodyHealth = math.floor(GetVehicleBodyHealth(Vehicle) + 0.5),
            engineHealth = math.floor(GetVehicleEngineHealth(Vehicle) + 0.5),
            tankHealth = math.floor(GetVehiclePetrolTankHealth(Vehicle) + 0.5),
            fuelLevel = math.floor(GetVehicleFuelLevel(Vehicle) + 0.5),
            oilLevel = math.floor(GetVehicleOilLevel(Vehicle) + 0.5),
            dirtLevel = math.floor(GetVehicleDirtLevel(Vehicle) + 0.5),
            paintType1 = paintType1,
            paintType2 = paintType2,
            color1 = colorPrimary,
            color2 = colorSecondary,
            pearlescentColor = pearlescentColor,
            interiorColor = GetVehicleInteriorColor(Vehicle),
            dashboardColor = GetVehicleDashboardColour(Vehicle),
            wheelColor = wheelColor,
            wheelWidth = GetVehicleWheelWidth(Vehicle),
            wheelSize = GetVehicleWheelSize(Vehicle),
            wheels = GetVehicleWheelType(Vehicle),
            windowTint = GetVehicleWindowTint(Vehicle),
            xenonColor = GetVehicleXenonLightsColor(Vehicle),
            neonEnabled = neons,
            neonColor = { GetVehicleNeonLightsColour(Vehicle) },
            extras = extras,
            tyreSmokeColor = { GetVehicleTyreSmokeColor(Vehicle) },
            modSpoilers = GetVehicleMod(Vehicle, 0),
            modFrontBumper = GetVehicleMod(Vehicle, 1),
            modRearBumper = GetVehicleMod(Vehicle, 2),
            modSideSkirt = GetVehicleMod(Vehicle, 3),
            modExhaust = GetVehicleMod(Vehicle, 4),
            modFrame = GetVehicleMod(Vehicle, 5),
            modGrille = GetVehicleMod(Vehicle, 6),
            modHood = GetVehicleMod(Vehicle, 7),
            modFender = GetVehicleMod(Vehicle, 8),
            modRightFender = GetVehicleMod(Vehicle, 9),
            modRoof = GetVehicleMod(Vehicle, 10),
            modEngine = GetVehicleMod(Vehicle, 11),
            modBrakes = GetVehicleMod(Vehicle, 12),
            modTransmission = GetVehicleMod(Vehicle, 13),
            modHorns = GetVehicleMod(Vehicle, 14),
            modSuspension = GetVehicleMod(Vehicle, 15),
            modArmor = GetVehicleMod(Vehicle, 16),
            modNitrous = GetVehicleMod(Vehicle, 17),
            modTurbo = IsToggleModOn(Vehicle, 18),
            modSubwoofer = GetVehicleMod(Vehicle, 19),
            modSmokeEnabled = IsToggleModOn(Vehicle, 20),
            modHydraulics = IsToggleModOn(Vehicle, 21),
            modXenon = IsToggleModOn(Vehicle, 22),
            modFrontWheels = GetVehicleMod(Vehicle, 23),
            modBackWheels = GetVehicleMod(Vehicle, 24),
            modCustomTiresF = GetVehicleModVariation(Vehicle, 23),
            modCustomTiresR = GetVehicleModVariation(Vehicle, 24),
            modPlateHolder = GetVehicleMod(Vehicle, 25),
            modVanityPlate = GetVehicleMod(Vehicle, 26),
            modTrimA = GetVehicleMod(Vehicle, 27),
            modOrnaments = GetVehicleMod(Vehicle, 28),
            modDashboard = GetVehicleMod(Vehicle, 29),
            modDial = GetVehicleMod(Vehicle, 30),
            modDoorSpeaker = GetVehicleMod(Vehicle, 31),
            modSeats = GetVehicleMod(Vehicle, 32),
            modSteeringWheel = GetVehicleMod(Vehicle, 33),
            modShifterLeavers = GetVehicleMod(Vehicle, 34),
            modAPlate = GetVehicleMod(Vehicle, 35),
            modSpeakers = GetVehicleMod(Vehicle, 36),
            modTrunk = GetVehicleMod(Vehicle, 37),
            modHydrolic = GetVehicleMod(Vehicle, 38),
            modEngineBlock = GetVehicleMod(Vehicle, 39),
            modAirFilter = GetVehicleMod(Vehicle, 40),
            modStruts = GetVehicleMod(Vehicle, 41),
            modArchCover = GetVehicleMod(Vehicle, 42),
            modAerials = GetVehicleMod(Vehicle, 43),
            modTrimB = GetVehicleMod(Vehicle, 44),
            modTank = GetVehicleMod(Vehicle, 45),
            modWindows = GetVehicleMod(Vehicle, 46),
            modDoorR = GetVehicleMod(Vehicle, 47),
            modLivery = GetVehicleMod(Vehicle, 48),
            modRoofLivery = GetVehicleRoofLivery(Vehicle),
            modLightbar = GetVehicleMod(Vehicle, 49),
            livery = GetVehicleLivery(Vehicle),
            windows = damage.windows,
            doors = damage.doors,
            tyres = damage.tyres,
            bulletProofTyres = GetVehicleTyresCanBurst(Vehicle),
            driftTyres = GetDriftTyresEnabled(Vehicle),
            convertibleDown = GetConvertibleRoofState(Vehicle) ~= 0 and true or false
        }
    end
end

return Vehicle