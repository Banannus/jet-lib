CreateThread(function()
    jet.Money.AddMoney(11, 'cash', 1000)
end)

jet.Callback.Register('jet-testEvent', function(source, cb)
    return 'Hejsa'
end)