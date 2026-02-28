local debug_getinfo = debug.getinfo

function noop() end

Jet = setmetatable({
    name = 'jet-lib',
    context = IsDuplicityVersion() and 'server' or 'client',
}, {
    __newindex = function(self, key, fn)
        key = string.lower(key)

        rawset(self, key, fn)

        if debug_getinfo(2, 'S').short_src:find('@jet%-lib/resource') then
            exports(key, fn)
        end
    end,

    __index = function(self, key)
        key = string.lower(key)

        local dir = ('modules/%s'):format(key)
        local chunk = LoadResourceFile(self.name, ('%s/%s.lua'):format(dir, self.context))
        local shared = LoadResourceFile(self.name, ('%s/shared.lua'):format(dir))

        if Dep[key] then
            chunk = LoadResourceFile(self.name, ('%s/%s.lua'):format(dir, ('%s_%s'):format(self.context, Dep[key].value))) or chunk
        end

        if shared then
            chunk = (chunk and ('%s\n%s'):format(shared, chunk)) or shared
        end

        if chunk then
            local fn, err = load(chunk, ('@@jet-lib/%s/%s.lua'):format(key, self.context))

            if not fn or err then return error(('\n^1Error importing module (%s): %s^0'):format(dir, err), 3) end

            rawset(self, key, fn() or noop)

            return self[key]
        end
    end
})

cache = { resource = Jet.name }

function Jet.initialized() return true end

function Jet.getdep()return Dep end

require = Jet.Require