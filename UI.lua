--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

--// ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CommandBarGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

--// Blur & Fog
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local fog = Instance.new("Frame")
fog.Size = UDim2.new(1,0,1,0)
fog.BackgroundColor3 = Color3.new(0,0,0)
fog.BackgroundTransparency = 1
fog.Parent = screenGui

--// Command Frame
local cmdFrame = Instance.new("Frame")
cmdFrame.Size = UDim2.new(0,500,0,45)
cmdFrame.Position = UDim2.new(0.5,0,0.4,0)
cmdFrame.AnchorPoint = Vector2.new(0.5,0.5)
cmdFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
cmdFrame.BorderSizePixel = 0
cmdFrame.Visible = false
cmdFrame.Parent = screenGui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0,10)
uicorner.Parent = cmdFrame

local uistroke = Instance.new("UIStroke")
uistroke.Thickness = 2
uistroke.Color = Color3.fromRGB(0,255,255)
uistroke.Parent = cmdFrame

--// TextBox
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1,-20,1,-10)
textBox.Position = UDim2.new(0,10,0,5)
textBox.BackgroundTransparency = 1
textBox.TextColor3 = Color3.fromRGB(0,255,255)
textBox.PlaceholderText = "Enter command..."
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.ClearTextOnFocus = false
textBox.Font = Enum.Font.Code
textBox.TextSize = 20
textBox.Parent = cmdFrame

--// Suggestion Box
local suggestFrame = Instance.new("Frame")
suggestFrame.Size = UDim2.new(1,0,0,25)
suggestFrame.Position = UDim2.new(0,0,-1.8,0)
suggestFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
suggestFrame.BackgroundTransparency = 0.6
suggestFrame.BorderSizePixel = 0
suggestFrame.Visible = false
suggestFrame.Parent = cmdFrame

local suggestText = Instance.new("TextLabel")
suggestText.Size = UDim2.new(1,-10,1,-2)
suggestText.Position = UDim2.new(0,5,0,1)
suggestText.BackgroundTransparency = 1
suggestText.TextColor3 = Color3.fromRGB(0,255,255)
suggestText.TextXAlignment = Enum.TextXAlignment.Left
suggestText.TextYAlignment = Enum.TextYAlignment.Top
suggestText.Font = Enum.Font.Code
suggestText.TextSize = 18
suggestText.TextWrapped = true
suggestText.Text = ""
suggestText.Parent = suggestFrame

--// CMD Button
local cmdButton = Instance.new("TextButton")
cmdButton.Size = UDim2.new(0,60,0,60)
cmdButton.Position = UDim2.new(0.9,0,0.9,0)
cmdButton.AnchorPoint = Vector2.new(0.5,0.5)
cmdButton.Text = "CMD"
cmdButton.Font = Enum.Font.Code
cmdButton.TextSize = 20
cmdButton.TextColor3 = Color3.fromRGB(255,255,255)
cmdButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
cmdButton.BorderSizePixel = 0
cmdButton.Parent = screenGui
cmdButton.Active = true
cmdButton.Draggable = true

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0,10)
buttonCorner.Parent = cmdButton

--// Stylish Notification Function
local function notify(title,msg,icon)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(0.5, 0, 0, -100)
    notif.AnchorPoint = Vector2.new(0.5, 0)
    notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    notif.BorderSizePixel = 0
    notif.ZIndex = 10
    notif.Parent = screenGui

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 10)
    uicorner.Parent = notif

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Parent = notif

    -- Title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 0, 25)
    titleLabel.Position = UDim2.new(0, 5, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.Code
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    titleLabel.Text = (icon or "").." "..(title or "")
    titleLabel.ZIndex = 11
    titleLabel.Parent = notif

    -- Message label
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -10, 0, 50)
    msgLabel.Position = UDim2.new(0, 5, 0, 25)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Font = Enum.Font.Code
    msgLabel.TextSize = 18
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    msgLabel.Text = msg or ""
    msgLabel.ZIndex = 11
    msgLabel.Parent = notif

    -- Tween in
    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.1, 0)}):Play()

    -- Auto-hide after 3s
    delay(3, function()
        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, -0.2, 0)}):Play()
        wait(0.5)
        notif:Destroy()
    end)
end

--// Show / Hide Functions
local function showCmd()
    cmdFrame.Visible = true
    TweenService:Create(fog,TweenInfo.new(0.5),{BackgroundTransparency=0.5}):Play()
    TweenService:Create(blur,TweenInfo.new(0.5),{Size=24}):Play()
    TweenService:Create(cmdFrame,TweenInfo.new(0.3),{Position=UDim2.new(0.5,0,0.5,0)}):Play()
    textBox:CaptureFocus()
end

local function hideCmd()
    TweenService:Create(fog,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
    TweenService:Create(blur,TweenInfo.new(0.5),{Size=0}):Play()
    TweenService:Create(cmdFrame,TweenInfo.new(0.3),{Position=UDim2.new(0.5,0,0.4,0)}):Play()
    wait(0.3)
    cmdFrame.Visible = false
    suggestFrame.Visible = false
end

cmdButton.MouseButton1Click:Connect(showCmd)

--// Commands
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local commands = {
    -- Movement & Character
    speed = function(arg)
        local num = tonumber(arg)
        if num then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = num
                notify("Speed", "WalkSpeed set to " .. num, "🚀")
            end
        else
            notify("Error", "Usage: speed <number>", "⚠️")
        end
    end,

    jp = function(arg) -- Jump Power
        local num = tonumber(arg)
        if num then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = num
                notify("Jump Power", "JumpPower set to " .. num, "🦘")
            end
        else
            notify("Error", "Usage: jp <number>", "⚠️")
        end
    end,

    fly = function()
        -- A simple, mobile-friendly fly script that toggles
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end

        local hrp = character.HumanoidRootPart
        local bodyVelocity = hrp:FindFirstChild("MobileFlyBV")
        local bodyGyro = hrp:FindFirstChild("MobileFlyBG")

        if bodyVelocity then
            -- Turn off fly
            bodyVelocity:Destroy()
            bodyGyro:Destroy()
            notify("Fly", "Fly mode disabled", "🚶")
        else
            -- Turn on fly
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "MobileFlyBV"
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = hrp

            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.Name = "MobileFlyBG"
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.CFrame = hrp.CFrame
            bodyGyro.Parent = hrp

            -- Control connection for mobile (could be tied to your virtual joystick)
            local flyConnection
            flyConnection = RunService.Heartbeat:Connect(function()
                if not bodyVelocity or not bodyGyro then
                    flyConnection:Disconnect()
                    return
                end

                -- Get camera direction for movement
                local camera = workspace.CurrentCamera
                local lookVector = camera.CFrame.LookVector
                local rightVector = camera.CFrame.RightVector

                -- This would be replaced with input from your virtual joystick
                -- For now, it's a simple upward/downward control
                local velocity = Vector3.new(0, 0, 0)

                -- Example: You would connect this to your UI buttons
                -- if IsFlyForwardPressed then velocity = velocity + (lookVector * 50) end
                -- if IsFlyBackwardPressed then velocity = velocity - (lookVector * 50) end

                bodyVelocity.Velocity = velocity
                bodyGyro.CFrame = camera.CFrame
            end)

            notify("Fly", "Fly mode enabled. Add UI controls!", "🕊️")
        end
    end,

    noclip = function()
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            notify("NoClip", "Noclip enabled", "👻")
        end
    end,

    clip = function()
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            notify("Clip", "Noclip disabled", "🧱")
        end
    end,

    -- Camera & View
    zoom = function(arg)
        local num = tonumber(arg)
        if num then
            local camera = workspace.CurrentCamera
            camera.FieldOfView = num
            notify("Zoom", "FOV set to " .. num, "🔍")
        else
            notify("Error", "Usage: zoom <number>", "⚠️")
        end
    end,

    -- Mobile Utility
    esp = function(arg)
        -- Simple ESP for players, useful on small mobile screens
        local targetName = arg and arg:lower() or "all"
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and (targetName == "all" or p.Name:lower():find(targetName)) then
                if p.Character then
                    local highlight = p.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = p.Character
                end
            end
        end
        notify("ESP", "Highlighting players: " .. targetName, "👀")
    end,

    noesp = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local highlight = p.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
        notify("ESP", "ESP disabled", "🚫")
    end,

    -- Player Interaction
    goto = function(arg)
        if not arg or arg == "" then
            notify("Error", "Usage: goto <player>", "⚠️")
            return
        end
        local target
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():sub(1, #arg) == arg:lower() then
                target = p
                break
            end
        end
        if not target then
            notify("Error", "Player not found: " .. arg, "⚠️")
            return
        end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame
            notify("Teleport", "Teleported to " .. target.Name, "🧭")
        end
    end,

    bring = function(arg)
        if not arg or arg == "" then
            notify("Error", "Usage: bring <player>", "⚠️")
            return
        end
        local target
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():sub(1, #arg) == arg:lower() then
                target = p
                break
            end
        end
        if not target then
            notify("Error", "Player not found: " .. arg, "⚠️")
            return
        end
        local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local theirHrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if myHrp and theirHrp then
            theirHrp.CFrame = myHrp.CFrame
            notify("Bring", "Brought " .. target.Name, "➡️")
        end
    end,

    -- Utility
    respawn = function()
        player:LoadCharacter()
        notify("Respawn", "Character respawned", "🔄")
    end,

    tools = function()
        for _, tool in pairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = player.Character
            end
        end
        notify("Tools", "Equipped all tools", "🛠️")
    end,

    -- Info
    players = function()
        local list = ""
        for i, p in pairs(Players:GetPlayers()) do
            list = list .. (i > 1 and ", " or "") .. p.Name
        end
        notify("Players", #Players:GetPlayers() .. " online: " .. list, "👥")
    end,

    -- Help command that lists all mobile-friendly commands
    help = function()
        local commandList = {
            "speed <num> - Change walk speed",
            "jp <num> - Change jump power",
            "fly - Toggle flight mode",
            "noclip/clip - Toggle collision",
            "zoom <num> - Change camera FOV",
            "esp [player] - Highlight players",
            "noesp - Remove highlights",
            "goto <player> - Teleport to player",
            "bring <player> - Bring player to you",
            "respawn - Respawn your character",
            "tools - Equip all tools",
            "players - List online players"
        }

        -- You might want to display this in a scrolling frame for mobile
        notify("Mobile Commands", "Swipe for more...", "❓")
        -- Ideally, you would have a function to show this list in a mobile-friendly way
    end
}

-- Function to execute commands from your UI
function executeCommand(input)
    local args = {}
    for word in input:gmatch("%S+") do
        table.insert(args, word)
    end

    if #args == 0 then return end

    local commandName = args[1]:lower()
    table.remove(args, 1)
    local argText = table.concat(args, " ")

    if commands[commandName] then
        commands[commandName](argText)
    else
        notify("Error", "Unknown command: " .. commandName, "⚠️")
    end
end

--// Suggestion Box
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = textBox.Text:lower()
    local list = {}
    for cmd,_ in pairs(Commands) do
        if cmd:sub(1,#txt)==txt and txt~="" then table.insert(list,cmd) end
    end
    if #list>0 then
        suggestFrame.Visible = true
        suggestText.Text = ""
        suggestFrame.Size = UDim2.new(1,0,0,#list*20)
        local currentText = ""
        spawn(function()
            for i=1,#list do
                local word = list[i]
                for j=1,#word do
                    currentText = currentText..string.sub(word,j,j)
                    suggestText.Text = currentText
                    wait(0.01)
                end
                currentText = currentText.."\n"
                suggestText.Text = currentText
            end
        end)
    else
        suggestFrame.Visible = false
    end
end)

--// Execute Commands
textBox.FocusLost:Connect(function(enter)
    if enter then
        local inputText = textBox.Text
        textBox.Text = ""
        hideCmd()
        local cmd,arg = inputText:match("^(%S+)%s*(.*)$")
        if cmd and Commands[cmd:lower()] then
            Commands[cmd:lower()](arg)
        else
            notify("Error","Command not found: "..(cmd or ""),"⚠️")
        end
    end
end)

--// Start Notification
notify("Welcome","This is Made from lucent!","🪽")
