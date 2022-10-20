root = "./"

DEBUG = true
project_name = "examples"
thread = 8
harbor = 0
start = "mysqlcluster_2"
bootstrap = "snlua bootstrap"
luaservice = root.."service/?.lua;"..root.."skynet/service/?.lua;"..root..project_name.."/?.lua"
lualoader = root.."skynet/lualib/loader.lua"
cpath = root.."skynet/cservice/?.so;"..root.."cservice/?.so"
lua_cpath = root.."luaclib/?.so;"..root.."skynet/luaclib/?.so"
lua_path = root.."lualib/?.lua;"..root..project_name.."/?.lua;"..root.."skynet/lualib/?.lua;"..root.."skynet/lualib/skynet/?.lua"
snax = root.."service/?.lua;"..root.."skynet/service/?.lua"
