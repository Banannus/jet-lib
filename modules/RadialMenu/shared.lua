local RadialMenu = {}

---Adds an item to the radial menu
---@param data table The data for the radial menu item { id, icon, iconWidth, iconHeight, label, menu, onSelect, keepOpen }
function RadialMenu.AddItem(data)
    return impl.addItem(data)
end

---Removes an item from the radial menu
---@param data table The data for the radial menu item { id }
function RadialMenu.RemoveItem(data)
    return impl.removeItem(data)
end

return RadialMenu