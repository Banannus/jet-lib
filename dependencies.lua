Dep = {}

local resources = {
    framework = {
        ['es_extended'] = 'esx',
        -- ['qb-core'] = 'qb',
        -- ['qbx_core'] = 'qb',
    },
    inventory = {
        ['ox_inventory'] = 'ox',
        -- ['qs-inventory-pro'] = 'qs',
        -- ['qs-inventory'] = 'qs',
        -- ['codem-inventory'] = 'codem',
        -- ['origen-inventory'] = 'origen',
        ['qb-inventory'] = 'qb',
        ['ps-inventory'] = 'qb',
        ['lj-inventory'] = 'qb',
        ['renewed-inventory'] = 'qb'
    },
    dispatch = {
        -- ['linden_outlawalert'] = 'linden',
        -- ['cd_dispatch'] = 'cd',
        -- ['fd_dispatch'] = 'fd',
        -- ['ps-dispatch'] = 'ps',
        -- ['qs-dispatch'] = 'qs',
        -- ['core_dispatch'] = 'core',
        -- ['origen_police'] = 'origen',
        -- ['codem-dispatch'] = 'codem'
    },
    notify = {
        ['ox_lib'] = 'ox',
    },
    radialmenu = {
        ['qb-radialmenu'] = 'qb',
        ['ox_lib'] = 'ox',
    },
    target = {
        ['ox_target'] = 'ox'
    },
    teams = {
        ['bach_squad'] = 'bach',
        -- ['st_teams'] = 'st',
    }
}

local function InitiateDependencies()
    for key, value in pairs(resources) do
        Dep[key] = {}

        for resName, resValue in pairs(value) do
            if GetResourceState(resName) == 'started' then
                local object

                if key == 'framework' then
                    local getter = resName == 'es_extended' and 'getSharedObject' or 'GetCoreObject'
                    object = exports[resName][getter]()
                else
                    object = exports[resName]
                end

                Dep[key] = { value = resValue, object = object, resource = resName }
                break
            end
        end
    end
end

InitiateDependencies()