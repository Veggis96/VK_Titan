-- VK Titan XP Plugin

local plugin = {}
plugin.percent = 0
plugin.current = 0
plugin.max = 0
plugin.rested = 0
plugin.sessionXP = 0
plugin.xpPerHour = 0

local XP_ICON = "Interface\\Icons\\INV_Enchant_ShipmentMagicValue"

local sessionStartTime = 0
local sessionXP = 0
local lastLevel = nil
local lastXP = nil
local lastXPMax = nil
local updateElapsed = 0

local frame = CreateFrame("Frame")

local function FormatXP(amount)
    amount = floor(amount or 0)
    if amount >= 1000000 then
        return string.format("%.1fm", amount / 1000000)
    elseif amount >= 10000 then
        return string.format("%.1fk", amount / 1000)
    end
    return tostring(amount)
end

local function GetElapsed()
    if sessionStartTime == 0 then return 0 end
    return max(0, time() - sessionStartTime)
end

local function CaptureSessionDelta()
    local level = UnitLevel("player")
    local current = UnitXP("player")
    local maxXP = UnitXPMax("player")

    if sessionStartTime == 0 then
        sessionStartTime = time()
        lastLevel = level
        lastXP = current
        lastXPMax = maxXP
        return
    end

    if lastLevel and lastXP and lastXPMax then
        local gained = 0
        if level == lastLevel then
            gained = current - lastXP
        elseif level > lastLevel then
            gained = max(0, lastXPMax - lastXP) + current
        end

        if gained > 0 then
            sessionXP = sessionXP + gained
        end
    end

    lastLevel = level
    lastXP = current
    lastXPMax = maxXP
end

function plugin:OnLoad()
    frame:RegisterEvent("PLAYER_XP_UPDATE")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("UPDATE_EXHAUSTION")
    frame:RegisterEvent("PLAYER_LEVEL_UP")
end

frame:SetScript("OnEvent", function(self, event)
    CaptureSessionDelta()
    plugin:Update()
    VK_Titan:RefreshBar()
end)

frame:SetScript("OnUpdate", function(self, elapsed)
    updateElapsed = updateElapsed + elapsed
    if updateElapsed >= 30 then
        updateElapsed = 0
        plugin:Update()
        VK_Titan:RefreshBar()
    end
end)

function plugin:Update()
    CaptureSessionDelta()

    local current = UnitXP("player")
    local max = UnitXPMax("player")
    local rested = GetXPExhaustion() or 0
    local elapsed = GetElapsed()

    self.current = current
    self.max = max
    self.rested = rested
    self.sessionXP = sessionXP
    self.xpPerHour = elapsed > 0 and floor((sessionXP / elapsed) * 3600) or 0

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
        self.text = string.format("|T" .. XP_ICON .. ":14:14:0:0|t %d%% (+%d%% rested) |cff00ff00+%s|r (%s/h)",
            self.percent,
            floor((rested / max) * 100),
            FormatXP(self.sessionXP),
            FormatXP(self.xpPerHour)
        )
    else
        self.text = string.format("|T" .. XP_ICON .. ":14:14:0:0|t %d%% |cff00ff00+%s|r (%s/h)",
            self.percent,
            FormatXP(self.sessionXP),
            FormatXP(self.xpPerHour)
        )
    end
end

function plugin:OnTooltipShow()
    self:Update()

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
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("Session XP", FormatXP(self.sessionXP), 1, 1, 1, 0, 1, 0)
    GameTooltip:AddDoubleLine("XP per Hour", FormatXP(self.xpPerHour), 1, 1, 1, 0, 1, 0)

    if rested > 0 then
        GameTooltip:AddLine(" ")
        local restedPct = max > 0 and floor((rested / max) * 100) or 0
        GameTooltip:AddDoubleLine("Rested XP", rested .. " (+" .. restedPct .. "%)", 1, 1, 1, 1, 1, 0)
    end
end

VK_TitanClassic:RegisterPlugin("VK_TitanXP", plugin)
