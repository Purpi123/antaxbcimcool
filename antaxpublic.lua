local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local RigMode

if character:FindFirstChild("Humanoid") then
	local rigType = character.Humanoid.RigType
	if rigType == Enum.HumanoidRigType.R15 then
		RigMode = "R15"
	elseif rigType == Enum.HumanoidRigType.R6 then
		RigMode = "R6"
	else
		RigMode = "Unknown"
	end
else
	RigMode = "No Humanoid"
end

print("Rig Mode:", RigMode)





-- // Tables
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Purpi123/antaxbcimcool/refs/heads/main/source.lua"))() -- Could Also Save It In Your Workspace And Do loadfile("Library.lua")()
-- // Variables
-- // Init
local Window = Library:New({
	Name = "Antax Public - " .. RigMode,
	Accent = Color3.fromRGB(250, 250, 250)
})
--
local LocalPlayer = Window:Page({
	Name = "Local"
})

local PlayersTab = Window:Page({
	Name = "Players"
})

local Visuals = Window:Page({
	Name = "Visuals"
})


local MenuSettings = Window:Page({
	Name = "Antax"
})  -- New Page for Menu Settings
--
local Local_Walking, Local_Jumping, Local_Grav, Local_Health = LocalPlayer:MultiSection({
	Sections = {
		"Walking",
		"Jumping",
		"Gravity",
		"Health"
	},
	Side = "Left",
	Size = 170
})

local Box_ESP, Chams_ESP, Skeleton_ESP, Object_ESP, Name_ESP, Tracer_ESP = Visuals:MultiSection({
	Sections = {
		"Box",
		"Chams",
		"Skeleton",
		"Object",
		"Names",
		"Tracers"
	},
	Side = "Left",
	Size = 200
})




local Local_Body, Local_Movement, Local_Powers, Local_Events = LocalPlayer:MultiSection({
	Sections = {
		"Body",
		"Movement",
		"Powers",
		"Events"
	},
	Side = "Right",
	Size = 230
})

local Local_Game, Local_Network = LocalPlayer:MultiSection({
	Sections = {
		"Game",
		"Network"
	},
	Side = "Left",
	Size = 230
})










local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
local defaults = humanoid and humanoid.WalkSpeed or 16 -- Default walk speed if something goes wrong
local defaultp = humanoid and humanoid.JumpPower or 50 -- Default walk speed if something goes wrong





-- Skapa slider för att justera Walk Speed
Local_Walking:Slider({
	Name = "Walk Speed",
	Minimum = 1,
	Maximum = 300,
	Default = defaults,
	Decimals = 1,
	Pointer = "Local_Walking_WalkSpeed",
	Callback = function(value)
		player.Character.Humanoid.WalkSpeed = value
	end
})

Local_Walking:Button({
	Name = "Reset Walk Speed",
	Pointer = "ResetWalkSpeedButton",
	Callback = function()
		player.Character.Humanoid.WalkSpeed = defaults
	end
})



Local_Jumping:Slider({
	Name = "Jump Power",
	Minimum = 1,
	Maximum = 300,
	Default = defaultp,
	Decimals = 1,
	Pointer = "Local_Jumping_JumpPower",
	Callback = function(value)
		player.Character.Humanoid.JumpPower = value
	end
})

Local_Jumping:Button({
	Name = "Reset Jump Power",
	Pointer = "ResetJumpPowerButton",
	Callback = function()
		player.Character.Humanoid.JumpPower = defaultp
	end
})


Local_Jumping:Toggle({
	Name = "Infinite Jump",
	Default = false,
	Pointer = "InfJump_Toggle",
	Callback = function(state)
		if state == true then
            -- Infinite Jump Enable Script
			_G.InfiniteJumpEnabled = true

            -- Function to handle jumping
            local function onJumpRequest()
				if _G.InfiniteJumpEnabled then
					local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						humanoid:ChangeState("Jumping")
					end
				end
			end

            -- Bind the function to the JumpRequest event
			if not _G.JumpConnection then
				_G.JumpConnection = game:GetService("UserInputService").JumpRequest:Connect(onJumpRequest)
			end
			print("Infinite Jump Enabled")
		else
            -- Infinite Jump Disable Script
			_G.InfiniteJumpEnabled = false

            -- Unbind the JumpRequest event if it exists
			if _G.JumpConnection then
				_G.JumpConnection:Disconnect()
				_G.JumpConnection = nil
			end
			print("Infinite Jump Disabled")
		end
	end
})



local BunnyHopEnabled = false -- Global variabel
local BunnyHopFrequency = 0.1 -- Standardfrekvens för hoppning

Local_Jumping:Toggle({
	Name = "Bunny Hop",
	Default = false,
	Pointer = "Bhop_Toggle",
	Callback = function(state)
		BunnyHopEnabled = state -- Uppdaterar variabeln för togglen
		if BunnyHopEnabled then
            -- Skapa en separat funktion för att hantera hoppningen
			spawn(function()
				while BunnyHopEnabled do
                    -- Kontrollera om spelaren är i spelet och om karaktären finns
					local player = game.Players.LocalPlayer
					if player.Character and player.Character:FindFirstChild("Humanoid") then
						local humanoid = player.Character:FindFirstChild("Humanoid")

                        -- Om spelaren inte är i luften, hoppa
						if humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and 
                           humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
							humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end

                    -- Vänta enligt den inställda frekvensen innan nästa hopp
					wait(BunnyHopFrequency) -- Använd den justerbara frekvensen
				end
			end)
		end
	end
})

Local_Jumping:Slider({
	Name = "Bunny Hop Frequency",
	Minimum = 0.01,
	Maximum = 3,
	Default = 0.1,
	Decimals = 0.01, -- Antal decimaler korrekt specificerat
	Pointer = "BhopFrequency_Slider",
	Callback = function(value)
		BunnyHopFrequency = value -- Uppdaterar frekvensvärdet
		print("Bunny Hop Frequency set to:", BunnyHopFrequency)
	end
})

Local_Health:Slider({
	Name = "Health [CS]",
	Minimum = 1,
	Maximum = 100,
	Default = humanoid.Health,
	Decimals = 1,
	Pointer = "Local_Health_healthSlider",
	Callback = function(value)
		player.Character.Humanoid.Health = value
	end
})

Local_Health:Button({
	Name = "Suicide",
	Pointer = "SuicideBTN",
	Callback = function()
		player.Character.Humanoid.Health = 0
	end
})


Local_Grav:Slider({
	Name = "Gravity",
	Minimum = 0,
	Maximum = 500,
	Default = 196.19,
	Decimals = 1,
	Pointer = "Local_GravSlider",
	Callback = function(value)
		game.Workspace.Gravity = value
	end
})

Local_Grav:Button({
	Name = "Reset Gravity",
	Pointer = "GravityBTN",
	Callback = function()
		game.Workspace.Gravity = 196.19
	end
})








Local_Body:Toggle({
	Name = "Freeze",
	Default = false,
	Pointer = "Freeze_Toggle",
	Callback = function(state)
		local player = game.Players.LocalPlayer
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if state then
            -- Anchora spelarens karaktär
				player.Character.HumanoidRootPart.Anchored = true
			else
            -- Släpp ankaret
				player.Character.HumanoidRootPart.Anchored = false
			end
		end
	end
})


local noclipEnabled = false
local player = game.Players.LocalPlayer

-- Funktion för att hantera kollisionsstatus
local function setCollision(character, canCollide)
	if not character then
		return
	end

    -- Kolla vilken typ av rigg spelaren använder
	if character:FindFirstChild("Humanoid") and character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
        -- R15 rigg: Hantera delar specifika för R15
		for _, partName in ipairs({
			"Head",
			"UpperTorso",
			"LowerTorso",
			"HumanoidRootPart"
		}) do
			local part = character:FindFirstChild(partName)
			if part and part:IsA("BasePart") then
				part.CanCollide = canCollide
			end
		end
	elseif character:FindFirstChild("Humanoid") and character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
        -- R6 rigg: Hantera delar specifika för R6
		for _, partName in ipairs({
			"Head",
			"Torso",
			"HumanoidRootPart"
		}) do
			local part = character:FindFirstChild(partName)
			if part and part:IsA("BasePart") then
				part.CanCollide = canCollide
			end
		end
	end
end

-- Skapa togglen
Local_Body:Toggle({
	Name = "Noclip",
	Default = false,
	Pointer = "Noclip_Toggle",
	Callback = function(state)
		noclipEnabled = state -- Uppdaterar noclipEnabled baserat på togglen
		local character = player.Character or player.CharacterAdded:Wait()
		if not state then
            -- Om noclip stängs av, återställ kollisionsstatus
			setCollision(character, true)
		end
	end
})

-- Använd Stepped för att hantera noclip i realtid
game:GetService("RunService").Stepped:Connect(function()
	if noclipEnabled then
		local character = player.Character
		if character then
			setCollision(character, false) -- Inaktivera kollision
		end
	end
end)

















local spinEnabled = false
local spinPower = 100  -- Default power for spin
local bodyThrust = nil
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()


Local_Body:Toggle({
	Name = "Spin Bot",
	Default = false,
	Pointer = "SpinB_Toggle",
	Callback = function(state)
		local character = player.Character or player.CharacterAdded:Wait()
		spinEnabled = state

        -- If spin is enabled, add BodyThrust to the HumanoidRootPart
		if spinEnabled then
			if character and character:FindFirstChild("HumanoidRootPart") then
                -- Ensure there is no existing BodyThrust
				if not character.HumanoidRootPart:FindFirstChild("BodyThrust") then
					bodyThrust = Instance.new("BodyThrust")
					bodyThrust.Parent = character.HumanoidRootPart
					bodyThrust.Force = Vector3.new(spinPower, 0, spinPower)
					bodyThrust.Location = character.HumanoidRootPart.Position
				end
			end
		else
            -- If spin is disabled, remove the BodyThrust
			if bodyThrust then
				bodyThrust:Destroy()
				bodyThrust = nil
			end
		end
	end
})

Local_Body:Slider({
	Name = "Spin Bot Power",
	Minimum = 1,
	Maximum = 1500,
	Default = 20,
	Decimals = 1,
	Pointer = "Local_Body_SpinSpeed",
	Callback = function(value)
		spinPower = value
        -- Update BodyThrust's Force dynamically if it's active
		if bodyThrust then
			bodyThrust.Force = Vector3.new(spinPower, 0, spinPower)
		end
	end
})


local flyspeeed = 20

-- Skapa togglen
Local_Movement:Toggle({
	Name = "Levitate",
	Default = false,
	Pointer = "Levitate_Toggle",
	Callback = function(state)
		if (state) == true then
            -- Fly Script with Camera-Aligned Movement and Stable Orientation
			local player = game.Players.LocalPlayer
			local character = player.Character or player.CharacterAdded:Wait()
			local humanoid = character:WaitForChild("Humanoid")
			local torso = character:WaitForChild("HumanoidRootPart")
			local flying = false
			local speed = flyspeeed
			local camera = game.Workspace.CurrentCamera
			local keysPressed = {}

            local function startFlying()
				local bg = Instance.new("BodyGyro", torso)
				bg.MaxTorque = Vector3.new(4000, 4000, 4000)
				bg.P = 20000 -- Proportional gain to stabilize orientation
				local bv = Instance.new("BodyVelocity", torso)
				bv.MaxForce = Vector3.new(4000, 4000, 4000)
				bv.Velocity = Vector3.new(0, 0, 0)
				flying = true
				humanoid.PlatformStand = true

                local function updateVelocity()
					speed = flyspeeed
					local moveDirection = Vector3.new(0, 0, 0)
					local forwardDirection = camera.CFrame.lookVector
					local rightDirection = camera.CFrame.rightVector
					if keysPressed["W"] then
						moveDirection = forwardDirection
					elseif keysPressed["S"] then
						moveDirection = -forwardDirection
					end
					if keysPressed["A"] then
						moveDirection = moveDirection - rightDirection
					elseif keysPressed["D"] then
						moveDirection = moveDirection + rightDirection
					end
					moveDirection = moveDirection.unit * speed
					bv.Velocity = moveDirection

                    -- Update BodyGyro to stabilize orientation
					bg.CFrame = CFrame.new(torso.Position, torso.Position + forwardDirection)
				end

                local function updateFlight()
					while flying do
						if keysPressed["W"] or keysPressed["S"] or keysPressed["A"] or keysPressed["D"] then
							updateVelocity()
						else
							bv.Velocity = Vector3.new(0, 0, 0) -- Stop movement when no keys are pressed
						end
						wait()
					end
					bv:Destroy()
					bg:Destroy()
					humanoid.PlatformStand = false
				end

                -- Handle key input for flight movement
				game:GetService("UserInputService").InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Keyboard then
						keysPressed[input.KeyCode.Name] = true
						updateVelocity()
					end
				end)
				game:GetService("UserInputService").InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Keyboard then
						keysPressed[input.KeyCode.Name] = nil
						updateVelocity()
					end
				end)
				updateFlight()
			end
			startFlying()
		else
            -- Unfly Script
			local player = game.Players.LocalPlayer
			local character = player.Character
			if character then
				local torso = character:FindFirstChild("HumanoidRootPart")
				if torso then
					for _, instance in ipairs(torso:GetChildren()) do
						if instance:IsA("BodyVelocity") or instance:IsA("BodyGyro") then
							instance:Destroy()
						end
					end
					player.Character.Humanoid.PlatformStand = false
				end
			end
		end
	end
})



Local_Movement:Slider({
	Name = "Levitate Speed",
	Minimum = 0,
	Maximum = 150,
	Default = 20,
	Decimals = 1,
	Pointer = "Local_FlySpeed",
	Callback = function(wsValue)
		flyspeeed = (wsValue)
	end
})





-- Variabler för simning
local swimming = false
local oldgrav = workspace.Gravity

print (oldgrav)

local swimbeat = nil
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local swimSpeed = 50  -- Default swim speed



-- Swim Toggle
Local_Movement:Toggle({
	Name = "Swim",
	Default = false,
	Pointer = "Swim_Toggle",
	Callback = function(boolean)
		if boolean then
            -- Start simning
			if not swimming and player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") then
				oldgrav = workspace.Gravity
				workspace.Gravity = 0  -- Sätt gravitationen till 0 för att simma i luften
				local swimDied = function()
					workspace.Gravity = oldgrav
					swimming = false
				end
				local Humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
				local gravReset = Humanoid.Died:Connect(swimDied)

                -- Förhindra spelaren från att använda andra humanoidstatyer under simning
				local enums = Enum.HumanoidStateType:GetEnumItems()
				table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
				for i, v in pairs(enums) do
					Humanoid:SetStateEnabled(v, false)
				end

                -- Sätt humanoiden i simningstillstånd
				Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)

                -- Starta simningens "heartbeat" för att hantera spelarens rörelse
				swimbeat = RunService.Heartbeat:Connect(function()
					pcall(function()
						local humanoidRootPart = player.Character.HumanoidRootPart
						local moveDirection = Vector3.new(0, 0, 0)

                        -- Om spelaren trycker på tangentbordstangenter (WASD)
						if UserInputService:IsKeyDown(Enum.KeyCode.W) then
							moveDirection = moveDirection + camera.CFrame.LookVector
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.S) then
							moveDirection = moveDirection - camera.CFrame.LookVector
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.A) then
							moveDirection = moveDirection - camera.CFrame.RightVector
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.D) then
							moveDirection = moveDirection + camera.CFrame.RightVector
						end

                        -- Om spelaren trycker på Space, stiger de
						if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
							moveDirection = moveDirection + Vector3.new(0, 1, 0)
						end

                        -- Använd spelarens riktning för att uppdatera deras rörelse med den hastighet som valts
						if moveDirection.Magnitude > 0 then
							humanoidRootPart.Velocity = moveDirection.Unit * swimSpeed  -- Använd den valda hastigheten
						else
							humanoidRootPart.Velocity = Vector3.new(0, 0, 0)  -- Stoppar rörelsen om inga tangenter trycks
						end
					end)
				end)
				swimming = true
			end
		else
            -- Stoppa simning
			if player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") then
				workspace.Gravity = oldgrav  -- Återställ gravitationen
				swimming = false

                -- Koppla bort event och rensa upp
				if swimbeat then
					swimbeat:Disconnect()
					swimbeat = nil
				end
				if gravReset then
					gravReset:Disconnect()
				end
				local Humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
				local enums = Enum.HumanoidStateType:GetEnumItems()
				table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))

                -- Återaktivera alla humanoidstatyer
				for i, v in pairs(enums) do
					Humanoid:SetStateEnabled(v, true)
				end

                -- Förhindra att spelaren ligger på marken eller sprattlar
				local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart then
					humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 2, 0)  -- Lyft spelaren för att undvika fastna
				end
			end
			workspace.Gravity = 196.19
		end
	end
})

-- Swim Speed Slider
Local_Movement:Slider({
	Name = "Swim Speed",
	Minimum = 0,
	Maximum = 300,
	Default = 50,
	Decimals = 1,
	Pointer = "Local_SwimSpeed",
	Callback = function(value)
		swimSpeed = value
	end
})


local player = game.Players.LocalPlayer
local teleportEnabled = false
local UserInputService = game:GetService("UserInputService")
local clicktpKEY = Enum.KeyCode.E -- Default key for teleport
local humanoidRootPart

-- Function to update the humanoidRootPart reference
local function updateCharacter()
	local character = player.Character or player.CharacterAdded:Wait()
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end

-- Initial character setup
updateCharacter()

-- Toggle function to enable/disable teleport
Local_Movement:Toggle({
	Name = "Click TP",
	Default = false,
	Pointer = "ClickTP_Toggle",
	Callback = function(state)
		teleportEnabled = state
	end
})

:Keybind({
	Default = Enum.KeyCode.E,
	KeybindName = "Keybind",
	Mode = "Hold",
	Pointer = "KeybindTP",
	Callback = function(value)
		clicktpKEY = value
	end
})

-- Function to teleport the character
local function teleport()
	if teleportEnabled then
		local mouseHit = player:GetMouse().Hit.p
		humanoidRootPart.CFrame = CFrame.new(mouseHit + Vector3.new(0, 3, 0)) -- Teleport slightly above ground
	end
end

-- Event for key press
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == clicktpKEY then
			teleport()
		end
	end
end)

-- Connect to the CharacterAdded event to handle respawns
player.CharacterAdded:Connect(function()
	updateCharacter() -- Update the humanoidRootPart reference when the character respawns
end)



local dashEnabled = false
local dashSpeed = 100  -- Dashhastigheten
local dashDuration = 0.2  -- Hur länge dashen varar (sekunder)
local dashCooldown = 0  -- Hur länge du måste vänta mellan dashar (sekunder)
local dashStart = 0  -- Tidpunkten när dashen startade
local dashActive = false  -- Om dashen är aktiv eller inte

-- Trail-variabeln
local trail = nil

local function Dash()
	if not dashActive and tick() - dashStart >= dashCooldown then
		dashActive = true
		dashStart = tick()
		local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
            -- Uppdatera spelaren med högre hastighet för dash
			local originalVelocity = humanoidRootPart.Velocity
			local dashDirection = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
			humanoidRootPart.Velocity = dashDirection * dashSpeed  -- Sätt hastigheten till dashhastigheten

            -- Skapa trailen
			trail = Instance.new("Trail")
			trail.Name = "DashTrail"
			trail.Parent = humanoidRootPart  -- Fästa trailen vid HumanoidRootPart
			trail.Attachment0 = humanoidRootPart:FindFirstChild("Attachment") or Instance.new("Attachment", humanoidRootPart)
			trail.Attachment1 = humanoidRootPart:FindFirstChild("Attachment") or Instance.new("Attachment", humanoidRootPart)
            
            -- Ställ in trailens egenskaper
			trail.Lifetime = 0.2  -- Trailens livslängd (kan justeras om du vill ha trailen längre eller kortare)
			trail.WidthScale = NumberSequence.new(0.5, 0)  -- Gör trailen tunnare mot slutet
			trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 255))  -- Färg (kan ändras)
			trail.Enabled = true  -- Gör trailen synlig

            -- Efter dashens varaktighet (dashDuration), ta bort trailen
			wait(dashDuration)

            -- Ta bort trailen efter dashen är över
			if trail then
				trail:Destroy()
			end
		end

        -- Dashens varaktighet (efter dashDuration återgår vi till normal hastighet)
		wait(dashDuration)

        -- Återställ hastigheten efter att dashen har gått ut
		local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			humanoidRootPart.Velocity = Vector3.new(0, 0, 0)  -- Stanna rörelsen
		end
		dashActive = false  -- Markera dashen som inaktiv
	end
end


local dashKEYY = Enum.KeyCode.E

Local_Powers:Toggle({
	Name = "Dash",
	Default = false,
	Pointer = "Dash_Toggle",
	Callback = function(state)
		dashEnabled = state
	end
})

:Keybind({
	Default = Enum.KeyCode.E,
	KeybindName = "Keybind",
	Mode = "Hold",
	Pointer = "KeybindDash",
	Callback = function(value)
		dashKEYY = value
	end
})

Local_Powers:Slider({
	Name = "Dash Speed",
	Minimum = 1,
	Maximum = 750,
	Default = 100,
	Decimals = 1,
	Pointer = "Local_DashSpeed",
	Callback = function(value)
		dashSpeed = value
	end
})


UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == dashKEYY then
		if dashEnabled then
			Dash()  -- Anropa Dash-funktionen om dash är aktiverad
		end
	end
end)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local torso = character:WaitForChild("HumanoidRootPart")

local grappleActive = false
local grappleColor = Color3.fromRGB(200, 200, 200)
local grappleLine = nil
local targetPosition = nil
local bodyVelocity = nil
local velocityIncrement = 0
local velocityResetValue = 100
local accelerationRate = 10
local grappleKEYY = Enum.KeyCode.E

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local torso = character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Funktion för att uppdatera referenser när spelaren respawnar
local function onCharacterAdded(newCharacter)
	character = newCharacter
	humanoid = newCharacter:WaitForChild("Humanoid")
	torso = newCharacter:WaitForChild("HumanoidRootPart")
end

-- Koppla till CharacterAdded-event
player.CharacterAdded:Connect(onCharacterAdded)

-- Toggle-funktion för grapple
Local_Powers:Toggle({
	Name = "Grapple",
	Default = false,
	Pointer = "Grapple_Toggle",
	Callback = function(state)
		grappleActive = state
		if not grappleActive then
            -- Rensa upp om grapple stängs av
			if grappleLine then
				grappleLine:Destroy()
				grappleLine = nil
			end
			if bodyVelocity then
				bodyVelocity:Destroy()
				bodyVelocity = nil
			end
			velocityIncrement = 0  -- Nollställ hastighetsökningen
		end
	end
})

:Keybind({
	Default = grappleKEYY,
	KeybindName = "Keybind",
	Mode = "Hold",
	Pointer = "KeybindGrapple",
	Callback = function(value)
		grappleKEYY = value
	end
})

-- Funktion för att skapa grapple-linjen
local function createGrappleLine(initialPosition)
	grappleLine = Instance.new("Part")
	grappleLine.Size = Vector3.new(0.1, 0.1, (torso.Position - initialPosition).Magnitude)
	grappleLine.Anchored = true
	grappleLine.CanCollide = false
	grappleLine.Material = Enum.Material.Neon
	grappleLine.Color = grappleColor
	local midPoint = (torso.Position + initialPosition) / 2
	grappleLine.Position = midPoint + Vector3.new(0, grappleLine.Size.Y / 2, 0)
	local lookVector = (initialPosition - torso.Position).unit
	grappleLine.CFrame = CFrame.new(midPoint, midPoint + lookVector)
	grappleLine.Parent = Workspace
end

-- Funktion för att dra spelaren mot målet
local function pullPlayer()
	if targetPosition and bodyVelocity and grappleActive and humanoid and humanoid.Health > 0 then
		bodyVelocity.Velocity = (targetPosition - torso.Position).unit * (velocityResetValue + velocityIncrement)
	end
end

-- Funktion för att uppdatera grapple-linjen
local function updateGrappleLine()
	if grappleLine and targetPosition then
		local torsoPosition = torso.Position
		local midPoint = (torsoPosition + targetPosition) / 2
		grappleLine.Size = Vector3.new(0.1, 0.1, (torsoPosition - targetPosition).Magnitude)
		grappleLine.Position = midPoint + Vector3.new(0, grappleLine.Size.Y / 2, 0)
		local lookVector = (targetPosition - torsoPosition).unit
		grappleLine.CFrame = CFrame.new(midPoint, midPoint + lookVector)
	end
end

-- Funktion för att hantera tangenttryckningar
local function onInputBegan(input, gameProcessedEvent)
	if not gameProcessedEvent and grappleActive and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == grappleKEYY then
        -- Kontrollera om spelaren är död innan vi försöker skapa grapple
		if humanoid and humanoid.Health > 0 then
			local mouse = player:GetMouse()
			targetPosition = mouse.Hit.Position
			createGrappleLine(targetPosition)
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
			bodyVelocity.Parent = torso

            -- Kontinuerlig uppdatering av grapple-linjen och dra spelaren
			local connection
			connection = RunService.RenderStepped:Connect(function()
				if grappleActive and humanoid and humanoid.Health > 0 then
					updateGrappleLine()
					pullPlayer()
				else
					connection:Disconnect()
				end
			end)

            -- Hastighetsökning
			while grappleActive and humanoid and humanoid.Health > 0 do
				wait(0.1)
				velocityIncrement = velocityIncrement + accelerationRate
			end
		end
	end
end

-- Funktion för att hantera input när knappen släpps
local function onInputEnded(input, gameProcessedEvent)
	if not gameProcessedEvent and grappleActive and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == grappleKEYY then
		if grappleLine then
			grappleLine:Destroy()
			grappleLine = nil
			targetPosition = nil
		end
		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end
		velocityIncrement = 0
	end
end

-- Koppla tangenttryckningar 
UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)

-- Färgval
Local_Powers:Colorpicker({
	Info = "Grapple Color",
	Name = "Grapple Color",
	Alpha = 1,
	Default = Color3.fromRGB(200, 200, 200),
	Pointer = "GrappleColor",
	Callback = function(value)
		grappleColor = value
	end
})






















Local_Events:Button({
	Name = "Sit",
	Pointer = "SitBTN",
	Callback = function()
		player.Character.Humanoid.Sit = true
	end
})

Local_Events:Button({
	Name = "Un Sit",
	Pointer = "SitBTN",
	Callback = function()
		player.Character.Humanoid.Sit = false
	end
})

Local_Events:Button({
	Name = "Lay",
	Pointer = "LayBTN",
	Callback = function()
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoid and rootPart then
			humanoid.Sit = true -- Sätt spelaren i sittläge
			task.wait(0.1)

            -- Rotera karaktären för att simulera att ligga ner
			rootPart.CFrame = rootPart.CFrame * CFrame.Angles(math.pi * 0.5, 0, 0)

            -- Stoppa alla animationer
			for _, v in ipairs(humanoid:GetPlayingAnimationTracks()) do
				v:Stop()
			end
		end
	end
})


local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local originalMaxZoom = player.CameraMaxZoomDistance
local originalMinZoom = player.CameraMinZoomDistance

-- Skapa togglen
Local_Game:Toggle({
    Name = "Unblock Zoom Limit",
    Default = false,
    Pointer = "UnblockScrollLimit_Toggle",
    Callback = function(state)
        if state then
            -- Ta bort begränsningen
            player.CameraMaxZoomDistance = 1000  -- Sätt till ett mycket högt värde
            player.CameraMinZoomDistance = 0.5  -- Tillåt att zooma väldigt nära om så behövs
        else
            -- Återställ originalvärdena
            player.CameraMaxZoomDistance = originalMaxZoom
            player.CameraMinZoomDistance = originalMinZoom
        end
    end
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local antiAFKActive = false

-- Skapa togglen
Local_Game:Toggle({
    Name = "Anti AFK Kick",
    Default = false,
    Pointer = "AntiAFK_Toggle",
    Callback = function(state)
        antiAFKActive = state
        if antiAFKActive then
            local GC = getconnections or get_signal_cons
            if GC then
                -- Koppla bort event som orsakar AFK-kick
                for i, v in pairs(GC(player.Idled)) do
                    if v["Disable"] then
                        v["Disable"](v)
                    elseif v["Disconnect"] then
                        v["Disconnect"](v)
                    end
                end
            else
                -- Fallback-metod om getconnections inte finns
                player.Idled:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        else
            -- Inaktivera Anti AFK (ingen särskild åtgärd krävs eftersom det bara kopplar bort när togglen stängs av)
        end
    end
})


local seatConnections = {}

Local_Game:Toggle({
    Name = "Disable Sitting",
    Default = false,
    Pointer = "DisableSittingToggle",
    Callback = function(state)
        if state then
            -- Aktivera: Förhindra sittning
            for _, seat in ipairs(workspace:GetDescendants()) do
                if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
                    seat.Disabled = true -- Förhindrar sittning
                end
            end
            
            -- Lyssna efter nya sittplatser och disabla dem
            local connection = workspace.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("Seat") or descendant:IsA("VehicleSeat") then
                    descendant.Disabled = true
                end
            end)
            table.insert(seatConnections, connection)
        else
            -- Inaktivera: Tillåt sittning
            for _, seat in ipairs(workspace:GetDescendants()) do
                if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
                    seat.Disabled = false -- Återställ sittfunktion
                end
            end
            
            -- Koppla bort lyssnare för nya sittplatser
            for _, connection in ipairs(seatConnections) do
                connection:Disconnect()
            end
            seatConnections = {}
        end
    end
})







local StarterGui = game:GetService("StarterGui")

Local_Network:Button({
    Name = "Console",
    Pointer = "ConsoleBTN",
    Callback = function()
        local success, err = pcall(function()
            StarterGui:SetCore("DevConsoleVisible", true)
        end)
        if not success then
            warn("Failed to open developer console:", err)
        end
    end
})



Local_Network:Button({
    Name = "Copy JobId",
    Pointer = "JobBTN",
    Callback = function()
        local JobId = game.JobId
        setclipboard(JobId)
    end
})




Local_Network:Label({Name = "Game", Middle = false})




-- Knapp för att lämna spelet
Local_Network:Button({
    Name = "Leave",
    Pointer = "LeaveGameBTN",
    Callback = function()
        
                game.Players.LocalPlayer:Kick("You left the game.") -- Kickar spelaren
                
            
                     -- Stänger spelet (server-only)
                    
    end
})

Local_Network:Button({
    Name = "Shutdown",
    Pointer = "ShutDownBTN",
    Callback = function()
        
                game:Shutdown()
                
            
                     -- Stänger spelet (server-only)
                    
    end
})







local Settings = {
    Box_Color = Color3.fromRGB(250, 250, 255), -- Standard Box Color
    Box_Thickness = 1, -- Standard Box Thickness
}

local OthersESPEnabled = false -- Toggle för andra spelare
local SelfESPEnabled = false -- Toggle för LocalPlayer
local HealthbarESPEnabled = false -- Toggle för Healthbar ESP

local ESPObjects = {} -- Lista för att lagra ESP-objekt

-- Lokala tjänster
local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera

-- Funktioner för att skapa ESP-element
local function NewQuad(thickness, color)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.Color = color
    quad.Filled = false
    quad.Thickness = thickness
    quad.Transparency = 1
    return quad
end

local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = color
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

-- Funktion för att toggla synlighet
local function Visibility(state, lib)
    for _, obj in pairs(lib) do
        obj.Visible = state
    end
end

-- Funktion för att skapa ESP
local function CreateESP(plr)
    local library = {
        -- Box (main och border)
        blackbox = NewQuad(Settings.Box_Thickness * 2, Color3.fromRGB(0, 0, 0)),
        box = NewQuad(Settings.Box_Thickness, Settings.Box_Color),

        -- Healthbar (green och border)
        healthbar = NewLine(2, Color3.fromRGB(0, 0, 0)),
        greenhealth = NewLine(1.5, Color3.fromRGB(0, 255, 0)),
    }

    ESPObjects[plr] = library -- Lagra ESP-data för spelaren

    local function Update()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
                local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)

                    -- Uppdatera boxens storlek
                    local function UpdateBox(item)
                        item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY * 2)
                        item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY * 2)
                        item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY * 2)
                        item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY * 2)
                    end
                    UpdateBox(library.box)
                    UpdateBox(library.blackbox)

                    -- Uppdatera hälsobaren
                    if HealthbarESPEnabled then
                        local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY * 2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY * 2)).magnitude
                        local healthoffset = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * d

                        library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2)
                        library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2 - healthoffset)

                        library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2)
                        library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY * 2)
                    else
                        Visibility(false, {library.greenhealth, library.healthbar})
                    end

                    -- Visa ESP baserat på "Self" och "Others" toggles
                    if plr == player then
                        Visibility(SelfESPEnabled, {library.box, library.blackbox})
                        Visibility(SelfESPEnabled and HealthbarESPEnabled, {library.greenhealth, library.healthbar})
                    else
                        Visibility(OthersESPEnabled, {library.box, library.blackbox})
                        Visibility(OthersESPEnabled and HealthbarESPEnabled, {library.greenhealth, library.healthbar})
                    end
                else
                    Visibility(false, {library.box, library.blackbox, library.greenhealth, library.healthbar})
                end
            else
                Visibility(false, {library.box, library.blackbox, library.greenhealth, library.healthbar})
                if not game.Players:FindFirstChild(plr.Name) then
                    connection:Disconnect()
                end
            end
        end)
    end

    coroutine.wrap(Update)()
end

-- Skapa ESP för alla spelare
for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    coroutine.wrap(CreateESP)(v)
end

-- Lyssna efter nya spelare
game.Players.PlayerAdded:Connect(function(newPlayer)
    coroutine.wrap(CreateESP)(newPlayer)
end)

-- Uppdatera ESP-inställningar
local function UpdateESPSettings()
    for _, library in pairs(ESPObjects) do
        library.box.Color = Settings.Box_Color
        library.box.Thickness = Settings.Box_Thickness

        library.blackbox.Thickness = Settings.Box_Thickness * 2
    end
end

-- ESP-kontroller
Box_ESP:Toggle({
    Name = "Others",
    Default = false,
    Pointer = "OthersESP_Toggle",
    Callback = function(state)
        OthersESPEnabled = state
    end
})

Box_ESP:Toggle({
    Name = "Self",
    Default = false,
    Pointer = "SelfESP_Toggle",
    Callback = function(state)
        SelfESPEnabled = state
    end
})

Box_ESP:Toggle({
    Name = "Healthbar ESP",
    Default = false,
    Pointer = "Healthbar_Toggle",
    Callback = function(state)
        HealthbarESPEnabled = state
    end
})

Box_ESP:Colorpicker({
    Name = "Box Color",
    Default = Settings.Box_Color,
    Pointer = "BoxColor",
    Callback = function(value)
        Settings.Box_Color = value
        UpdateESPSettings()
    end
})

Box_ESP:Slider({
    Name = "Box Thickness",
    Default = Settings.Box_Thickness,
    Min = 0.1,
    Max = 5,
    Pointer = "BoxThickness_Slider",
    Callback = function(value)
        Settings.Box_Thickness = value
        UpdateESPSettings()
    end
})


local espColorChamsSelf = Color3.new(255, 255, 255)  -- Default color for Self
local espColorChamsOthers = Color3.new(255, 255, 255) -- Default color for Others
local chamsEnabledSelf = false -- Toggle for Self
local chamsEnabledOthers = false -- Toggle for Others

-- Funktion för att skapa Chams-ESP
local function createChams(character, color)
    if character:FindFirstChild("Head") then
        if not character:FindFirstChild("ESPHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Parent = character
            highlight.Name = "ESPHighlight"
            highlight.Adornee = character
            highlight.FillColor = color
            highlight.OutlineColor = color
        end
    end
end

-- Funktion för att ta bort Chams-ESP
local function removeChams(character)
    if character:FindFirstChild("ESPHighlight") then
        character.ESPHighlight:Destroy()
    end
end

-- Funktion för att applicera Chams till alla spelare
local function applyChamsToAllPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character then
            -- Applicera Chams baserat på Self eller Others toggle
            if player == game.Players.LocalPlayer then
                if chamsEnabledSelf then
                    createChams(player.Character, espColorChamsSelf)
                end
            else
                if chamsEnabledOthers then
                    createChams(player.Character, espColorChamsOthers)
                end
            end
        end
        
        -- När en ny spelare går med (CharacterAdded)
        player.CharacterAdded:Connect(function(character)
            if player == game.Players.LocalPlayer then
                if chamsEnabledSelf then
                    createChams(character, espColorChamsSelf)
                end
            else
                if chamsEnabledOthers then
                    createChams(character, espColorChamsOthers)
                end
            end
        end)

        -- När en spelare dör (CharacterRemoving)
        player.CharacterRemoving:Connect(function(character)
            removeChams(character)
        end)
    end
end

-- Funktion för att ta bort Chams från alla spelare
local function removeChamsFromAllPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character then
            removeChams(player.Character)
        end
    end
end

-- Uppdaterad loop som kontinuerligt applicerar Chams när det är aktiverat
game:GetService("RunService").Heartbeat:Connect(function()
    if chamsEnabledSelf or chamsEnabledOthers then
        applyChamsToAllPlayers()
    else
        removeChamsFromAllPlayers()
    end
end)

-- Chams-ESP kontroller i din nya menystruktur



Chams_ESP:Toggle({
    Name = "Others", -- Toggle för Others
    Default = false,
    Pointer = "OthersChams_Toggle",
    Callback = function(state)
        chamsEnabledOthers = state
        if chamsEnabledOthers then
            applyChamsToAllPlayers() -- Applicera Chams på andra spelare
        else
            removeChamsFromAllPlayers() -- Ta bort Chams från andra spelare
        end
    end
})

:Colorpicker({
    Name = "Others Chams Color", -- Färg för Others Chams
    Default = Color3.new(255, 0, 170), -- Röd som standard
    Pointer = "OthersChamsColor_Picker",
    Callback = function(color)
        espColorChamsOthers = color
        -- Uppdatera färg för Others Chams om det är aktiverat
        if chamsEnabledOthers then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    removeChams(player.Character)
                    createChams(player.Character, espColorChamsOthers)
                end
            end
        end
    end
})

Chams_ESP:Toggle({
    Name = "Self", -- Toggle för Self
    Default = false,
    Pointer = "SelfChams_Toggle",
    Callback = function(state)
        chamsEnabledSelf = state
        if chamsEnabledSelf then
            applyChamsToAllPlayers() -- Applicera Chams på din egen spelare
        else
            removeChamsFromAllPlayers() -- Ta bort Chams från din egen spelare
        end
    end
})
:Colorpicker({
    Name = "Self Chams Color", -- Färg för Self Chams
    Default = Color3.new(100, 0, 170), -- Lila som standard
    Pointer = "SelfChamsColor_Picker",
    Callback = function(color)
        espColorChamsSelf = color
        -- Uppdatera färg för Self Chams om det är aktiverat
        if chamsEnabledSelf then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player == game.Players.LocalPlayer and player.Character then
                    removeChams(player.Character)
                    createChams(player.Character, espColorChamsSelf)
                end
            end
        end
    end
})



local SkeletonLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()

local Skeletons = {}
local SelfESPEnabled = false  -- Variabel för om Self ESP är aktiverat
local OthersESPEnabled = false  -- Variabel för om Others ESP är aktiverat

-- Färg för skelettet (standard: lila)
local SkeletonColor = Color3.fromRGB(130, 0, 255)

-- Default värden för Thickness och Transparency
local SkeletonThickness = 1
local SkeletonTransparency = 0.5

-- Funktion för att skapa skelett ESP för en spelare
local function createSkeletonForPlayer(player)
    local skeleton = SkeletonLibrary:NewSkeleton(player, true)
    skeleton.Color = SkeletonColor  -- Sätt den nya färgen på skelettet
    skeleton.Thickness = SkeletonThickness  -- Sätt Thickness
    skeleton.Alpha = SkeletonTransparency  -- Sätt Transparency
    table.insert(Skeletons, skeleton)
end

-- Funktion för att uppdatera skelett baserat på togglarna
local function updateSkeletons()
    -- Ta bort alla befintliga skelett
    for _, skeleton in next, Skeletons do
        skeleton:Remove()
    end
    Skeletons = {}

    -- Om SelfESP är aktiverat, skapa skelett för den egna spelaren
    if SelfESPEnabled then
        createSkeletonForPlayer(game.Players.LocalPlayer)
    end

    -- Om OthersESP är aktiverat, skapa skelett för andra spelare
    if OthersESPEnabled then
        for _, player in next, game.Players:GetChildren() do
            if player ~= game.Players.LocalPlayer then
                createSkeletonForPlayer(player)
            end
        end
    end
end

-- Lägg till en spelare och deras skelett när de går med i spelet
game.Players.PlayerAdded:Connect(function(player)
    -- Om OthersESP är aktiverat, skapa skelett för den nya spelaren
    if OthersESPEnabled and player ~= game.Players.LocalPlayer then
        createSkeletonForPlayer(player)
    end
end)

-- Toggle för Self Skeleton ESP
Skeleton_ESP:Toggle({
    Name = "Self", -- Toggle för Self
    Default = false,
    Pointer = "SelfSkeleton_Toggle",
    Callback = function(state)
        SelfESPEnabled = state  -- Uppdatera variabeln när togglen ändras
        updateSkeletons()  -- Uppdatera skelett när ESP aktiveras eller inaktiveras
    end
})

-- Toggle för Others Skeleton ESP
Skeleton_ESP:Toggle({
    Name = "Others", -- Toggle för Others
    Default = false,
    Pointer = "OthersSkeleton_Toggle",
    Callback = function(state)
        OthersESPEnabled = state  -- Uppdatera variabeln när togglen ändras
        updateSkeletons()  -- Uppdatera skelett när ESP aktiveras eller inaktiveras
    end
})

-- Färgväljare för Skeleton Color
Skeleton_ESP:Colorpicker({
    Name = "Skeleton Color", -- Välj färg för skelett
    Default = SkeletonColor,
    Pointer = "SkeletonColor_Picker",
    Callback = function(color)
        SkeletonColor = color  -- Uppdatera SkeletonColor när användaren väljer en ny färg
        -- Uppdatera alla skelett med den nya färgen
        for _, skeleton in next, Skeletons do
            skeleton.Color = SkeletonColor  -- Ändra färgen för varje skelett
        end
    end
})

-- Slider för att justera Skeleton Thickness
Skeleton_ESP:Slider({
    Name = "Skeleton Thickness", -- Justera tjockleken på skelettet
    Default = SkeletonThickness,
    Min = 0.1,
    Max = 0.1,
    Rounding = 1,
    Pointer = "SkeletonThickness_Slider",
    Callback = function(value)
        SkeletonThickness = value  -- Uppdatera Thickness när användaren ändrar slider
        -- Uppdatera alla skelett med den nya tjockleken
        for _, skeleton in next, Skeletons do
            skeleton.Thickness = SkeletonThickness  -- Ändra tjockleken på varje skelett
        end
    end
})

-- Slider för att justera Skeleton Transparency
Skeleton_ESP:Slider({
    Name = "Skeleton Transparency", -- Justera transparensen på skelettet
    Default = SkeletonTransparency,
    Min = 0,
    Max = 1,
    Rounding = 0.1,
    Pointer = "SkeletonTransparency_Slider",
    Callback = function(value)
        SkeletonTransparency = value  -- Uppdatera Transparency när användaren ändrar slider
        -- Uppdatera alla skelett med den nya transparensen
        for _, skeleton in next, Skeletons do
            skeleton.Alpha = SkeletonTransparency  -- Ändra transparensen på varje skelett
        end
    end
})








-- // Keybind for toggling the menu
local UserInputService = game:GetService("UserInputService")
local isWindowVisible = true  -- Initially, the window is visible
local toggleKey = Enum.KeyCode.Insert  -- Default key to toggle the menu

-- Function to toggle the visibility of the window
local function toggleWindowVisibility()
	if isWindowVisible then
		Window:Fade()  -- Hide the window smoothly
	else
		Window:Initialize()  -- Show the window again (or you can use a fade-in animation)
	end
	isWindowVisible = not isWindowVisible
end

-- Listen for the chosen keybind to toggle the window
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end  -- Ignore inputs that are processed by the game (e.g., chat)
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == toggleKey then
		toggleWindowVisibility()  -- Toggle the window visibility based on the keybind
	end
end)

-- // Keybind Selector for the User
local SettingsMenu = MenuSettings:Section({
	Name = "Settings",
	Side = "Left"
})

-- Keybind to toggle the menu
SettingsMenu:Keybind({
	Name = "Toggle",
	Default = Enum.KeyCode.Insert,  -- Set the default key as Insert
	KeybindName = "Toggle",  -- This is the name used in the UI
	Mode = "Hold",  -- Hold mode for the keybind
	Pointer = "MenuSettings_Toggle",  -- Pointer for internal reference
	Callback = function(value)
		toggleKey = value  -- Update the toggleKey based on the selected key
		print("New keybind set to: " .. toggleKey.Name)
	end
})



local pigvicval = ""
local selectedobj = ""

-- Lyssnar efter chat-meddelanden från den lokala spelaren
game.Players.LocalPlayer.Chatted:Connect(function(message)
    -- Kontrollera om meddelandet börjar med "!plr "
    if message:lower():sub(1, 5) == "!plr " then
        -- Ta bort "!plr " från meddelandet och få kvar delnamnet
        local partialName = message:sub(6):lower()

        -- Vi håller koll på om vi redan har skickat en notis
        local foundPlayer = false

        -- Loopar genom alla spelare för att hitta en matchning
        for _, player in pairs(game.Players:GetPlayers()) do
            -- Kontrollera om spelarens namn innehåller delnamnet
            if player.Name:lower():find(partialName) then
                -- Kontrollera om vi redan har funnit en spelare för att undvika dubbla notiser
                if not foundPlayer then
                    -- Få spelarens avatarbild (profile picture URL)
                    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"

                    -- Skicka en notification med spelarens namn och avatarbild
                    game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "Player Found!", -- Required
                        Text = player.Name, -- Required
                        Icon = avatarUrl -- Optional, använd avatarbilden
                    })
                
                    pigvicval = player.Name

                    -- Markera att vi har skickat en notis
                    foundPlayer = true
                end
                -- Om en spelare har hittats, stoppa vidare sökning
                break
            end
        end

        -- Om ingen spelare hittades med det delnamnet
        if not foundPlayer then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "No player found", -- Required
                        Text = "We are sorry, try again", -- Required
                        
                    })
        end
    end
end)


game.Players.LocalPlayer.Chatted:Connect(function(message)
    -- Kontrollera om meddelandet börjar med "!plr "
    if message:lower():sub(1, 5) == "!obj " then
        -- Ta bort "!plr " från meddelandet och få kvar delnamnet
        local partialName = message:sub(6):lower()

        
                    selectedobj = partialName

                  
            game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "Object Selected", -- Required
                        Text = partialName, -- Required
                        
                    })
        
    end
end)








Window:Initialize()
