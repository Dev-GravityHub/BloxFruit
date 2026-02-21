repeat
    wait()
until game:IsLoaded()
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    World2 = true
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    World3 = true
end
local function setTeam(teamName)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", teamName)
end
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if getgenv().Settings.JoinTeam then
    local minimal = playerGui:FindFirstChild("Main (minimal)")
    if minimal then
        task.wait(5)
        setTeam(getgenv().Settings.Team)
    end
end
repeat
    wait()
until game.Players.LocalPlayer.Character
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local CG=game:GetService("CoreGui")
local plr=Players.LocalPlayer

local function MkGui(name)
	local old=CG:FindFirstChild(name)
	if old then old:Destroy() end
	local g=Instance.new("ScreenGui")
	g.Name=name
	g.ResetOnSpawn=false
	g.Parent=CG
	return g
end

local function norm(t)
	t=tostring(t or ""):lower()
	t=t:gsub("[%c%p]", " ")
	t=t:gsub("%s+"," "):gsub("^%s+",""):gsub("%s+$","")
	return t
end

local function Tween(obj,t,props)
	local info=TweenInfo.new(t,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
	local tw=TS:Create(obj,info,props)
	tw:Play()
	return tw
end

local function Round(obj,r)
	local c=Instance.new("UICorner",obj)
	c.CornerRadius=UDim.new(0,r)
	return c
end

local ControlGUI=MkGui("ControlGUI")
local ImgBtn=Instance.new("ImageButton")
ImgBtn.Size=UDim2.new(0,50,0,50)
ImgBtn.Position=UDim2.new(0.15,0,0.15,0)
ImgBtn.Image="rbxassetid://73675787844710"
ImgBtn.BackgroundTransparency=1
ImgBtn.Parent=ControlGUI
Round(ImgBtn,999)

local UIStroke=Instance.new("UIStroke",ImgBtn)
UIStroke.Thickness=2
UIStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
local RainbowColors={
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(255,127,0),
	Color3.fromRGB(255,255,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,255,255),
	Color3.fromRGB(0,0,255),
	Color3.fromRGB(139,0,255)
}
task.spawn(function()
	local idx=1
	while UIStroke.Parent do
		UIStroke.Color=RainbowColors[idx]
		idx=idx%#RainbowColors+1
		task.wait(0.25)
	end
end)

do
	local dragging=false
	local dragInput,dragStart,startPos
	local function update(input)
		local delta=input.Position-dragStart
		ImgBtn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
	end
	ImgBtn.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			dragStart=input.Position
			startPos=ImgBtn.Position
			local c; c=input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputType.End then
					dragging=false
					if c then c:Disconnect() end
				end
			end)
		end
	end)
	ImgBtn.InputChanged:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
			dragInput=input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input==dragInput then update(input) end
	end)
end

local GravityHubGUI=MkGui("GravityHub")
GravityHubGUI.Enabled=true

local mainFrame=Instance.new("Frame")
mainFrame.AnchorPoint=Vector2.new(0.5,0.5)
mainFrame.Position=UDim2.new(0.5,0,0.44,0)
mainFrame.Size=UDim2.new(0,430,0,330)
mainFrame.BackgroundTransparency=1
mainFrame.BorderSizePixel=0
mainFrame.Parent=GravityHubGUI

local uiScale=Instance.new("UIScale",mainFrame)
local function ApplyScale()
	local cam=workspace.CurrentCamera
	if not cam then return end
	local vp=cam.ViewportSize
	local baseW,baseH=430,330
	local s=math.min((vp.X-30)/baseW,(vp.Y-120)/baseH,1)
	if s<0.55 then s=0.55 end
	uiScale.Scale=s
end
ApplyScale()
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		task.defer(ApplyScale)
	end)
end

local function MakeGalaxyLayer(parent, radius)
	local base=Instance.new("Frame")
	base.Size=UDim2.new(1,0,1,0)
	base.BorderSizePixel=0
	base.Parent=parent
	Round(base,radius)

	local grad=Instance.new("UIGradient",base)
	grad.Rotation=35
	grad.Color=ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(10,14,40)),
		ColorSequenceKeypoint.new(0.35, Color3.fromRGB(55,24,120)),
		ColorSequenceKeypoint.new(0.70, Color3.fromRGB(20,90,170)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(120,60,255)),
	})

	local stars=Instance.new("ImageLabel")
	stars.Size=UDim2.new(1,0,1,0)
	stars.BackgroundTransparency=1
	stars.Image="rbxassetid://128972793928157"
	stars.ImageTransparency=0.55
	stars.ScaleType=Enum.ScaleType.Crop
	stars.Parent=parent
	Round(stars,radius)

	local overlay=Instance.new("Frame")
	overlay.Size=UDim2.new(1,0,1,0)
	overlay.BackgroundColor3=Color3.fromRGB(0,0,0)
	overlay.BackgroundTransparency=0.55
	overlay.BorderSizePixel=0
	overlay.Parent=parent
	Round(overlay,radius)

	return stars
end

local function PinkBtn(parent, txt, y)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(1,-36,0,40)
	b.Position=UDim2.new(0,18,0,y)
	b.BackgroundColor3=Color3.fromRGB(255,105,180)
	b.AutoButtonColor=false
	b.Text=txt
	b.TextColor3=Color3.new(1,1,1)
	b.TextSize=16
	b.Font=Enum.Font.Arcade
	b.Parent=parent
	Round(b,12)
	local st=Instance.new("UIStroke",b)
	st.Thickness=2
	st.Color=Color3.fromRGB(255,200,230)
	st.Transparency=0.15
	b.MouseEnter:Connect(function() b.BackgroundColor3=Color3.fromRGB(255,140,200) end)
	b.MouseLeave:Connect(function() b.BackgroundColor3=Color3.fromRGB(255,105,180) end)
	return b
end

local HeaderFrame=Instance.new("Frame")
HeaderFrame.AnchorPoint=Vector2.new(0.5,0)
HeaderFrame.Position=UDim2.new(0.5,0,0,0)
HeaderFrame.Size=UDim2.new(1,0,0,110)
HeaderFrame.BackgroundColor3=Color3.fromRGB(10,10,14)
HeaderFrame.BackgroundTransparency=0.08
HeaderFrame.BorderSizePixel=0
HeaderFrame.Parent=mainFrame
Round(HeaderFrame,20)

local headerStroke=Instance.new("UIStroke",HeaderFrame)
headerStroke.Thickness=2
headerStroke.Color=Color3.fromRGB(140,110,255)
headerStroke.Transparency=0.18

local hstars=MakeGalaxyLayer(HeaderFrame,20)

local avatar=Instance.new("ImageLabel")
avatar.Size=UDim2.new(0,64,0,64)
avatar.Position=UDim2.new(0,16,0,20)
avatar.BackgroundTransparency=1
avatar.Image="rbxassetid://128972793928157"
avatar.Parent=HeaderFrame
Round(avatar,32)
local avs=Instance.new("UIStroke",avatar)
avs.Thickness=2
avs.Color=Color3.fromRGB(255,170,240)
avs.Transparency=0.2

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-100,0,44)
title.Position=UDim2.new(0,92,0,18)
title.BackgroundTransparency=1
title.Text="Gravity Hub"
title.TextColor3=Color3.fromRGB(255,255,255)
title.TextSize=36
title.Font=Enum.Font.GothamBlack
title.TextXAlignment=Enum.TextXAlignment.Left
title.Parent=HeaderFrame

local sub=Instance.new("TextLabel")
sub.Size=UDim2.new(1,-100,0,18)
sub.Position=UDim2.new(0,92,0,62)
sub.BackgroundTransparency=1
sub.Text="Kaitun Valentine"
sub.TextColor3=Color3.fromRGB(215,215,225)
sub.TextSize=14
sub.Font=Enum.Font.Gotham
sub.TextXAlignment=Enum.TextXAlignment.Left
sub.Parent=HeaderFrame

local BodyFrame=Instance.new("Frame")
BodyFrame.AnchorPoint=Vector2.new(0.5,0)
BodyFrame.Position=UDim2.new(0.5,0,0,110)
BodyFrame.Size=UDim2.new(1,0,0,220)
BodyFrame.BackgroundColor3=Color3.fromRGB(10,10,14)
BodyFrame.BackgroundTransparency=0.08
BodyFrame.BorderSizePixel=0
BodyFrame.Parent=mainFrame
Round(BodyFrame,20)

local bodyStroke=Instance.new("UIStroke",BodyFrame)
bodyStroke.Thickness=2
bodyStroke.Color=Color3.fromRGB(140,110,255)
bodyStroke.Transparency=0.18

local bstars=MakeGalaxyLayer(BodyFrame,20)

local info=Instance.new("Frame")
info.Size=UDim2.new(1,-36,0,92)
info.Position=UDim2.new(0,18,0,14)
info.BackgroundColor3=Color3.fromRGB(0,0,0)
info.BackgroundTransparency=0.45
info.BorderSizePixel=0
info.Parent=BodyFrame
Round(info,14)
local ifs=Instance.new("UIStroke",info)
ifs.Thickness=1
ifs.Color=Color3.fromRGB(160,120,255)
ifs.Transparency=0.35

local farmText=Instance.new("TextLabel")
farmText.Size=UDim2.new(1,-20,1,-16)
farmText.Position=UDim2.new(0,10,0,8)
farmText.BackgroundTransparency=1
farmText.Text="Farm: none"
farmText.TextColor3=Color3.fromRGB(255,210,245)
farmText.TextSize=14
farmText.Font=Enum.Font.GothamBold
farmText.TextWrapped=true
farmText.TextXAlignment=Enum.TextXAlignment.Center
farmText.TextYAlignment=Enum.TextYAlignment.Center
farmText.Parent=info

local btnEvent=PinkBtn(BodyFrame,"Click to shop event",128)
local btnDiscord=PinkBtn(BodyFrame,"COPY DISCORD",172)

local headerFinal=HeaderFrame.Position
local bodyFinal=BodyFrame.Position

HeaderFrame.Position=headerFinal + UDim2.new(0,0,0,-70)
BodyFrame.Position=bodyFinal + UDim2.new(0,0,0,90)

local function SetAlpha(root, a)
	for _,d in ipairs(root:GetDescendants()) do
		if d:IsA("TextLabel") or d:IsA("TextButton") then d.TextTransparency=a end
		if d:IsA("ImageLabel") or d:IsA("ImageButton") then
			local base=(d==hstars or d==bstars) and 0.55 or 0
			d.ImageTransparency=math.clamp(base + a*0.45,0,1)
		end
		if d:IsA("UIStroke") then d.Transparency=math.clamp(d.Transparency + a*0.6,0,1) end
	end
end

SetAlpha(HeaderFrame,1)
SetAlpha(BodyFrame,1)
HeaderFrame.BackgroundTransparency=1
BodyFrame.BackgroundTransparency=1
headerStroke.Transparency=1
bodyStroke.Transparency=1

task.defer(function()
	local t=0.75
	Tween(HeaderFrame,t,{Position=headerFinal,BackgroundTransparency=0.08})
	Tween(BodyFrame,t,{Position=bodyFinal,BackgroundTransparency=0.08})
	Tween(headerStroke,t,{Transparency=0.18})
	Tween(bodyStroke,t,{Transparency=0.18})
	for _,root in ipairs({HeaderFrame,BodyFrame}) do
		for _,d in ipairs(root:GetDescendants()) do
			if d:IsA("TextLabel") or d:IsA("TextButton") then Tween(d,t,{TextTransparency=0}) end
			if d:IsA("ImageLabel") or d:IsA("ImageButton") then
				if d==hstars or d==bstars then Tween(d,t,{ImageTransparency=0.55})
				else Tween(d,t,{ImageTransparency=0}) end
			end
		end
	end
end)

local windowVisible=true
ImgBtn.MouseButton1Click:Connect(function()
	windowVisible=not windowVisible
	GravityHubGUI.Enabled=windowVisible
	if windowVisible then
		HeaderFrame.Position=headerFinal + UDim2.new(0,0,0,-70)
		BodyFrame.Position=bodyFinal + UDim2.new(0,0,0,90)
		task.defer(function()
			local t=0.75
			Tween(HeaderFrame,t,{Position=headerFinal})
			Tween(BodyFrame,t,{Position=bodyFinal})
		end)
	end
end)

local function QuestTitleText()
	local ok,res=pcall(function()
		local main=plr.PlayerGui:WaitForChild("Main",5)
		if not main then return "" end
		local q=main:FindFirstChild("Quest")
		if not q then return "" end
		local c=q:FindFirstChild("Container")
		local qt=(c and c:FindFirstChild("QuestTitle")) or q:FindFirstChild("QuestTitle")
		if qt then
			if qt:IsA("TextLabel") or qt:IsA("TextBox") then
				local t=tostring(qt.Text); if t~="" then return t end
			end
			for _,d in ipairs(qt:GetDescendants()) do
				if d:IsA("TextLabel") or d:IsA("TextBox") then
					local t=tostring(d.Text); if t~="" then return t end
				end
			end
		end
		for _,d in ipairs(q:GetDescendants()) do
			if d:IsA("TextLabel") or d:IsA("TextBox") then
				local t=tostring(d.Text)
				local s=norm(t)
				if t~="" and (s:find("defeat",1,true) or s:find("boss",1,true)) then
					return t
				end
			end
		end
		return ""
	end)
	return ok and res or ""
end

local function HasQuest()
	local ok,res=pcall(function()
		local main=plr.PlayerGui:FindFirstChild("Main")
		if not main then return false end
		if main:IsA("ScreenGui") and main.Enabled==false then return false end
		local q=main:FindFirstChild("Quest")
		if not q or q.Visible==false then return false end
		local c=q:FindFirstChild("Container")
		if c and c.Visible==false then return false end
		local t=QuestTitleText()
		return t and t:gsub("%s+","")~=""
	end)
	return ok and res or false
end

local function QuestMode()
	local t=QuestTitleText()
	local s=norm(t)
	if s=="" then return "none",t end
	if s:find("fruit",1,true) or s:find("fruits",1,true) or s:find("blox fruit",1,true) or s:find("devil fruit",1,true)
		or s:find("collect",1,true) or s:find("pickup",1,true) or s:find("pick up",1,true) then
		return "fruit",t
	end
	if s:find("fish",1,true) or s:find("catch",1,true) then return "fish",t end
	if s:find("sea",1,true) or s:find("seabeast",1,true) or s:find("terror",1,true) or s:find("shark",1,true) or s:find("piranha",1,true) then
		return "sea",t
	end
	if s:find("boss",1,true) then return "boss",t end
	if s:find("defeat",1,true) and (s:find("enem",1,true) or s:find("enemy",1,true) or s:find("enemies",1,true)) then
		return "mob",t
	end
	return "unknown",t
end

local function NiceMode(m)
	if m=="mob" then return "Farm Mob" end
	if m=="boss" then return "Farm Boss" end
	if m=="fruit" then return "Farm Fruit" end
	if m=="fish" then return "Farm Fish" end
	if m=="sea" then return "Farm Sea" end
	if m=="none" then return "Farm: none" end
	return "Farm "..tostring(m):upper()
end

task.spawn(function()
	local last=""
	while task.wait(0.35) do
		pcall(function()
			if not GravityHubGUI.Enabled then return end
			local txt
			if not HasQuest() then
				txt="Farm: none"
			else
				local mode,title2=QuestMode()
				txt=NiceMode(mode).."\n"..tostring(title2 or "")
			end
			if txt~=last then
				last=txt
				farmText.Text=txt
			end
		end)
	end
end)

local function RunEventShop()
	local RS=game:GetService("ReplicatedStorage")
	local EVENT_TYPE="Valentine"

	local function FindViaGC()
		if type(getgc)~="function" then return nil end
		for _,obj in ipairs(getgc(true)) do
			if type(obj)=="table" then
				local init=rawget(obj,"init")
				local Open=rawget(obj,"Open")
				local Close=rawget(obj,"Close")
				local GetIfInitialized=rawget(obj,"GetIfInitialized")
				if type(init)=="function" and type(Open)=="function" and type(Close)=="function" and type(GetIfInitialized)=="function" then
					return obj
				end
			end
		end
	end

	local function FindViaRS()
		for _,inst in ipairs(RS:GetDescendants()) do
			if inst:IsA("ModuleScript") then
				local n=inst.Name:lower()
				if n:find("event",1,true) or n:find("celebr",1,true) or n:find("shop",1,true) then
					local ok,mod=pcall(require,inst)
					if ok and type(mod)=="table" and type(mod.init)=="function" and type(mod.Open)=="function" and type(mod.Close)=="function" then
						return mod
					end
				end
			end
		end
	end

	local Svc=FindViaGC() or FindViaRS()
	if not Svc then return end

	local function EnsureInit()
		local ok,des=pcall(Svc.init)
		if ok and type(des)=="function" then return des end
	end

	EnsureInit()
	local function IsOpen() return Svc.IsOpen==true end
	local function OpenShop() pcall(function() Svc:Open(EVENT_TYPE) end) end
	local function CloseShop() pcall(function() Svc:Close() end) end

	if IsOpen() then CloseShop() else
		if type(Svc.GetIfInitialized)=="function" and not Svc:GetIfInitialized() then EnsureInit() end
		OpenShop()
	end
end

btnEvent.MouseButton1Click:Connect(function()
	pcall(RunEventShop)
end)

local DISCORD_LINK="https://discord.gg/rPgRN9j8w"
btnDiscord.MouseButton1Click:Connect(function()
	if setclipboard then setclipboard(DISCORD_LINK) end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/TBoyRoblox727/TBoyRobloxYTB/refs/heads/main/FastMax.lua"))()

do
    local Players = game:GetService("Players")
    ply = Players
    plr = Players.LocalPlayer
    replicated = game:GetService("ReplicatedStorage")
    TeleportService = game:GetService("TeleportService")
    TW = game:GetService("TweenService")
    Lighting = game:GetService("Lighting")
    Enemies = workspace:WaitForChild("Enemies")
    vim1 = game:GetService("VirtualInputManager")
    vim2 = game:GetService("VirtualUser")
    RunSer = game:GetService("RunService")
    Stats = game:GetService("Stats")

    local c = plr.Character or plr.CharacterAdded:Wait()
    Root = c:WaitForChild("HumanoidRootPart")

    Lv = plr:WaitForChild("Data"):WaitForChild("Level").Value
    Energy = (c:FindFirstChild("Energy") and c.Energy.Value) or 0
    TeamSelf = plr.Team
end
_G.SpeedTween = _G.SpeedTween or 325
_G.PosY = _G.PosY or 0
shouldTween = true
_B = true
_G.BringRange = _G.BringRange or 350
_G.SpeedB = _G.SpeedB or 300
_G.MobM = _G.MobM or 7

Attack = Attack or {}

World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

EquipByTip = EquipByTip or function(tip)
	local c = plr.Character
	local bp = plr:FindFirstChildOfClass("Backpack")
	if c then
		for _,v in ipairs(c:GetChildren()) do
			if v:IsA("Tool") and v.ToolTip == tip then return v end
		end
	end
	if bp then
		for _,v in ipairs(bp:GetChildren()) do
			if v:IsA("Tool") and v.ToolTip == tip then
				local hum = c and c:FindFirstChildOfClass("Humanoid")
				if hum then pcall(function() hum:EquipTool(v) end) end
				return v
			end
		end
	end
end
local lastTP = 0
local TP_CD = 0.12

Attack.Kill = function(model, Succes)
	if not (model and Succes) then return end
	local hrp = model:FindFirstChild("HumanoidRootPart"); if not hrp then return end

	local locked = model:GetAttribute("Locked")
	if typeof(locked) ~= "CFrame" then
		model:SetAttribute("Locked", hrp.CFrame)
		locked = hrp.CFrame
	end

	PosMon = locked.Position
	BringEnemy()
       EquipWeapon(_G.SelectWeapon)

	local now = os.clock()
	if now - lastTP < TP_CD then return end
	lastTP = now

	local tool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
	local tip = tool and tool:FindFirstChild("ToolTip") and tool.ToolTip
	local isFruit = (tip == "Blox Fruit")

	local offset = isFruit and CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)
		or CFrame.new(0,30,0) * CFrame.Angles(0,math.rad(180),0)

	_tp(locked * offset, true)
end
Attack.Alive = function(model) if not model then return end local Humanoid = model:FindFirstChild("Humanoid") return Humanoid and Humanoid.Health > 0 end
GetConnectionEnemies = function(a)
  for i,v in pairs(replicated:GetChildren()) do
    if v:IsA("Model") and  ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
      return v
    end
  end
  for i,v in next,game.Workspace.Enemies:GetChildren() do
    if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a)  and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
      return v
    end
  end
end

local function FindNearestEnemyByName(name)
    local e = workspace:FindFirstChild("Enemies")
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not e or not hrp then return nil end

    local best, bestD = nil, math.huge
    for _,m in ipairs(e:GetChildren()) do
        if m.Name == name then
            local hum = m:FindFirstChildOfClass("Humanoid")
            local rp = m:FindFirstChild("HumanoidRootPart")
            if hum and rp and hum.Health > 0 then
                local d = (rp.Position - hrp.Position).Magnitude
                if d < bestD then bestD, best = d, m end
            end
        end
    end
    return best
end
EquipWeapon = function(name)
    if not name then return end
    local c = plr.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local t = (c and c:FindFirstChild(name)) or (plr.Backpack and plr.Backpack:FindFirstChild(name))
    if not t then return end
    if t.Parent == c then return t end

    for _=1,6 do
        pcall(function() hum:EquipTool(t) end)
        task.wait()
        if t.Parent == c then return t end
        t = (c and c:FindFirstChild(name)) or (plr.Backpack and plr.Backpack:FindFirstChild(name))
        if not t then break end
    end
end
Modules = Modules or {}
Modules.Players = Modules.Players or game:GetService("Players")
function Modules:GetMasteryCurrentTool(Type)
    local P = (self and self.Players) or game:GetService("Players")
    local lp = P.LocalPlayer
    local c = lp and lp.Character
    local bp = lp and lp:FindFirstChildOfClass("Backpack")

    if c then
        for _,v in next, c:GetChildren() do
            if v:IsA("Tool") and v.ToolTip == Type and v:FindFirstChild("Level") then
                return v.Level.Value
            end
        end
    end
    if bp then
        for _,v in next, bp:GetChildren() do
            if v:IsA("Tool") and v.ToolTip == Type and v:FindFirstChild("Level") then
                return v.Level.Value
            end
        end
    end
    return 0
end
GetBP = function(v)
  return plr.Backpack:FindFirstChild(v) or plr.Character:FindFirstChild(v)
end
local UIS = game:GetService("UserInputService")

local function Buddha_Z_OneShot()
    local tool = EquipWeapon("Buddha-Buddha") or EquipWeapon("Buddha")
    if not tool then return false end
    if UIS:GetFocusedTextBox() then return false end

    vim1:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
    task.wait(0.09)
    vim1:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    return true
end

pcall(Buddha_Z_OneShot)

function Modules:CheckInventory(Name)
    for i,v in next, Modules.ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory") do
        if v.Name == Name then
            return v
        end
    end
end
function CheckNearestTeleporter(aI)
    local vcspos = aI.Position
    local min = math.huge
    local min2 = math.huge
    local y = game.PlaceId
      
    if tostring(aI.Position) == "28286, 14897, 103" then
        local mapStash = game:GetService("ReplicatedStorage"):WaitForChild("MapStash")
        local temple = mapStash:FindFirstChild("Temple of Time")
        if temple and not workspace:FindFirstChild("Temple of Time") then
            temple.Parent = workspace:WaitForChild("Map")
        end
        while not workspace:FindFirstChild("Temple of Time") do task.wait(999) end
    end

    local TableLocations = {}
    if y == 7449423635 or y == 100117331123089 then
        TableLocations = {
            ["Mansion"] = Vector3.new(-12471, 374, -7551),
            ["Hydra"] = Vector3.new(5659, 1013, -341),
            ["Caslte On The Sea"] = Vector3.new(-5092, 315, -3130),
            ["Floating Turtle"] = Vector3.new(-12001, 332, -8861),
            ["Beautiful Pirate"] = Vector3.new(5319, 23, -93)
        }
    elseif y == 4442272183 or y == 79091703265657 then
        TableLocations = {
            ["Flamingo Mansion"] = Vector3.new(-317, 331, 597),
            ["Flamingo Room"] = Vector3.new(2283, 15, 867),
            ["Cursed Ship"] = Vector3.new(923, 125, 32853),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    elseif y == 2753915549 or y == 85211729168715 then
        TableLocations = {
            ["Sky Island 1"] = Vector3.new(-4652, 873, -1754),
            ["Under Water Island"] = Vector3.new(61164, 5, 1820)
        }
    end

    local TableLocations2 = {}
    for r, v in pairs(TableLocations) do TableLocations2[r] = (v - vcspos).Magnitude end
    for r, v in pairs(TableLocations2) do if v < min then min = v min2 = v end end
    
    local choose
    for r, v in pairs(TableLocations2) do if v <= min then choose = TableLocations[r] end end
    
    local min3 = (vcspos - plr.Character.HumanoidRootPart.Position).Magnitude
    if min2 <= min3 then return choose end
end

function requestEntrance(aJ)
    replicated.Remotes.CommF_:InvokeServer("requestEntrance", aJ)
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(aJ.X, aJ.Y + 15, aJ.Z)
    end
    task.wait(0.3)
end


shouldTween = (shouldTween ~= false)

local TweenService = game:GetService("TweenService")

local function GetChar()
	return plr and plr.Character
end

local function GetHRP()
	local c = GetChar()
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetHum()
	local c = GetChar()
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function ToCFrame(t)
	if typeof(t) == "CFrame" then return t end
	if typeof(t) == "Vector3" then return CFrame.new(t) end
	if typeof(t) == "Instance" and t:IsA("BasePart") then return t.CFrame end
	return nil
end

local _tpTween
local _tpId = 0
local lastPortal, lastPortalTime = nil, 0
local PORTAL_CD = 2

_tp = function(target, force)
	local hrp = GetHRP(); if not hrp then return end
	local hum = GetHum()
	local cf = ToCFrame(target); if not cf then return end

	_tpId += 1
	local myId = _tpId

	if _tpTween then pcall(function() _tpTween:Cancel() end) end

	do
		local portal = CheckNearestTeleporter and CheckNearestTeleporter(cf)
		if portal then
			local now = os.clock()
			if portal ~= lastPortal or (now - lastPortalTime) > PORTAL_CD then
				lastPortal = portal
				lastPortalTime = now
				pcall(function() requestEntrance(portal) end)
			end
		end
	end

	local SpeedT = tonumber(_G.SpeedTween) or 300
	local HEIGHT = tonumber(_G.PosY) or 0
	local snapDist = tonumber(_G.SnapDist) or 167
	local step = tonumber(_G.StepTween) or 500

	local rot = (cf - cf.Position)
	local goalPos = cf.Position + Vector3.new(0, HEIGHT, 0)
	local goalCF = CFrame.new(goalPos) * rot

	local function canRun()
		return myId == _tpId and (force or shouldTween)
	end

	local function prep()
		pcall(function()
			hrp.Anchored = false
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.AssemblyAngularVelocity = Vector3.zero
		end)
		if hum then
			pcall(function()
				hum:ChangeState(Enum.HumanoidStateType.Physics)
				hum.AutoRotate = false
			end)
		end
	end

	local function cleanup()
		if hum then
			pcall(function() hum.AutoRotate = true end)
		end
	end

	local function tweenTo(pos, speed)
		if not canRun() then return false end
		hrp = GetHRP(); if not hrp then return false end

		local d = (hrp.Position - pos).Magnitude
		local t = math.max(0.06, d / math.max(1, speed))

		prep()
		_tpTween = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos) * rot})
		_tpTween:Play()

		while _tpTween and _tpTween.PlaybackState == Enum.PlaybackState.Playing do
			if not canRun() then
				pcall(function() _tpTween:Cancel() end)
				cleanup()
				return false
			end
			hrp = GetHRP()
			if not hrp then
				pcall(function() _tpTween:Cancel() end)
				cleanup()
				return false
			end
			pcall(function()
				hrp.AssemblyLinearVelocity = Vector3.zero
				hrp.AssemblyAngularVelocity = Vector3.zero
			end)
			task.wait(0.05)
		end

		return canRun()
	end

	local hrpNow = GetHRP(); if not hrpNow then return end
	local dist = (hrpNow.Position - goalPos).Magnitude
	if dist <= snapDist then
		prep()
		hrpNow.CFrame = goalCF
		task.wait()
		hrpNow.CFrame = goalCF
		cleanup()
		return
	end

	local cur = hrpNow.Position
	while canRun() do
		hrpNow = GetHRP(); if not hrpNow then cleanup(); return end
		local d = (goalPos - hrpNow.Position).Magnitude
		if d <= step then break end
		local dir = (goalPos - hrpNow.Position).Unit
		local nextPos = hrpNow.Position + dir * step
		if not tweenTo(nextPos, SpeedT) then cleanup(); return end
	end

	if not tweenTo(goalPos, SpeedT) then cleanup(); return end

	if canRun() then
		prep()
		hrpNow = GetHRP()
		if hrpNow then
			hrpNow.CFrame = goalCF
			task.wait()
			hrpNow.CFrame = goalCF
		end
	end
	cleanup()
end
task.spawn(function()
    while task.wait(1) do
        local c = plr.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not hrp:FindFirstChild("BodyClip") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "BodyClip"
                bv.Parent = hrp
                bv.MaxForce = Vector3.new(100000,100000,100000)
                bv.Velocity = Vector3.new(0,0,0)
            end
            if not c:FindFirstChild("highlight") then
                local h = Instance.new("Highlight")
                h.Name = "highlight"
                h.Enabled = true
                h.FillColor = Color3.fromRGB(255,165,0)
                h.OutlineColor = Color3.fromRGB(255,0,0)
                h.FillTransparency = 0.5
                h.OutlineTransparency = 0.2
                h.Parent = c
            end
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)
CheckBoat = function()
  for i, v in pairs(workspace.Boats:GetChildren()) do
    if tostring(v.Owner.Value) == tostring(plr.Name) then
      return v    
end;
  end;
  return false
end;
CheckEnemiesBoat = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "FishBoat") and v:FindFirstChild("Health").Value > 0 then
      return true    
end;
  end;
  return false
end;
CheckPirateGrandBrigade = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "PirateGrandBrigade" or v.Name == "PirateBrigade") and v:FindFirstChild("Health").Value > 0 then
      return true
    end
  end
  return false
end
CheckShark = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if v.Name == "Shark" and Attack.Alive(v) then
      return true    
end;
  end;
  return false
end;
CheckTerrorShark = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if v.Name == "Terrorshark" and Attack.Alive(v) then
      return true    
end;
  end;
  return false
end;
CheckPiranha = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if v.Name == "Piranha" and Attack.Alive(v) then
      return true    
end;
  end;
  return false
end;
CheckFishCrew = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "Fish Crew Member" or v.Name == "Haunted Crew Member") and Attack.Alive(v) then
      return true    
end;
  end;
  return false
end;
CheckHauntedCrew = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "Haunted Crew Member") and Attack.Alive(v) then
      return true    
end;
  end;
  return false
end;
CheckSeaBeast = function()
  if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
    return true  
end;
  return false
end;
local RS=game:GetService("ReplicatedStorage")
local CommF_=RS:WaitForChild("Remotes"):WaitForChild("CommF_")
local function CF(...) return CommF_:InvokeServer(...) end

local _fishCD,_fishLast=3,0

local function LoadRandomFishUID()
	local now=os.clock()
	local d=_fishCD-(now-_fishLast)
	if d>0 then task.wait(d) end
	_fishLast=os.clock()

	local function isGUID(s)
		return typeof(s)=="string" and s:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$")~=nil
	end
	local function collect(t,out,seen)
		if typeof(t)~="table" then return end
		for k,v in pairs(t) do
			if isGUID(k) and not seen[k] then seen[k]=true; out[#out+1]=k end
			if isGUID(v) and not seen[v] then seen[v]=true; out[#out+1]=v end
			if typeof(v)=="table" then collect(v,out,seen) end
		end
	end

	local fish=CF("getFish")
	local list,seen={},{}
	collect(fish,list,seen)
	if #list==0 then return end

	local uid=list[math.random(#list)]
	local ok=CF("LoadItem",uid,{"Fish"})

	CF("ValentineCurrentQuest")
	CF("ValentinesBringFishQuest")

	return ok, uid
end
_B = _B or false
_G.BringRange = _G.BringRange or 350
_G.SpeedB = _G.SpeedB or 300
_G.MobM = _G.MobM or 7
_G.BringUpY = _G.BringUpY or 36

local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local plr = Players.LocalPlayer

local function isBossMob(mob)
	if not BossList then return false end
	for _, b in ipairs(BossList) do
		if mob.Name == b then return true end
	end
	return false
end
Attack.KillSea = function(model,Succes)
  if model and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
  EquipWeapon(_G.SelectWeapon)
  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
  local ToolTip = Equipped.ToolTip
  if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)) else notween(model.HumanoidRootPart.CFrame * CFrame.new(0,50,8)) wait(.85)notween(model.HumanoidRootPart.CFrame * CFrame.new(0,400,0)) wait(4)end
  end
end
BringEnemy = function()
	if not _B then return end
	if not PosMon then return end

	local char = plr.Character
	local hrpPlr = char and char:FindFirstChild("HumanoidRootPart")
	if not hrpPlr then return end

	local range = tonumber(_G.BringRange) or 400
	local speed = tonumber(_G.SpeedB) or 400
	local maxMob = tonumber(_G.MobM) or 7
	local upY = tonumber(_G.BringUpY) or 36

	local list = {}
	for _, v in pairs(workspace.Enemies:GetChildren()) do
		if #list >= maxMob then break end
		if isBossMob(v) then continue end

		local hum = v:FindFirstChildOfClass("Humanoid")
		local pp = v.PrimaryPart or v:FindFirstChild("HumanoidRootPart")
		if hum and pp and hum.Health > 0 then
			if (pp.Position - PosMon).Magnitude <= range then
				list[#list + 1] = {mob = v, hum = hum, pp = pp}
			end
		end
	end

	if #list <= 1 then return end

	pcall(function()
		sethiddenproperty(plr, "SimulationRadius", math.huge)
	end)

	local bringPos = PosMon
	if #list >= 4 then
		bringPos = Vector3.new(PosMon.X, PosMon.Y + upY, PosMon.Z)
	end
	local targetCF = CFrame.new(bringPos)

	for _, it in ipairs(list) do
		local v, hum, pp = it.mob, it.hum, it.pp

		pp.CanCollide = true
		hum.WalkSpeed = 0
		hum.JumpPower = 0
		if hum:FindFirstChild("Animator") then
			hum.Animator:Destroy()
		end

		if speed <= 0 then
			pp.CFrame = targetCF
		else
			local dist = (pp.Position - bringPos).Magnitude
			local t = math.max(0.05, dist / speed)
			TS:Create(pp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = targetCF}):Play()
		end

		pp.AssemblyLinearVelocity = Vector3.zero
		pp.AssemblyAngularVelocity = Vector3.zero
	end
end
local replicated=game:GetService("ReplicatedStorage")
local CommF_=replicated:WaitForChild("Remotes"):WaitForChild("CommF_")
local function CF(...) return CommF_:InvokeServer(...) end

local function UnstoreCheapestFruit(maxPrice)
	maxPrice=tonumber(maxPrice) or 490000
	local fruits=CF("GetFruits")
	if typeof(fruits)~="table" then return false end
	local bestName,bestPrice=nil,math.huge
	for _,d in pairs(fruits) do
		local name=d and d.Name
		local price=tonumber(d and d.Price) or math.huge
		if name and price<=maxPrice and price<bestPrice then
			bestName,bestPrice=name,price
		end
	end
	if bestName then
		CF("LoadFruit",tostring(bestName))
		return true,bestName,bestPrice
	end
	return false
end

local _fruitQuestCd=0
local function RunValentineFruitQuest(maxPrice)
	local now=os.clock()
	if now-_fruitQuestCd<3 then return false,"cd" end
	_fruitQuestCd=now

	local cur=CF("ValentineCurrentQuest")
	local ok,name,price=UnstoreCheapestFruit(maxPrice or 490000)
	local bring=CF("ValentinesBringFruitQuest")

	return true,cur,ok,name,price,bring
end

local plr = plr or game:GetService("Players").LocalPlayer

_G.PickToolType = _G.PickToolType or ""
_G.SelectWeapon = _G.SelectWeapon or ""

local function statVal(x)
	if not x then return 0 end
	if typeof(x)=="Instance" and x:IsA("ValueBase") then
		return tonumber(x.Value) or 0
	end
	return tonumber(x) or 0
end

local function FindStatFolder()
	local d = plr:FindFirstChild("Data")
	if not d then return nil end
	return d:FindFirstChild("Stats") or d:FindFirstChild("Stat") or d:FindFirstChild("Stars")
end

local function GetStat(sf, name)
	local v = sf and sf:FindFirstChild(name)
	return statVal(v)
end

local function BestTipByStats()
	local sf = FindStatFolder()
	if not sf then return "Melee" end

	local fruit = GetStat(sf,"Blox Fruit")
	if fruit == 0 then fruit = GetStat(sf,"Demon Fruit") end

	local melee = GetStat(sf,"Melee")
	local sword = GetStat(sf,"Sword")
	local gun   = GetStat(sf,"Gun")

	if melee >= sword and melee >= fruit and melee >= gun then return "Melee" end
	if sword >= fruit and sword >= gun then return "Sword" end
	if gun >= fruit then return "Gun" end
	return "Blox Fruit"
end

local function PickToolByTip(tip)
	local bp = plr:FindFirstChildOfClass("Backpack")
	local ch = plr.Character
	if not bp and not ch then return end

	local function scan(container)
		if not container then return nil end
		for _,v in ipairs(container:GetChildren()) do
			if v:IsA("Tool") and v.ToolTip == tip then
				_G.SelectWeapon = v.Name
				return v
			end
		end
	end

	return scan(ch) or scan(bp)
end

task.spawn(function()
	while task.wait(0.5) do
		pcall(function()
			_G.PickToolType = BestTipByStats()
			PickToolByTip(_G.PickToolType)
		end)
	end
end)

_G.HeartBoss=_G.HeartBoss or false

local function AliveBoss(b,enemies)
	return b and b.Parent==enemies
		and b:FindFirstChild("HumanoidRootPart")
		and b:FindFirstChild("Humanoid")
		and b.Humanoid.Health>0
end

local function HRP()
	local c=game.Players.LocalPlayer.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function DistTo(cf)
	local hrp=HRP()
	if not hrp then return math.huge end
	return (hrp.Position - cf.Position).Magnitude
end

local function WaitArrive(cf,needDist,timeout)
	needDist=needDist or 250
	timeout=timeout or t
	local t0=tick()
	while _G.HeartBoss do
		if DistTo(cf)<=needDist then return true end
		if tick()-t0>=timeout then return false end
		task.wait(0.1)
	end
	return false
end

spawn(function()
	while task.wait() do
		if not _G.SailBoats then continue end
		pcall(function()
			local myBoat = CheckBoat()
			local danger = (CheckShark() and _G.Shark)
				or (CheckTerrorShark() and _G.TerrorShark)
				or (CheckFishCrew() and _G.MobCrew)
				or (CheckPiranha() and _G.Piranha)
				or (CheckEnemiesBoat() and _G.FishBoat)
				or (CheckSeaBeast() and _G.SeaBeast1)
				or (_G.PGB and CheckPirateGrandBrigade())
				or (_G.HCM and CheckHauntedCrew())
				or (_G.Leviathan1 and CheckLeviathan())

			if not myBoat and not danger then
				local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
				TeleportToTarget(buyBoatCFrame)
				local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp and (buyBoatCFrame.Position - hrp.Position).Magnitude <= 10 then
					replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
				end
			elseif myBoat and not danger then
				local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
				local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if not (hum and hrp) then return end

				if hum.Sit == false then
					_tp(myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
				else
					local z = _G.DangerSc
					local CFrameSelectedZone =
						(z == "Lv 1" and CFrame.new(-21998.375, 30.0006084, -682.309143)) or
						(z == "Lv 2" and CFrame.new(-26779.5215, 30.0005474, -822.858032)) or
						(z == "Lv 3" and CFrame.new(-31171.957, 30.0001011, -2256.93774)) or
						(z == "Lv 4" and CFrame.new(-34054.6875, 30.2187767, -2560.12012)) or
						(z == "Lv 5" and CFrame.new(-38887.5547, 30.0004578, -2162.99023)) or
						(z == "Lv 6" and CFrame.new(-44541.7617, 30.0003204, -1244.8584)) or
						(z == "Lv Infinite" and CFrame.new(-10000000, 31, 37016.25)) or
						CFrame.new(-21998.375, 30.0006084, -682.309143)

					repeat
						task.wait()
						if (not _G.FishBoat and CheckEnemiesBoat()) or (not _G.PGB and CheckPirateGrandBrigade()) or (not _G.TerrorShark and CheckTerrorShark()) then
							_tp(CFrameSelectedZone * CFrame.new(0, 150, 0))
						else
							_tp(CFrameSelectedZone)
						end
						hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
					until not _G.SailBoats
						or ((CheckShark() and _G.Shark) or (CheckTerrorShark() and _G.TerrorShark) or (CheckFishCrew() and _G.MobCrew) or (CheckPiranha() and _G.Piranha))
						or (CheckSeaBeast() and _G.SeaBeast1)
						or (CheckEnemiesBoat() and _G.FishBoat)
						or (_G.Leviathan1 and CheckLeviathan())
						or (_G.HCM and CheckHauntedCrew())
						or (_G.PGB and CheckPirateGrandBrigade())
						or (hum and hum.Sit == false)

					if hum then hum.Sit = false end
				end
			end
		end)
	end
end)

spawn(function()
	while task.wait(Sec) do
		pcall(function()
			local on = (_G.SailBoats or _G.Prehis_Find or _G.FindMirage or _G.SailBoat_Hydra or _G.AutofindKitIs)
			for _, boat in ipairs(workspace.Boats:GetChildren()) do
				for _, d in ipairs(boat:GetDescendants()) do
					if d:IsA("BasePart") then d.CanCollide = not on end
				end
			end
		end)
	end
end)

local function FarmBossEvent()
	if not _G.HeartBoss then return end

	local sea=(World3 and "Sea3") or (World2 and "Sea2") or "Sea1"
	local list=({
		Sea3={
			["Beautiful Pirate"]=CFrame.new(5368.95459,18.7312012,-215.565369,-1,0,0,0,1,0,0,0,-1),
			["Hydra Leader"]=CFrame.new(5863.11475,1015.27264,-101.904381,-0.544665575,0,0.838653445,0,1,0,-0.838653445,0,-0.544665575),
			["Captain Elephant"]=CFrame.new(-13226.5586,319.618652,-8522.31934,-3.23057175e-05,-0.707060337,0.707153201,-1,3.23057175e-05,-1.33812428e-05,-1.33812428e-05,-0.707153201,-0.707060337),
			["Cake Queen"]=CFrame.new(-678.648804,381.353943,-11114.2012,-0.908641815,0.00149294338,0.41757378,0.00837114919,0.999857843,0.0146408929,-0.417492568,0.0167988986,-0.90852499),
			["Longma"]=CFrame.new(-10238.875976563,389.7912902832,-9549.7939453125)
		},
		Sea2={
			["Orbitus"]=CFrame.new(-2046.20801,67.8339996,-4244.25195,-0.788017035,0,-0.615653694,0,1,0,0.615653694,0,-0.788017035),
			["Diamond"]=CFrame.new(-1774.07837,193.830765,-65.1594696,6.55651093e-06,0.173615217,0.984813571,-1,6.55651093e-06,5.48362732e-06,-5.48362732e-06,-0.984813571,0.173615217),
			["Jeremy"]=CFrame.new(2338.50439,445.128601,760.178589,-0.707134247,0,0.707079291,0,1,0,-0.707079291,0,-0.707134247),
			["Don Swan"]=CFrame.new(2286.2004394531,15.177839279175,863.8388671875),
			["Smoke Admiral"]=CFrame.new(-5275.1987304688,20.757257461548,-5260.6669921875),
			["Awakened Ice Admiral"]=CFrame.new(6403.5439453125,340.29766845703,-6894.5595703125),
			["Tide Keeper"]=CFrame.new(-3795.6423339844,105.88877105713,-11421.307617188)
		},
		Sea1={
			["Thunder God"]=CFrame.new(-7811.88721,5602.6001,-2417.37695,-0.484826207,0,0.874610603,0,1,0,-0.874610603,0,-0.484826207),
			["Wysper"]=CFrame.new(-7896.33691,5543.12793,-617.458984,-0.999848008,0.017434394,-0.000263410155,0.017434394,0.999391556,-0.0302081089,-0.000263410155,-0.0302081089,-0.999543548),
			["The Gorilla King"]=CFrame.new(-1121.46399,38.4680023,-438.395996,-0.824771285,-0.0706752539,0.561032414,-0.0858078003,0.996311486,-0.000636750832,-0.558917999,-0.0486661345,-0.827793598),
			["Bobby"]=CFrame.new(-1087.3760986328,46.949409484863,4040.1462402344),
			["The Saw"]=CFrame.new(-784.89715576172,72.427383422852,1603.5822753906),
			["Yeti"]=CFrame.new(1218.7956542969,138.01184082031,-1488.0262451172),
			["Mob Leader"]=CFrame.new(-2844.7307128906,7.4180502891541,5356.6723632813),
			["Vice Admiral"]=CFrame.new(-5006.5454101563,88.032081604004,4353.162109375),
			["Saber Expert"]=CFrame.new(-1458.89502,29.8870335,-50.633564),
			["Warden"]=CFrame.new(5278.04932,2.15167475,944.101929,0.220546961,-4.49946401e-06,0.975376427,-1.95412576e-05,1,9.03162072e-06,-0.975376427,-2.10519756e-05,0.220546961),
		}
	})[sea]
	if not list then return end

	local enemies=workspace:FindFirstChild("Enemies")
	if not enemies then return end

	local function HRP()
		local c=plr and plr.Character
		return c and c:FindFirstChild("HumanoidRootPart")
	end

	local function GetAliveBoss()
		for n,_ in pairs(list) do
			local b=enemies:FindFirstChild(n)
			if AliveBoss(b,enemies) then return b,n end
		end
	end

	local function DoKill(b)
		local k=Attack and (Attack.Kill or Attack.kill)
		if k then pcall(function() k(b,true) end) end
	end

	local function KillLoop(name)
		local miss=0
		while _G.HeartBoss do
			local b=enemies:FindFirstChild(name)
			if not AliveBoss(b,enemies) then
				miss+=1
				if miss>=10 then break end
				task.wait(0.08)
			else
				miss=0
				DoKill(b)
				task.wait(0.08)
			end
		end
	end

	while _G.HeartBoss do
		local b,n=GetAliveBoss()
		if b then
			KillLoop(n)
		else
			for name,cf in pairs(list) do
				if not _G.HeartBoss then return end

				pcall(function() _tp(cf,true) end)

				local t0=tick()
				while _G.HeartBoss do
					local bb,nn=GetAliveBoss()
					if bb then
						pcall(function() if _tpTween then _tpTween:Cancel() end end)
						KillLoop(nn)
						break
					end

					local hrp=HRP()
					if hrp then
						if (hrp.Position - cf.Position).Magnitude<=250 then
							local here=enemies:FindFirstChild(name)
							if AliveBoss(here,enemies) then KillLoop(name) end
							break
						end
					end

					if tick()-t0>7.5 then break end
					task.wait(0.12)
				end
			end
		end
		task.wait(0.05)
	end
end

spawn(function()
	while task.wait() do
		if not _G.SailBoats then continue end
		pcall(function()
			local myBoat = CheckBoat()
			local danger = (CheckShark() and _G.Shark)
				or (CheckTerrorShark() and _G.TerrorShark)
				or (CheckFishCrew() and _G.MobCrew)
				or (CheckPiranha() and _G.Piranha)
				or (CheckEnemiesBoat() and _G.FishBoat)
				or (CheckSeaBeast() and _G.SeaBeast1)
				or (_G.PGB and CheckPirateGrandBrigade())
				or (_G.HCM and CheckHauntedCrew())

			if not myBoat and not danger then
				local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
				TeleportToTarget(buyBoatCFrame)
				local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp and (buyBoatCFrame.Position - hrp.Position).Magnitude <= 10 then
					replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
				end
			elseif myBoat and not danger then
				local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
				local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if not (hum and hrp) then return end

				if hum.Sit == false then
					_tp(myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
				else
					local z = _G.DangerSc
					local CFrameSelectedZone =
						(z == "Lv 1" and CFrame.new(-21998.375, 30.0006084, -682.309143)) or
						(z == "Lv 2" and CFrame.new(-26779.5215, 30.0005474, -822.858032)) or
						(z == "Lv 3" and CFrame.new(-31171.957, 30.0001011, -2256.93774)) or
						(z == "Lv 4" and CFrame.new(-34054.6875, 30.2187767, -2560.12012)) or
						(z == "Lv 5" and CFrame.new(-38887.5547, 30.0004578, -2162.99023)) or
						(z == "Lv 6" and CFrame.new(-44541.7617, 30.0003204, -1244.8584)) or
						(z == "Lv Infinite" and CFrame.new(-10000000, 31, 37016.25)) or
						CFrame.new(-21998.375, 30.0006084, -682.309143)

					repeat
						task.wait()
						if (not _G.FishBoat and CheckEnemiesBoat()) or (not _G.PGB and CheckPirateGrandBrigade()) or (not _G.TerrorShark and CheckTerrorShark()) then
							_tp(CFrameSelectedZone * CFrame.new(0, 150, 0))
						else
							_tp(CFrameSelectedZone)
						end
						hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
					until not _G.SailBoats
						or ((CheckShark() and _G.Shark) or (CheckTerrorShark() and _G.TerrorShark) or (CheckFishCrew() and _G.MobCrew) or (CheckPiranha() and _G.Piranha))
						or (CheckSeaBeast() and _G.SeaBeast1)
						or (CheckEnemiesBoat() and _G.FishBoat)
						or (_G.Leviathan1 and CheckLeviathan())
						or (_G.HCM and CheckHauntedCrew())
						or (_G.PGB and CheckPirateGrandBrigade())
						or (hum and hum.Sit == false)

					if hum then hum.Sit = false end
				end
			end
		end)
	end
end)

spawn(function()
	while task.wait(Sec) do
		pcall(function()
			local on = (_G.SailBoats or _G.Prehis_Find or _G.FindMirage or _G.SailBoat_Hydra or _G.AutofindKitIs)
			for _, boat in ipairs(workspace.Boats:GetChildren()) do
				for _, d in ipairs(boat:GetDescendants()) do
					if d:IsA("BasePart") then d.CanCollide = not on end
				end
			end
		end)
	end
end)
spawn(function()
    while wait() do
        pcall(function()
            for i, boat in pairs(game:GetService("Workspace").Boats:GetChildren()) do
                for _, v in pairs(boat:GetDescendants()) do
                    if v:IsA("BasePart") then
                        if getgenv().NoClipShip or getgenv().FindPrehistoric then
                            v.CanCollide = false
                        else
                            v.CanCollide = true
                        end
                    end
                end
            end
        end)
    end
end)
getgenv().NoClipShip = true

_G.DangerSc = "Lv Infinite"

spawn(function()
  while wait() do
    pcall(function()	
      if _G.Shark then local a={"Shark"}if CheckShark()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.Shark)until _G.Shark==false or not c.Parent or c.Humanoid.Health<=0 end end end end end
      if _G.TerrorShark then local a={"Terrorshark"}if CheckTerrorShark()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.KillSea(c,_G.TerrorShark)until _G.TerrorShark==false or not c.Parent or c.Humanoid.Health<=0 end end end end end
      if _G.Piranha then local a={"Piranha"}if CheckPiranha()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.Piranha)until _G.Piranha==false or not c.Parent or c.Humanoid.Health<=0 end end end end end
      if _G.MobCrew then local a={"Fish Crew Member"}if CheckFishCrew()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.MobCrew)until _G.MobCrew==false or not c.Parent or c.Humanoid.Health<=0 end end end end end                 
      if _G.HCM then local a={"Haunted Crew Member"}if CheckHauntedCrew()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.HCM)until _G.HCM==false or not c.Parent or c.Humanoid.Health<=0 end end end end end
      if _G.SeaBeast1 then if workspace.SeaBeasts:FindFirstChild("SeaBeast1")then for a,b in pairs(workspace.SeaBeasts:GetChildren())do if b:FindFirstChild("HumanoidRootPart")and b:FindFirstChild("Health")and b.Health.Value>0 then repeat task.wait()spawn(function()_tp(CFrame.new(b.HumanoidRootPart.Position.X,game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y+200,b.HumanoidRootPart.Position.Z))end)if plr:DistanceFromCharacter(b.HumanoidRootPart.CFrame.Position)<=500 then AitSeaSkill_Custom=b.HumanoidRootPart.CFrame;MousePos=AitSeaSkill_Custom.Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.SeaBeast1==false or not b:FindFirstChild("HumanoidRootPart")or not b.Parent or b.Health.Value<=0 end end end end
      if _G.FishBoat then if CheckEnemiesBoat()then for a,b in pairs(workspace.Enemies:GetChildren())do if b:FindFirstChild("Health")and b.Health.Value>0 and b:FindFirstChild("VehicleSeat")then repeat task.wait()spawn(function()if b.Name=="FishBoat"then _tp(b.Engine.CFrame*CFrame.new(0,-50,-25))end end)if plr:DistanceFromCharacter(b.Engine.CFrame.Position)<=150 then AitSeaSkill_Custom=b.Engine.CFrame;MousePos=AitSeaSkill_Custom.Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.FishBoat==false or not b:FindFirstChild("VehicleSeat")or b.Health.Value<=0 end end end end
      if _G.PGB then if CheckPirateGrandBrigade()then for a,b in pairs(workspace.Enemies:GetChildren())do if b:FindFirstChild("Health")and b.Health.Value>0 and b:FindFirstChild("VehicleSeat")then repeat task.wait()spawn(function()if b.Name=="PirateBrigade"then _tp(b.Engine.CFrame*CFrame.new(0,-30,-10))elseif b.Name=="PirateGrandBrigade"then _tp(b.Engine.CFrame*CFrame.new(0,-50,-50))end end)if plr:DistanceFromCharacter(b.Engine.CFrame.Position)<=150 then AitSeaSkill_Custom=b.Engine.CFrame;MousePos=AitSeaSkill_Custom.Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.PGB==false or not b:FindFirstChild("VehicleSeat")or b.Health.Value<=0 end end end end
    end)
  end
end)

spawn(function()
	while task.wait() do
		pcall(function()
			if not _G.AutoFarmNear then return end
			local E=workspace:FindFirstChild("Enemies"); if not E then return end

			while _G.AutoFarmNear do
				local best,bestHp=nil,math.huge
				for _,v in pairs(E:GetChildren()) do
					local h=v and v:FindFirstChildOfClass("Humanoid")
					local r=v and v:FindFirstChild("HumanoidRootPart")
					if h and r and h.Health>0 and v.Parent then
						local hp=h.Health
						if hp<bestHp then best,bestHp=v,hp end
					end
				end

				if not best then break end

				repeat task.wait()
					Attack.Kill(best,_G.AutoFarmNear)
				until not _G.AutoFarmNear or not best.Parent or not best:FindFirstChildOfClass("Humanoid") or best:FindFirstChildOfClass("Humanoid").Health<=0
			end
		end)
	end
end)

local lastMode = "none"
local fishDone = false

local function RunFishQuest()
	pcall(function()
		if LoadRandomFishUID then LoadRandomFishUID() end
	end)

	pcall(function()
		RS:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("ValentineCurrentQuest")
	end)

	task.wait(0.2)

	pcall(function()
		RS:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("ValentinesBringFishQuest")
	end)
end

_G.AutoFarmHeart = true
local Players=game:GetService("Players")
local plr=Players.LocalPlayer
local RS=game:GetService("ReplicatedStorage")

local function SeaName()
	if World3 then return "Sea3" end
	if World2 then return "Sea2" end
	return "Sea1"
end

local function ValentineCF()
	local sea=SeaName()
	if sea=="Sea3" then
		return CFrame.new(-13240.1836,422.515869,-7760.69043,0.087131381,0,-0.996196866,0,1,0,0.996196866,0,0.087131381)
	elseif sea=="Sea2" then
		return CFrame.new(964.492126,115.863968,1302.74329,0,0,-1,1,0,0,0,-1,0)
	else
		return CFrame.new(1037.18298,67.3220062,1594.93103,0.275584042,0,0.961277127,0,1,0,-0.961277127,0,0.275584042)
	end
end

local function norm(s)
	s=tostring(s or ""):lower()
	s=s:gsub("[%z\1-\31]"," ")
	s=s:gsub("[%c]"," ")
	s=s:gsub("[^%w%s]"," ")
	s=s:gsub("%s+"," ")
	return s
end

local function HRP()
	local c=plr.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function SeaName()
	if World3 then return "Sea3" end
	if World2 then return "Sea2" end
	return "Sea1"
end

local function StartValentineQuest()
	return RS:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("StartNextValentineQuest",SeaName())
end

local function QuestTitleText()
	local ok,res=pcall(function()
		local q=plr.PlayerGui.Main.Quest
		local c=q:FindFirstChild("Container")
		local qt=(c and c:FindFirstChild("QuestTitle")) or q:FindFirstChild("QuestTitle")
		if qt then
			if qt:IsA("TextLabel") or qt:IsA("TextBox") then
				local t=tostring(qt.Text); if t~="" then return t end
			end
			for _,d in ipairs(qt:GetDescendants()) do
				if d:IsA("TextLabel") or d:IsA("TextBox") then
					local t=tostring(d.Text); if t~="" then return t end
				end
			end
		end
		for _,d in ipairs(q:GetDescendants()) do
			if d:IsA("TextLabel") or d:IsA("TextBox") then
				local t=tostring(d.Text)
				local s=norm(t)
				if t~="" and (s:find("defeat",1,true) or s:find("boss",1,true)) then
					return t
				end
			end
		end
		return ""
	end)
	return ok and res or ""
end

local function HasQuest()
	local ok,res=pcall(function()
		local main=plr.PlayerGui:FindFirstChild("Main")
		if not main then return false end
		if main:IsA("ScreenGui") and main.Enabled==false then return false end
		local q=main:FindFirstChild("Quest")
		if not q or q.Visible==false then return false end
		local c=q:FindFirstChild("Container")
		if c and c.Visible==false then return false end
		local t=QuestTitleText()
		return t and t:gsub("%s+","")~=""
	end)
	return ok and res or false
end

local function QuestMode()
	local t=QuestTitleText()
	local s=norm(t)
	if s=="" then return "none",t end

	if s:find("fruit",1,true) or s:find("fruits",1,true) or s:find("blox fruit",1,true) or s:find("devil fruit",1,true) or s:find("collect",1,true) or s:find("pickup",1,true) or s:find("pick up",1,true) then
		return "fruit",t
	end

	if s:find("fish",1,true) or s:find("catch",1,true) then return "fish",t end

	if s:find("sea",1,true) or s:find("seabeast",1,true) or s:find("terror",1,true) or s:find("shark",1,true) or s:find("piranha",1,true) then
		return "sea",t
	end

	if s:find("boss",1,true) then return "boss",t end
	if s:find("defeat",1,true) and (s:find("enem",1,true) or s:find("enemy",1,true) or s:find("enemies",1,true)) then
		return "mob",t
	end

	return "unknown",t
end

task.spawn(function()
	local lastAct=0
	local miss=0
	local bossRun=false

	while task.wait(0.2) do
		if not _G.AutoFarmHeart then
			miss=0
			bossRun=false
			_G.AutoFarmNear=false
			_G.HeartBoss=false
			shouldTween=false
		else
			local has=HasQuest()
			if not has then miss+=1 else miss=0 end

			if miss>=5 then
				bossRun=false
				_G.AutoFarmNear=false
				_G.HeartBoss=false

				if tick()-lastAct>1 then
					lastAct=tick()
					shouldTween=true
					_tp(ValentineCF())
					StartValentineQuest()
					shouldTween=false
				end
			else
				local mode=QuestMode()
				shouldTween=false

				if mode=="boss" then
					_G.AutoFarmNear=false
					_G.HeartBoss=true

					if not bossRun then
						bossRun=true
						task.spawn(function()
							pcall(FarmBossEvent)
							bossRun=false
						end)
					end

				elseif mode=="mob" then
					bossRun=false
					_G.HeartBoss=false
					_G.AutoFarmNear=true

				elseif mode=="sea" then
					bossRun=false
					_G.HeartBoss=false
					_G.AutoFarmNear=false
					_G.SeaBeast1=true; _G.TerrorShark=true; _G.Shark=true; _G.Piranha=true; _G.SailBoats=true

elseif mode=="fish" then
	_G.AutoFarmNear=false
	_G.HeartBoss=false
	if not fishRun then
		fishRun=true
		task.spawn(function()
			RunFishQuest()
			fishRun=false
		end)
	end

elseif mode=="fruit" then
	_G.AutoFarmNear=false
	_G.HeartBoss=false
	if not fruitRun then
		fruitRun=true
		task.spawn(function()
			RunValentineFruitQuest(490000)
			fruitRun=false
		end)
	end

				else
					bossRun=false
					_G.AutoFarmNear=false
					_G.HeartBoss=false
				end
			end
		end
	end
end)