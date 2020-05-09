local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"
local OldTeleportBeam = require "verbs/groove_teleport_beam"

local TeleportBeam = GrooveVerb:new()

function TeleportBeam:init()
    OldTeleportBeam.getRecruitableTargets = TeleportBeam.getRecruitableTargets
end

function TeleportBeam:getRecruitableTargets(unit)
    local allUnits = Wargroove.getAllUnitsForPlayer(unit.playerId, true)
    local recruitableUnits = {}
    for i, unit in pairs(allUnits) do
        for i, recruit in pairs(unit.recruits) do
            if OldTeleportBeam.recruitsContain(self, {"ballista", "balloon", "dragon", "giant", "harpoonship", "travelboat", "trebuchet", "wagon", "warship"}, recruit) then
                -- don't add to list
            elseif not OldTeleportBeam.recruitsContain(self, recruitableUnits, recruit) then
                recruitableUnits[#recruitableUnits + 1] = recruit
            end
        end
    end

    if #recruitableUnits == 0 then
        recruitableUnits = {"soldier", "spearman", "dog"}
    end

    return recruitableUnits
end

return TeleportBeam
