local Create = {}

function Create.Vehicle(model, coords, prop)
    return impl.vehicle(model, coords, prop)
end

function Create.Prop(model, coords)
    return impl.prop(model, coords)
end

function Create.Ped(model, coords, insideVehicle)
    return impl.ped(model, coords, insideVehicle)
end

return Create