local Object, Target = Jet.dep.target.object, {}

function Target.AddGlobalVehicle(Options)
    return Object:addGlobalVehicle(Options)
end

return Target