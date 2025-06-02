local KukuriLib = {}
KukuriLib.__index = KukuriLib

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local SplashTime = 3
local uiToggleKey = Enum.KeyCode.LeftCtrl
local mainScreenGuiInstance = nil

local OPEN_ANIM_DURATION = 0.5 
local CLOSE_ANIM_DURATION = 0.4

local KukuriLib_isUiVisible = false

local function playUiOpenAnimation(screenGui, mainFrame)
    if not mainFrame or not screenGui then return end
    
    screenGui.Enabled = true
    
    mainFrame.Visible = true
    mainFrame.BackgroundTransparency = 1
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Rotation = -15

    for _, child in pairs(mainFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child.Visible = false
        end
    end
    
    local mainFrameTween = TweenService:Create(mainFrame, 
        TweenInfo.new(OPEN_ANIM_DURATION, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
        {
            Size = UDim2.new(0, 650, 0, 450),
            BackgroundTransparency = mainFrame:GetAttribute("OriginalTransparency") or 0,
            Rotation = 0
        }
    )
    mainFrameTween:Play()
    mainFrameTween.Completed:Wait()

    local titleBar = mainFrame:FindFirstChild("TitleBar")
    local tabContainer = mainFrame:FindFirstChild("TabContainer")
    local contentFrame = mainFrame:FindFirstChild("ContentFrame")

    local childrenToShow = {}
    if titleBar then table.insert(childrenToShow, titleBar) end
    if tabContainer then table.insert(childrenToShow, tabContainer) end
    if contentFrame then table.insert(childrenToShow, contentFrame) end

    for _, child in pairs(childrenToShow) do
        child.Visible = true
        child.Transparency = 1
        local originalPosition = child:GetAttribute("OriginalPosition") or child.Position
        
        if child.Name == "TitleBar" then
            child.Position = originalPosition - UDim2.new(0,0,0,20)
        elseif child.Name == "TabContainer" then
            child.Position = originalPosition - UDim2.new(0,20,0,0)
        elseif child.Name == "ContentFrame" then
             child.Position = originalPosition + UDim2.new(0,20,0,0)
        end
        
        TweenService:Create(child, 
            TweenInfo.new(OPEN_ANIM_DURATION * 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {
                Position = originalPosition,
                Transparency = 0
            }
        ):Play()
        task.wait(0.05)
    end
end

local function playUiCloseAnimation(screenGui, mainFrame)
    if not mainFrame or not screenGui then return end
    
    local titleBar = mainFrame:FindFirstChild("TitleBar")
    local tabContainer = mainFrame:FindFirstChild("TabContainer")
    local contentFrame = mainFrame:FindFirstChild("ContentFrame")
    
    local childrenToHide = {}
    if contentFrame then table.insert(childrenToHide, contentFrame) end
    if tabContainer then table.insert(childrenToHide, tabContainer) end
    if titleBar then table.insert(childrenToHide, titleBar) end

    for _, child in pairs(childrenToHide) do
        local targetPosition
        local originalPosition = child:GetAttribute("OriginalPosition") or child.Position

        if child.Name == "TitleBar" then
            targetPosition = originalPosition - UDim2.new(0,0,0,20)
        elseif child.Name == "TabContainer" then
            targetPosition = originalPosition - UDim2.new(0,20,0,0)
        elseif child.Name == "ContentFrame" then
             targetPosition = originalPosition + UDim2.new(0,20,0,0)
        else
            targetPosition = originalPosition
        end

        TweenService:Create(child, 
            TweenInfo.new(CLOSE_ANIM_DURATION * 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {
                Position = targetPosition,
                Transparency = 1
            }
        ):Play()
        task.wait(0.03)
    end
    
    task.wait(CLOSE_ANIM_DURATION * 0.4)

    local mainFrameTween = TweenService:Create(mainFrame, 
        TweenInfo.new(CLOSE_ANIM_DURATION, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
        {
            Size = UDim2.new(0, mainFrame.AbsoluteSize.X * 0.2, 0, mainFrame.AbsoluteSize.Y * 0.2),
            BackgroundTransparency = 1,
            Rotation = 30,
            Position = UDim2.new(0.5, 0, 0.8, 0)
        }
    )
    mainFrameTween:Play()
    
    mainFrameTween.Completed:Wait()
    mainFrame.Visible = false
    screenGui.Enabled = false
end

function KukuriLib:ToggleUI()
    print("Library: ToggleUI CALLED (Simplified Test).")
    if not mainScreenGuiInstance or not mainScreenGuiInstance.Parent then
        warn("KukuriLib: Simplified ToggleUI - mainScreenGuiInstance or parent missing.")
        return
    end
    local mainFrame = mainScreenGuiInstance:FindFirstChild("MainFrame")
    if not mainFrame then
        warn("KukuriLib: Simplified ToggleUI - MainFrame missing.")
        return
    end

    if mainScreenGuiInstance.Enabled then
        print("Library: Simplified ToggleUI - Disabling ScreenGui.")
        mainScreenGuiInstance.Enabled = false
        mainFrame.Visible = false
    else
        print("Library: Simplified ToggleUI - Enabling ScreenGui.")
        mainScreenGuiInstance.Enabled = true
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 650, 0, 450)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        mainFrame.Rotation = 0
        mainFrame.BackgroundTransparency = 0
    end
end


local function SplashScreen(callbackAfterSplash)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")

    local player = Players.LocalPlayer
    if not player then 
        if callbackAfterSplash then task.defer(callbackAfterSplash) end
        return 
    end

    local splashScreenGui = Instance.new("ScreenGui")
    splashScreenGui.Name = "KukuriCustomSplashScreen"
    splashScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    splashScreenGui.ResetOnSpawn = false
    splashScreenGui.IgnoreGuiInset = true
    splashScreenGui.DisplayOrder = 1000
    
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "SplashContainer"
    mainContainer.Size = UDim2.new(1, 0, 1, 0)
    mainContainer.BackgroundTransparency = 1
    mainContainer.Parent = splashScreenGui

    local splashOverallSize = 250

    local starContainer = Instance.new("Frame")
    starContainer.Name = "StarContainer"
    starContainer.Size = UDim2.new(0, splashOverallSize, 0, splashOverallSize)
    starContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    starContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    starContainer.BackgroundTransparency = 1
    starContainer.ClipsDescendants = false
    starContainer.Parent = mainContainer

    local starColor = Color3.fromRGB(60, 55, 50)
    local starTransparencyStart = 1

    local square1 = Instance.new("Frame")
    square1.Name = "StarSquare1"
    square1.Size = UDim2.new(0.7071, 0, 0.7071, 0)
    
    square1.AnchorPoint = Vector2.new(0.5, 0.5)
    square1.Position = UDim2.new(0.5, 0, 0.5, 0)
    square1.BackgroundColor3 = starColor
    square1.BackgroundTransparency = starTransparencyStart
    square1.BorderSizePixel = 0
    square1.Parent = starContainer

    local square2 = Instance.new("Frame")
    square2.Name = "StarSquare2"
    square2.Size = square1.Size
    square2.AnchorPoint = Vector2.new(0.5, 0.5)
    square2.Position = UDim2.new(0.5, 0, 0.5, 0)
    square2.BackgroundColor3 = starColor
    square2.BackgroundTransparency = starTransparencyStart
    square2.BorderSizePixel = 0
    square2.Rotation = 45
    square2.Parent = starContainer

    local cubeViewportSize = splashOverallSize * 0.5
    local viewportFrame = Instance.new("ViewportFrame")
    viewportFrame.Name = "CubeViewport"
    viewportFrame.Size = UDim2.new(0, cubeViewportSize, 0, cubeViewportSize)
    viewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    viewportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    viewportFrame.BackgroundTransparency = 1
    viewportFrame.Ambient = Color3.new(0.6, 0.6, 0.6)
    viewportFrame.LightColor = Color3.new(0.9, 0.9, 0.9)
    viewportFrame.LightDirection = Vector3.new(0.3, -0.8, 0.5).Unit
    viewportFrame.ZIndex = 2
    viewportFrame.Parent = starContainer

    local viewportCamera = Instance.new("Camera")
    viewportCamera.Parent = viewportFrame
    viewportFrame.CurrentCamera = viewportCamera
    viewportCamera.CFrame = CFrame.lookAt(Vector3.new(0, 1.5, 3.5), Vector3.new(0, 0, 0)) 
    viewportCamera.FieldOfView = 30

    local worldModel = Instance.new("WorldModel")
    worldModel.Parent = viewportFrame

    local cube = Instance.new("Part")
    cube.Name = "SpinningCube"
    cube.Size = Vector3.new(1.0, 1.0, 1.0)
    cube.Anchored = true
    cube.CanCollide = false
    cube.Color = Color3.fromRGB(228, 223, 212)
    cube.Material = Enum.Material.SmoothPlastic
    cube.Reflectance = 0.1
    cube.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(20), math.rad(30), math.rad(10))
    cube.Transparency = starTransparencyStart
    cube.Parent = worldModel

    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 0.6
    pointLight.Color = Color3.fromRGB(220,220,255)
    pointLight.Range = 7
    pointLight.Parent = cube

    local rotationAngle = 0
    local rotationAxis = Vector3.new(0.5, 1, 0.2).Unit
    local rotationSpeed = math.rad(120)
    local cubeRotationConnection
    cubeRotationConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if cube and cube.Parent then
            rotationAngle = rotationAngle + rotationSpeed * deltaTime
            cube.CFrame = CFrame.fromAxisAngle(rotationAxis, rotationAngle) * CFrame.Angles(math.rad(20), math.rad(30), math.rad(10))
        else
            if cubeRotationConnection then cubeRotationConnection:Disconnect(); cubeRotationConnection = nil end
        end
    end)

    splashScreenGui.Parent = CoreGui

    local tweenInfoFade = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local square1FadeIn = TweenService:Create(square1, tweenInfoFade, {BackgroundTransparency = 0})
    local square2FadeIn = TweenService:Create(square2, tweenInfoFade, {BackgroundTransparency = 0})
    local cubeFadeIn = TweenService:Create(cube, tweenInfoFade, {Transparency = 0})
    
    square1FadeIn:Play()
    square2FadeIn:Play()
    cubeFadeIn:Play()
    
    square1FadeIn.Completed:Wait()

    task.wait(SplashTime)

    local tweenInfoFadeOut = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local square1FadeOut = TweenService:Create(square1, tweenInfoFadeOut, {BackgroundTransparency = 1})
    local square2FadeOut = TweenService:Create(square2, tweenInfoFadeOut, {BackgroundTransparency = 1})
    local cubeFadeOut = TweenService:Create(cube, tweenInfoFadeOut, {Transparency = 1})

    square1FadeOut:Play()
    square2FadeOut:Play()
    cubeFadeOut:Play()

    square1FadeOut.Completed:Wait()
    
    if cubeRotationConnection then cubeRotationConnection:Disconnect(); cubeRotationConnection = nil end
    if splashScreenGui and splashScreenGui.Parent then splashScreenGui:Destroy() end
    
    if callbackAfterSplash then task.defer(callbackAfterSplash) end
end

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
    ContentItemHoverBackground = Color3.fromRGB(60, 55, 50),
    ContentItemHoverBorder = Color3.fromRGB(218, 213, 202),
    ContentItemIcon = Color3.fromRGB(70, 70, 70),
    ContentItemIconHover = Color3.fromRGB(255, 255, 255),
    
    SliderTrack = Color3.fromRGB(205, 200, 190),
    SliderFill = Color3.fromRGB(100, 95, 90),
    SliderHandle = Color3.fromRGB(70, 70, 70),
    
    ToggleOffText = Color3.fromRGB(120, 120, 120),
    ToggleOnText = Color3.fromRGB(76, 175, 80),

    MainFrameOuterBorder = Color3.fromRGB(200, 195, 185),
    
    ContentTitleText = Color3.fromRGB(60, 60, 60),
    TabSeparatorLine = Color3.fromRGB(200, 195, 185)
}

    function KukuriLib:ShowSplashScreen(callbackOnFinish)
        SplashScreen(callbackOnFinish)
    end

    function KukuriLib:CreateWindow(title, subtitle)
        local window = {}
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "KukuriLib_Redesigned"
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.ResetOnSpawn = false
        screenGui.Enabled = false

        mainScreenGuiInstance = screenGui
        print("Library: CreateWindow - mainScreenGuiInstance SET TO:", mainScreenGuiInstance, "Name:", mainScreenGuiInstance.Name)
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 650, 0, 450)
        mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        mainFrame.BackgroundColor3 = Colors.TabContainerBackground 
        mainFrame.BackgroundTransparency = 1
        mainFrame.BorderSizePixel = 1
        mainFrame.BorderColor3 = Colors.MainFrameOuterBorder
        mainFrame.ClipsDescendants = true
        mainFrame.Visible = false
        mainFrame.Parent = screenGui
        mainFrame:SetAttribute("OriginalTransparency", 0)
        
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 30)
        --titleBar.Position = UDim2.new(0, 0, 0, 0)
        titleBar.BackgroundColor3 = Colors.DarkPrimary
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mainFrame
        titleBar:SetAttribute("OriginalPosition", titleBar.Position)
    
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
        tabContainer:SetAttribute("OriginalPosition", tabContainer.Position)
    
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
        contentFrame:SetAttribute("OriginalPosition", contentFrame.Position)
    
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
            buttonFrame.ClipsDescendants = true
            buttonFrame.Parent = tab.UI
            
            buttonFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            buttonFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

            local hoverStroke = Instance.new("UIStroke")
            hoverStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            hoverStroke.Color = Colors.ContentItemHoverBorder
            hoverStroke.Thickness = 1
            hoverStroke.Enabled = false
            hoverStroke.Parent = buttonFrame

            local arrowIconSize = 10
            local arrowIconPadding = 5
            
            local hoverArrowIcon = Instance.new("ImageLabel")
            hoverArrowIcon.Name = "HoverArrowIcon"
            hoverArrowIcon.Size = UDim2.new(0, arrowIconSize, 0, arrowIconSize)
            hoverArrowIcon.AnchorPoint = Vector2.new(0, 0.5)
            hoverArrowIcon.Position = UDim2.new(0, arrowIconPadding, 0.5, 0)
            hoverArrowIcon.BackgroundTransparency = 1
            hoverArrowIcon.Image = "rbxassetid://2207556774"
            hoverArrowIcon.ImageColor3 = Colors.ContentItemIconHover
            hoverArrowIcon.Visible = false
            hoverArrowIcon.ZIndex = 2
            hoverArrowIcon.Parent = buttonFrame

            local squareIconSize = 10
            local squareIconPadding = arrowIconPadding + arrowIconSize + 3
            local spaceAfterSquareIcon = 5

            local buttonIcon = Instance.new("Frame")
            buttonIcon.Name = "ButtonIcon"
            buttonIcon.Size = UDim2.new(0, squareIconSize, 0, squareIconSize)
            buttonIcon.AnchorPoint = Vector2.new(0, 0.5)
            buttonIcon.Position = UDim2.new(0, squareIconPadding, 0.5, 0)
            buttonIcon.BackgroundColor3 = Colors.ContentItemIcon
            buttonIcon.BorderSizePixel = 0
            buttonIcon.ZIndex = 1
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
            textPadding.PaddingLeft = UDim.new(0, squareIconPadding + squareIconSize + spaceAfterSquareIcon)
            textPadding.Parent = actualButton

            local originalBackgroundColor = buttonFrame.BackgroundColor3
            local originalTextColor = actualButton.TextColor3
            local originalSquareIconColor = buttonIcon.BackgroundColor3
            local originalSize = buttonFrame.Size

            local isHovering = false
            local isPressed = false

            actualButton.MouseEnter:Connect(function()
                isHovering = true
                hoverArrowIcon.Visible = true
                if not isPressed then
                    TweenService:Create(buttonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Colors.ContentItemHoverBackground}):Play()
                    TweenService:Create(actualButton, TweenInfo.new(0.1), {TextColor3 = Colors.LightText}):Play()
                    TweenService:Create(buttonIcon, TweenInfo.new(0.1), {BackgroundColor3 = Colors.ContentItemIconHover}):Play()
                    hoverStroke.Enabled = true
                end
            end)
            
            actualButton.MouseLeave:Connect(function()
                isHovering = false
                hoverArrowIcon.Visible = false
                if not isPressed then
                    TweenService:Create(buttonFrame, TweenInfo.new(0.1), {BackgroundColor3 = originalBackgroundColor}):Play()
                    TweenService:Create(actualButton, TweenInfo.new(0.1), {TextColor3 = originalTextColor}):Play()
                    TweenService:Create(buttonIcon, TweenInfo.new(0.1), {BackgroundColor3 = originalSquareIconColor}):Play()
                    hoverStroke.Enabled = false
                    TweenService:Create(buttonFrame, TweenInfo.new(0.1), {Size = originalSize}):Play()
                end
            end)

            actualButton.MouseButton1Down:Connect(function()
                isPressed = true
                hoverArrowIcon.Visible = true
                local newSize = UDim2.new(originalSize.X.Scale * 0.97, originalSize.X.Offset * 0.97, 
                                          originalSize.Y.Scale * 0.97, originalSize.Y.Offset * 0.97)
                TweenService:Create(buttonFrame, TweenInfo.new(0.05), {Size = newSize}):Play()
                
                TweenService:Create(buttonFrame, TweenInfo.new(0.05), {BackgroundColor3 = Colors.ContentItemHoverBackground }):Play()
                TweenService:Create(actualButton, TweenInfo.new(0.05), {TextColor3 = Colors.LightText}):Play()
                TweenService:Create(buttonIcon, TweenInfo.new(0.05), {BackgroundColor3 = Colors.ContentItemIconHover}):Play()
                if not hoverStroke.Enabled then hoverStroke.Enabled = true end
            end)

            actualButton.MouseButton1Up:Connect(function()
                isPressed = false
                TweenService:Create(buttonFrame, TweenInfo.new(0.05), {Size = originalSize}):Play()

                if isHovering then
                    hoverArrowIcon.Visible = true
                    TweenService:Create(buttonFrame, TweenInfo.new(0.05), {BackgroundColor3 = Colors.ContentItemHoverBackground}):Play()
                    TweenService:Create(actualButton, TweenInfo.new(0.05), {TextColor3 = Colors.LightText}):Play()
                    TweenService:Create(buttonIcon, TweenInfo.new(0.05), {BackgroundColor3 = Colors.ContentItemIconHover}):Play()
                    hoverStroke.Enabled = true
                else
                    hoverArrowIcon.Visible = false
                    TweenService:Create(buttonFrame, TweenInfo.new(0.05), {BackgroundColor3 = originalBackgroundColor}):Play()
                    TweenService:Create(actualButton, TweenInfo.new(0.05), {TextColor3 = originalTextColor}):Play()
                    TweenService:Create(buttonIcon, TweenInfo.new(0.05), {BackgroundColor3 = originalSquareIconColor}):Play()
                    hoverStroke.Enabled = false
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
            toggleFrame.ClipsDescendants = true
            toggleFrame.Parent = self.UI

            local hoverStroke = Instance.new("UIStroke")
            hoverStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            hoverStroke.Color = Colors.ContentItemHoverBorder
            hoverStroke.Thickness = 1
            hoverStroke.Enabled = false
            hoverStroke.Parent = toggleFrame

            local iconSize = 10
            local iconPadding = 10
            local spaceAfterIcon = 5

            local toggleIconFrame = Instance.new("Frame")
            toggleIconFrame.Name = "ToggleIcon"
            toggleIconFrame.Size = UDim2.new(0, iconSize, 0, iconSize)
            toggleIconFrame.AnchorPoint = Vector2.new(0, 0.5)
            toggleIconFrame.Position = UDim2.new(0, iconPadding, 0.5, 0)
            toggleIconFrame.BackgroundColor3 = Colors.ContentItemIcon
            toggleIconFrame.BorderSizePixel = 0
            toggleIconFrame.Parent = toggleFrame
            
            local toggleTextLabel = Instance.new("TextLabel")
            toggleTextLabel.Name = "ToggleTextLabel"
            toggleTextLabel.Size = UDim2.new(1, 0, 1, 0)
            toggleTextLabel.Position = UDim2.new(0,0,0,0)
            toggleTextLabel.BackgroundTransparency = 1
            toggleTextLabel.Text = text
            toggleTextLabel.TextColor3 = Colors.DarkText
            toggleTextLabel.TextSize = 14
            toggleTextLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleTextLabel.Font = Enum.Font.SourceSans
            toggleTextLabel.Parent = toggleFrame

            local toggleTextPadding = Instance.new("UIPadding")
            toggleTextPadding.PaddingLeft = UDim.new(0, iconPadding + iconSize + spaceAfterIcon)
            toggleTextPadding.PaddingRight = UDim.new(0, 60)
            toggleTextPadding.Parent = toggleTextLabel
            
            local statusContainerWidth = 50
            local statusContainer = Instance.new("Frame")
            statusContainer.Name = "StatusContainer"
            statusContainer.Size = UDim2.new(0, statusContainerWidth, 1, 0)
            statusContainer.AnchorPoint = Vector2.new(1, 0.5)
            statusContainer.Position = UDim2.new(1, -5, 0.5, 0)
            statusContainer.BackgroundTransparency = 1
            statusContainer.ClipsDescendants = true
            statusContainer.Parent = toggleFrame

            local onLabel = Instance.new("TextLabel")
            onLabel.Name = "OnLabel"
            onLabel.Size = UDim2.new(1, 0, 1, 0)
            onLabel.Position = UDim2.new(0, 0, 0, 0)
            onLabel.BackgroundTransparency = 1
            onLabel.Text = "ON"
            onLabel.TextColor3 = Colors.ToggleOnText or Color3.fromRGB(76, 175, 80)
            onLabel.TextSize = 14
            onLabel.TextXAlignment = Enum.TextXAlignment.Center
            onLabel.Font = Enum.Font.SourceSansBold
            onLabel.Visible = false
            onLabel.Parent = statusContainer

            local offLabel = Instance.new("TextLabel")
            offLabel.Name = "OffLabel"
            offLabel.Size = UDim2.new(1, 0, 1, 0)
            offLabel.Position = UDim2.new(0, 0, 0, 0)
            offLabel.BackgroundTransparency = 1
            offLabel.Text = "OFF"
            offLabel.TextColor3 = Colors.ToggleOffText or Color3.fromRGB(180, 180, 180)
            offLabel.TextSize = 14
            offLabel.TextXAlignment = Enum.TextXAlignment.Center
            offLabel.Font = Enum.Font.SourceSans
            offLabel.Visible = false
            offLabel.Parent = statusContainer
            
            local actualButton = Instance.new("TextButton")
            actualButton.Name = "ActualButton"
            actualButton.Size = UDim2.new(1,0,1,0)
            actualButton.BackgroundTransparency = 1
            actualButton.Text = ""
            actualButton.Parent = toggleFrame

            local isToggled = default or false
            local originalBackgroundColor = toggleFrame.BackgroundColor3
            local originalToggleTextColor = toggleTextLabel.TextColor3
            local originalIconColor = toggleIconFrame.BackgroundColor3
            local originalSize = toggleFrame.Size -- for scale effect

            local isHovering = false
            local isPressed = false -- for scale effect

            local function updateToggleVisuals()
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) -- Animation

                if isToggled then
                    onLabel.Visible = true
                    offLabel.Visible = false
                    onLabel.Position = UDim2.new(-1, 0, 0, 0) -- on from left
                    TweenService:Create(onLabel, tweenInfo, {Position = UDim2.new(0,0,0,0)}):Play()
                    TweenService:Create(offLabel, tweenInfo, {Position = UDim2.new(1,0,0,0)}):Play() -- off to right
                else
                    offLabel.Visible = true
                    onLabel.Visible = false
                    offLabel.Position = UDim2.new(1, 0, 0, 0) -- off to right
                    TweenService:Create(offLabel, tweenInfo, {Position = UDim2.new(0,0,0,0)}):Play()
                    TweenService:Create(onLabel, tweenInfo, {Position = UDim2.new(-1,0,0,0)}):Play() -- on to left
                end
                
                if callback then
                    pcall(callback, isToggled)
                end
            end
            
            actualButton.MouseEnter:Connect(function()
                isHovering = true
                if not isPressed then
                    TweenService:Create(toggleFrame, TweenInfo.new(0.1), {BackgroundColor3 = Colors.ContentItemHoverBackground}):Play()
                    TweenService:Create(toggleTextLabel, TweenInfo.new(0.1), {TextColor3 = Colors.LightText}):Play()
                    TweenService:Create(toggleIconFrame, TweenInfo.new(0.1), {BackgroundColor3 = Colors.ContentItemIconHover}):Play()
                    hoverStroke.Enabled = true
                end
            end)
            
            actualButton.MouseLeave:Connect(function()
                isHovering = false
                if not isPressed then
                    TweenService:Create(toggleFrame, TweenInfo.new(0.1), {BackgroundColor3 = originalBackgroundColor}):Play()
                    TweenService:Create(toggleTextLabel, TweenInfo.new(0.1), {TextColor3 = originalToggleTextColor}):Play()
                    TweenService:Create(toggleIconFrame, TweenInfo.new(0.1), {BackgroundColor3 = originalIconColor}):Play()
                    hoverStroke.Enabled = false
                    TweenService:Create(toggleFrame, TweenInfo.new(0.1), {Size = originalSize}):Play() -- if scale effect
                end
            end)

             actualButton.MouseButton1Down:Connect(function()
                isPressed = true
            end)

            actualButton.MouseButton1Up:Connect(function()
                isPressed = false
            end)
            
            actualButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                updateToggleVisuals()
            end)
            
            updateToggleVisuals()
            
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

KukuriLib.KeyToToggle = uiToggleKey 

return KukuriLib
