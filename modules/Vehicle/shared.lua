local Vehicle = {}

function Vehicle.SetProperties(vehicle, props, fixVehicle)
    return impl.setProperties(vehicle, props, fixVehicle)
end

function Vehicle.GetProperties(vehicle)
    return impl.getProperties(vehicle)
end

return Vehicle