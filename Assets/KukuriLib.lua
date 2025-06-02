local KukuriLib = {}
KukuriLib.__index = KukuriLib

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local Colors = {
    MainBackground = Color3.fromRGB(228, 223, 212),
    DarkPrimary = Color3.fromRGB(60, 55, 50),
    LightText = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(70, 70, 70),
    
    TabContainerBackground = Color3.fromRGB(218, 213, 202),
    UnselectedTabBackground = Color3.fromRGB(218, 213, 202),
    UnselectedTabText = Color3.fromRGB(80, 80, 80),
    UnselectedTabIcon = Color3.fromRGB(80, 80, 80),
    
    ContentItemBackground = Color3.fromRGB(235, 230, 220),
    ContentItemIcon = Color3.fromRGB(70, 70, 70),
    
    SliderTrack = Color3.fromRGB(205, 200, 190),
    SliderFill = Color3.fromRGB(100, 95, 90),
    SliderHandle = Color3.fromRGB(70, 70, 70),
    
    ToggleOffText = Color3.fromRGB(120, 120, 120),
    ToggleOnText = Color3.fromRGB(76, 175, 80),

    MainFrameOuterBorder = Color3.fromRGB(200, 195, 185),
    
    ContentTitleText = Color3.fromRGB(60, 60, 60),
    TabSeparatorLine = Color3.fromRGB(200, 195, 185)
}

    function KukuriLib:CreateWindow(title, subtitle)
        local window = {}
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "KukuriLib_Redesigned"
        screenGui.Parent = CoreGui
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.ResetOnSpawn = false
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 650, 0, 450)
        mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
        mainFrame.BackgroundColor3 = Colors.TabContainerBackground
        mainFrame.BorderSizePixel = 1
        mainFrame.BorderColor3 = Colors.MainFrameOuterBorder
        mainFrame.Parent = screenGui
        
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 30)
        titleBar.Position = UDim2.new(0, 0, 0, 0)
        titleBar.BackgroundColor3 = Colors.DarkPrimary
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mainFrame
        
        local titleIcon = Instance.new("Frame")
        titleIcon.Name = "TitleIcon"
        titleIcon.Size = UDim2.new(0, 10, 0, 10)
        titleIcon.Position = UDim2.new(0, 10, 0.5, -5)
        titleIcon.BackgroundColor3 = Colors.LightText
        titleIcon.BorderSizePixel = 0
        titleIcon.Parent = titleBar
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "TitleLabel"
        titleLabel.Size = UDim2.new(1, -35, 1, 0)
        titleLabel.Position = UDim2.new(0, 28, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title or "Label"
        titleLabel.TextColor3 = Colors.LightText
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Font = Enum.Font.SourceSans
        titleLabel.Parent = titleBar
        
        local tabContainer = Instance.new("Frame")
        tabContainer.Name = "TabContainer"
        tabContainer.Size = UDim2.new(0, 180, 1, -30)
        tabContainer.Position = UDim2.new(0, 0, 0, 30)
        tabContainer.BackgroundColor3 = Colors.TabContainerBackground
        tabContainer.BorderSizePixel = 0
        tabContainer.Parent = mainFrame
        
        local tabListLayout = Instance.new("UIListLayout")
        tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabListLayout.FillDirection = Enum.FillDirection.Vertical
        tabListLayout.Padding = UDim.new(0, 0)
        tabListLayout.Parent = tabContainer
        
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "ContentFrame"
        contentFrame.Size = UDim2.new(1, -tabContainer.Size.X.Offset, 1, -30)
        contentFrame.Position = UDim2.new(0, tabContainer.Size.X.Offset, 0, 30)
        contentFrame.BackgroundColor3 = Colors.MainBackground
        contentFrame.BorderSizePixel = 0
        contentFrame.Parent = mainFrame
        
        local tabTitleLabel = Instance.new("TextLabel")
        tabTitleLabel.Name = "TabTitleLabel"
        tabTitleLabel.Size = UDim2.new(1, -20, 0, 40)
        tabTitleLabel.Position = UDim2.new(0, 15, 0, 15)
        tabTitleLabel.BackgroundTransparency = 1
        tabTitleLabel.Text = ""
        tabTitleLabel.TextColor3 = Colors.ContentTitleText
        tabTitleLabel.TextSize = 24
        tabTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabTitleLabel.Font = Enum.Font.SourceSansBold
        tabTitleLabel.Parent = contentFrame
        
        local contentScroll = Instance.new("ScrollingFrame")
        contentScroll.Name = "ContentScroll"
        contentScroll.Size = UDim2.new(1, -20, 1, -65)
        contentScroll.Position = UDim2.new(0, 10, 0, 55)
        contentScroll.BackgroundTransparency = 1
        contentScroll.BorderSizePixel = 0
        contentScroll.ScrollBarThickness = 6
        contentScroll.ScrollBarImageColor3 = Colors.SliderTrack
        contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        contentScroll.Parent = contentFrame
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.FillDirection = Enum.FillDirection.Vertical
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.Parent = contentScroll
        
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        window.ScreenGui = screenGui
        window.MainFrame = mainFrame
        window.TabContainer = tabContainer
        window.ContentFrame = contentFrame
        window.ContentScroll = contentScroll
        window.TabTitleLabel = tabTitleLabel
        window.CurrentTabContent = nil
        window.Tabs = {}
        
        function window:CreateTab(name)
        local tab = {}
        local tabNameUpper = name:upper()
        
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "TabButton"
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.BorderSizePixel = 0
        tabButton.Text = "    " .. tabNameUpper
        tabButton.TextSize = 14
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Parent = self.TabContainer
        
        local tabIcon = Instance.new("Frame")
        tabIcon.Name = "TabIcon"
        tabIcon.Size = UDim2.new(0, 10, 0, 10)
        tabIcon.Position = UDim2.new(0, 12, 0.5, -5)
        tabIcon.BorderSizePixel = 0
        tabIcon.Parent = tabButton
    
        local bottomBorder = Instance.new("Frame")
        bottomBorder.Name = "BottomBorder"
        bottomBorder.Size = UDim2.new(1,0,0,1)
        bottomBorder.Position = UDim2.new(0,0,1,-1)
        bottomBorder.BackgroundColor3 = Colors.TabSeparatorLine
        bottomBorder.BorderSizePixel = 0
        bottomBorder.ZIndex = tabButton.ZIndex + 1
        bottomBorder.Parent = tabButton
        
        local tabContent = Instance.new("Frame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.AutomaticSize = Enum.AutomaticSize.Y
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Visible = false
        tabContent.Parent = self.ContentScroll
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.FillDirection = Enum.FillDirection.Vertical
        tabContentLayout.Padding = UDim.new(0, 8)
        tabContentLayout.Parent = tabContent
        
        if not self.Tabs then self.Tabs = {} end
        table.insert(self.Tabs, {button = tabButton, content = tabContent, icon = tabIcon, border = bottomBorder, name = name})

        local function selectThisTab()
            for _, t_info in pairs(self.Tabs) do
                t_info.content.Visible = false
                t_info.button.BackgroundColor3 = Colors.UnselectedTabBackground
                t_info.button.TextColor3 = Colors.UnselectedTabText
                t_info.icon.BackgroundColor3 = Colors.UnselectedTabIcon
                if t_info.border then
                    t_info.border.BackgroundColor3 = Colors.TabSeparatorLine
                    t_info.border.Visible = true
                end
            end
            
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Colors.DarkPrimary
            tabButton.TextColor3 = Colors.LightText
            tabIcon.BackgroundColor3 = Colors.LightText
            if bottomBorder then
                bottomBorder.Visible = false
            end
    
            if self.TabTitleLabel then
                self.TabTitleLabel.Text = tabNameUpper
            end
            self.CurrentTabContent = tabContent
        end
        
        tabButton.MouseButton1Click:Connect(function()
            selectThisTab()
        end)
        
        if #self.Tabs == 1 then
            selectThisTab()
        else
            tabButton.BackgroundColor3 = Colors.UnselectedTabBackground
            tabButton.TextColor3 = Colors.UnselectedTabText
            tabIcon.BackgroundColor3 = Colors.UnselectedTabIcon
            if bottomBorder then
                bottomBorder.BackgroundColor3 = Colors.TabSeparatorLine
                bottomBorder.Visible = true
            end
        end
        
        tab.UI = tabContent
        tab.ParentWindow = self

        function tab:CreateButton(text, callback)
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = text .. "ButtonElement"
            buttonFrame.Size = UDim2.new(1, 0, 0, 35)
            buttonFrame.BackgroundColor3 = Colors.ContentItemBackground
            buttonFrame.BorderSizePixel = 0
            buttonFrame.Parent = tab.UI
            
            local iconSize = 10 -- ขนาดของไอคอน
            local iconPadding = 10 -- ระยะห่างระหว่างขอบกับไอคอน
            local spaceAfterIcon = 5 -- ระยะห่างระหว่างไอคอนกับข้อความ

            local buttonIcon = Instance.new("Frame")
            buttonIcon.Name = "ButtonIcon"
            buttonIcon.Size = UDim2.new(0, iconSize, 0, iconSize)
            buttonIcon.Position = UDim2.new(0, iconPadding, 0.5, -(iconSize/2)) -- จัดกึ่งกลางแนวตั้ง
            buttonIcon.BackgroundColor3 = Colors.ContentItemIcon
            buttonIcon.BorderSizePixel = 0
            buttonIcon.Parent = buttonFrame
            
            local actualButton = Instance.new("TextButton")
            actualButton.Name = "ActualButton"
            actualButton.Size = UDim2.new(1, 0, 1, 0)
            actualButton.Position = UDim2.new(0,0,0,0)
            actualButton.BackgroundTransparency = 1
            actualButton.Text = text
            actualButton.TextColor3 = Colors.DarkText
            actualButton.TextSize = 14
            actualButton.TextXAlignment = Enum.TextXAlignment.Left
            actualButton.TextWrapped = true
            actualButton.Font = Enum.Font.SourceSans
            actualButton.Parent = buttonFrame

            local textPadding = Instance.new("UIPadding")
            textPadding.PaddingLeft = UDim.new(0, iconPadding + iconSize + spaceAfterIcon)
            textPadding.Parent = actualButton

            actualButton.MouseEnter:Connect(function()
                if TweenService and Colors and Colors.SliderTrack then
                    TweenService:Create(buttonFrame, TweenInfo.new(0.15), {BackgroundColor3 = Colors.SliderTrack}):Play()
                end
            end)
            actualButton.MouseLeave:Connect(function()
                if TweenService and Colors and Colors.ContentItemBackground then
                    TweenService:Create(buttonFrame, TweenInfo.new(0.15), {BackgroundColor3 = Colors.ContentItemBackground}):Play()
                end
            end)
            actualButton.MouseButton1Click:Connect(function()
                if callback then pcall(callback) end
            end)
            return actualButton
        end
        
        function tab:CreateSlider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = text .. "SliderElement"
            sliderFrame.Size = UDim2.new(1, 0, 0, 35)
            sliderFrame.BackgroundColor3 = Colors.ContentItemBackground
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = self.UI
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Name = "ValueLabel"
            valueLabel.Size = UDim2.new(0, 30, 1, 0)
            valueLabel.Position = UDim2.new(0, 10, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(math.floor(default))
            valueLabel.TextColor3 = Colors.DarkText
            valueLabel.TextSize = 14
            valueLabel.TextXAlignment = Enum.TextXAlignment.Left
            valueLabel.Font = Enum.Font.SourceSans
            valueLabel.Parent = sliderFrame
            
            local sliderTextLabel = Instance.new("TextLabel")
            sliderTextLabel.Name = "SliderTextLabel"
            sliderTextLabel.Size = UDim2.new(0, 120, 1, 0)
            sliderTextLabel.Position = UDim2.new(0, valueLabel.Position.X.Offset + valueLabel.Size.X.Offset + 5, 0, 0)
            sliderTextLabel.BackgroundTransparency = 1
            sliderTextLabel.Text = text
            sliderTextLabel.TextColor3 = Colors.DarkText
            sliderTextLabel.TextSize = 14
            sliderTextLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderTextLabel.Font = Enum.Font.SourceSans
            sliderTextLabel.Parent = sliderFrame

            local sliderTrackWidth = 150
            local sliderTrackHeight = 6

            local sliderTrack = Instance.new("Frame")
            sliderTrack.Name = "SliderTrack"
            sliderTrack.Size = UDim2.new(0, sliderTrackWidth, 0, sliderTrackHeight)
            sliderTrack.Position = UDim2.new(1, -sliderTrackWidth - 15, 0.5, -(sliderTrackHeight/2))
            sliderTrack.BackgroundColor3 = Colors.SliderTrack
            sliderTrack.BorderSizePixel = 0
            sliderTrack.Parent = sliderFrame
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "SliderFill"
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Colors.SliderFill
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderTrack
            
            local sliderHandle = Instance.new("Frame")
            sliderHandle.Name = "SliderHandle"
            sliderHandle.Size = UDim2.new(0, 2, 0, 12)
            sliderHandle.Position = UDim2.new(sliderFill.Size.X.Scale, -1, 0.5, -6)
            sliderHandle.BackgroundColor3 = Colors.SliderHandle
            sliderHandle.BorderSizePixel = 0
            sliderHandle.ZIndex = sliderTrack.ZIndex + 1
            sliderHandle.Parent = sliderTrack
            
            local draggingSlider = false
            local currentValue = default
            
            local function updateSlider(inputPos)
                local relativeX = inputPos.X - sliderTrack.AbsolutePosition.X
                local percentage = math.clamp(relativeX / sliderTrack.AbsoluteSize.X, 0, 1)
                local value = min + (max - min) * percentage
                currentValue = value
                
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                sliderHandle.Position = UDim2.new(percentage, -sliderHandle.Size.X.Offset / 2, 0.5, -sliderHandle.Size.Y.Offset / 2)
                valueLabel.Text = tostring(math.floor(currentValue))
                
                if callback then pcall(callback, currentValue) end
            end
            
            sliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    updateSlider(input.Position)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and draggingSlider then
                    updateSlider(input.Position)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)
            
            return {
                Frame = sliderFrame,
                GetValue = function() return currentValue end,
                SetValue = function(val) 
                    currentValue = math.clamp(val, min, max)
                    local percentage = (currentValue - min) / (max - min)
                    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    sliderHandle.Position = UDim2.new(percentage, -sliderHandle.Size.X.Offset / 2, 0.5, -sliderHandle.Size.Y.Offset / 2)
                    valueLabel.Text = tostring(math.floor(currentValue))
                    if callback then pcall(callback, currentValue) end
                end
            }
        end
        
        function tab:CreateToggle(text, default, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = text .. "ToggleElement"
            toggleFrame.Size = UDim2.new(1, 0, 0, 35)
            toggleFrame.BackgroundColor3 = Colors.ContentItemBackground
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = self.UI
            
            local toggleIcon = Instance.new("Frame")
            toggleIcon.Name = "ToggleIcon"
            toggleIcon.Size = UDim2.new(0, 10, 0, 10)
            toggleIcon.Position = UDim2.new(0, 10, 0.5, -5)
            toggleIcon.BackgroundColor3 = Colors.ContentItemIcon
            toggleIcon.BorderSizePixel = 0
            toggleIcon.Parent = toggleFrame
            
            local toggleTextLabel = Instance.new("TextLabel")
            toggleTextLabel.Name = "ToggleTextLabel"
            toggleTextLabel.Size = UDim2.new(1, -80, 1, 0)
            toggleTextLabel.Position = UDim2.new(0, toggleIcon.Position.X.Offset + toggleIcon.Size.X.Offset + 5, 0, 0)
            toggleTextLabel.BackgroundTransparency = 1
            toggleTextLabel.Text = text
            toggleTextLabel.TextColor3 = Colors.DarkText
            toggleTextLabel.TextSize = 14
            toggleTextLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleTextLabel.Font = Enum.Font.SourceSans
            toggleTextLabel.Parent = toggleFrame
            
            local toggleStatus = Instance.new("TextLabel")
            toggleStatus.Name = "ToggleStatus"
            toggleStatus.Size = UDim2.new(0, 50, 1, 0)
            toggleStatus.Position = UDim2.new(1, -55, 0, 0)
            toggleStatus.BackgroundTransparency = 1
            toggleStatus.Text = default and "ON" or "OFF"
            toggleStatus.TextColor3 = default and Colors.ToggleOnText or Colors.ToggleOffText
            toggleStatus.TextSize = 14
            toggleStatus.TextXAlignment = Enum.TextXAlignment.Right
            toggleStatus.Font = Enum.Font.SourceSans
            toggleStatus.Parent = toggleFrame
            
            local actualButton = Instance.new("TextButton")
            actualButton.Name = "ActualButton"
            actualButton.Size = UDim2.new(1,0,1,0)
            actualButton.BackgroundTransparency = 1
            actualButton.Text = ""
            actualButton.Parent = toggleFrame

            local isToggled = default or false
            
            local function updateToggleVisuals()
                toggleStatus.Text = isToggled and "ON" or "OFF"
                toggleStatus.TextColor3 = isToggled and Colors.ToggleOnText or Colors.ToggleOffText
            end
            
            actualButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                updateToggleVisuals()
                if callback then pcall(callback, isToggled) end
            end)
            actualButton.MouseEnter:Connect(function()
                TweenService:Create(toggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = Colors.SliderTrack}):Play()
            end)
            actualButton.MouseLeave:Connect(function()
                TweenService:Create(toggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = Colors.ContentItemBackground}):Play()
            end)
            
            return {
                Frame = toggleFrame,
                GetValue = function() return isToggled end,
                SetValue = function(value) 
                    isToggled = value
                    updateToggleVisuals()
                end
            }
        end

        function tab:CreateHeader(text)
            local header = Instance.new("TextLabel")
            header.Name = "Header"
            header.Size = UDim2.new(1, 0, 0, 30)
            header.BackgroundTransparency = 1
            header.Text = text
            header.TextColor3 = Colors.ContentTitleText
            header.TextSize = 18
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.Font = Enum.Font.SourceSansBold
            header.Parent = self.UI
            return header
        end
        
        function tab:CreateParagraph(text)
            local paragraph = Instance.new("TextLabel")
            paragraph.Name = "Paragraph"
            paragraph.Size = UDim2.new(1, 0, 0, 20)
            paragraph.BackgroundTransparency = 1
            paragraph.Text = text
            paragraph.TextColor3 = Colors.DarkText
            paragraph.TextSize = 14
            paragraph.TextXAlignment = Enum.TextXAlignment.Left
            paragraph.TextWrapped = true
            paragraph.Font = Enum.Font.SourceSans
            paragraph.Parent = self.UI
            
            coroutine.wrap(function()
                wait() 
                local availableWidth = paragraph.AbsoluteSize.X
                if availableWidth == 0 and self.UI.Parent.AbsoluteSize.X > 0 then
                    availableWidth = self.UI.Parent.AbsoluteSize.X - (contentLayout.Padding.Offset * 2)
                end
                if availableWidth > 0 then
                    local textSize = game:GetService("TextService"):GetTextSize(text, 14, Enum.Font.SourceSans, Vector2.new(availableWidth, math.huge))
                    paragraph.Size = UDim2.new(1, 0, 0, textSize.Y + 5)
                else
                     paragraph.AutomaticSize = Enum.AutomaticSize.Y
                end
            end)()
            return paragraph
        end
        
        return tab
    end
    
    return window
end

return KukuriLib
