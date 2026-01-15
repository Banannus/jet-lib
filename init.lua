local Registry = {}

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

local Dep = {}

local function initFramework(fw)
    if GetResourceState(fw.object) ~= 'started' then return nil end
    local getter = fw.getter
    if not exports[fw.object][getter] then return nil end
    return exports[fw.object][getter]()
end

local function detectFramework()
    for _, fw in pairs(Registry.frameworks) do
        local obj = initFramework(fw)
        if obj then
            return fw.id, obj
        end
    end
    return nil, nil
end

local function detectDependencies()
    local deps = {}
    local framework, frameworkObj = detectFramework()

    deps.framework = framework
    deps.object = frameworkObj

    for depType, depList in pairs(Registry.dependencies) do
        for resKey, depId in pairs(depList) do
            if GetResourceState(resKey) == 'started' then
                deps[depType] = depId
                break
            end
        end
    end

    if GetResourceState('ox_lib') == 'started' then
        deps.oxlib = 'ox'
    end

    return deps
end

Dep = detectDependencies()

Jet = setmetatable({
    name = 'jet-lib',
    context = IsDuplicityVersion() and 'server' or 'client'
}, {
    __newindex = function(self, key, value)
        rawset(self, key, value)
    end,

    __index = function(self, key)
        local basePath = ('modules/%s'):format(key)
        local sharedPath = ('%s/shared.lua'):format(basePath)
        local sharedChunk = LoadResourceFile(self.name, sharedPath)

        if not sharedChunk then
            error(('Module %s does not exist!'):format(key))
        end

        local env = { Dep = Dep }
        setmetatable(env, { __index = _G })

        local implFile

        if Dep[string.lower(key)] then
            implFile = ('%s.lua'):format(Dep[string.lower(key)])
        else
            implFile = Dep.framework == 'esx' and 'esx.lua' or (Dep.framework == 'qb' and 'qb.lua' or nil)
        end

        local implChunk = LoadResourceFile(self.name, ('%s/%s'):format(basePath, implFile))
        if not implChunk then 
            implFile = self.context == 'server' and 'server.lua' or 'client.lua'
            implChunk = LoadResourceFile(self.name, ('%s/%s'):format(basePath, implFile))
        end
        
        if implChunk then
            env.impl = assert(load(implChunk, ('@@%s/%s/%s'):format(self.name, basePath, implFile), 't', env))()
        end

        local module = assert(load(sharedChunk, ('@@%s/%s/shared.lua'):format(self.name, basePath), 't', env))()
        self[key] = module
        return module
    end
})
