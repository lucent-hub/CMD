local CommandBarLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucent-hub/CMD/refs/heads/main/UI.lua"))()

local commandBar = CommandBarLib.new({
    ThemeColor = Color3.fromRGB(0,255,255),
    StartNotification = {
        Title = "Welcome",
        Message = "Hello handsome!",
        Icon = "😎"
    },
    Commands = {
        hello = function() commandBar:Notify("Hello","World","😎") end,
        help = function() commandBar:Notify("Help","This is help!","❓") end,
        speed = function(arg)
            local num = tonumber(arg)
            if num then
                local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.WalkSpeed = num end
                commandBar:Notify("Speed","WalkSpeed set to "..num,"🌟")
            else
                commandBar:Notify("Error","Usage: speed <number>","⚠️")
            end
        end,
        goto = function(arg)
            if arg and arg~="" then
                local targetPlayer
                for _,p in pairs(game.Players:GetPlayers()) do
                    if p.Name:lower():sub(1,#arg) == arg:lower() then targetPlayer=p break end
                end
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                        commandBar:Notify("Teleport","Teleported to "..targetPlayer.Name,"🧭")
                    end
                else commandBar:Notify("Error","Player not found.\nUsage: goto <player>","⚠️") end
            else commandBar:Notify("Error","Usage: goto <player>","⚠️") end
        end
    },
    Shortcuts = {
        sh = "goto Steve",
        k = "cframefly",
        h = "helm"
    }
})
