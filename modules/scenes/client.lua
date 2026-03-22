local Scenes = {}

---@param cb function
---@param entity number
---@param chance number
function Scenes.CardSwipe(cb, entity, chance)
    local playerPed = cache.ped
    local playerCoords = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity)
    local dict = 'anim_heist@hs3f@ig3_cardswipe@female@'
    local cardModel = GetHashKey('p_ld_id_card_002')

    Jet.Request.AnimDict(dict)
    Jet.Request.Model(cardModel)

    local cardProp = CreateObject(cardModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)

    SetEntityCollision(cardProp, false, true)

    local dropped = math.random(1, 100) <= (chance or 10)

    local duration = dropped and 5600 or 4133
    local anim = dropped and 'drop_card_success_var02' or 'success_var01'

    local swipeScene = NetworkCreateSynchronisedScene(playerCoords.x, playerCoords.y, playerCoords.z, rotation.x, rotation.y, rotation.z, 2, true, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(playerPed, swipeScene, dict, anim, 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(cardProp, swipeScene, dict, ('%s_card'):format(anim), 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(swipeScene)

    Wait(duration)

    cb()

    DeleteEntity(cardProp)

    RemoveAnimDict(dict)
    SetModelAsNoLongerNeeded(cardModel)
end

---@param cb function
---@param entity number
function Scenes.HackUSB(cb, entity)
    local ped = cache.ped
    local coords = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity)
    local dict = 'anim@scripted@player@mission@tunf_hack_keypad@male@'
    local phoneModel = GetHashKey('prop_npc_phone')
    local usbModel = GetHashKey('tr_prop_tr_usb_drive_01a')

    Jet.Request.AnimDict(dict)
    Jet.Request.Model(phoneModel)
    Jet.Request.Model(usbModel)

    local phoneProp = CreateObject(phoneModel, coords.x, coords.y, coords.z, true, true, true)
    local usbProp = CreateObject(usbModel, coords.x, coords.y, coords.z, true, true, true)

    SetEntityCollision(phoneProp, false, true)
    SetEntityCollision(usbProp, false, true)

    local scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, rotation.x, rotation.y, rotation.z, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, scene, dict, 'action', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(phoneProp, scene, dict, 'action_phone', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(usbProp, scene, dict, 'action_usb_drive', 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(scene)

    Wait(4566)

    local loopScene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, rotation.x, rotation.y, rotation.z, 2, true, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, loopScene, dict, 'hack_loop', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(phoneProp, loopScene, dict, 'hack_loop_phone', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(usbProp, loopScene, dict, 'hack_loop_usb_drive', 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(loopScene)

    cb()

    local exitScene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, rotation.x, rotation.y, rotation.z, 2, true, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, exitScene, dict, 'exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(phoneProp, exitScene, dict, 'exit_phone', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(usbProp, exitScene, dict, 'exit_usb_drive', 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(exitScene)

    Wait(3600)

    DeleteEntity(phoneProp)
    DeleteEntity(usbProp)

    RemoveAnimDict(dict)
    SetModelAsNoLongerNeeded(phoneModel)
    SetModelAsNoLongerNeeded(usbModel)
end

return Scenes