local Create = {}

local Creating = false

---@param Model number | string
---@param Coords vector4
---@param Props table?
---@return number Vehicle
---@return number NetworkId
function Create.Vehicle(Model, Coords, Props)
    while Creating do Wait(100) end
    Creating = true

    Jet.Request.Model(Model)
    local Vehicle = CreateVehicle(Model, Coords.x, Coords.y, Coords.z, Coords.w, true, true)
    while not DoesEntityExist(Vehicle) do Wait(100) end

    while not NetworkGetEntityIsNetworked(Vehicle) do
        NetworkRegisterEntityAsNetworked(Vehicle)
        Wait(25)
    end

    local NetworkId = NetworkGetNetworkIdFromEntity(Vehicle)
    while not NetworkDoesEntityExistWithNetworkId(NetworkId) do Wait(100) end

    SetNetworkIdCanMigrate(NetworkId, true)
    SetNetworkIdExistsOnAllMachines(NetworkId, true)

    SetEntityAsMissionEntity(Vehicle, true, true)
    SetEntityVisible(Vehicle, true, false)

    -- if Props then lib.setVehicleProperties(Vehicle, Props) end TODO: Set Vehicle Properties

    SetTimeout(100, function()
       Creating = false
    end)

    SetModelAsNoLongerNeeded(Model)

    return Vehicle, NetworkId
end

---@param Model number | string
---@param Coords vector4
---@return number Prop
---@return number NetworkId
function Create.Prop(Model, Coords)
    while Creating do Wait(100) end
    Creating = true

    Jet.Request.Model(Model)

    local Prop = CreateObjectNoOffset(Model, Coords.x, Coords.y, Coords.z, true, true, true)
    while not DoesEntityExist(Prop) do Wait(100) end

    while not NetworkGetEntityIsNetworked(Prop) do
        NetworkRegisterEntityAsNetworked(Prop)
        Wait(25)
    end

    local NetworkId = NetworkGetNetworkIdFromEntity(Prop)
    while not NetworkDoesEntityExistWithNetworkId(NetworkId) do Wait(100) end

    SetNetworkIdCanMigrate(NetworkId, true)
    SetNetworkIdExistsOnAllMachines(NetworkId, true)

    SetEntityAsMissionEntity(Prop, true, true)
    SetEntityHeading(Prop, Coords.w)

    SetTimeout(100, function()
       Creating = false
    end)

    SetModelAsNoLongerNeeded(Model)

    return Prop, NetworkId
end

---@param Model number | string
---@param Coords vector4
---@param InsideVehicle table?
---@return number Ped
---@return number NetworkId
function Create.Ped(Model, Coords, InsideVehicle)
    while Creating do Wait(100) end
    Creating = true
    
    Jet.Request.Model(Model)

    local Ped
    
    if InsideVehicle and next(InsideVehicle) then
        Ped = CreatePedInsideVehicle(InsideVehicle.Entity, 26, Model, InsideVehicle.Seat, true, true)
    else
        Ped = CreatePed(26, Model, Coords.x, Coords.y, Coords.z, Coords.w, true, true)
    end
    while not DoesEntityExist(Ped) do Wait(100) end

    while not NetworkGetEntityIsNetworked(Ped) do
        NetworkRegisterEntityAsNetworked(Ped)
        Wait(25)
    end

    local NetworkId = NetworkGetNetworkIdFromEntity(Ped)
    while not NetworkDoesEntityExistWithNetworkId(NetworkId) do
        Wait(100)
    end

    SetNetworkIdCanMigrate(NetworkId, true)
    SetNetworkIdExistsOnAllMachines(NetworkId, true)

    SetEntityAsMissionEntity(Ped, true, true)
    SetEntityVisible(Ped, true, false)

    SetPedCanSwitchWeapon(Ped, true)
    SetPedDropsWeaponsWhenDead(Ped, false)
    SetPedFleeAttributes(Ped, 0, false)

    SetTimeout(100, function()
       Creating = false
    end)

    SetModelAsNoLongerNeeded(Model)

    return Ped, NetworkId
end

return Create