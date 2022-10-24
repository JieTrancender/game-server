local _M = {}

--字符串转换为字符数组
local function str_to_arr(str)
    local arr = {}
    local len = string.len(str)
    while str do
        local fontUTF = string.byte(str, 1)
        if fontUTF == nil then
            break
        end

        local byteCount = 0
        if fontUTF >= 240 then
            byteCount = 4
        elseif fontUTF >= 224 then
            byteCount = 3
        elseif fontUTF >= 192 then
            byteCount = 2
        elseif fontUTF <= 127 then
            byteCount = 1
        end

        table.insert(array, string.sub(str,1, byteCount))
        str = string.sub(str, byteCount + 1, len)
    end
    return array
end
_M.str_to_arr = str_to_arr

function _M.split(str, separator)
    if str == nil then
        return {}
    end

    if str == "" then
        return {}
    end

    if separator == "" then
        return str_to_arr(str)
    end

    local arr, index, pos = {}, 1
    separator = separator or ":"
    while true do
        pos = string.find(str, separator, index, true)  -- 关闭模式匹配
        if not pos then
            break
        end

        table.insert(arr, string.sub(str, index, pos - 1))
        index = pos + string.len(separator)
    end
    table.insert(arr, string.sub(str, index))
    return arr
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

return _M
