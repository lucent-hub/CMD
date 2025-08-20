-- Full Modern CommandBar UI
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local CommandBarLib = {}
CommandBarLib.__index = CommandBarLib

function CommandBarLib.new(options)
    local self = setmetatable({}, CommandBarLib)
    
    self.ThemeColor = options.ThemeColor or Color3.fromRGB(0,255,255)
    self.Commands = options.Commands or {}
    self.Shortcuts = options.Shortcuts or {}
    self.StartNotification = options.StartNotification or {Title="Info", Message="CommandBar Loaded", Icon="ℹ️"}
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CommandBarGUI"
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 100
    self.ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Blur & Fog
    self.Blur = Instance.new("BlurEffect")
    self.Blur.Size = 0
    self.Blur.Parent = Lighting
    
    self.Fog = Instance.new("Frame")
    self.Fog.Size = UDim2.new(1,0,1,0)
    self.Fog.BackgroundColor3 = Color3.new(0,0,0)
    self.Fog.BackgroundTransparency = 1
    self.Fog.ZIndex = 0
    self.Fog.Parent = self.ScreenGui
    
    -- Command Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(0,500,0,45)
    self.Frame.Position = UDim2.new(0.5,0,0.5,0)
    self.Frame.AnchorPoint = Vector2.new(0.5,0.5)
    self.Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    self.Frame.BorderSizePixel = 0
    self.Frame.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = self.Frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = self.ThemeColor
    stroke.Parent = self.Frame
    
    -- TextBox
    self.TextBox = Instance.new("TextBox")
    self.TextBox.Size = UDim2.new(1,-20,1,-10)
    self.TextBox.Position = UDim2.new(0,10,0,5)
    self.TextBox.BackgroundTransparency = 1
    self.TextBox.PlaceholderText = "Enter command..."
    self.TextBox.TextColor3 = self.ThemeColor
    self.TextBox.TextXAlignment = Enum.TextXAlignment.Left
    self.TextBox.Font = Enum.Font.Code
    self.TextBox.TextSize = 20
    self.TextBox.ClearTextOnFocus = false
    self.TextBox.Parent = self.Frame
    
    -- Suggestion Frame
    self.SuggestFrame = Instance.new("Frame")
    self.SuggestFrame.Size = UDim2.new(1,0,0,25)
    self.SuggestFrame.Position = UDim2.new(0,0,-1.8,0)
    self.SuggestFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    self.SuggestFrame.BackgroundTransparency = 0.6
    self.SuggestFrame.BorderSizePixel = 0
    self.SuggestFrame.Visible = false
    self.SuggestFrame.Parent = self.Frame
    
    self.SuggestText = Instance.new("TextLabel")
    self.SuggestText.Size = UDim2.new(1,-10,1,-2)
    self.SuggestText.Position = UDim2.new(0,5,0,1)
    self.SuggestText.BackgroundTransparency = 1
    self.SuggestText.TextColor3 = self.ThemeColor
    self.SuggestText.TextXAlignment = Enum.TextXAlignment.Left
    self.SuggestText.TextYAlignment = Enum.TextYAlignment.Top
    self.SuggestText.Font = Enum.Font.Code
    self.SuggestText.TextSize = 18
    self.SuggestText.TextWrapped = true
    self.SuggestText.Text = ""
    self.SuggestText.Parent = self.SuggestFrame
    
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
    self.Button.Parent = self.ScreenGui
    self.Button.Active = true
    self.Button.Draggable = true
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,10)
    btnCorner.Parent = self.Button
    
    self.Button.MouseButton1Click:Connect(function()
        if self.Frame.Visible then
            self:Hide()
        else
            self:Show()
        end
    end)
    
    -- Show / Hide Functions
    function self:Show()
        self.Frame.Visible = true
        TweenService:Create(self.Fog, TweenInfo.new(0.5), {BackgroundTransparency=0.5}):Play()
        TweenService:Create(self.Blur, TweenInfo.new(0.5), {Size=24}):Play()
        TweenService:Create(self.Frame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,0,0.5,0)}):Play()
        self.TextBox:CaptureFocus()
    end
    
    function self:Hide()
        TweenService:Create(self.Fog, TweenInfo.new(0.5), {BackgroundTransparency=1}):Play()
        TweenService:Create(self.Blur, TweenInfo.new(0.5), {Size=0}):Play()
        TweenService:Create(self.Frame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,0,0.4,0)}):Play()
        wait(0.3)
        self.Frame.Visible = false
        self.SuggestFrame.Visible = false
    end
    
    -- Notification
    function self:Notify(title,msg,icon)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0,300,0,70)
        notif.Position = UDim2.new(0.5,-150,-0.5,0)
        notif.AnchorPoint = Vector2.new(0.5,0)
        notif.BackgroundColor3 = Color3.fromRGB(20,20,20)
        notif.BorderSizePixel = 0
        notif.Parent = self.ScreenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0,10)
        corner.Parent = notif

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = self.ThemeColor
        stroke.Parent = notif

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1,-10,0,25)
        titleLabel.Position = UDim2.new(0,5,0,5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = (icon or "").." "..(title or "Info")
        titleLabel.TextColor3 = self.ThemeColor
        titleLabel.Font = Enum.Font.Code
        titleLabel.TextSize = 18
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notif

        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1,-10,0,35)
        msgLabel.Position = UDim2.new(0,5,0,25)
        msgLabel.BackgroundTransparency = 1
        msgLabel.Text = msg or ""
        msgLabel.TextColor3 = Color3.fromRGB(255,255,255)
        msgLabel.Font = Enum.Font.Code
        msgLabel.TextSize = 16
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextWrapped = true
        msgLabel.Parent = notif

        TweenService:Create(notif, TweenInfo.new(0.5), {Position=UDim2.new(0.5,-150,0,50)}):Play()
        spawn(function()
            wait(3)
            TweenService:Create(notif, TweenInfo.new(0.5), {Position=UDim2.new(0.5,-150,-0.5,0)}):Play()
            wait(0.5)
            notif:Destroy()
        end)
    end
    
    -- Suggestion animation
    self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local txt = self.TextBox.Text:lower()
        local list = {}
        for cmd,_ in pairs(self.Commands) do
            if cmd:sub(1,#txt) == txt and txt~="" then table.insert(list,cmd) end
        end
        for k,v in pairs(self.Shortcuts) do
            if k:sub(1,#txt) == txt and txt~="" then table.insert(list,v) end
        end
        if #list>0 then
            self.SuggestFrame.Visible = true
            self.SuggestText.Text = ""
            self.SuggestFrame.Size = UDim2.new(1,0,0,#list*20)
            local currentText = ""
            spawn(function()
                for i=1,#list do
                    local word = list[i]
                    for j=1,#word do
                        currentText=currentText..string.sub(word,j,j)
                        self.SuggestText.Text=currentText
                        wait(0.01)
                    end
                    currentText=currentText.."\n"
                    self.SuggestText.Text=currentText
                end
            end)
        else
            self.SuggestFrame.Visible = false
        end
    end)
    
    -- Execute commands
    self.TextBox.FocusLost:Connect(function(enter)
        if enter then
            local inputText=self.TextBox.Text
            self.TextBox.Text=""
            self:Hide()
            local cmd,arg=inputText:match("^(%S+)%s*(.*)$")
            if cmd and self.Commands[cmd:lower()] then
                self.Commands[cmd:lower()](arg)
            else
                self:Notify("Error","Command not found: "..(cmd or ""), "⚠️")
            end
        end
    end)
    
    -- Start notification
    self:Notify(self.StartNotification.Title, self.StartNotification.Message, self.StartNotification.Icon)
    
    return self
end

return CommandBarLib
