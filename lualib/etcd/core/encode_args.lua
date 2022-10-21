local string = require "string"
local table = require "table"
local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end

local typeof = require "etcd.core.typeof"
local function urlencode(url)
    if url == nil then
        return
    end
    s = string.gsub(url, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(url, " ", "+")
end

local urldecode = function(url)
    if url == nil then
        return
    end
    url = url:gsub("+", " ")
    url = url:gsub("%%(%x%x)", hex_to_char)
    return url
end

return function (params)
    local str = ''
    local is_not_first = false
    for k,v in pairs(params) do
        if typeof.table(v) then
            --TODO:
            assert(false)
        elseif is_not_first then
            str = str .. '&' .. k .. '=' .. v
        else
            str = str .. k .. '=' .. v
            is_not_first = true
        end
    end

    return urlencode(str)
end
