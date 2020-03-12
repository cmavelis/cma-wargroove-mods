local OldWargroove = require "wargroove/wargroove"
local Combat = require "wargroove/combat"

local Wargroove = {}

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local CopyWargroove = deepcopy(OldWargroove)

local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

function Wargroove.init()
    print('===Wargroove.init')
    -- OldWargroove.getTargetsInRange = Wargroove.getTargetsInRange

    -- local mapSize = CopyWargroove.getMapSize()
    -- print('mapSize')
    -- print(dump(mapSize))
    
end

local function getFacing(from, to)
    local dx = to.x - from.x
    local dy = to.y - from.y

    if math.abs(dx) > math.abs(dy) then
        if dx > 0 then
            return 1 -- Right
        else
            return 3 -- Left
        end
    else
        if dy > 0 then
            return 2 -- Down
        else
            return 0 -- Up
        end
    end
end

-- function Wargroove.getTargetsInRange(pos, range, targetType)
--     local mapSize = Wargroove.getMapSize()

--    local result = {}
--    local x0 = pos.x
--    local y0 = pos.y
--    for yo = -range, range do
--        for xo = -range, range do
--            local distance = math.abs(xo) + math.abs(yo)
--            if distance <= range then
--                local x = x0 + xo
--                local y = y0 + yo
--                if (x >= 0) and (y >= 0) and (x < mapSize.x) and (y < mapSize.y) then
--                    if (targetType == "all") then
--                        table.insert(result, { x = x, y = y})
--                    else
--                        local unitId = Wargroove.getUnitIdAtXY(x, y)
--                        if (targetType == "unit" and unitId ~= -1) or (targetType == "empty" and unitId == -1) then
--                            table.insert(result, { x = x, y = y})
--                        end
--                    end
--                end
--            end
--        end
--    end

--    return result
-- end

-- function Wargroove.getCleaveTargets(pos, range)
--     -- pos: x, y coords of the reference location
--     local mapSize = Wargroove.getMapSize()
--     local targetType = "unit"

--    local result = {}
--    local x0 = pos.x
--    local y0 = pos.y
--    for yo = -range, range do
--        for xo = -range, range do
--            local distance = math.abs(xo) + math.abs(yo)
--            if distance <= range then
--                local x = x0 + xo
--                local y = y0 + yo
--                if (x >= 0) and (y >= 0) and (x < mapSize.x) and (y < mapSize.y) then
--                    if (targetType == "all") then
--                        table.insert(result, { x = x, y = y})
--                    else
--                        local unitId = Wargroove.getUnitIdAtXY(x, y)
--                        if (targetType == "unit" and unitId ~= -1) or (targetType == "empty" and unitId == -1) then
--                            table.insert(result, { x = x, y = y})
--                        end
--                    end
--                end
--            end
--        end
--    end

--    return result
-- end


return Wargroove
