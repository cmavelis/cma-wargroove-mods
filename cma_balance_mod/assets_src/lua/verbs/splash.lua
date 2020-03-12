local Wargroove = require "wargroove/wargroove"
local Verb = require "wargroove/verb"
local Combat = require "wargroove/combat"

local Splash = Verb:new()
-- splash attack for the 3 squares in front of unit


-- -- TODO:
-- range finder (Wargroove.getTargetsInRange)
--     X
--   G X
--     X
-- X X X
--   G
--

-- calculate attack dmg like regular attack
-- counterattack
-- confirmation of action

-- -- nice-to-have:
-- add range indicator

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

function Splash:getMaximumRange(unit, endPos)
    return 1
end

function Splash:getTargetType()
    return "all"
end

function Splash:execute(unit, targetPos, strParam, path)
    Wargroove.spawnMapAnimation(unit.pos, 1, "fx/groove/koji_groove_fx", "idle", "behind_units", { x = 12, y = 12 })
    print("==Splash:execute")
    local targets = Wargroove.getTargetsInRange(targetPos, 1, "unit")

    local facing = getFacing(unit.pos, targetPos)

--    if (targetType == "all") then
--        table.insert(result, { x = x, y = y})
--    else

    local function squareRadiusFromPos(a, pos)
        print('square check', a.x, a.y, pos.x, pos.y)
        print(math.max(math.abs(a.x - pos.x), math.abs(a.y - pos.y)))
        return math.max(math.abs(a.x - pos.x), math.abs(a.y - pos.y))
    end

    for i, pos in ipairs(targets) do
        if squareRadiusFromPos(pos, unit.pos) < 2 then
            local u = Wargroove.getUnitAt(pos)
            if u and Wargroove.areEnemies(u.playerId, unit.playerId) then
                local damage = Combat:getGrooveAttackerDamage(unit, u, "random", unit.pos, u.pos, path, "kojiAttack") * 0.5
    --            edit damage to follow attack pattern
                u:setHealth(u.health - damage, unit.id)
                Wargroove.updateUnit(u)
                Wargroove.playUnitAnimation(u.id, "hit")
            end
        end
    end

    Wargroove.playMapSound("koji/kojiDroneExplode", unit.pos)

    Wargroove.waitTime(0.4)
end

-- function Splash:generateOrders(unitId, canMove)
--     local orders = {}

--     local unit = Wargroove.getUnitById(unitId)
--     local unitClass = Wargroove.getUnitClass(unit.unitClassId)
--     local movePositions = {}
--     if canMove then
--         movePositions = Wargroove.getTargetsInRange(unit.pos, unitClass.moveRange, "empty")
--     end
--     table.insert(movePositions, unit.pos)

--     for i, pos in pairs(movePositions) do
--         orders[#orders+1] = {targetPosition = pos, strParam = "", movePosition = pos, endPosition = pos}
--     end

--     for i,line in ipairs(orders) do
--         print(line)
--     end

--     return orders
-- end

-- function Splash:getScore(unitId, order)
--     local unit = Wargroove.getUnitById(unitId)
--     local targets = Wargroove.getTargetsInRangeAfterMove(unit, order.endPosition, order.endPosition, 1, "unit")

--     local effectivenessScore = 0.0
--     local totalValue = 0.0

--     local foundTarget = false
--     for i, target in ipairs(targets) do
--         local u = Wargroove.getUnitAt(target)
--         if u ~= nil and Wargroove.areEnemies(u.playerId, unit.playerId) then
--             foundTarget = true
--             local damage = Combat:getGrooveAttackerDamage(unit, u, "aiSimulation", unit.pos, u.pos, path, "kojiAttack") * 0.5
--             local newHealth = math.max(0, u.health - damage)
--             local theirValue = Wargroove.getAIUnitValue(u.id, target)
--             local theirDelta = theirValue - Wargroove.getAIUnitValueWithHealth(u.id, target, newHealth)
--             effectivenessScore = effectivenessScore + theirDelta
--             totalValue = totalValue + theirValue
--         end
--     end

--     if not foundTarget then
--         return {score = -1, introspection = {}}
--     end

--     local locationGradient = 0.0
--     if (Wargroove.getAICanLookAhead(unitId)) then
--         locationGradient = Wargroove.getAILocationScore(unit.unitClassId, order.endPosition) - Wargroove.getAILocationScore(unit.unitClassId, unit.pos)
--     end
--     local gradientBonus = 0.0
--     if (locationGradient > 0.0001) then
--         gradientBonus = 0.25
--     end

--     local bravery = Wargroove.getAIBraveryBonus()
--     local attackBias = Wargroove.getAIAttackBias()

--     local score = (effectivenessScore + gradientBonus + bravery) * attackBias
--     local introspection = {
--         {key = "effectivenessScore", value = effectivenessScore},
--         {key = "totalValue", value = totalValue},
--         {key = "bravery", value = bravery},
--         {key = "attackBias", value = attackBias}}

--     return {score = score, introspection = introspection}
-- end

return Splash
