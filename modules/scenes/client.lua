local Scenes = {}

function Scenes.OpenCrate(entity, cb)
    if not DoesEntityExist(entity) then print('OpenContainer: Entity does not exist') return end

    while NetworkGetEntityOwner(entity) ~= cache.playerId do
        NetworkRequestControlOfEntity(entity)
        Wait(100)
    end

    local ped = cache.ped
    local coords = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity)
    local dict = 'anim@scripted@player@mission@trn_ig2_empty@male@'
    local crowbarModel = GetHashKey('w_me_crowbar')
    
    Jet.Request.AnimDict(dict)
    Jet.Request.Model(crowbarModel)

    local crowbarProp = CreateObject(crowbarModel, coords.x, coords.y, coords.z, true, true, true)

    SetEntityCollision(crowbarProp, false, true)

    local scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, scene, dict, 'empty', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(crowbarProp, scene, dict, 'empty_crowbar', 1.0, 1.0, 1)
    
    local propScene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddEntityToSynchronisedScene(entity, propScene, dict, 'empty_crate', 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(scene)
    NetworkStartSynchronisedScene(propScene)

    Wait(5000)

    cb()

    Wait(1000)

    DeleteEntity(crowbarProp)

    RemoveAnimDict(dict)
    SetModelAsNoLongerNeeded(crowbarModel)
end

return Scenes