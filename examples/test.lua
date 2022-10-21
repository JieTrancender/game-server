-- local host = "http://192.168.3.212:2379"
-- local scheme, host, port = string.match(host, [[([a-zA-Z]+://[^\s]+)]])
-- print("~~~~~~schema", scheme, host, port)
-- local m, err = string.match(host, [[[a-zA-z]+://[^\s]*]])
-- print("~~~~~~~~m", m, err)
-- for k, v in pairs(m) do
--     print("falsdfl", k, v)
-- end
-- print("~~~~~err", err)

local str = "http://192.168.3.212:2379"
local a, b, c, d = string.match(str, [[([^/]+)://([^%s:]+):?(%d+)]])
print("~~~~~~", a, b, c, d)
print(a)
print(b)
print(c)
print(d)
