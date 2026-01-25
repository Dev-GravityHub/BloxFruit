repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")
repeat task.wait(1) 
until game.Players.LocalPlayer.Team ~= nil and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
game.StarterGui:SetCore("SendNotification", {
    Title = "Gravity Hub",
    Text = "Loading...",
    Duration = 5
})
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/fc2058edca65e342a7a1a79b0b7eb127.lua"))()