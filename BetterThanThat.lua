local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local UICorner_2 = Instance.new("UICorner")
local ScrollingFrame = Instance.new("ScrollingFrame")  -- added
local TextBox = Instance.new("TextBox")
local UICorner_3 = Instance.new("UICorner")
local Execute = Instance.new("TextButton")
local Clear = Instance.new("TextButton")
local Yield = Instance.new("TextButton")
local Copy = Instance.new("TextButton")
local Drag = Instance.new("TextLabel")
local Hide = Instance.new("TextButton")
local UIS = game:GetService("UserInputService")
local SCROLL_SPEED = 40

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
Frame.Position = UDim2.new(0.112842187, 0, 0.0880844295, 0)
Frame.Size = UDim2.new(0, 1060, 0, 551)

Title.Name = "Title"
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderColor3 = Color3.fromRGB(199, 199, 199)
Title.Size = UDim2.new(0, 344, 0, 27)
Title.Font = Enum.Font.Jura
Title.Text = "bluddy executor v1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 26
UICorner.Parent = Title

UICorner_2.CornerRadius = UDim.new(0, 4)
UICorner_2.Parent = Frame

-- ScrollingFrame replaces TextBox's old position
ScrollingFrame.Parent = Frame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0.0103773586, 0, 0.0617059879, 0)
ScrollingFrame.Size = UDim2.new(0, 1038, 0, 462)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 9999)
ScrollingFrame.ScrollBarThickness = 0  -- hidden, we scroll manually
ScrollingFrame.ScrollingEnabled = false

-- TextBox inside ScrollingFrame
TextBox.Parent = ScrollingFrame
TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderColor3 = Color3.fromRGB(52, 52, 52)
TextBox.Size = UDim2.new(1, 0, 0, 9999)
TextBox.ClearTextOnFocus = false
TextBox.Font = Enum.Font.SciFi
TextBox.MultiLine = true
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 18
TextBox.TextWrapped = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
UICorner_3.Parent = TextBox

Execute.Name = "Execute"
Execute.Parent = Frame
Execute.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Execute.BorderColor3 = Color3.fromRGB(115, 115, 115)
Execute.Position = UDim2.new(0.818867922, 0, 0.918330312, 0)
Execute.Size = UDim2.new(0, 172, 0, 34)
Execute.Font = Enum.Font.SciFi
Execute.Text = "Execute"
Execute.TextColor3 = Color3.fromRGB(255, 255, 255)
Execute.TextSize = 21
Execute.TextStrokeColor3 = Color3.fromRGB(113, 113, 113)
Execute.TextStrokeTransparency = 0

Clear.Name = "Clear"
Clear.Parent = Frame
Clear.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Clear.BorderColor3 = Color3.fromRGB(115, 115, 115)
Clear.Position = UDim2.new(0.640566051, 0, 0.918330312, 0)
Clear.Size = UDim2.new(0, 172, 0, 34)
Clear.Font = Enum.Font.SciFi
Clear.Text = "Clear"
Clear.TextColor3 = Color3.fromRGB(255, 255, 255)
Clear.TextSize = 21
Clear.TextStrokeColor3 = Color3.fromRGB(113, 113, 113)
Clear.TextStrokeTransparency = 0

Yield.Name = "Yield"
Yield.Parent = Frame
Yield.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Yield.BorderColor3 = Color3.fromRGB(115, 115, 115)
Yield.Position = UDim2.new(0.459433973, 0, 0.918330312, 0)
Yield.Size = UDim2.new(0, 172, 0, 34)
Yield.Font = Enum.Font.SciFi
Yield.Text = "Infinite Yield"
Yield.TextColor3 = Color3.fromRGB(255, 255, 255)
Yield.TextSize = 21
Yield.TextStrokeColor3 = Color3.fromRGB(113, 113, 113)
Yield.TextStrokeTransparency = 0

Copy.Name = "Copy"
Copy.Parent = Frame
Copy.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Copy.BorderColor3 = Color3.fromRGB(115, 115, 115)
Copy.Position = UDim2.new(0.275471687, 0, 0.918330312, 0)
Copy.Size = UDim2.new(0, 172, 0, 34)
Copy.Font = Enum.Font.SciFi
Copy.Text = "CopyClipBoard"
Copy.TextColor3 = Color3.fromRGB(255, 255, 255)
Copy.TextSize = 21
Copy.TextStrokeColor3 = Color3.fromRGB(113, 113, 113)
Copy.TextStrokeTransparency = 0

Drag.Name = "Drag"
Drag.Parent = Frame
Drag.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Drag.BackgroundTransparency = 1
Drag.BorderColor3 = Color3.fromRGB(199, 199, 199)
Drag.Size = UDim2.new(0, 1060, 0, 27)
Drag.Font = Enum.Font.Jura
Drag.Text = ""
Drag.TextColor3 = Color3.fromRGB(255, 255, 255)
Drag.TextSize = 26

Hide.Name = "Hide"
Hide.Parent = Frame
Hide.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Hide.BorderColor3 = Color3.fromRGB(115, 115, 115)
Hide.Position = UDim2.new(0.0207547173, 0, 0.918330312, 0)
Hide.Size = UDim2.new(0, 172, 0, 34)
Hide.Font = Enum.Font.SciFi
Hide.Text = "Shift+X to hide"
Hide.TextColor3 = Color3.fromRGB(255, 255, 255)
Hide.TextSize = 21
Hide.TextStrokeColor3 = Color3.fromRGB(113, 113, 113)
Hide.TextStrokeTransparency = 0

-- Button logic
Execute.MouseButton1Click:Connect(function()
    local f, loadErr = loadstring(TextBox.Text)
    if not f then
        warn("Syntax error: " .. loadErr)
        return
    end
    local ok, runErr = pcall(f)
    if not ok then
        warn("Runtime error: " .. runErr)
    end
end)

Clear.MouseButton1Click:Connect(function()
    TextBox.Text = ""
end)

Yield.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

Copy.MouseButton1Click:Connect(function()
    setclipboard(TextBox.Text)
end)

-- Drag logic
local dragging = false
local dragInput
local dragStart
local startPos

Drag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Drag.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

-- Undo/redo
local history = {}
local future = {}
local lastText = ""
local DEBOUNCE = 0.3
local debounceThread
local intervalThread

local function snapshot()
    if TextBox.Text ~= lastText then
        table.insert(history, lastText)
        future = {}
        lastText = TextBox.Text
    end
end

local function undo()
    snapshot()
    if #history == 0 then return end
    table.insert(future, TextBox.Text)
    local prev = table.remove(history)
    TextBox.Text = prev
    lastText = prev
    TextBox.CursorPosition = #prev + 1
end

local function redo()
    if #future == 0 then return end
    table.insert(history, TextBox.Text)
    local next = table.remove(future)
    TextBox.Text = next
    lastText = next
    TextBox.CursorPosition = #next + 1
end

TextBox.Focused:Connect(function()
    intervalThread = task.spawn(function()
        while TextBox:IsFocused() do
            task.wait(2)
            snapshot()
        end
    end)
end)

TextBox.FocusLost:Connect(function()
    snapshot()
    if intervalThread then
        task.cancel(intervalThread)
        intervalThread = nil
    end
end)

TextBox:GetPropertyChangedSignal("Text"):Connect(function()
    if debounceThread then task.cancel(debounceThread) end
    debounceThread = task.delay(DEBOUNCE, snapshot)
end)

-- All input handling in one connection
UIS.InputBegan:Connect(function(input, gameProcessed)
    local ctrl = UIS:IsKeyDown(Enum.KeyCode.LeftControl)
        or UIS:IsKeyDown(Enum.KeyCode.RightControl)
    local shift = UIS:IsKeyDown(Enum.KeyCode.LeftShift)

    if gameProcessed and not ctrl then return end

    -- hide/show
    if shift and input.KeyCode == Enum.KeyCode.X then
        Frame.Visible = not Frame.Visible
    end

    -- word boundary snapshots
    if TextBox:IsFocused() then
        if input.KeyCode == Enum.KeyCode.Space
        or input.KeyCode == Enum.KeyCode.Return
        or input.KeyCode == Enum.KeyCode.Backspace then
            snapshot()
        end
    end

    -- undo/redo
    if ctrl and input.KeyCode == Enum.KeyCode.Z then
        undo()
    elseif ctrl and input.KeyCode == Enum.KeyCode.Y then
        redo()
    end
end)

-- Drag + scroll in one InputChanged connection
UIS.InputChanged:Connect(function(input)
    -- drag
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    -- scroll
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        local mousePos = UIS:GetMouseLocation()
        local framePos = ScrollingFrame.AbsolutePosition
        local frameSize = ScrollingFrame.AbsoluteSize
        if mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X
        and mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y then
            local pos = ScrollingFrame.CanvasPosition
            ScrollingFrame.CanvasPosition = Vector2.new(
                pos.X,
                math.max(0, pos.Y - input.Position.Z * SCROLL_SPEED)
            )
        end
    end
end)
