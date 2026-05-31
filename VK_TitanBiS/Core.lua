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
                CloseDropDownMenus()
                ns:RefreshBiSList()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    UIDropDownMenu_SetText(classDD, "Warrior")

    -- Spec dropdown
    local specLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    specLabel:SetPoint("LEFT", classDD, "RIGHT", 10, 10)
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
        noData:SetText("No BiS data for this spec/phase yet.\nUse the Python scraper to generate data.")
        return
    end

    local yOffset = -5

    for _, item in ipairs(phaseData) do
        if tContains(SLOT_ORDER, item.slot) then
            local row = CreateFrame("Frame", nil, scrollChild, "BackdropTemplate")
            row:SetSize(scrollChild:GetWidth() - 20, 65)
            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 5, yOffset)
            row:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                edgeSize = 4,
                insets = { left = 2, right = 2, top = 2, bottom = 2 },
            })

            -- Slot icon
            local slotIcon = row:CreateTexture(nil, "ARTWORK")
            slotIcon:SetSize(32, 32)
            slotIcon:SetPoint("TOPLEFT", row, "TOPLEFT", 5, -5)
            slotIcon:SetTexture(SLOT_ICONS[item.slot] or "Interface\\Icons\\INV_Misc_QuestionMark")

            -- Item name (use GetItemInfo if available)
            local itemName = "Item " .. item.itemID
            local itemLink = nil
            local _, _, quality, _, _, _, _, _, _, itemTexture = GetItemInfo(item.itemID)
            if quality then
                local r, g, b = GetItemQualityColor(quality)
                -- Use item info
            end

            local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            nameText:SetPoint("TOPLEFT", slotIcon, "TOPRIGHT", 5, -2)
            nameText:SetWidth(300)
            nameText:SetJustifyH("LEFT")
            nameText:SetText(string.format("|cff%s#%d|r  %s (%d)",
                item.rank == 1 and "00ff00" or item.rank == 2 and "ffffffcc" or "999999",
                item.rank, itemName, item.itemID))

            -- Slot label
            local slotText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            slotText:SetPoint("TOPRIGHT", row, "TOPRIGHT", -5, -2)
            slotText:SetTextColor(0.7, 0.7, 0.7)
            slotText:SetText(item.slot)

            -- Socket info + Gems
            local sockets = ns.ItemSockets[item.itemID]
            if sockets and gemData then
                local gemLine = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                gemLine:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -3)
                gemLine:SetWidth(500)
                gemLine:SetJustifyH("LEFT")

                local gemStr = "Sockets: "
                for i, color in ipairs(sockets) do
                    local gem = GetGemForSocket(color, specKey, showBudget)
                    local colorName = GetSocketColorName(color)
                    if gem then
                        gemStr = gemStr .. string.format("|T%d:12:12:0:0|t|cff%s%s|r ",
                            gem.id, GetSocketColorHex(color), colorName)
                    else
                        gemStr = gemStr .. string.format("|cff%s%s|r ",
                            GetSocketColorHex(color), colorName)
                    end
                end
                gemLine:SetText(gemStr)

                -- Enchant
                if enchantData and item.slot and enchantData[item.slot] and enchantData[item.slot].name then
                    local enchantLine = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                    enchantLine:SetPoint("TOPLEFT", gemLine, "BOTTOMLEFT", 0, -1)
                    enchantLine:SetTextColor(0.5, 1, 0.5)
                    enchantLine:SetText("Enchant: " .. enchantData[item.slot].name)
                    row:SetHeight(80)
                else
                    row:SetHeight(65)
                end
            elseif enchantData and item.slot and enchantData[item.slot] and enchantData[item.slot].name then
                local enchantLine = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                enchantLine:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -3)
                enchantLine:SetTextColor(0.5, 1, 0.5)
                enchantLine:SetText("Enchant: " .. enchantData[item.slot].name)
                row:SetHeight(65)
            end

            yOffset = yOffset - row:GetHeight() - 5
        end
    end

    -- Resize scroll child
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
