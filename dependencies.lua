Registry = {}

Registry.frameworks = {
    ['es_extended'] = { id = 'esx', object = 'es_extended', getter = 'getSharedObject' },
    ['qb-core'] = { id = 'qb', object = 'qb-core', getter = 'GetCoreObject' },
    ['qbx_core'] = { id = 'qb', object = 'qb-core', getter = 'GetCoreObject' }
}

Registry.dependencies = {
    inventory = {
        ['ox_inventory'] = 'ox',
        ['qs-inventory-pro'] = 'qs',
        ['qs-inventory'] = 'qs',
        ['codem-inventory'] = 'codem',
        ['origen-inventory'] = 'origen',
        ['qb-inventory'] = 'qb',
        ['ps-inventory'] = 'qb',
        ['lj-inventory'] = 'qb',
        ['renewed-inventory'] = 'qb'
    },
    dispatch = {
        ['linden_outlawalert'] = 'linden',
        ['cd_dispatch'] = 'cd',
        ['fd_dispatch'] = 'fd',
        ['ps-dispatch'] = 'ps',
        ['qs-dispatch'] = 'qs',
        ['core_dispatch'] = 'core',
        ['origen_police'] = 'origen',
        ['codem-dispatch'] = 'codem'
    },
    notification = {
        ['ox_lib'] = 'ox',
    },
    radialmenu = {
        ['qb-radialmenu'] = 'qb',
        ['ox_lib'] = 'ox',
    }
}