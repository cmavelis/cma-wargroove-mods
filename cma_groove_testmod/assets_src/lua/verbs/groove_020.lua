local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"

local Effigy = GrooveVerb:new()

Effigy.isInPreExecute = false

function Effigy:getMaximumRange(unit, endPos)
    return 3
end


function Effigy:getTargetType()
    return "unit"
end

function Effigy:canExecuteWithTarget(unit, endPos, targetPos, strParam)
    if not self:canSeeTarget(targetPos) then
        return false
    end

    local targetUnit = Wargroove.getUnitAt(targetPos)

    if not targetUnit or Wargroove.areEnemies(unit.playerId, targetUnit.playerId) then
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

    return true
end

function Effigy:preExecute(unit, targetPos, strParam, endPos)
    Effigy.targetUnit = Wargroove.getUnitAt(targetPos).id

    Effigy.isInPreExecute = true

    Wargroove.selectTarget()

    while Wargroove.waitingForSelectedTarget() do
        coroutine.yield()
    end

    local destination = Wargroove.getSelectedTarget()

    if (destination == nil) then
        Effigy.isInPreExecute = false
        return false, ""
    end
    
    Wargroove.setSelectedTarget(targetPos)

    Effigy.isInPreExecute = false

    return true, Effigy.targetUnit .. ";" .. destination.x .. "," .. destination.y
end

function Effigy:execute(unit, targetPos, strParam, path)
    Wargroove.setIsUsingGroove(unit.id, true)
    Wargroove.updateUnit(unit)

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
    Wargroove.waitTime(0)

    Wargroove.spawnMapAnimation(unit.pos, 0, "fx/groove/sigrid_groove_fx", effectSequence, "over_units", { x = 12, y = 12 }, facingOverride)

    Wargroove.waitTime(0.7)    
    
    local u = Wargroove.getUnitAt(targetPos)
    if u.health then
        unit:setHealth(unit.health + u.health, unit.id)
        u:setHealth(0, unit.id)
        Wargroove.updateUnit(u)
        Wargroove.playUnitAnimation(u.id, "hit")
    end

    Wargroove.waitTime(0.3)

    Wargroove.playGrooveEffect()

    Wargroove.unsetFacingOverride(unit.id)

    Wargroove.waitTime(1.0)
end


return Effigy
