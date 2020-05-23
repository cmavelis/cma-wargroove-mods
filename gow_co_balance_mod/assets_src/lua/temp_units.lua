
local temp_units = {}

temp_units.forward = {
    harpoonship="harpoonship_move_only",
    warship="warship_move_only",
    turtle="turtle_move_only",
    travelboat="travelboat_move_only"
}

-- reverse is used to automatically reset temp units at end of turn
temp_units.reverse = {}
for k,v in pairs(temp_units.forward) do
    temp_units.reverse[v] = k
end
temp_units.reverse["commander_twins_water"] = "commander_twins"


return temp_units