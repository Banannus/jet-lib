local module = {}

function module.addItem(data)
    return lib.addRadialItem(data)
end

function module.removeItem(data)
    return lib.removeRadialItem(data)
end

return module