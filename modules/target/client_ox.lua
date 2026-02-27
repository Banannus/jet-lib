local Object, Target = Dep.target.object, {}

function Target.AddGlobalVehicle(Options)
    return Object:addGlobalVehicle(Options)
end

return Target