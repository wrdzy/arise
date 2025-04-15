--loadstring(game:HttpGet("https://raw.githubusercontent.com/wrdzy/arise/refs/heads/main/Arise.lua"))()

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
local Version = "Final"

-- ====== PERSISTENCE MECHANISM ======
-- Constants for configuration management
local CONFIGURATION = {
    FOLDER_NAME = "CROW",
    SCRIPT_URL = "https://raw.githubusercontent.com/wrdzy/arise/refs/heads/main/Arise.lua",
    FILE_EXTENSION = ".lua"
}




if _G.Interface == nil then
_G.Interface = true



    
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
    World = Window:AddTab({ Title = "World", Icon = "compass" }),
    Autofarm = Window:AddTab({ Title = "Autofarm", Icon = "repeat" }),
    Servers = Window:AddTab({ Title = "Servers", Icon = "server" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "book" }),
    UpdateLogs = Window:AddTab({ Title = "Update Logs", Icon = "scroll" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

if isAdmin then
    Tabs.Admin = Window:AddTab({ Title = "Admin", Icon = "shield" })
end





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
        Max = basespeed * 10,
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
        Max = basejump * 6,
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


    local secHitbox = Tabs.Player:AddSection("Enemy Hitbox")

local hitcolor = secHitbox:AddColorpicker("hitcolor", {
    Title = "Hitbox color",
    Transparency = 0,
    Default = Color3.fromRGB(255, 0, 0)
})

-- Table to store original Hitbox sizes
local OriginalSizes = {}

-- Function to safely get the default size of an enemy Hitbox
local function GetDefaultHitboxSize()
    local enemiesFolder = workspace.__Main.__Enemies.Client
    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") then
            local hitbox = enemy:FindFirstChild("Hitbox")
            if hitbox then
                return hitbox.Size.X
            end
        end
    end
    return 5 -- Fallback size
end

-- Set default size based on existing enemy (if available)
local DefaultHitboxSize = GetDefaultHitboxSize()
local HitboxSize = DefaultHitboxSize -- Current hitbox size (modifiable via slider)
local HitboxEnabled = false -- Track if hitbox resizing is enabled

-- Function to resize hitboxes for an enemy
local function ResizeHitboxForEnemy(enemy)
    if not HitboxEnabled then return end

    local hitbox = enemy:FindFirstChild("Hitbox")
    if hitbox then
        -- Store original size before resizing
        if not OriginalSizes[enemy] then
            OriginalSizes[enemy] = hitbox.Size
        end

        local newSize = Vector3.new(HitboxSize, HitboxSize, HitboxSize)

        hitbox.Size = newSize
        hitbox.Transparency = 1 -- Make it invisible

        -- Add visualizer if not already present
        local hitboxVisualizer = hitbox:FindFirstChild("HitboxVisualizer")
        if not hitboxVisualizer then
            hitboxVisualizer = Instance.new("SelectionBox")
            hitboxVisualizer.Name = "HitboxVisualizer"
            hitboxVisualizer.Adornee = hitbox
            hitboxVisualizer.Parent = hitbox

            -- Set initial color when visualizer is created
            local color = hitcolor.Value
            local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
            
            hitboxVisualizer.Color3 = Color3.fromRGB(r, g, b)
            hitboxVisualizer.SurfaceColor3 = Color3.fromRGB(r, g, b)
            
            hitboxVisualizer.SurfaceTransparency = 1 -- Outline only, matching player script
            hitboxVisualizer.LineThickness = 0.1
        end
    end
end

-- Function to reset hitbox to original size
local function RevertHitboxSize(enemy)
    local hitbox = enemy:FindFirstChild("Hitbox")
    if hitbox and OriginalSizes[enemy] then
        hitbox.Size = OriginalSizes[enemy] -- Reset size
        hitbox.Transparency = 1 -- Restore transparency
        
        -- Remove hitbox visualizer if it exists
        local hitboxVisualizer = hitbox:FindFirstChild("HitboxVisualizer")
        if hitboxVisualizer then
            hitboxVisualizer:Destroy()
        end
    end
end

-- Function to resize all enemies
local function ApplyHitboxResizing()
    local enemiesFolder = workspace.__Main.__Enemies.Client
    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") then
            ResizeHitboxForEnemy(enemy)
        end
    end
end

-- Function to update the color of the hitbox visualizer for all enemies
local function UpdateHitboxColor()
    local color = hitcolor.Value
    local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)

    -- Iterate through all enemies and update their visualizers
    local enemiesFolder = workspace.__Main.__Enemies.Client
    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") then
            local hitbox = enemy:FindFirstChild("Hitbox")
            if hitbox then
                local hitboxVisualizer = hitbox:FindFirstChild("HitboxVisualizer")
                if hitboxVisualizer then
                    hitboxVisualizer.Color3 = Color3.fromRGB(r, g, b)
                    hitboxVisualizer.SurfaceColor3 = Color3.fromRGB(r, g, b)
                    hitboxVisualizer.Transparency = hitcolor.Transparency
                end
            end
        end
    end
end

-- Handle new enemies being added to the workspace
local enemiesFolder = workspace.__Main.__Enemies.Client
enemiesFolder.ChildAdded:Connect(function(enemy)
    task.wait(0.5) -- Give time for the enemy to fully load
    if HitboxEnabled and enemy:IsA("Model") then
        ResizeHitboxForEnemy(enemy)
    end
end)

-- UI Elements (Initialized AFTER variables are defined)
local SliderHitboxSize = secHitbox:AddSlider("SliderHitboxSize", {
    Title = "Enemy Hitbox Size",
    Description = "",
    Default = DefaultHitboxSize,
    Min = 10,  -- Minimum size, matching player script
    Max = 70, -- Maximum size, matching player script
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

-- Toggle to enable/disable hitbox resizing
local ToggleHitboxResize = secHitbox:AddToggle("ToggleHitboxResize", {
    Title = "Enemy Hitbox Expander",
    Default = false
})

-- Toggle behavior
ToggleHitboxResize:OnChanged(function(Value)
    if Value == nil then return end -- Prevent nil value errors

    HitboxEnabled = Value

    if HitboxEnabled then
        ApplyHitboxResizing() -- Apply resizing if enabled
    else
        -- Revert all enemies to their original hitbox sizes
        local enemiesFolder = workspace.__Main.__Enemies.Client
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") then
                RevertHitboxSize(enemy)
            end
        end
        
        -- Clean up any orphaned visualizers
        for _, descendant in pairs(enemiesFolder:GetDescendants()) do
            if descendant.Name == "HitboxVisualizer" then
                descendant:Destroy()
            end
        end
    end
end)

-- Update color whenever the colorpicker value changes
hitcolor:OnChanged(function()
    UpdateHitboxColor()

end)
















local Teleport = Tabs.World:AddSection("World")

-- Function to populate dropdown with spawn point names and custom locations
local function PopulateSpawnDropdown()
    local spawnNames = {}

    -- Add your custom locations here
    table.insert(spawnNames, "Guild Hall")
    table.insert(spawnNames, "Jeju Island")

    -- Add spawn locations from the folder
    local spawnFolder = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Spawns")
    if spawnFolder then
        for _, spawn in pairs(spawnFolder:GetChildren()) do
            if spawn:IsA("BasePart") then
                table.insert(spawnNames, spawn.Name)
            end
        end
    end

    return spawnNames
end

-- Create dropdown with initial values
local droptp = Teleport:AddDropdown("droptp", {
    Title = "Teleport to Spawn:",
    Values = PopulateSpawnDropdown(),
    Multi = false,
    Default = nil,
})

-- Instant teleport function (with retry in case of reset)
local function InstantTeleport(targetPosition)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    if hrp then
        local finalPos = targetPosition + Vector3.new(0, 5, 0)

        -- Initial teleport
        hrp.CFrame = CFrame.new(finalPos)

        -- Small delay, then ensure we didn't get snapped back
        task.wait(0.1)
        if (hrp.Position - finalPos).Magnitude > 10 then
            hrp.CFrame = CFrame.new(finalPos)
        end
    end
end

-- Dropdown selection event
-- Teleport handler for dropdown selection
droptp:OnChanged(function(Value)
    local mainWorld = workspace.__Main and workspace.__Main:FindFirstChild("__World")
    local extra = workspace:FindFirstChild("__Extra")

    -- Guild Hall teleportation via touch interest
    if Value == "Guild Hall" then
        local guildHall = mainWorld and mainWorld:FindFirstChild("GuildHall")
        if guildHall then
            -- Find the touch part in the expected path
            local touchPart = extra and 
                             extra:FindFirstChild("GuildTPs") and
                             extra.GuildTPs:FindFirstChild("Main")
            
            if touchPart then
                -- Execute touch sequence
                local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    firetouchinterest(hrp, touchPart, 0) -- Begin touch
                    task.wait(0.05)                      -- Minimal wait time
                    firetouchinterest(hrp, touchPart, 1) -- End touch
                end
            end
        end
        return
        
    -- Jeju Island direct teleportation
    elseif Value == "Jeju Island" then
        local jejuWorld = mainWorld and mainWorld:FindFirstChild("World Jeju")
        if jejuWorld then
            InstantTeleport(jejuWorld:GetPivot().Position)
        end
        return
    end

    -- Generic spawn folder location teleportation
    local spawnFolder = extra and extra:FindFirstChild("__Spawns")
    if spawnFolder then
        for _, spawn in pairs(spawnFolder:GetChildren()) do
            if spawn:IsA("BasePart") and spawn.Name == Value then
                InstantTeleport(spawn.Position)
                break
            end
        end
    end
end)

-- Auto-update dropdown if spawn points change
local function UpdateSpawnDropdown()
    droptp:SetValues(PopulateSpawnDropdown())
end

local spawnFolder = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Spawns")
if spawnFolder then
    spawnFolder.ChildAdded:Connect(UpdateSpawnDropdown)
    spawnFolder.ChildRemoved:Connect(UpdateSpawnDropdown)
end



local setspawn = Tabs.World:AddSection("Spawn")


-- Function to populate dropdown with spawn point names and custom locations
local function PopulateSpawnDropdown()
    local spawnNames = {}
    -- Add spawn locations from the folder
    local spawnFolder = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Spawns")
    if spawnFolder then
        for _, spawn in pairs(spawnFolder:GetChildren()) do
            if spawn:IsA("BasePart") then
                table.insert(spawnNames, spawn.Name)
            end
        end
    end

    return spawnNames
end




-- Create dropdown with initial values
local spawndrop = setspawn:AddDropdown("spawndrop", {
    Title = "Set Spawn:",
    Values = PopulateSpawnDropdown(),
    Multi = false,
    Default = nil,
})


spawndrop:OnChanged(function(Value)
    local args = {
        [1] = {
            [1] = {
                ["Event"] = "ChangeSpawn",
                ["Spawn"] = Value
            },
            [2] = "\n"
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
    
end)






































    local secautogeneral = Tabs.Autofarm:AddSection("Global")



-- Auto Hit
local autohit = secautogeneral:AddToggle("autohit", {Title = "Auto Hit", Default = false})

autohit:OnChanged(function()
    if autohit.Value then
        -- Run in a separate task to prevent blocking
            while autohit.Value do
                -- Dynamically find the closest enemy
                local closestEnemy = nil
                local closestDistance = math.huge  -- Start with a large value for distance

                -- Get the player's character
                local player = game.Players.LocalPlayer
                local playerCharacter = player.Character or player.CharacterAdded:Wait()
                local playerPosition = playerCharacter:WaitForChild("HumanoidRootPart").Position

                -- Iterate through all enemies in the game
                for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                        -- Calculate the distance to the player
                        local enemyPosition = enemy:FindFirstChild("HumanoidRootPart").Position
                        local distance = (playerPosition - enemyPosition).magnitude

                        -- If this enemy is closer than the previous one, select it
                        if distance < closestDistance then
                            closestEnemy = enemy
                            closestDistance = distance
                        end
                    end
                end

                -- If we found a valid closest enemy, send the PunchAttack event
                if closestEnemy then
                    local args = {
                        [1] = {
                            [1] = {
                                ["Event"] = "PunchAttack",
                                ["Enemy"] = closestEnemy.Name  -- Use the dynamically found enemy's name
                            },
                            [2] = "\4"
                        }
                    }

                    -- Fire the event to hit the closest enemy
                    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                end

                -- Wait before checking for the next enemy
                task.wait()
            end
    end
end)

-- Auto Arise
local autoarise = secautogeneral:AddToggle("autoarise", {Title = "Auto Arise", Default = false})

autoarise:OnChanged(function()
    if autoarise.Value then
        -- Run in a separate task to prevent blocking
            while autoarise.Value do
                -- Dynamically find the closest enemy with 0 HP
                local closestEnemy = nil
                local closestDistance = math.huge  -- Start with a large value for distance

                -- Get the player's character
                local player = game.Players.LocalPlayer
                local playerCharacter = player.Character or player.CharacterAdded:Wait()
                local playerPosition = playerCharacter:WaitForChild("HumanoidRootPart").Position

                -- Iterate through all enemies in the game
                for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                        local healthBar = enemy:FindFirstChild("HealthBar")
                        local main = healthBar and healthBar:FindFirstChild("Main")
                        local title = main and main:FindFirstChild("Title")
                        local bar = main and main:FindFirstChild("Bar")
                        local amount = bar and bar:FindFirstChild("Amount")

                        if title and amount and title:IsA("TextLabel") and amount:IsA("TextLabel") then
                            local hp = tonumber(string.match(amount.Text, "(%d+)"))
                            if hp and hp == 0 then  -- Only consider enemies with 0 HP
                                -- Calculate the distance to the player
                                local enemyPosition = enemy:FindFirstChild("HumanoidRootPart").Position
                                local distance = (playerPosition - enemyPosition).magnitude

                                -- If this enemy is closer than the previous one, select it
                                if distance < closestDistance then
                                    closestEnemy = enemy
                                    closestDistance = distance
                                end
                            end
                        end
                    end
                end

                -- If we found a valid closest enemy, send the capture event
                if closestEnemy then
                    local args = {
                        [1] = {
                            [1] = {
                                ["Event"] = "EnemyCapture",
                                ["Enemy"] = closestEnemy.Name  -- Use the dynamically found enemy's name
                            },
                            [2] = "\4"
                        }
                    }

                    -- Fire the event to capture the closest enemy with 0 HP
                    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                end

                -- Wait before checking for the next enemy
                task.wait()
            end
    end
end)

-- Auto Destroy
local autodestroy = secautogeneral:AddToggle("autodestroy", {Title = "Auto Destroy", Default = false})

autodestroy:OnChanged(function()
    if autodestroy.Value then
        -- Run in a separate task to prevent blocking
            while autodestroy.Value do
                -- Dynamically find the closest enemy
                local closestEnemy = nil
                local closestDistance = math.huge  -- Start with a large value for distance

                -- Get the player's character
                local player = game.Players.LocalPlayer
                local playerCharacter = player.Character or player.CharacterAdded:Wait()
                local playerPosition = playerCharacter:WaitForChild("HumanoidRootPart").Position

                -- Iterate through all enemies in the game
                for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                        -- Calculate the distance to the player
                        local enemyPosition = enemy:FindFirstChild("HumanoidRootPart").Position
                        local distance = (playerPosition - enemyPosition).magnitude

                        -- If this enemy is closer than the previous one, select it
                        if distance < closestDistance then
                            closestEnemy = enemy
                            closestDistance = distance
                        end
                    end
                end

                -- If we found a valid closest enemy, send the EnemyDestroy event
                if closestEnemy then
                    local args = {
                        [1] = {
                            [1] = {
                                ["Event"] = "EnemyDestroy",
                                ["Enemy"] = closestEnemy.Name  -- Use the dynamically found enemy's name
                            },
                            [2] = "\4"
                        }
                    }

                    -- Fire the event to destroy the closest enemy
                    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                end

                -- Wait before checking for the next enemy
                task.wait()
            end
    end
end)















    -- Dropdown UI setup
    local secautofarm = Tabs.Autofarm:AddSection("Mobs")




    local selectedEnemies = {}
    local currentMobGroups = {}
    local detectionRange = 1000  -- Increased detection range significantly
    
    local MobDrop = secautofarm:AddDropdown("MobDrop", {
        Title = "Choose Mobs to Farm",
        Values = {},
        Multi = true,
        Default = {},
    })
    
    -- Function to check if the enemy is valid
    local function isValidTarget(enemy)
        local healthBar = enemy:FindFirstChild("HealthBar")
        local main = healthBar and healthBar:FindFirstChild("Main")
        local title = main and main:FindFirstChild("Title")
        local bar = main and main:FindFirstChild("Bar")
        local amount = bar and bar:FindFirstChild("Amount")
        local avatar = main and main:FindFirstChild("Avatar")
        local levelText = avatar and avatar:FindFirstChild("LevelText")
    
        if not (title and amount) then return false end
        if not amount:IsA("TextLabel") or not title:IsA("TextLabel") then return false end
    
        local hp = tonumber(string.match(amount.Text, "(%d+)"))
        if not (hp and hp > 0) then return false end
        
        -- Get enemy group key based only on name and level (ignoring health)
        local name = title.Text
        local level = levelText and levelText:IsA("TextLabel") and levelText.Text or "Unknown"
        local groupKey = name .. " [Lv." .. level .. "]"
        
        return table.find(selectedEnemies, groupKey)
    end
    
    -- Trigger the attack event to target the enemy
    local function triggerAttack(enemy)
        local player = game.Players.LocalPlayer
        local userId = tostring(player.UserId)
        local userFolder = workspace.__Main.__Pets:FindFirstChild(userId)
        if not userFolder then return false end
    
        local currentPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
        if not currentPos then return false end
    
        local offset = 5
    
        -- Loop through all pets and fire one event per pet
        for _, pet in ipairs(userFolder:GetChildren()) do
            local petPos = {}
    
            -- Calculate pet position relative to the player's position
            petPos[pet.Name] = Vector3.new(
                currentPos.X + math.random(-offset, offset),
                currentPos.Y,
                currentPos.Z + math.random(-offset, offset)
            )
    
            -- Create the args for the specific pet
            local args = {
                [1] = {
                    [1] = {
                        ["PetPos"] = petPos,  -- Position of the current pet
                        ["AttackType"] = "All",  -- Assuming attack type is "All"
                        ["Event"] = "Attack",
                        ["Enemy"] = enemy.Name  -- Target enemy
                    },
                    [2] = "\t"
                }
            }
    
            -- Send the event for the specific pet
            game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
            
            -- Wait a small amount of time before firing the next event
            task.wait(.8)
        end
    
        return true
    end
    
    
    
    
    
    -- Teleport the player to a randomly selected enemy using Lerp and trigger attack
    local function teleportToRandomEnemy()
        local validEnemies = {}
        
        -- Collect all valid enemies in the expanded detection range
        for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                local player = game.Players.LocalPlayer
                local char = player.Character or player.CharacterAdded:Wait()
                local distance = (enemy.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                
                -- Check if enemy is within the detection range
                if distance <= detectionRange and isValidTarget(enemy) then
                    table.insert(validEnemies, enemy)
                end
            end
        end
    
        if #validEnemies == 0 then return false end
    
        local targetEnemy = validEnemies[math.random(1, #validEnemies)]
    
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
        local targetRootPart = targetEnemy:FindFirstChild("HumanoidRootPart")
    
        if targetRootPart then
            char.HumanoidRootPart.Anchored = true
    
            local targetPosition = targetRootPart.Position + Vector3.new(5, 0, 0)
            local currentPosition = humanoidRootPart.Position
            local lerpDuration = 1
            local startTime = tick()
    
            local function lerpToPosition()
                local elapsedTime = tick() - startTime
                local lerpFactor = math.min(elapsedTime / lerpDuration, 1)
                humanoidRootPart.CFrame = CFrame.new(currentPosition:Lerp(targetPosition, lerpFactor))
    
                if lerpFactor < 1 then
                    task.wait(0.03)
                    lerpToPosition()
                else
                    char.HumanoidRootPart.Anchored = false
                    triggerAttack(targetEnemy)
                end
            end
    
            lerpToPosition()
    
            while targetEnemy:FindFirstChild("HealthBar") and targetEnemy.HealthBar:FindFirstChild("Main") do
                local healthBar = targetEnemy.HealthBar.Main
                local amount = healthBar:FindFirstChild("Bar") and healthBar.Bar:FindFirstChild("Amount")
    
                if amount and amount:IsA("TextLabel") then
                    local health = tonumber(string.match(amount.Text, "(%d+)"))
                    if health and health <= 0 then break end
                end
    
                task.wait(1)
            end
        end
    
        return true
    end
    
    -- Autofarm loop with slight optimization
    local function runAutofarm()
        while farmRunning do
            if #selectedEnemies > 0 then
                teleportToRandomEnemy()
                task.wait()
            else
                task.wait(1)
            end
        end
    end
    
    -- Dropdown change listener
    MobDrop:OnChanged(function(valueTable)
        selectedEnemies = {}
        for value, isSelected in pairs(valueTable) do
            if isSelected then
                table.insert(selectedEnemies, value)
            end
        end
    end)
    
    -- Toggle to run autofarm
    local automob = secautofarm:AddToggle("automob", {
        Title = "Autofarm Selected Mobs",
        Default = false
    })
    
    farmRunning = false
    farmThread = nil
    
    automob:OnChanged(function()
        if automob.Value then
            if farmRunning then return end
            farmRunning = true
            farmThread = task.spawn(runAutofarm)
        else
            farmRunning = false
            if farmThread then
                task.cancel(farmThread)
                farmThread = nil
            end
        end
    end)
    
    -- Function to get enemy level and name from health bar
    local function getEnemyLevelAndName(enemy)
        local healthBar = enemy:FindFirstChild("HealthBar")
        local main = healthBar and healthBar:FindFirstChild("Main")
        local title = main and main:FindFirstChild("Title")
        local avatar = main and main:FindFirstChild("Avatar")
        local levelText = avatar and avatar:FindFirstChild("LevelText")
        
        if title and title:IsA("TextLabel") then
            local name = title.Text
            local level = "Unknown"
            
            if levelText and levelText:IsA("TextLabel") then
                level = levelText.Text
            end
            
            -- Create a group key based on the enemy name and level only
            local groupKey = name .. " [Lv." .. level .. "]"
            
            return {
                name = name,
                level = level,
                groupKey = groupKey
            }
        end
        
        return nil
    end
    
    -- Function to get all enemy types and update dropdown
    local function updateMobDropdown()
        local enemyTypes = {}
        local seen = {}
        
        for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
            if enemy:IsA("Model") then
                local enemyInfo = getEnemyLevelAndName(enemy)
                if enemyInfo and enemyInfo.groupKey then
                    if not seen[enemyInfo.groupKey] then
                        table.insert(enemyTypes, enemyInfo.groupKey)
                        seen[enemyInfo.groupKey] = true
                    end
                end
            end
        end
        
        table.sort(enemyTypes)
        currentMobGroups = enemyTypes
        MobDrop:SetValues(currentMobGroups)
    end
    
    -- Initial update when the script loads
    task.spawn(function()
        task.wait(1) -- Allow the game to initialize first
        updateMobDropdown()
    end)
    

    secautofarm:AddButton({
        Title = "Refresh Enemy list",
        Callback = function()
            updateMobDropdown()
        end
    })
 





    










    




    local autoevent = Tabs.Autofarm:AddSection("Event")
    local selectedEvents = {}
    
    local eventDropdown = autoevent:AddDropdown("eventSelect", {
        Title = "Select Events",
        Values = { "Dungeons", "Mounts", "Raid", "Castle" },
        Multi = true,
        Default = {},
    })
    
    eventDropdown:OnChanged(function(value)
        selectedEvents = {}
        for k, v in pairs(value) do
            if v then
                table.insert(selectedEvents, k)
            end
        end
    end)
    
    local mountLocations = {
        CFrame.new(539.4, 176.48, 886.29),
        CFrame.new(3300.52, 84.41, 18.95),
        CFrame.new(443.20, 61.86, 3337.68),
        CFrame.new(-3042.75, 138.46, 3443.81),
        CFrame.new(-3759.01, 130.27, 3389.78),
        CFrame.new(-3881.89, 124.43, 1997.91),
        CFrame.new(-5867.49, 80.89, 412.10),
        CFrame.new(-664.85, 96.61, -3598.44),
        CFrame.new(4281.31, 58.57, -4735.80),
        CFrame.new(-6138.31, 84.79, 5462.36)
    }
    
    local function rawTeleport(cframe)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = cframe
            return true
        end
        return false
    end
    
    local function teleportToSameLocationTwice(cframe)
        for i = 1, 3 do
            rawTeleport(cframe)
            task.wait(0.15)
        end
    end
    
    local function interactWithMountPrompt(mount)
        local prompt = mount:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            task.wait(2)
            fireproximityprompt(prompt)
        end
    end
    
    local function teleportToMountAndInteract(location)
        teleportToSameLocationTwice(location)
        task.wait(2)
    
        local mounts = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Appear")
        if mounts and #mounts:GetChildren() > 0 then
            local mount = mounts:GetChildren()[1]
            if mount then
                local primaryPart = mount.PrimaryPart or mount:FindFirstChild("HumanoidRootPart")
                if primaryPart then
                    teleportToSameLocationTwice(primaryPart.CFrame)
                    interactWithMountPrompt(mount)
                    return true
                else
                    warn("Mount doesn't have a PrimaryPart or HumanoidRootPart!")
                end
            end
        end
        return false
    end
    
    local function teleportToNextLocation()
        for _, location in ipairs(mountLocations) do
            if teleportToMountAndInteract(location) then
                break
            end
            task.wait(1.5)
        end
    end
    
    -- Create a variable to track if we should stop all loops
    local shouldStopAllLoops = false
    
    -- Create variables to track if we already handled specific dungeons/castles
    local handledDungeons = {}
    local handledCastles = {}
    
    local autofarmToggle = autoevent:AddToggle("eventAutofarm", {
        Title = "Auto-Capture Events",
        Default = false,
    })
    
    -- Function to check and handle dungeons
    local function checkAndHandleDungeon(InstantTeleport)
        -- Check if Dungeon exists in __Main.__Dungeon
        local dungeonFolder = workspace:FindFirstChild("__Main") and 
                              workspace.__Main:FindFirstChild("__Dungeon") and
                              workspace.__Main.__Dungeon:FindFirstChild("Dungeon")

        if dungeonFolder then
            -- Get a unique identifier for this dungeon instance
            local dungeonId = tostring(dungeonFolder:GetFullName())
            
            -- Check if we've already handled this dungeon
            if handledDungeons[dungeonId] then
                return false
            end
            
            
            -- Look for parts to teleport to within Dungeon
            local teleportTarget = nil
            
            -- Try to find a primary part or any part to teleport to
            if dungeonFolder:IsA("Model") and dungeonFolder.PrimaryPart then
                teleportTarget = dungeonFolder.PrimaryPart
            else
                -- Look for any part in the dungeon folder
                for _, part in pairs(dungeonFolder:GetDescendants()) do
                    if part:IsA("BasePart") then
                        teleportTarget = part
                        break
                    end
                end
            end
            
            if teleportTarget then
                InstantTeleport(teleportTarget.Position)
                
                -- Wait a short time after teleporting
                task.wait(1)
                
                -- Fire the remote event to start the dungeon
                local args = {
                    [1] = {
                        [1] = {
                            ["Dungeon"] = game.Players.LocalPlayer.UserId, -- Using local player UserId
                            ["Event"] = "DungeonAction",
                            ["Action"] = "Start"
                        },
                        [2] = "\n"
                    }
                }
                game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                
                -- Mark this dungeon as handled
                handledDungeons[dungeonId] = true
                return true
            end
        end
        
        return false
    end
    
    -- Function to teleport to spawn points looking for dungeons
    local function teleportToSpawnPoints(InstantTeleport)
        -- Check spawn parts in __Extra.__Spawns
        local spawnFolder = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Spawns")
        if not spawnFolder then 
            return false
        end

        for _, spawn in pairs(spawnFolder:GetChildren()) do
            -- Check if toggle was turned off
            if not autofarmToggle.Value or shouldStopAllLoops then
                return false
            end
            
            if spawn:IsA("BasePart") then
                InstantTeleport(spawn.Position)
                task.wait(1.5) -- Adjust wait time as needed
                
                -- After teleporting to a spawn, check if dungeon appeared
                if checkAndHandleDungeon(InstantTeleport) then
                    return true
                end
            end
        end
        
        return false
    end
    
    -- Function to handle the actual loop
    local function startAutofarmLoop()
        shouldStopAllLoops = false
        
        while autofarmToggle.Value and not shouldStopAllLoops do
            
            for _, event in ipairs(selectedEvents) do
                -- Stop processing if toggle turned off
                if not autofarmToggle.Value or shouldStopAllLoops then
                    break
                end
                
                if event == "Mounts" then
                    teleportToNextLocation()
                elseif event == "Raid" then
                    -- Your Raid code here
                elseif event == "Dungeons" then
                    
                    local function InstantTeleport(targetPosition)
                        local player = game.Players.LocalPlayer
                        local char = player.Character or player.CharacterAdded:Wait()
                        local hrp = char:WaitForChild("HumanoidRootPart")

                        if hrp then
                            local finalPos = targetPosition + Vector3.new(0, 5, 0)

                            -- Initial teleport
                            hrp.CFrame = CFrame.new(finalPos)

                            -- Small delay, then ensure we didn't get snapped back
                            task.wait(0.1)
                            if (hrp.Position - finalPos).Magnitude > 10 then
                                hrp.CFrame = CFrame.new(finalPos)
                            end
                        end
                    end

                    -- First check if we can find the dungeon directly
                    if not checkAndHandleDungeon(InstantTeleport) then
                        -- If not, teleport to spawn points
                        teleportToSpawnPoints(InstantTeleport)
                    end
                elseif event == "Castle" then
                    
                    local function InstantTeleport(targetPosition)
                        local player = game.Players.LocalPlayer
                        local char = player.Character or player.CharacterAdded:Wait()
                        local hrp = char:WaitForChild("HumanoidRootPart")

                        if hrp then
                            local finalPos = targetPosition + Vector3.new(0, 5, 0)

                            -- Initial teleport
                            hrp.CFrame = CFrame.new(finalPos)

                            -- Small delay, then ensure we didn't get snapped back
                            task.wait(0.1)
                            if (hrp.Position - finalPos).Magnitude > 10 then
                                hrp.CFrame = CFrame.new(finalPos)
                            end
                        end
                    end

                    -- First teleport to SoloWorld (don't check for Castle yet)
                    local soloWorld = workspace:FindFirstChild("__Extra")
                        and workspace.__Extra:FindFirstChild("__Spawns")
                        and workspace.__Extra.__Spawns:FindFirstChild("SoloWorld")

                    if soloWorld and soloWorld:IsA("BasePart") then
                        InstantTeleport(soloWorld.Position)
                        
                        -- Wait a moment after teleporting
                        task.wait(2)
                        
                        -- NOW check for Castle in __Main.__Dungeon
                        local castleFolder = workspace:FindFirstChild("__Main") and 
                                          workspace.__Main:FindFirstChild("__Dungeon") and
                                          workspace.__Main.__Dungeon:FindFirstChild("Castle")
                        
                        if castleFolder then
                            -- Get a unique identifier for this castle instance
                            local castleId = tostring(castleFolder:GetFullName())
                            
                            -- Skip if we've already handled this castle
                            if handledCastles[castleId] then
                            else
                                
                                -- Fire the remote event to join the Castle
                                local args = {
                                    [1] = {
                                        [1] = {
                                            ["Event"] = "JoinCastle"
                                        },
                                        [2] = "\n"
                                    }
                                }
                                game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                                
                                -- Now you can teleport directly to the Castle if needed
                                task.wait(1) -- Wait for castle to load after firing event
                                
                                -- Look for parts to teleport to within Castle
                                local teleportTarget = nil
                                
                                -- Try to find a primary part or any part to teleport to
                                if castleFolder:IsA("Model") and castleFolder.PrimaryPart then
                                    teleportTarget = castleFolder.PrimaryPart
                                else
                                    -- Look for any part in the castle folder
                                    for _, part in pairs(castleFolder:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            teleportTarget = part
                                            break
                                        end
                                    end
                                end
                                
                                if teleportTarget then
                                    InstantTeleport(teleportTarget.Position)
                                end
                                
                                -- Mark this castle as handled
                                handledCastles[castleId] = true
                            end
                        end
                    end
                end
                
                -- Stop processing if toggle turned off
                if not autofarmToggle.Value or shouldStopAllLoops then
                    break
                end
            end
            
            -- Exit the loop if toggle turned off
            if not autofarmToggle.Value or shouldStopAllLoops then
                break
            end
            
            task.wait(3)
        end
        
    end
    
    -- DIRECT CONNECTION: Start/stop the autofarm loop when the toggle is changed
    local autoFarmThread = nil
    local monitorThread = nil
    
    -- Function to clear handled events when toggling off
    local function clearHandledEvents()
        handledDungeons = {}
        handledCastles = {}
    end
    
    autofarmToggle:OnChanged(function()
        
        if autofarmToggle.Value then
            -- Start the autofarm
            shouldStopAllLoops = false
            clearHandledEvents() -- Reset tracking when starting
            
            -- Start the main autofarm loop
            autoFarmThread = task.spawn(startAutofarmLoop)
            
            -- Start the continuous monitoring thread for all events
            monitorThread = task.spawn(function()
                while autofarmToggle.Value and not shouldStopAllLoops do
                    -- Continuously check for dungeons
                    if table.find(selectedEvents, "Dungeons") then
                        -- Check if new dungeon exists in __Main.__Dungeon
                        local dungeonFolder = workspace:FindFirstChild("__Main") and 
                                            workspace.__Main:FindFirstChild("__Dungeon") and
                                            workspace.__Main.__Dungeon:FindFirstChild("Dungeon")
                                            
                        if dungeonFolder then
                            local dungeonId = tostring(dungeonFolder:GetFullName())
                            

                        end
                        
                        -- Also check for dungeon spawns
                        local spawnFolder = workspace:FindFirstChild("__Extra") and 
                                            workspace.__Extra:FindFirstChild("__Spawns")
                                            

                    end
                    
                    -- Check for mount appearances
                    if table.find(selectedEvents, "Mounts") then
                        local mountFolder = workspace:FindFirstChild("__Extra") and 
                                            workspace.__Extra:FindFirstChild("__Appear")
                                            
                        if mountFolder and #mountFolder:GetChildren() > 0 then
                            teleportToNextLocation()
                        end
                    end
                    
                    -- Check for castle appearances
                    if table.find(selectedEvents, "Castle") then
                        local castleFolder = workspace:FindFirstChild("__Main") and 
                                          workspace.__Main:FindFirstChild("__Dungeon") and
                                          workspace.__Main.__Dungeon:FindFirstChild("Castle")
                                            
                        if castleFolder then
                            local castleId = tostring(castleFolder:GetFullName())
                            
                        end
                    end
                    
                    task.wait(1)
                end
            end)
        else
            -- Stop all running threads
            shouldStopAllLoops = true
            
            -- Additional force-stop measures
            if autoFarmThread then
                task.cancel(autoFarmThread)
                autoFarmThread = nil
            end
            
            if monitorThread then
                task.cancel(monitorThread)
                monitorThread = nil
            end
            
            -- Clear handled events when turning off
            clearHandledEvents()
            
        end
    end)

    










    local secesp = Tabs.World:AddSection("Enemy")

    -- Default ESP settings for enemies
    local billboardTextColor = Color3.fromRGB(255, 0, 0) -- Red text color
    local nameEnabled = false
    local healthEnabled = false
    
    -- Function to extract enemy info (name and health)
    local function extractEnemyInfo(enemy)
        if not enemy or not enemy:IsA("Model") then
            return nil, nil
        end
        
        local name, health = nil, nil
        
        -- Try to find HealthBar in the direct children
        local healthBar = enemy:FindFirstChild("HealthBar")
        if healthBar then
            local main = healthBar:FindFirstChild("Main")
            if main then
                -- Get name
                local title = main:FindFirstChild("Title")
                if title and title:IsA("TextLabel") then
                    -- Extract just the name part, removing any "Model" prefix
                    name = title.Text
                    -- Remove "Model" text if present
                    if name:sub(1, 5) == "Model" then
                        name = name:sub(6):gsub("^%s*", "")
                    end
                end
                
                -- Get health
                local bar = main:FindFirstChild("Bar")
                if bar then
                    local amount = bar:FindFirstChild("Amount")
                    if amount and amount:IsA("TextLabel") then
                        health = amount.Text
                    end
                end
            end
        end
        
        -- Fallback to humanoid health if available
        if not health then
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            if humanoid then
                health = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            end
        end
        
        -- Fallback for name - removing any "Model" prefix
        if not name or name == "" then
            name = enemy.Name
            if name:sub(1, 5) == "Model" then
                name = name:sub(6):gsub("^%s*", "")
            end
        end
        
        return name, health
    end
    
    -- Function to find a valid attachment point for labels
    local function findAttachmentPoint(model)
        if not model then return nil end
        
        -- Try head part first (for consistent label positioning)
        local head = model:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            return head
        end
        
        -- Try standard parts next
        local attachPart = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
        
        -- If no standard parts, try any BasePart
        if not attachPart then
            for _, part in pairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    attachPart = part
                    break
                end
            end
        end
        
        return attachPart
    end
    
    -- Function to create or update ESP for an enemy
    local function createEnemyESP(enemy)
        -- Skip if not a valid model
        if not enemy or not enemy:IsA("Model") then
            return
        end
        
        -- Remove any existing highlight (in case this was previously enabled)
        local existingHighlight = enemy:FindFirstChild("ESP_Highlight")
        if existingHighlight then
            existingHighlight:Destroy()
        end
        
        -- Remove any existing billboard
        local existingBillboard = enemy:FindFirstChild("ESP_BillboardGui")
        if existingBillboard then
            existingBillboard:Destroy()
        end
        
        -- Only create billboard if name or health is enabled
        if nameEnabled or healthEnabled then
            -- Find attachment point for billboard
            local attachPart = findAttachmentPoint(enemy)
            if not attachPart then return end
            
            -- Extract name and health information
            local name, health = extractEnemyInfo(enemy)
            if not name and not health then return end
            
            -- Create the BillboardGui with exact specifications
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "ESP_BillboardGui"
            billboardGui.AlwaysOnTop = true
            billboardGui.Size = UDim2.new(0, 200, 0, 50)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)  -- Position above head
            billboardGui.Adornee = attachPart
            billboardGui.Parent = enemy
            
            local verticalOffset = 0
            
            -- Create name label if enabled
            if nameEnabled and name then
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "NameLabel"
                nameLabel.Size = UDim2.new(1, 0, 0, 20)
                nameLabel.Position = UDim2.new(0, 0, 0, verticalOffset)
                nameLabel.BackgroundTransparency = 1
                nameLabel.TextColor3 = billboardTextColor
                nameLabel.TextStrokeTransparency = 0.5
                nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                nameLabel.Font = Enum.Font.SourceSansBold
                nameLabel.TextSize = 14
                nameLabel.Text = name
                nameLabel.Parent = billboardGui
                
                verticalOffset = verticalOffset + 20
            end
            
            -- Create health label if enabled
            if healthEnabled and health then
                local healthLabel = Instance.new("TextLabel")
                healthLabel.Name = "HealthLabel"
                healthLabel.Size = UDim2.new(1, 0, 0, 20)
                healthLabel.Position = UDim2.new(0, 0, 0, verticalOffset)
                healthLabel.BackgroundTransparency = 1
                healthLabel.TextColor3 = billboardTextColor
                healthLabel.TextStrokeTransparency = 0.5
                healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                healthLabel.Font = Enum.Font.SourceSansBold
                healthLabel.TextSize = 14
                healthLabel.Text = "Health: " .. health
                healthLabel.Parent = billboardGui
            end
        end
    end
    
    -- Function to update all enemy ESP elements
    local function updateAllEnemyESP()
        local enemiesPath = workspace:FindFirstChild("__Main")
        if not enemiesPath then return end
        enemiesPath = enemiesPath:FindFirstChild("__Enemies")
        if not enemiesPath then return end
        enemiesPath = enemiesPath:FindFirstChild("Client")
        if not enemiesPath then return end
        
        -- Process all existing enemies recursively
        local function processEnemies(container)
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Model") then
                    createEnemyESP(child)
                end
                
                if #child:GetChildren() > 0 then
                    processEnemies(child)
                end
            end
        end
        
        processEnemies(enemiesPath)
        
        -- Setup monitoring if not already done
        if not enemiesPath:GetAttribute("ESPMonitored") then
            enemiesPath:SetAttribute("ESPMonitored", true)
            
            -- Monitor for new enemies
            enemiesPath.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("Model") then
                    task.spawn(function()
                        task.wait(0.1) -- Small delay to ensure model is loaded
                        createEnemyESP(descendant)
                    end)
                end
            end)
            
            -- Setup cleanup for removed enemies
            enemiesPath.DescendantRemoving:Connect(function(descendant)
                if descendant:FindFirstChild("ESP_BillboardGui") then
                    descendant.ESP_BillboardGui:Destroy()
                end
            end)
        end
    end
    
    -- UI controls for Enemy section
    local TextColorPicker = secesp:AddColorpicker("TextColorPicker", {
        Title = "Text Color",
        Default = billboardTextColor
    })
    TextColorPicker:OnChanged(function(newColor)
        billboardTextColor = newColor
        updateAllEnemyESP()
    end)
    
    local nameToggle = secesp:AddToggle("NameToggle", { Title = "Show Names", Default = nameEnabled })
    nameToggle:OnChanged(function(enabled)
        nameEnabled = enabled
        updateAllEnemyESP()
    end)
    
    local healthToggle = secesp:AddToggle("HealthToggle", { Title = "Show Health", Default = healthEnabled })
    healthToggle:OnChanged(function(enabled)
        healthEnabled = enabled
        updateAllEnemyESP()
    end)
    
    -- Initialize enemy ESP
    updateAllEnemyESP()
    
    -- Setup continuous health updates
    task.spawn(function()
        while true do
            if healthEnabled then
                updateAllEnemyESP()
            end
            task.wait(0.5) -- Update twice per second for health
        end
    end)












    

-- Initialize our variables at the top with default values
local playerFillColor = Color3.fromRGB(0, 255, 255)      -- Default: Green fill
local playerOutlineColor = Color3.fromRGB(0, 255, 255)   -- Default: Red outline
local playerFillEnabled = false
local playerOutlineEnabled = false

-- Billboard GUI variables - now with separate toggles
local nameEnabled = false
local healthEnabled = false
local billboardTextColor = Color3.fromRGB(0, 255, 255)   -- Cyan (0, 255, 255)

-- Highlight and billboard tracking tables for better cleanup
local playerHighlights = {}
local playerBillboards = {}

local secesp2 = Tabs.World:AddSection("Player")

-- Function to update a single billboard GUI component
local function updateBillboardGUI(player)
    -- Perform strict validation
    if not player or typeof(player) ~= "Instance" or not player:IsA("Player") then
        return
    end
    
    local character = player.Character
    if not character then 
        return 
    end
    
    -- Clean up any existing billboard for this player
    if playerBillboards[player] then
        playerBillboards[player]:Destroy()
        playerBillboards[player] = nil
    end
    
    -- Skip if neither name nor health is enabled
    if not (nameEnabled or healthEnabled) then 
        return 
    end
    
    -- Get the humanoid to access health information
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then 
        return 
    end
    
    -- Get the head or primary part for billboard adornment
    local head = character:FindFirstChild("Head")
    if not head then
        head = character.PrimaryPart
        if not head then
            return
        end
    end
    
    -- Create the BillboardGui
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_BillboardGui"
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)  -- Position above head
    billboardGui.Adornee = head
    billboardGui.Parent = character
    
    local verticalOffset = 0
    
    -- Create name label if enabled
    if nameEnabled then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.Position = UDim2.new(0, 0, 0, verticalOffset)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = billboardTextColor
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 14
        nameLabel.Text = player.Name
        nameLabel.Parent = billboardGui
        
        verticalOffset = verticalOffset + 20
    end
    
    -- Create health label if enabled
    if healthEnabled and humanoid then
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Name = "HealthLabel"
        healthLabel.Size = UDim2.new(1, 0, 0, 20)
        healthLabel.Position = UDim2.new(0, 0, 0, verticalOffset)
        healthLabel.BackgroundTransparency = 1
        healthLabel.TextColor3 = billboardTextColor
        healthLabel.TextStrokeTransparency = 0.5
        healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        healthLabel.Font = Enum.Font.SourceSansBold  -- Changed to bold font
        healthLabel.TextSize = 14
        healthLabel.Text = "Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        healthLabel.Parent = billboardGui
        
        -- Update health text when it changes using a local function to prevent leaks
        local function updateHealthText()
            if healthLabel and healthLabel.Parent then
                healthLabel.Text = "Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            end
        end
        
        -- Create connection for health changes
        local healthChangedConnection = humanoid.HealthChanged:Connect(updateHealthText)
        
        -- Ensure proper cleanup
        character.AncestryChanged:Connect(function(_, parent)
            if not parent and healthChangedConnection then
                healthChangedConnection:Disconnect()
            end
        end)
    end
    
    -- Store reference for cleanup
    playerBillboards[player] = billboardGui
end

-- Function to add a highlight to the player's character (excluding the local player)
local function addPlayerHighlight(player, character)
    -- Strict validation
    if not player or typeof(player) ~= "Instance" or not player:IsA("Player") then
        return
    end
    
    if not character or typeof(character) ~= "Instance" or not character:IsA("Model") then
        return
    end
    
    if player == game.Players.LocalPlayer then 
        return 
    end  -- Skip the local player
    
    -- Clean up any existing highlight for this player first
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
    
    -- Create new highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = playerFillColor
    highlight.OutlineColor = playerOutlineColor
    highlight.FillTransparency = playerFillEnabled and 0.5 or 1
    highlight.OutlineTransparency = playerOutlineEnabled and 0 or 1
    highlight.Parent = character
    
    -- Store reference for cleanup
    playerHighlights[player] = highlight
    
    -- Create billboard GUI for this character
    updateBillboardGUI(player)
end

-- Function to update all highlights based on current settings
local function updateAllHighlights()
    for player, highlight in pairs(playerHighlights) do
        if highlight and highlight.Parent then
            highlight.FillColor = playerFillColor
            highlight.OutlineColor = playerOutlineColor
            highlight.FillTransparency = playerFillEnabled and 0.5 or 1
            highlight.OutlineTransparency = playerOutlineEnabled and 0 or 1
        end
    end
end

-- Function to update all billboard GUIs based on current settings
local function updateAllBillboards()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            updateBillboardGUI(player)
        end
    end
end

-- Set up ESP for all existing players
for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer and player.Character then
        addPlayerHighlight(player, player.Character)
    end
    
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            task.spawn(function()
                -- Use task.spawn to prevent yielding the main thread and add a small delay
                -- to ensure character is fully loaded
                task.wait(0.1)
                addPlayerHighlight(player, character)
            end)
        end)
    end
end

-- Handle new players joining
game.Players.PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            task.spawn(function()
                -- Use task.spawn to prevent yielding the main thread and add a small delay
                -- to ensure character is fully loaded
                task.wait(0.1)
                addPlayerHighlight(player, character)
            end)
        end)
    end
end)

-- Handle players leaving
game.Players.PlayerRemoving:Connect(function(player)
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
    
    if playerBillboards[player] then
        playerBillboards[player]:Destroy()
        playerBillboards[player] = nil
    end
end)

-- UI controls for Player section
local playerFillColorPicker = secesp2:AddColorpicker("PlayerFillColorPicker", {
    Title = "Player Fill Color",
    Default = playerFillColor
})
playerFillColorPicker:OnChanged(function(newColor)
    playerFillColor = newColor
    updateAllHighlights()
end)

local playerOutlineColorPicker = secesp2:AddColorpicker("PlayerOutlineColorPicker", {
    Title = "Player Outline Color",
    Default = playerOutlineColor
})
playerOutlineColorPicker:OnChanged(function(newColor)
    playerOutlineColor = newColor
    updateAllHighlights()
end)

local playerFillToggle = secesp2:AddToggle("PlayerFillToggle", { 
    Title = "Enable Fill", 
    Default = playerFillEnabled 
})
playerFillToggle:OnChanged(function(enabled)
    playerFillEnabled = enabled
    updateAllHighlights()
end)

local playerOutlineToggle = secesp2:AddToggle("PlayerOutlineToggle", { 
    Title = "Enable Outline", 
    Default = playerOutlineEnabled 
})
playerOutlineToggle:OnChanged(function(enabled)
    playerOutlineEnabled = enabled
    updateAllHighlights()
end)

-- Separate toggles for name and health display
local nameToggle = secesp2:AddToggle("NameToggle", {
    Title = "Show Player Names",
    Default = nameEnabled
})
nameToggle:OnChanged(function(enabled)
    nameEnabled = enabled
    updateAllBillboards()
end)

local healthToggle = secesp2:AddToggle("HealthToggle", {
    Title = "Show Player Health",
    Default = healthEnabled
})
healthToggle:OnChanged(function(enabled)
    healthEnabled = enabled
    updateAllBillboards()
end)







    local miscserver = Tabs.Servers:AddSection("Servers")

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


















-- Implementation for script persistence with teleport queueing
local function implementPersistentScript()
    -- Step 1: Validate environment and prepare filesystem
    if not isfolder(CONFIGURATION.FOLDER_NAME) then
        local success, errorMessage = pcall(makefolder, CONFIGURATION.FOLDER_NAME)
        
        if not success then
            warn("[ERROR] Failed to create directory structure: " .. tostring(errorMessage))
            return false
        end
    end
    
    -- Step 2: Generate target filepath using game ID
    local currentGameId = tostring(game.PlaceId)
    local targetFilePath = CONFIGURATION.FOLDER_NAME .. "/" .. currentGameId .. CONFIGURATION.FILE_EXTENSION
    
    -- Step 3: Prepare script content with loadstring
    local scriptContent = [[
        loadstring(game:HttpGet(SCRIPT_URL))()
    ]]
    
    -- Step 4: Write file with error handling
    local writeSuccess, writeError = pcall(function()
        writefile(targetFilePath, scriptContent)
    end)
    
    if not writeSuccess then
        warn("[ERROR] Failed to write script file: " .. tostring(writeError))
        return false
    end
    
    -- Step 5: Prepare teleport queue script that will execute after teleport
    local teleportScript = [[
        -- Wait for game to load properly
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        
        -- Small delay to ensure services are available
        task.wait(1)
        
        -- Execute the Arise script
        loadstring(game:HttpGet(SCRIPT_URL))()
        
        -- Re-queue for future teleports
        queue_on_teleport([=[
            loadstring(game:HttpGet(SCRIPT_URL))()
            loadstring(readfile("]=] .. targetFilePath .. [=["))()
        ]=])
    ]]
    
    -- Step 6: Queue the teleport script
    local queueSuccess, queueError = pcall(function()
        queue_on_teleport(teleportScript)
    end)
    
    if not queueSuccess then
        warn("[ERROR] Failed to queue script for teleport: " .. tostring(queueError))
        return false
    end
    
    -- Step 7: Return operation results
    return {
        success = true,
        filePath = targetFilePath,
        gameId = currentGameId,
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
SaveManager:SetFolder("CROW/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

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
end
