-- VK Titan Session Timer Plugin

local plugin = {}
plugin.text = "Session: 0m"

local SESSION_ICON = "Interface\\Icons\\INV_Misc_PocketWatch_01"

local frame = CreateFrame("Frame")
local sessionStartTime = 0
local updateElapsed = 0

local function GetElapsed()
    if sessionStartTime == 0 then return 0 end
    return max(0, time() - sessionStartTime)
end

local function FormatDuration(seconds, compact)
    seconds = floor(seconds or 0)

    local hours = floor(seconds / 3600)
    local minutes = floor((seconds % 3600) / 60)
    local secs = seconds % 60

    if compact then
        if hours > 0 then
            return string.format("%dh %02dm", hours, minutes)
        elseif minutes > 0 then
            return string.format("%dm %02ds", minutes, secs)
        end
        return string.format("%ds", secs)
    end

    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

function plugin:OnLoad()
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
end

frame:SetScript("OnEvent", function(self, event)
    if sessionStartTime == 0 then
        sessionStartTime = time()
    end
    plugin:Update()
    VK_Titan:RefreshBar()
end)

frame:SetScript("OnUpdate", function(self, elapsed)
    updateElapsed = updateElapsed + elapsed
    if updateElapsed >= 1 then
        updateElapsed = 0
        plugin:Update()
        VK_Titan:RefreshBar()
    end
end)

function plugin:Update()
    if sessionStartTime == 0 then
        sessionStartTime = time()
    end

    self.elapsed = GetElapsed()
    self.text = string.format("|T%s:14:14:0:0|t %s", SESSION_ICON, FormatDuration(self.elapsed, true))
end

function plugin:OnTooltipShow()
    self:Update()

    GameTooltip:AddLine("Session Time", 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("Elapsed", FormatDuration(self.elapsed, false), 1, 1, 1, 1, 0.82, 0)
end

VK_TitanClassic:RegisterPlugin("VK_TitanSession", plugin)
