local RETRY_DELAY = 5

local function isAreaOccupied(areaCFrame: CFrame, areaSize: Vector3): boolean
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = {}

	local parts = workspace:GetPartBoundsInBox(areaCFrame, areaSize, overlapParams)
	print("[Detection] Parts found in box:", #parts)

	for _, part in parts do
		local character = part:FindFirstAncestorOfClass("Model")
		if character and character:FindFirstChildOfClass("Humanoid") then
			print("[Detection] Humanoid found in area:", character.Name)
			return true
		end
	end

	print("[Detecti No humanoids found, area is clear.")
	return false
end

local function checkAreaThenProceed(areaCFrame: CFrame, areaSize: Vector3, onClear: () -> ())
	if isAreaOccupied(areaCFrame, areaSize) then
		print("[Retry] Area occupied. Trying again in", RETRY_DELAY, "seconds.")
		task.delay(RETRY_DELAY, function()
			checkAreaThenProceed(areaCFrame, areaSize, onClear)
		end)
	else
		print("[Retry] Area is clear. Proceeding.")
		onClear()
	end
end
--vibe coding on top!



local placeId = game.PlaceId

if placeId == 104770044244450 then
    print("lobby")
    local areaCFrame = CFrame.new(-74.9999924, 7.0630002, -128, 0, 0, 1, 1, 0, 0, 0, 1, 0)
    local areaSize   = Vector3.new(15, 15, 15)
    checkAreaThenProceed(areaCFrame, areaSize, function()
	print("tufboy")
	task.wait(0.1)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/zato-yes/test1/main/lobby.lua"))()
    end)
    

elseif placeId == 89744231770777 then
    print("maingame") 
    	loadstring(game:HttpGet("https://raw.githubusercontent.com/zato-yes/test1/main/maingame.lua"))()

else
    print("unknown")
end




