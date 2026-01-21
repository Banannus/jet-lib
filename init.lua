--[[
    Code originally sourced from ox_lib (https://github.com/overextended/ox_lib).
    This modified version is part of jet-lib
    
    This file is licensed under LGPL-3.0 or higher 
    (<https://www.gnu.org/licenses/lgpl-3.0.en.html>).
    
    Copyright (c) 2025 Linden 
    (<https://github.com/thelindat/fivem>).
]]

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
    },
    mdt = {
        ['tk_mdt'] = 'tk_mdt', -- Check lb-tablet last
        ['ps-mdt'] = 'qb',
    }
} -- TODO: Fix this

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
        -- First check if it's a call-based export request
        local existing = rawget(self, key)
        if existing then return existing end

        local basePath = ('modules/%s'):format(key)
        local sharedPath = ('%s/shared.lua'):format(basePath)
        local sharedChunk = LoadResourceFile(self.name, sharedPath)

        if not sharedChunk then
            error(('Module %s does not exist!'):format(key))
        end

        local env = { Dep = Dep }
        setmetatable(env, { __index = _G })

        local implFile
        local depKey = string.lower(key)

        if not Dep[depKey] and Registry.dependencies[depKey] then
            for resKey, depId in pairs(Registry.dependencies[depKey]) do
                if GetResourceState(resKey) == 'started' then
                    Dep[depKey] = depId
                    break
                end
            end
        end

        if Dep[depKey] then
            implFile = ('%s.lua'):format(Dep[depKey])
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
    end,

    __call = call,
})

_ENV.Dep = Dep
_ENV.Jet = Jet

local jetCacheEvents = {}

local context = IsDuplicityVersion() and 'server' or 'client'
local initialCache = { 
    game = GetGameName(), 
    resource = GetCurrentResourceName() 
}

if context == 'client' then
    initialCache.playerId = PlayerId()
    initialCache.serverId = GetPlayerServerId(initialCache.playerId)
end

local jetCache = setmetatable(initialCache, {
    __index = function(self, key)
        if not jetCacheEvents[key] then
            jetCacheEvents[key] = {}

            AddEventHandler(('jet-lib:jetCache:%s'):format(key), function(value)
                local oldValue = rawget(self, key)
                local events = jetCacheEvents[key]

                for i = 1, #events do
                    Citizen.CreateThreadNow(function()
                        events[i](value, oldValue)
                    end)
                end

                rawset(self, key, value)
            end)
        end

        return rawget(self, key) or rawset(self, key, false)[key]
    end,

    __call = function(self, key, func, timeout)
        local value = rawget(self, key)

        if value == nil then
            value = func()

            rawset(self, key, value)

            if timeout then SetTimeout(timeout, function() self[key] = nil end) end
        end

        return value
    end,
})

function Jet.onCache(key, cb)
    if not jetCacheEvents[key] then
        getmetatable(jetCache).__index(jetCache, key)
    end

    table.insert(jetCacheEvents[key], cb)
end

if GetCurrentResourceName() == 'jet-lib' then
    _ENV.jetCache = jetCache
    _ENV.jetCacheEvents = jetCacheEvents

    exports('getCache', function(key)
        return jetCache[key]
    end)
else
    _ENV.jetCache = setmetatable({}, {
        __index = function(self, key)
            return exports['jet-lib']:getCache(key)
        end
    })
end
