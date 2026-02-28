---@meta
--[[
    https://github.com/overextended/jet-lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

local resourceName = GetCurrentResourceName()

local jetlib = 'jet-lib'

local export = exports[jetlib]

if GetResourceState(jetlib) ~= 'started' then
    error('^1jet-lib must be started before this resource.^0', 0)
end

local status = export.initialized()
if status ~= true then error(status, 2) end

-- Ignore invalid types during msgpack.pack (e.g. userdata)
msgpack.setoption('ignore_invalid', true)

-----------------------------------------------------------------------------------------------
-- Module
-----------------------------------------------------------------------------------------------

local LoadResourceFile = LoadResourceFile
local context = IsDuplicityVersion() and 'server' or 'client'

function noop() end

local function loadModule(self, module)
    module = string.lower(module)

    local dir = ('modules/%s'):format(module)
    local chunk = LoadResourceFile(jetlib, ('%s/%s.lua'):format(dir, context))
    local shared = LoadResourceFile(jetlib, ('%s/shared.lua'):format(dir))

    local dep = Jet.deb[module]

    if dep then
        chunk = LoadResourceFile(jetlib, ('%s/%s.lua'):format(dir, ('%s_%s'):format(context, dep.value))) or chunk
    end

    if shared then
        chunk = (chunk and ('%s\n%s'):format(shared, chunk)) or shared
    end

    if chunk then
        local fn, err = load(chunk, ('@@jet-lib/modules/%s/%s.lua'):format(module, context))

        if not fn or err then
            if shared then
                -- lib.print.warn(("An error occurred when importing '@jet-lib/modules/%s'.\nThis is likely caused by improperly updating jet-lib.\n%s'")
                --     :format(module, err))
                fn, err = load(shared, ('@@jet-lib/modules/%s/shared.lua'):format(module))
            end

            if not fn or err then
                return error(('\n^1Error importing module (%s): %s^0'):format(dir, err), 3)
            end
        end

        local result = fn()
        self[module] = result or noop
        return self[module]
    end
end

-----------------------------------------------------------------------------------------------
-- API
-----------------------------------------------------------------------------------------------

local function call(self, index, ...)
    index = string.lower(index)
    local module = rawget(self, index)

    if not module then
        self[index] = noop
        module = loadModule(self, index)

        if not module then
            local function method(...)
                return export[index](nil, ...)
            end

            if not ... then
                self[index] = method
            end

            return method
        end
    end

    return module
end

local Jet = setmetatable({
    name = 'jet-lib',
    context = context,
    dep = export.getdep(),
}, {
    __index = call,
    __call = call,
})

local intervals = {}
--- Dream of a world where this PR gets accepted.
---@param callback function | number
---@param interval? number
---@param ... any
function SetInterval(callback, interval, ...)
    interval = interval or 0

    if type(interval) ~= 'number' then
        return error(('Interval must be a number. Received %s'):format(json.encode(interval --[[@as unknown]])))
    end

    local cbType = type(callback)

    if cbType == 'number' and intervals[callback] then
        intervals[callback] = interval or 0
        return
    end

    if cbType ~= 'function' then
        return error(('Callback must be a function. Received %s'):format(cbType))
    end

    local args, id = { ... }

    Citizen.CreateThreadNow(function(ref)
        id = ref
        intervals[id] = interval or 0
        repeat
            interval = intervals[id]
            Wait(interval)

            if interval < 0 then break end
            callback(table.unpack(args))
        until false
        intervals[id] = nil
    end)

    return id
end

---@param id number
function ClearInterval(id)
    if type(id) ~= 'number' then
        return error(('Interval id must be a number. Received %s'):format(json.encode(id --[[@as unknown]])))
    end

    if not intervals[id] then
        return error(('No interval exists with id %s'):format(id))
    end

    intervals[id] = -1
end

--[[
    lua language server doesn't support generics when using @overload
    see https://github.com/LuaLS/lua-language-server/issues/723
    this function stub allows the following to work

    local key = cache('key', function() return 'abc' end) -- fff: 'abc'
    local game = cache.game -- game: string
]]

---@generic T
---@param key string
---@param func fun(...: any): T
---@param timeout? number
---@return T
---Caches the result of a function, optionally clearing it after timeout ms.
function cache(key, func, timeout) end

local cacheEvents = {}

local cache = setmetatable({ resource = resourceName }, {
    __index = function(self, key)
        cacheEvents[key] = {}

        AddEventHandler(('jet-lib:cache:%s'):format(key), function(value)
            local oldValue = self[key]
            local events = cacheEvents[key]

            for i = 1, #events do
                Citizen.CreateThreadNow(function()
                    events[i](value, oldValue)
                end)
            end

            self[key] = value
        end)

        return rawset(self, key, export.cache(nil, key) or false)[key]
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
    if not cacheEvents[key] then
        getmetatable(cache).__index(cache, key)
    end

    table.insert(cacheEvents[key], cb)
end

_ENV.Jet = Jet
_ENV.cache = cache
_ENV.require = Jet.require

if context == 'client' then
    cache.playerId = PlayerId()
    cache.serverId = GetPlayerServerId(cache.playerId)
else
    local poolNatives = {
        CPed = GetAllPeds,
        CObject = GetAllObjects,
        CVehicle = GetAllVehicles,
    }

    ---@param poolName 'CPed' | 'CObject' | 'CVehicle'
    ---@return number[]
    ---Server-side parity for the `GetGamePool` client native.
    function GetGamePool(poolName)
        local fn = poolNatives[poolName]
        return fn and fn() --[[@as number[] ]]
    end

    ---@return number[]
    ---Server-side parity for the `GetPlayers` client native.
    function GetActivePlayers()
        local playerNum = GetNumPlayerIndices()
        local players = table.create(playerNum, 0)

        for i = 1, playerNum do
            players[i] = tonumber(GetPlayerFromIndex(i - 1))
        end

        return players
    end
end

for i = 1, GetNumResourceMetadata(cache.resource, 'jet-lib') do
    local name = GetResourceMetadata(cache.resource, 'jet-lib', i - 1)

    if not rawget(Jet, name) then
        local module = loadModule(Jet, name)

        if type(module) == 'function' then pcall(module) end
    end
end