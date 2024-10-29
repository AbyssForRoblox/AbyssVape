-- Credits to Inf Yield & all the other scripts that helped me make bypasses
--[[                                                             
                                                              
   ,---,           ,---,.               .--.--.    .--.--.    
  '  .' \        ,'  .'  \       ,---, /  /    '. /  /    '.  
 /  ;    '.    ,---.' .' |      /_ ./||  :  /`. /|  :  /`. /  
:  :       \   |   |  |: |,---, |  ' :;  |  |--` ;  |  |--`   
:  |   /\   \  :   :  :  /___/ \.  : ||  :  ;_   |  :  ;_     
|  :  ' ;.   : :   |    ; .  \  \ ,' ' \  \    `. \  \    `.  
|  |  ;/  \   \|   :     \ \  ;  `  ,'  `----.   \ `----.   \ 
'  :  | \  \ ,'|   |   . |  \  \    '   __ \  \  | __ \  \  | 
|  |  '  '--'  '   :  '; |   '  \   |  /  /`--'  //  /`--'  / 
|  :  :        |   |  | ;     \  ;  ; '--'.     /'--'.     /  
|  | ,'        |   :   /       :  \  \  `--'---'   `--'---'   
`--''          |   | ,'         \  ' ;                        
               `----'            `--`                         
                           ,-.----.                           
               ,---,       \    /  \      ,---,.              
       ,---.  '  .' \      |   :    \   ,'  .' |              
      /__./| /  ;    '.    |   |  .\ :,---.'   |              
 ,---.;  ; |:  :       \   .   :  |: ||   |   .'              
/___/ \  | |:  |   /\   \  |   |   \ ::   :  |-,              
\   ;  \ ' ||  :  ' ;.   : |   : .   /:   |  ;/|              
 \   \  \: ||  |  ;/  \   \;   | |`-' |   :   .'              
  ;   \  ' .'  :  | \  \ ,'|   | ;    |   |  |-,              
   \   \   '|  |  '  '--'  :   ' |    '   :  ;/|              
    \   `  ;|  :  :        :   : :    |   |    \              
     :   \ ||  | ,'        |   | :    |   :   .'              
      '---" `--''          `---'.|    |   | ,'                
   vape/CustomModules/893973440.lua by abyss 100%!                          `---`    `----'                  
 --]]                                                             
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local repstorage = game:GetService("ReplicatedStorage")
local localmouse = lplr:GetMouse()
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset

local RenderStepTable = {}
local StepTable = {}

local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function BindToStepped(name, num, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end
local function UnbindFromStepped(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end

local function warningNotification(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)]
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function getcustomassetfunc(path)
	if not isfile(path) then
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat wait() until isfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/qwertyui-is-back/UpdatedV4ForBW/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr.Team ~= lplr.Team or (lplr.Team == nil or #lplr.Team:GetPlayers() == #game:GetService("Players"):GetChildren())) or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend and friendCheck(plr) == nil or (not friend)) and isAlive(plr) and targetCheck(plr, target) and shared.vapeteamcheck(plr)
end

local function vischeck(char, part)
	return not unpack(cam:GetPartsObscuringTarget({lplr.Character[part].Position, char[part].Position}, {lplr.Character, char}))
end

local function runcode(func)
	func()
end

local function GetAllNearestHumanoidToPosition(player, distance, amount)
	local returnedplayer = {}
	local currentamount = 0
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= distance then
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance)
	local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= closest then
                    closest = mag
                    returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToMouse(player, distance, checkvis)
    local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and (checkvis == false or checkvis and (vischeck(v.Character, "Head") or vischeck(v.Character, "HumanoidRootPart"))) then
                local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
                    if mag <= closest then
                        closest = mag
                        returnedplayer = v
                    end
                end
            end
        end
    end
    return returnedplayer
end

local function CalculateObjectPosition(pos)
	local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
	return Vector2.new(newpos.X, newpos.Y)
end

local function CalculateLine(startVector, endVector, obj)
	local Distance = (startVector - endVector).Magnitude
	obj.Size = UDim2.new(0, Distance, 0, 2)
	obj.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
	obj.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
end

local function findTouchInterest(tool)
	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			return v
		end
	end
	return nil
end

local store = {
    beast = nil,
    map = "nil"
}

local run = runcode

task.spawn(function()
    local teams = game:GetService("Teams")
    if not teams:FindFirstChild("Survivors") then
        local Survivors = Instance.new("Team", teams)
        Survivors.Name = "Survivors"
        Survivors.TeamColor = BrickColor.new("Bright blue")
        Survivors.AutoAssignable = true
    end
    if not teams:FindFirstChild("Beast") then
        local Beast = Instance.new("Team", teams)
        Beast.Name = "Beast"
        Beast.TeamColor = BrickColor.new("Bright red")
        Beast.AutoAssignable = true
    end
    local survivor = teams.Survivors
    local beast = teams.Beast
    players.PlayerAdded:Connect(function(p)
        p.Team = survivor
    end)
    BindToStepped("Update",1,function()
        if not shared.VapeExecuted then
            UnbindFromStepped("Update")
        end
        for i,v in players:GetPlayers() do
            if v.Character == nil then return end
            pcall(function()
                if v.Character:FindFirstChild("BeastPowers") == nil then
                    v.Team = survivor
                else
                    v.Team = beast
                    store.beast = v
                    if v.Name ~= lplr.Name then
                        if v.Character:FindFirstChild("WarningNotifDetector") == nil then
                            local p = Instance.new("Part", v.Character)
                            p.Name = "WarningNotifDetector"
                            warningNotification("Vape", v.Name.." is the beast!",10)
                        end
                    end
                end
            end)
        end
        store.map = tostring(repstorage.CurrentMap.Value)
    end)
end)

run(function()
    local ZoomUnlocker = {Enabled = false}

    ZoomUnlocker = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
        Name = "ZoomUnlocker",
        Function = function(callback)
            if callback then
                BindToStepped("zu",1,function()
                    lplr.CameraMaxZoomDistance = 10
                end)
            else
                UnbindFromStepped("zu")
            end
        end
    })
end)

run(function()
    local AutoHack = {Enabled = false}

    AutoHack = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "AutoMinigame",
        HoverText = "Automatically completes the Hacking Minigame",
        Function = function(callback)
            if callback then
                BindToStepped("ah",1,function()
                    repstorage.RemoteEvent:FireServer("SetPlayerMinigameResult",true)
                end)
            else
                UnbindFromStepped("ah")
            end
        end
    })
end)

run(function()
    local AutoInteract = {Enabled = false}

    AutoInteract = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "AutoInteract",
        HoverText = "Automatically interact with anything",
        Function = function(callback)
            if callback then
                BindToStepped("ai",1,function()
                    repstorage.RemoteEvent:FireServer("Input", "Action", true)
                end)
            else
                UnbindFromStepped("ai")
            end
        end
    })
end)

run(function()
    local NoSlowdown = {Enabled = false}

    NoSlowdown = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
        Name = "NoSlowdown",
        Function = function(callback)
            if callback then
                BindToStepped("nh",1,function()
                    pcall(function()
                        if lplr.Character.Humanoid.WalkSpeed < 16 then
                            lplr.Character.Humanoid.WalkSpeed = 16
                        end
                    end)
                end)
            else
                UnbindFromStepped("nh")
            end
        end
    })
end)

run(function()
    local BeastNotifier = {Enabled = false}
    local Range = {Value = 25}
    local hasNotified = tick()

    BeastNotifier = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "BeastNotifier",
        Function = function()
            if callback then
                BindToStepped("bn",1,function()
                    --pcall(function()
                        local mag = (store.beast.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).magnitude
                        if mag <= Range.Value then
                            if math.floor(tick() - hasNotified) > 10 then
                                warningNotification("BeastNotified", "The beast is near you!", 10)
                                hasNotified = tick()
                            end
                        end
                    --end)
                end)
            else
                UnbindFromStepped("bn")
            end
        end
    })
    Range = BeastNotifier.CreateSlider({
        Name = "Range",
        Min = 5,
        Max = 30,
        Default = "25",
        Function = function(val) end
    })
end)

run(function()
	local ChamsFolder = Instance.new("Folder")
	ChamsFolder.Name = "ChamsPCFolder"
	ChamsFolder.Parent = GuiLibrary.MainGui
	local chamstable = {}
	local ChamsColor = {Value = 0.44}
	local ChamsOutlineColor = {Value = 0.44}
	local ChamsTransparency = {Value = 1}
	local ChamsOutlineTransparency = {Value = 1}
	local ChamsOnTop = {Enabled = true}
	local ChamsTeammates = {Enabled = true}

	local function addfunc(ent)
		local hl = Instance.new("Highlight")
		hl.Parent = ent
		hl.FillColor = BrickColor.new("Bright green")
		hl.OutlineColor = Color3.fromRGB(255,255,255)
		h1.FullTransparency = 0.4
	end

	local function removefunc(ent)
		ent.Highlight:Destroy()
	end

	local Chams = {Enabled = false}
	Chams = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ComputerESP",
		Function = function(callback)
			if callback then
                BindToStepped("ce",1,function()
                    pcall(function()
                        for i,v in pairs(workspace[store.map]:GetChildren()) do
                            if v.Name == "ComputerTable" then
                                if v:FindFirstChild("Highlight") == nil then
                                    addfunc(v)
                                end
                                v.Highlight.FillColor = v.Screen.Color
                            end
                        end
                    end)
                end)
			else
				UnbindFromStepped("ce")
			end
		end,
		HoverText = "Render computers through walls"
	})
end)

run(function()

	local function addfunc(ent)
		local hl = Instance.new("Highlight")
		hl.Parent = ent
		hl.FillColor = Color3.fromRGB(121,121,255)
		hl.OutlineColor = Color3.fromRGB(255,255,255)
		h1.FullTransparency = 0.4
	end

	local function removefunc(ent)
		ent.Highlight:Destroy()
	end

	local Chams = {Enabled = false}
	Chams = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "PodESP",
		Function = function(callback)
			if callback then
                BindToStepped("pe",1,function()
                    pcall(function()
                        for i,v in pairs(workspace[store.map]:GetChildren()) do
                            if v.Name == "FreezePod" then
                                if v:FindFirstChild("Highlight") == nil then
                                    addfunc(v)
                                end
                            end
                        end
                    end)
                end)
			else
				UnbindFromStepped("pe")
			end
		end,
		HoverText = "Render computers through walls"
	})
end)