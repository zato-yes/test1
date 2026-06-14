
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
task.wait(0.5)
loadstring(game:HttpGet("https://raw.githubusercontent.com/zato-yes/test1/refs/heads/main/poghubbackup"))()
task.wait(0.2)

local function findSpecificButton()
    for _, obj in ipairs(game:GetService("CoreGui"):GetDescendants()) do
        if obj:IsA("TextButton")
        and obj.Text == "MAGNET: OFF" then
            return obj
        end
    end
end


local button = findSpecificButton()

if button then
    print("fooooound:", button:GetFullName())
    firesignal(button.MouseButton1Click)
else
    warn("stoopid idiot")
end


local ReplicatedStorage = game:GetService("ReplicatedStorage")
pcall(function()
    local Remotes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))

    local originalMeleeHit
    originalMeleeHit = hookfunction(Remotes.RegisterMeleeHit.fireServer, function(...)
        local args = {...}

            task.spawn(function()
                for i = 1, 200 - 1 do
                    task.wait(0.03)
                    originalMeleeHit(unpack(args))
                end
            end)
        
        return originalMeleeHit(...)
    end)
end)



local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
player.CameraMode = Enum.CameraMode.Classic
player.CameraMinZoomDistance = 0.5
player.CameraMaxZoomDistance = 1000
rootPart.CFrame = CFrame.new(-1, -7, -17979)

print("workssofar")
local Players = game:GetService("Players")

--findsword and ability
--[[local function findAbility()
    if player.Character then
	local EnrageAbilityinchar = player.Character:FindFirstChild("Enrage")
	
	if EnrageAbilityinchar and EnrageAbilityinchar:IsA("Tool") then
	    return EnrageAbilityinchar
	end
    end

    local EnrageAbilityinbackpack = player:WaitForChild("Backpack"):FindFirstChild("Enrage")
	if EnrageAbilityinbackpack and EnrageAbilityinbackpack:IsA("Tool") then
	    return EnrageAbilityinbackpack
	end

end

local function UseAbilityOnce()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local ability = findAbility()
    if ability then
	humanoid:EquipTool(ability)
	ability.Equipped:Wait()
	task.wait(0.2)
	ability:Activate()
	task.wait(0.3)
	humanoid:UnequipTools()
	print("shouldve worked")
    else print("yayabubu")
    end
end
]]


local function findSword()
    if player.Character then
        local swordInChar = player.Character:FindFirstChild("WornBlade")

        if swordInChar and swordInChar:IsA("Tool") then
            return swordInChar
        end
    end

    local swordInBackpack = player:WaitForChild("Backpack"):FindFirstChild("WornBlade")
    if swordInBackpack and swordInBackpack:IsA("Tool") then
        return swordInBackpack
    end

end

local function equipSword()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end

    local sword = findSword()
    if sword then
        humanoid:EquipTool(sword)
        print("sworded myself")

        spawn(function()
            while sword.Parent == player.Character do
                task.wait(0.2)  
                sword:Activate()
            end
        end)

    else
        task.wait(0.5)
        equipSword()
    end
end


--[[if player.Character then
    UseAbilityOnce()
end
task.wait(0.4)
]]


if player.Character then
    equipSword()
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    equipSword()
end)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-------------------
---

local bossDied = false
local connection

local bosses = {
    {
        name = "Thief King",
        onDeath = function()
            task.wait(3.5)
            rootPart.CFrame = CFrame.new(6, 42, -3451)
            workspace.Map.Presets:WaitForChild("Dojo"):GetPivot()
            rootPart.CFrame = workspace.Map.Presets.Dojo:GetPivot()
        end
    },
    {
        name = "MasterSamurai",
        onDeath = function()
            task.wait(3.5)
            rootPart.CFrame = CFrame.new(10, 41, 13988)
        end
    },
    {
        name = "GnomeChampion",
        onDeath = function()
            task.wait(3.5)
            rootPart.CFrame = CFrame.new(-5, 26, 5001)
        end
    },
    {
        name = "Elder Vampire",
        onDeath = function()
            task.wait(3.5)
            rootPart.CFrame = CFrame.new(-6, 121, 27028)
        end
    },
    {
        name = "SteamborneCzar",
        onDeath = function()
            task.wait(3.5)
            rootPart.CFrame = CFrame.new(-1, 94, 45962)
        end
    },
    {
        name = "King Ice",
        onDeath = function()
        task.wait(0.4)
        rootPart.CFrame = CFrame.new(-1, 96, 47020)
        task.wait(3)
        rootPart.CFrame = CFrame.new(21, 6, -40014)
        task.wait(0.4)
          print("maybeeee")
	    local args = {
	     buffer.fromstring("\031\000"),
	    {
        workspace:WaitForChild("Models"):WaitForChild("CorpseBox")
    	},
	     {
        1
        }
	    }
	    game:GetService("ReplicatedStorage"):WaitForChild("__Nets__"):FireServer(unpack(args))


    	local args = {
    	buffer.fromstring("\020\000"),
    	{},
    	{}
    	}
    	game:GetService("ReplicatedStorage"):WaitForChild("__Nets__"):FireServer(unpack(args))


        print("maybe works maybe")
        end
    },
}

local function watchForBoss(index)
    if index > #bosses then return end
    bossDied = false
    local bossData = bosses[index]

    local function trySetup(model)
        if bossDied then return end
        if model.Name:sub(1, #bossData.name) ~= bossData.name then return end

        local humanoid = model:WaitForChild("Humanoid", 20)
        if not humanoid then return end

        humanoid.Died:Connect(function()
            if bossDied then return end
            bossDied = true
            if connection then connection:Disconnect() end
            bossData.onDeath()
            watchForBoss(index + 1)
        end)
    end

    for _, m in ipairs(workspace.Models:GetChildren()) do
        trySetup(m)
    end
    connection = workspace.Models.ChildAdded:Connect(trySetup)
end

watchForBoss(1)

task.wait(240)
    rootPart.CFrame = CFrame.new(21, 6, -40014)
	rootPart.CFrame = CFrame.new(21, 6, -40014)
	local args = {
	 buffer.fromstring("\031\000"),
	{
        workspace:WaitForChild("Models"):WaitForChild("CorpseBox")
	},
	 {
        1
        }
	}
	game:GetService("ReplicatedStorage"):WaitForChild("__Nets__"):FireServer(unpack(args))


	local args = {
	buffer.fromstring("\020\000"),
	{},
	{}
	}
	game:GetService("ReplicatedStorage"):WaitForChild("__Nets__"):FireServer(unpack(args))
