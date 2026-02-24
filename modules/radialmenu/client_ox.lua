local Object, RadialMenu = Dep.radialmenu.object, {}

function RadialMenu.AddItem(data)
    return Object:addRadialItem(data)
end

function RadialMenu.RemoveItem(id)
    return Object:removeRadialItem(id)
end

return RadialMenu