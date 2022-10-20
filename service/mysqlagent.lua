local skynet  = require "skynet"
local cluster = require "skynet.cluster"

local proxy

local CMD = {}

function CMD.init(nodeName, serviceName)
    proxy = cluster.proxy(nodeName, serviceName)
end

function CMD.exec(sql)
    return skynet.call(proxy, "lua", "exec", sql)
end

function CMD.stop()
    while skynet.mqlen() > 0 or skynet.task() > 0 do
        skynet.sleep(100)
    end
    return 0
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, command, ...)
        local f = assert(CMD[command], string.format("source:%s, command:%s", skynet.address(source), command))
        if session > 0 then
            skynet.retpack(f(...))
        else
            f(...)
        end
    end)
end)
