local util    = require "util"
local skynet  = require "skynet"
local service = require "skynet.service"
local swt     = require "swt"

local function cost_cpu()
    local skynet = require "skynet"

    local function execRandom()
        for i = 1, 100000000 do
            randomV = math.random(1, i)
        end
    end
    
    local function execTableConcat()
        local arr = {}
        for i = 1, 10000000 do
            table.insert(arr, i)
        end
        table.concat(arr, " ")
    end
    
    skynet.start(function()
        skynet.dispatch("lua", function()
            local randomV
            for j = 1, 100 do
                execRandom()
                execTableConcat()
                skynet.yield()
                print("exec random", j)
            end
        end)
    end)
end

skynet.start(function()
    swt.start_master("0.0.0.0:11001")
    swt.start_agent("app", "node1", "127.0.0.1:11002")

    local costservice = service.new("cost_cpu", cost_cpu)
    skynet.send(costservice, "lua", "test")
end)
