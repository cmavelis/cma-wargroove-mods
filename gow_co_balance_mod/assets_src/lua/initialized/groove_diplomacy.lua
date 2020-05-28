local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"
local OldDiplomacy = require "verbs/groove_diplomacy"


local Diplomacy = GrooveVerb:new()

function Diplomacy:init()
    OldDiplomacy.getMaximumRange = Diplomacy.getMaximumRange
    OldDiplomacy.canExecuteWithTarget = Diplomacy.canExecuteWithTarget
    OldDiplomacy.execute = Diplomacy.execute
    -- OldDiplomacy.preExecute = Diplomacy.preExecute
end

function Diplomacy:getMaximumRange(unit, endPos)
    return 2
end

-- function Diplomacy:preExecute(unit, targetPos, strParam, endPos)
--     local fish = Wargroove.chooseFish(targetPos)
--     return true, fish
-- end

function Diplomacy:canExecuteWithTarget(unit, endPos, targetPos, strParam)
    local targetUnit = Wargroove.getUnitAt(targetPos)
    return targetUnit and targetUnit.unitClass.isStructure and targetUnit.unitClassId ~= "hq" and Wargroove.areEnemies(unit.playerId, targetUnit.playerId)
end

function Diplomacy:execute(unit, targetPos, strParam, path)
    Wargroove.setIsUsingGroove(unit.id, true)
    Wargroove.updateUnit(unit)

    local facingOverride = ""
    if targetPos.x > unit.pos.x then
        facingOverride = "right"
    elseif targetPos.x < unit.pos.x then
        facingOverride = "left"
    end

    local grooveAnimation = "groove"
    if targetPos.y < unit.pos.y then
        grooveAnimation = "groove_up"
    elseif targetPos.y > unit.pos.y then
        grooveAnimation = "groove_down"
    end

    if facingOverride ~= "" then
        Wargroove.setFacingOverride(unit.id, facingOverride)
    end

    Wargroove.playUnitAnimation(unit.id, grooveAnimation)
    Wargroove.playMapSound("mercival/mercivalGroove", targetPos)
    Wargroove.waitTime(3.0)

    Wargroove.playGrooveEffect()
    Wargroove.unsetFacingOverride(unit.id)
    Wargroove.playUnitAnimation(unit.id, "groove_end")
    Wargroove.openFishingUI(unit.pos, "boot")
    Wargroove.waitTime(0.5)
    Wargroove.playMapSound("mercival/mercivalGrooveCatch", unit.pos)

    local endPos = unit.pos
    if path and #path > 0 then
        endPos = path[#path]
    end
    local targetUnit = Wargroove.getUnitAt(targetPos);
    targetUnit:setHealth(100, unit.id)
    targetUnit.playerId = unit.playerId
    Wargroove.updateUnit(targetUnit)

    Wargroove.waitTime(2.5)
end


return Diplomacy
