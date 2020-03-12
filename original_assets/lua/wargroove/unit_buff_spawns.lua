local UnitBuffSpawns = {}

local BuffSpawns = {}

function BuffSpawns.crystal(Wargroove, unit)
    Wargroove.displayBuffVisualEffect(unit.id, unit.playerId, "units/commanders/emeric/crystal_aura", "spawn", 0.3)
end

function UnitBuffSpawns:getBuffSpawns()
    return BuffSpawns
end

return UnitBuffSpawns