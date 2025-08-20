-- CommandBarLib
local CommandBarLib = {}
CommandBarLib.__index = CommandBarLib

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- Constructor
function CommandBarLib.new(options)
    local self = setmetatable({}, CommandBarLib)
    
    self.ThemeColor = options.ThemeColor or Color3.fromRGB(0,255,255)
    self.Commands = options.Commands or {}
    self.StartNotification = options.StartNotification or {Title="Info", Message="CommandBar Loaded", Icon="ℹ️"}
    self.Parent = player:WaitForChild("PlayerGui")
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CommandBarGUI"
    self.ScreenGui.Parent = self.Parent
    
    -- Blur & fog
    self.BlurEffect = Instance.new("BlurEffect")
    self.BlurEffect.Size = 0
    self.BlurEffect.Parent = Lighting
    
    self.FogFrame = Instance.new("Frame")
    self.FogFrame.Size = UDim2.new(1,0,1,0)
    self.FogFrame.BackgroundColor3 = Color3.new(0,0,0)
    self.FogFrame.BackgroundTransparency = 1
    self.FogFrame.Parent = self.ScreenGui

    -- Command frame
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(0,500,0,45)
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
    self.Textbox = Instance.new("TextBox")
    self.Textbox.Size = UDim2.new(1,-20,1,-10)
    self.Textbox.Position = UDim2.new(0,10,0,5)
    self.Textbox.BackgroundTransparency = 1
    self.Textbox.TextColor3 = self.ThemeColor
    self.Textbox.PlaceholderText = "Enter command..."
    self.Textbox.TextXAlignment = Enum.TextXAlignment.Left
    self.Textbox.ClearTextOnFocus = false
    self.Textbox.Font = Enum.Font.Code
    self.Textbox.TextSize = 20
    self.Textbox.Parent = self.Frame
    
    -- Suggestion box
    self.SuggestionFrame = Instance.new("Frame")
    self.SuggestionFrame.Size = UDim2.new(1,0,0,25)
    self.SuggestionFrame.Position = UDim2.new(0,0,-1.8,0)
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
    
    -- CMD button
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
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0,10)
    buttonCorner.Parent = self.Button
    
    self.Button.MouseButton1Click:Connect(function()
        self:Show()
    end)
    
    -- Show/Hide functions
    function self:Show()
        self.Frame.Visible = true
        TweenService:Create(self.FogFrame, TweenInfo.new(0.5), {BackgroundTransparency=0.5}):Play()
        TweenService:Create(self.BlurEffect, TweenInfo.new(0.5), {Size=24}):Play()
        TweenService:Create(self.Frame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,0,0.5,0)}):Play()
        self.Textbox:CaptureFocus()
    end
    
    function self:Hide()
        TweenService:Create(self.FogFrame, TweenInfo.new(0.5), {BackgroundTransparency=1}):Play()
        TweenService:Create(self.BlurEffect, TweenInfo.new(0.5), {Size=0}):Play()
        TweenService:Create(self.Frame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,0,0.4,0)}):Play()
        wait(0.3)
        self.Frame.Visible = false
        self.SuggestionFrame.Visible = false
    end
    
    -- Notification
    function self:Notify(title,msg,icon)
        notify(self.ScreenGui,title,msg,icon,self.ThemeColor)
    end
    
    -- Suggestion & typing animation
    self.Textbox:GetPropertyChangedSignal("Text"):Connect(function()
        local txt = self.Textbox.Text:lower()
        local list = {}
        for cmd,_ in pairs(self.Commands) do
            if cmd:sub(1,#txt) == txt and txt ~= "" then
                table.insert(list, cmd)
            end
        end
        for key,value in pairs(options.Shortcuts or {}) do
            if key:sub(1,#txt) == txt and txt ~= "" then
                table.insert(list, value)
            end
        end
        if #list > 0 then
            self.SuggestionFrame.Visible = true
            self.SuggestionText.Text = ""
            self.SuggestionFrame.Size = UDim2.new(1,0,0,#list*20)
            local currentText = ""
            spawn(function()
                for i = 1,#list do
                    local word = list[i]
                    for j=1,#word do
                        currentText = currentText..string.sub(word,j,j)
                        self.SuggestionText.Text = currentText
                        wait(0.01)
                    end
                    currentText = currentText.."\n"
                    self.SuggestionText.Text = currentText
                end
            end)
        else
            self.SuggestionFrame.Visible = false
        end
    end)
    
    -- Execute commands
    self.Textbox.FocusLost:Connect(function(enter)
        if enter then
            local inputText = self.Textbox.Text
            self.Textbox.Text = ""
            self:Hide()
            local cmd,arg = inputText:match("^(%S+)%s*(.*)$")
            if cmd and self.Commands[cmd:lower()] then
                self.Commands[cmd:lower()](arg)
            elseif cmd then
                self:Notify("Error","Command not found: "..cmd,"⚠️")
            end
        end
    end)
    
    -- Start notification
    self:Notify(self.StartNotification.Title, self.StartNotification.Message, self.StartNotification.Icon)
    
    return self
end

return CommandBarLib
