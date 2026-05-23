
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
task.wait(0.5)
loadstring(game:HttpGet("https://pastefy.app/C99C6KXA/raw"))()
task.wait(0.1)

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
    print("Found:", button:GetFullName())
    firesignal(button.MouseButton1Click)
else
    warn("Button not found")
end




local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
rootPart.CFrame = CFrame.new(-1, -5, -17979)

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



-------------------
---


local thiefdied = false
local function setupThiefKing(model)
    local humanoid = model:WaitForChild("Humanoid", 10)
    if not humanoid then return end
    
    humanoid.Died:Connect(function()
    task.wait(4.4)
    print("died")
    rootPart.CFrame = CFrame.new(9, 337, 34956)
    task.wait(5)

    rootPart.CFrame = CFrame.new(-14, 75, 16085)
    task.wait(4)
    rootPart.CFrame = CFrame.new(13, 44, 46966)
    task.wait(4)
   rootPart.CFrame = CFrame.new(177, 39, 4717)
   task.wait(4)
   rootPart.CFrame = CFrame.new(13, 44, 46966)
   task.wait(3)
	thiefdied = true
	rootPart.CFrame = CFrame.new(11, 1, -40010)
	task.wait(1)

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
end)
end
local TeleportService = game:GetService("TeleportService")



task.wait(240)
if not thiefdied then

for _, model in ipairs(workspace.Models:GetChildren()) do
    if model.Name:sub(1, #"Thief King") == "Thief King" then
        setupThiefKing(model)
    end
end


workspace.Models.ChildAdded:Connect(function(model)
    if model.Name:sub(1, #"Thief King") == "Thief King" then
        setupThiefKing(model)
    end
end)

end

