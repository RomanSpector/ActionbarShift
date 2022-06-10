---@diagnostic disable: undefined-global
---@class ActionbarShift: Frame
---@field borderTopLeft ActionbarShiftBorderTopLeft
---@field borderBottomLeft ActionbarShiftBorderBottomLeft
---@field borderLeft ActionbarShiftBorderLeft
---@field bg ActionbarShiftBg
---@field toggleButton ActionbarShiftToggleButton
---@field collapsed boolean

---@class ActionbarShiftBorderTopLeft: Texture
---@class ActionbarShiftBorderBottomLeft: Texture
---@class ActionbarShiftBorderLeft: Texture
---@class ActionbarShiftBg: Texture

---@class ActionbarShiftToggleButton: Button

local function updateContainersAnchors()
    local frame, xOffset, yOffset, screenHeight, freeScreenHeight, leftMostPoint, column;
    local screenWidth = GetScreenWidth();
    local containerScale = 1;
    local leftLimit = 0;
    if ( BankFrame:IsShown() ) then
        leftLimit = BankFrame:GetRight() - 25;
    end

    while ( containerScale > CONTAINER_SCALE ) do
        screenHeight = GetScreenHeight() / containerScale;
        -- Adjust the start anchor for bags depending on the multibars
        xOffset = CONTAINER_OFFSET_X / containerScale;
        yOffset = CONTAINER_OFFSET_Y / containerScale;
        -- freeScreenHeight determines when to start a new column of bags
        freeScreenHeight = screenHeight - yOffset;
        leftMostPoint = screenWidth - xOffset;
        column = 1;
        local frameHeight;
        for index, frameName in ipairs(ContainerFrame1.bags) do
            frameHeight = _G[frameName]:GetHeight();
            if ( freeScreenHeight < frameHeight ) then
                -- Start a new column
                column = column + 1;
                leftMostPoint = screenWidth - ( column * CONTAINER_WIDTH * containerScale ) - xOffset;
                freeScreenHeight = screenHeight - yOffset;
            end
            freeScreenHeight = freeScreenHeight - frameHeight - VISIBLE_CONTAINER_SPACING;
        end
        if ( leftMostPoint < leftLimit ) then
            containerScale = containerScale - 0.01;
        else
            break;
        end
    end

    if ( containerScale < CONTAINER_SCALE ) then
        containerScale = CONTAINER_SCALE;
    end

    screenHeight = GetScreenHeight() / containerScale;
    -- Adjust the start anchor for bags depending on the multibars
    xOffset = CONTAINER_OFFSET_X / containerScale;
    yOffset = CONTAINER_OFFSET_Y / containerScale;
    -- freeScreenHeight determines when to start a new column of bags
    freeScreenHeight = screenHeight - yOffset;
    column = 0;
    for index, frameName in ipairs(ContainerFrame1.bags) do
        frame = _G[frameName];
        frame:SetScale(containerScale);
        if ( index == 1 ) then
            -- First bag
            frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), "BOTTOMRIGHT", -xOffset, yOffset );
        elseif ( freeScreenHeight < frame:GetHeight() ) then
            -- Start a new column
            column = column + 1;
            freeScreenHeight = screenHeight - yOffset;
            frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), "BOTTOMRIGHT", -(column * CONTAINER_WIDTH) - xOffset, yOffset );
        else
            -- Anchor to the previous bag
            frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING);
        end
        freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
    end
end

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

    self:SetPoint("RIGHT", MultiBarLeftButton6, "LEFT", 0, 0);
    self.toggleButton:GetNormalTexture():SetTexCoord(1, 0.5, 0, 1);

    MultiBarLeft:Show();
    MultiBarRight:Show();

    CONTAINER_OFFSET_X = 103;
    ActionbarShiftDB.visible = true;

    updateContainersAnchors();
end

---@param self ActionbarShift
function ActionbarShift_Collapse(self)
    self.collapsed = true;

    self:SetPoint("RIGHT", MultiBarLeftButton6, "LEFT", 90, 0);
    self.toggleButton:GetNormalTexture():SetTexCoord(0.5, 0, 0, 1);

    MultiBarLeft:Hide();
    MultiBarRight:Hide();


    CONTAINER_OFFSET_X = 13;
    ActionbarShiftDB.visible = false;

    updateContainersAnchors();
end

local function hookUpdateContainerFrameAnchors()
    if ActionbarShiftDB and ActionbarShiftDB.visible then
        CONTAINER_OFFSET_X = 103;
    else
        CONTAINER_OFFSET_X = 13;
    end
end

local function hookMultiActionBar_Update()
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
end

---@param self ActionbarShift
function ActionbarShift_OnLoad(self)
    hooksecurefunc("MultiActionBar_Update", hookMultiActionBar_Update);
    hooksecurefunc("updateContainerFrameAnchors", hookUpdateContainerFrameAnchors);

    self:RegisterEvent("ADDON_LOADED");
end

---@param self ActionbarShift
---@param event WowEvent
---@param name string
function ActionbarShift_OnEvent(self, event, name)
    if ( ActionbarShiftDB and not self.loaded ) then
        if ActionbarShiftDB.visible or ActionbarShiftDB.visible == nil then
            ActionbarShift_Expand(self)
        else
            ActionbarShift_Collapse(self);
        end

        self.loaded = true;
    end
end
