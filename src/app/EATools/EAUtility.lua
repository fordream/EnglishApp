EAUtility = {}

EAUtility.CSB_NODE = function(rootnode,name)
    local node = nil
    if rootnode and name then
        node = rootnode:getChildByName(name)
    end
    return node
end

return EAUtility