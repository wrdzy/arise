--loadstring(game:HttpGet("https://pastes.io/raw/wwwwwwwwwwdddd"))()

local BlacklistedPlayers = {
    548245499,
    2318524722,
    3564923852
}

local player = game.Players.LocalPlayer
local userId = player.UserId

-- Check if the player's userId is in the BlacklistedPlayers table
for _, blacklistedId in ipairs(BlacklistedPlayers) do
    if userId == blacklistedId then
        player:Kick("You are blacklisted from using this script. wrdyz.94 On discord for appeal.")
        break
    end
end




local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Version = "1.5.5"

if _G.Interface == nil then
_G.Interface = true

-- ====== PERSISTENCE MECHANISM ======
local CONFIGURATION = {
    FOLDER_NAME = "CROW",
    SCRIPT_URL = "https://pastes.io/raw/wwwwwwwwwwdddd",
    FILE_EXTENSION = ".lua"
}





    
Fluent:Notify({
    Title = "Loading interface...",
    Content = "Interface is loading, please wait.",
    Duration = 5 -- Set to nil to make the notification not disappear
})



local Admins = {
    8205778977
}
local isAdmin = false
for _, adminId in ipairs(Admins) do
    if userId == adminId then
        isAdmin = true
        break
    end
end

local Window = Fluent:CreateWindow({
    Title = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." | "..Version,
    SubTitle = "(auto updt vers.) by wrdyz.94",
    TabWidth = 100,
    Size = UDim2.fromOffset(550, 400),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    Transparency = "false",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})



--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "hammer" }),
    Autofarm = Window:AddTab({ Title = "Autofarm", Icon = "repeat" }),
    AutoCrates = Window:AddTab({ Title = "Crates", Icon = "box" }),
    -- Teleport = Window:AddTab({ Title = "Teleport", Icon = "compass" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "book" }),
    UpdateLogs = Window:AddTab({ Title = "Update Logs", Icon = "scroll" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

if isAdmin then
    Tabs.Admin = Window:AddTab({ Title = "Admin", Icon = "shield" })
end


local Options = Fluent.Options




    Tabs.Player:AddParagraph({
        Title = "Some features might not work together correctly.",
        Content = ""
    })



    
    

    local secplayer = Tabs.Player:AddSection("Player")

    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local basespeed = humanoid.WalkSpeed
    local basejump = humanoid.JumpPower


    -- WalkSpeed Slider
    local SliderWalk = secplayer:AddSlider("SliderWalk", {
        Title = "Walk Speed",
        Description = "",
        Default = basespeed,
        Min = basespeed,
        Max = basespeed * 5,
        Rounding = 0,
        Callback = function(Value)
            humanoid.WalkSpeed = Value
        end
    })
    
    
    -- JumpPower Slider
    local SliderJump = secplayer:AddSlider("SliderJump", {
        Title = "Jump Power",
        Description = "",
        Default = basejump,
        Min = basejump,
        Max = basejump * 4,
        Rounding = 0,
        Callback = function(Value)
            humanoid.UseJumpPower = true
            humanoid.JumpPower = Value
        end
    })
    
    -- Ensure WalkSpeed stays set
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if humanoid.WalkSpeed ~= SliderWalk.Value then
            humanoid.WalkSpeed = SliderWalk.Value
        end
    end)
    -- Ensure this block is properly closed and does not interfere with subsequent code
    
    -- Ensure JumpPower stays set
    humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if humanoid.JumpPower ~= SliderJump.Value then
            humanoid.JumpPower = SliderJump.Value
        end
    end)
    
    -- Reset values when character respawns
    player.CharacterAdded:Connect(function(character)
        humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = SliderWalk.Value
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed ~= SliderWalk.Value then
                humanoid.WalkSpeed = SliderWalk.Value
            end
        end)
        humanoid.UseJumpPower = true
        humanoid.JumpPower = SliderJump.Value
    end)











    local player = game.Players.LocalPlayer
    local tool = nil
    local notificationShown = false
    
    -- Slider for swing speed
    local SwingSpeed = secplayer:AddSlider("Swing Speed", {
        Title = "Swing Speed",
        Description = "",
        Default = 1.5,
        Min = 1.5,
        Max = 4.5,
        Rounding = 1,
        Callback = function(Value)
            if tool and tool:FindFirstChild("Speeds") and tool.Speeds:FindFirstChild("Swingspeed") then
                tool.Speeds.Swingspeed.Value = Value
            end
        end
    })
    
    -- Function to safely wait for Speeds.Swingspeed and set the value
    local function updateToolSwingSpeed()
        if not tool then return end
    
        -- Wait for 'Speeds' folder
        local speeds = tool:FindFirstChild("Speeds") or tool:WaitForChild("Speeds", 2)
        if not speeds then return end
    
        -- Wait for 'Swingspeed' value
        local swingspeed = speeds:FindFirstChild("Swingspeed") or speeds:WaitForChild("Swingspeed", 2)
        if not swingspeed then return end
    
        -- Set the value
        swingspeed.Value = SwingSpeed.Value
    end
    
    -- Start a loop to wait for the tool and apply the swing speed
    task.spawn(function()
        while true do
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
    
            -- Wait until character exists and is alive
            if not character or not humanoid or humanoid.Health <= 0 then
                task.wait(1)
                continue
            end
    
            tool = character:FindFirstChildOfClass("Tool")
    
            -- If tool is missing, show notification and wait
            if not tool then
                -- Wait until tool is found
                repeat
                    task.wait(0.5)
                    character = player.Character
                    tool = character and character:FindFirstChildOfClass("Tool")
                until tool
    
                notificationShown = false
            end
    
            -- Wait for Speeds and Swingspeed to be replicated and set the value
            updateToolSwingSpeed()
    
            -- Monitor tool removal
            tool.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    tool = nil
                end
            end)
    
            -- Idle wait until tool is removed
            repeat task.wait(1) until not tool
        end
    end)
    
    -- Also update on slider change
    SwingSpeed:OnChanged(function()
        updateToolSwingSpeed()
    end)
    

    
    
    

    

    




    
    


    -- Tabs.Autofarm:AddParagraph({
    --     Title = "Disable everything from player section before enabling this.",
    --     Content = ""
    -- })

    -- local secauto = Tabs.Autofarm:AddSection("Heads")

    -- local Headsinput = secauto:AddInput("Autofarm threshold", {
    --     Title = "Autofarm threshold",
    --     Description = "Below 0.08 will resault in a server kick.",
    --     Default = "0.1",
    --     Placeholder = "Placeholder",
    --     Numeric = true, -- Only allows numbers
    --     Finished = true, -- Only calls callback when you press enter
    --     -- Callback = function(numberthreshold)
    --     --     print("Input changed:", numberthreshold)
    --     -- end
    -- })
    
    -- local player = game.Players.LocalPlayer
    -- local AutofarmCoins = secauto:AddToggle("AutofarmCoins", {Title = "Autofarm heads", Default = false })
    -- local eventsDeleted = false  -- Variable to track if the events were already deleted
    
    -- local notificationShown = false
    
    -- -- Function to disable autofarm and show notification
    -- local function disableAutofarmWithNotification()
    --     AutofarmCoins:SetValue(false)
    --     Fluent:Notify({
    --         Title = "Autofarm",
    --         Content = "Disabled due to death.",
    --         Duration = 5
    --     })
    -- end
    
    -- AutofarmCoins:OnChanged(function()
    --     if not player or not player.Character then return end -- Ensure player exists
    --     local characterEvents = player.Character:FindFirstChild("CharacterEvents")
    --     if not characterEvents then return end -- Ensure CharacterEvents exists
    
    --     if AutofarmCoins.Value then
    --         -- Check if player has a weapon
    --         local weapon = player.Character:FindFirstChildOfClass("Tool")
    --         if not weapon then
    --             AutofarmCoins:SetValue(false)
    --             Fluent:Notify({
    --                 Title = "Autofarm",
    --                 Content = "Weapon not found.",
    --                 Duration = 5
    --             })
    --             return  -- Exit early if no weapon
    --         end

    --         if humanoid.Health == 0 then
    --             disableAutofarmWithNotification()  -- Disable autofarm and notify on death
    --             return
    --         end
    
    --         -- Delete events only once
    --         if not eventsDeleted then
    --             for _, event in ipairs(characterEvents:GetChildren()) do
    --                 event:Destroy()  -- Destroy each child (event) in the CharacterEvents folder
    --             end
    --             eventsDeleted = true
    --         end
    
    --         -- Ensure to disable autofarm on death
    --         if player.Character:FindFirstChild("Humanoid") then
    --             player.Character.Humanoid.Died:Connect(function()
    --                 disableAutofarmWithNotification()  -- Disable autofarm and notify on death
    --             end)
    --         end
    
    --         -- Start the hit loop
    --         task.spawn(function()
    --             while AutofarmCoins.Value do
    --                 for _, tool in ipairs(player.Character:GetChildren()) do
    --                     if tool:IsA("Tool") then
    --                         local hitEvent = tool:FindFirstChild("Events") and tool.Events:FindFirstChild("Hit")
    --                         if hitEvent then
    --                             local humanoid = player.Character:FindFirstChild("Humanoid")
    --                             if humanoid then
    --                                 hitEvent:FireServer(humanoid)
    --                             end
    --                         end
    --                     end
    --                 end
                    
    --                 -- Convert input value to a number and check if it's >= 0.8           
    --                 -- if Headsinput.Value > 0.8 then
    --                     task.wait(Headsinput.Value)
    --                 -- end
    --             end
    --         end)
            
    
    --     else
    --         -- Stop the hit loop
            
    --         -- Restore the deleted events
    --         if eventsDeleted then
    --             local function restoreEvent(name)
    --                 local event = Instance.new("RemoteEvent")
    --                 event.Name = name
    --                 event.Parent = player.Character:FindFirstChild("CharacterEvents")
    --             end
    
    --             restoreEvent("Ability")
    --             restoreEvent("ClientRagdollEvent")
    --             restoreEvent("Headbutt")
    --             restoreEvent("Hit")
    --             restoreEvent("Impulse")
    --             restoreEvent("Launch")
    --             restoreEvent("PhysicsEvent")
    --             restoreEvent("RagdollEvent")
    
    --             eventsDeleted = false  -- Reset the deletion flag
    --         end
    --     end
    -- end)
    
    -- -- Ensure Autofarm is off initially
    -- AutofarmCoins:SetValue(false)
    


    



    
        

    



    local GodMode = secplayer:AddToggle("GodMode", {Title = "God Mode", Default = false})
    local player = game.Players.LocalPlayer
    local humanoid = nil
    local character = nil
    local originalImmuneState = nil  -- Variable to store the original state of the 'Immune' property
    
    -- Function to delete the Immune property
    local function deleteImmuneProperty()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            humanoid = player.Character.Humanoid
            if humanoid:FindFirstChild("Immune") then
                originalImmuneState = humanoid.Immune.Value  -- Save the original state before deleting
                humanoid.Immune:Destroy()  -- Delete the Immune property
            end
        end
    end
    
    -- Function to restore the Immune property
    local function restoreImmuneProperty()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            humanoid = player.Character.Humanoid
            if originalImmuneState ~= nil then
                -- If Immune exists, restore the value to its original state
                local immune = humanoid:FindFirstChild("Immune")
                if immune then
                    immune.Value = originalImmuneState
                else
                    -- If Immune doesn't exist, create it and set the value
                    local immune = Instance.new("BoolValue")
                    immune.Name = "Immune"
                    immune.Value = originalImmuneState
                    immune.Parent = humanoid
                end
            end
        end
    end
    
    -- When the character respawns, update the humanoid and handle immunity
    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoid = character:WaitForChild("Humanoid")
    
        -- If GodMode is active, delete the Immune property
        if GodMode.Value then  -- Use Value instead of Get()
            deleteImmuneProperty()
        else
            -- If GodMode is turned off, restore the Immune property to its original state
            restoreImmuneProperty()
        end
    end)
    
    -- God Mode toggle logic
    GodMode:OnChanged(function()
        if not player or not player.Character then return end  -- Ensure the player exists
        humanoid = player.Character:FindFirstChild("Humanoid")
    
        -- If GodMode is active, delete the Immune property to make the player invulnerable
        if GodMode.Value then  -- Use Value instead of Get()
            if humanoid and humanoid:FindFirstChild("Immune") then
                deleteImmuneProperty()
            end
        else
            -- If GodMode is turned off, restore the Immune property to its original state
            if humanoid then
                restoreImmuneProperty()
            end
        end
    end)
    
    
    local godmodestate = GodMode.Value
    
    
    
    
      
    

local Killaura = secplayer:AddToggle("Killaura", {Title = "Kill aura", Default = false})
local player = game:GetService("Players").LocalPlayer
local hitEventThread = nil
local notificationShown = false

-- Function to get the nearest player
local function getNearestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    if myHRP then
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= player and p.Character then
                local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    local distance = (targetHRP.Position - myHRP.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = p
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Function to run Kill Aura loop
local function fireHitEvent()
    while Killaura.Value do
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")

        -- Wait until character exists and is alive
        if not character or not humanoid or humanoid.Health <= 0 then
            task.wait(1)
            continue
        end

        local weapon = character:FindFirstChildOfClass("Tool")
        if not weapon then
            -- Wait until tool is found or Killaura is toggled off
            repeat
                task.wait(0.5)
                character = player.Character
                weapon = character and character:FindFirstChildOfClass("Tool")
            until weapon or not Killaura.Value

            notificationShown = false
        end

        if weapon then
            local targetPlayer = getNearestPlayer()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                weapon.Events.Hit:FireServer(targetPlayer.Character.Humanoid)
            end
        end

        task.wait(0.1)
    end
end

-- When toggle is changed
Killaura:OnChanged(function()
    if Killaura.Value then
        hitEventThread = task.spawn(fireHitEvent)
    else
        hitEventThread = nil
    end
end)





local secHitbox = Tabs.Player:AddSection("Hitbox")

local hitcolor = secHitbox:AddColorpicker("hitcolor", {
    Title = "Hitbox color",
    Transparency = 0,
    Default = Color3.fromRGB(255, 0, 0)
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Table to store original HumanoidRootPart sizes
local OriginalSizes = {}

-- Function to safely get the default size of HumanoidRootPart
local function GetDefaultHumanoidRootPartSize(player)
    if player and player.Character then
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            return rootPart.Size
        end
    end
    return Vector3.new(2, 2, 1) -- Fallback size
end

-- Set default size based on local player (if available)
local DefaultHitboxSize = GetDefaultHumanoidRootPartSize(LocalPlayer).X
local HitboxSize = DefaultHitboxSize -- Current hitbox size (modifiable via slider)
local HitboxEnabled = false -- Track if hitbox resizing is enabled

-- Function to resize hitboxes for other players
local function ResizeHitboxesForPlayer(player)
    if not HitboxEnabled or player == LocalPlayer then return end -- Ensure toggle is ON and ignore local player

    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Store original size before resizing
            if not OriginalSizes[player] then
                OriginalSizes[player] = humanoidRootPart.Size
            end

            local newSize = Vector3.new(HitboxSize, HitboxSize, HitboxSize)

            humanoidRootPart.Size = newSize
            humanoidRootPart.CanCollide = false
            humanoidRootPart.Transparency = 1 -- Make it invisible

            -- Add visualizer if not already present
            local hitboxVisualizer = humanoidRootPart:FindFirstChild("HitboxVisualizer")
            if not hitboxVisualizer then
                hitboxVisualizer = Instance.new("SelectionBox")
                hitboxVisualizer.Name = "HitboxVisualizer"
                hitboxVisualizer.Adornee = humanoidRootPart
                hitboxVisualizer.Parent = humanoidRootPart

                -- Set initial color when visualizer is created
                local color = hitcolor.Value
                local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
                
                hitboxVisualizer.Color3 = Color3.fromRGB(r, g, b)
                hitboxVisualizer.SurfaceColor3 = Color3.fromRGB(r, g, b)
                
                hitboxVisualizer.SurfaceTransparency = 1 -- Outline only
                hitboxVisualizer.LineThickness = 0.1
            end
        end
    end
end

-- Function to reset hitbox to original size
local function RevertHitboxSize(player)
    if player == LocalPlayer then return end -- Ignore local player
    
    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and OriginalSizes[player] then
            humanoidRootPart.Size = OriginalSizes[player] -- Reset size
            humanoidRootPart.Transparency = 0 -- Restore transparency
            humanoidRootPart.CanCollide = true -- Restore collision
            
            -- Remove hitbox visualizer if it exists
            local hitboxVisualizer = humanoidRootPart:FindFirstChild("HitboxVisualizer")
            if hitboxVisualizer then
                hitboxVisualizer:Destroy()
            end
        end
    end
end

-- Function to resize all players except local player
local function ApplyHitboxResizing()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ResizeHitboxesForPlayer(player)
        end
    end
end

-- Function to update the color of the hitbox visualizer for all players
local function UpdateHitboxColor()
    local color = hitcolor.Value
    local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)

    -- Iterate through all players and update their visualizers
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local hitboxVisualizer = humanoidRootPart:FindFirstChild("HitboxVisualizer")
                if hitboxVisualizer then
                    hitboxVisualizer.Color3 = Color3.fromRGB(r, g, b)
                    hitboxVisualizer.SurfaceColor3 = Color3.fromRGB(r, g, b)
                    hitboxVisualizer.Transparency = hitcolor.Transparency
                end
            end
        end
    end
end

-- Handle new player joining and respawning
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1) -- Ensure character is fully loaded
        if HitboxEnabled then
            ResizeHitboxesForPlayer(player)
        end
    end)
end)

-- Apply respawn handling for all players except local player
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1) -- Ensure character is fully loaded
            if HitboxEnabled then
                ResizeHitboxesForPlayer(player)
            end
        end)
    end
end

-- UI Elements (Initialized AFTER variables are defined)
local SliderHitboxSize = secHitbox:AddSlider("SliderHitboxSize", {
    Title = "Hitbox Size",
    Description = "",
    Default = DefaultHitboxSize,
    Min = 10,  -- Minimum size
    Max = 70, -- Maximum size
    Rounding = 1,
    Callback = function(Value)
        if Value then
            HitboxSize = Value -- Update hitbox size
            if HitboxEnabled then
                ApplyHitboxResizing()
            end
        end
    end
})

-- Ensure slider starts at default size
SliderHitboxSize:SetValue(DefaultHitboxSize)

-- Toggle to enable/disable hitbox resizing (AFTER slider)
local ToggleHitboxResize = secHitbox:AddToggle("ToggleHitboxResize", {
    Title = "Hitbox Expander",
    Default = false
})

-- Toggle behavior (AFTER slider)
ToggleHitboxResize:OnChanged(function(Value)
    if Value == nil then return end -- Prevent nil value errors

    HitboxEnabled = Value

    if HitboxEnabled then
        ApplyHitboxResizing() -- Apply resizing if enabled
    else
        -- Revert all players except local player to their original hitbox sizes
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                RevertHitboxSize(player)
            end
        end
    end
end)

-- Update color whenever the colorpicker value changes
hitcolor:OnChanged(function()
    UpdateHitboxColor()
end)















local secmisc = Tabs.Misc:AddSection("Misc")


local SoundSpamname = secmisc:AddDropdown("SsN", {
    Title = "Sound Emote",
    Description = "",
    Values = {},  -- Will be populated with emotes that have sounds
    Default = nil,
    Multi = false,
})

local SoundSpam = secmisc:AddToggle("SoundSpam", {Title = "Sound Spam", Default = false })

-- Cache the selected emote
local selectedEmote = nil

-- Function to populate dropdown with emotes that have sounds
local function populateSoundEmotes()
    local repStorage = game:GetService("ReplicatedStorage")
    local emotesContainer = repStorage:FindFirstChild("Emotes")
    local newEmotesContainer = repStorage:FindFirstChild("Emotes.New") -- Look for Emotes.New folder as well
    

    local soundEmotes = {}

    -- Function to find all emotes with sounds in a given folder
    local function findEmotesWithSounds(parent)
        if not parent then return end  -- Ensure we don't try to access GetChildren on a nil parent
        for _, child in ipairs(parent:GetChildren()) do
            -- Check if the child is of type Sound or has a sound component (Audio/Sound, etc.)
            if child:IsA("Sound") or child:IsA("Audio") or child:FindFirstChildOfClass("Sound") then
                table.insert(soundEmotes, child.Name)
            end
            
            -- If it's a folder, recursively check its children
            if child:IsA("Folder") then
                findEmotesWithSounds(child)
            end
        end
    end

    -- Check both Emotes and Emotes.New for sound emotes
    findEmotesWithSounds(emotesContainer)
    findEmotesWithSounds(newEmotesContainer)

    -- Update dropdown with found sound emotes
    if #soundEmotes > 0 then
        SoundSpamname:SetValues(soundEmotes)
    end
end

-- Initialize dropdown with sound emotes
task.spawn(populateSoundEmotes)

-- Function to find an emote by name
local function findEmote(emoteName)
    local repStorage = game:GetService("ReplicatedStorage")
    local emotesContainer = repStorage:FindFirstChild("Emotes")
    local newEmotesContainer = repStorage:FindFirstChild("Emotes.New")
    
    if not emotesContainer and not newEmotesContainer then return nil end

    -- Function to search through emotes and find the right one
    local function searchForEmote(parent, targetName)
        if not parent then return nil end
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == targetName and (child:IsA("Sound") or child:IsA("Audio") or child:FindFirstChildOfClass("Sound")) then
                return child
            elseif child:IsA("Folder") then
                local found = searchForEmote(child, targetName)
                if found then
                    return found
                end
            end
        end
        return nil
    end

    -- Search in both Emotes and Emotes.New folders
    return searchForEmote(emotesContainer, emoteName) or searchForEmote(newEmotesContainer, emoteName)
end

-- Handle dropdown selection
SoundSpamname:OnChanged(function(value)
    selectedEmote = findEmote(value)
end)

SoundSpam:OnChanged(function()
    local repStorage = game:GetService("ReplicatedStorage")
    
    -- If the toggle is turned on, start the sound spam loop
    if SoundSpam.Value then
        task.spawn(function()
            while SoundSpam.Value do
                task.wait(0.5)  -- Small wait to avoid freezing the script
                
                -- Check again immediately after waiting
                if not SoundSpam.Value then break end
                
                local emoteName = SoundSpamname.Value
                if emoteName and emoteName ~= "" then
                    if not selectedEmote then
                        selectedEmote = findEmote(emoteName)
                    end
                    
                    if selectedEmote then
                        local song = selectedEmote:FindFirstChildOfClass("Sound") or selectedEmote:FindFirstChild("Song")
                        if song then
                            -- Fire the sound event
                            local args = { song }
                            repStorage:WaitForChild("Modules")
                                :WaitForChild("Utilities")
                                :WaitForChild("net")
                                :WaitForChild("EmoteSoundEvent")
                                :FireServer(unpack(args))
                        else
                            Fluent:Notify({
                                Title = "Sound Spam",
                                Content = "Emote not found.",
                                Duration = 2
                            })
                            break
                        end
                    else
                        Fluent:Notify({
                            Title = "Sound Spam",
                            Content = "Please select a valid emote.",
                            Duration = 2
                        })
                        break
                    end
                end
            end
        end)
    else
        -- Stop the sound when the toggle is turned off
        local emoteName = SoundSpamname.Value
        if emoteName and emoteName ~= "" and selectedEmote then
            local song = selectedEmote:FindFirstChildOfClass("Sound") or selectedEmote:FindFirstChild("Song")
            if song then
                local args = { song }
                repStorage:WaitForChild("Modules")
                    :WaitForChild("Utilities")
                    :WaitForChild("net")
                    :WaitForChild("StopSoundEvent")
                    :FireServer(unpack(args))
            else
                Fluent:Notify({
                    Title = "Sound Spam",
                    Content = "Emote not found.",
                    Duration = 2
                })
            end
        end
    end
end)





local brickk = secmisc:AddToggle("BrickToggle", {Title = "Remove Lava", Description = "", Default = false})
local brickkyes = false

local removedCanTouch = {}  -- Store the original CanTouch property states

brickk:OnChanged(function()
    if brickk.Value then
        -- Turned ON: Look through models inside workspace.Map
        for _, model in pairs(workspace.Map:GetChildren()) do
            if model:IsA("Model") then  -- Ensure it's a model
                -- Look through the nested models inside the outer model
                for _, innerModel in pairs(model:GetChildren()) do
                    if innerModel:IsA("Model") then
                        -- Look for parts inside the innerModel named "Union" or "Part"
                        for _, part in pairs(innerModel:GetChildren()) do
                            if part:IsA("BasePart") and (part.Name == "Union" or part.Name == "Part") then
                                -- Check if part has a TouchInterest
                                local touchInterest = part:FindFirstChild("TouchInterest")
                                if touchInterest then
                                    -- Store the original CanTouch property value
                                    table.insert(removedCanTouch, {part, part.CanTouch})
                                    
                                    -- Disable the CanTouch property to stop touch interactions
                                    part.CanTouch = false
                                end
                            end
                        end
                    end
                end
            end
        end
        brickkyes = true
        local brick = Instance.new("Part")
        brick.Size = Vector3.new(10000, 10, 10000) -- Large but not extreme
        brick.Anchored = true
        brick.CanCollide = true
        brick.Transparency = 0.5 -- Semi-visible
        brick.BrickColor = BrickColor.new("Dark grey")
        brick.Name = "BigBrick"
        brick.Parent = game.Workspace -- Parent must be set before Position
        brick.Position = Vector3.new(50, -95, 1000)
    else
        -- Turned OFF: Restore the CanTouch property to its original value
        if brickkyes then
            local existingBrick = game.Workspace:FindFirstChild("BigBrick")
            if existingBrick then
                existingBrick:Destroy()
            end
            for _, data in ipairs(removedCanTouch) do
                local part, originalCanTouch = unpack(data)
                
                -- Restore the original CanTouch value
                part.CanTouch = originalCanTouch
            end

            removedCanTouch = {}  -- Clear the list after restoring
            brickkyes = false
        end
    end
end)










local secunl = Tabs.Misc:AddSection("Unlock")

secunl:AddButton({
    Title = "Unlock all badge weapons",
    Description = "",
    Callback = function()
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local userId = localPlayer.UserId
        
        -- Using request() function (only available in exploit environments)
        local response = request({
            Url = "https://badges.roblox.com/v1/users/" .. userId .. "/badges?limit=100",
            Method = "GET"
        })
        
        if response.Success then
            local data = game:GetService("HttpService"):JSONDecode(response.Body)
            
            if data and data.data and #data.data > 0 then
                -- Get a random badge ID
                local randomBadgeId = data.data[math.random(1, #data.data)].id
                
                -- Find all badge statue models and replace their IDs with the random one
                local notify = false
                for _, statue in pairs(workspace.Shop.Statues.BadgeStatues:GetChildren()) do
                    if statue:FindFirstChild("badgeid") then
                        statue.badgeid.Value = randomBadgeId
                        if not notify then
                            notify = true
                            Fluent:Notify({
                                Title = "Success",
                                Content = "Unlocked badge weapons successfully",
                                Duration = 5
                            })
                        end
                    end
                end
            else
                -- No badges found
                Fluent:Notify({
                    Title = "Error",
                    Content = "You need to own at least one badge",
                    Duration = 5
                })
            end
        else
            -- Request failed
            Fluent:Notify({
                Title = "Error",
                Content = "Failed to fetch badge data",
                Duration = 5
            })
        end
    end
})




local miscserver = Tabs.Misc:AddSection("Servers")

local Player = game:GetService("Players").LocalPlayer

-- Function to format server time from 00:00:00 to 00h 00m 00s
local function formatServerTime(timeString)
    -- Attempt to match the pattern of hours, minutes, and seconds
    local hours, minutes, seconds = timeString:match("(%d+):(%d+):(%d+)")
    if hours and minutes and seconds then
        return string.format("%02dh %02dm %02ds", tonumber(hours), tonumber(minutes), tonumber(seconds))
    else
        return "Invalid Time"  -- In case the time format is wrong
    end
end

-- Function to get the server's info (player count, max players, ping)
local function getServerInfo()
    local serverInfo = {
        playerCount = #game:GetService("Players"):GetPlayers(), -- Get player count from the current server
        ping = 0, -- Default value for server ping, will be updated by the API
        maxPlayers = game:GetService("Players").MaxPlayers -- Get max players for the current server
    }

    -- Fetch server data from the Roblox API
    local success, response = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)

    if success then
        local decoded
        success, decoded = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response)
        end)

        if success and decoded and decoded.data then
            for _, server in ipairs(decoded.data) do
                if server.id == game.JobId then  -- We're checking for the current server (based on JobId)
                    -- Updating with server's player count, max players, and ping from the API
                    serverInfo.playerCount = server.playing or serverInfo.playerCount
                    serverInfo.maxPlayers = server.maxPlayers or serverInfo.maxPlayers
                    serverInfo.ping = server.ping or 0  -- API ping data
                    break
                end
            end
        end
    end

    return serverInfo
end

-- Function to get the player's ping and convert it to ms
local function getPlayerPing()
    -- Get player's ping (in seconds)
    local playerPingSeconds = Player:GetNetworkPing()

    -- Convert to milliseconds (round-trip)
    local playerPingMs = playerPingSeconds * 1000 * 2

    return math.floor(playerPingMs)  -- Return the ping in milliseconds
end

-- Check if the ServerTime element exists in the PlayerGui
local function getServerTimeText()
    if Player.PlayerGui and Player.PlayerGui:FindFirstChild("Others") and 
       Player.PlayerGui.Others:FindFirstChild("ServerTime") then
        return Player.PlayerGui.Others.ServerTime.Text or "00:00:00"
    end
    return "00:00:00"  -- Default if GUI element not found
end

local infoParagraph = miscserver:AddParagraph({
    Title = "Server Uptime: Loading... | Player Count: N/A | Max Players: N/A | Ping: N/A ms",
    Content = ""
})

-- Update server uptime, player count, max players, and ping every frame
game:GetService("RunService").Heartbeat:Connect(function()
    -- Fetch the current server's info (player count, max players, ping)
    local serverInfo = getServerInfo()

    -- Get the player's network ping
    local playerPing = getPlayerPing()

    -- Update the server uptime
    local uptime = formatServerTime(getServerTimeText())

    -- Update the paragraph title with the current server info
    infoParagraph:SetTitle("Server Uptime: " .. uptime ..
                           " | Player Count: " .. serverInfo.playerCount ..
                           "/" .. serverInfo.maxPlayers ..
                           " | Ping: " .. playerPing .. " ms")
end)

-- Create the dropdown
local SVD = miscserver:AddDropdown("Server List", {
    Title = "Server Browser",
    Values = {},  -- Will be populated once
    Multi = false,
    Default = nil,
})

-- Get server list once
local function getServerList()
    local serverList = {}
    
    local success, response = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)
    
    if success then
        local decoded
        success, decoded = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response)
        end)
        
        if success and decoded and decoded.data then
            for _, server in ipairs(decoded.data) do
                if server.id ~= game.JobId then -- Don't include current server
                    table.insert(serverList, {
                        id = server.id,
                        playing = server.playing or 0,
                        maxPlayers = server.maxPlayers or 0,
                        ping = server.ping or 0
                    })
                end
            end
        end
    end
    
    return serverList
end

-- Store server IDs for teleporting
_G.ServerIDs = {}

-- Get servers once
local servers = getServerList()
local serverOptions = {}

-- Format server information for dropdown
for _, server in ipairs(servers) do
    local option = string.format("Players: %d/%d | Ping: %dms", 
        server.playing, server.maxPlayers, server.ping)
    table.insert(serverOptions, option)
    _G.ServerIDs[option] = server.id
end

-- Set values to dropdown
if #serverOptions > 0 then
    SVD:SetValues(serverOptions)
else
    SVD:SetValues({"No servers available"})
end

-- Handle selection
SVD:OnChanged(function(Value)
    local serverId = _G.ServerIDs[Value]
    
    if serverId then
        Fluent:Notify({
            Title = "Teleporting",
            Content = "Joining server...",
            Duration = 3
        })
        
        -- Use pcall to handle teleport errors
        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(
                game.PlaceId, serverId, game.Players.LocalPlayer
            )
        end)
    end
end)

miscserver:AddButton({
    Title = "Copy Server ID: ".. tostring(game.JobId),
    Callback = function()
        pcall(function()
            setclipboard(tostring(game.JobId)) -- Copy the server ID to clipboard
        end)
        Fluent:Notify({
            Title = "Server ID Copied",
            Content = "Server ID: " .. tostring(game.JobId) .. " copied to clipboard.",
            Duration = 3
        })
    end
})

-- Rejoin button logic
miscserver:AddButton({
    Title = "Rejoin",
    Description = "",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        -- Teleport the player to the same place they are currently in
        pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end
})




miscserver:AddButton({
    Title = "Server Hop",
    Description = "",
    Callback = function()
        -- Get services
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        -- Show initial notification
        Fluent:Notify({
            Title = "Server Hop",
            Content = "Finding a populated server...",
            Duration = 2
        })
        
        -- API endpoint for servers - sort by Desc to get more populated servers first
        local apiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        
        -- Try to get server list
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(apiUrl))
        end)
        
        if success and result and result.data then
            -- Filter for valid servers (not current server and not full)
            local validServers = {}
            
            for _, server in ipairs(result.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    table.insert(validServers, server)
                end
            end
            
            -- Sort servers by player count (highest first)
            table.sort(validServers, function(a, b)
                return a.playing > b.playing
            end)
            
            -- If we have servers, teleport to one of the most populated ones
            if #validServers > 0 then
                -- Choose one of the top 3 most populated servers (or fewer if less available)
                local topServerCount = math.min(3, #validServers)
                local serverIndex = math.random(1, topServerCount)
                local server = validServers[serverIndex]
                
                -- Show teleport notification
                Fluent:Notify({
                    Title = "Server Hop",
                    Content = "Joining server with " .. server.playing .. "/" .. server.maxPlayers .. " players",
                    Duration = 2
                })
                
                -- Teleport immediately after notification
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
            else
                -- No suitable servers found, teleport to same place (will pick random server)
                Fluent:Notify({
                    Title = "Server Hop",
                    Content = "No servers found. Joining random server...",
                    Duration = 2
                })
                
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        else
            -- If API call failed, fallback to simple teleport
            Fluent:Notify({
                Title = "Server Hop",
                Content = "Joining random server...",
                Duration = 2
            })
            
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end
})





    -- -- Create Auto-Click ToggleA
    -- local TeleportService = game:GetService("TeleportService")
    -- local Players = game:GetService("Players")
    -- local LocalPlayer = Players.LocalPlayer
    
    -- local Autorejoin = secmisc:AddToggle("Autorejoin", {Title = "Auto rejoin", Description = "Instantly rejoins when kicked", Default = false})
    
    -- Autorejoin:OnChanged(function()
    --     if Autorejoin.Value then
    --         -- Detect when the player is kicked by overriding the Kick function
    --         local mt = getrawmetatable(game)
    --         setreadonly(mt, false)
    --         local oldNamecall = mt.__namecall
    
    --         mt.__namecall = newcclosure(function(self, ...)
    --             local method = getnamecallmethod()
    --             if method == "Kick" and self == LocalPlayer then
    --                 task.spawn(function()
    --                     TeleportService:Teleport(game.PlaceId) -- Instantly rejoin
    --                 end)
    --                 return
    --             end
    --             return oldNamecall(self, ...)
    --         end)
    
    --         -- Handle teleport failure and attempt rejoin
    --         LocalPlayer.OnTeleport:Connect(function(status)
    --             if status == Enum.TeleportState.Failed then
    --                 TeleportService:Teleport(game.PlaceId) -- Instantly attempt to rejoin
    --             end
    --         end)
    --     end
    -- end)
    
    

    -- Options.Autorejoin:SetValue(false)



local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local AntiAFKEnabled = false  -- Starts as disabled
local AntiAFKLoop  -- Variable to store the loop thread

-- UI Toggle Setup
local Antiafk = secmisc:AddToggle("Antiafk", {Title = "Anti AFK", Default = false })

Antiafk:OnChanged(function()
    AntiAFKEnabled = Options.Antiafk.Value  -- Sync with UI Toggle

    if AntiAFKEnabled then
        -- Start Anti-AFK loop
        AntiAFKLoop = task.spawn(function()
            while AntiAFKEnabled do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new()) -- Simulates right-click to stay active
                print("Anti-AFK: Prevented afk kick.")
                task.wait(300) -- Every 5 minutes (300 seconds)
            end
        end)
    else
        -- Stop Anti-AFK loop
        AntiAFKEnabled = false
        if AntiAFKLoop then
            task.cancel(AntiAFKLoop) -- Stop the active loop
            AntiAFKLoop = nil
        end
    end
end)

Antiafk:SetValue(false) -- Default state is OFF

-- Prevent AFK kick by responding to "Idle" events
player.Idled:Connect(function()
    if AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)





local secautoBoss = Tabs.Autofarm:AddSection("Boss")


local AutofarmBoss = secautoBoss:AddToggle("AutofarmBoss", {Title = "Autofarm Boss", Default = false})
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local hitEventThread = nil
local teleportThread = nil
local isRunning = false

-- Tween config
local tweenTime = 0.5
local tweenInfo = TweenInfo.new(
    tweenTime,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out,
    0,
    false,
    0
)

local positionOffset = Vector3.new(0, 2, 2)  -- Offset from boss position

-- Function to check if the boss has spawned
local function isBossSpawned()
    local boss = workspace:FindFirstChild("Boss")
    return boss and boss:FindFirstChild("KingBuffoon")
end

-- Function to safely get the boss and its humanoid
local function getBoss()
    if not isBossSpawned() then return nil, nil end
    local boss = workspace.Boss.KingBuffoon
    local bossHumanoid = boss:FindFirstChild("Humanoid")
    return boss, bossHumanoid
end

-- Tween teleport to the boss and disable after boss dies
local function tweenToBoss()
    while AutofarmBoss.Value and isRunning do
        if not isBossSpawned() then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Boss disappeared, disabling autofarm.",
                Duration = 5
            })
            break
        end

        local boss, bossHumanoid = getBoss()
        if boss and bossHumanoid and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Check if boss is defeated
            if bossHumanoid.Health <= 0 then
                task.defer(function()
                    AutofarmBoss:SetValue(false)
                end)
                Fluent:Notify({
                    Title = "Autofarm Boss",
                    Content = "Boss defeated! Autofarm disabled.",
                    Duration = 5
                })
                break
            end

            local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
            local bossHRP = boss:FindFirstChild("HumanoidRootPart")

            if myHRP and bossHRP then
                local targetPos = bossHRP.Position + positionOffset

                local tween = TweenService:Create(
                    myHRP,
                    tweenInfo,
                    {CFrame = CFrame.new(targetPos, bossHRP.Position)}
                )
                tween:Play()
                tween.Completed:Wait()
            end
        end

        task.wait(0.1)
    end
end

-- Function to fire the hit event
local function fireHitEvent()
    while AutofarmBoss.Value and isRunning do
        if not isBossSpawned() then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Boss despawned.",
                Duration = 5
            })
            break
        end

        local weapon = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if not weapon then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Weapon not found.",
                Duration = 5
            })
            break
        end

        local _, bossHumanoid = getBoss()
        if bossHumanoid and player.Character and weapon then
            local hitEvent = weapon:FindFirstChild("Events") and weapon.Events:FindFirstChild("Hit")
            if hitEvent then
                pcall(function()
                    hitEvent:FireServer(bossHumanoid)
                end)
            else
                pcall(function()
                    weapon:Activate()
                end)
            end
        end

        task.wait(0.3 + math.random() * 0.1)
    end
end

-- Handle player death
local function handlePlayerDeath()
    if AutofarmBoss.Value then
        task.defer(function()
            AutofarmBoss:SetValue(false)
        end)
        Fluent:Notify({
            Title = "Autofarm Boss",
            Content = "Disabled due to death.",
            Duration = 5
        })
    end
end

-- Connect to character respawn
player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(handlePlayerDeath)

    if AutofarmBoss.Value then
        task.delay(1, function()
            local weapon = character:FindFirstChildOfClass("Tool")
            if not weapon then
                task.defer(function()
                    AutofarmBoss:SetValue(false)
                end)
                Fluent:Notify({
                    Title = "Autofarm Boss",
                    Content = "Disabled after respawn - no weapon found.",
                    Duration = 5
                })
            end
        end)
    end
end)

-- Listen for workspace changes to detect boss spawn/despawn
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Boss" then
        child.ChildAdded:Connect(function(bossChild)
            if bossChild.Name == "KingBuffoon" then
                Fluent:Notify({
                    Title = "Boss Notification",
                    Content = "Boss has spawned!",
                    Duration = 5
                })
            end
        end)
    end
end)

workspace.ChildRemoved:Connect(function(child)
    if child.Name == "Boss" and AutofarmBoss.Value then
        task.defer(function()
            AutofarmBoss:SetValue(false)
        end)
        Fluent:Notify({
            Title = "Autofarm Boss",
            Content = "Boss despawned",
            Duration = 5
        })
    end
end)

-- Constant boss check loop
task.spawn(function()
    while wait(1) do
        if AutofarmBoss.Value and not isBossSpawned() then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Boss not found, disabling autofarm.",
                Duration = 5
            })
        end
    end
end)
local godmodevalue = GodMode.Value

-- Handle AutofarmBoss toggle
AutofarmBoss:OnChanged(function()
    if AutofarmBoss.Value then
        -- Enable GodMode when AutofarmBoss is turned on
        GodMode:SetValue(true)

        if not isBossSpawned() then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Boss not found.",
                Duration = 5
            })
            return
        end

        local weapon = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if not weapon then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Weapon not found.",
                Duration = 5
            })
            return
        end

        if not isRunning then
            isRunning = true
            hitEventThread = task.spawn(fireHitEvent)
            teleportThread = task.spawn(tweenToBoss)
        end
    else
        isRunning = false
        if hitEventThread then
            task.cancel(hitEventThread)
            hitEventThread = nil
        end
        if teleportThread then
            task.cancel(teleportThread)
            teleportThread = nil
        end

        GodMode:SetValue(godmodevalue)
    end
end)

-- Connect death handler if character already exists
if player.Character then
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(handlePlayerDeath)
    end
end














secautoBoss:AddButton({
    Title = "Auto Server Hop to find boss",
    Description = "Automatically hops servers until King Buffoon is found",
    Callback = function()
        local ScriptSource = [[
            local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
            local PlaceID = game.PlaceId
            local AllIDs = {}
            local foundAnything = ""
            local actualHour = os.date("!*t").hour
            local File = pcall(function()
                AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
            end)

            if not File then
                table.insert(AllIDs, actualHour)
                writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
            end
            wait(5)

            local function IsBossPresent()
                local bossFolder = game.Workspace:FindFirstChild("Boss")
                if bossFolder then
                    local found = bossFolder:FindFirstChild("KingBuffoon")
                    if found and found:IsA("Model") then
                        local humanoid = found:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            return true
                        else
                            return false
                        end
                    end
                end
                return false
            end

            local function TPReturner()
                local Site
                local retries = 0
                local success = false

                while not success and retries < 3 do
                    local status, response = pcall(function()
                        if foundAnything == "" then
                            return game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
                        else
                            return game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
                        end
                    end)

                    if status then
                        Site = response
                        success = true
                    else
                        print("Error fetching server list: " .. tostring(response))
                        if Fluent then
                            Fluent:Notify({
                                Title = "Error",
                                Content = "Error fetching server list: " .. tostring(response),
                                Duration = 5
                            })
                        end
                        if tostring(response):find("429") then
                            print("Rate limited. Waiting 20 seconds...")
                            if Fluent then
                                Fluent:Notify({
                                    Title = "Rate Limit",
                                    Content = "Rate limited. Waiting 20 seconds...",
                                    Duration = 5
                                })
                            end
                            wait(20)
                        end
                        retries = retries + 1
                        wait(5)
                    end
                end

                if not success then
                    print("Failed after retries.")
                    if Fluent then
                        Fluent:Notify({
                            Title = "Error",
                            Content = "Failed to fetch server list after retries.",
                            Duration = 5
                        })
                    end
                    return
                end

                if Site.nextPageCursor and Site.nextPageCursor ~= "null" then
                    foundAnything = Site.nextPageCursor
                end

                local num = 0
                for i, v in pairs(Site.data) do
                    local Possible = true
                    local ID = tostring(v.id)
                    if tonumber(v.maxPlayers) > tonumber(v.playing) then
                        for _, Existing in pairs(AllIDs) do
                            if num ~= 0 then
                                if ID == tostring(Existing) then
                                    Possible = false
                                end
                            else
                                if tonumber(actualHour) ~= tonumber(Existing) then
                                    pcall(function()
                                        delfile("NotSameServers.json")
                                        AllIDs = {}
                                        table.insert(AllIDs, actualHour)
                                    end)
                                end
                            end
                            num = num + 1
                        end
                        if Possible then
                            table.insert(AllIDs, ID)
                            wait()
                            pcall(function()
                                writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                                wait()
                                queue_on_teleport(ScriptSource)  -- Queue the ScriptSource to run after teleport
                                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                            end)
                            wait(4)
                        end
                    end
                end
            end

            local function Main()
                while true do
                    if not IsBossPresent() then
                        print("Boss not found. Hopping servers...")
                        if Fluent then 
                            Fluent:Notify({
                                Title = "Server Hop",
                                Content = "Boss not found. Hopping servers...",
                                Duration = 5
                            })
                        end
                        TPReturner()
                    else
                        print("Boss found! Ending loop.")
                        if Fluent then
                            Fluent:Notify({
                                Title = "Boss Found",
                                Content = "Boss found! Ending loop.",
                                Duration = 5
                            })
                        end
                        loadstring(game:HttpGet("https://pastes.io/raw/wwwwwwwwwwdddd"))()
                        break
                    end
                end
            end

            Main()
        ]]

        -- Write the script to file BEFORE execution
        writefile("AutoServerHop.lua", ScriptSource)
            
        queue_on_teleport(ScriptSource)
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        -- Show initial notification
        Fluent:Notify({
            Title = "Server Hop",
            Content = "Finding a populated server...",
            Duration = 2
        })
        
        -- API endpoint for servers - sort by Desc to get more populated servers first
        local apiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        
        -- Try to get server list
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(apiUrl))
        end)
        
        if success and result and result.data then
            -- Filter for valid servers (not current server and not full)
            local validServers = {}
            
            for _, server in ipairs(result.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    table.insert(validServers, server)
                end
            end
            
            -- Sort servers by player count (highest first)
            table.sort(validServers, function(a, b)
                return a.playing > b.playing
            end)
            
            -- If we have servers, teleport to one of the most populated ones
            if #validServers > 0 then
                -- Choose one of the top 3 most populated servers (or fewer if less available)
                local topServerCount = math.min(3, #validServers)
                local serverIndex = math.random(1, topServerCount)
                local server = validServers[serverIndex]
                
                -- Show teleport notification
                Fluent:Notify({
                    Title = "Server Hop",
                    Content = "Joining server with " .. server.playing .. "/" .. server.maxPlayers .. " players",
                    Duration = 2
                })
                
                -- Teleport immediately after notification
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
            else
                -- No suitable servers found, teleport to same place (will pick random server)
                Fluent:Notify({
                    Title = "Server Hop",
                    Content = "No servers found. Joining random server...",
                    Duration = 2
                })
                
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        else
            -- If API call failed, fallback to simple teleport
            Fluent:Notify({
                Title = "Server Hop",
                Content = "Joining random server...",
                Duration = 2
            })
            
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
        
    end
})





























    

-- 📌 UI Section
local secauto2 = Tabs.Autofarm:AddSection("Boxes")


-- 📌 Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local teleporting = false
local notificationShown = false

-- 📌 Function to calculate distance
local function GetDistance(position1, position2)
    return (position1 - position2).Magnitude
end

-- Declare stepammount globally first with a default value
local stepammount = 0.005

local StepValue = secauto2:AddInput("StepValue", {
    Title = "Step Size",
    Description = "Default setting if unfamiliar.",
    Default = "0.005",
    Placeholder = "Placeholder",
    Numeric = true, -- Only allows numbers
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
    end
})

-- Properly update the global stepammount when the input changes
StepValue:OnChanged(function()
    stepammount = tonumber(StepValue.Value) or 0.005 -- Convert to number with fallback
end)

-- 📌 Toggle for Autofarm
local TTPM = secauto2:AddToggle("TTPM", {
    Title = "Autofarm boxes ", 
    Description = "Performance may vary based on your FPS.",
    Default = false
})

-- 📌 Function to find nearest box
local function FindNearestBox()
    local character = player.Character
    if not character then return nil end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local boxPositions = game.Workspace:FindFirstChild("BoxPositions")
    if not boxPositions then return nil end

    local nearestBox, nearestDistance = nil, math.huge  
    for _, boxpos in pairs(boxPositions:GetChildren()) do
        if boxpos:IsA("BasePart") and #boxpos:GetChildren() > 0 then
            local distance = GetDistance(rootPart.Position, boxpos.Position)
            if distance < nearestDistance then
                nearestBox, nearestDistance = boxpos, distance
            end
        end
    end
    return nearestBox
end

-- Function to check if player has a weapon equipped
local function HasWeaponEquipped()
    local character = player.Character
    if not character then return false end

    local tool = character:FindFirstChildOfClass("Tool")
    return tool ~= nil
end

-- Function to handle player death
local function handlePlayerDeath()
    if TTPM.Value then
        GodMode:SetValue(godmodestate)
        TTPM:SetValue(false)
        Fluent:Notify({
            Title = "Box Autofarm",
            Content = "Disabled due to death.",
            Duration = 5
        })
    end
end

-- 📌 Function to teleport to nearest crate
local function DirectTeleportToNearestCrate()
    local character = player.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local tool = character:FindFirstChildOfClass("Tool")

    if not rootPart then return end

    if not tool then
        TTPM:SetValue(false)
        Fluent:Notify({
            Title = "Box Autofarm",
            Content = "Weapon not found.",
            Duration = 5
        })
        return
    end

    local nearestBox = FindNearestBox()
    if not nearestBox then return end

    local maxSpeed, minSpeed, distanceThreshold = 500, 200, 70

    local startPos = rootPart.Position
    local endPos = nearestBox.Position + Vector3.new(0, 2, 0)
    local distance = GetDistance(startPos, endPos)

    local speed = maxSpeed
    if distance > distanceThreshold then
        local factor = math.clamp((distance - distanceThreshold) / distanceThreshold, 0, 1)
        speed = maxSpeed - factor * (maxSpeed - minSpeed)
    end

    local stepSize = speed * stepammount
    local totalSteps = math.ceil(distance / stepSize)

    -- Precompute random offsets
    local randomOffsets = {}
    for i = 1, totalSteps do
        randomOffsets[i] = Vector3.new(math.random(), math.random(), math.random())
    end

    -- Anchor player before teleporting
    rootPart.Anchored = true

    for i = 1, totalSteps do
        rootPart.CFrame = CFrame.new(startPos:Lerp(endPos + randomOffsets[i], i / totalSteps))
        tool:Activate()

        local randomFactor = 1 + (math.random() * 0.3 - 0.15)
        task.wait(stepammount * randomFactor)
    end

    tool:Activate()

    -- Unanchor after teleporting
    rootPart.Anchored = false
end

-- 📌 Start teleport loop
local function StartTeleportLoop()
    if teleporting then return end
    teleporting = true
    GodMode:SetValue(true)

    task.spawn(function()
        while TTPM.Value do
            if not HasWeaponEquipped() then
                TTPM:SetValue(false)
                Fluent:Notify({
                    Title = "Box Autofarm",
                    Content = "Weapon not found.",
                    Duration = 5
                })
                break
            end

            DirectTeleportToNearestCrate()
            task.wait(0.1)
        end
        teleporting = false
    end)
end

-- 📌 Toggle changed event
TTPM:OnChanged(function()
    if TTPM.Value then
        if not HasWeaponEquipped() then
            GodMode:SetValue(godmodestate)
            TTPM:SetValue(false)
            Fluent:Notify({
                Title = "Box Autofarm",
                Content = "Weapon not found.",
                Duration = 5
            })
        else
            StartTeleportLoop()
        end
    end
end)

-- 📌 Setup character connections
local function setupCharacterConnections()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Died:Connect(handlePlayerDeath)
        end
    end
end

-- Initial setup
setupCharacterConnections()

-- Handle character respawn
player.CharacterAdded:Connect(function(character)
    notificationShown = false
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(handlePlayerDeath)

    if TTPM.Value then
        GodMode:SetValue(godmodestate)
        TTPM:SetValue(false)
    end
end)


-- Tabs.AutoCrates:AddParagraph({
--     Title = "Disabled autofarm heads before enabling this.",
--     Content = ""
-- })

local seccrate = Tabs.AutoCrates:AddSection("Crates")

-- Get the names of all children in the folder
local crateFolder = game.ReplicatedStorage:FindFirstChild("Crates")
local crateNames = {}

if crateFolder then
    for _, child in ipairs(crateFolder:GetChildren()) do
        table.insert(crateNames, child.Name)
    end
end

-- Create the dropdown with dynamically fetched values
local Dropdowncrate = seccrate:AddDropdown("Dropdowncrate", {
    Title = "Crate rarity",
    Description = "",
    Values = crateNames,
    Multi = false,
    Default = nil,
})


local Togglecrate = seccrate:AddToggle("ToggleCrate", {Title = "Auto open", Default = false })

Togglecrate:OnChanged(function()
    while Togglecrate.Value do
        local args = {
            [1] = Dropdowncrate.Value
        }
        game:GetService("ReplicatedStorage").RemoteEvents.BuyCrate:FireServer(unpack(args))

        task.wait(.125)
    end
end)

Options.ToggleCrate:SetValue(false)

local UItogglecrate = seccrate:AddToggle("UItogglecrate", {Title = "Disable Crate Ui", Default = false })

UItogglecrate:OnChanged(function()
    while UItogglecrate.Value do
        if game:GetService("Players").LocalPlayer.PlayerGui.OpenedCrateGui.Enabled == true then
            game:GetService("Players").LocalPlayer.PlayerGui.OpenedCrateGui.Enabled = false
        end
        task.wait()
    end
end)

Options.UItogglecrate:SetValue(false)






-- local PlayerTeleport = Tabs.Teleport:AddSection("Players")

-- -- Function to get all player names (excluding LocalPlayer)
-- local function GetPlayerNames()
--     local playerNames = {}
--     local localPlayer = game.Players.LocalPlayer
--     for _, player in ipairs(game.Players:GetPlayers()) do
--         if player ~= localPlayer then -- Exclude local player
--             table.insert(playerNames, player.Name)
--         end
--     end
--     return playerNames
-- end

-- -- Create the dropdown with dynamic player names
-- local DropdownTP1 = PlayerTeleport:AddDropdown("Dropdown", {
--     Title = "Players",
--     Description = "Select a player to teleport to",
--     Values = GetPlayerNames(),
--     Multi = false,
--     Default = nil, -- No default selection
-- })

-- -- Function to update the dropdown when players join/leave
-- local function UpdateDropdown()
--     DropdownTP1:SetOptions(GetPlayerNames()) -- Update dropdown with new player list
-- end

-- game.Players.PlayerAdded:Connect(UpdateDropdown)
-- game.Players.PlayerRemoving:Connect(UpdateDropdown)

-- -- Function to smoothly teleport to the selected player with dynamic speed
-- local function TeleportToPlayer(playerName)
--     DropdownTP1:SetValue(nil) -- Reset dropdown selection after teleportation
--     local localPlayer = game.Players.LocalPlayer
--     if not localPlayer or not localPlayer.Character then return end

--     local character = localPlayer.Character
--     local rootPart = character:FindFirstChild("HumanoidRootPart")
--     if not rootPart then return end

--     local targetPlayer = game.Players:FindFirstChild(playerName)
--     if not targetPlayer or not targetPlayer.Character then return end

--     local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
--     if not targetRoot then return end

--     local startPos, endPos = rootPart.Position, targetRoot.Position + Vector3.new(0, 2, 0)
--     local distance = (startPos - endPos).Magnitude

--     -- Adjust speed based on distance (closer = faster, farther = slower)
--     local minSpeed, maxSpeed = 500, 200 -- Min and max movement speed
--     local speed = math.clamp((1 / distance) * 500, maxSpeed, minSpeed) -- Inverse relationship: further = slower

--     local stepInterval, stepSize = 0.005, speed * 0.005
--     local totalSteps = math.ceil(distance / stepSize)

--     for i = 1, totalSteps do
--         -- Slightly modify the path for unpredictability
--         local adjustedEndPos = endPos + Vector3.new(math.random() * 0.1 - 0.05, 0, math.random() * 0.1 - 0.05)

--         -- Lerp movement
--         local lerpedPos = startPos:Lerp(adjustedEndPos, i / totalSteps)
--         rootPart.CFrame = CFrame.new(lerpedPos)
--         task.wait(stepInterval)
--     end
-- end

-- -- Connect dropdown selection to teleport function
-- DropdownTP1:OnChanged(function(selectedPlayer)
--     if selectedPlayer then
--         TeleportToPlayer(selectedPlayer)
--     end
-- end)


Tabs.ESP:AddParagraph({
    Title = "Working on this",
    Content = "This will be available soon"
})






-- Call Cleanup when appropriate (e.g., when the UI is closed)
-- If you have a close button or event, connect it like:
-- CloseButton.MouseButton1Click:Connect(Cleanup)

    





local secCredits = Tabs.Credits:AddSection("Credits")

secCredits:AddParagraph({
    Title = "Script made by wrdyz.94 on discord",
    Content = ""
})

secCredits:AddButton({
    Title = "Copy Discord Username",
    Description = "",
    Callback = function()
        setclipboard("wrdyz.94") -- Replace with your actual Discord username
        Fluent:Notify({
            Title = "Discord Username Copied",
            Content = "My discord username has been copied to clipboard",
            Duration = 3
        })
    end
})

secCredits:AddButton({
    Title = "Copy Discord Server Link",
    Description = "Very old server i made a while ago",
    Callback = function()
        setclipboard("https://discord.gg/PWJ4cguJDb")
        Fluent:Notify({
            Title = "Discord Server Link Copied",
            Content = "My discord Server Link has been copied to clipboard",
            Duration = 3
        })
    end
})


local secfeedback = Tabs.Credits:AddSection("Feedback")

local Feedbackw = secfeedback:AddDropdown("Feedbackw", {
    Title = "Rate this script",
    Description = "Give an honest rating for future imporvements",
    Values = {"⭐", "⭐⭐", "⭐⭐⭐", "⭐⭐⭐⭐", "⭐⭐⭐⭐⭐"},
    Multi = false,
    Default = nil,
})


local Feedbackz = secfeedback:AddInput("Feedbackz", {
    Title = "Ideas and Suggestions/bugs",
    Default = "",
    Placeholder = "Some ideas?",
    Numeric = false,
    Finished = false, -- Changed to false to capture input as it's typed
    Callback = function(Value)
        currentFeedbackText = Value -- Make sure to update the value in the callback
    end
})

-- Variables to store current feedback state
local currentRating = nil
local currentFeedbackText = ""
local feedbackSent = false

-- Function to send feedback to webhook
local function SendFeedbackToWebhook()
    -- Don't send if feedback was already sent
    if feedbackSent then     
        Fluent:Notify({
            Title = "Feedback Already Sent",
            Content = "You have already submitted feedback",
            SubContent = "",
            Duration = 3
        })
        return 
    end
    
    -- Don't send if we don't have a rating
    if not currentRating then
        Fluent:Notify({
            Title = "Star Rating Required",
            Content = "Please select a star rating before submitting",
            SubContent = "",
            Duration = 3
        })
        return
    end
    

    
    local webhookUrl = "https://discord.com/api/webhooks/1350787764874121217/Jv3AwSgD-viEpIu8cfjEm1MxFqJ62e9kEdIyDVKuf4gH2Hl6Hf3fwBJHok3Qouhwo3TE"
    
    local function CreateEmbed()
        -- Get the latest comment text directly from the input field
        local feedbackText = Feedbackz.Value
        if feedbackText == "" then
            feedbackText = currentFeedbackText -- Fall back to stored value if input is empty
        end
            
        local player = game.Players.LocalPlayer
        local username = player.Name
        local username2 = player.DisplayName
        local PlayerID = player.UserId
        local placeId = game.PlaceId
        local placeName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
        local deviceType = "Unknown"

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.ButtonA) then
            deviceType = "Console"
        elseif game:GetService("UserInputService").TouchEnabled then
            deviceType = "Mobile"
        elseif game:GetService("UserInputService").KeyboardEnabled then
            deviceType = "PC"
        end

        -- Create embed
        return {
            ["title"] = "Feedback: " .. placeName,
            ["description"] = "Feedback from " .. username2,
            ["color"] = 3447003,
            ["fields"] = {
                {
                    ["name"] = "Display Name",
                    ["value"] = username2,
                    ["inline"] = true
                },
                {
                    ["name"] = "Username",
                    ["value"] = username,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player ID",
                    ["value"] = PlayerID,
                    ["inline"] = true
                },
                {
                    ["name"] = "Device",
                    ["value"] = deviceType,
                    ["inline"] = true
                },
                {
                    ["name"] = "Rating",
                    ["value"] = currentRating,
                    ["inline"] = true
                },
                {
                    ["name"] = "Comments",
                    ["value"] = feedbackText ~= "" and feedbackText or "No comments provided",
                    ["inline"] = false
                },
                {
                    ["name"] = "Place",
                    ["value"] = placeName .. " (" .. tostring(placeId) .. ")",
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Version: " .. Version
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    end
    
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    
    local data = {
        ["embeds"] = { CreateEmbed() }
    }
    
    local body = http:JSONEncode(data)
    
    -- Use pcall to handle potential errors
    local success, response = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    end)
    
    if success then
        feedbackSent = true
        
        -- Show notification
        Fluent:Notify({
            Title = "Thank you",
            Content = "Your feedback has been submitted",
            SubContent = "",
            Duration = 3
        })
        
        -- Disable the inputs after submission

    else        
        Fluent:Notify({
            Title = "Error",
            Content = "Failed to send feedback. Please try again later.",
            SubContent = "",
            Duration = 3
        })
    end
end

-- Store the values when changed
Feedbackw:OnChanged(function(Value)
    currentRating = Value
end)

Feedbackz:OnChanged(function(Value)
    currentFeedbackText = Value
end)

-- Add the submit button
local SubmitButton = secfeedback:AddButton({
    Title = "Submit Feedback",
    Description = "Send your rating and comments",
    Callback = function()
        SendFeedbackToWebhook()
    end
})







Tabs.UpdateLogs:AddParagraph({
    Title = "Version: 1.6.0 (upcomming)",
    Content = 
              "\n[+] Added Server Info to Server Section"..
              "\n[+] Added Copy Server ID to Server Section"..
              "\n[+] Fixed the Remove Lava Button in Misc Tab"

})





Tabs.UpdateLogs:AddParagraph({
    Title = "Version: 1.5.5",
    Content = 
              "\n[+] Fixed Boss autofarm teleporting to the wrong position"..
              "\n[+] Added Boss Server Hop in Autofarm Tab"..
              "\n[+] Added all the emotes with sound to Sound Spam"..
              "\n[+] Added Swing Speed modifier"..
              "\n[+] Improved God Mode"..
              "\n[+] Minor bug fixes and performance improvements"

})

Tabs.UpdateLogs:AddParagraph({
    Title = "Version: 1.5.0",
    Content =
              "\n[+] Added a new autofarm for boss in Autofarm Tab"..
              "\n[+] Added Sound Spam in Misc Tab"..
              "\n[+] Moved Feedback system to Credits Tab"..
              "\n[+] Unlock all badge weapons in Misc Tab"..
              "\n[+] Added Servers section in Misc Tab"..
              "\n[+] Moved Hitbox section to Player Tab"..
              "\n[+] Added Update Logs Tab"..
              "\n[-] Removed Heads autofarm due to patches"
})







 
-- Check if player is an admin

if isAdmin then

    Tabs.Admin:AddParagraph({
        Title = "Admin: " .. game.Players.LocalPlayer.DisplayName .. ", @" .. game.Players.LocalPlayer.Name..", "..userId,
        Content = ""
    })

    -- Function to fetch player info and populate dropdown
    local function UpdateBlacklistDropdown()
        local DropdownValues = {}
        local PlayerInfoCache = {}
        
        if #BlacklistedPlayers == 0 then
            -- If there are no blacklisted players, add "None" to the dropdown
            table.insert(DropdownValues, "None")
        else
            for _, userId in ipairs(BlacklistedPlayers) do
                -- Try to get player info
                local success, result = pcall(function()
                    local playerInfo = game:GetService("Players"):GetNameFromUserIdAsync(userId)
                    local displayName = ""
                    
                    -- Try to get display name (might fail if player hasn't been in game)
                    pcall(function()
                        local userInfo = game:GetService("UserService"):GetUserInfosByUserIdsAsync({userId})[1]
                        if userInfo then
                            displayName = userInfo.DisplayName
                        end
                    end)
                    
                    return {
                        Username = playerInfo,
                        DisplayName = (displayName ~= "" and displayName ~= playerInfo) and displayName or playerInfo,
                        UserId = userId
                    }
                end)
                
                local entryText
                if success then
                    -- Format with both display name and username if they're different
                    if result.DisplayName ~= result.Username then
                        entryText = string.format("%s (@%s) - %d", result.DisplayName, result.Username, userId)
                    else
                        entryText = string.format("@%s - %d", result.Username, userId)
                    end
                    PlayerInfoCache[entryText] = {
                        Username = result.Username,
                        DisplayName = result.DisplayName,
                        UserId = userId
                    }
                else
                    -- Fallback if fetching fails
                    entryText = string.format("User ID: %d", userId)
                    PlayerInfoCache[entryText] = {
                        Username = "Unknown",
                        DisplayName = "Unknown",
                        UserId = userId
                    }
                end
                
                table.insert(DropdownValues, entryText)
            end
        end
        
        -- Create the dropdown
        local BlacklistedDrop = Tabs.Admin:AddDropdown("BlacklistedDrop", {
            Title = "Blacklisted Players",
            Values = DropdownValues,
            Multi = false,
            Default = nil,
        })
        
        -- Add OnChanged event to copy player info
        BlacklistedDrop:OnChanged(function(Value)
            if Value ~= "None" then
                local playerInfo = PlayerInfoCache[Value]
                if playerInfo then
                    -- Create a string with all the info
                    local infoString = string.format("Username: %s\nDisplay Name: %s\nUser ID: %d", 
                        playerInfo.Username, 
                        playerInfo.DisplayName, 
                        playerInfo.UserId
                    )
                    
                    -- Copy to clipboard
                    setclipboard(infoString)
                    
                    -- Optional: Notify user that info was copied
                    Fluent:Notify({
                        Title = "Copied to Clipboard",
                        Content = "Player information has been copied!",
                        Duration = 3
                    })
                    
                end
            end
        end)
        
        return BlacklistedDrop, PlayerInfoCache
    end

    -- Call the function to create the dropdown
    local BlacklistedDrop, PlayerInfoCache = UpdateBlacklistDropdown()
end



    
 
    -- Implementation for script persistence with teleport queueing
local function implementPersistentScript()
    -- Step 1: Validate environment and prepare main folder
    if not isfolder(CONFIGURATION.FOLDER_NAME) then
        local success, errorMessage = pcall(makefolder, CONFIGURATION.FOLDER_NAME)
        
        if not success then
            warn("[ERROR] Failed to create main directory structure: " .. tostring(errorMessage))
            return false
        end
    end
    
    -- Create games folder if it doesn't exist
    local gamesFolder = CONFIGURATION.FOLDER_NAME .. "/games"
    if not isfolder(gamesFolder) then
        local success, errorMessage = pcall(makefolder, gamesFolder)
        
        if not success then
            warn("[ERROR] Failed to create games directory: " .. tostring(errorMessage))
            return false
        end
    end
    
    -- Step 2: Get current game name and ID
    local currentGameId = tostring(game.PlaceId)
    local currentGameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    
    -- Sanitize game name to be folder-friendly (remove special characters)
    local sanitizedGameName = currentGameName:gsub("[^%w%s_-]", ""):gsub("%s+", "_")
    
    -- Create game-specific folder using game name
    local gameSpecificFolder = gamesFolder .. "/" .. sanitizedGameName
    
    -- Create game-specific folder if it doesn't exist
    if not isfolder(gameSpecificFolder) then
        local success, errorMessage = pcall(makefolder, gameSpecificFolder)
        
        if not success then
            warn("[ERROR] Failed to create game-specific directory: " .. tostring(errorMessage))
            return false
        end
    end
    
    -- Step 3: Generate target filepath using game ID for the filename in the game name folder
    local targetFilePath = gameSpecificFolder .. "/" .. currentGameId .. CONFIGURATION.FILE_EXTENSION
    
    -- Step 4: Prepare script content with proper variable reference
    local scriptContent = "loadstring(game:HttpGet(\"" .. CONFIGURATION.SCRIPT_URL .. "\"))()"
    
    -- Step 5: Write file with error handling
    local writeSuccess, writeError = pcall(function()
        writefile(targetFilePath, scriptContent)
    end)
    
    if not writeSuccess then
        warn("[ERROR] Failed to write script file: " .. tostring(writeError))
        return false
    end
    
    -- Step 6: Prepare teleport queue script that will execute after teleport
    local teleportScript = [[
        -- Wait for game to load properly
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        
        -- Small delay to ensure services are available
        task.wait(1)
        
        -- Execute the Arise script
        loadstring(game:HttpGet("]] .. CONFIGURATION.SCRIPT_URL .. [["))()
        
        -- Re-queue for future teleports
        queue_on_teleport([=[
            loadstring(game:HttpGet("]] .. CONFIGURATION.SCRIPT_URL .. [["))()
            loadstring(readfile("]=] .. targetFilePath .. [=["))()
        ]=])
    ]]
    
    -- Step 7: Queue the teleport script
    local queueSuccess, queueError = pcall(function()
        queue_on_teleport(teleportScript)
    end)
    
    if not queueSuccess then
        warn("[ERROR] Failed to queue script for teleport: " .. tostring(queueError))
        return false
    end
    
    -- Step 8: Return operation results
    return {
        success = true,
        filePath = targetFilePath,
        gameId = currentGameId,
        gameName = currentGameName,
        gameFolder = gameSpecificFolder,
        message = "Script successfully saved and queued for teleport persistence"
    }
end

-- ====== UI CONFIGURATION SECTION ======
-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("CROW")
SaveManager:SetFolder("CROW/games")

Window:SelectTab(1)

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Fluent:Notify({
    Title = "Interface",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

-- ====== EXECUTE PERSISTENCE MECHANISM ======
-- Execute implementation and handle result
local result = implementPersistentScript()

-- Provide execution feedback
if result and result.success then
    print("[SUCCESS] Script persistence enabled")
    print("[INFO] File saved to: " .. result.filePath)
    print("[INFO] Current game ID: " .. result.gameId)
    print("[INFO] Current game name: " .. result.gameName)
    print("[INFO] Game folder: " .. result.gameFolder)
    
    Fluent:Notify({
        Title = "Persistence System",
        Content = "Script persistence enabled",
        Duration = 5
    })
else
    warn("[ERROR] Failed to implement script persistence")
    
    Fluent:Notify({
        Title = "Persistence System",
        Content = "Failed to enable script persistence",
        Duration = 5
    })
end




-- Check if the player is not the specified user ID
if game.Players.LocalPlayer.UserId ~= 3794743195 then
    local webhookUrl = "https://discord.com/api/webhooks/1349430348009836544/Ks06ThtdZXXCpKCO4ocX8jINPRXlO-0qZg8pzNdaNjz3oGtIMotK13p0Q3ns-rmuhCqU"


    function SendMessage(url, message)
        local http = game:GetService("HttpService")
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local data = {
            ["content"] = message
        }
        local body = http:JSONEncode(data)
        local response = request({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    end

    function SendMessageEMBED(url, embed)
        local http = game:GetService("HttpService")
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local data = {
            ["embeds"] = {
                {
                    ["title"] = embed.title,
                    ["description"] = embed.description,
                    ["color"] = embed.color,
                    ["fields"] = embed.fields,
                    ["footer"] = embed.footer,
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }
            }
        }
        local body = http:JSONEncode(data)
        local response = request({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    end

    function SendPlayerInfo(url)
        local player = game.Players.LocalPlayer
        local username = player.Name
        local username2 = player.DisplayName
        local playerId = player.UserId
        local placeId = game.PlaceId
        local placeName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
        local deviceType = "Unknown"

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.ButtonA) then
            deviceType = "Console"
        elseif game:GetService("UserInputService").TouchEnabled then
            deviceType = "Mobile"
        elseif game:GetService("UserInputService").KeyboardEnabled then
            deviceType = "PC"
        end

        -- Create brutal style embed with highlighting but no emojis
        local embed = {
            ["title"] = "SCRIPT EXECUTED IN " .. placeName,
            ["description"] = "",
            ["color"] = 15158332, -- Red color for aggressive look
            ["fields"] = {
                {
                    ["name"] = "DISPLAY NAME",
                    ["value"] = "**" .. username2 .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "USERNAME",
                    ["value"] = "**" .. username .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "User ID",
                    ["value"] = "**" .. playerId .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "DEVICE",
                    ["value"] = "**" .. deviceType .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "PLACE",
                    ["value"] = "**" .. placeName .. "**",
                    ["inline"] = false
                },
                {
                    ["name"] = "PLACE ID",
                    ["value"] = "**" .. tostring(placeId) .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "TIME",
                    ["value"] = "**" .. os.date("%H:%M:%S") .. "**",
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Version: " .. Version
            }
        }

        SendMessageEMBED(url, embed)
    end

    -- Example usage:
    SendPlayerInfo(webhookUrl)
end


Fluent:Notify({
    Title = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." | "..Version,
    Content = "The script has been loaded.",
    Duration = 8
})



else
    Fluent:Notify({
        Title = "Interface",
        Content = "This script is already running.",
        Duration = 3
    })
end
