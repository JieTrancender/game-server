local skynet = require "skynet"

skynet.start(function()
    local agentList = {}
    for i = 1, 100 do
        agentList[i] = skynet.newservice("mysqlagent")
        skynet.call(agentList[i], "lua", "init", "mysqlcluster_1", "@mysqlproxy")
    end
    
    skynet.error("start mysqlcluster_2 success!")
    skynet.exit()    
end)
