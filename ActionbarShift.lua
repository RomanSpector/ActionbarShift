---@diagnostic disable: undefined-global
---@class ActionbarShift: Frame
---@field borderTopLeft ActionbarShiftBorderTopLeft
---@field borderTopRight ActionbarShiftBorderTopRight
---@field borderBottomLeft ActionbarShiftBorderBottomLeft
---@field borderBottomRight ActionbarShiftBorderBottomRight
---@field borderTop ActionbarShiftBorderTop
---@field borderBottom ActionbarShiftBorderBottom
---@field borderLeft ActionbarShiftBorderLeft
---@field bg ActionbarShiftBg
---@field toggleButton ActionbarShiftToggleButton
---@field collapsed boolean

---@class ActionbarShiftBorderTopLeft: Texture
---@class ActionbarShiftBorderTopRight: Texture
---@class ActionbarShiftBorderBottomLeft: Texture
---@class ActionbarShiftBorderBottomRight: Texture
---@class ActionbarShiftBorderTop: Texture
---@class ActionbarShiftBorderBottom: Texture
---@class ActionbarShiftBorderLeft: Texture
---@class ActionbarShiftBg: Texture

---@class ActionbarShiftToggleButton: Button

local MultiBarRightButton1 = _G["MultiBarRightButton1"];
local MultiBarLeftButton12 = _G["MultiBarLeftButton12"];
local InterfaceOptionsActionBarsPanelRight = _G["InterfaceOptionsActionBarsPanelRight"];

---@param self ActionbarShift
function ActionbarShift_Toggle(self)
    if ( self.collapsed ) then
        ActionbarShift_Expand(self);
    else
        ActionbarShift_Collapse(self);
    end
end

---@param self ActionbarShift
function ActionbarShift_Expand(self)
    self.collapsed = false;

    self:ClearAllPoints();
    self:SetPoint("TOPRIGHT", MultiBarRightButton1, "TOPRIGHT", 13, 13);
    self:SetPoint("BOTTOMLEFT", MultiBarLeftButton12, "BOTTOMLEFT", -13, -13);

    self.borderTopRight:Show();
    self.borderBottomRight:Show();

    self.toggleButton:GetNormalTexture():SetTexCoord(1, 0.5, 0, 1);

    MultiBarLeft:Show();
    MultiBarRight:Show();

    if ActionbarShiftDB then ActionbarShiftDB.visible = true;end
end

---@param self ActionbarShift
function ActionbarShift_Collapse(self)
    self.collapsed = true;

    self:ClearAllPoints();
    self:SetPoint("TOPRIGHT", MultiBarRightButton1, "TOPRIGHT", 13, 13);
    self:SetPoint("BOTTOMLEFT", MultiBarLeftButton12, "BOTTOMLEFT", 65, -13);

    self.borderTopRight:Hide();
    self.borderBottomRight:Hide();

    self.toggleButton:GetNormalTexture():SetTexCoord(0.5, 0, 0, 1);

    MultiBarLeft:Hide();
    MultiBarRight:Hide();

    if ActionbarShiftDB then ActionbarShiftDB.visible = false;end
end

---@param self ActionbarShift
function ActionbarShift_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED");
    ActionbarShift_Collapse(self);
end

---@param self ActionbarShift
---@param event WowEvent
---@param name string
function ActionbarShift_OnEvent(self, event, name)
    if name == "ActionbarShift" and ActionbarShiftDB and ActionbarShiftDB.visible then
        ActionbarShift_Expand(self);
    end
end

hooksecurefunc("MultiActionBar_Update", function()
    local visible = ActionbarShiftDB and ActionbarShiftDB.visible;

    if SHOW_MULTI_ACTIONBAR_3 and MainMenuBar.state=="player" and visible then
        MultiBarRight:Show();
    else
        MultiBarRight:Hide();
    end
    if SHOW_MULTI_ACTIONBAR_3 and SHOW_MULTI_ACTIONBAR_4 and MainMenuBar.state=="player" and visible then
        MultiBarLeft:Show();
    else
        MultiBarLeft:Hide();
    end
end)
