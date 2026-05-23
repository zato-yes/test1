
local TeleportService = game:GetService("TeleportService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
   rootPart.CFrame = CFrame.new(13, 44, 46966)




local args = {
	"InvClasses"
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("ClassData"):WaitForChild("ServerFunction"):InvokeServer(unpack(args))








local args = {
	"GetClassData"
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("ClassData"):WaitForChild("ServerFunction"):InvokeServer(unpack(args))




local args = {
	"EquipClass",
	"ClassAdventurer",
	2
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Class"):WaitForChild("ServerFunction"):InvokeServer(unpack(args))










TeleportService:Teleport(89744231770777)









local args = {
	buffer.fromstring("\001\000\v\000100KMEMBERS"),
	{},
	{}
}
game:GetService("ReplicatedStorage"):WaitForChild("__Nets__"):FireServer(unpack(args))


local args = {
	buffer.fromstring("\001\000\b\00060KLIKES"),
	{},
	{}
}
game:GetService("ReplicatedStorage"):WaitForChild("__Nets__"):FireServer(unpack(args))



local args = {
	buffer.fromstring("\001\000\r\000105KFAVORITES"),
	{},
	{}
}
game:GetService("ReplicatedStorage"):WaitForChild("__Nets__"):FireServer(unpack(args))


local args = {
	buffer.fromstring("\001\000\t\00026MVISITS"),
	{},
	{}
}
game:GetService("ReplicatedStorage"):WaitForChild("__Nets__"):FireServer(unpack(args))


local args = {
	buffer.fromstring("\001\000\b\000PartFour"),
	{},
	{}
}
game:GetService("ReplicatedStorage"):WaitForChild("__Nets__"):FireServer(unpack(args))

