-- VK Titan Bag Plugin

local plugin = {}
plugin.text = "Bags: 0/0"

local frame = CreateFrame("Frame")

local BAG_NAMES = {
    [0] = "Backpack",
    [1] = "Bag 1",
    [2] = "Bag 2",
    [3] = "Bag 3",
    [4] = "Bag 4",
}

function plugin:OnLoad()
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("BAG_UPDATE")
end

frame:SetScript("OnEvent", function(self, event)
    plugin:Update()
end)

local function GetBagInfo()
    local totalSlots = 0
    local freeSlots = 0
    local bagData = {}

    for bag = 0, 4 do
        local slots = C_Container.GetContainerNumSlots(bag)
        if slots and slots > 0 then
            local free = C_Container.GetContainerNumFreeSlots(bag)
            totalSlots = totalSlots + slots
            freeSlots = freeSlots + free
            table.insert(bagData, {
                name = BAG_NAMES[bag] or ("Bag " .. bag),
                slots = slots,
                free = free,
                used = slots - free,
            })
        end
    end

    return totalSlots, freeSlots, bagData
end

local function Colorize(free, total)
    if total == 0 then return "|cffffffff0|r" end
    local pct = (free / total) * 100

    if pct >= 50 then
        return "|cff00ff00" .. free .. "|r"
    elseif pct >= 25 then
        return "|cffffff00" .. free .. "|r"
    else
        return "|cffff0000" .. free .. "|r"
    end
end

function plugin:Update()
    local totalSlots, freeSlots, bagData = GetBagInfo()
    local colored = Colorize(freeSlots, totalSlots)
    self.text = "Bags: " .. colored .. "/" .. totalSlots
end

function plugin:OnTooltipShow()
    local totalSlots, freeSlots, bagData = GetBagInfo()

    GameTooltip:AddLine("Bag Usage", 1, 1, 1)
    GameTooltip:AddLine(" ")

    for _, bag in ipairs(bagData) do
        local pctText = string.format("%d/%d", bag.used, bag.slots)
        GameTooltip:AddDoubleLine(bag.name, pctText, 1, 1, 1, 1, 0.82, 0)
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("Total", freeSlots .. " free / " .. totalSlots .. " slots", 1, 1, 1, 1, 1, 0)
end

VK_TitanClassic:RegisterPlugin("VK_TitanBag", plugin)
