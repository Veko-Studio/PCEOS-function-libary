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

-- Re-enable PlayerGui (restore previous states)
local function showPlayerGui()
	for gui, wasEnabled in pairs(guiStates) do
		if gui and gui.Parent == playerGui then
			gui.Enabled = wasEnabled
		end
	end
	guiStates = {}
end

function SetCameraPosition(position: Vector3)
    -- Cleanup
    for _, child in workspace:GetChildren() do
        if child.Name=="e2562"then child:Destroy() end
    end
    -- Create the temp part
    local tempPart = Instance.new("Part", workspace)
    tempPart.Name = "e2562"
    tempPart.Anchored = true
    tempPart.Size = Vector3.new(50,50,0.05)--Vector3.new(5,5,0.05) -- flat surface
    tempPart.Position = position
    local tempPart2 = Instance.new("Part", workspace)
    tempPart2.Name = "e2562"
    tempPart2.Anchored = true
    tempPart2.Size = Vector3.new(50,50,6+5000)--Vector3.new(5,5,0.05) -- flat surface
    tempPart2.Position = position

    local cameraPosition = position
    local partpos = position + Vector3.new(0, -1.5, 0)
    local partpos2 = position + Vector3.new(0, 3, 0)
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
--simulate rotation presses
    local function rotate90onR() keypress(82) keyrelease(82) end -- Global X
    local function rotate90onT() keypress(84) keyrelease(84) end -- Global Y
    local function rotate90onZ() keypress(90) keyrelease(90) end -- Global Z
-- Round both current and target to nearest 90
    local function roundTo90(angle)
        return math.floor((angle % 360 + 45) / 90) % 4
    end
local function rotateblockto(block: Model, targetRot: Vector3)

    -- Get current rotation of the model (assumes block.PrimaryPart is set)
    local currentCF = block:GetPivot()
    local _, currentRotY, _ = currentCF:ToEulerAnglesYXZ()
    local x, y, z = currentCF:ToOrientation()
    
    local currentRot = Vector3.new(
        math.deg(x),
        math.deg(y),
        math.deg(z)
    )

    local xSteps = (roundTo90(targetRot.X) - roundTo90(currentRot.X)) % 4
    local ySteps = (roundTo90(targetRot.Y) - roundTo90(currentRot.Y)) % 4
    local zSteps = (roundTo90(targetRot.Z) - roundTo90(currentRot.Z)) % 4

    -- Apply rotations in RTZ order (global axis)
    for _ = 1, xSteps do rotate90onR() end--wait() end
    for _ = 1, ySteps do rotate90onT() end--wait() end
    for _ = 1, zSteps do rotate90onZ() end--wait() end
    return xSteps+ySteps+zSteps
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
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Levenshtein Distance function for string similarity
local function levenshtein(s, t)
    local len_s = #s
    local len_t = #t
    local matrix = {}

    for i = 0, len_s do
        matrix[i] = {}
        matrix[i][0] = i
    end
    for j = 0, len_t do
        matrix[0][j] = j
    end

    for i = 1, len_s do
        for j = 1, len_t do
            if s:sub(i,i) == t:sub(j,j) then
                matrix[i][j] = matrix[i-1][j-1]
            else
                matrix[i][j] = math.min(
                    matrix[i-1][j] + 1,
                    matrix[i][j-1] + 1,
                    matrix[i-1][j-1] + 1
                )
            end
        end
    end

    return matrix[len_s][len_t]
end

function _G.getBlockIDFromName(name)
    local container = LocalPlayer.PlayerGui.BuildGUI2.BuildMenu.Container.Container.BlockMenu
    if not container then
        return 1
    end

    local descendants = container:GetDescendants()
    local closestModel = nil
    local smallestDistance = math.huge

    for _, descendant in ipairs(descendants) do
        if descendant:IsA("Model") and descendant.Name then
            local dist = levenshtein(descendant.Name:lower(), name:lower())
            if dist < smallestDistance then
                smallestDistance = dist
                closestModel = descendant
            end
        end
    end

    if closestModel and closestModel.Parent and closestModel.Parent.Parent then
        return tonumber(closestModel.Parent.Parent.Name) or 1
    else
        return 1
    end
end


lastcall = 1
storedCalls = {}
function _G.FrontEndPlaceBlock(id, pos, rot)
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

    local totalStart = tick()
    local occupied = false
    local a



    local playerName = Players.LocalPlayer.Name
    local aircraftFolder = workspace:FindFirstChild("PIayerAircraft")
    if not aircraftFolder then return nil end

    local playerAircraft = aircraftFolder:FindFirstChild(playerName)
    if not playerAircraft then return nil end
    local cc = #playerAircraft:GetChildren()



    timed("occupied space check1", function()
        a = getinplotposinworldspace(pos)
        local b = findModelAtPosition(a)
        if b then occupied = true end
        print(pos,a,b)
    end)
    if occupied then return end
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

        timed("Rotate block", function()
            local c = rotateblockto(e, rot)
            print("rotate count:",c)
            --task.wait()--if c~=0 then task.wait() end
        end)

        timed("Set camera", function()
            SetCameraPosition(a)
            --task.wait()
        end)
        timed("Run Button1Down", function()
            local screenSize = camera.ViewportSize
            mousemoveabs(screenSize.X/2,screenSize.Y/2)
            pcall(function()game:GetService("CoreGui").DevConsoleMaster.DevConsoleWindow.Visible = false end)
            if (e:GetPivot().Position-a).Magnitude <= 2 then task.spawn(function()mouse1click() end) end
            --task.wait()
        end)
    end)
    print(result_or_error)
    lastcall = lastcall+1
    local storedcall = lastcall
    task.spawn(function()
        task.wait(1)
        if lastcall == storedcall then
            ResetCamera(); lastcall = 1
        end
    end)
    print("[PCEOS]FrontEndPlaceBlock() total time including the task.wait()'s:", tick() - totalStart, "seconds")
    print("-------------------------")
    if #playerAircraft:GetChildren()+1 ~= cc then _G.FrontEndPlaceBlock(id, pos, rot) end
end
