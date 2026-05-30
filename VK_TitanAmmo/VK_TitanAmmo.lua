-- VK Titan Ammo Plugin

local plugin = {}
plugin.text = "Ammo"

local frame = CreateFrame("Frame")

local scanTip = CreateFrame("GameTooltip", "VK_TitanAmmoScanTip", nil, "GameTooltipTemplate")
scanTip:SetOwner(UIParent, "ANCHOR_NONE")

function plugin:OnLoad()
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("BAG_UPDATE")
    frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
end

frame:SetScript("OnEvent", function(self, event, unit)
    if event == "UNIT_INVENTORY_CHANGED" and unit ~= "player" then return end
    plugin:Update()
end)

local function GetContainerSlotCount(bagSlot)
    scanTip:ClearLines()
    scanTip:SetInventoryItem("player", bagSlot)

    for i = 1, scanTip:NumLines() do
        local text = _G["VK_TitanAmmoScanTipTextLeft" .. i]:GetText()
        if text then
            local slots = text:match("(%d+)%s+Slot%s+Quiver")
            if slots then return tonumber(slots) end

            local slots2 = text:match("(%d+)%s+Slot%s+Ammo%s+Pouch")
            if slots2 then return tonumber(slots2) end
        end
    end

    return nil
end

local function GetAmmoInfo()
    local ammo = GetInventoryItemCount("player", 0)
    local ammoItemID = GetInventoryItemID("player", 0)

    local icon = "Interface\\Icons\\INV_Ammo_Arrow_02"

    local ranged = GetInventoryItemLink("player", 18)
    if ranged then
        local _, _, _, _, _, _, subType = GetItemInfo(ranged)
        if subType == "Guns" then
            icon = "Interface\\Icons\\INV_Ammo_Bullet_02"
        elseif subType == "Thrown" then
            icon = "Interface\\Icons\\INV_ThrowingKnife_02"
        end
    end

    local _, _, _, _, _, _, _, stackSize = GetItemInfo(ammoItemID)
    if not stackSize or stackSize == 0 then
        stackSize = 200
    end

    local maxCap = 0
    for bagSlot = 20, 23 do
        local slots = GetContainerSlotCount(bagSlot)
        if slots then
            maxCap = slots * stackSize
            break
        end
    end

    return ammo, maxCap, icon
end

local function Colorize(ammo, maxCap)
    if maxCap > 0 then
        local pct = (ammo / maxCap) * 100

        if pct >= 66 then
            return "|cff00ff00" .. ammo .. "|r"
        elseif pct >= 33 then
            return "|cffffff00" .. ammo .. "|r"
        elseif pct >= 10 then
            return "|cffffa500" .. ammo .. "|r"
        else
            return "|cffff0000" .. ammo .. "|r"
        end
    end

    return tostring(ammo)
end

function plugin:Update()
    local ammo, maxCap, icon = GetAmmoInfo()
    local colored = Colorize(ammo, maxCap)

    if maxCap > 0 then
        self.text = "|T" .. icon .. ":14:14:0:0|t " .. colored .. " / " .. maxCap
    else
        self.text = "|T" .. icon .. ":14:14:0:0|t " .. colored
    end
end

function plugin:OnTooltipShow()
    local ammo, maxCap, icon = GetAmmoInfo()

    GameTooltip:AddLine("Ammo", 1, 1, 1)
    GameTooltip:AddLine(" ")

    local text = maxCap > 0 and (ammo .. " / " .. maxCap) or tostring(ammo)

    GameTooltip:AddDoubleLine(
        "|T" .. icon .. ":16:16:0:0|t Ammo",
        text,
        1, 1, 1,
        1, 0.82, 0
    )
end

VK_TitanClassic:RegisterPlugin("VK_TitanAmmo", plugin)
