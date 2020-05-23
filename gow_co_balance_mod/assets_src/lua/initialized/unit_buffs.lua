local OldUnitBuffs = require "wargroove/unit_buffs"
local Wargroove = require "wargroove/wargroove"

local UnitBuffs = {}

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local CopyUnitBuffs = deepcopy(OldUnitBuffs)

function UnitBuffs.init()
    OldUnitBuffs.getBuffs = UnitBuffs.getBuffs
end

function UnitBuffs:getBuffs()
    local OldBuffs = CopyUnitBuffs.getBuffs()

    function OldBuffs.harpoonship_move_only(Wargroove, unit)
        if Wargroove.isSimulating() then
            return
        end
        print('firing')
        if unit.playerId ~= Wargroove.getCurrentPlayerId() then
            print('updatings')
            unit.unitClassId = "harpoonship"
            Wargroove.updateUnit(unit)
        end
    end

    return OldBuffs
end

return UnitBuffs