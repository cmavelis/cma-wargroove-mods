local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"
local OldDiplomacy = require "verbs/groove_diplomacy"


local Diplomacy = GrooveVerb:new()

function Diplomacy:init()
    OldDiplomacy.getMaximumRange = Diplomacy.getMaximumRange
end

function Diplomacy:getMaximumRange(unit, endPos)
    return 2
end



return Diplomacy
