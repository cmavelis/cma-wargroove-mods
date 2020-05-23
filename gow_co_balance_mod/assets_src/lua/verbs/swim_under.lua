local Wargroove = require "wargroove/wargroove"
local Verb = require "wargroove/verb"

local SwimUnder = Verb:new()

local allowedTargets = {
  "travelboat",
  "harpoonship",
  "warship",
  "harpy",
  "witch",
  "dragon",
  "balloon",
  "drone",
}

function SwimUnder:getMaximumRange(unit, endPos)
  return 1
end

function SwimUnder:getTargetType()
  return "unit"
end

function SwimUnder:canSwimUnder(unit)
  for i, target in pairs(allowedTargets) do
      if target == unit then 
         return true
      end
   end
   return false
end

function SwimUnder:getPointBeyond(unit, targetPos)
  local direction = { x = targetPos.x - unit.pos.x, y = targetPos.y - unit.pos.y}
  return { x = targetPos.x + direction.x, y = targetPos.y + direction.y}
end

function SwimUnder:canExecuteWithTarget(unit, endPos, targetPos, strParam)
  local targetUnit = Wargroove.getUnitAt(targetPos)
  if targetUnit == nil then -- or targetUnit.unitClassId ~= "gate"
    return false
  end

  if not Wargroove.areEnemies(unit.playerId, targetUnit.playerId) then
    return false
  elseif not SwimUnder.canSwimUnder(targetUnit.unitClassId) then
    return false
  end

  local direction = { x = targetPos.x - endPos.x, y = targetPos.y - endPos.y}
  local pointBeyond = { x = targetPos.x + direction.x, y = targetPos.y + direction.y}

  local unitBeyond = Wargroove.getUnitAt(pointBeyond)
  return unitBeyond == nil and Wargroove.canStandAt("turtle", pointBeyond)
end

function SwimUnder:execute(unit, targetPos, strParam, path)
  local pointBeyond = SwimUnder:getPointBeyond(unit, targetPos)

  if targetPos.x > unit.pos.x then
    unit.pos.facing = 1
  elseif targetPos.x < unit.pos.x then
    unit.pos.facing = 3
  end
  Wargroove.updateUnit(unit)

  Wargroove.setVisibleOverride(unit.id, false)

  Wargroove.waitTime(0.5)
end

function SwimUnder:onPostUpdateUnit(unit, targetPos, strParam, path)
  Verb.onPostUpdateUnit(self, unit, targetPos, strParam, path)

  local facing
  if targetPos.x > unit.pos.x then
    facing = 1
  elseif targetPos.x < unit.pos.x then
    facing = 3
  end

  unit.pos = SwimUnder:getPointBeyond(unit, targetPos)
  unit.pos.facing = facing
  
  Wargroove.updateUnit(unit)
  coroutine.yield()
  Wargroove.setVisibleOverride(unit.id, true)
end

return SwimUnder
