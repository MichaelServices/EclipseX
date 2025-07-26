-- EclipseX UI Library by MichaelServices

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local EclipseX = {}

function EclipseX:CreateWindow(options)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "EclipseX_" .. HttpService:GenerateGUID(false)

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Name = "MainWindow"

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Text = options.Name or "EclipseX UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)

    local TabHolder = Instance.new("Frame", MainFrame)
    TabHolder.Size = UDim2.new(1, -20, 1, -60)
    TabHolder.Position = UDim2.new(0, 10, 0, 50)
    TabHolder.BackgroundTransparency = 1

    local Keybind = Enum.KeyCode.RightShift
    local toggled = true

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Keybind then
            toggled = not toggled
            MainFrame.Visible = toggled
        end
    end)

    local function Animate(instance, properties, time)
        TweenService:Create(instance, TweenInfo.new(time or 0.3), properties):Play()
    end

    return {
        CreateTab = function(tabName)
            local Tab = Instance.new("ScrollingFrame", TabHolder)
            Tab.Size = UDim2.new(1, 0, 1, 0)
            Tab.Name = tabName
            Tab.BackgroundTransparency = 1
            Tab.ScrollBarThickness = 5
            Tab.CanvasSize = UDim2.new(0, 0, 10, 0)

            local Layout = Instance.new("UIListLayout", Tab)
            Layout.Padding = UDim.new(0, 10)
            Layout.SortOrder = Enum.SortOrder.LayoutOrder

            return {
                AddButton = function(text, callback)
                    local Button = Instance.new("TextButton", Tab)
                    Button.Text = text
                    Button.Size = UDim2.new(1, -20, 0, 35)
                    Button.Position = UDim2.new(0, 10, 0, 0)
                    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Button.Font = Enum.Font.Gotham
                    Button.TextSize = 14

                    local corner = Instance.new("UICorner", Button)
                    corner.CornerRadius = UDim.new(0, 6)

                    Button.MouseButton1Click:Connect(callback)
                end,

                AddToggle = function(text, default, callback)
                    local Toggle = Instance.new("TextButton", Tab)
                    Toggle.Size = UDim2.new(1, -20, 0, 35)
                    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Toggle.Font = Enum.Font.Gotham
                    Toggle.TextSize = 14
                    Toggle.Text = text .. ": " .. (default and "ON" or "OFF")
                    local state = default
                    local corner = Instance.new("UICorner", Toggle)
                    corner.CornerRadius = UDim.new(0, 6)

                    Toggle.MouseButton1Click:Connect(function()
                        state = not state
                        Toggle.Text = text .. ": " .. (state and "ON" or "OFF")
                        callback(state)
                    end)
                end,

                AddSlider = function(text, min, max, default, callback)
                    local Container = Instance.new("Frame", Tab)
                    Container.Size = UDim2.new(1, -20, 0, 50)
                    Container.BackgroundTransparency = 1

                    local Label = Instance.new("TextLabel", Container)
                    Label.Text = text .. ": " .. tostring(default)
                    Label.Size = UDim2.new(1, 0, 0, 20)
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.Font = Enum.Font.Gotham
                    Label.TextSize = 14
                    Label.BackgroundTransparency = 1

                    local Slider = Instance.new("TextButton", Container)
                    Slider.Size = UDim2.new(1, 0, 0, 20)
                    Slider.Position = UDim2.new(0, 0, 0, 25)
                    Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    Slider.Text = ""

                    local Fill = Instance.new("Frame", Slider)
                    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
                    Fill.BorderSizePixel = 0

                    local corner1 = Instance.new("UICorner", Slider)
                    corner1.CornerRadius = UDim.new(0, 6)
                    local corner2 = Instance.new("UICorner", Fill)
                    corner2.CornerRadius = UDim.new(0, 6)

                    local dragging = false

                    Slider.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local scale = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(scale, 0, 1, 0)
                            local value = math.floor(min + (max - min) * scale)
                            Label.Text = text .. ": " .. tostring(value)
                            callback(value)
                        end
                    end)
                end,

                AddInput = function(placeholder, callback)
                    local Box = Instance.new("TextBox", Tab)
                    Box.Size = UDim2.new(1, -20, 0, 30)
                    Box.PlaceholderText = placeholder
                    Box.Font = Enum.Font.Gotham
                    Box.TextSize = 14
                    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                    local corner = Instance.new("UICorner", Box)
                    corner.CornerRadius = UDim.new(0, 6)

                    Box.FocusLost:Connect(function()
                        callback(Box.Text)
                    end)
                end,

                AddNotification = function(message)
                    local Notif = Instance.new("TextLabel", MainFrame)
                    Notif.Size = UDim2.new(1, 0, 0, 30)
                    Notif.Position = UDim2.new(0, 0, 0, -30)
                    Notif.Text = message
                    Notif.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Notif.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                    Notif.TextSize = 14
                    Notif.Font = Enum.Font.GothamBold

                    local corner = Instance.new("UICorner", Notif)
                    corner.CornerRadius = UDim.new(0, 6)

                    Animate(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.5)
                    task.delay(3, function()
                        Animate(Notif, {Position = UDim2.new(0, 0, 0, -30)}, 0.5)
                        task.delay(0.6, function()
                            Notif:Destroy()
                        end)
                    end)
                end
            }
        end
    }
end

return EclipseX
