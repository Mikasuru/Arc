-- Kukuri UI Library (Redesigned)
-- Custom UI Library for Roblox

local KukuriLib = {}
KukuriLib.__index = KukuriLib

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Main Library Functions
function KukuriLib:CreateWindow(title, subtitle)
    local window = {}
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KukuriLib"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 650, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(198, 189, 171)
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(120, 120, 120)
    mainFrame.Parent = screenGui
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(92, 84, 69)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    -- Title Icon
    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Name = "TitleIcon"
    titleIcon.Size = UDim2.new(0, 16, 0, 16)
    titleIcon.Position = UDim2.new(0, 8, 0, 7)
    titleIcon.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    titleIcon.BorderSizePixel = 0
    titleIcon.Image = ""
    titleIcon.Parent = titleBar
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -32, 1, 0)
    titleLabel.Position = UDim2.new(0, 32, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Label"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.SourceSans
    titleLabel.Parent = titleBar
    
    -- Tab Container (Left Side)
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 200, 1, -30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(168, 159, 141)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    -- Tab List Layout
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.FillDirection = Enum.FillDirection.Vertical
    tabListLayout.Padding = UDim.new(0, 1)
    tabListLayout.Parent = tabContainer
    
    -- Content Frame (Right Side)
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -200, 1, -30)
    contentFrame.Position = UDim2.new(0, 200, 0, 30)
    contentFrame.BackgroundColor3 = Color3.fromRGB(198, 189, 171)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    -- Tab Title in Content
    local tabTitle = Instance.new("TextLabel")
    tabTitle.Name = "TabTitle"
    tabTitle.Size = UDim2.new(1, -20, 0, 40)
    tabTitle.Position = UDim2.new(0, 10, 0, 10)
    tabTitle.BackgroundTransparency = 1
    tabTitle.Text = "TAB 1"
    tabTitle.TextColor3 = Color3.fromRGB(60, 60, 60)
    tabTitle.TextSize = 24
    tabTitle.TextXAlignment = Enum.TextXAlignment.Left
    tabTitle.Font = Enum.Font.SourceSansBold
    tabTitle.Parent = contentFrame
    
    -- Content Scroll Frame
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "ContentScroll"
    contentScroll.Size = UDim2.new(1, -20, 1, -60)
    contentScroll.Position = UDim2.new(0, 10, 0, 50)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 8
    contentScroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.Parent = contentFrame
    
    -- Content Layout
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.FillDirection = Enum.FillDirection.Vertical
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = contentScroll
    
    -- Content Padding
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 5)
    contentPadding.PaddingLeft = UDim.new(0, 5)
    contentPadding.PaddingRight = UDim.new(0, 5)
    contentPadding.PaddingBottom = UDim.new(0, 5)
    contentPadding.Parent = contentScroll
    
    -- Make window draggable
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
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.ContentFrame = contentFrame
    window.ContentScroll = contentScroll
    window.TabTitle = tabTitle
    window.CurrentTab = nil
    window.TabCount = 0
    
    function window:CreateTab(name)
        local tab = {}
        self.TabCount = self.TabCount + 1
        
        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.BackgroundColor3 = Color3.fromRGB(140, 131, 113)
        tabButton.BorderSizePixel = 0
        tabButton.Text = "  " .. name
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 14
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Parent = self.TabContainer
        
        -- Tab Icon
        local tabIcon = Instance.new("Frame")
        tabIcon.Name = "TabIcon"
        tabIcon.Size = UDim2.new(0, 12, 0, 12)
        tabIcon.Position = UDim2.new(0, 8, 0.5, -6)
        tabIcon.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        tabIcon.BorderSizePixel = 0
        tabIcon.Parent = tabButton
        
        -- Tab Content Frame
        local tabContent = Instance.new("Frame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Visible = false
        tabContent.Parent = self.ContentScroll
        
        -- Tab Content Layout
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.FillDirection = Enum.FillDirection.Vertical
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout.Parent = tabContent
        
        -- Tab Selection Logic
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, child in pairs(self.ContentScroll:GetChildren()) do
                if child:IsA("Frame") and child.Name:find("Content") then
                    child.Visible = false
                end
            end
            
            -- Reset all tab buttons
            for _, child in pairs(self.TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(140, 131, 113)
                end
            end
            
            -- Show selected tab
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            self.TabTitle.Text = name:upper()
            self.CurrentTab = tabContent
        end)
        
        -- Select first tab by default
        if self.TabCount == 1 then
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            tabContent.Visible = true
            self.TabTitle.Text = name:upper()
            self.CurrentTab = tabContent
        end
        
        tab.Button = tabButton
        tab.Content = tabContent
        tab.Parent = self
        
        -- Tab Methods
        function tab:CreateButton(text, callback)
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = "ButtonFrame"
            buttonFrame.Size = UDim2.new(1, 0, 0, 35)
            buttonFrame.BackgroundTransparency = 1
            buttonFrame.Parent = self.Content
            
            local button = Instance.new("TextButton")
            button.Name = "Button"
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            button.BorderSizePixel = 1
            button.BorderColor3 = Color3.fromRGB(80, 80, 80)
            button.Text = "  " .. text
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.TextXAlignment = Enum.TextXAlignment.Left
            button.Font = Enum.Font.SourceSans
            button.Parent = buttonFrame
            
            -- Button Icon
            local buttonIcon = Instance.new("Frame")
            buttonIcon.Name = "ButtonIcon"
            buttonIcon.Size = UDim2.new(0, 12, 0, 12)
            buttonIcon.Position = UDim2.new(0, 8, 0.5, -6)
            buttonIcon.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            buttonIcon.BorderSizePixel = 0
            buttonIcon.Parent = button
            
            -- Button Animation
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 140, 140)}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 120, 120)}):Play()
            end)
            
            button.MouseButton1Click:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
                wait(0.1)
                TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(120, 120, 120)}):Play()
                
                if callback then
                    callback()
                end
            end)
            
            return button
        end
        
        function tab:CreateSlider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = "SliderFrame"
            sliderFrame.Size = UDim2.new(1, 0, 0, 35)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            sliderFrame.BorderSizePixel = 1
            sliderFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
            sliderFrame.Parent = self.Content
            
            -- Slider Icon
            local sliderIcon = Instance.new("Frame")
            sliderIcon.Name = "SliderIcon"
            sliderIcon.Size = UDim2.new(0, 12, 0, 12)
            sliderIcon.Position = UDim2.new(0, 8, 0.5, -6)
            sliderIcon.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            sliderIcon.BorderSizePixel = 0
            sliderIcon.Parent = sliderFrame
            
            -- Slider Value Label
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Name = "ValueLabel"
            valueLabel.Size = UDim2.new(0, 30, 1, 0)
            valueLabel.Position = UDim2.new(0, 25, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            valueLabel.TextSize = 14
            valueLabel.TextXAlignment = Enum.TextXAlignment.Left
            valueLabel.Font = Enum.Font.SourceSans
            valueLabel.Parent = sliderFrame
            
            -- Slider Text
            local sliderText = Instance.new("TextLabel")
            sliderText.Name = "SliderText"
            sliderText.Size = UDim2.new(0, 100, 1, 0)
            sliderText.Position = UDim2.new(0, 60, 0, 0)
            sliderText.BackgroundTransparency = 1
            sliderText.Text = text
            sliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
            sliderText.TextSize = 14
            sliderText.TextXAlignment = Enum.TextXAlignment.Left
            sliderText.Font = Enum.Font.SourceSans
            sliderText.Parent = sliderFrame
            
            -- Slider Track
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Name = "SliderTrack"
            sliderTrack.Size = UDim2.new(0, 150, 0, 4)
            sliderTrack.Position = UDim2.new(1, -160, 0.5, -2)
            sliderTrack.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            sliderTrack.BorderSizePixel = 0
            sliderTrack.Parent = sliderFrame
            
            -- Slider Fill
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "SliderFill"
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderTrack
            
            -- Slider Handle
            local sliderHandle = Instance.new("Frame")
            sliderHandle.Name = "SliderHandle"
            sliderHandle.Size = UDim2.new(0, 8, 0, 12)
            sliderHandle.Position = UDim2.new((default - min) / (max - min), -4, 0.5, -6)
            sliderHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            sliderHandle.BorderSizePixel = 1
            sliderHandle.BorderColor3 = Color3.fromRGB(40, 40, 40)
            sliderHandle.Parent = sliderTrack
            
            -- Slider Logic
            local dragging = false
            local currentValue = default
            
            local function updateSlider(value)
                value = math.clamp(value, min, max)
                currentValue = value
                local percentage = (value - min) / (max - min)
                
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                sliderHandle.Position = UDim2.new(percentage, -4, 0.5, -6)
                valueLabel.Text = tostring(math.floor(value))
                
                if callback then
                    callback(value)
                end
            end
            
            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local relativeX = input.Position.X - sliderTrack.AbsolutePosition.X
                    local percentage = math.clamp(relativeX / sliderTrack.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * percentage
                    updateSlider(value)
                end
            end)
            
            sliderTrack.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                    local relativeX = input.Position.X - sliderTrack.AbsolutePosition.X
                    local percentage = math.clamp(relativeX / sliderTrack.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * percentage
                    updateSlider(value)
                end
            end)
            
            sliderTrack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            return {
                Frame = sliderFrame,
                GetValue = function() return currentValue end,
                SetValue = updateSlider
            }
        end
        
        function tab:CreateToggle(text, default, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = "ToggleFrame"
            toggleFrame.Size = UDim2.new(1, 0, 0, 35)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            toggleFrame.BorderSizePixel = 1
            toggleFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
            toggleFrame.Parent = self.Content
            
            -- Toggle Icon
            local toggleIcon = Instance.new("Frame")
            toggleIcon.Name = "ToggleIcon"
            toggleIcon.Size = UDim2.new(0, 12, 0, 12)
            toggleIcon.Position = UDim2.new(0, 8, 0.5, -6)
            toggleIcon.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            toggleIcon.BorderSizePixel = 0
            toggleIcon.Parent = toggleFrame
            
            -- Toggle Text
            local toggleText = Instance.new("TextLabel")
            toggleText.Name = "ToggleText"
            toggleText.Size = UDim2.new(1, -100, 1, 0)
            toggleText.Position = UDim2.new(0, 25, 0, 0)
            toggleText.BackgroundTransparency = 1
            toggleText.Text = text
            toggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleText.TextSize = 14
            toggleText.TextXAlignment = Enum.TextXAlignment.Left
            toggleText.Font = Enum.Font.SourceSans
            toggleText.Parent = toggleFrame
            
            -- Toggle Status
            local toggleStatus = Instance.new("TextLabel")
            toggleStatus.Name = "ToggleStatus"
            toggleStatus.Size = UDim2.new(0, 50, 1, 0)
            toggleStatus.Position = UDim2.new(1, -55, 0, 0)
            toggleStatus.BackgroundTransparency = 1
            toggleStatus.Text = default and "ON" or "OFF"
            toggleStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
            toggleStatus.TextSize = 14
            toggleStatus.TextXAlignment = Enum.TextXAlignment.Right
            toggleStatus.Font = Enum.Font.SourceSans
            toggleStatus.Parent = toggleFrame
            
            -- Toggle Button
            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "ToggleButton"
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.Position = UDim2.new(0, 0, 0, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            -- Toggle Logic
            local isToggled = default or false
            
            local function updateToggle()
                toggleStatus.Text = isToggled and "ON" or "OFF"
                toggleStatus.TextColor3 = isToggled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(180, 180, 180)
                
                if callback then
                    callback(isToggled)
                end
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                updateToggle()
            end)
            
            -- Hover effect
            toggleButton.MouseEnter:Connect(function()
                TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 140, 140)}):Play()
            end)
            
            toggleButton.MouseLeave:Connect(function()
                TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 120, 120)}):Play()
            end)
            
            -- Initialize
            updateToggle()
            
            return {
                Frame = toggleFrame,
                GetValue = function() return isToggled end,
                SetValue = function(value) 
                    isToggled = value
                    updateToggle()
                end
            }
        end
        
        function tab:CreateHeader(text)
            local header = Instance.new("TextLabel")
            header.Name = "Header"
            header.Size = UDim2.new(1, 0, 0, 30)
            header.BackgroundTransparency = 1
            header.Text = text
            header.TextColor3 = Color3.fromRGB(60, 60, 60)
            header.TextSize = 18
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.Font = Enum.Font.SourceSansBold
            header.Parent = self.Content
            
            return header
        end
        
        function tab:CreateParagraph(text)
            local paragraph = Instance.new("TextLabel")
            paragraph.Name = "Paragraph"
            paragraph.Size = UDim2.new(1, 0, 0, 20)
            paragraph.BackgroundTransparency = 1
            paragraph.Text = text
            paragraph.TextColor3 = Color3.fromRGB(80, 80, 80)
            paragraph.TextSize = 14
            paragraph.TextXAlignment = Enum.TextXAlignment.Left
            paragraph.TextWrapped = true
            paragraph.Font = Enum.Font.SourceSans
            paragraph.Parent = self.Content
            
            -- Auto-resize based on text
            local textSize = game:GetService("TextService"):GetTextSize(text, 14, Enum.Font.SourceSans, Vector2.new(paragraph.AbsoluteSize.X, math.huge))
            paragraph.Size = UDim2.new(1, 0, 0, textSize.Y + 5)
            
            return paragraph
        end
        
        return tab
    end
    
    return window
end

return KukuriLib
