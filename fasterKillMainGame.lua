
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
local Players = game:GetService("Players")


rootPart.CFrame = CFrame.new(-288, 24, -3499)

print("workssofar")

--findsword

local function findSword()
    if player.Character then
        local swordInChar = player.Character:FindFirstChild("Sword")
        if swordInChar and swordInChar:IsA("Tool") then
            return swordInChar
        end
    end

    local swordInBackpack = player:WaitForChild("Backpack"):FindFirstChild("Sword")
    if swordInBackpack and swordInBackpack:IsA("Tool") then
        return swordInBackpack
    end

    return nil
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

 if player.Character then
    equipSword()
end
--[[
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    equipSword()
end)
]]
-------------------
local gnomeDoneEvent = Instance.new("BindableEvent")

local function connectGnome(npc)
    if npc.Name == "GnomeBerzerker" then
        local humanoid = npc:WaitForChild("Humanoid", 5)
        if not humanoid then warn("No humanoid on", npc.Name) return end
        humanoid.Died:Connect(function()
            task.wait(2)
            print("died")
            local TOOL_NAMES = { "LinkedSword", "GnomeAxe", "GnomeClaws" }
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            for _, model in pairs(workspace.Models:GetChildren()) do
                if table.find(TOOL_NAMES, model.Name) then
                    for _, part in pairs(model:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.Size = Vector3.new(2, 2, 2)
                        end
                    end
                end
            end
            gnomeDoneEvent:Fire()
        end)
    end
end

for _, npc in ipairs(workspace.Models:GetChildren()) do
    connectGnome(npc)
end

workspace.Models.ChildAdded:Connect(connectGnome)

gnomeDoneEvent.Event:Wait()

local TOOL_NAMES = { "LinkedSword", "GnomeAxe", "GnomeClaws" }
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

for _, model in pairs(workspace.Models:GetChildren()) do
    if table.find(TOOL_NAMES, model.Name) then
        local teleportPart
        if model:FindFirstChild("Handle") then
            teleportPart = model.Handle
        elseif model:FindFirstChild("Point") then
            teleportPart = model.Point
        else
            teleportPart = model:FindFirstChildWhichIsA("BasePart")
        end

        if teleportPart then
            local forwardOffset = rootPart.CFrame.LookVector * 17 
            local verticalOffset = Vector3.new(0, 3, 0)  
            local targetPosition = rootPart.Position + forwardOffset + verticalOffset

            if not model.PrimaryPart then
                model.PrimaryPart = teleportPart
            end
            model:SetPrimaryPartCFrame(CFrame.new(targetPosition))
        end
    end
end

task.wait(26)

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local TOOL_NAMES = { "GnomeClaws", "GnomeAxe", "LinkedSword" }

local function cleanTool(tool)
    for _, part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
            part.Anchored = false
        end
    end
end

for _, tool in pairs(backpack:GetChildren()) do
    if table.find(TOOL_NAMES, tool.Name) and tool:IsA("Tool") then
        cleanTool(tool)
    end
end


print("DISABLED COLISION YES REAL REAL")



local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")


if keypress and keyrelease then
    local code = Enum.KeyCode.Four  
    keypress(code)                  
    task.wait(0.1)                 
    keyrelease(code)                

end










--[[local function equipAllTools()
    if not player.Character then return end
    local backpack = player:WaitForChild("Backpack")

    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") or tool:IsA("HopperBin") then
            tool.Parent = player.Character 

            spawn(function()
                while tool.Parent == player.Character do
                    task.wait(0.2)
                    tool:Activate()
                end
            end)
        end
    end
end



if player.Character then
    equipAllTools()
end



--TeleportService:Teleport(104770044244450)

--equiptools



--[[player.CharacterAdded:Connect(function()
    task.wait(0.5)
    equipAllTools()
end)]]






