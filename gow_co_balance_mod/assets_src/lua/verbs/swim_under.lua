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

function SwimUnder.canSwimUnder(unitClassId)
  for i, target in pairs(allowedTargets) do
      if target == unitClassId then 
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
  if targetUnit == nil then
    return false
  end

  if not Wargroove.areEnemies(unit.playerId, targetUnit.playerId) then
    return false
  elseif not SwimUnder.canSwimUnder(targetUnit.unitClassId) then
    return false
  elseif not Wargroove.canStandAt("turtle", targetPos) then
    return false
  end

  local direction = { x = targetPos.x - endPos.x, y = targetPos.y - endPos.y}
  local pointBeyond = { x = targetPos.x + direction.x, y = targetPos.y + direction.y}
  if not self:canSeeTarget(pointBeyond) then -- fog fix: need to be able to see ending space
    return false
  end
  local unitBeyond = Wargroove.getUnitAt(pointBeyond)
  return Wargroove.canStandAt("turtle", pointBeyond) and unitBeyond == nil
end

function SwimUnder:execute(unit, targetPos, strParam, path)
  local pointBeyond = SwimUnder:getPointBeyond(unit, targetPos)

  if targetPos.x > unit.pos.x then
    unit.pos.facing = 1
  elseif targetPos.x < unit.pos.x then
    unit.pos.facing = 3
  end
  Wargroove.updateUnit(unit)

  local splashFX = Wargroove.getSplashEffect()
  Wargroove.spawnMapAnimation(unit.pos, 1, splashFX)
  Wargroove.playMapSound("unitSplash", unit.pos)

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
  local splashFX = Wargroove.getSplashEffect()
  Wargroove.setVisibleOverride(unit.id, true)
  Wargroove.spawnMapAnimation(unit.pos, 1, splashFX, "idle", "behind_units", {x=12, y=8})
  Wargroove.playMapSound("unitSplash", unit.pos)
end

return SwimUnder
