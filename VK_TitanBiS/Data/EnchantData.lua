-- VK Titan BiS - Enchant Recommendations
-- Per-spec enchant choices for each equipment slot

local ADDON_NAME, ns = ...

ns.EnchantData = {
    -- =====================
    -- PHYSICAL DPS (Rogue, Hunter, Fury Warrior, Cat Druid, Enhancement Shaman, Ret Paladin)
    -- =====================
    ["PhysicalDPS"] = {
        Head      = { id = 27961, name = "Arcanum of Agility" },
        Shoulders = { id = 29790, name = "Greater Inscription of the Blade" },
        Back      = { id = 34004, name = "Enchant Cloak - Agility" },
        Chest     = { id = 27960, name = "Enchant Chest - Exceptional Stats" },
        Wrist     = { id = 27914, name = "Enchant Bracer - Major Agility" },
        Hands     = { id = 27920, name = "Enchant Gloves - Assault" },
        Legs      = { id = 29523, name = "Cobrahide Leg Armor" },
        Feet      = { id = 27954, name = "Enchant Boots - Dexterity" },
        MainHand  = { id = 27968, name = "Enchant Weapon - Mongoose" },
        OffHand   = { id = 27968, name = "Enchant Weapon - Mongoose" },
        TwoHand   = { id = 27968, name = "Enchant Weapon - Mongoose" },
        Ring1     = { id = 27927, name = "Enchant Ring - Striking" },
        Ring2     = { id = 27927, name = "Enchant Ring - Striking" },
    },

    -- =====================
    -- TANK (Prot Warrior, Bear Druid, Prot Paladin)
    -- =====================
    ["Tank"] = {
        Head      = { id = 27945, name = "Arcanum of the Sentinel" },
        Shoulders = { id = 29787, name = "Greater Inscription of the Knight" },
        Back      = { id = 25084, name = "Enchant Cloak - Greater Nature Resistance" },
        Chest     = { id = 27960, name = "Enchant Chest - Exceptional Stats" },
        Wrist     = { id = 27914, name = "Enchant Bracer - Major Agility" },
        Hands     = { id = 27920, name = "Enchant Gloves - Assault" },
        Legs      = { id = 29524, name = "Clefthide Leg Armor" },
        Feet      = { id = 27954, name = "Enchant Boots - Dexterity" },
        MainHand  = { id = 27946, name = "Enchant Weapon - Major Spirit" },
        OffHand   = { id = 27961, name = "Enchant Shield - Major Stamina" },
        TwoHand   = { id = 27968, name = "Enchant Weapon - Mongoose" },
        Ring1     = { id = 27927, name = "Enchant Ring - Striking" },
        Ring2     = { id = 27927, name = "Enchant Ring - Striking" },
    },

    -- =====================
    -- SPELL DPS (Mage, Warlock, Shadow Priest, Balance Druid, Elemental Shaman)
    -- =====================
    ["SpellDPS"] = {
        Head      = { id = 27958, name = "Arcanum of the Flame" },
        Shoulders = { id = 29789, name = "Greater Inscription of the Orb" },
        Back      = { id = 34003, name = "Enchant Cloak - Spell Penetration" },
        Chest     = { id = 27960, name = "Enchant Chest - Exceptional Stats" },
        Wrist     = { id = 27914, name = "Enchant Bracer - Spellpower" },
        Hands     = { id = 27920, name = "Enchant Gloves - Spellstrike" },
        Legs      = { id = 29525, name = "Netherscale Leg Armor" },
        Feet      = { id = 27954, name = "Enchant Boots - Vitality" },
        MainHand  = { id = 27968, name = "Enchant Weapon - Major Spellpower" },
        OffHand   = { id = 27961, name = "Enchant Weapon - Sunfire" },
        TwoHand   = { id = 27968, name = "Enchant 2H Weapon - Major Spellpower" },
        Ring1     = { id = 27927, name = "Enchant Ring - Spellpower" },
        Ring2     = { id = 27927, name = "Enchant Ring - Spellpower" },
    },

    -- =====================
    -- HEALER (Holy Paladin, Resto Druid, Holy Priest, Resto Shaman)
    -- =====================
    ["Healer"] = {
        Head      = { id = 27958, name = "Arcanum of the Flame" },
        Shoulders = { id = 29789, name = "Greater Inscription of the Orb" },
        Back      = { id = 34003, name = "Enchant Cloak - Spell Penetration" },
        Chest     = { id = 27960, name = "Enchant Chest - Exceptional Stats" },
        Wrist     = { id = 27914, name = "Enchant Bracer - Spellpower" },
        Hands     = { id = 27920, name = "Enchant Gloves - Spellstrike" },
        Legs      = { id = 29525, name = "Netherscale Leg Armor" },
        Feet      = { id = 27954, name = "Enchant Boots - Vitality" },
        MainHand  = { id = 27968, name = "Enchant Weapon - Major Healing" },
        OffHand   = { id = 27961, name = "Enchant Weapon - Major Healing" },
        TwoHand   = { id = 27968, name = "Enchant 2H Weapon - Major Healing" },
        Ring1     = { id = 27927, name = "Enchant Ring - Healing Power" },
        Ring2     = { id = 27927, name = "Enchant Ring - Healing Power" },
    },

    -- =====================
    -- FERAL DRUID (shared tank/DPS)
    -- =====================
    ["FeralDPS"] = {
        Head      = { id = 27961, name = "Arcanum of Agility" },
        Shoulders = { id = 29790, name = "Greater Inscription of the Blade" },
        Back      = { id = 34004, name = "Enchant Cloak - Agility" },
        Chest     = { id = 27960, name = "Enchant Chest - Exceptional Stats" },
        Wrist     = { id = 27914, name = "Enchant Bracer - Major Agility" },
        Hands     = { id = 27920, name = "Enchant Gloves - Assault" },
        Legs      = { id = 29523, name = "Cobrahide Leg Armor" },
        Feet      = { id = 27954, name = "Enchant Boots - Dexterity" },
        MainHand  = { id = 27968, name = "Enchant Weapon - Mongoose" },
        OffHand   = {},
        TwoHand   = { id = 27968, name = "Enchant Weapon - Mongoose" },
        Ring1     = {},
        Ring2     = {},
    },
}

-- Map spec keys to enchant categories
ns.SpecToEnchantCategory = {
    -- Warrior
    ["WarriorArms"]     = "PhysicalDPS",
    ["WarriorFury"]     = "PhysicalDPS",
    ["WarriorProt"]     = "Tank",
    -- Druid
    ["DruidBalance"]    = "SpellDPS",
    ["DruidCat"]        = "FeralDPS",
    ["DruidBear"]       = "Tank",
    ["DruidResto"]      = "Healer",
    -- Hunter
    ["HunterBM"]        = "PhysicalDPS",
    ["HunterMM"]        = "PhysicalDPS",
    ["HunterSV"]        = "PhysicalDPS",
    -- Mage
    ["MageArcane"]      = "SpellDPS",
    ["MageFire"]        = "SpellDPS",
    ["MageFrost"]       = "SpellDPS",
    -- Paladin
    ["PaladinHoly"]     = "Healer",
    ["PaladinProt"]     = "Tank",
    ["PaladinRet"]      = "PhysicalDPS",
    -- Priest
    ["PriestHoly"]      = "Healer",
    ["PriestDisc"]      = "Healer",
    ["PriestShadow"]    = "SpellDPS",
    -- Rogue
    ["RogueAssassination"] = "PhysicalDPS",
    ["RogueCombat"]     = "PhysicalDPS",
    ["RogueSubtlety"]   = "PhysicalDPS",
    -- Shaman
    ["ShamanElemental"]   = "SpellDPS",
    ["ShamanEnhancement"] = "PhysicalDPS",
    ["ShamanResto"]       = "Healer",
    -- Warlock
    ["WarlockAffliction"]   = "SpellDPS",
    ["WarlockDemonology"]   = "SpellDPS",
    ["WarlockDestruction"]  = "SpellDPS",
}
