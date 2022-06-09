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
---@field buttons Button[]

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
    ActionbarShift_ShowButton(self)
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
    ActionbarShift_HideButton(self)
end

---@param self ActionbarShift
function ActionbarShift_ShowButton(self)
    for iter, button in ipairs(self.buttons) do
        button:Show();
    end
end

---@param self ActionbarShift
function ActionbarShift_HideButton(self)
    for iter, button in ipairs(self.buttons) do
        button:Hide();
    end
end

---@param self ActionbarShift
function ActionbarShift_OnLoad(self)
    self.buttons = {};
    for i = 1, 12 do
        table.insert(self.buttons, _G["MultiBarRightButton" .. i]);
        table.insert(self.buttons, _G["MultiBarLeftButton" .. i]);
    end
end
