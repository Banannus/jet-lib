CreateThread(function()
    Jet.Money.AddMoney(14, 'cash', 1000)
end)

Jet.Callback.Register('jet-testEvent', function(source, cb)
    return 'Hejsa'
end)