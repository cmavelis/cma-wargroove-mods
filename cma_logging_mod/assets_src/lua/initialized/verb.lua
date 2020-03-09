local OldVerb = require "wargroove/verb"

local Verb = {}

-- This is called by the game when the map is loaded.
function Verb.init()
    OldVerb.updateSelfUnit = Verb.updateSelfUnit
    OldVerb.execute = Verb.execute
end

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

function Verb:execute(unit, targetPos, strParam, path)
    print('===execute')
    print('---unit')
    print(dump(unit))
    print('---strParam')
    print(dump(strParam))

    print('---debugging')
    print(dump(self))

end

function Verb:updateSelfUnit(unit, targetPos, path)
    print('===updateSelfUnit')
    print('---unit')
    print(dump(unit))
    print('---targetPos')
    print(dump(targetPos))
    print('---path')
    print(dump(path))


    local endPos = unit.pos
    if path ~= nil and #path > 0 then
        endPos = path[#path]

        if #path >= 2 then
            unit.pos.facing = getFacing(path[#path - 1], path[#path])
        end
    end

    unit.hadTurn = true
    unit.pos.x = endPos.x
    unit.pos.y = endPos.y
end

return Verb
