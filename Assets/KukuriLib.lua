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
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Corner for Main Frame
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame
    
    -- Header Frame
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "HeaderFrame"
    headerFrame.Size = UDim2.new(1, 0, 0, 50)
    headerFrame.Position = UDim2.new(0, 0, 0, 0)
    headerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = mainFrame
    
    -- Header Corner
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = headerFrame
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Kukuri Library"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = headerFrame
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, -50)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    -- Tab List Layout
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.FillDirection = Enum.FillDirection.Vertical
    tabListLayout.Padding = UDim.new(0, 2)
    tabListLayout.Parent = tabContainer
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -150, 1, -50)
    contentFrame.Position = UDim2.new(0, 150, 0, 50)
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    -- Content Layout
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.FillDirection = Enum.FillDirection.Vertical
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = contentFrame
    
    -- Content Padding
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.Parent = contentFrame
    
    -- Make window draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    headerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    headerFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    headerFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.ContentFrame = contentFrame
    window.CurrentTab = nil
    
    function window:CreateTab(name)
        local tab = {}
        
        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tabButton.BorderSizePixel = 0
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.Gotham
        tabButton.Parent = self.TabContainer
        
        -- Tab Button Corner
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4)
        tabCorner.Parent = tabButton
        
        -- Tab Content Frame
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.Visible = false
        tabContent.Parent = self.ContentFrame
        
        -- Tab Content Layout
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.FillDirection = Enum.FillDirection.Vertical
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout.Parent = tabContent
        
        -- Tab Content Padding
        local tabPadding = Instance.new("UIPadding")
        tabPadding.PaddingTop = UDim.new(0, 5)
        tabPadding.PaddingLeft = UDim.new(0, 5)
        tabPadding.PaddingRight = UDim.new(0, 5)
        tabPadding.PaddingBottom = UDim.new(0, 5)
        tabPadding.Parent = tabContent
        
        -- Tab Selection Logic
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, child in pairs(self.ContentFrame:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            
            -- Reset all tab buttons
            for _, child in pairs(self.TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    child.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            
            -- Show selected tab
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            self.CurrentTab = tabContent
        end)
        
        -- Select first tab by default
        if not self.CurrentTab then
            tabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabContent.Visible = true
            self.CurrentTab = tabContent
        end
        
        tab.Button = tabButton
        tab.Content = tabContent
        tab.Parent = self
        
        -- Tab Methods
        function tab:CreateHeader(text)
            local header = Instance.new("TextLabel")
            header.Name = "Header"
            header.Size = UDim2.new(1, 0, 0, 30)
            header.BackgroundTransparency = 1
            header.Text = text
            header.TextColor3 = Color3.fromRGB(255, 255, 255)
            header.TextSize = 16
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.Font = Enum.Font.GothamBold
            header.Parent = self.Content
            
            return header
        end
        
        function tab:CreateParagraph(text)
            local paragraph = Instance.new("TextLabel")
            paragraph.Name = "Paragraph"
            paragraph.Size = UDim2.new(1, 0, 0, 20)
            paragraph.BackgroundTransparency = 1
            paragraph.Text = text
            paragraph.TextColor3 = Color3.fromRGB(180, 180, 180)
            paragraph.TextSize = 12
            paragraph.TextXAlignment = Enum.TextXAlignment.Left
            paragraph.TextWrapped = true
            paragraph.Font = Enum.Font.Gotham
            paragraph.Parent = self.Content
            
            -- Auto-resize based on text
            paragraph.Size = UDim2.new(1, 0, 0, paragraph.TextBounds.Y + 5)
            
            return paragraph
        end
        
        function tab:CreateButton(text, callback)
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = "ButtonFrame"
            buttonFrame.Size = UDim2.new(1, 0, 0, 35)
            buttonFrame.BackgroundTransparency = 1
            buttonFrame.Parent = self.Content
            
            local button = Instance.new("TextButton")
            button.Name = "Button"
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.Parent = buttonFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = button
            
            -- Button Animation
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 150, 200)}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 130, 180)}):Play()
            end)
            
            button.MouseButton1Click:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 110, 160)}):Play()
                wait(0.1)
                TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 130, 180)}):Play()
                
                if callback then
                    callback()
                end
            end)
            
            return button
        end
        
        function tab:CreateSlider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = "SliderFrame"
            sliderFrame.Size = UDim2.new(1, 0, 0, 60)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = self.Content
            
            -- Slider Label
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Name = "SliderLabel"
            sliderLabel.Size = UDim2.new(1, 0, 0, 20)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = text .. ": " .. tostring(default)
            sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sliderLabel.TextSize = 14
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.Parent = sliderFrame
            
            -- Slider Background
            local sliderBg = Instance.new("Frame")
            sliderBg.Name = "SliderBackground"
            sliderBg.Size = UDim2.new(1, 0, 0, 20)
            sliderBg.Position = UDim2.new(0, 0, 0, 30)
            sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = sliderFrame
            
            local sliderBgCorner = Instance.new("UICorner")
            sliderBgCorner.CornerRadius = UDim.new(0, 10)
            sliderBgCorner.Parent = sliderBg
            
            -- Slider Fill
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "SliderFill"
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(0, 10)
            sliderFillCorner.Parent = sliderFill
            
            -- Slider Handle
            local sliderHandle = Instance.new("Frame")
            sliderHandle.Name = "SliderHandle"
            sliderHandle.Size = UDim2.new(0, 20, 0, 20)
            sliderHandle.Position = UDim2.new((default - min) / (max - min), -10, 0, 0)
            sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderHandle.BorderSizePixel = 0
            sliderHandle.Parent = sliderBg
            
            local sliderHandleCorner = Instance.new("UICorner")
            sliderHandleCorner.CornerRadius = UDim.new(0, 10)
            sliderHandleCorner.Parent = sliderHandle
            
            -- Slider Logic
            local dragging = false
            local currentValue = default
            
            local function updateSlider(value)
                value = math.clamp(value, min, max)
                currentValue = value
                local percentage = (value - min) / (max - min)
                
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                sliderHandle.Position = UDim2.new(percentage, -10, 0, 0)
                sliderLabel.Text = text .. ": " .. tostring(math.floor(value * 100) / 100)
                
                if callback then
                    callback(value)
                end
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local relativeX = input.Position.X - sliderBg.AbsolutePosition.X
                    local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * percentage
                    updateSlider(value)
                end
            end)
            
            sliderBg.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                    local relativeX = input.Position.X - sliderBg.AbsolutePosition.X
                    local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * percentage
                    updateSlider(value)
                end
            end)
            
            sliderBg.InputEnded:Connect(function(input)
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
        
        return tab
    end
    
    return window
end

return KukuriLib
