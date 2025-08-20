-- CommandBarLib.lua
local CommandBarLib = {}
CommandBarLib.__index = CommandBarLib

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Constructor
function CommandBarLib.new(config)
    local self = setmetatable({}, CommandBarLib)
    
    -- Config
    self.ThemeColor = config.ThemeColor or Color3.fromRGB(0,255,255)
    self.Width = config.Width or 500
    self.Height = config.Height or 45
    self.Commands = config.Commands or {}
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CommandBarGUI"
    self.ScreenGui.Parent = PlayerGui

    -- Blur & Fog
    self.Blur = Instance.new("BlurEffect")
    self.Blur.Size = 0
    self.Blur.Parent = Lighting

    self.Fog = Instance.new("Frame")
    self.Fog.Size = UDim2.new(1,0,1,0)
    self.Fog.BackgroundColor3 = Color3.fromRGB(0,0,0)
    self.Fog.BackgroundTransparency = 1
    self.Fog.Parent = self.ScreenGui

    -- Command Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(0, self.Width, 0, self.Height)
    self.Frame.Position = UDim2.new(0.5,0,0.4,0)
    self.Frame.AnchorPoint = Vector2.new(0.5,0.5)
    self.Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    self.Frame.BorderSizePixel = 0
    self.Frame.Visible = false
    self.Frame.Parent = self.ScreenGui

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0,10)
    uicorner.Parent = self.Frame

    local uistroke = Instance.new("UIStroke")
    uistroke.Thickness = 2
    uistroke.Color = self.ThemeColor
    uistroke.Parent = self.Frame

    -- TextBox
    self.TextBox = Instance.new("TextBox")
    self.TextBox.Size = UDim2.new(1,-20,1,-10)
    self.TextBox.Position = UDim2.new(0,10,0,5)
    self.TextBox.BackgroundTransparency = 1
    self.TextBox.TextColor3 = self.ThemeColor
    self.TextBox.PlaceholderText = "Enter command..."
    self.TextBox.TextXAlignment = Enum.TextXAlignment.Left
    self.TextBox.ClearTextOnFocus = false
    self.TextBox.Font = Enum.Font.Code
    self.TextBox.TextSize = 20
    self.TextBox.Parent = self.Frame

    -- Suggestion Frame
    self.SuggestionFrame = Instance.new("Frame")
    self.SuggestionFrame.Size = UDim2.new(1,0,0,25)
    self.SuggestionFrame.Position = UDim2.new(0,0,-1.5,0)
    self.SuggestionFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    self.SuggestionFrame.BackgroundTransparency = 0.6
    self.SuggestionFrame.BorderSizePixel = 0
    self.SuggestionFrame.Visible = false
    self.SuggestionFrame.Parent = self.Frame

    self.SuggestionText = Instance.new("TextLabel")
    self.SuggestionText.Size = UDim2.new(1,-10,1,-2)
    self.SuggestionText.Position = UDim2.new(0,5,0,1)
    self.SuggestionText.BackgroundTransparency = 1
    self.SuggestionText.TextColor3 = self.ThemeColor
    self.SuggestionText.TextXAlignment = Enum.TextXAlignment.Left
    self.SuggestionText.TextYAlignment = Enum.TextYAlignment.Top
    self.SuggestionText.Font = Enum.Font.Code
    self.SuggestionText.TextSize = 18
    self.SuggestionText.TextWrapped = true
    self.SuggestionText.Text = ""
    self.SuggestionText.Parent = self.SuggestionFrame

    -- CMD Button
    self.Button = Instance.new("TextButton")
    self.Button.Size = UDim2.new(0,60,0,60)
    self.Button.Position = UDim2.new(0.9,0,0.9,0)
    self.Button.AnchorPoint = Vector2.new(0.5,0.5)
    self.Button.Text = "CMD"
    self.Button.Font = Enum.Font.Code
    self.Button.TextSize = 20
    self.Button.TextColor3 = Color3.fromRGB(255,255,255)
    self.Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
    self.Button.BorderSizePixel = 0
    self.Button.Active = true
    self.Button.Draggable = true
    self.Button.Parent = self.ScreenGui

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0,10)
    buttonCorner.Parent = self.Button

    self.Button.MouseButton1Click:Connect(function() self:ShowBar() end)

    -- TextBox events
    self.TextBox.FocusLost:Connect(function(enter)
        if enter then
            local cmd = self.TextBox.Text:lower()
            self.TextBox.Text = ""
            self:HideBar()
            if self.Commands[cmd] then
                self.Commands[cmd]()
            else
                self:Notify("Error","Command not found: "..cmd,"⚠️")
            end
        end
    end)

    self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        self:UpdateSuggestions()
    end)

    -- Start notification
    if config.StartNotification then
        local title = config.StartNotification.Title or "Welcome"
        local msg = config.StartNotification.Message or "Hello handsome"
        local icon = config.StartNotification.Icon or "😎"
        self:Notify(title,msg,icon)
    end

    return self
end

-- Show/hide fog
function CommandBarLib:ShowFog()
    TweenService:Create(self.Fog, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(self.Blur, TweenInfo.new(0.5), {Size = 24}):Play()
end
function CommandBarLib:HideFog()
    TweenService:Create(self.Fog, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(self.Blur, TweenInfo.new(0.5), {Size = 0}):Play()
end

-- Show/hide bar
function CommandBarLib:ShowBar()
    self.Frame.Visible = true
    self:ShowFog()
    TweenService:Create(self.Frame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,0,0.5,0)}):Play()
    self.TextBox:CaptureFocus()
end
function CommandBarLib:HideBar()
    self:HideFog()
    TweenService:Create(self.Frame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,0,0.4,0)}):Play()
    wait(0.3)
    self.Frame.Visible = false
    self.SuggestionFrame.Visible = false
end

-- Notifications
function CommandBarLib:Notify(title,msg,icon)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0,300,0,60)
    notif.Position = UDim2.new(0.5,-150,0,100)
    notif.BackgroundColor3 = Color3.fromRGB(25,25,25)
    notif.Parent = self.ScreenGui

    local uicornerN = Instance.new("UICorner")
    uicornerN.CornerRadius = UDim.new(0,10)
    uicornerN.Parent = notif

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = self.ThemeColor
    stroke.Parent = notif

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0,40,0,40)
    iconLabel.Position = UDim2.new(0,5,0.5,-20)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon or "ℹ️"
    iconLabel.Font = Enum.Font.Code
    iconLabel.TextSize = 24
    iconLabel.TextColor3 = self.ThemeColor
    iconLabel.Parent = notif

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,-50,0,20)
    titleLabel.Position = UDim2.new(0,50,0,5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.Code
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = self.ThemeColor
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1,-50,0,30)
    msgLabel.Position = UDim2.new(0,50,0,25)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = msg
    msgLabel.Font = Enum.Font.Code
    msgLabel.TextSize = 16
    msgLabel.TextColor3 = Color3.fromRGB(150,255,255)
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Parent = notif

    notif.BackgroundTransparency = 1
    titleLabel.TextTransparency = 1
    msgLabel.TextTransparency = 1
    iconLabel.TextTransparency = 1

    TweenService:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(titleLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(msgLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(iconLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    delay(3,function()
        TweenService:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(msgLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        wait(0.5)
        notif:Destroy()
    end)
end

-- Animated suggestion box
function CommandBarLib:UpdateSuggestions()
    local txt = self.TextBox.Text:lower()
    local list = {}
    for cmd,_ in pairs(self.Commands) do
        if cmd:sub(1,#txt) == txt and txt ~= "" then
            table.insert(list, cmd)
        end
    end

    if #list > 0 then
        self.SuggestionFrame.Visible = true
        self.SuggestionText.Text = ""
        self.SuggestionFrame.Size = UDim2.new(1,0,0,#list*20)

        local currentText = ""
        spawn(function()
            for i = 1, #list do
                local word = list[i]
                for j = 1, #word do
                    currentText = currentText..string.sub(word,j,j)
                    self.SuggestionText.Text = currentText
                    wait(0.02)
                end
                currentText = currentText.."\n"
                self.SuggestionText.Text = currentText
            end
        end)
    else
        self.SuggestionFrame.Visible = false
    end
end

return CommandBarLib
    self.Fog.Parent = self.ScreenGui

    -- Command Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(0, self.Width, 0, self.Height)
    self.Frame.Position = UDim2.new(0.5,0,0.4,0)
    self.Frame.AnchorPoint = Vector2.new(0.5,0.5)
    self.Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    self.Frame.BorderSizePixel = 0
    self.Frame.Visible = false
    self.Frame.Parent = self.ScreenGui

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0,10)
    uicorner.Parent = self.Frame

    local uistroke = Instance.new("UIStroke")
    uistroke.Thickness = 2
    uistroke.Color = self.ThemeColor
    uistroke.Parent = self.Frame

    -- Textbox
    self.TextBox = Instance.new("TextBox")
    self.TextBox.Size = UDim2.new(1,-20,1,-10)
    self.TextBox.Position = UDim2.new(0,10,0,5)
    self.TextBox.BackgroundTransparency = 1
    self.TextBox.TextColor3 = self.ThemeColor
    self.TextBox.PlaceholderText = "Enter command..."
    self.TextBox.TextXAlignment = Enum.TextXAlignment.Left
    self.TextBox.ClearTextOnFocus = false
    self.TextBox.Font = Enum.Font.Code
    self.TextBox.TextSize = 20
    self.TextBox.Parent = self.Frame

    -- Suggestion Frame
    self.SuggestionFrame = Instance.new("Frame")
    self.SuggestionFrame.Size = UDim2.new(1,0,0,25)
    self.SuggestionFrame.Position = UDim2.new(0,0,-1.5,0)
    self.SuggestionFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    self.SuggestionFrame.BackgroundTransparency = 0.6
    self.SuggestionFrame.BorderSizePixel = 0
    self.SuggestionFrame.Visible = false
    self.SuggestionFrame.Parent = self.Frame

    self.SuggestionText = Instance.new("TextLabel")
    self.SuggestionText.Size = UDim2.new(1,-10,1,-2)
    self.SuggestionText.Position = UDim2.new(0,5,0,1)
    self.SuggestionText.BackgroundTransparency = 1
    self.SuggestionText.TextColor3 = self.ThemeColor
    self.SuggestionText.TextXAlignment = Enum.TextXAlignment.Left
    self.SuggestionText.TextYAlignment = Enum.TextYAlignment.Top
    self.SuggestionText.Font = Enum.Font.Code
    self.SuggestionText.TextSize = 18
    self.SuggestionText.TextWrapped = true
    self.SuggestionText.Text = ""
    self.SuggestionText.Parent = self.SuggestionFrame

    -- CMD Button
    self.Button = Instance.new("TextButton")
    self.Button.Size = UDim2.new(0,60,0,60)
    self.Button.Position = UDim2.new(0.9,0,0.9,0)
    self.Button.AnchorPoint = Vector2.new(0.5,0.5)
    self.Button.Text = "CMD"
    self.Button.Font = Enum.Font.Code
    self.Button.TextSize = 20
    self.Button.TextColor3 = Color3.fromRGB(255,255,255)
    self.Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
    self.Button.BorderSizePixel = 0
    self.Button.Active = true
    self.Button.Draggable = true
    self.Button.Parent = self.ScreenGui

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0,10)
    buttonCorner.Parent = self.Button

    self.Button.MouseButton1Click:Connect(function() self:ShowBar() end)

    -- Textbox Events
    self.TextBox.FocusLost:Connect(function(enter)
        if enter then
            local cmd = self.TextBox.Text:lower()
            self.TextBox.Text = ""
            self:HideBar()
            if self.Commands[cmd] then
                self.Commands[cmd]()
            else
                self:Notify("Error","Command not found: "..cmd,"⚠️")
            end
        end
    end)

    self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        self:UpdateSuggestions()
    end)

    return self
end

--// Show/hide fog
function CommandBarLib:ShowFog()
    TweenService:Create(self.Fog, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(self.Blur, TweenInfo.new(0.5), {Size = 24}):Play()
end
function CommandBarLib:HideFog()
    TweenService:Create(self.Fog, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(self.Blur, TweenInfo.new(0.5), {Size = 0}):Play()
end

--// Show/hide bar
function CommandBarLib:ShowBar()
    self.Frame.Visible = true
    self:ShowFog()
    TweenService:Create(self.Frame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,0,0.5,0)}):Play()
    self.TextBox:CaptureFocus()
end
function CommandBarLib:HideBar()
    self:HideFog()
    TweenService:Create(self.Frame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,0,0.4,0)}):Play()
    wait(0.3)
    self.Frame.Visible = false
    self.SuggestionFrame.Visible = false
end

--// Notifications
function CommandBarLib:Notify(title,msg,icon)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0,300,0,60)
    notif.Position = UDim2.new(0.5,-150,0,100)
    notif.BackgroundColor3 = Color3.fromRGB(25,25,25)
    notif.Parent = self.ScreenGui

    local uicornerN = Instance.new("UICorner")
    uicornerN.CornerRadius = UDim.new(0,10)
    uicornerN.Parent = notif

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = self.ThemeColor
    stroke.Parent = notif

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0,40,0,40)
    iconLabel.Position = UDim2.new(0,5,0.5,-20)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon or "ℹ️"
    iconLabel.Font = Enum.Font.Code
    iconLabel.TextSize = 24
    iconLabel.TextColor3 = self.ThemeColor
    iconLabel.Parent = notif

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,-50,0,20)
    titleLabel.Position = UDim2.new(0,50,0,5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.Code
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = self.ThemeColor
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1,-50,0,30)
    msgLabel.Position = UDim2.new(0,50,0,25)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = msg
    msgLabel.Font = Enum.Font.Code
    msgLabel.TextSize = 16
    msgLabel.TextColor3 = Color3.fromRGB(150,255,255)
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Parent = notif

    notif.BackgroundTransparency = 1
    titleLabel.TextTransparency = 1
    msgLabel.TextTransparency = 1
    iconLabel.TextTransparency = 1

    TweenService:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(titleLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(msgLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(iconLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    delay(3,function()
        TweenService:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(msgLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        wait(0.5)
        notif:Destroy()
    end)
end

--// Update suggestion box
function CommandBarLib:UpdateSuggestions()
    local txt = self.TextBox.Text:lower()
    local list = {}
    for cmd,_ in pairs(self.Commands) do
        if cmd:sub(1,#txt) == txt and txt ~= "" then
            table.insert(list, cmd)
        end
    end

    if #list > 0 then
        self.SuggestionFrame.Visible = true
        self.SuggestionText.Text = ""
        self.SuggestionFrame.Size = UDim2.new(1,0,0,#list*20)

        local currentText = ""
        spawn(function()
            for i = 1, #list do
                local word = list[i]
                for j = 1, #word do
                    currentText = currentText..string.sub(word,j,j)
                    self.SuggestionText.Text = currentText
                    wait(0.02)
                end
                currentText = currentText.."\n"
                self.SuggestionText.Text = currentText
            end
        end)
    else
        self.SuggestionFrame.Visible = false
    end
end

return CommandBarLib
