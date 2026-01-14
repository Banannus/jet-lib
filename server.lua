CreateThread(function()
    jet.Inventory.AddItem(11, 'water', 1)
end)

jet.Callback.Register('jet-testEvent', function(source, cb)
    return 'Hejsa'
end)