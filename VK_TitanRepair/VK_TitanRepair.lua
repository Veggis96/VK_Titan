-- VK Titan Repair Plugin

local plugin = {}
plugin.text = "Repair"

local frame = CreateFrame("Frame")

local SLOT_NAMES = {
    [1]  = "HeadSlot",
    [2]  = "NeckSlot",
    [3]  = "ShoulderSlot",
    [4]  = "ShirtSlot",
    [5]  = "ChestSlot",
    [6]  = "WaistSlot",
    [7]  = "LegsSlot",
    [8]  = "FeetSlot",
    [9]  = "WristSlot",
    [10] = "HandsSlot",
    [11] = "Finger0Slot",
    [12] = "Finger1Slot",
    [13] = "Trinket0Slot",
    [14] = "Trinket1Slot",
    [15] = "BackSlot",
    [16] = "MainHandSlot",
    [17] = "SecondaryHandSlot",
    [18] = "RangedSlot",
}

local function FormatGold(copper)
    local gold = floor(copper / 10000)
    local silver = floor((copper % 10000) / 100)
    local rem = copper % 100
    return string.format("%dg %ds %dc", gold, silver, rem)
end

local function GetDurability()
    local lowest = 100
    for slot = 1, 18 do
        local cur, max = GetInventoryItemDurability(slot)
        if cur and max and max > 0 then
            local pct = (cur / max) * 100
            if pct < lowest then lowest = pct end
        end
    end
    return floor(lowest)
end

local scanTool = CreateFrame("GameTooltip", "VK_TitanRepairScan", nil, "GameTooltipTemplate")
scanTool:SetOwner(UIParent, "ANCHOR_NONE")

local function GetRepairCost(slot)
    scanTool:ClearLines()
    local _, _, repairCost = scanTool:SetInventoryItem("player", slot)
    return repairCost or 0
end

local function GetTotalRepairCost()
    local total = 0
    for slot = 1, 18 do
        local cost = GetRepairCost(slot)
        if cost > 0 then total = total + cost end
    end
    return total
end

local function Colorize(text, pct)
    if pct >= 100 then
        return "|cff00ff00" .. text .. "|r"
    elseif pct >= 66 then
        return "|cffffff00" .. text .. "|r"
    elseif pct >= 33 then
        return "|cffffa500" .. text .. "|r"
    else
        return "|cffff0000" .. text .. "|r"
    end
end

function plugin:OnLoad()
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
    frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
end

frame:SetScript("OnEvent", function(self, event)
    plugin:Update()
    VK_Titan:RefreshBar()
end)

function plugin:Update()
    local durability = GetDurability()
    local cost = GetTotalRepairCost()

    local durText = Colorize(durability .. "%", durability)

    if cost > 0 then
        self.text = string.format("%s (%s)", durText, FormatGold(cost))
    else
        self.text = durText
    end
end

function plugin:OnTooltipShow()
    GameTooltip:AddLine("Repair Details", 1, 1, 1)
    GameTooltip:AddLine(" ")

    local totalCost = 0

    for slot = 1, 18 do
        local itemLink = GetInventoryItemLink("player", slot)
        if itemLink then
            local slotName = SLOT_NAMES[slot] or ("Slot " .. slot)

            local cur, max = GetInventoryItemDurability(slot)
            local pct = cur and max and max > 0 and floor((cur / max) * 100) or 0

            local repairCost = GetRepairCost(slot)
            if repairCost > 0 then totalCost = totalCost + repairCost end

            local costText = repairCost > 0 and FormatGold(repairCost) or "-"

            local icon = GetInventoryItemTexture("player", slot)
            local iconText = icon and ("|T" .. icon .. ":16:16:0:0|t ") or ""

            GameTooltip:AddDoubleLine(
                iconText .. slotName,
                string.format("%d%%   %s", pct, costText),
                1, 1, 1,
                1, 0.82, 0
            )
        end
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("Total Repair Cost", FormatGold(totalCost), 1, 1, 1, 1, 0.8, 0)
end

VK_TitanClassic:RegisterPlugin("VK_TitanRepair", plugin)
