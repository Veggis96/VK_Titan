-- VK Titan Classic Engine

VK_TitanClassic = {}
VK_TitanClassic.plugins = {}

-- Forward plugins to VK_Titan core
setmetatable(VK_TitanClassic.plugins, {
    __newindex = function(t, key, value)
        rawset(t, key, value)
        if VK_Titan and VK_Titan.RegisterPlugin then
            VK_Titan:RegisterPlugin(key, value)
        end
    end
})

-- Register a plugin
function VK_TitanClassic:RegisterPlugin(name, plugin)
    VK_TitanClassic.plugins[name] = plugin
end
