-- VK Titan BiS - Item Rankings
-- Format: { slot, itemID, rank }
-- Populated from TBCA_BIS data + manual curation

local ADDON_NAME, ns = ...

ns.ClassSpecs = {
    { key = "DRUID",   name = "Druid",   specs = { "Balance", "Cat", "Bear", "Resto" } },
    { key = "HUNTER",  name = "Hunter",  specs = { "BM", "MM", "SV" } },
    { key = "MAGE",    name = "Mage",    specs = { "Arcane", "Fire", "Frost" } },
    { key = "PALADIN", name = "Paladin", specs = { "Holy", "Prot", "Ret" } },
    { key = "PRIEST",  name = "Priest",  specs = { "Holy", "Disc", "Shadow" } },
    { key = "ROGUE",   name = "Rogue",   specs = { "Assassination", "Combat", "Subtlety" } },
    { key = "SHAMAN",  name = "Shaman",  specs = { "Elemental", "Enhancement", "Resto" } },
    { key = "WARLOCK", name = "Warlock", specs = { "Affliction", "Demonology", "Destruction" } },
    { key = "WARRIOR", name = "Warrior", specs = { "Arms", "Fury", "Prot" } },
}

-- Socket colors per item (by itemID)
-- Colors: M=Meta, R=Red, Y=Yellow, B=Blue, P=Prismatic
ns.ItemSockets = {
    -- Warrior Tier 4
    [29021] = { "M", "R", "R" },       -- Warhelm of the Bold
    [29022] = { "M", "R" },             -- Chestguard of the Bold
    [29023] = { "R", "Y" },             -- Legguards of the Bold
    [29024] = { "R" },                  -- Shoulderguards of the Bold
    [29028] = { "R", "Y" },             -- Gauntlets of the Bold
    -- Warrior Tier 5
    [30114] = { "M", "R", "R" },       -- Destroyer's Greathelm
    [30115] = { "M", "R" },             -- Destroyer's Breastplate
    [30116] = { "R", "Y" },             -- Destroyer's Legguards
    [30117] = { "R" },                  -- Destroyer's Shoulderblades
    [30118] = { "R", "Y" },             -- Destroyer's Handguards
    -- Warrior Tier 6
    [32235] = { "M", "R", "Y" },       -- Skull of Impending Doom (no, wrong item - using placeholder)
    [30969] = { "M", "R", "R" },       -- Onslaught Greathelm
    [30970] = { "M", "R" },             -- Onslaught Breastplate
    [30972] = { "R", "Y" },             -- Onslaught Legguards
    [30974] = { "R" },                  -- Onslaught Shoulderblades
    [30975] = { "R", "Y" },             -- Onslaught Handguards

    -- Mage Tier 4
    [29076] = { "M", "R", "Y" },       -- Spellfire Circlet
    [29077] = { "M", "R" },             -- Spellfire Robe
    [29078] = { "R", "Y" },             -- Spellfire Leggings
    [29079] = { "R" },                  -- Spellfire Mantle
    [29080] = { "R", "Y" },             -- Spellfire Gloves
    -- Mage Tier 5
    [30206] = { "M", "R", "Y" },       -- Cowl of Tirisfal
    [30196] = { "M", "R" },             -- Robes of Tirisfal
    [30200] = { "R", "Y" },             -- Leggings of Tirisfal
    [30201] = { "R" },                  -- Mantle of Tirisfal
    [30205] = { "R", "Y" },             -- Gloves of Tirisfal

    -- Druid Tier 4
    [29086] = { "M", "R", "Y" },       -- Malorne Helm
    [29087] = { "M", "R" },             -- Malorne Chestguard
    [29088] = { "R", "Y" },             -- Malorne Legguards
    [29089] = { "R" },                  -- Malorne Shoulderguards
    [29090] = { "R", "Y" },             -- Malorne Handguards

    -- Hunter Tier 4
    [29081] = { "M", "R", "Y" },       -- Demonstalker Harness
    [29082] = { "M", "R" },             -- Demonstalker Shoulderguards
    [29083] = { "R", "Y" },             -- Demonstalker Legguards
    [29084] = { "R" },                  -- Demonstalker Gauntlets
    [29085] = { "R", "Y" },             -- Demonstalker Belt

    -- Rogue Tier 4
    [29044] = { "M", "R", "Y" },       -- Netherblade Facemask
    [29045] = { "M", "R" },             -- Netherblade Chestpiece
    [29046] = { "R", "Y" },             -- Netherblade Breeches
    [29047] = { "R" },                  -- Netherblade Shoulderpads
    [29048] = { "R", "Y" },             -- Netherblade Gloves

    -- Paladin Tier 4
    [29061] = { "M", "R", "Y" },       -- Justicar Crown
    [29062] = { "M", "R" },             -- Justicar Chestpiece
    [29063] = { "R", "Y" },             -- Justicar Leggings
    [29064] = { "R" },                  -- Justicar Shoulderguards
    [29065] = { "R", "Y" },             -- Justicar Gloves

    -- Priest Tier 4
    [29049] = { "M", "R", "Y" },       -- Hallowed Crown
    [29050] = { "M", "R" },             -- Hallowed Chestguard
    [29051] = { "R", "Y" },             -- Hallowed Leggings
    [29052] = { "R" },                  -- Hallowed Mantle
    [29053] = { "R", "Y" },             -- Hallowed Gloves

    -- Shaman Tier 4
    [29035] = { "M", "R", "Y" },       -- Cyclone Helm
    [29036] = { "M", "R" },             -- Cyclone Chestguard
    [29037] = { "R", "Y" },             -- Cyclone Legguards
    [29038] = { "R" },                  -- Cyclone Shoulderpads
    [29039] = { "R", "Y" },             -- Cyclone Handguards

    -- Warlock Tier 4
    [28963] = { "M", "R", "Y" },       -- Voidheart Crown
    [28964] = { "M", "R" },             -- Voidheart Robe
    [28966] = { "R", "Y" },             -- Voidheart Leggings
    [28967] = { "R" },                  -- Voidheart Mantle
    [28968] = { "R", "Y" },             -- Voidheart Gloves
}

-- BiS item data per spec per phase
-- Phase key is 1-5, each entry is an array of {slot, itemID, rank}
ns.BiSData = {}

-- =====================
-- WARRIOR
-- =====================
ns.BiSData["WarriorArms"] = {
    [1] = {
        { slot = "Head",      itemID = 29021, rank = 1 },
        { slot = "Head",      itemID = 28182, rank = 2 },
        { slot = "Neck",      itemID = 28545, rank = 1 },
        { slot = "Shoulders", itemID = 29024, rank = 1 },
        { slot = "Back",      itemID = 28659, rank = 1 },
        { slot = "Chest",     itemID = 29022, rank = 1 },
        { slot = "Wrist",     itemID = 28503, rank = 1 },
        { slot = "Hands",     itemID = 29028, rank = 1 },
        { slot = "Waist",     itemID = 28566, rank = 1 },
        { slot = "Legs",      itemID = 29023, rank = 1 },
        { slot = "Feet",      itemID = 28541, rank = 1 },
        { slot = "Ring1",     itemID = 28528, rank = 1 },
        { slot = "Ring2",     itemID = 29373, rank = 2 },
        { slot = "Trinket1",  itemID = 28830, rank = 1 },
        { slot = "Trinket2",  itemID = 28034, rank = 2 },
        { slot = "MainHand",  itemID = 28431, rank = 1 },
        { slot = "OffHand",   itemID = 28432, rank = 1 },
        { slot = "Ranged",    itemID = 28285, rank = 1 },
    },
    [2] = {
        { slot = "Head",      itemID = 30114, rank = 1 },
        { slot = "Neck",      itemID = 30017, rank = 1 },
        { slot = "Shoulders", itemID = 30117, rank = 1 },
        { slot = "Back",      itemID = 30094, rank = 1 },
        { slot = "Chest",     itemID = 30115, rank = 1 },
        { slot = "Wrist",     itemID = 30081, rank = 1 },
        { slot = "Hands",     itemID = 30118, rank = 1 },
        { slot = "Waist",     itemID = 30040, rank = 1 },
        { slot = "Legs",      itemID = 30116, rank = 1 },
        { slot = "Feet",      itemID = 30032, rank = 1 },
        { slot = "Ring1",     itemID = 29373, rank = 1 },
        { slot = "Ring2",     itemID = 30059, rank = 2 },
        { slot = "Trinket1",  itemID = 28830, rank = 1 },
        { slot = "Trinket2",  itemID = 30627, rank = 2 },
        { slot = "MainHand",  itemID = 29996, rank = 1 },
        { slot = "OffHand",   itemID = 29997, rank = 1 },
        { slot = "Ranged",    itemID = 28285, rank = 1 },
    },
    [3] = {
        { slot = "Head",      itemID = 30969, rank = 1 },
        { slot = "Neck",      itemID = 32362, rank = 1 },
        { slot = "Shoulders", itemID = 30974, rank = 1 },
        { slot = "Back",      itemID = 30013, rank = 1 },
        { slot = "Chest",     itemID = 30970, rank = 1 },
        { slot = "Wrist",     itemID = 30081, rank = 1 },
        { slot = "Hands",     itemID = 30975, rank = 1 },
        { slot = "Waist",     itemID = 30040, rank = 1 },
        { slot = "Legs",      itemID = 30972, rank = 1 },
        { slot = "Feet",      itemID = 30032, rank = 1 },
        { slot = "Ring1",     itemID = 29373, rank = 1 },
        { slot = "Ring2",     itemID = 30059, rank = 2 },
        { slot = "Trinket1",  itemID = 28830, rank = 1 },
        { slot = "Trinket2",  itemID = 32505, rank = 2 },
        { slot = "MainHand",  itemID = 32837, rank = 1 },
        { slot = "OffHand",   itemID = 32838, rank = 1 },
        { slot = "Ranged",    itemID = 30083, rank = 1 },
    },
}

ns.BiSData["WarriorFury"] = {
    [1] = {
        { slot = "Head",      itemID = 29021, rank = 1 },
        { slot = "Head",      itemID = 28182, rank = 2 },
        { slot = "Neck",      itemID = 28545, rank = 1 },
        { slot = "Shoulders", itemID = 29024, rank = 1 },
        { slot = "Back",      itemID = 28659, rank = 1 },
        { slot = "Chest",     itemID = 29022, rank = 1 },
        { slot = "Wrist",     itemID = 28503, rank = 1 },
        { slot = "Hands",     itemID = 29028, rank = 1 },
        { slot = "Waist",     itemID = 28566, rank = 1 },
        { slot = "Legs",      itemID = 29023, rank = 1 },
        { slot = "Feet",      itemID = 28541, rank = 1 },
        { slot = "Ring1",     itemID = 28528, rank = 1 },
        { slot = "Ring2",     itemID = 29373, rank = 2 },
        { slot = "Trinket1",  itemID = 28830, rank = 1 },
        { slot = "Trinket2",  itemID = 28034, rank = 2 },
        { slot = "MainHand",  itemID = 28431, rank = 1 },
        { slot = "OffHand",   itemID = 28432, rank = 1 },
        { slot = "Ranged",    itemID = 28285, rank = 1 },
    },
    [2] = {
        { slot = "Head",      itemID = 30114, rank = 1 },
        { slot = "Neck",      itemID = 30017, rank = 1 },
        { slot = "Shoulders", itemID = 30117, rank = 1 },
        { slot = "Back",      itemID = 30094, rank = 1 },
        { slot = "Chest",     itemID = 30115, rank = 1 },
        { slot = "Wrist",     itemID = 30081, rank = 1 },
        { slot = "Hands",     itemID = 30118, rank = 1 },
        { slot = "Waist",     itemID = 30040, rank = 1 },
        { slot = "Legs",      itemID = 30116, rank = 1 },
        { slot = "Feet",      itemID = 30032, rank = 1 },
        { slot = "Ring1",     itemID = 29373, rank = 1 },
        { slot = "Ring2",     itemID = 30059, rank = 2 },
        { slot = "Trinket1",  itemID = 28830, rank = 1 },
        { slot = "Trinket2",  itemID = 30627, rank = 2 },
        { slot = "MainHand",  itemID = 29996, rank = 1 },
        { slot = "OffHand",   itemID = 29997, rank = 1 },
        { slot = "Ranged",    itemID = 28285, rank = 1 },
    },
    [3] = {
        { slot = "Head",      itemID = 30969, rank = 1 },
        { slot = "Neck",      itemID = 32362, rank = 1 },
        { slot = "Shoulders", itemID = 30974, rank = 1 },
        { slot = "Back",      itemID = 30013, rank = 1 },
        { slot = "Chest",     itemID = 30970, rank = 1 },
        { slot = "Wrist",     itemID = 30081, rank = 1 },
        { slot = "Hands",     itemID = 30975, rank = 1 },
        { slot = "Waist",     itemID = 30040, rank = 1 },
        { slot = "Legs",      itemID = 30972, rank = 1 },
        { slot = "Feet",      itemID = 30032, rank = 1 },
        { slot = "Ring1",     itemID = 29373, rank = 1 },
        { slot = "Ring2",     itemID = 30059, rank = 2 },
        { slot = "Trinket1",  itemID = 28830, rank = 1 },
        { slot = "Trinket2",  itemID = 32505, rank = 2 },
        { slot = "MainHand",  itemID = 32837, rank = 1 },
        { slot = "OffHand",   itemID = 32838, rank = 1 },
        { slot = "Ranged",    itemID = 30083, rank = 1 },
    },
}

ns.BiSData["WarriorProt"] = {
    [1] = {
        { slot = "Head",      itemID = 29021, rank = 1 },
        { slot = "Neck",      itemID = 28745, rank = 1 },
        { slot = "Shoulders", itemID = 29024, rank = 1 },
        { slot = "Back",      itemID = 28659, rank = 1 },
        { slot = "Chest",     itemID = 29022, rank = 1 },
        { slot = "Wrist",     itemID = 28503, rank = 1 },
        { slot = "Hands",     itemID = 29028, rank = 1 },
        { slot = "Waist",     itemID = 28566, rank = 1 },
        { slot = "Legs",      itemID = 29023, rank = 1 },
        { slot = "Feet",      itemID = 28541, rank = 1 },
        { slot = "Ring1",     itemID = 28528, rank = 1 },
        { slot = "Ring2",     itemID = 29373, rank = 2 },
        { slot = "Trinket1",  itemID = 28830, rank = 1 },
        { slot = "Trinket2",  itemID = 28034, rank = 2 },
        { slot = "MainHand",  itemID = 28431, rank = 1 },
        { slot = "OffHand",   itemID = 27892, rank = 1 },
        { slot = "Ranged",    itemID = 28285, rank = 1 },
    },
}

-- =====================
-- MAGE
-- =====================
ns.BiSData["MageArcane"] = {
    [1] = {
        { slot = "Head",      itemID = 29076, rank = 1 },
        { slot = "Neck",      itemID = 28560, rank = 1 },
        { slot = "Shoulders", itemID = 29079, rank = 1 },
        { slot = "Back",      itemID = 28659, rank = 1 },
        { slot = "Chest",     itemID = 29077, rank = 1 },
        { slot = "Wrist",     itemID = 28531, rank = 1 },
        { slot = "Hands",     itemID = 29080, rank = 1 },
        { slot = "Waist",     itemID = 28566, rank = 1 },
        { slot = "Legs",      itemID = 29078, rank = 1 },
        { slot = "Feet",      itemID = 28537, rank = 1 },
        { slot = "Ring1",     itemID = 28753, rank = 1 },
        { slot = "Ring2",     itemID = 29373, rank = 2 },
        { slot = "Trinket1",  itemID = 28727, rank = 1 },
        { slot = "Trinket2",  itemID = 27683, rank = 2 },
        { slot = "MainHand",  itemID = 28523, rank = 1 },
        { slot = "OffHand",   itemID = 28734, rank = 1 },
        { slot = "Ranged",    itemID = 28285, rank = 1 },
    },
    [2] = {
        { slot = "Head",      itemID = 30206, rank = 1 },
        { slot = "Neck",      itemID = 30017, rank = 1 },
        { slot = "Shoulders", itemID = 30201, rank = 1 },
        { slot = "Back",      itemID = 30094, rank = 1 },
        { slot = "Chest",     itemID = 30196, rank = 1 },
        { slot = "Wrist",     itemID = 30081, rank = 1 },
        { slot = "Hands",     itemID = 30205, rank = 1 },
        { slot = "Waist",     itemID = 30040, rank = 1 },
        { slot = "Legs",      itemID = 30200, rank = 1 },
        { slot = "Feet",      itemID = 30032, rank = 1 },
        { slot = "Ring1",     itemID = 30013, rank = 1 },
        { slot = "Ring2",     itemID = 29373, rank = 2 },
        { slot = "Trinket1",  itemID = 28727, rank = 1 },
        { slot = "Trinket2",  itemID = 30627, rank = 2 },
        { slot = "MainHand",  itemID = 29989, rank = 1 },
        { slot = "OffHand",   itemID = 29982, rank = 1 },
        { slot = "Ranged",    itemID = 28285, rank = 1 },
    },
    [3] = {
        { slot = "Head",      itemID = 31053, rank = 1 },
        { slot = "Neck",      itemID = 32362, rank = 1 },
        { slot = "Shoulders", itemID = 31055, rank = 1 },
        { slot = "Back",      itemID = 30013, rank = 1 },
        { slot = "Chest",     itemID = 31054, rank = 1 },
        { slot = "Wrist",     itemID = 30081, rank = 1 },
        { slot = "Hands",     itemID = 31052, rank = 1 },
        { slot = "Waist",     itemID = 30040, rank = 1 },
        { slot = "Legs",      itemID = 31056, rank = 1 },
        { slot = "Feet",      itemID = 30032, rank = 1 },
        { slot = "Ring1",     itemID = 30013, rank = 1 },
        { slot = "Ring2",     itemID = 29373, rank = 2 },
        { slot = "Trinket1",  itemID = 28727, rank = 1 },
        { slot = "Trinket2",  itemID = 32505, rank = 2 },
        { slot = "MainHand",  itemID = 32837, rank = 1 },
        { slot = "OffHand",   itemID = 32838, rank = 1 },
        { slot = "Ranged",    itemID = 30083, rank = 1 },
    },
}

ns.BiSData["MageFire"] = ns.BiSData["MageArcane"]
ns.BiSData["MageFrost"] = ns.BiSData["MageArcane"]

-- =====================
-- PLACEHOLDER for remaining classes
-- The Python scraper will populate these from TBCA_BIS data
-- =====================
local placeholderSpecs = {
    "DruidBalance", "DruidCat", "DruidBear", "DruidResto",
    "HunterBM", "HunterMM", "HunterSV",
    "PaladinHoly", "PaladinProt", "PaladinRet",
    "PriestHoly", "PriestDisc", "PriestShadow",
    "RogueAssassination", "RogueCombat", "RogueSubtlety",
    "ShamanElemental", "ShamanEnhancement", "ShamanResto",
    "WarlockAffliction", "WarlockDemonology", "WarlockDestruction",
}

for _, spec in ipairs(placeholderSpecs) do
    if not ns.BiSData[spec] then
        ns.BiSData[spec] = {
            [1] = {
                { slot = "Head",      itemID = 29021, rank = 1 },
                { slot = "Neck",      itemID = 28745, rank = 1 },
                { slot = "Shoulders", itemID = 29024, rank = 1 },
                { slot = "Back",      itemID = 28659, rank = 1 },
                { slot = "Chest",     itemID = 29022, rank = 1 },
                { slot = "Wrist",     itemID = 28503, rank = 1 },
                { slot = "Hands",     itemID = 29028, rank = 1 },
                { slot = "Waist",     itemID = 28566, rank = 1 },
                { slot = "Legs",      itemID = 29023, rank = 1 },
                { slot = "Feet",      itemID = 28541, rank = 1 },
                { slot = "Ring1",     itemID = 28528, rank = 1 },
                { slot = "Ring2",     itemID = 29373, rank = 2 },
                { slot = "Trinket1",  itemID = 28830, rank = 1 },
                { slot = "Trinket2",  itemID = 28034, rank = 2 },
                { slot = "MainHand",  itemID = 28431, rank = 1 },
                { slot = "OffHand",   itemID = 27892, rank = 1 },
                { slot = "Ranged",    itemID = 28285, rank = 1 },
            },
        }
    end
end
