-- EclipseX UI Library by MichaelServices - Fixed Version

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local EclipseX = {}

function EclipseX:CreateWindow(options)
    options = options or {}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "EclipseX_" .. HttpService:GenerateGUID(false)
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Name = "MainWindow"
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = MainFrame
    UICorner.CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Text = options.Name or "EclipseX UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextYAlignment = Enum.TextYAlignment.Center

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = MainFrame
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.Parent = CloseButton
    CloseCorner.CornerRadius = UDim.new(0, 6)

    local TabContainer = Instance.new("Frame")
    TabContainer.Parent = MainFrame
    TabContainer.Size = UDim2.new(1, -20, 0, 30)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundTransparency = 1

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 5)

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.Size = UDim2.new(1, -20, 1, -90)
    ContentContainer.Position = UDim2.new(0, 10, 0, 80)
    ContentContainer.BackgroundTransparency = 1

    local Keybind = options.Keybind or Enum.KeyCode.RightShift
    local toggled = true
    local tabs = {}
    local currentTab = nil

    -- Toggle functionality
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Keybind then
            toggled = not toggled
            MainFrame.Visible = toggled
        end
    end)

    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local function Animate(instance, properties, time)
        local tween = TweenService:Create(instance, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quad), properties)
        tween:Play()
        return tween
    end

    local function SwitchTab(tabName)
        for name, tab in pairs(tabs) do
            tab.Content.Visible = (name == tabName)
            if tab.Button then
                tab.Button.BackgroundColor3 = (name == tabName) and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
            end
        end
        currentTab = tabName
    end

    return {
        CreateTab = function(tabName)
            -- Create tab button
            local TabButton = Instance.new("TextButton")
            TabButton.Parent = TabContainer
            TabButton.Size = UDim2.new(0, 100, 1, 0)
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            TabButton.Text = tabName
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.Font = Enum.Font.Gotham
            TabButton.TextSize = 12

            local TabCorner = Instance.new("UICorner")
            TabCorner.Parent = TabButton
            TabCorner.CornerRadius = UDim.new(0, 6)

            -- Create tab content
            local TabContent = Instance.new("ScrollingFrame")
            TabContent.Parent = ContentContainer
            TabContent.Size = UDim2.new(1, 0, 1, 0)
            TabContent.Name = tabName
            TabContent.BackgroundTransparency = 1
            TabContent.ScrollBarThickness = 8
            TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
            TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            TabContent.Visible = false

            local Layout = Instance.new("UIListLayout")
            Layout.Parent = TabContent
            Layout.Padding = UDim.new(0, 10)
            Layout.SortOrder = Enum.SortOrder.LayoutOrder

            -- Auto-resize canvas
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
            end)

            -- Store tab info
            tabs[tabName] = {
                Content = TabContent,
                Button = TabButton
            }

            -- Set as current tab if it's the first one
            if not currentTab then
                SwitchTab(tabName)
            end

            -- Tab button click handler
            TabButton.MouseButton1Click:Connect(function()
                SwitchTab(tabName)
            end)

            return {
                AddButton = function(text, callback)
                    local Button = Instance.new("TextButton")
                    Button.Parent = TabContent
                    Button.Text = text
                    Button.Size = UDim2.new(1, -20, 0, 35)
                    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Button.Font = Enum.Font.Gotham
                    Button.TextSize = 14

                    local corner = Instance.new("UICorner")
                    corner.Parent = Button
                    corner.CornerRadius = UDim.new(0, 6)

                    -- Hover effects
                    Button.MouseEnter:Connect(function()
                        Animate(Button, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
                    end)

                    Button.MouseLeave:Connect(function()
                        Animate(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
                    end)

                    Button.MouseButton1Click:Connect(function()
                        if callback then
                            callback()
                        end
                    end)
                end,

                AddToggle = function(text, default, callback)
                    default = default or false
                    
                    local Toggle = Instance.new("TextButton")
                    Toggle.Parent = TabContent
                    Toggle.Size = UDim2.new(1, -20, 0, 35)
                    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Toggle.Font = Enum.Font.Gotham
                    Toggle.TextSize = 14
                    Toggle.Text = text .. ": " .. (default and "ON" or "OFF")
                    
                    local state = default
                    
                    local corner = Instance.new("UICorner")
                    corner.Parent = Toggle
                    corner.CornerRadius = UDim.new(0, 6)

                    Toggle.MouseEnter:Connect(function()
                        Animate(Toggle, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
                    end)

                    Toggle.MouseLeave:Connect(function()
                        Animate(Toggle, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
                    end)

                    Toggle.MouseButton1Click:Connect(function()
                        state = not state
                        Toggle.Text = text .. ": " .. (state and "ON" or "OFF")
                        Toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
                        if callback then
                            callback(state)
                        end
                    end)

                    -- Set initial color
                    if state then
                        Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                    end
                end,

                AddSlider = function(text, min, max, default, callback)
                    min = min or 0
                    max = max or 100
                    default = default or min
                    
                    local Container = Instance.new("Frame")
                    Container.Parent = TabContent
                    Container.Size = UDim2.new(1, -20, 0, 60)
                    Container.BackgroundTransparency = 1

                    local Label = Instance.new("TextLabel")
                    Label.Parent = Container
                    Label.Text = text .. ": " .. tostring(default)
                    Label.Size = UDim2.new(1, 0, 0, 25)
                    Label.Position = UDim2.new(0, 0, 0, 0)
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.Font = Enum.Font.Gotham
                    Label.TextSize = 14
                    Label.BackgroundTransparency = 1
                    Label.TextXAlignment = Enum.TextXAlignment.Left

                    local SliderBack = Instance.new("Frame")
                    SliderBack.Parent = Container
                    SliderBack.Size = UDim2.new(1, 0, 0, 20)
                    SliderBack.Position = UDim2.new(0, 0, 0, 30)
                    SliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

                    local SliderFill = Instance.new("Frame")
                    SliderFill.Parent = SliderBack
                    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
                    SliderFill.BorderSizePixel = 0

                    local SliderButton = Instance.new("TextButton")
                    SliderButton.Parent = SliderBack
                    SliderButton.Size = UDim2.new(1, 0, 1, 0)
                    SliderButton.BackgroundTransparency = 1
                    SliderButton.Text = ""

                    local corner1 = Instance.new("UICorner")
                    corner1.Parent = SliderBack
                    corner1.CornerRadius = UDim.new(0, 6)
                    
                    local corner2 = Instance.new("UICorner")
                    corner2.Parent = SliderFill
                    corner2.CornerRadius = UDim.new(0, 6)

                    local dragging = false
                    local currentValue = default

                    local function UpdateSlider(input)
                        local relativeX = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                        SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                        currentValue = math.floor(min + (max - min) * relativeX)
                        Label.Text = text .. ": " .. tostring(currentValue)
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
                    local Box = Instance.new("TextBox")
                    Box.Parent = TabContent
                    Box.Size = UDim2.new(1, -20, 0, 35)
                    Box.PlaceholderText = placeholder or "Enter text..."
                    Box.Font = Enum.Font.Gotham
                    Box.TextSize = 14
                    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    Box.Text = ""
                    Box.ClearTextOnFocus = false
                    Box.TextWrapped = true

                    local corner = Instance.new("UICorner")
                    corner.Parent = Box
                    corner.CornerRadius = UDim.new(0, 6)

                    Box.FocusLost:Connect(function(enterPressed)
                        if callback then
                            callback(Box.Text)
                        end
                    end)
                end,

                AddLabel = function(text)
                    local Label = Instance.new("TextLabel")
                    Label.Parent = TabContent
                    Label.Size = UDim2.new(1, -20, 0, 30)
                    Label.Text = text
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.Font = Enum.Font.Gotham
                    Label.TextSize = 14
                    Label.BackgroundTransparency = 1
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.TextWrapped = true
                end,

                AddNotification = function(message, duration)
                    duration = duration or 3
                    
                    local Notif = Instance.new("Frame")
                    Notif.Parent = ScreenGui
                    Notif.Size = UDim2.new(0, 300, 0, 60)
                    Notif.Position = UDim2.new(1, -310, 0, 10)
                    Notif.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                    local NotifCorner = Instance.new("UICorner")
                    NotifCorner.Parent = Notif
                    NotifCorner.CornerRadius = UDim.new(0, 8)

                    local NotifText = Instance.new("TextLabel")
                    NotifText.Parent = Notif
                    NotifText.Size = UDim2.new(1, -20, 1, 0)
                    NotifText.Position = UDim2.new(0, 10, 0, 0)
                    NotifText.Text = message
                    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    NotifText.BackgroundTransparency = 1
                    NotifText.TextSize = 14
                    NotifText.Font = Enum.Font.Gotham
                    NotifText.TextWrapped = true

                    -- Slide in animation
                    Notif.Position = UDim2.new(1, 10, 0, 10)
                    Animate(Notif, {Position = UDim2.new(1, -310, 0, 10)}, 0.5)

                    -- Auto-remove after duration
                    task.delay(duration, function()
                        if Notif and Notif.Parent then
                            Animate(Notif, {Position = UDim2.new(1, 10, 0, 10)}, 0.5)
                            task.delay(0.6, function()
                                if Notif and Notif.Parent then
                                    Notif:Destroy()
                                end
                            end)
                        end
                    end)
                end
            }
        end,

        Destroy = function()
            if ScreenGui and ScreenGui.Parent then
                ScreenGui:Destroy()
            end
        end,

        SetKeybind = function(newKeybind)
            Keybind = newKeybind
        end,

        Toggle = function()
            toggled = not toggled
            MainFrame.Visible = toggled
        end
    }
end

return EclipseX
