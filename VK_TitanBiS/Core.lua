-- VK Titan BiS - Core
-- Best in Slot list with gem and enchant recommendations

local ADDON_NAME, ns = ...

-- =====================
-- State
-- =====================
local selectedClass = "WARRIOR"
local selectedSpec = "Arms"
local selectedPhase = 1
local showBudget = false

local SLOT_ORDER = {
    "Head", "Neck", "Shoulders", "Back", "Chest", "Wrist",
    "Hands", "Waist", "Legs", "Feet",
    "Ring1", "Ring2", "Trinket1", "Trinket2",
    "MainHand", "OffHand", "TwoHand", "Ranged",
}

local SLOT_ICONS = {
    Head = 133071, Neck = 133304, Shoulders = 135026, Back = 133752,
    Chest = 132624, Wrist = 132616, Hands = 132958, Waist = 132516,
    Legs = 132726, Feet = 132535, Ring1 = 133399, Ring2 = 133399,
    Trinket1 = 133278, Trinket2 = 133278, MainHand = 135321,
    OffHand = 134952, TwoHand = 135321, Ranged = 135611,
}

-- =====================
-- Helpers
-- =====================
local function GetSpecKey()
    for _, classData in ipairs(ns.ClassSpecs) do
        if classData.key == selectedClass then
            return classData.name .. selectedSpec
        end
    end
    return selectedClass .. selectedSpec
end

local function GetGemForSocket(socketColor, specKey, useBudget)
    local gemData = ns.GemData[specKey]
    if not gemData or not gemData.gems[socketColor] then return nil end
    if useBudget then
        return gemData.gems[socketColor].budget
    end
    return gemData.gems[socketColor].bis
end

local function GetSocketColorName(color)
    local names = { M = "Meta", R = "Red", Y = "Yellow", B = "Blue", P = "Prismatic" }
    return names[color] or "Unknown"
end

local function GetSocketColorHex(color)
    local hexes = { M = "a335ee", R = "ff0000", Y = "ffcc00", B = "0070dd", P = "00cc00" }
    return hexes[color] or "ffffff"
end

-- =====================
-- Main Window
-- =====================
local mainFrame

local function CreateMainFrame()
    if mainFrame then return mainFrame end

    mainFrame = CreateFrame("Frame", "VK_TitanBiSFrame", UIParent)
    mainFrame:SetSize(750, 600)
    mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    mainFrame:SetFrameStrata("DIALOG")
    mainFrame:SetMovable(true)
    mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
    mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
    mainFrame:Hide()

    -- Background
    local bg = mainFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.05, 0.05, 0.05, 0.95)

    -- Title bar
    local titleBar = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
    titleBar:SetHeight(30)
    titleBar:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, 0)
    titleBar:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", 0, 0)
    titleBar:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark" })
    titleBar:EnableMouse(true)
    titleBar:RegisterForDrag("LeftButton")
    titleBar:SetScript("OnDragStart", function() mainFrame:StartMoving() end)
    titleBar:SetScript("OnDragStop", function() mainFrame:StopMovingOrSizing() end)

    local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", titleBar, "LEFT", 10, 0)
    title:SetText("VK Titan BiS")

    -- Close button
    local closeBtn = CreateFrame("Button", nil, titleBar, "UIPanelCloseButton")
    closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", 5, 0)
    closeBtn:SetScript("OnClick", function() mainFrame:Hide() end)

    -- Content area
    local content = CreateFrame("Frame", nil, mainFrame)
    content:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 10, -10)
    content:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -10, 10)

    -- Spec dropdown (defined first so class dropdown can reference it)
    local specLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    specLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 200, 0)
    specLabel:SetText("Spec:")

    local specDD = CreateFrame("Frame", "VK_TitanBiSSpecDD", content, "UIDropDownMenuTemplate")
    specDD:SetPoint("TOPLEFT", specLabel, "BOTTOMLEFT", -10, -5)
    UIDropDownMenu_SetWidth(specDD, 130)

    local function UpdateSpecDropdown()
        UIDropDownMenu_SetInitializeFunction(specDD, function(self, level)
            for _, classData in ipairs(ns.ClassSpecs) do
                if classData.key == selectedClass then
                    for _, specName in ipairs(classData.specs) do
                        local info = {}
                        info.text = specName
                        info.func = function()
                            selectedSpec = specName
                            UIDropDownMenu_SetText(specDD, specName)
                            CloseDropDownMenus()
                            ns:RefreshBiSList()
                        end
                        UIDropDownMenu_AddButton(info, level)
                    end
                    break
                end
            end
        end)
        UIDropDownMenu_SetText(specDD, selectedSpec)
    end

    -- Class dropdown
    local classLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    classLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
    classLabel:SetText("Class:")

    local classDD = CreateFrame("Frame", "VK_TitanBiSClassDD", content, "UIDropDownMenuTemplate")
    classDD:SetPoint("TOPLEFT", classLabel, "BOTTOMLEFT", -10, -5)

    UIDropDownMenu_SetWidth(classDD, 130)
    UIDropDownMenu_SetInitializeFunction(classDD, function(self, level)
        for _, classData in ipairs(ns.ClassSpecs) do
            local info = {}
            info.text = classData.name
            info.func = function()
                selectedClass = classData.key
                selectedSpec = classData.specs[1]
                UIDropDownMenu_SetText(classDD, classData.name)
                UpdateSpecDropdown()
                CloseDropDownMenus()
                ns:RefreshBiSList()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    UIDropDownMenu_SetText(classDD, "Warrior")

    -- Phase dropdown
    local phaseLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    phaseLabel:SetPoint("LEFT", specDD, "RIGHT", 10, 10)
    phaseLabel:SetText("Phase:")

    local phaseDD = CreateFrame("Frame", "VK_TitanBiSPhaseDD", content, "UIDropDownMenuTemplate")
    phaseDD:SetPoint("TOPLEFT", phaseLabel, "BOTTOMLEFT", -10, -5)
    UIDropDownMenu_SetWidth(phaseDD, 90)

    UIDropDownMenu_SetInitializeFunction(phaseDD, function(self, level)
        for i = 1, 5 do
            local info = {}
            info.text = "Phase " .. i
            info.func = function()
                selectedPhase = i
                UIDropDownMenu_SetText(phaseDD, "Phase " .. i)
                CloseDropDownMenus()
                ns:RefreshBiSList()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    UIDropDownMenu_SetText(phaseDD, "Phase 1")

    -- Budget toggle
    local budgetBtn = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
    budgetBtn:SetPoint("LEFT", phaseDD, "RIGHT", 5, 5)
    budgetBtn:SetChecked(false)
    budgetBtn:SetScript("OnClick", function(self)
        showBudget = self:GetChecked()
        ns:RefreshBiSList()
    end)

    local budgetLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    budgetLabel:SetPoint("LEFT", budgetBtn, "RIGHT", 5, 0)
    budgetLabel:SetText("Show Budget Gems")

    -- Meta gem info box
    local metaBox = CreateFrame("Frame", nil, content, "BackdropTemplate")
    metaBox:SetHeight(40)
    metaBox:SetPoint("TOPLEFT", classDD, "BOTTOMLEFT", 10, -15)
    metaBox:SetPoint("RIGHT", content, "RIGHT", 0, 0)
    metaBox:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 8,
    })

    local metaText = metaBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    metaText:SetPoint("LEFT", metaBox, "LEFT", 10, 0)
    metaText:SetText("Meta: Loading...")

    -- Scroll frame for items
    local scrollFrame = CreateFrame("ScrollFrame", "VK_TitanBiSScroll", content, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", metaBox, "BOTTOMLEFT", 0, -10)
    scrollFrame:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -5, 0)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(scrollChild)

    -- Store references
    mainFrame.classDD = classDD
    mainFrame.specDD = specDD
    mainFrame.phaseDD = phaseDD
    mainFrame.metaText = metaText
    mainFrame.scrollChild = scrollChild
    mainFrame.UpdateSpecDropdown = UpdateSpecDropdown

    return mainFrame
end

-- =====================
-- Refresh BiS List
-- =====================
-- Refresh BiS List (AtlasLoot-style)
-- =====================
local MAX_PER_SLOT = 3

local function CreateSlotHeader(parent, slotName, yOffset)
    local header = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    header:SetSize(parent:GetWidth() - 10, 24)
    header:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, yOffset)
    header:SetBackdrop({
        bgFile = "Interface\\QuestFrame\\UI-QuestTitleHighlight",
        tile = true, tileSize = 16,
    })

    local icon = header:CreateTexture(nil, "ARTWORK")
    icon:SetSize(18, 18)
    icon:SetPoint("LEFT", header, "LEFT", 5, 0)
    icon:SetTexture(SLOT_ICONS[slotName] or "Interface\\Icons\\INV_Misc_QuestionMark")

    local label = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    label:SetText(slotName)

    return header, 28
end

local function CreateItemRow(parent, item, rank, gemData, enchantData, yOffset, isTop)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(parent:GetWidth() - 10, isTop and 22 or 18)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, yOffset)

    -- Rank number
    local rankText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    rankText:SetPoint("LEFT", row, "LEFT", 5, 0)
    rankText:SetWidth(20)
    local rankColor = rank == 1 and "|cff00ff00" or rank == 2 and "|cffffffcc" or "|cff999999"
    rankText:SetText(rankColor .. "#" .. rank .. "|r")

    -- Item name
    local itemName = "Item " .. item.itemID
    local itemQuality = nil
    local info = { GetItemInfo(item.itemID) }
    if info[1] then
        itemName = info[1]
        itemQuality = info[3]
    end

    local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    nameText:SetPoint("LEFT", rankText, "RIGHT", 5, 0)
    nameText:SetWidth(350)
    nameText:SetJustifyH("LEFT")

    if itemQuality then
        local r, g, b = GetItemQualityColor(itemQuality)
        local qhex = string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
        nameText:SetText("|cff" .. qhex .. itemName .. "|r")
    else
        nameText:SetText(itemName)
    end

    local rowHeight = isTop and 22 or 18

    -- Show gems + enchant only for #1 item
    if isTop and gemData then
        local sockets = ns.ItemSockets[item.itemID]
        if sockets then
            local gemStr = ""
            for _, color in ipairs(sockets) do
                local gem = GetGemForSocket(color, GetSpecKey(), showBudget)
                local colorName = GetSocketColorName(color)
                if gem then
                    gemStr = gemStr .. string.format("|T%d:11:11:0:0|t|cff%s%s|r ",
                        gem.id, GetSocketColorHex(color), colorName)
                else
                    gemStr = gemStr .. string.format("|cff%s%s|r ",
                        GetSocketColorHex(color), colorName)
                end
            end

            if gemStr ~= "" then
                local gemLine = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                gemLine:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 25, -1)
                gemLine:SetWidth(400)
                gemLine:SetJustifyH("LEFT")
                gemLine:SetText("Gems: " .. gemStr)
                rowHeight = rowHeight + 14
            end
        end

        if enchantData and enchantData[item.slot] and enchantData[item.slot].name then
            local enchantLine = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            local eY = -1
            if ns.ItemSockets[item.itemID] then eY = -15 end
            enchantLine:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 25, eY)
            enchantLine:SetTextColor(0.5, 1, 0.5)
            enchantLine:SetText("Enchant: " .. enchantData[item.slot].name)
            rowHeight = rowHeight + 14
        end
    end

    row:SetHeight(rowHeight)
    return row, rowHeight
end

function ns:RefreshBiSList()
    if not mainFrame then return end

    local specKey = GetSpecKey()
    local bisData = ns.BiSData[specKey]
    local gemData = ns.GemData[specKey]
    local enchantCategory = ns.SpecToEnchantCategory[specKey]
    local enchantData = enchantCategory and ns.EnchantData[enchantCategory]
    local phaseData = bisData and bisData[selectedPhase]

    -- Update meta gem info
    if gemData and gemData.meta then
        mainFrame.metaText:SetText(
            string.format("|T%d:16:16:0:0|t Meta: %s  |  Req: %s",
                gemData.meta.id, gemData.meta.name, gemData.meta.req)
        )
    else
        mainFrame.metaText:SetText("No gem data for this spec")
    end

    -- Clear scroll child
    local scrollChild = mainFrame.scrollChild
    for _, child in ipairs({ scrollChild:GetChildren() }) do
        child:Hide()
    end

    if not phaseData then
        local noData = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        noData:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, -10)
        noData:SetText("No BiS data for this spec/phase yet.")
        return
    end

    -- Group items by slot
    local grouped = {}
    for _, item in ipairs(phaseData) do
        if tContains(SLOT_ORDER, item.slot) then
            if not grouped[item.slot] then
                grouped[item.slot] = {}
            end
            table.insert(grouped[item.slot], item)
        end
    end

    -- Render AtlasLoot-style: slot header + items under it
    local yOffset = -5

    for _, slotName in ipairs(SLOT_ORDER) do
        local items = grouped[slotName]
        if items and #items > 0 then
            -- Slot header
            local _, headerHeight = CreateSlotHeader(scrollChild, slotName, yOffset)
            yOffset = yOffset - headerHeight

            -- Top items for this slot
            local shown = 0
            for _, item in ipairs(items) do
                if shown < MAX_PER_SLOT then
                    shown = shown + 1
                    local _, rowHeight = CreateItemRow(scrollChild, item, shown, gemData, enchantData, yOffset, shown == 1)
                    yOffset = yOffset - rowHeight
                end
            end

            yOffset = yOffset - 4
        end
    end

    scrollChild:SetHeight(math.abs(yOffset) + 20)
end

-- =====================
-- Toggle Window
-- =====================
function ns:ToggleBiSWindow()
    local frame = CreateMainFrame()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        ns:RefreshBiSList()
    end
end

-- =====================
-- Titan Panel Plugin
-- =====================
local plugin = {}
plugin.text = "BiS"

local frame = CreateFrame("Frame")

function plugin:OnLoad()
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
end

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        local _, classFile = UnitClass("player")
        if classFile then
            selectedClass = classFile
            for _, classData in ipairs(ns.ClassSpecs) do
                if classData.key == classFile then
                    selectedSpec = classData.specs[1]
                    break
                end
            end
        end
        plugin:Update()
        VK_Titan:RefreshBar()
    end
end)

function plugin:Update()
    local specKey = GetSpecKey()
    local classData
    for _, cd in ipairs(ns.ClassSpecs) do
        if cd.key == selectedClass then
            classData = cd
            break
        end
    end
    if classData then
        self.text = classData.name .. " " .. selectedSpec
    else
        self.text = "BiS"
    end
end

function plugin:OnTooltipShow()
    local displayName = selectedClass
    for _, classData in ipairs(ns.ClassSpecs) do
        if classData.key == selectedClass then
            displayName = classData.name
            break
        end
    end
    GameTooltip:AddLine("VK Titan BiS", 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("Class", displayName, 1, 1, 1, 1, 0.82, 0)
    GameTooltip:AddDoubleLine("Spec", selectedSpec, 1, 1, 1, 1, 0.82, 0)
    GameTooltip:AddDoubleLine("Phase", selectedPhase, 1, 1, 1, 1, 0.82, 0)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("|cff00ff00Click to open BiS list|r")
end

VK_TitanClassic:RegisterPlugin("VK_TitanBiS", plugin)

function plugin:OnClick(self, button)
    if button == "LeftButton" then
        ns:ToggleBiSWindow()
    end
end

-- =====================
-- Tooltip Integration
-- =====================
GameTooltip:HookScript("OnTooltipSetItem", function(self)
    local _, link = self:GetItem()
    if not link then return end
    local itemID = tonumber(link:match("item:(%d+)"))
    if not itemID then return end

    local specKey = GetSpecKey()
    local phaseData = ns.BiSData[specKey] and ns.BiSData[specKey][selectedPhase]
    if not phaseData then return end

    for _, item in ipairs(phaseData) do
        if item.itemID == itemID then
            self:AddLine(" ")
            self:AddLine("|cFF00FF00BiS #" .. item.rank .. " (" .. item.slot .. ")|r")
            break
        end
    end
end)

-- =====================
-- Slash Commands
-- =====================
SLASH_VKTITANBIS1 = "/vkbis"
SlashCmdList["VTITANBIS"] = function(msg)
    ns:ToggleBiSWindow()
end
