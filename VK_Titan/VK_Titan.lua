-- VK Titan Panel Core

VK_Titan = {}
VK_Titan.plugins = {}
VK_Titan.locked = false

VK_TitanBarDB = VK_TitanBarDB or { anchor = "top", yOffset = 0 }

local bar
local bg

-- ============================
-- Event handling
-- ============================

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        VK_Titan:Initialize()
        VK_Titan:CreateBar()
        VK_Titan:CreateMenu()
        VK_Titan:RegisterSlashCommands()
    elseif event == "PLAYER_ENTERING_WORLD" then
        VK_Titan:UpdateAll()
        VK_Titan:RefreshBar()
    end
end)

-- ============================
-- Plugin registry
-- ============================

function VK_Titan:RegisterPlugin(name, plugin)
    VK_Titan.plugins[name] = plugin
end

function VK_Titan:Initialize()
    for name, plugin in pairs(VK_Titan.plugins) do
        if plugin.OnLoad then
            plugin:OnLoad()
        end
    end
end

function VK_Titan:UpdateAll()
    for name, plugin in pairs(VK_Titan.plugins) do
        if plugin.Update then
            local ok, err = pcall(plugin.Update, plugin)
            if not ok then
                -- silently ignore plugin errors
            end
        end
    end
end

-- ============================
-- Bar creation
-- ============================

VK_Titan.textObjects = {}

function VK_Titan:CreateBar()
    bar = CreateFrame("Frame", "VK_TitanBar", UIParent)
    bar:SetHeight(24)
    bar:SetClampedToScreen(true)
    bar:EnableMouse(true)

    VK_Titan:ApplyPosition()

    bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.1, 0.1, 0.1, 0.85)
end

function VK_Titan:ApplyPosition()
    if not bar then return end
    bar:ClearAllPoints()
    if VK_TitanBarDB.anchor == "bottom" then
        bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, VK_TitanBarDB.yOffset)
        bar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, VK_TitanBarDB.yOffset)
    else
        bar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, VK_TitanBarDB.yOffset)
        bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, VK_TitanBarDB.yOffset)
    end
end

-- ============================
-- Text objects & layout
-- ============================

function VK_Titan:CreateTextObject(name, plugin)
    local holder = CreateFrame("Frame", nil, bar)
    holder:SetHeight(24)
    holder:EnableMouse(false)
    holder._vkPlugin = plugin

    local text = holder:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetTextColor(1, 1, 1, 1)
    text:SetJustifyH("LEFT")
    text:SetPoint("LEFT", holder, "LEFT", 0, 0)

    holder._text = text
    table.insert(VK_Titan.textObjects, holder)
    return holder
end

function VK_Titan:Layout()
    local x = 10
    for _, holder in ipairs(VK_Titan.textObjects) do
        holder:ClearAllPoints()
        holder:SetPoint("LEFT", bar, "LEFT", x, 0)
        local w = holder._text:GetStringWidth()
        holder:SetWidth(w + 10)
        x = x + w + 20
    end
end

function VK_Titan:RefreshBar()
    for name, plugin in pairs(VK_Titan.plugins) do
        if not plugin.textObject then
            plugin.textObject = VK_Titan:CreateTextObject(name, plugin)
            plugin.textObject:EnableMouse(true)
            plugin.textObject:SetScript("OnEnter", function(self)
                if self._vkPlugin and self._vkPlugin.OnTooltipShow then
                    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
                    self._vkPlugin:OnTooltipShow()
                    GameTooltip:Show()
                end
            end)
            plugin.textObject:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
            if plugin.OnClick then
                plugin.textObject:SetScript("OnClick", function(self, button)
                    if self._vkPlugin and self._vkPlugin.OnClick then
                        self._vkPlugin:OnClick(self, button)
                    end
                end)
            end
        end
        plugin.textObject._text:SetText(plugin.text or name)
    end
    VK_Titan:Layout()
end

-- ============================
-- Drag support
-- ============================

function VK_Titan:SetupDrag()
    if not bar then return end
    bar:RegisterForDrag("LeftButton")
    bar:SetMovable(true)

    local dragStartY = 0

    bar:SetScript("OnDragStart", function(self)
        if VK_Titan.locked then return end
        _, dragStartY = GetCursorPosition()
    end)

    bar:SetScript("OnDragStop", function(self)
        if VK_Titan.locked then return end
        local _, endY = GetCursorPosition()
        local delta = endY - dragStartY
        VK_TitanBarDB.yOffset = VK_TitanBarDB.yOffset + (delta / UIParent:GetScale())
        VK_Titan:ApplyPosition()
    end)
end

-- ============================
-- Slash commands
-- ============================

function VK_Titan:RegisterSlashCommands()
    SLASH_VKTITAN1 = "/vktitan"
    SLASH_VKTITAN2 = "/vkt"

    SlashCmdList["VKTITAN"] = function(msg)
        local cmd = strtrim(msg):lower()

        if cmd == "top" then
            VK_TitanBarDB.anchor = "top"
            VK_TitanBarDB.yOffset = 0
            VK_Titan:ApplyPosition()
        elseif cmd == "bottom" then
            VK_TitanBarDB.anchor = "bottom"
            VK_TitanBarDB.yOffset = 0
            VK_Titan:ApplyPosition()
        elseif cmd == "lock" then
            VK_Titan.locked = true
        elseif cmd == "unlock" then
            VK_Titan.locked = false
            VK_Titan:SetupDrag()
        elseif cmd == "reset" then
            VK_TitanBarDB.anchor = "top"
            VK_TitanBarDB.yOffset = 0
            VK_Titan.locked = false
            VK_Titan:ApplyPosition()
        else
            -- show usage
        end
    end
end

-- ============================
-- Right-click menu
-- ============================

function VK_Titan:CreateMenu()
    local menu = CreateFrame("Frame", "VK_TitanMenu", UIParent, "UIDropDownMenuTemplate")

    UIDropDownMenu_SetWidth(menu, 160)
    UIDropDownMenu_SetInitializeFunction(menu, function(self, level, menuList)
        local info = {}

        info.text = "VK Titan"
        info.isTitle = true
        info.notCheckable = true
        UIDropDownMenu_AddButton(info, level)

        info = {}
        info.text = VK_TitanBarDB.anchor == "top" and "|cff00ff00Top|r" or "Top"
        info.func = function()
            VK_TitanBarDB.anchor = "top"
            VK_TitanBarDB.yOffset = 0
            VK_Titan:ApplyPosition()
            CloseDropDownMenus()
        end
        info.checked = VK_TitanBarDB.anchor == "top"
        UIDropDownMenu_AddButton(info, level)

        info = {}
        info.text = VK_TitanBarDB.anchor == "bottom" and "|cff00ff00Bottom|r" or "Bottom"
        info.func = function()
            VK_TitanBarDB.anchor = "bottom"
            VK_TitanBarDB.yOffset = 0
            VK_Titan:ApplyPosition()
            CloseDropDownMenus()
        end
        info.checked = VK_TitanBarDB.anchor == "bottom"
        UIDropDownMenu_AddButton(info, level)

        info = {}
        info.text = "-----------------"
        info.notCheckable = true
        info.disabled = true
        UIDropDownMenu_AddButton(info, level)

        info = {}
        info.text = VK_Titan.locked and "|cff00ff00Locked|r" or "Unlock Bar"
        info.func = function()
            VK_Titan.locked = not VK_Titan.locked
            if not VK_Titan.locked then
                VK_Titan:SetupDrag()
            end
            CloseDropDownMenus()
        end
        info.notCheckable = true
        UIDropDownMenu_AddButton(info, level)

        info = {}
        info.text = "Reset Position"
        info.func = function()
            VK_TitanBarDB.anchor = "top"
            VK_TitanBarDB.yOffset = 0
            VK_Titan.locked = false
            VK_Titan:ApplyPosition()
            CloseDropDownMenus()
        end
        info.notCheckable = true
        UIDropDownMenu_AddButton(info, level)
    end)

    if bar then
        bar:SetScript("OnMouseDown", function(self, button)
            if button == "RightButton" then
                ToggleDropDownMenu(1, nil, menu, self, 0, 0)
            end
        end)
    end
end
