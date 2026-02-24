---@class Locale
local Locale = {}

-- A table to store the flattened dictionary of translations
local dict = {}

--- Function to flatten the nested JSON structure into a single-level dictionary.
-- This function is internal and used to preprocess locale files.
---@param prefix string The current prefix used for nested keys.
---@param source table The source table to flatten.
---@param target table The target table where flattened key-value pairs are stored.
local function flattenDict(prefix, source, target)
    for key, value in pairs(source) do
        local fullKey = (prefix and prefix .. "." .. key) or key
        if type(value) == "table" then
            flattenDict(fullKey, value, target)  -- Recursive call now recognizes 'flattenDict'
        else
            target[fullKey] = value
        end
    end
end

--- Function to retrieve localized strings, with optional dynamic content replacement.
---@param key string The key for the localized string.
---@param replacements? table A table of replacement values for dynamic content in the localized string.
---@return string The localized string with any replacements applied, or the original key if no translation is found.
function Locale.T(key, replacements)
    local lstr = dict[key]
    if lstr and replacements then
        for k, v in pairs(replacements) do
            lstr = lstr:gsub('{' .. k .. '}', v)
        end
    end
    return lstr or key  -- Fallback to the original key if no translation is found
end

--- Function to load and apply locales from a JSON file based on the provided locale setting.
---@param locale? string The locale setting determining which translation file to load. Defaults to 'en'
function Locale.LoadLocale(locale)
    local lang = locale or 'en'  -- Default to 'en' if not set
    local path = ('locales/%s.json'):format(lang)
    local resourceName = GetCurrentResourceName()
    local file = LoadResourceFile(resourceName, path)

    if not file then
        error(string.format("Could not load locale file: %s for resource %s", path, resourceName))
        return
    end

    local locales = json.decode(file)
    if not locales then
        error("Failed to parse the locale JSON.")
        return
    end

    -- Clear existing dictionary to replace with new locale
    for k in pairs(dict) do
        dict[k] = nil
    end

    flattenDict(nil, locales, dict)
end

--- Alias for T function for shorter syntax
---@param key string The key for the localized string.
---@param replacements? table A table of replacement values for dynamic content.
---@return string The localized string with replacements applied.
function Locale.Translate(key, replacements)
    return Locale.T(key, replacements)
end

--- Get the current dictionary (useful for debugging)
---@return table The current flattened dictionary
function Locale.GetDict()
    return dict
end

--- Check if a translation key exists
---@param key string The key to check
---@return boolean Whether the key exists in the current locale
function Locale.HasKey(key)
    return dict[key] ~= nil
end

return Locale
