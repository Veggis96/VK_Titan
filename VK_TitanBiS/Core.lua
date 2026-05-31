-- VK Titan BiS - Core
-- AtlasLoot-style Best in Slot list with gem and enchant recommendations

local ADDON_NAME, ns = ...

-- =====================
-- State
-- =====================
local selectedClass = "WARRIOR"
local selectedSpec = "Arms"
local selectedPhase = 1
local showBudget = false
local activeSlot = nil

local SLOT_ORDER = {
    "Head", "Shoulders", "Back", "Chest", "Wrist", "Hands",
    "Waist", "Legs", "Feet", "Neck", "Ring1", "Ring2",
    "Trinket1", "Trinket2", "MainHand", "OffHand", "TwoHand", "Ranged",
}

local SLOT_ICONS = {
    Head = 133071, Neck = 133304, Shoulders = 135026, Back = 133752,
    Chest = 132624, Wrist = 132616, Hands = 132958, Waist = 132516,
    Legs = 132726, Feet = 132535, Ring1 = 133399, Ring2 = 133399,
    Trinket1 = 133278, Trinket2 = 133278, MainHand = 135321,
    OffHand = 134952, TwoHand = 135321, Ranged = 135611,
}

local SLOT_DISPLAY = {
    "Head", "Shoulders", "Back", "Chest", "Wrist", "Hands",
    "Waist", "Legs", "Feet", "Neck", "Rings", "Trinkets",
    "Main Hand", "Off Hand", "Two Hand", "Ranged",
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

local function GetGemForSocket(socketColor, specKey, budget)
    local gd = ns.GemData[specKey]
    if not gd or not gd.gems[socketColor] then return nil end
    return budget and gd.gems[socketColor].budget or gd.gems[socketColor].bis
end

-- =====================
-- Main Window
-- =====================
local mainFrame

local function CreateMainFrame()
    if mainFrame then return mainFrame end

    mainFrame = CreateFrame("Frame", "VK_TitanBiSFrame", UIParent, "BackdropTemplate")
    mainFrame:SetSize(800, 600)
    mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    mainFrame:SetFrameStrata("DIALOG")
    mainFrame:SetMovable(true)
    mainFrame:SetClampedToScreen(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
    mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
    mainFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 16, tileSize = 16, tile = true,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    mainFrame:Hide()

    -- Title bar
    local titleBar = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
    titleBar:SetHeight(28)
    titleBar:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 8, -6)
    titleBar:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -8, -6)
    titleBar:SetBackdrop({ bgFile = "Interface\\QuestFrame\\UI-QuestTitleHighlight", tile = true, tileSize = 16 })

    local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("CENTER", titleBar, "CENTER", 0, 0)
    title:SetText("VK Titan BiS")

    local closeBtn = CreateFrame("Button", nil, titleBar, "UIPanelCloseButton")
    closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", 0, 0)
    closeBtn:SetScript("OnClick", function() mainFrame:Hide() end)

    -- Dropdowns row
    local ddFrame = CreateFrame("Frame", nil, mainFrame)
    ddFrame:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 5, -5)
    ddFrame:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -5, -5)
    ddFrame:SetHeight(30)

    -- Class dropdown
    local classDD = CreateFrame("Frame", nil, ddFrame, "UIDropDownMenuTemplate")
    classDD:SetPoint("TOPLEFT", ddFrame, "TOPLEFT", -10, 0)
    UIDropDownMenu_SetWidth(classDD, 110)

    local specDD = CreateFrame("Frame", nil, ddFrame, "UIDropDownMenuTemplate")
    specDD:SetPoint("LEFT", classDD, "RIGHT", 10, 0)
    UIDropDownMenu_SetWidth(specDD, 110)

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

    local phaseDD = CreateFrame("Frame", nil, ddFrame, "UIDropDownMenuTemplate")
    phaseDD:SetPoint("LEFT", specDD, "RIGHT", 10, 0)
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

    local budgetBtn = CreateFrame("CheckButton", nil, ddFrame, "UICheckButtonTemplate")
    budgetBtn:SetPoint("LEFT", phaseDD, "RIGHT", 5, 0)
    budgetBtn:SetChecked(false)
    budgetBtn:SetScript("OnClick", function(self)
        showBudget = self:GetChecked()
        ns:RefreshBiSList()
    end)
    local budgetLabel = ddFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    budgetLabel:SetPoint("LEFT", budgetBtn, "RIGHT", 3, 0)
    budgetLabel:SetText("Budget")

    -- Meta gem info
    local metaBox = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
    metaBox:SetHeight(22)
    metaBox:SetPoint("TOPLEFT", ddFrame, "BOTTOMLEFT", 0, -2)
    metaBox:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -8, 0)
    metaBox:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background" })

    local metaText = metaBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    metaText:SetPoint("LEFT", metaBox, "LEFT", 8, 0)
    metaText:SetText("")

    -- Right panel: slot navigation
    local navPanel = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
    navPanel:SetWidth(120)
    navPanel:SetPoint("TOPLEFT", metaBox, "BOTTOMLEFT", 0, -4)
    navPanel:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -8, 8)
    navPanel:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })

    local navTitle = navPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    navTitle:SetPoint("TOP", navPanel, "TOP", 0, -6)
    navTitle:SetText("Slots")

    local navButtons = {}
    local navSlotNames = {
        "Head", "Shoulders", "Back", "Chest", "Wrist", "Hands",
        "Waist", "Legs", "Feet", "Neck", "Ring1", "Ring2",
        "Trinket1", "Trinket2", "MainHand", "OffHand", "TwoHand", "Ranged",
    }

    for i, slotName in ipairs(navSlotNames) do
        local btn = CreateFrame("Button", nil, navPanel)
        btn:SetSize(110, 18)
        btn:SetPoint("TOP", navTitle, "BOTTOM", 0, -((i - 1) * 18) - 4)

        local btnBg = btn:CreateTexture(nil, "HIGHLIGHT")
        btnBg:SetAllPoints()
        btnBg:SetColorTexture(1, 1, 1, 0.1)

        local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        btnText:SetPoint("LEFT", btn, "LEFT", 5, 0)
        btnText:SetText(slotName)

        btn:SetScript("OnClick", function()
            activeSlot = slotName
            ns:RefreshBiSList()
        end)

        navButtons[slotName] = btn
    end

    -- Left panel: items scroll
    local scrollFrame = CreateFrame("ScrollFrame", nil, mainFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", metaBox, "BOTTOMLEFT", 0, -4)
    scrollFrame:SetPoint("BOTTOMRIGHT", navPanel, "BOTTOMLEFT", -6, 0)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetWidth(scrollFrame:GetWidth())
    scrollChild:SetHeight(1)
    scrollFrame:SetScrollChild(scrollChild)

    -- Store references
    mainFrame.metaText = metaText
    mainFrame.scrollChild = scrollChild
    mainFrame.navButtons = navButtons
    mainFrame.UpdateSpecDropdown = UpdateSpecDropdown

    return mainFrame
end

-- =====================
-- Refresh BiS List
-- =====================
local function BuildItemTooltip(tooltip, itemID, specKey)
    local sockets = ns.ItemSockets[itemID]
    local gemData = ns.GemData[specKey]
    local enchantCategory = ns.SpecToEnchantCategory[specKey]
    local enchantData = enchantCategory and ns.EnchantData[enchantCategory]

    -- Find item slot for enchant lookup
    local itemSlot = nil
    local bisData = ns.BiSData[specKey]
    local phaseData = bisData and bisData[selectedPhase]
    if phaseData then
        for _, item in ipairs(phaseData) do
            if item.itemID == itemID then
                itemSlot = item.slot
                break
            end
        end
    end

    if sockets and gemData then
        tooltip:AddLine(" ")
        tooltip:AddLine("|cFF00CCFFSuggested Gems:|r")
        for _, color in ipairs(sockets) do
            local gem = GetGemForSocket(color, specKey, showBudget)
            if gem then
                local _, link = GetItemInfo(gem.id)
                if link then
                    tooltip:AddDoubleLine("  " .. color .. " socket", link)
                else
                    tooltip:AddDoubleLine("  " .. color .. " socket", gem.name)
                end
            end
        end
    end

    if enchantData and itemSlot and enchantData[itemSlot] and enchantData[itemSlot].name then
        tooltip:AddLine(" ")
        tooltip:AddLine("|cFF00CCFFSuggested Enchant:|r")
        tooltip:AddLine("  " .. enchantData[itemSlot].name)
    end
end

function ns:RefreshBiSList()
    if not mainFrame then return end

    local specKey = GetSpecKey()
    local bisData = ns.BiSData[specKey]
    local gemData = ns.GemData[specKey]

    -- Update meta gem info
    if gemData and gemData.meta then
        mainFrame.metaText:SetText(
            string.format("|T%d:14:14:0:0|t Meta: %s  |  Req: %s",
                gemData.meta.id, gemData.meta.name, gemData.meta.req)
        )
    else
        mainFrame.metaText:SetText("No gem data for this spec")
    end

    -- Update nav button highlights
    for slotName, btn in pairs(mainFrame.navButtons) do
        if slotName == activeSlot then
            btn:GetFontString():SetTextColor(0, 1, 0)
        else
            btn:GetFontString():SetTextColor(1, 0.82, 0)
        end
    end

    -- Clear scroll child
    local scrollChild = mainFrame.scrollChild
    for _, child in ipairs({ scrollChild:GetChildren() }) do
        child:Hide()
    end

    if not bisData then
        local noData = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        noData:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, -10)
        noData:SetText("No BiS data for this spec.")
        return
    end

    local phaseData = bisData[selectedPhase]
    if not phaseData then
        local noData = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        noData:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, -10)
        noData:SetText("No data for Phase " .. selectedPhase .. ".")
        return
    end

    -- Group items by slot
    local grouped = {}
    for _, item in ipairs(phaseData) do
        if tContains(SLOT_ORDER, item.slot) then
            if not grouped[item.slot] then grouped[item.slot] = {} end
            table.insert(grouped[item.slot], item)
        end
    end

    -- Determine which slots to show
    local slotsToShow = {}
    if activeSlot then
        slotsToShow = { activeSlot }
    else
        slotsToShow = SLOT_ORDER
    end

    -- Render items
    local yOffset = -5

    for _, slotName in ipairs(slotsToShow) do
        local items = grouped[slotName]
        if items and #items > 0 then
            -- Slot header (AtlasLoot-style gold bar)
            local header = CreateFrame("Frame", nil, scrollChild, "BackdropTemplate")
            header:SetSize(scrollChild:GetWidth() - 10, 24)
            header:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 5, yOffset)
            header:SetBackdrop({
                bgFile = "Interface\\QuestFrame\\UI-QuestTitleHighlight",
                tile = true, tileSize = 16,
            })

            local headerLabel = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            headerLabel:SetPoint("CENTER", header, "CENTER", 0, 0)
            headerLabel:SetText(slotName)

            yOffset = yOffset - 28

            -- Show top items (up to 3)
            local shown = 0
            for _, item in ipairs(items) do
                if shown >= 3 then break end
                shown = shown + 1

                local info = { GetItemInfo(item.itemID) }
                local itemName = info[1] or ("Item " .. item.itemID)
                local itemLink = info[2]
                local itemQuality = info[3]
                local itemTexture = info[10] or ("Interface\\Icons\\INV_Misc_QuestionMark")

                local rowHeight = 38

                local row = CreateFrame("Frame", nil, scrollChild)
                row:SetSize(scrollChild:GetWidth() - 10, rowHeight)
                row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 5, yOffset)

                -- Hover background
                local hoverBg = row:CreateTexture(nil, "HIGHLIGHT")
                hoverBg:SetAllPoints()
                hoverBg:SetColorTexture(1, 1, 1, 0.05)

                -- Item icon
                local icon = row:CreateTexture(nil, "ARTWORK")
                icon:SetSize(28, 28)
                icon:SetPoint("TOPLEFT", row, "TOPLEFT", 4, -4)
                icon:SetTexture(itemTexture)

                -- Item name (quality-colored)
                local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                nameText:SetPoint("TOPLEFT", icon, "TOPRIGHT", 6, -2)
                nameText:SetWidth(400)
                nameText:SetJustifyH("LEFT")

                if itemQuality then
                    local r, g, b = GetItemQualityColor(itemQuality)
                    local qhex = string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
                    nameText:SetText("|cff" .. qhex .. itemName .. "|r")
                else
                    nameText:SetText(itemName)
                end

                -- Item subtype line (e.g. "Head, Mail")
                local subText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                subText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
                subText:SetTextColor(0.7, 0.7, 0.7)

                local _, _, _, _, _, _, _, _, itemEquipLoc, itemTexture2, itemClassID, itemSubClassID = GetItemInfo(item.itemID)
                if itemClassID and itemSubClassID then
                    local armorTypes = { [2] = "Cloth", [3] = "Leather", [4] = "Mail", [5] = "Plate" }
                    local armorType = armorTypes[itemSubClassID] or ""
                    local slotType = slotName
                    if itemEquipLoc then
                        slotType = slotType .. (armorType ~= "" and (", " .. armorType) or "")
                    end
                    subText:SetText(slotType)
                else
                    subText:SetText(slotName)
                end

                -- Hover: show full tooltip with gem/enchant suggestions
                row:EnableMouse(true)
                row:SetScript("OnEnter", function(self)
                    if itemLink then
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                        GameTooltip:SetHyperlink(itemLink)
                        BuildItemTooltip(GameTooltip, item.itemID, specKey)
                        GameTooltip:Show()
                    end
                end)
                row:SetScript("OnLeave", function()
                    GameTooltip:Hide()
                end)

                yOffset = yOffset - rowHeight
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
        activeSlot = nil
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
-- Global Tooltip Integration
-- =====================
GameTooltip:HookScript("OnTooltipSetItem", function(self)
    local _, link = self:GetItem()
    if not link then return end
    local itemID = tonumber(link:match("item:(%d+)"))
    if not itemID then return end

    local specKey = GetSpecKey()
    local bisData = ns.BiSData[specKey]
    local phaseData = bisData and bisData[selectedPhase]
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
