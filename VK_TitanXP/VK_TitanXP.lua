-- VK Titan XP Plugin

local plugin = {}
plugin.percent = 0
plugin.current = 0
plugin.max = 0
plugin.rested = 0

local XP_ICON = "Interface\\Icons\\INV_Enchant_ShipmentMagicValue"

local frame = CreateFrame("Frame")

function plugin:OnLoad()
    frame:RegisterEvent("PLAYER_XP_UPDATE")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("UPDATE_EXHAUSTION")
    frame:RegisterEvent("PLAYER_LEVEL_UP")
end

frame:SetScript("OnEvent", function(self, event)
    plugin:Update()
end)

function plugin:Update()
    local current = UnitXP("player")
    local max = UnitXPMax("player")
    local rested = GetXPExhaustion() or 0

    self.current = current
    self.max = max
    self.rested = rested

    local level = UnitLevel("player")

    if level >= 70 then
        self.percent = 100
        self.text = "|T" .. XP_ICON .. ":14:14:0:0|t |cff00ff00Max Level|r"
        return
    end

    if max > 0 then
        self.percent = floor((current / max) * 100)
    else
        self.percent = 0
    end

    if rested > 0 and max > 0 then
        self.text = string.format("|T" .. XP_ICON .. ":14:14:0:0|t %d%% (+%d%% rested)",
            self.percent,
            floor((rested / max) * 100)
        )
    else
        self.text = string.format("|T" .. XP_ICON .. ":14:14:0:0|t %d%%", self.percent)
    end
end

function plugin:OnTooltipShow()
    local level = UnitLevel("player")

    GameTooltip:AddLine("Experience", 1, 1, 1)
    GameTooltip:AddLine(" ")

    if level >= 70 then
        GameTooltip:AddLine("Max Level (70)", 0, 1, 0)
        return
    end

    local current = self.current
    local max = self.max
    local rested = self.rested

    GameTooltip:AddDoubleLine("Level", tostring(level), 1, 1, 1, 1, 0.82, 0)
    GameTooltip:AddDoubleLine("XP", current .. " / " .. max, 1, 1, 1, 1, 0.82, 0)
    GameTooltip:AddDoubleLine("Progress", self.percent .. "%", 1, 1, 1, 1, 0.82, 0)

    if rested > 0 then
        GameTooltip:AddLine(" ")
        local restedPct = max > 0 and floor((rested / max) * 100) or 0
        GameTooltip:AddDoubleLine("Rested XP", rested .. " (+" .. restedPct .. "%)", 1, 1, 1, 1, 1, 0)
    end
end

VK_TitanClassic:RegisterPlugin("VK_TitanXP", plugin)
