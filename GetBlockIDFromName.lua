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
function _G.GetBlockIDFromName(name)
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
