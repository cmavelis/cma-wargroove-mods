local UnitBuffs = {}

local Buffs = {}

function Buffs.crystal(Wargroove, unit)
    Wargroove.displayBuffVisualEffect(unit.id, unit.playerId, "units/commanders/emeric/crystal_aura", "idle", 0.3)

    local range = 3
    local positions = Wargroove.getTargetsInRange(unit.pos, range, "all")
    for i, pos in pairs(positions) do
        local u = Wargroove.getUnitAt(pos)

        -- If (and only if) it's your turn, or your ally's, also apply to empty tiles, because your unit might be about to move that.
        -- Otherwise, combat results preview will be wrong.
        -- Likewise, if this happens on an enemy's turn, preview will be wrong.
        -- Note that preview also affects AI's ability to judge moves.
        local includeEmpty = Wargroove.areAllies(Wargroove.getCurrentPlayerId(), unit.playerId)

        if (u == nil and includeEmpty) or (u ~= nil and Wargroove.areAllies(u.playerId, unit.playerId)) then
            local baseDefence = Wargroove.getBaseTerrainDefenceAt(pos)
            local currentDefence = Wargroove.getTerrainDefenceAt(pos)
            local newDefence = math.min(math.max(baseDefence + 3, currentDefence), 4)
            Wargroove.setTerrainDefenceAt(pos, newDefence)

            local baseSkyDefence = Wargroove.getBaseSkyDefence()
            local currentSkyDefence = Wargroove.getSkyDefenceAt(pos)
            local newSkyDefence = math.min(math.max(baseSkyDefence + 3, currentSkyDefence), 4)
            Wargroove.setSkyDefenceAt(pos, newSkyDefence)
        end
    end
end

function UnitBuffs:getBuffs()
    return Buffs
end

return UnitBuffs