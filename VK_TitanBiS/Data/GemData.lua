-- VK Titan BiS - Gem Recommendations
-- Per-spec gem choices: BiS and Budget options for each socket color

local ADDON_NAME, ns = ...

ns.GemData = {
    -- =====================
    -- WARRIOR
    -- =====================
    ["WarriorArms"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Inscribed Noble Topaz" },    budget = { id = 28217, name = "Inscribed Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },
    ["WarriorFury"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Inscribed Noble Topaz" },    budget = { id = 28217, name = "Inscribed Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },
    ["WarriorProt"] = {
        meta = { id = 25896, name = "Powerful Earthstorm Diamond", req = "3 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Subtle Living Ruby" },       budget = { id = 28118, name = "Subtle Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Thick Dawnstone" },          budget = { id = 28221, name = "Thick Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Solid Star of Elune" },      budget = { id = 28119, name = "Solid Azure Moonstone" } },
            Orange = { bis = { id = 27786, name = "Enduring Noble Topaz" },     budget = { id = 28217, name = "Enduring Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Sovereign Nightseye" },      budget = { id = 28119, name = "Sovereign Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Jagged Talasite" },          budget = { id = 28217, name = "Jagged Deep Peridot" } },
        },
    },

    -- =====================
    -- DRUID
    -- =====================
    ["DruidBalance"] = {
        meta = { id = 34220, name = "Chaotic Skyfire Diamond", req = "2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Potent Noble Topaz" },       budget = { id = 28221, name = "Potent Flame Spessarite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Veiled Noble Topaz" },       budget = { id = 28217, name = "Veiled Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Potent Noble Topaz" },       budget = { id = 28217, name = "Potent Flame Spessarite" } },
        },
    },
    ["DruidCat"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Delicate Living Ruby" },     budget = { id = 28118, name = "Delicate Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Balanced Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },
    ["DruidBear"] = {
        meta = { id = 25896, name = "Powerful Earthstorm Diamond", req = "3 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Subtle Living Ruby" },       budget = { id = 28118, name = "Subtle Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Thick Dawnstone" },          budget = { id = 28221, name = "Thick Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Solid Star of Elune" },      budget = { id = 28119, name = "Solid Azure Moonstone" } },
            Orange = { bis = { id = 27786, name = "Enduring Noble Topaz" },     budget = { id = 28217, name = "Enduring Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Sovereign Nightseye" },      budget = { id = 28119, name = "Sovereign Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Jagged Talasite" },          budget = { id = 28217, name = "Jagged Deep Peridot" } },
        },
    },
    ["DruidResto"] = {
        meta = { id = 25901, name = "Insightful Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Teardrop Living Ruby" },     budget = { id = 28118, name = "Teardrop Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Brilliant Dawnstone" },      budget = { id = 28221, name = "Brilliant Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Lustrous Star of Elune" },   budget = { id = 28119, name = "Lustrous Azure Moonstone" } },
            Orange = { bis = { id = 27786, name = "Dazzling Noble Topaz" },     budget = { id = 28217, name = "Dazzling Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Royal Nightseye" },          budget = { id = 28119, name = "Royal Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Dazzling Noble Topaz" },     budget = { id = 28217, name = "Dazzling Flame Spessarite" } },
        },
    },

    -- =====================
    -- HUNTER
    -- =====================
    ["HunterBM"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Delicate Living Ruby" },     budget = { id = 28118, name = "Delicate Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Balanced Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },
    ["HunterMM"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Delicate Living Ruby" },     budget = { id = 28118, name = "Delicate Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Balanced Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },
    ["HunterSV"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Delicate Living Ruby" },     budget = { id = 28118, name = "Delicate Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Balanced Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },

    -- =====================
    -- MAGE
    -- =====================
    ["MageArcane"] = {
        meta = { id = 34220, name = "Chaotic Skyfire Diamond", req = "2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Potent Noble Topaz" },       budget = { id = 28221, name = "Potent Flame Spessarite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Veiled Noble Topaz" },       budget = { id = 28217, name = "Veiled Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Potent Noble Topaz" },       budget = { id = 28217, name = "Potent Flame Spessarite" } },
        },
    },
    ["MageFire"] = {
        meta = { id = 34220, name = "Chaotic Skyfire Diamond", req = "2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Potent Noble Topaz" },       budget = { id = 28221, name = "Potent Flame Spessarite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Veiled Noble Topaz" },       budget = { id = 28217, name = "Veiled Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Potent Noble Topaz" },       budget = { id = 28217, name = "Potent Flame Spessarite" } },
        },
    },
    ["MageFrost"] = {
        meta = { id = 34220, name = "Chaotic Skyfire Diamond", req = "2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Potent Noble Topaz" },       budget = { id = 28221, name = "Potent Flame Spessarite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Veiled Noble Topaz" },       budget = { id = 28217, name = "Veiled Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Potent Noble Topaz" },       budget = { id = 28217, name = "Potent Flame Spessarite" } },
        },
    },

    -- =====================
    -- PALADIN
    -- =====================
    ["PaladinHoly"] = {
        meta = { id = 25901, name = "Insightful Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Teardrop Living Ruby" },     budget = { id = 28118, name = "Teardrop Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Brilliant Dawnstone" },      budget = { id = 28221, name = "Brilliant Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Lustrous Star of Elune" },   budget = { id = 28119, name = "Lustrous Azure Moonstone" } },
            Orange = { bis = { id = 27786, name = "Dazzling Noble Topaz" },     budget = { id = 28217, name = "Dazzling Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Royal Nightseye" },          budget = { id = 28119, name = "Royal Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Dazzling Noble Topaz" },     budget = { id = 28217, name = "Dazzling Flame Spessarite" } },
        },
    },
    ["PaladinProt"] = {
        meta = { id = 25896, name = "Powerful Earthstorm Diamond", req = "3 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Subtle Living Ruby" },       budget = { id = 28118, name = "Subtle Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Thick Dawnstone" },          budget = { id = 28221, name = "Thick Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Solid Star of Elune" },      budget = { id = 28119, name = "Solid Azure Moonstone" } },
            Orange = { bis = { id = 27786, name = "Enduring Noble Topaz" },     budget = { id = 28217, name = "Enduring Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Sovereign Nightseye" },      budget = { id = 28119, name = "Sovereign Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Jagged Talasite" },          budget = { id = 28217, name = "Jagged Deep Peridot" } },
        },
    },
    ["PaladinRet"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Balanced Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Inscribed Noble Topaz" },    budget = { id = 28217, name = "Inscribed Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },

    -- =====================
    -- PRIEST
    -- =====================
    ["PriestHoly"] = {
        meta = { id = 25901, name = "Insightful Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Teardrop Living Ruby" },     budget = { id = 28118, name = "Teardrop Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Brilliant Dawnstone" },      budget = { id = 28221, name = "Brilliant Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Lustrous Star of Elune" },   budget = { id = 28119, name = "Lustrous Azure Moonstone" } },
            Orange = { bis = { id = 27786, name = "Dazzling Noble Topaz" },     budget = { id = 28217, name = "Dazzling Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Royal Nightseye" },          budget = { id = 28119, name = "Royal Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Dazzling Noble Topaz" },     budget = { id = 28217, name = "Dazzling Flame Spessarite" } },
        },
    },
    ["PriestDisc"] = {
        meta = { id = 25901, name = "Insightful Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Teardrop Living Ruby" },     budget = { id = 28118, name = "Teardrop Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Brilliant Dawnstone" },      budget = { id = 28221, name = "Brilliant Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Lustrous Star of Elune" },   budget = { id = 28119, name = "Lustrous Azure Moonstone" } },
            Orange = { bis = { id = 27786, name = "Dazzling Noble Topaz" },     budget = { id = 28217, name = "Dazzling Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Royal Nightseye" },          budget = { id = 28119, name = "Royal Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Dazzling Noble Topaz" },     budget = { id = 28217, name = "Dazzling Flame Spessarite" } },
        },
    },
    ["PriestShadow"] = {
        meta = { id = 34220, name = "Chaotic Skyfire Diamond", req = "2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Potent Noble Topaz" },       budget = { id = 28221, name = "Potent Flame Spessarite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Veiled Noble Topaz" },       budget = { id = 28217, name = "Veiled Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Potent Noble Topaz" },       budget = { id = 28217, name = "Potent Flame Spessarite" } },
        },
    },

    -- =====================
    -- ROGUE
    -- =====================
    ["RogueAssassination"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Delicate Living Ruby" },     budget = { id = 28118, name = "Delicate Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Balanced Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },
    ["RogueCombat"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Delicate Living Ruby" },     budget = { id = 28118, name = "Delicate Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Balanced Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },
    ["RogueSubtlety"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Delicate Living Ruby" },     budget = { id = 28118, name = "Delicate Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Balanced Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },

    -- =====================
    -- SHAMAN
    -- =====================
    ["ShamanElemental"] = {
        meta = { id = 34220, name = "Chaotic Skyfire Diamond", req = "2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Potent Noble Topaz" },       budget = { id = 28221, name = "Potent Flame Spessarite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Veiled Noble Topaz" },       budget = { id = 28217, name = "Veiled Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Potent Noble Topaz" },       budget = { id = 28217, name = "Potent Flame Spessarite" } },
        },
    },
    ["ShamanEnhancement"] = {
        meta = { id = 32409, name = "Relentless Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Delicate Living Ruby" },     budget = { id = 28118, name = "Delicate Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Smooth Dawnstone" },         budget = { id = 28221, name = "Smooth Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Balanced Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Shifting Nightseye" },       budget = { id = 28119, name = "Shifting Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Glinting Noble Topaz" },     budget = { id = 28217, name = "Glinting Flame Spessarite" } },
        },
    },
    ["ShamanResto"] = {
        meta = { id = 25901, name = "Insightful Earthstorm Diamond", req = "2 Red, 2 Yellow, 2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Teardrop Living Ruby" },     budget = { id = 28118, name = "Teardrop Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Brilliant Dawnstone" },      budget = { id = 28221, name = "Brilliant Golden Draenite" } },
            Blue   = { bis = { id = 28120, name = "Lustrous Star of Elune" },   budget = { id = 28119, name = "Lustrous Azure Moonstone" } },
            Orange = { bis = { id = 27786, name = "Dazzling Noble Topaz" },     budget = { id = 28217, name = "Dazzling Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Royal Nightseye" },          budget = { id = 28119, name = "Royal Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Dazzling Noble Topaz" },     budget = { id = 28217, name = "Dazzling Flame Spessarite" } },
        },
    },

    -- =====================
    -- WARLOCK
    -- =====================
    ["WarlockAffliction"] = {
        meta = { id = 34220, name = "Chaotic Skyfire Diamond", req = "2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Potent Noble Topaz" },       budget = { id = 28221, name = "Potent Flame Spessarite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Veiled Noble Topaz" },       budget = { id = 28217, name = "Veiled Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Potent Noble Topaz" },       budget = { id = 28217, name = "Potent Flame Spessarite" } },
        },
    },
    ["WarlockDemonology"] = {
        meta = { id = 34220, name = "Chaotic Skyfire Diamond", req = "2 Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Potent Noble Topaz" },       budget = { id = 28221, name = "Potent Flame Spessarite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Veiled Noble Topaz" },       budget = { id = 28217, name = "Veiled Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Potent Noble Topaz" },       budget = { id = 28217, name = "Potent Flame Spessarite" } },
        },
    },
    ["WarlockDestruction"] = {
        meta = { id = 25897, name = "Bracing Earthstorm Diamond", req = "More Red than Blue" },
        gems = {
            Red    = { bis = { id = 27812, name = "Runed Living Ruby" },        budget = { id = 28118, name = "Runed Blood Garnet" } },
            Yellow = { bis = { id = 27777, name = "Potent Noble Topaz" },       budget = { id = 28221, name = "Potent Flame Spessarite" } },
            Blue   = { bis = { id = 28120, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Orange = { bis = { id = 27786, name = "Veiled Noble Topaz" },       budget = { id = 28217, name = "Veiled Flame Spessarite" } },
            Purple = { bis = { id = 28121, name = "Glowing Nightseye" },        budget = { id = 28119, name = "Glowing Shadow Draenite" } },
            Green  = { bis = { id = 27781, name = "Potent Noble Topaz" },       budget = { id = 28217, name = "Potent Flame Spessarite" } },
        },
    },
}
