local util           = require "util"
local skynet         = require "skynet"
local etcd_hosts     = skynet.getenv("etcd_hosts")
local etcd_user      = skynet.getenv("etcd_user")
local etcd_passwd    = skynet.getenv("etcd_passwd")
local etcd_protocol  = skynet.getenv("etcd_protocol")
local etcd_base_path = skynet.getenv("etcd_base_path")

skynet.start(function()
    local etcdd = skynet.uniqueservice("etcdd")
    local err = skynet.call(etcdd, "lua", "init", etcd_hosts, etcd_user, etcd_passwd, etcd_protocol)
    if err ~= nil then
        skynet.error("failed to init etcdd:", err)
        return
    end

    local wcachedConf1 = {ips = "127.0.0.1:11001,127.0.0.1:11002,127.0.0.1:11003", nodeName = "wcached", threadId = 1, serviceName = "wcached"}
    local wcachedConf2 = {ips = "127.0.0.1:11101,127.0.0.1:11102,127.0.0.1:11103", nodeName = "wcached", threadId = 2, serviceName = "wcached"}
    local res, err = skynet.call(etcdd, "lua", "set", etcd_base_path.."node/wcached/1", wcachedConf1)
    local res, err = skynet.call(etcdd, "lua", "set", etcd_base_path.."node/wcached/2", wcachedConf2)
    local res, err = skynet.call(etcdd, "lua", "get", etcd_base_path.."node/wcached/2")
    print("config is ", util.table_dump_line(res.body.kvs[1].value))
    
    skynet.error("test etcd successd.")
end)
