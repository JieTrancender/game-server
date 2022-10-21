local _M = {}

-- 增加搜索路径
function _M.add_path(path)
    package.path = package.path .. ";" .. path
end

function _M.genClusterName(nodeList)
end

return _M
