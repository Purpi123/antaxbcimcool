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
	Name = "Antax Private - " .. RigMode,
	Accent = Color3.fromRGB(60, 80, 110)
})
--
local LocalPlayer = Window:Page({
	Name = "Local"
})
local Visuals = Window:Page({
	Name = "Visuals"
})

local ClientSided = Window:Page({
	Name = "Client"
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





Window:Initialize()
