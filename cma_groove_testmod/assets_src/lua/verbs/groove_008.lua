local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"

local MarkedPrey = GrooveVerb:new()


function MarkedPrey:getMaximumRange(unit, endPos)
    return 0
end


function MarkedPrey:getTargetType()
    return "unit"
end


function MarkedPrey:execute(unit, targetPos, strParam, path)
    Wargroove.setIsUsingGroove(unit.id, true)
    Wargroove.updateUnit(unit)

    Wargroove.playPositionlessSound("battleStart")
    Wargroove.playGrooveCutscene(unit.id)

    local targets = Wargroove.getTargetsInRange(targetPos, 100, "unit")

    Wargroove.playUnitAnimation(unit.id, "groove_1")
    Wargroove.playMapSound("sedge/sedgeGroove", targetPos)
    Wargroove.waitTime(1)

    Wargroove.setVisibleOverride(unit.id, false)
    Wargroove.waitTime(0.8)
    Wargroove.spawnMapAnimation(targetPos, 0, "fx/groove/sedge_groove_fx", "idle", "sky", { x = 12, y = 12 })

    Wargroove.playGrooveEffect()

    -- -- Could add sorting for cleaner order to death animations
    -- local function distFromTarget(a)
    --     return math.abs(a.x - targetPos.x) + math.abs(a.y - targetPos.y)
    -- end
    -- table.sort(targets, function(a, b) return distFromTarget(a) < distFromTarget(b) end)

    for i, pos in ipairs(targets) do
        local u = Wargroove.getUnitAt(pos)
        local uc = u.unitClass
        -- local shouldDie = false
        if u ~= nil and Wargroove.areEnemies(u.playerId, unit.playerId) and (not uc.isStructure) then
            if u.health <= 30 then
                u:setHealth(0, unit.id)
            
                Wargroove.updateUnit(u)
                Wargroove.playUnitAnimation(u.id, "hit")  
                Wargroove.waitTime(0.2)
            end
        end
    end

    Wargroove.waitTime(0.6)    
    Wargroove.unsetVisibleOverride(unit.id)

    Wargroove.playUnitAnimation(unit.id, "groove_3")
    Wargroove.waitTime(1.2)

end

-- function MarkedPrey:onPostUpdateUnit(unit, targetPos, strParam, path)
--     GrooveVerb.onPostUpdateUnit(self, unit, targetPos, strParam, path)
--     local u = Wargroove.getUnitAt(targetPos)
--     if not u or u.health == 0 then
--         unit.hadTurn = false
--         unit.grooveCharge = unit.unitClass.maxGroove
--     end
-- end

function MarkedPrey:generateOrders(unitId, canMove)
    local orders = {}

    local unit = Wargroove.getUnitById(unitId)
    local unitClass = Wargroove.getUnitClass(unit.unitClassId)
    local movePositions = {}
    if canMove then
        movePositions = Wargroove.getTargetsInRange(unit.pos, unitClass.moveRange, "empty")
    end
    table.insert(movePositions, unit.pos)

    for i, pos in pairs(movePositions) do
        local targets = Wargroove.getTargetsInRangeAfterMove(unit, pos, pos, 100, "unit")
        
        -- from groove_drain_aura
        if #targets ~= 0 then
            if self:canSeeTarget(pos) then
                orders[#orders+1] = {targetPosition = pos, strParam = "", movePosition = pos, endPosition = pos}
            end
        end
        -- -- Not sure what generateOrders does, above is from groove_drain_aura
        -- for j, targetPos in pairs(targets) do
        --     local u = Wargroove.getUnitAt(targetPos)
        --     if u ~= nil then
        --         local uc = Wargroove.getUnitClass(u.unitClassId)
        --         if Wargroove.areEnemies(u.playerId, unit.playerId) and not uc.isStructure and self:canSeeTarget(targetPos) then
        --             local isSummon = false
        --             for i, tag in ipairs(uc.tags) do
        --                 if tag == "summon" then
        --                     isSummon = true
        --                 end
        --             end
        --             if not isSummon then
        --                 orders[#orders+1] = {targetPosition = targetPos, strParam = "", movePosition = pos, endPosition = pos}
        --             end
        --         end
        --     end
        -- end
    end

    return orders
end


return MarkedPrey
