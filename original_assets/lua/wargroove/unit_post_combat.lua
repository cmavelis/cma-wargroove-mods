local UnitPostCombat = {}

local PostCombat = {}

function UnitPostCombat:getPostCombat(unitClassId)
    return PostCombat[unitClassId]
end

return UnitPostCombat