repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")
repeat task.wait(1) 
until game.Players.LocalPlayer.Team ~= nil and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vinh129150/hack/refs/heads/main/Notify.lua"))()
end)
task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/CauTrom.luau"))()
end)
task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/noguchihyuga/idk/refs/heads/main/abcyxz.lua"))()
end)
task.spawn(function()
    loadstring(game:HttpGet("https://github.com/TlDinhKhoi/Util/raw/refs/heads/main/NotifyBloxKid.luau"))()
end)
task.wait(1)
task.spawn(function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/fc2058edca65e342a7a1a79b0b7eb127.lua"))()
end)
local lastNotificationTime = 0
local notificationCooldown = 5
local currentTime = tick()
if currentTime - lastNotificationTime >= notificationCooldown then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Gravity Hub",
        Text = "Loading...",
        Duration = 5
    })
    lastNotificationTime = currentTime
end