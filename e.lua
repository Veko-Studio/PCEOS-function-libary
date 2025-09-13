--libary
--loadstring(game:HttpGet("https://raw.githubusercontent.com/Veko-Studio/PCEOS-function-libary/refs/heads/main/FrontEndPlaceBlock.lua"))()










local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local zone
for _, zonei in workspace.BuildingZones:GetChildren() do
    if zonei.Owner.Value == Players.LocalPlayer then zone = zonei end
end

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local originalCameraType = camera.CameraType
local originalCameraSubject = camera.CameraSubject

local tempPart -- holds the temporary part
local guiStates = {}

-- Hide PlayerGui 
local function hidePlayerGui()
	guiStates = {} -- reset memory
	for _, gui in ipairs(playerGui:GetChildren()) do
		if gui:IsA("ScreenGui") then
			guiStates[gui] = gui.Enabled
			gui.Enabled = false
		end
	end
end

local function highlightPart(part: BasePart, color: Color3)
    if not part or not part:IsA("BasePart") then return end

    -- Remove old highlight if it exists
    local existing = part:FindFirstChildOfClass("Highlight")
    if existing then existing:Destroy() end

    -- Create new highlight
    local hl = Instance.new("Highlight")
    hl.Parent = part
    hl.Adornee = part
    hl.FillColor = color
    hl.FillTransparency = 0.5 -- 0 = solid, 1 = invisible
    hl.OutlineTransparency = 1 -- hide the border
end

-- Re-enable PlayerGui (restore previous states)
local function showPlayerGui()
	for gui, wasEnabled in pairs(guiStates) do
		if gui and gui.Parent == playerGui then
			gui.Enabled = wasEnabled
		end
	end
	guiStates = {}
end

function SetCameraPosition(position: Vector3, ysize: number)
    -- Cleanup
    for _, child in workspace:GetChildren() do
        if child.Name=="e2562"then child:Destroy() end
    end
    -- Create the temp part
    local tempPart = Instance.new("Part", workspace)
    tempPart.Name = "e2562"
    tempPart.Anchored = true
    tempPart.Size = Vector3.new(2.5,2.5,0.05)--Vector3.new(5,5,0.05) -- flat surface
    tempPart.Position = position
    tempPart.Color = Color3.new(0,255,0)
    local tempPart2 = Instance.new("Part", workspace)
    tempPart2.Name = "e2562"
    tempPart2.Anchored = true
    tempPart2.Size = Vector3.new(50,50,5000)--Vector3.new(5,5,0.05) -- flat surface
    tempPart2.Position = position
    tempPart2.Color = Color3.new(255,0,0)
    highlightPart(tempPart, Color3.new(0,255,0))
    highlightPart(tempPart2, Color3.new(255,0,0))

    local cameraPosition = position
    local partpos = position + Vector3.new(0, -1.5, 0)
    local partpos2 = position + Vector3.new(0, ysize+(tempPart2.Size.Z/2), 0)
    -- Make the camera look at the part
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(cameraPosition, partpos) -- Look at the part

    -- Optional: make the part face the camera
    tempPart.CFrame = CFrame.new(partpos, camera.CFrame.Position)
    tempPart2.CFrame = CFrame.new(partpos2, camera.CFrame.Position)
end

function ResetCamera()
    -- Restore default camera
    camera.CameraType = originalCameraType
    camera.CameraSubject = originalCameraSubject

    -- Cleanup
    for _, child in workspace:GetChildren() do
        if child.Name=="e2562"then child:Destroy() end
    end
end
local function setblock(id)
game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Bindables.BlockSelected:Fire(id)
end
local function getinplotposinworldspace(vec)
    print("getinplotposinworldspace zone:",zone)
    local vec1 = zone.Position + Vector3.new(vec.X*2.5,(vec.Y+0.4)*2.5,vec.Z*2.5)
    print("getinplotposinworldspace vec1:",vec1)
    return vec1
end
-- Rotate functions (forward 90° each call)
local function rotate90onR() keypress(82) keyrelease(82) end -- Global X
local function rotate90onT() keypress(84) keyrelease(84) end -- Global Y
local function rotate90onZ() keypress(90) keyrelease(90) end -- Global Z









local function previewBlockPlacement(block: Model, targetCFrame: CFrame)
    if not block or not block:IsA("Model") then return end
    -- Clone the block
    local clone = block:Clone()
    clone.Parent = workspace
    -- Make all parts green and transparent a little
    for _, p in ipairs(clone:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Color = Color3.fromRGB(0, 255, 0)
            p.Transparency = p.Transparency+0.5
        end
        if p:IsA("HighLight") then
            p:destroy() 
        end 
    end
        -- Move clone to target CFrame
        clone:PivotTo(targetCFrame)
        -- Destroy after 5 seconds
    task.spawn(function()
        task.wait(20)
        if clone and clone.Parent then
            clone:Destroy()
        end
    end)
end
local function rotateblockto(block: Model, targetCFrame: CFrame)
    if not block then return 0 end

    -- Helper: check if block is close enough to target orientation
    local function approxEqualCFrame(a, b, tolerance)
        tolerance = tolerance or 0.05
        local aLook, aUp = a.LookVector, a.UpVector
        local bLook, bUp = b.LookVector, b.UpVector
        return (aLook - bLook).Magnitude < tolerance and (aUp - bUp).Magnitude < tolerance
    end

    -- Check if block is already correct
    if approxEqualCFrame(block:GetPivot(), targetCFrame) then
        return 0
    end

    -- Show preview
    previewBlockPlacement(block, targetCFrame)

    local rotations = {0, 1, 2} -- number of 90° rotations per axis
    local totalPresses = 0

    -- Try all realistic combinations of rotations
    for _, rx in ipairs(rotations) do
        for _, ry in ipairs(rotations) do
            for _, rz in ipairs(rotations) do
                -- Apply sequence of keypresses
                for i = 1, rx do rotate90onR() end--task.wait(0.05) end
                for i = 1, ry do rotate90onT() end--task.wait(0.05) end
                for i = 1, rz do rotate90onZ() end--task.wait(0.05) end

                totalPresses = totalPresses + rx + ry + rz
                task.wait(0.08)
                -- Check if block matches target
                if approxEqualCFrame(block:GetPivot(), targetCFrame) then
                    return totalPresses
                end

                -- Undo rotations if not matched
                for i = 1, rz do rotate90onZ() end--task.wait() end
                for i = 1, ry do rotate90onT() end--task.wait() end
                for i = 1, rx do rotate90onR() end--task.wait() end
            end
        end
    end

    warn("[PCEOS] rotateblockto: Could not match rotation with brute-force!")
    return totalPresses
end
















local function buildmode()
    local Event = game:GetService("Players").LocalPlayer.PlayerGui.BuildGui.EnableBuilding
    Event:Fire()
end
local function findModelAtPosition(pos: Vector3)
local rad = 2
-- Create a new part
local part = Instance.new("Part")

-- Set size to 2.5 x 2.5 x 2.5
part.Size = Vector3.new(rad, rad, rad)

-- Set color to green
part.Color = Color3.fromRGB(0, 255, 0) -- or Color3.new(0,1,0)

-- Anchor the part so it doesn’t fall
part.Anchored = true
part.Shape = Enum.PartType.Ball

-- Set position
part.Position = pos

-- Parent the part to workspace so it appears in the game
part.Parent = workspace
task.spawn(function()task.wait(5)part:destroy()end)


    local playerName = Players.LocalPlayer.Name
    local aircraftFolder = workspace:FindFirstChild("PIayerAircraft")
    if not aircraftFolder then return nil end

    local playerAircraft = aircraftFolder:FindFirstChild(playerName)
    if not playerAircraft then return nil end

    for _, model in ipairs(playerAircraft:GetChildren()) do
        if model:IsA("Model") then
            local modelPos = model:GetPivot().Position
            if (modelPos - pos).Magnitude < rad then -- tolerance to avoid float mismatch
                return model
            end
        end
    end

    return false
end
local function getinplotposinworldspace(vec)
    print("getinplotposinworldspace zone:",zone)
    local vec1 = zone.Position + Vector3.new(vec.X*2.5,(vec.Y+0.4)*2.5,vec.Z*2.5)
    print("getinplotposinworldspace vec1:",vec1)
    return vec1
end
local function getModelHeight(model: Model)
    if not model or not model:IsA("Model") then return nil end

    local cf, size = model:GetBoundingBox()

    -- Transform the local Y-axis into world space
    local up = cf:VectorToWorldSpace(Vector3.new(0, 1, 0))

    -- The effective height is the projection of the bounding box size onto the global Y-axis
    local worldY = math.abs(up.Y) * size.Y 
                 + math.abs(cf:VectorToWorldSpace(Vector3.new(1,0,0)).Y) * size.X
                 + math.abs(cf:VectorToWorldSpace(Vector3.new(0,0,1)).Y) * size.Z

    return worldY
end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

lastcall = 1
storedCalls = {}
function _G.FrontEndPlaceBlock(id, CFrame)
    print("")
    print("")
    print("")
    print("-------------------------")
    local function timed(label, func)
        local start = tick()
        func()
        task.spawn(function()
            warn("[PCEOS]"..label .. " took", tick() - start, "s")
        end)
    end
    local a
    local playerName = Players.LocalPlayer.Name
    local aircraftFolder = workspace:FindFirstChild("PIayerAircraft")
    if not aircraftFolder then return nil end

    local playerAircraft = aircraftFolder:FindFirstChild(playerName)
    if not playerAircraft then return nil end
    local success, result_or_error = pcall(function()
        timed("Wait for RBX active", function()
            if not isrbxactive() then
                repeat task.wait() until isrbxactive()
            end
        end)
        local e
        timed("modelget1", function()
            e = workspace.Camera.BuildObjects:FindFirstChildWhichIsA("Model")
        end)
        timed("Build mode and modelget2", function()
            if (not e) or e:FindFirstChild("SelectionBoxNoPos") then
                buildmode() task.wait(0.3)
                e = workspace.Camera.BuildObjects:FindFirstChildWhichIsA("Model")
            end
        end)
        timed("Set block", function()
            if e and e:FindFirstChild("ID") and e:FindFirstChild("ID").Value ~= id then
                task.spawn(function() setblock(id) end)
            end
            --task.wait()
        end)
    end)
    print(result_or_error)
    print("[PCEOS]PreviewBlock() total time including the task.wait()'s:", tick() - totalStart, "seconds")
    print("-------------------------")
end
