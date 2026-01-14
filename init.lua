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

    return deps
end

Dep = detectDependencies()

jet = setmetatable({
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
        if key == 'Callback' then
            implFile = self.context == 'server' and 'server.lua' or 'client.lua'
        elseif Dep[string.lower(key)] then
            implFile = ('%s.lua'):format(Dep[string.lower(key)])
        else
            implFile = Dep.framework == 'esx' and 'esx.lua' or (Dep.framework == 'qb' and 'qb.lua' or nil)
        end

        if not implFile then
            error(('No implementation found for module %s with framework %s'):format(key, tostring(Dep.framework)))
        end

        local implChunk = LoadResourceFile(self.name, ('%s/%s'):format(basePath, implFile))
        if implChunk then
            env.impl = assert(load(implChunk, ('@@%s/%s/%s'):format(self.name, basePath, implFile), 't', env))()
        end

        local module = assert(load(sharedChunk, ('@@%s/%s/shared.lua'):format(self.name, basePath), 't', env))()
        self[key] = module
        return module
    end
})
