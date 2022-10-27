local util       = require "util"
local skynet     = require "skynet"
local service    = require "skynet.service"
local sharetable = require "skynet.sharetable"

local function test_sharetable()
    local skynet     = require "skynet"
    local sharetable = require "skynet.sharetable"

    local configList = {}
    local function queryConfig(t, configName)
        local config = sharetable.query(configName)
        t[configName] = config
        return config
    end
    
    setmetatable(configList, {__index = queryConfig})
    
    local totalCount = 0
    local CMD = {}
    function CMD.doSomething()
        local count = totalCount
        local testConfig = configList["test"]
        totalCount = count + 1
    end

    function CMD.getCount()
        return totalCount
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
end

local function test_sharetable2()
    local skynet     = require "skynet"
    local sharetable = require "skynet.sharetable"

    local configList = {}
    local function queryConfig(t, configName)
        local config = sharetable.query(configName)
        t[configName] = config
        return config
    end
    
    setmetatable(configList, {__index = queryConfig})
    
    local totalCount = 0
    local CMD = {}

    function CMD.init()
        for filename, ptr in pairs(sharetable.queryall()) do
            configList[filename] = ptr
        end
    end
    
    function CMD.doSomething()
        local count = totalCount
        local testConfig = configList["test"]
        totalCount = count + 1
    end

    function CMD.getCount()
        return totalCount
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
end

local function test_sharetable3()
    local skynet     = require "skynet"
    local sharetable = require "skynet.sharetable"
    local queue      = require "skynet.queue"

    local configList = {}
    local function queryConfig(t, configName)
        local config = sharetable.query(configName)
        t[configName] = config
        return config
    end
    
    setmetatable(configList, {__index = queryConfig})
    
    local totalCount = 0
    local CMD = {}
    local doSomethingQueue = queue()
    function CMD.doSomething()
        doSomethingQueue(function()
            local count = totalCount
            local testConfig = configList["test"]
            totalCount = count + 1
        end)
    end

    function CMD.getCount()
        return totalCount
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
end

skynet.start(function()
    sharetable.loadtable("test", {content = "test content"})
    local testservice = service.new("test_sharetable", test_sharetable)
    for i = 1, 100 do
        skynet.send(testservice, "lua", "doSomething")
    end
    skynet.sleep(100)
    print("test_sharetable count is ", skynet.call(testservice, "lua", "getCount"))

    local testservice2 = service.new("test_sharetable2", test_sharetable2)
    -- 提前加载配置
    skynet.call(testservice2, "lua", "init")
    for i = 1, 100 do
        skynet.send(testservice2, "lua", "doSomething")
    end
    skynet.sleep(100)
    print("test_sharetable2 count is ", skynet.call(testservice2, "lua", "getCount"))

    local testservice3 = service.new("test_sharetable3", test_sharetable3)
    for i = 1, 100 do
        skynet.send(testservice3, "lua", "doSomething")
    end
    skynet.sleep(100)
    print("test_sharetable3 count is ", skynet.call(testservice3, "lua", "getCount"))
end)
