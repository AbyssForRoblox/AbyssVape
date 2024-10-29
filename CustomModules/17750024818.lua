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
   vape/CustomModules/17750024818.lua by abyss 100%!                          `---`    `----'                  
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

local function WarningNotification(title, text, delay)
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
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
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

local function runFunction(func)
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

--

runFunction(function()
    local tydai = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.Api.CreateOptionsButton({
        Name = "LootExploit",
        Function = function(callback)
            if callback then
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local GiveTagRemote = ReplicatedStorage.Remotes.GiveTag

                task.spawn(function()
                    repeat
                        for _, player in pairs(game.Players:GetPlayers()) do
                            if player.Character then
                                GiveTagRemote:FireServer(player.Character, "Sword")
                            end
                            task.wait(0.01)
                        end
                    until not callback
                end)
            end
        end
    })
end)


runFunction(function()
	local Nuker = {Enabled = false}
	Nuker = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = 'Nuker',
		HoverText = 'Breaks beds when you get close to them (breaks your own too...)',
		Function = function(callback)
			if callback then
				game:GetService("RunService").RenderStepped:Connect(function()
					local Nigger, blak
					for ii,vv in pairs(game.workspace.Map.Beds:GetChildren()) do
						if not vv then return end
						if IgnoreTeamBed and vv:GetAttribute('TeamName') == game.Players.LocalPlayer.Team then return end
						if (game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position - vv:WaitForChild('Hitbox').Position).Magnitude < 30 then
							blak = vv
						else continue
						end
				
						if blak then
							game:GetService("ReplicatedStorage").Remotes.DamageBlock:InvokeServer(blak, game.Players.LocalPlayer.HotbarFolder["2"]:GetAttribute('ItemName'))
						end
					end
				end)
			end
		end
	})
end)

runFunction(function()
	local AdminsFolder = game.ReplicatedStorage.Admins
	local StaffDetector = {Enabled = false}
	StaffDetector = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = 'StaffDetector',
		Function = function(callback)
			if callback then
				repeat
					task.wait()
					for _, v in ipairs(AdminsFolder:GetChildren()) do
						for i, vv in ipairs(game.Players:GetPlayers()) do
							if v.Name == vv.Name then
								warningNotification('Staff Detector', 'Staff Detected '.. vv.Name, 10)
								StaffDetector.ToggleButton(false)
							end
						end
					end 
				until not StaffDetector.Enabled
			end
		end
	})
end)


runFunction(function()
	local Killaura = {Enabled = false}
	local moose = game.Players.LocalPlayer:GetMouse()
	
	Killaura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "TPAura", 
		HoverText = "Good",
		Function = function(callback)
			if callback then
				game:GetService('RunService').RenderStepped:Connect(function()
					task.wait(0.1)
					local blackNigger, WhiteNigger
					for _,v in pairs(game.Players:GetPlayers()) do
						if v.Name == game.Players.LocalPlayer.Name then continue end
						if v.Character:WaitForChild('Humanoid').Health < 0 then continue end
						if v then
							local chary = v.Character
							local Dist = v:DistanceFromCharacter(game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position)
							if not chary or Dist > KillauraRange.Value or (WhiteNigger and Dist >= WhiteNigger) then
								continue
							end
							
							blackNigger = v
							WhiteNigger = Dist
						end
					end
					if blackNigger and blackNigger.Character:WaitForChild('Humanoid').Health > 0 then
						game:GetService("ReplicatedStorage").Remotes.ItemRemotes.SwordAttack:FireServer(blackNigger.Character.PrimaryPart, blackNigger.Character.Humanoid.MoveDirection + Vector3.new(0,0.5,0), game.Players.LocalPlayer.HotbarFolder['1']:GetAttribute('ItemName')) -- Predicktion :)
					end
				end)
			end
		end
	})

	KillauraRange = Killaura.CreateSlider({
		Name = 'Range',
		Min = 30,
		Max = 100,
		Function = function(val) end,
		Default = 30
	})
end)

runFunction(function()
	local BedTp = {Enabled = false}
	BedTp = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = 'BedTP',
		Function = function(callback)
			if callback then
				for iii, vvv in pairs(game.workspace.Map.Beds:GetDescendants()) do
					game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame = vvv.Hitbox.CFrame
				end
				if BedTp.Enabled then
					BedTp.ToggleButton(false)
				end
			end
		end
	})
end)

runFunction(function()
	local PlayerTp = {Enabled = false}
	PlayerTp = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = 'PlayerTP',
		Function = function(callback)
			if callback then
				for iiii,vvvv in pairs(game.Players:GetPlayers()) do
					if vvvv.Team == "Spectator" then continue end
					game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = game.Players[vvvv.Name].Character.HumanoidRootPart.CFrame
				end
				if PlayerTp.Enabled then
					PlayerTp.ToggleButton(false)
				end
			end
		end
	})
end)


