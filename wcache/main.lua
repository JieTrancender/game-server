local skynet  = require "skynet"
local cluster = requrie "skynet.cluster"

skynet.start(function()
    local clusterName = {
        __nowaiting = true,
        wcached_1 = {"127.0.0.1:2520","127.0.0.1:2521"},
        wgamed_1 = "127.0.0.1:2521",
    }

    local nodeName = "wcached_1"
    local wcached = skynet.uniqueservice("wcached")
    cluster.register("wcached", wcached)
    for i, v in ipairs(clusterName[nodeName]) do
        cluster.open(nodeName.."_"..i, v)
    end

    skynet.error("start wcached success!")
end)
