local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"
local OldAreaHeal = require "verbs/groove_area_heal"

local AreaHeal = GrooveVerb:new()

function AreaHeal:init()
    OldAreaHeal.execute = AreaHeal.execute
    OldAreaHeal.onPostUpdateUnit = AreaHeal.onPostUpdateUnit
end

function AreaHeal:execute(unit, targetPos, strParam, path)
    Wargroove.setIsUsingGroove(unit.id, true)
    Wargroove.updateUnit(unit)
    
    Wargroove.playPositionlessSound("battleStart")
    Wargroove.playGrooveCutscene(unit.id, "area_heal", "errol")
        
    Wargroove.playUnitAnimation(unit.id, "groove")
    Wargroove.playMapSound("twins/errolGroove", targetPos)
    Wargroove.waitTime(1.2)
    Wargroove.spawnMapAnimation(targetPos, 3, "fx/groove/errol_groove_fx", "idle", "behind_units", {x = 12, y = 12})

    Wargroove.playGrooveEffect()

    local startingState = {}
    local pos = {key = "pos", value = "" .. targetPos.x .. "," .. targetPos.y}
    local radius = {key = "radius", value = "3"}    
    table.insert(startingState, pos)
    table.insert(startingState, radius)
    Wargroove.spawnUnit(unit.playerId, {x = -100, y = -100}, "area_heal", false, "", startingState)

    Wargroove.waitTime(1.2)
end

function AreaHeal:onPostUpdateUnit(unit, targetPos, strParam, path)
    GrooveVerb.onPostUpdateUnit(self, unit, targetPos, strParam, path)
    unit.unitClassId = "commander_twins"

end

return AreaHeal
