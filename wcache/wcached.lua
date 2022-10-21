local skynet    = require "skynet"
local profile   = require "skynet.profile"
local wcacheMgr = require "gate.wcache_mgr"

local ti = {}
skynet.start(function()
    skynet.dispatch("lua", function(session, source, command, ...)
        profile.start()
        local f = wcacheMgr[command]
        if session > 0 then
            skynet.retpack(f, ...)
        else
            f(...)
        end

        local time = profile.stop()
        if nil == ti[command] then
            ti[command] = {n = 0, ti = 0}
        end
        ti[command].n = ti[command].n + 1
        ti[command].ti = ti[command].ti + time
    end)
end)

skynet.info_func(function()
    return ti
end)
