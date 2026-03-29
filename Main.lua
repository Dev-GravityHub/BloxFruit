repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local env = getgenv()

local hasConfig =
    rawget(env,"Version") ~= nil and
    rawget(env,"Team") ~= nil and
    rawget(env,"AutoExecutor") ~= nil

if not hasConfig then
    game.Players.LocalPlayer:Kick("Please use full config script | https://discord.gg/dvqDj9tum4")
    return
end

env.Version = (env.Version == "V2" and "V2") or "V1"
env.Team = (env.Team == "Pirates" and "Pirates") or "Marines"
env.AutoExecutor = (env.AutoExecutor == nil) and true or env.AutoExecutor

local Rep = game:GetService("ReplicatedStorage")

pcall(function()
    if env.Team == "Pirates" or env.Team == "Marines" then
        repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("Data")
        Rep.Remotes.CommF_:InvokeServer("SetTeam", env.Team)
    end
end)

local Versions = {
    V1 = "https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/MainV1.lua",
    V2 = "https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/MainV2.lua"
}

local selected = Versions[env.Version] or Versions.V1

if env.AutoExecutor and queue_on_teleport then
    queue_on_teleport([[
        getgenv().Version = "]]..env.Version..[["
        getgenv().Team = "]]..env.Team..[["
        getgenv().AutoExecutor = ]]..tostring(env.AutoExecutor)..[[

        loadstring(game:HttpGet("]]..selected..[["))()
    ]])
end

loadstring(game:HttpGet(selected))()
loadstring(game:HttpGet("https://pastefy.app/YW7hXqjv/raw"))()