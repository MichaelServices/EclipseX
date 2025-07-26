-- EclipseX UI Library by MichaelServices

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local EclipseX = {}

-- Animation presets
local AnimationPresets = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}

-- Color scheme (Rayfield inspired)
local Colors = {
    Background = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(100, 100, 255),
    Success = Color3.fromRGB(50, 200, 50),
    Warning = Color3.fromRGB(255, 200, 50),
    Error = Color3.fromRGB(255, 80, 80),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(40, 40, 40),
    Hover = Color3.fromRGB(50, 50, 50)
}

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = parent
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    return gradient
end

local function CreateShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Parent = parent
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/InGameMenu/Tab/9slice_tab_shadow.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(8, 8, 248, 248)
    shadow.Size = size or UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.ZIndex = parent.ZIndex - 1
    return shadow
end

local function Animate(instance, properties, preset)
    preset = preset or AnimationPresets.Medium
    local tween = TweenService:Create(instance, preset, properties)
    tween:Play()
    return tween
end

function EclipseX:CreateWindow(options)
    options = options or {}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "EclipseX_" .. HttpService:GenerateGUID(false)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main window frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Name = "MainWindow"
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ZIndex = 10

    local MainCorner = Instance.new("UICorner")
    MainCorner.Parent = MainFrame
    MainCorner.CornerRadius = UDim.new(0, 15)

    -- Create shadow
    CreateShadow(MainFrame, UDim2.new(1, 20, 1, 20), 0.7)

    -- Create gradient background
    CreateGradient(MainFrame, {
        Colors.Background,
        Color3.fromRGB(25, 25, 30)
    }, 45)

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = MainFrame
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Colors.Secondary
    TitleBar.BorderSizePixel = 0

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.Parent = TitleBar
    TitleCorner.CornerRadius = UDim.new(0, 15)

    -- Create title gradient
    CreateGradient(TitleBar, {
        Color3.fromRGB(35, 35, 40),
        Color3.fromRGB(30, 30, 35)
    }, 90)

    -- Title text
    local Title = Instance.new("TextLabel")
    Title.Parent = TitleBar
    Title.Text = options.Name or "EclipseX UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Colors.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = TitleBar
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -45, 0, 7.5)
    CloseButton.BackgroundColor3 = Colors.Error
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.BorderSizePixel = 0

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.Parent = CloseButton
    CloseCorner.CornerRadius = UDim.new(0, 8)

    -- Minimize button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Parent = TitleBar
    MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
    MinimizeButton.Position = UDim2.new(1, -85, 0, 7.5)
    MinimizeButton.BackgroundColor3 = Colors.Warning
    MinimizeButton.Text = "─"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 16
    MinimizeButton.BorderSizePixel = 0

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.Parent = MinimizeButton
    MinimizeCorner.CornerRadius = UDim.new(0, 8)

    -- Side navigation
    local SideNav = Instance.new("Frame")
    SideNav.Parent = MainFrame
    SideNav.Size = UDim2.new(0, 180, 1, -70)
    SideNav.Position = UDim2.new(0, 10, 0, 60)
    SideNav.BackgroundColor3 = Colors.Secondary
    SideNav.BorderSizePixel = 0

    local SideNavCorner = Instance.new("UICorner")
    SideNavCorner.Parent = SideNav
    SideNavCorner.CornerRadius = UDim.new(0, 12)

    CreateGradient(SideNav, {
        Color3.fromRGB(25, 25, 30),
        Color3.fromRGB(30, 30, 35)
    }, 180)

    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.Size = UDim2.new(1, -210, 1, -70)
    ContentArea.Position = UDim2.new(0, 200, 0, 60)
    ContentArea.BackgroundColor3 = Colors.Secondary
    ContentArea.BorderSizePixel = 0

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.Parent = ContentArea
    ContentCorner.CornerRadius = UDim.new(0, 12)

    CreateGradient(ContentArea, {
        Color3.fromRGB(25, 25, 30),
        Color3.fromRGB(22, 22, 27)
    }, 135)

    -- Tab list layout
    local TabList = Instance.new("UIListLayout")
    TabList.Parent = SideNav
    TabList.Padding = UDim.new(0, 8)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = SideNav
    TabPadding.PaddingAll = UDim.new(0, 10)

    -- Variables
    local Keybind = options.Keybind or Enum.KeyCode.RightShift
    local toggled = true
    local tabs = {}
    local currentTab = nil
    local isMinimized = false

    -- Toggle functionality
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Keybind then
            toggled = not toggled
            if toggled then
                MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
                Animate(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, AnimationPresets.Bounce)
            else
                Animate(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, AnimationPresets.Fast)
            end
        end
    end)

    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        Animate(MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, AnimationPresets.Fast)
        task.wait(0.2)
        ScreenGui:Destroy()
    end)

    -- Minimize functionality
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Animate(MainFrame, {Size = UDim2.new(0, 600, 0, 50)}, AnimationPresets.Medium)
            SideNav.Visible = false
            ContentArea.Visible = false
        else
            Animate(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, AnimationPresets.Medium)
            SideNav.Visible = true
            ContentArea.Visible = true
        end
    end)

    -- Button hover effects
    CloseButton.MouseEnter:Connect(function()
        Animate(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, AnimationPresets.Fast)
    end)
    CloseButton.MouseLeave:Connect(function()
        Animate(CloseButton, {BackgroundColor3 = Colors.Error}, AnimationPresets.Fast)
    end)

    MinimizeButton.MouseEnter:Connect(function()
        Animate(MinimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 220, 70)}, AnimationPresets.Fast)
    end)
    MinimizeButton.MouseLeave:Connect(function()
        Animate(MinimizeButton, {BackgroundColor3 = Colors.Warning}, AnimationPresets.Fast)
    end)

    local function SwitchTab(tabName)
        for name, tab in pairs(tabs) do
            if tab.Content then
                tab.Content.Visible = (name == tabName)
            end
            if tab.Button then
                if name == tabName then
                    Animate(tab.Button, {BackgroundColor3 = Colors.Accent}, AnimationPresets.Fast)
                    tab.Button.TextColor3 = Colors.Text
                else
                    Animate(tab.Button, {BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)}, AnimationPresets.Fast)
                    tab.Button.TextColor3 = Colors.SubText
                end
            end
        end
        currentTab = tabName
    end

    return {
        CreateTab = function(tabName, icon)
            icon = icon or "📄"

            -- Create tab button
            local TabButton = Instance.new("TextButton")
            TabButton.Parent = SideNav
            TabButton.Size = UDim2.new(1, 0, 0, 45)
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
            TabButton.Text = "  " .. icon .. "  " .. tabName
            TabButton.TextColor3 = Colors.SubText
            TabButton.Font = Enum.Font.Gotham
            TabButton.TextSize = 14
            TabButton.TextXAlignment = Enum.TextXAlignment.Left
            TabButton.BorderSizePixel = 0

            local TabCorner = Instance.new("UICorner")
            TabCorner.Parent = TabButton
            TabCorner.CornerRadius = UDim.new(0, 10)

            -- Create tab content
            local TabContent = Instance.new("ScrollingFrame")
            TabContent.Parent = ContentArea
            TabContent.Size = UDim2.new(1, 0, 1, 0)
            TabContent.Position = UDim2.new(0, 0, 0, 0)
            TabContent.Name = tabName
            TabContent.BackgroundTransparency = 1
            TabContent.ScrollBarThickness = 6
            TabContent.ScrollBarImageColor3 = Colors.Accent
            TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            TabContent.Visible = false
            TabContent.BorderSizePixel = 0

            local Layout = Instance.new("UIListLayout")
            Layout.Parent = TabContent
            Layout.Padding = UDim.new(0, 12)
            Layout.SortOrder = Enum.SortOrder.LayoutOrder
            Layout.FillDirection = Enum.FillDirection.Vertical

            local UIPadding = Instance.new("UIPadding")
            UIPadding.Parent = TabContent
            UIPadding.PaddingAll = UDim.new(0, 15)

            -- Auto-resize canvas
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 30)
            end)

            -- Store tab info
            tabs[tabName] = {
                Content = TabContent,
                Button = TabButton
            }

            -- Set as current tab if it's the first one
            if not currentTab then
                currentTab = tabName
                TabContent.Visible = true
                TabButton.BackgroundColor3 = Colors.Accent
                TabButton.TextColor3 = Colors.Text
            end

            -- Tab button hover effects
            TabButton.MouseEnter:Connect(function()
                if currentTab ~= tabName then
                    Animate(TabButton, {BackgroundColor3 = Colors.Hover}, AnimationPresets.Fast)
                end
            end)

            TabButton.MouseLeave:Connect(function()
                if currentTab ~= tabName then
                    Animate(TabButton, {BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)}, AnimationPresets.Fast)
                end
            end)

            TabButton.MouseButton1Click:Connect(function()
                SwitchTab(tabName)
            end)

            return {
                AddButton = function(text, callback)
                    local ButtonFrame = Instance.new("Frame")
                    ButtonFrame.Parent = TabContent
                    ButtonFrame.Size = UDim2.new(1, 0, 0, 50)
                    ButtonFrame.BackgroundColor3 = Colors.Secondary
                    ButtonFrame.BorderSizePixel = 0

                    local ButtonCorner = Instance.new("UICorner")
                    ButtonCorner.Parent = ButtonFrame
                    ButtonCorner.CornerRadius = UDim.new(0, 12)

                    CreateGradient(ButtonFrame, {
                        Color3.fromRGB(35, 35, 40),
                        Color3.fromRGB(30, 30, 35)
                    }, 45)

                    local Button = Instance.new("TextButton")
                    Button.Parent = ButtonFrame
                    Button.Size = UDim2.new(1, 0, 1, 0)
                    Button.BackgroundTransparency = 1
                    Button.Text = text or "Button"
                    Button.TextColor3 = Colors.Text
                    Button.Font = Enum.Font.Gotham
                    Button.TextSize = 15
                    Button.BorderSizePixel = 0

                    -- Hover effects
                    Button.MouseEnter:Connect(function()
                        Animate(ButtonFrame, {BackgroundColor3 = Colors.Hover}, AnimationPresets.Fast)
                    end)

                    Button.MouseLeave:Connect(function()
                        Animate(ButtonFrame, {BackgroundColor3 = Colors.Secondary}, AnimationPresets.Fast)
                    end)

                    Button.MouseButton1Click:Connect(function()
                        -- Click animation
                        Animate(ButtonFrame, {Size = UDim2.new(1, -4, 0, 46)}, AnimationPresets.Fast)
                        task.wait(0.1)
                        Animate(ButtonFrame, {Size = UDim2.new(1, 0, 0, 50)}, AnimationPresets.Fast)
                        
                        if callback then
                            callback()
                        end
                    end)
                end,

                AddToggle = function(text, default, callback)
                    default = default or false
                    
                    local ToggleFrame = Instance.new("Frame")
                    ToggleFrame.Parent = TabContent
                    ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
                    ToggleFrame.BackgroundColor3 = Colors.Secondary
                    ToggleFrame.BorderSizePixel = 0

                    local ToggleCorner = Instance.new("UICorner")
                    ToggleCorner.Parent = ToggleFrame
                    ToggleCorner.CornerRadius = UDim.new(0, 12)

                    CreateGradient(ToggleFrame, {
                        Color3.fromRGB(35, 35, 40),
                        Color3.fromRGB(30, 30, 35)
                    }, 45)

                    local Label = Instance.new("TextLabel")
                    Label.Parent = ToggleFrame
                    Label.Size = UDim2.new(1, -80, 1, 0)
                    Label.Position = UDim2.new(0, 15, 0, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = text
                    Label.TextColor3 = Colors.Text
                    Label.Font = Enum.Font.Gotham
                    Label.TextSize = 15
                    Label.TextXAlignment = Enum.TextXAlignment.Left

                    -- Toggle switch
                    local ToggleSwitch = Instance.new("Frame")
                    ToggleSwitch.Parent = ToggleFrame
                    ToggleSwitch.Size = UDim2.new(0, 50, 0, 25)
                    ToggleSwitch.Position = UDim2.new(1, -65, 0.5, -12.5)
                    ToggleSwitch.BackgroundColor3 = default and Colors.Success or Colors.Border
                    ToggleSwitch.BorderSizePixel = 0

                    local SwitchCorner = Instance.new("UICorner")
                    SwitchCorner.Parent = ToggleSwitch
                    SwitchCorner.CornerRadius = UDim.new(0, 12.5)

                    local ToggleCircle = Instance.new("Frame")
                    ToggleCircle.Parent = ToggleSwitch
                    ToggleCircle.Size = UDim2.new(0, 21, 0, 21)
                    ToggleCircle.Position = default and UDim2.new(0, 27, 0, 2) or UDim2.new(0, 2, 0, 2)
                    ToggleCircle.BackgroundColor3 = Colors.Text
                    ToggleCircle.BorderSizePixel = 0

                    local CircleCorner = Instance.new("UICorner")
                    CircleCorner.Parent = ToggleCircle
                    CircleCorner.CornerRadius = UDim.new(0, 10.5)

                    local state = default
                    
                    local ToggleButton = Instance.new("TextButton")
                    ToggleButton.Parent = ToggleFrame
                    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                    ToggleButton.BackgroundTransparency = 1
                    ToggleButton.Text = ""

                    ToggleButton.MouseButton1Click:Connect(function()
                        state = not state
                        
                        if state then
                            Animate(ToggleCircle, {Position = UDim2.new(0, 27, 0, 2)}, AnimationPresets.Medium)
                            Animate(ToggleSwitch, {BackgroundColor3 = Colors.Success}, AnimationPresets.Medium)
                        else
                            Animate(ToggleCircle, {Position = UDim2.new(0, 2, 0, 2)}, AnimationPresets.Medium)
                            Animate(ToggleSwitch, {BackgroundColor3 = Colors.Border}, AnimationPresets.Medium)
                        end
                        
                        if callback then
                            callback(state)
                        end
                    end)
                end,

                AddSlider = function(text, min, max, default, callback)
                    min = min or 0
                    max = max or 100
                    default = default or min
                    
                    local SliderFrame = Instance.new("Frame")
                    SliderFrame.Parent = TabContent
                    SliderFrame.Size = UDim2.new(1, 0, 0, 70)
                    SliderFrame.BackgroundColor3 = Colors.Secondary
                    SliderFrame.BorderSizePixel = 0

                    local SliderCorner = Instance.new("UICorner")
                    SliderCorner.Parent = SliderFrame
                    SliderCorner.CornerRadius = UDim.new(0, 12)

                    CreateGradient(SliderFrame, {
                        Color3.fromRGB(35, 35, 40),
                        Color3.fromRGB(30, 30, 35)
                    }, 45)

                    local Label = Instance.new("TextLabel")
                    Label.Parent = SliderFrame
                    Label.Text = text
                    Label.Size = UDim2.new(1, -20, 0, 25)
                    Label.Position = UDim2.new(0, 15, 0, 8)
                    Label.TextColor3 = Colors.Text
                    Label.Font = Enum.Font.Gotham
                    Label.TextSize = 15
                    Label.BackgroundTransparency = 1
                    Label.TextXAlignment = Enum.TextXAlignment.Left

                    local ValueLabel = Instance.new("TextLabel")
                    ValueLabel.Parent = SliderFrame
                    ValueLabel.Text = tostring(default)
                    ValueLabel.Size = UDim2.new(0, 50, 0, 25)
                    ValueLabel.Position = UDim2.new(1, -65, 0, 8)
                    ValueLabel.TextColor3 = Colors.Accent
                    ValueLabel.Font = Enum.Font.GothamBold
                    ValueLabel.TextSize = 15
                    ValueLabel.BackgroundTransparency = 1
                    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

                    local SliderTrack = Instance.new("Frame")
                    SliderTrack.Parent = SliderFrame
                    SliderTrack.Size = UDim2.new(1, -30, 0, 6)
                    SliderTrack.Position = UDim2.new(0, 15, 0, 45)
                    SliderTrack.BackgroundColor3 = Colors.Border
                    SliderTrack.BorderSizePixel = 0

                    local TrackCorner = Instance.new("UICorner")
                    TrackCorner.Parent = SliderTrack
                    TrackCorner.CornerRadius = UDim.new(0, 3)

                    local SliderFill = Instance.new("Frame")
                    SliderFill.Parent = SliderTrack
                    SliderFill.BackgroundColor3 = Colors.Accent
                    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
                    SliderFill.Position = UDim2.new(0, 0, 0, 0)
                    SliderFill.BorderSizePixel = 0

                    local FillCorner = Instance.new("UICorner")
                    FillCorner.Parent = SliderFill
                    FillCorner.CornerRadius = UDim.new(0, 3)

                    CreateGradient(SliderFill, {
                        Colors.Accent,
                        Color3.fromRGB(120, 120, 255)
                    }, 90)

                    local SliderButton = Instance.new("TextButton")
                    SliderButton.Parent = SliderTrack
                    SliderButton.Size = UDim2.new(1, 0, 1, 0)
                    SliderButton.BackgroundTransparency = 1
                    SliderButton.Text = ""

                    local dragging = false
                    local currentValue = default

                    local function UpdateSlider(input)
                        local relativeX = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                        Animate(SliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, AnimationPresets.Fast)
                        currentValue = math.floor(min + (max - min) * relativeX)
                        ValueLabel.Text = tostring(currentValue)
                        if callback then
                            callback(currentValue)
                        end
                    end

                    SliderButton.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            UpdateSlider(input)
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateSlider(input)
                        end
                    end)
                end,

                AddInput = function(placeholder, callback)
                    local InputFrame = Instance.new("Frame")
                    InputFrame.Parent = TabContent
                    InputFrame.Size = UDim2.new(1, 0, 0, 50)
                    InputFrame.BackgroundColor3 = Colors.Secondary
                    InputFrame.BorderSizePixel = 0

                    local InputCorner = Instance.new("UICorner")
                    InputCorner.Parent = InputFrame
                    InputCorner.CornerRadius = UDim.new(0, 12)

                    CreateGradient(InputFrame, {
                        Color3.fromRGB(35, 35, 40),
                        Color3.fromRGB(30, 30, 35)
                    }, 45)

                    local TextBox = Instance.new("TextBox")
                    TextBox.Parent = InputFrame
                    TextBox.Size = UDim2.new(1, -30, 1, -10)
                    TextBox.Position = UDim2.new(0, 15, 0, 5)
                    TextBox.BackgroundTransparency = 1
                    TextBox.PlaceholderText = placeholder or "Enter text..."
                    TextBox.PlaceholderColor3 = Colors.SubText
                    TextBox.Font = Enum.Font.Gotham
                    TextBox.TextSize = 15
                    TextBox.TextColor3 = Colors.Text
                    TextBox.Text = ""
                    TextBox.ClearTextOnFocus = false
                    TextBox.TextWrapped = true
                    TextBox.TextXAlignment = Enum.TextXAlignment.Left

                    TextBox.Focused:Connect(function()
                        Animate(InputFrame, {BackgroundColor3 = Colors.Hover}, AnimationPresets.Fast)
                    end)

                    TextBox.FocusLost:Connect(function(enterPressed)
                        Animate(InputFrame, {BackgroundColor3 = Colors.Secondary}, AnimationPresets.Fast)
                        if callback then
                            callback(TextBox.Text)
                        end
                    end)
                end,

                AddLabel = function(text)
                    local Label = Instance.new("TextLabel")
                    Label.Parent = TabContent
                    Label.Size = UDim2.new(1, 0, 0, 30)
                    Label.Position = UDim2.new(0, 0, 0, 0)
                    Label.Text = text
                    Label.TextColor3 = Colors.SubText
                    Label.Font = Enum.Font.Gotham
                    Label.TextSize = 14
                    Label.BackgroundTransparency = 1
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.TextWrapped = true
                    Label.BorderSizePixel = 0
                end,

                AddDropdown = function(text, options, callback)
                    options = options or {}
                    
                    local DropdownFrame = Instance.new("Frame")
                    DropdownFrame.Parent = TabContent
                    DropdownFrame.Size = UDim2.new(1, 0, 0, 50)
                    DropdownFrame.BackgroundColor3 = Colors.Secondary
                    DropdownFrame.BorderSizePixel = 0
                    DropdownFrame.ClipsDescendants = true

                    local DropdownCorner = Instance.new("UICorner")
                    DropdownCorner.Parent = DropdownFrame
                    DropdownCorner.CornerRadius = UDim.new(0, 12)

                    CreateGradient(DropdownFrame, {
                        Color3.fromRGB(35, 35, 40),
                        Color3.fromRGB(30, 30, 35)
                    }, 45)

                    local DropdownButton = Instance.new("TextButton")
                    DropdownButton.Parent = DropdownFrame
                    DropdownButton.Size = UDim2.new(1, 0, 0, 50)
                    DropdownButton.BackgroundTransparency = 1
                    DropdownButton.Text = text .. ": None"
                    DropdownButton.TextColor3 = Colors.Text
                    DropdownButton.Font = Enum.Font.Gotham
                    DropdownButton.TextSize = 15
                    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                    DropdownButton.BorderSizePixel = 0

                    local Arrow = Instance.new("TextLabel")
                    Arrow.Parent = DropdownButton
                    Arrow.Size = UDim2.new(0, 30, 1, 0)
                    Arrow.Position = UDim2.new(1, -45, 0, 0)
                    Arrow.BackgroundTransparency = 1
                    Arrow.Text = "▼"
                    Arrow.TextColor3 = Colors.SubText
                    Arrow.Font = Enum.Font.Gotham
                    Arrow.TextSize = 12

                    local OptionsList = Instance.new("Frame")
                    OptionsList.Parent = DropdownFrame
                    OptionsList.Size = UDim2.new(1, 0, 0, #options * 35)
                    OptionsList.Position = UDim2.new(0, 0, 0, 50)
                    OptionsList.BackgroundColor3 = Colors.Background
                    OptionsList.BorderSizePixel = 0
                    OptionsList.Visible = false

                    local OptionsCorner = Instance.new("UICorner")
                    OptionsCorner.Parent = OptionsList
                    OptionsCorner.CornerRadius = UDim.new(0, 8)

                    local OptionsLayout = Instance.new("UIListLayout")
                    OptionsLayout.Parent = OptionsList
                    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder

                    local isOpen = false
                    local selectedOption = nil

                    DropdownButton.MouseButton1Click:Connect(function()
                        isOpen = not isOpen
                        if isOpen then
                            OptionsList.Visible = true
                            Animate(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50 + #options * 35)}, AnimationPresets.Medium)
                            Animate(Arrow, {Rotation = 180}, AnimationPresets.Medium)
                        else
                            Animate(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, AnimationPresets.Medium)
                            Animate(Arrow, {Rotation = 0}, AnimationPresets.Medium)
                            task.wait(0.3)
                            OptionsList.Visible = false
                        end
                    end)

                    for i, option in ipairs(options) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Parent = OptionsList
                        OptionButton.Size = UDim2.new(1, 0, 0, 35)
                        OptionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
                        OptionButton.Text = "  " .. option
                        OptionButton.TextColor3 = Colors.Text
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.TextSize = 14
                        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                        OptionButton.BorderSizePixel = 0

                        OptionButton.MouseEnter:Connect(function()
                            Animate(OptionButton, {BackgroundColor3 = Colors.Hover}, AnimationPresets.Fast)
                        end)

                        OptionButton.MouseLeave:Connect(function()
                            Animate(OptionButton, {BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)}, AnimationPresets.Fast)
                        end)

                        OptionButton.MouseButton1Click:Connect(function()
                            selectedOption = option
                            DropdownButton.Text = text .. ": " .. option
                            isOpen = false
                            Animate(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, AnimationPresets.Medium)
                            Animate(Arrow, {Rotation = 0}, AnimationPresets.Medium)
                            task.wait(0.3)
                            OptionsList.Visible = false
                            if callback then
                                callback(option)
                            end
                        end)
                    end
                end,

                AddNotification = function(message, type, duration)
                    type = type or "info"
                    duration = duration or 3
                    
                    local NotificationFrame = Instance.new("Frame")
                    NotificationFrame.Parent = ScreenGui
                    NotificationFrame.Size = UDim2.new(0, 350, 0, 70)
                    NotificationFrame.Position = UDim2.new(1, 360, 0, 20)
                    NotificationFrame.BackgroundColor3 = Colors.Background
                    NotificationFrame.BorderSizePixel = 0
                    NotificationFrame.ZIndex = 100

                    local NotifCorner = Instance.new("UICorner")
                    NotifCorner.Parent = NotificationFrame
                    NotifCorner.CornerRadius = UDim.new(0, 12)

                    CreateShadow(NotificationFrame, UDim2.new(1, 15, 1, 15), 0.6)

                    -- Color indicator based on type
                    local TypeColor = Colors.Accent
                    local TypeIcon = "ℹ️"
                    
                    if type == "success" then
                        TypeColor = Colors.Success
                        TypeIcon = "✅"
                    elseif type == "warning" then
                        TypeColor = Colors.Warning
                        TypeIcon = "⚠️"
                    elseif type == "error" then
                        TypeColor = Colors.Error
                        TypeIcon = "❌"
                    end

                    local ColorBar = Instance.new("Frame")
                    ColorBar.Parent = NotificationFrame
                    ColorBar.Size = UDim2.new(0, 4, 1, 0)
                    ColorBar.Position = UDim2.new(0, 0, 0, 0)
                    ColorBar.BackgroundColor3 = TypeColor
                    ColorBar.BorderSizePixel = 0

                    local BarCorner = Instance.new("UICorner")
                    BarCorner.Parent = ColorBar
                    BarCorner.CornerRadius = UDim.new(0, 2)

                    local Icon = Instance.new("TextLabel")
                    Icon.Parent = NotificationFrame
                    Icon.Size = UDim2.new(0, 30, 0, 30)
                    Icon.Position = UDim2.new(0, 15, 0, 20)
                    Icon.BackgroundTransparency = 1
                    Icon.Text = TypeIcon
                    Icon.TextSize = 18
                    Icon.Font = Enum.Font.Gotham

                    local Message = Instance.new("TextLabel")
                    Message.Parent = NotificationFrame
                    Message.Size = UDim2.new(1, -60, 1, -10)
                    Message.Position = UDim2.new(0, 50, 0, 5)
                    Message.BackgroundTransparency = 1
                    Message.Text = message
                    Message.TextColor3 = Colors.Text
                    Message.Font = Enum.Font.Gotham
                    Message.TextSize = 14
                    Message.TextWrapped = true
                    Message.TextXAlignment = Enum.TextXAlignment.Left
                    Message.TextYAlignment = Enum.TextYAlignment.Center

                    CreateGradient(NotificationFrame, {
                        Color3.fromRGB(25, 25, 30),
                        Color3.fromRGB(30, 30, 35)
                    }, 45)

                    -- Slide in animation
                    Animate(NotificationFrame, {Position = UDim2.new(1, -360, 0, 20)}, AnimationPresets.Bounce)

                    -- Auto-remove after duration
                    task.delay(duration, function()
                        if NotificationFrame and NotificationFrame.Parent then
                            Animate(NotificationFrame, {Position = UDim2.new(1, 360, 0, 20)}, AnimationPresets.Medium)
                            task.delay(0.4, function()
                                if NotificationFrame and NotificationFrame.Parent then
                                    NotificationFrame:Destroy()
                                end
                            end)
                        end
                    end)
                end,

                AddSeparator = function()
                    local Separator = Instance.new("Frame")
                    Separator.Parent = TabContent
                    Separator.Size = UDim2.new(1, -20, 0, 2)
                    Separator.Position = UDim2.new(0, 10, 0, 0)
                    Separator.BackgroundColor3 = Colors.Border
                    Separator.BorderSizePixel = 0

                    local SepCorner = Instance.new("UICorner")
                    SepCorner.Parent = Separator
                    SepCorner.CornerRadius = UDim.new(0, 1)

                    CreateGradient(Separator, {
                        Color3.fromRGB(40, 40, 45),
                        Color3.fromRGB(60, 60, 65)
                    }, 90)
                end,

                AddSection = function(sectionName)
                    local SectionFrame = Instance.new("Frame")
                    SectionFrame.Parent = TabContent
                    SectionFrame.Size = UDim2.new(1, 0, 0, 40)
                    SectionFrame.BackgroundTransparency = 1

                    local SectionLabel = Instance.new("TextLabel")
                    SectionLabel.Parent = SectionFrame
                    SectionLabel.Size = UDim2.new(1, 0, 1, 0)
                    SectionLabel.BackgroundTransparency = 1
                    SectionLabel.Text = sectionName
                    SectionLabel.TextColor3 = Colors.Accent
                    SectionLabel.Font = Enum.Font.GothamBold
                    SectionLabel.TextSize = 16
                    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

                    local Underline = Instance.new("Frame")
                    Underline.Parent = SectionFrame
                    Underline.Size = UDim2.new(0, 50, 0, 2)
                    Underline.Position = UDim2.new(0, 0, 1, -5)
                    Underline.BackgroundColor3 = Colors.Accent
                    Underline.BorderSizePixel = 0

                    local UnderlineCorner = Instance.new("UICorner")
                    UnderlineCorner.Parent = Underline
                    UnderlineCorner.CornerRadius = UDim.new(0, 1)
                end
            }
        end,

        -- Window methods
        Destroy = function()
            if ScreenGui and ScreenGui.Parent then
                Animate(MainFrame, {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                }, AnimationPresets.Fast)
                task.wait(0.2)
                ScreenGui:Destroy()
            end
        end,

        SetKeybind = function(newKeybind)
            Keybind = newKeybind
        end,

        Toggle = function()
            toggled = not toggled
            if toggled then
                MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
                Animate(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, AnimationPresets.Bounce)
            else
                Animate(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, AnimationPresets.Fast)
            end
        end,

        SetTitle = function(title)
            Title.Text = title
        end,

        Minimize = function()
            isMinimized = not isMinimized
            if isMinimized then
                Animate(MainFrame, {Size = UDim2.new(0, 600, 0, 50)}, AnimationPresets.Medium)
                SideNav.Visible = false
                ContentArea.Visible = false
            else
                Animate(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, AnimationPresets.Medium)
                SideNav.Visible = true
                ContentArea.Visible = true
            end
        end
    }
end

return EclipseX
