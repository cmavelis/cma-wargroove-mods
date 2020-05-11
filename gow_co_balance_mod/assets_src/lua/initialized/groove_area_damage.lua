local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"
local OldAreaDamage = require "verbs/groove_area_damage"

local AreaDamage = GrooveVerb:new()


function AreaDamage:init()
    OldAreaDamage.execute = AreaDamage.execute
    OldAreaDamage.onPostUpdateUnit = AreaDamage.onPostUpdateUnit
end

function AreaDamage:execute(unit, targetPos, strParam, path)
    Wargroove.setIsUsingGroove(unit.id, true)
    Wargroove.updateUnit(unit)
    
    Wargroove.playPositionlessSound("battleStart")
    Wargroove.playGrooveCutscene(unit.id, "area_damage", "orla")
        
    Wargroove.playUnitAnimation(unit.id, "groove2")
    Wargroove.playMapSound("twins/orlaGroove", unit.pos)
    Wargroove.waitTime(1.9)
    Wargroove.playMapSound("twins/orlaGrooveEffect", targetPos)
    Wargroove.spawnMapAnimation(targetPos, 3, "fx/groove/orla_groove_fx", "idle", "behind_units", {x = 12, y = 12})

    Wargroove.playGrooveEffect()

    local startingState = {}
    local pos = {key = "pos", value = "" .. targetPos.x .. "," .. targetPos.y}
    local radius = {key = "radius", value = "0"}    
    table.insert(startingState, pos)
    table.insert(startingState, radius)
    Wargroove.spawnUnit(unit.playerId, {x = -100, y = -100}, "area_damage", false, "", startingState)

    Wargroove.waitTime(1.2)

end

function AreaDamage:onPostUpdateUnit(unit, targetPos, strParam, path)
    GrooveVerb.onPostUpdateUnit(self, unit, targetPos, strParam, path)
    unit.unitClassId = "commander_twins_water"
    unit.hadTurn = false
    unit.grooveCharge = unit.unitClass.maxGroove
end

return AreaDamage
