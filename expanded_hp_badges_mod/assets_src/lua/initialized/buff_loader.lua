local XHPBadgeBuff = require "buffs/expanded_hp_badges"


-- imported buffs should have a "unitClasses" field and a createFunction() field
local BuffsToLoad = {
    XHPBadgeBuff
}

-- loading game's original buffs first
local OldUnitBuffs = require "wargroove/unit_buffs"
local BaseGameBuffs = require "buffs/vanilla_unit_buffs_2-1"


local BuffLoader = {}
BuffLoader.Buffs = BaseGameBuffs

function BuffLoader:init()
    BuffLoader.loadBuffs()
    OldUnitBuffs.Buffs = BuffLoader.Buffs
    OldUnitBuffs.getBuffs = BuffLoader.getBuffs
end

local unpack = table.unpack or unpack

function stackFunctions(fcnOne, fcnTwo)
    print('wrapped Buffs')
    return function (...)
        local arg = {...}
        arg.n = select("#", ...)
        fcnOne(unpack(arg, 1))  
        fcnTwo(unpack(arg, 1))  
    end
end


-- this function will apply any buffs we import and declare
function BuffLoader.loadBuffs()
    -- Buffs["thief"] already exists, for example

    for i, buffToLoad in pairs(BuffsToLoad) do
        print("buff#: ",i)
        for j, buffedUnit in pairs(buffToLoad.unitClasses) do
            print('buff loading: ', buffedUnit)
            local existingBuff = BuffLoader.Buffs[buffedUnit]
            if existingBuff == nil then
                BuffLoader.Buffs[buffedUnit] =  buffToLoad.createFunction()
            else
                BuffLoader.Buffs[buffedUnit] = stackFunctions(existingBuff, buffToLoad.createFunction())
            end
        end
    end
end

function BuffLoader:getBuffs()
    return BuffLoader.Buffs
end

return BuffLoader