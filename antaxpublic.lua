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

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = 'Antax - '.. RigMode,
    Center = true,
    AutoShow = true,
    TabPadding = 8
})

-- CALLBACK NOTE:
-- Passing in callback functions via the initial element parameters (i.e. Callback = function(Value)...) works
-- HOWEVER, using Toggles/Options.INDEX:OnChanged(function(Value) ... ) is the RECOMMENDED way to do this.
-- I strongly recommend decoupling UI code from logic code. i.e. Create your UI elements FIRST, and THEN setup :OnChanged functions later.

-- You do not have to set your tabs & groups up this way, just a prefrence.
local Tabs = {
    -- Creates a new tab titled Main
    LocalTab = Window:AddTab('Local'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}


local LocalBasic = Tabs.LocalTab:AddLeftTabbox() 


local TabWalking = LocalBasic:AddTab('Walking')


local TabJumping = LocalBasic:AddTab('Jumping')


local TabGravity = LocalBasic:AddTab('Gravity')


local TabHealth = LocalBasic:AddTab('Health')


local LocalSpecials = Tabs.LocalTab:AddRightTabbox() 


local TabBody = LocalSpecials:AddTab('Body')

local TabMovement = LocalSpecials:AddTab('Movement')

local TabPowers = LocalSpecials:AddTab('Powers')

local TabEvents = LocalSpecials:AddTab('Events')


local LocalGame = Tabs.LocalTab:AddLeftTabbox() 


local TabGame = LocalGame:AddTab('Game')

local TabNetwork = LocalGame:AddTab('Network')

local TabSound = LocalGame:AddTab('Sound')

local defaultSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed -- Spara standardhastigheten

TabWalking:AddSlider('WalkSlider', {
    Text = 'Walkspeed',
    Default = defaultSpeed,
    Min = 1,
    Max = 500,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

local ResetWalk = TabWalking:AddButton({
    Text = 'Reset Walkspeed',
    Func = function()
        -- Återställ spelarens hastighet
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = defaultSpeed

        -- Uppdatera sliderns värde
        Options.WalkSlider:SetValue(defaultSpeed)
    end,
    DoubleClick = false,
    
})






local defaultJump = game.Players.LocalPlayer.Character.Humanoid.JumpPower -- Spara standardhastigheten

TabJumping:AddSlider('Jumppower', {
    Text = 'Jumppower',
    Default = defaultJump,
    Min = 1,
    Max = 500,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

local ResetJump = TabJumping:AddButton({
    Text = 'Reset Jumppower',
    Func = function()
        -- Återställ spelarens hastighet
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = defaultJump

        -- Uppdatera sliderns värde
        Options.Jumppower:SetValue(defaultJump)
    end,
    DoubleClick = false,
    
})


TabJumping:AddToggle('InfiniteJump', {
    Text = 'Infinite Jump',
    Default = false, -- Bör vara avstängd som standard
    Tooltip = 'Jump in the air / hold space.',

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

local DefaultWalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
local CurrentWalkSpeed = DefaultWalkSpeed
local MaxSpeed = 100 -- Max hastighet vid acceleration
local SpeedIncrement = 0.05 -- Hastighetsökning varje gång
local BunnyHopConnection
local IsMoving = false -- För att spåra om spelaren rör sig

TabJumping:AddToggle('BunnyHop', {
    Text = 'Bunny Hop',
    Default = false,
    Tooltip = 'Hold WASD for it to work.',

    Callback = function(Value)
        if Value then
            -- Aktivera Bunny Hop
            BunnyHopConnection = game:GetService("RunService").Stepped:Connect(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    local moveDirection = humanoid.MoveDirection
                    if moveDirection.Magnitude > 0 then
                        -- Spelaren rör sig, öka hastigheten och hoppa
                        IsMoving = true
                        CurrentWalkSpeed = math.min(CurrentWalkSpeed + SpeedIncrement, MaxSpeed)
                        humanoid.WalkSpeed = CurrentWalkSpeed
                        if humanoid.FloorMaterial ~= Enum.Material.Air then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    else
                        -- Spelaren rör sig inte, återställ hastigheten
                        IsMoving = false
                        humanoid.WalkSpeed = DefaultWalkSpeed
                        CurrentWalkSpeed = DefaultWalkSpeed
                    end
                end
            end)
        else
            -- Stäng av Bunny Hop
            if BunnyHopConnection then
                BunnyHopConnection:Disconnect()
                BunnyHopConnection = nil
            end

            -- Återställ hastighet
            local character = game.Players.LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = DefaultWalkSpeed
            end
        end
    end
})


local defaultGrav = game.workspace.Gravity 

TabGravity:AddSlider('Gravity', {
    Text = 'Gravity',
    Default = defaultGrav,
    Min = 0,
    Max = 500,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        game.workspace.Gravity = Value
    end
})

local ResetGrav = TabGravity:AddButton({
    Text = 'Reset Gravity',
    Func = function()
        -- Återställ spelarens hastighet
        game.workspace.Gravity = defaultGrav

        -- Uppdatera sliderns värde
        Options.Gravity:SetValue(defaultGrav)
    end,
    DoubleClick = false,
    
})

TabHealth:AddSlider('Health', {
    Text = 'Health',
    Default = game.Players.LocalPlayer.Character.Humanoid.Health,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Compact = false,
	Tooltip = "This is client sided.",

    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.Health = Value
    end
})

local Suicide = TabHealth:AddButton({
    Text = 'Suicide',
    Func = function()
        -- Återställ spelarens hastighet
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
        Library:Notify("You took the easy way out.", 5)
        
    end,
    DoubleClick = true,
    
})





TabBody:AddToggle('FreezeTog', {
    Text = 'Freeze',
    Default = false, -- Default value (true / false)
    

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

TabBody:AddToggle('NoclipTog', {
    Text = 'Noclip',
    Default = false, -- Default value (true / false)
    

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















-- Notif
Library:Notify("Welcome!", 5) -- Text, Time



Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
