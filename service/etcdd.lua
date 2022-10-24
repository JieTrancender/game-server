local util   = require "util"
local skynet = require "skynet"
local etcd   = require "etcd.etcd"

local etcd_cli
local _M = {}

local function genEtcdHosts(etcd_hosts)
    return util.split(etcd_hosts, ",")
end

function _M.init(etcd_hosts, etcd_user, etcd_passwd, etcd_protocol)
    local opt = {
        http_host = genEtcdHosts(etcd_hosts),
        user = etcd_user,
        password = etcd_passwd,
        protocol = etcd_protocol,
        serializer = "json",  -- 默认使用json格式配置
    }
    
    local err
    etcd_cli, err = etcd.new(opt)
    if not etcd_cli then
        return err
    end

    return nil
end

function _M.get(...)
    return etcd_cli:get(...)
end

function _M.set(key, value, ttl)
    return etcd_cli:set(key, value, ttl)
end

function _M.version()
    return etcd_cli:version()
end

function _M.readdir(key, recursive)
    return etcd_cli:readdir(key, recursive)
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, command, ...)
        local f = assert(_M[command], string.format("source:%s, command:%s", skynet.address(source), command))
        if session > 0 then
            skynet.retpack(f(...))
        else
            f(...)
        end
    end)
end)
