local c            = require "skynet.core"
local http         = require "http.httpc"
local table_concat = table.concat
local tostring     = tostring
local select       = select
local ipairs       = ipairs
local pairs        = pairs
local type         = type

local _M = {}

local function clear_tab(t)
    t = {}
end
_M.clear_tab = clear_tab

local function split(s, delim)
    local sp = {}
    local pattern = "[^" .. delim .. ']+'
    string.gsub(s, pattern, function(v) table.insert(sp, v) end)
    return sp
end
_M.split = split

local normalize
do
    local items = {}
    local function concat(sep, ...)
        local argc = select('#', ...)
        clear_tab(items)
        local len, v = 0

        for i = 1, argc do
            v = select(i, ...)
            if v ~= nil then
                len = len + 1
                items[len] = tostring(v)
            end
        end

        return table_concat(items, sep)
    end

    local segs = {}
    function normalize(...)
        local path = concat('/', ...)
        local names = {}
        local err

        segs, err = split(path, [[/]])
        if not segs then
            return nil, err
        end

        local len = 0
        for _, seg in ipairs(segs) do
            if seg == '..' then
                if len > 0 then
                    len = len - 1
                end
            elseif seg == '' or seg == '/' and names[len] == '/' then
                -- do nothing
            elseif seg ~= '.' then
                len = len + 1
                names[len] = seg
            end
        end

        return '/' .. table_concat(names, '/', 1, len)
    end
end
_M.normalize = normalize

function _M.get_real_key(prefix, key)
    return (type(prefix) == 'string' and prefix or "") .. key
end

function _M.has_value(arr, val)
    for key, value in pairs(arr) do
        if value == val then
            return key
        end
    end

    return false
end

local log_info
local log_error

-- todo: log level
local log_level = "ERROR"
do
    local function logImp(...)
        local t = {...}
        for i = 1, #t do
            t[i] = tostring(t[i])
        end

        return c.error(table.concat(t, " "))
    end

    function log_info(...)
        if log_level ~= "INFO" then
            return
        end
        
        logImp("INFO", ...)
    end

    function log_error(...)
        logImp("ERROR", ...)
    end

    function table_dump_line(obj)
        local getIndent, quoteStr, wrapKey, wrapVal, dumpObj
        getIndent = function(level)
            return ""
            -- return string.rep("\t", level)
        end
        quoteStr = function(str)
            return '"' .. string.gsub(str, '"', '\\"') .. '"'
        end
        wrapKey = function(val)
            if type(val) == "number" then
                return "[" .. val .. "]"
            elseif type(val) == "string" then
                return "[" .. quoteStr(val) .. "]"
            else
                return "[" .. tostring(val) .. "]"
            end
        end
        wrapVal = function(val, level)
            if type(val) == "table" then
                return dumpObj(val, level)
            elseif type(val) == "number" then
                return val
            elseif type(val) == "string" then
                return quoteStr(val)
            else
                return tostring(val)
            end
        end
        dumpObj = function(obj, level)
            if type(obj) ~= "table" then
                return wrapVal(obj)
            end
            level = level + 1
            local tokens = {}
            tokens[#tokens + 1] = "{"
            for k, v in pairs(obj) do
                tokens[#tokens + 1] = getIndent(level) .. wrapKey(k) .. " = " .. wrapVal(v, level) .. ","
            end
            tokens[#tokens + 1] = getIndent(level - 1) .. "}"
            return table.concat(tokens, "")
        end
        return dumpObj(obj, 0)
    end
end
_M.log_info = log_info
_M.log_error = log_error
_M.table_dump_line = table_dump_line

local function verify_key(key)
    if not key or #key == 0 then
        return false, "key should not be empty"
    end

    return true, nil
end
_M.verify_key = verify_key

return _M
