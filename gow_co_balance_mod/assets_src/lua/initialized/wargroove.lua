local OldWargroove = require "wargroove/wargroove"

local Wargroove = {}

local api = wargrooveAPI
wargrooveAPI = nil

local helpers = require "helpers"
local inspect = require "inspect"

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

local CopyWargroove = deepcopy(OldWargroove)

function Wargroove:init()
    print('===Wargroove.init')
    for k,v in pairs(Wargroove) do
        if (k ~= 'debugWrap') and (type(v) == 'function') then
            print(k)
            OldWargroove[k] = helpers.debugWrap(v)
        end
    end
end

function Wargroove.getUnitById(unitId)
    assert(unitId ~= nil)

    local result = CopyWargroove.getUnitById(unitId)
    assert(unitId ~= nil)
    print(inspect(result))

    -- allow overhealing in some instances
    local function unitSetHealth(self, health, attackerId, source)
        local maxHp = 100
        if source == "mercia_groove" then
            maxHp = 110
        end
        if source == "dm_groove" and self.unitClassId == "commander_darkmercia" then
            maxHp = 200
        end
        self.health = math.floor(math.max(0, math.min(health, maxHp)) * 0.01 * self.unitClass.maxHealth + 0.5)
        self.attackerId = attackerId
        if attackerId >= 0 then
            attacker = CopyWargroove.getUnitById(attackerId)
            self.attackerUnitClass = attacker.unitClass.id
            self.attackerPlayerId = attacker.playerId
        end
    end

    if unitId == -1 then
        return nil
    end
    
    result.setHealth = unitSetHealth

    return result
end

return Wargroove