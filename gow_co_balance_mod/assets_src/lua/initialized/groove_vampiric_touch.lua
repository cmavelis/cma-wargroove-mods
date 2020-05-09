local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"
local Verb = require "wargroove/verb"
local Functional = require "halley/functional"
local OldVampiricTouch = require "verbs/groove_vampiric_touch"

local inspect = require "inspect"

local VampiricTouch = GrooveVerb:new()

VampiricTouch.isInPreExecute = false
VampiricTouch.teleportLocation = {}


local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} \n'
    else
       return tostring(o)
    end
 end

local unpack = table.unpack or unpack

function VampiricTouch:parseTargets(strParam)
    local targetStrs={}
    local i = 1
    for targetStr in string.gmatch(strParam, "([^"..";".."]+)") do
        targetStrs[i] = targetStr
        i = i + 1
    end

    local targetUnitId = tonumber(targetStrs[1])

    local targetPosStr = targetStrs[2]
    local vals = {}
    for val in targetPosStr.gmatch(targetPosStr, "([^"..",".."]+)") do
        vals[#vals+1] = val
    end
    targetPosition = { x = tonumber(vals[1]), y = tonumber(vals[2])}

    return targetUnitId, targetPosition
end

local function get_key_for_value( t, value )
    for k,v in pairs(t) do
      if v==value then return k end
    end
    return nil
  end

local function debugWrap(fcn)
    print('wrapper applied')
    return function (...)
        local arg = {...}
        arg.n = select("#", ...)
        -- print('function name:', get_key_for_value(VampiricTouch, fcn))
        -- print('argdump')
        -- print(inspect(arg))
        return fcn(unpack(arg, 1))  
    end
end

function VampiricTouch:init()
    for k,v in pairs(VampiricTouch) do
        if (k ~= 'debugWrap') and (type(v) == 'function') then
            print(k)
            OldVampiricTouch[k] = debugWrap(v)
        end
    end
end

function VampiricTouch:getMaximumRange(unit, endPos)
    if VampiricTouch.isInPreExecute then
        return 1
    end

    return 2
end

function VampiricTouch:getTargetType()
    if VampiricTouch.isInPreExecute then
        return "unit" 
    end

    return "empty"
end

function VampiricTouch:getTargets(unit, endPos, strParam)
    local targets = {}
    if VampiricTouch.isInPreExecute then
        targets = Functional.filter(function (targetPos)
            return self:canExecuteWithTarget(unit, VampiricTouch.teleportLocation, targetPos, strParam)
        end, Wargroove.getTargetsInRange(VampiricTouch.teleportLocation, 1, 'unit'))
    else
        targets = Functional.filter(function (targetPos)
            return self:canExecuteWithTarget(unit, endPos, targetPos, strParam)
        end, Wargroove.getTargetsInRangeAfterMove(unit, endPos, endPos, self:getMaximumRange(unit, endPos), self:getTargetType()))
    end
    return targets, endPos
end

function VampiricTouch:preExecute(unit, targetPos, strParam, endPos)
    VampiricTouch.isInPreExecute = true
    VampiricTouch.teleportLocation = targetPos
    Wargroove.displayTarget(targetPos)

    Wargroove.selectTarget()

    while Wargroove.waitingForSelectedTarget() do
        coroutine.yield()
    end

    local targetUnit = Wargroove.getSelectedTarget()

    if (targetUnit == nil) then
        VampiricTouch.isInPreExecute = false
        Wargroove.clearDisplayTargets()
        return false, ""
    end

    Wargroove.setSelectedTarget(targetPos)
    local groovedUnit = Wargroove.getUnitAt(targetUnit)

    VampiricTouch.isInPreExecute = false
    Wargroove.clearDisplayTargets()
    return true, groovedUnit.id .. ";" .. groovedUnit.pos.x .. "," .. groovedUnit.pos.y
end


function VampiricTouch:canExecuteAt(unit, endPos)
    if not Verb.canExecuteAt(self, unit, endPos) then
        return false
    end
    
    local targets = self:getTargets(unit, endPos, {}, false)  
    return #targets > 0
end

function VampiricTouch:canExecuteWithTarget(unit, endPos, targetPos, strParam)
    if not self:canSeeTarget(targetPos) then
        return false
    end
    
    if VampiricTouch.isInPreExecute then

        local targetUnit = Wargroove.getUnitAt(targetPos)

        if not targetUnit or not Wargroove.areEnemies(unit.playerId, targetUnit.playerId) or (not targetUnit.canBeAttacked) then
            return false
        end

        if targetUnit.unitClass.isCommander or targetUnit.unitClass.isStructure then
            return false
        end

        for i, tag in ipairs(targetUnit.unitClass.tags) do
            if tag == "summon" then
                return false
            end
        end

        return true --, targetUnit.id .. ";" .. targetUnit.pos.x .. "," .. targetUnit.pos.y
    end 

    local u = Wargroove.getUnitAt(targetPos)
    local uc = Wargroove.getUnitClass("soldier")
    return (u == nil or u.id == unit.id) and Wargroove.canStandAt("soldier", targetPos)

end
    -- -- this all goes into a different function FROM here
    -- local targetUnit = Wargroove.getUnitAt(targetPos)

    -- if not targetUnit or not Wargroove.areEnemies(unit.playerId, targetUnit.playerId) or (not targetUnit.canBeAttacked) then
    --     return false
    -- end

    -- if targetUnit.unitClass.isCommander or targetUnit.unitClass.isStructure then
    --     return false
    -- end

    -- for i, tag in ipairs(targetUnit.unitClass.tags) do
    --     if tag == "summon" then
    --         return false
    --     end
    -- end
    -- -- TO here
-- end

function VampiricTouch:execute(unit, targetPos, strParam, path)
    Wargroove.setIsUsingGroove(unit.id, true)
    Wargroove.updateUnit(unit)
    local targetUnitId, groovedUnitPosition = VampiricTouch:parseTargets(strParam)

    Wargroove.playPositionlessSound("battleStart")
    Wargroove.playGrooveCutscene(unit.id)

    local facingOverride = ""
    local effectSequence = ""
    if targetPos.x == unit.pos.x and targetPos.y > unit.pos.y then
        effectSequence = "groove_down"
    elseif targetPos.x == unit.pos.x and targetPos.y < unit.pos.y then
        effectSequence = "groove_up"
    elseif targetPos.x > unit.pos.x then
        facingOverride = "right"
        effectSequence = "groove"
    else 
        facingOverride = "left"
        effectSequence = "groove"
    end

    Wargroove.setFacingOverride(unit.id, facingOverride)
    Wargroove.playUnitAnimation(unit.id, "groove")

    Wargroove.playMapSound("sigrid/sigridGroove", targetPos)

    Wargroove.spawnMapAnimation(targetPos, 0, "fx/groove/sigrid_groove_fx", effectSequence, "over_units", { x = 12, y = 12 }, facingOverride)
    Wargroove.waitTime(1.0)
    Wargroove.moveUnitToOverride(unit.id, targetPos, 0, 0, 5)
    while (Wargroove.isLuaMoving(unit.id)) do
        coroutine.yield()
    end

    unit.pos = { x = targetPos.x, y = targetPos.y }

    Wargroove.updateUnit(unit)
    
    local targetUnit = Wargroove.getUnitAt(groovedUnitPosition)
    if targetUnit.health then
        unit:setHealth(unit.health + targetUnit.health, unit.id)
        targetUnit:setHealth(0, unit.id)
        Wargroove.updateUnit(targetUnit)
        Wargroove.playUnitAnimation(targetUnit.id, "hit")
    end

    Wargroove.playGrooveEffect()

    Wargroove.unsetFacingOverride(unit.id)

    Wargroove.waitTime(1.0)
end

function VampiricTouch:onPostUpdateUnit(unit, targetPos, strParam, path)
    GrooveVerb.onPostUpdateUnit(self, unit, targetPos, strParam, path)
    unit.pos = targetPos
end

return VampiricTouch
