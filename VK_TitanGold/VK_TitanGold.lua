-- VK Titan Gold Plugin

local plugin = {}
plugin.text = "Gold: 0"

VK_TitanGoldDB = VK_TitanGoldDB or {}

local sessionStartGold = 0
local sessionStartTime = 0

local function GetIdentity()
    local name = UnitName("player")
    local realm = GetRealmName() or "UnknownRealm"
    local faction = UnitFactionGroup("player") or "Neutral"
    return realm, faction, name
end

local function SaveGold()
    local realm, faction, name = GetIdentity()
    local copper = GetMoney()

    VK_TitanGoldDB[realm] = VK_TitanGoldDB[realm] or {}
    VK_TitanGoldDB[realm][faction] = VK_TitanGoldDB[realm][faction] or {}
    VK_TitanGoldDB[realm][faction][name] = copper
end

local function GetTotalGold()
    local realm, faction = GetIdentity()

    local total = 0
    if VK_TitanGoldDB[realm] and VK_TitanGoldDB[realm][faction] then
        for _, copper in pairs(VK_TitanGoldDB[realm][faction]) do
            total = total + copper
        end
    end

    return total
end

local function FormatGold(copper)
    local gold = floor(copper / 10000)
    local silver = floor((copper % 10000) / 100)
    local rem = copper % 100
    return string.format("%dg %ds %dc", gold, silver, rem)
end

local frame = CreateFrame("Frame")

function plugin:OnLoad()
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_MONEY")
    frame:RegisterEvent("PLAYER_LOGOUT")
end

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGOUT" then
        SaveGold()
    else
        plugin:Update()
        VK_Titan:RefreshBar()
    end
end)

function plugin:Update()
    local current = GetMoney()

    if sessionStartTime == 0 then
        sessionStartTime = time()
        sessionStartGold = current
    end

    SaveGold()

    local total = GetTotalGold()

    self.text = FormatGold(total)
end

function plugin:OnTooltipShow()
    local realm, faction = GetIdentity()

    GameTooltip:AddLine("Gold Summary", 1, 1, 1)
    GameTooltip:AddLine(" ")

    if VK_TitanGoldDB[realm] and VK_TitanGoldDB[realm][faction] then
        for name, copper in pairs(VK_TitanGoldDB[realm][faction]) do
            GameTooltip:AddDoubleLine(name, FormatGold(copper), 1, 1, 1, 1, 1, 0)
        end
    end

    GameTooltip:AddLine(" ")

    local total = GetTotalGold()
    GameTooltip:AddDoubleLine("Total", FormatGold(total), 1, 1, 1, 1, 1, 0)

    GameTooltip:AddLine(" ")

    local current = GetMoney()
    local sessionEarned = current - sessionStartGold
    GameTooltip:AddDoubleLine("Session Earned", FormatGold(sessionEarned), 1, 1, 1, 1, 1, 0)

    local elapsed = max(1, time() - sessionStartTime)
    local gph = floor((sessionEarned / elapsed) * 3600)
    GameTooltip:AddDoubleLine("Gold per Hour", FormatGold(gph), 1, 1, 1, 1, 1, 0)
end

VK_TitanClassic:RegisterPlugin("VK_TitanGold", plugin)
