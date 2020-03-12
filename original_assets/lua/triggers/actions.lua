local Wargroove = require "wargroove/wargroove"
local Actions = {}

function Actions.populate(dst)
    dst["set_map_flag"] = Actions.setMapFlag
    dst["set_campaign_flag"] = Actions.setCampaignFlag
    dst["set_party_member"] = Actions.setPartyMember
    dst["modify_counter"] = Actions.modifyCounter
    dst["add_campaign_cutscene"] = Actions.addCampaignCutscene
    dst["spawn_unit"] = Actions.spawnUnit
    dst["remove_units"] = Actions.removeUnits
    dst["modify_gold"] = Actions.modifyGold
    dst["modify_health"] = Actions.modifyHealth
    dst["modify_groove"] = Actions.modifyGroove
    dst["victory"] = Actions.victory
    dst["eliminate"] = Actions.eliminate
    dst["convert"] = Actions.convert
    dst["change_unit_type"] = Actions.changeUnitType
    dst["reveal_fow"] = Actions.revealFoW
    dst["change_team"] = Actions.changeTeam
    dst["message"] = Actions.message
    dst["dialogue_box"] = Actions.dialogueBox
    dst["dialogue_box_simple"] = Actions.dialogueBoxSimple
    dst["wait"] = Actions.wait
    dst["centre_camera"] = Actions.centreCamera
    dst["ai_set_profile"] = Actions.aiSetProfile
    dst["set_weather"] = Actions.setWeather
    dst["ai_set_restriction"] = Actions.aiSetRestriction
    dst["set_unit_spent"] = Actions.setUnitSpent
    dst["play_cutscene"] = Actions.playCutscene
    dst["set_location_highlight"] = Actions.setLocationHighlight
    dst["set_conditional_location_highlight"] = Actions.setConditionalLocationHighlight
    dst["force_action"] = Actions.forceAction
    dst["force_open_ui_tutorial"] = Actions.forceOpenUITutorial
    dst["queue_force_action"] = Actions.queueForceAction
    dst["queue_force_open_ui_tutorial"] = Actions.queueForceOpenUITutorial
    dst["add_ui_tutorial"] = Actions.addUITutorial
    dst["play_credits"] = Actions.playCredits
    dst["set_match_seed"] = Actions.setMatchSeed
    dst["update_fog_of_war"] = Actions.updateFogOfWar
    dst["change_objective"] = Actions.changeObjective
    dst["show_objective"] = Actions.showObjective
    dst["move_location_to_unit"] = Actions.moveLocationToUnit
    dst["move_location_to_location"] = Actions.moveLocationToLocation
    dst["set_map_music"] = Actions.setMapMusic
    dst["play_groove_cutscene"] = Actions.playGrooveCutscene
end


function Actions.setMapFlag(context)
    -- "Set Map Flag {0} to {1}"
    context:setMapFlag(0, context:getBoolean(1))
end


function Actions.setCampaignFlag(context)
    -- "Set Campaign Flag {0} to {1}"
    context:setCampaignFlag(0, context:getBoolean(1))
end


function Actions.setPartyMember(context)
    -- "Set {0}'s presence in party to {1}"
    context:setPartyMember(0, context:getBoolean(1))
end


function Actions.modifyCounter(context)
    -- "Counter {0}: {1} {2}"
    local curValue = context:getMapCounter(0)
    local op = context:getOperation(1)
    local value = context:getInteger(2)
    context:setMapCounter(0, op(curValue, value))
end

function Actions.addCampaignCutscene(context)
    -- "Sets the cutscene {0} to be played after the match is over on the campaign map."
    context:addCampaignCutscene(0)
end

local function findCentreOfLocation(location)
    local centre = { x = 0, y = 0 }
    for i, pos in ipairs(location.positions) do
        centre.x = centre.x + pos.x
        centre.y = centre.y + pos.y
    end
    centre.x = centre.x / #(location.positions)
    centre.y = centre.y / #(location.positions)

    return centre
end


function Actions.spawnUnit(context)
    -- "Spawn {0} at {1} for {2} (silent = {3})"
    local unitClassId = context:getUnitClass(0)
    local location = context:getLocation(1)
    local playerId = context:getPlayerId(2)
    local silent = context:getBoolean(3)

    local candidates = {}

    if location == nil then
        -- No location, use centre of map
        local mapSize = Wargroove.getMapSize()
        local cX = math.floor(mapSize.x / 2)
        local cY = math.floor(mapSize.y / 2)
        for x = 0, mapSize.x - 1 do
            for y = 0, mapSize.y - 1 do
                local pos = { x = x, y = y }
                if Wargroove.getUnitIdAt(pos) == -1 and Wargroove.canStandAt(unitClassId, pos) then
                    local dx = x - cX
                    local dy = y - cY
                    local dist = dx * dx + dy * dy
                    table.insert(candidates, { pos = pos, dist = dist })
                end
            end
        end
    else
        -- Find the centre of the location
        local centre = findCentreOfLocation(location)

        -- All candidates
        for i, pos in ipairs(location.positions) do
            if Wargroove.getUnitIdAt(pos) == -1 and Wargroove.canStandAt(unitClassId, pos) then
                local dx = pos.x - centre.x
                local dy = pos.y - centre.y
                local dist = dx * dx + dy * dy
                table.insert(candidates, { pos = pos, dist = dist })
            end
        end
    end

    -- Sort candidates
    table.sort(candidates, function(a, b) return a.dist < b.dist end)

    -- Spawn at the best candidate
    if #candidates > 0 then
        local pos = candidates[1].pos
        if not silent then
            Wargroove.trackCameraTo(pos)
        end
        Wargroove.spawnUnit(playerId, pos, unitClassId, false)
        Wargroove.clearCaches()
        if silent or (not Wargroove.canCurrentlySeeTile(pos)) then
            -- Need to wait two frames to prevent being able to spawn on top of other units
            Wargroove.waitFrame()
            Wargroove.waitFrame()
        else
            Wargroove.spawnMapAnimation(pos, 0, "fx/mapeditor_unitdrop")
            Wargroove.waitTime(0.5)
        end
    end
end


function Actions.removeUnits(context)
    -- "Remove units of type {0} at {1} for {2}"
    local units = context:gatherUnits(2, 0, 1)

    for i, unit in ipairs(units) do
        Wargroove.trackCameraTo(unit.pos)
        Wargroove.removeUnit(unit.id)
        Wargroove.spawnMapAnimation(unit.pos, 0, "fx/mapeditor_unitdrop")
        Wargroove.clearCaches()
        Wargroove.waitTime(0.2)
    end
end


function Actions.modifyGold(context)
    -- "Modify Gold for {0}: {1} {2}"
    local playerId = context:getPlayerId(0)
    local operation = context:getOperation(1)
    local value = context:getInteger(2)
    local previous = Wargroove.getMoney(playerId)

    Wargroove.setMoney(playerId, operation(previous, value))
end


function Actions.modifyHealth(context)
    -- "Modify Health of {0} at {1} for {2}: {3} {4}%"
    local operation = context:getOperation(3)
    local value = context:getInteger(4)
    local units = context:gatherUnits(2, 0, 1)

    local deadUnitId = -1
    for i, unit in ipairs(units) do
        local newValue = operation(unit.health, value)
        if (newValue <= 0) then
            deadUnitId = unit.id
        end
        unit:setHealth(newValue, -1)
    end

    Wargroove.updateUnits(units)

    if (deadUnitId >= 0) then
        Wargroove.doLuaDeathCheck(deadUnitId)
    end

    coroutine.yield()
end


function Actions.setUnitSpent(context)
    -- "Set turn spent for {0} at {1} for {2}: {3}"
    local value = context:getBoolean(3)
    local units = context:gatherUnits(2, 0, 1)

    for i, unit in ipairs(units) do
        unit.hadTurn = value
    end

    Wargroove.updateUnits(units)
end

function Actions.playCutscene(context)
    -- "Play cutscene {0}"
    Wargroove.playCutscene(context:getCutscene(0))
end

function Actions.setLocationHighlight(context)
    -- "Set highlight of location {0} to {1} with the colour {2}."

    if context:getLocation(0) == nil then
        print("Set location highlight event had no location set.")
        return
    end

    Wargroove.highlightLocation(context:getLocation(0).id, context:getLocationHighlight(1), context:getPlayerColour(2), false, false, false, false)
end

function Actions.setConditionalLocationHighlight(context)
    -- "Set highlight of location {0} to {1} with the colour {2}. Hide on selection: {3}. Show: {4}"
    local locationId = context:getLocation(0).id
    local highlight = context:getLocationHighlight(1)
    local playerColour = context:getPlayerColour(2)

    local hideOnSelection = context:getBoolean(3)

    local showOnUnitSelection = false
    local showOnEndPosSelection = false
    local showOnActionSelected = false

    local showType = context:getString(4)
    if showType == "start" then
        -- do nothing
    elseif showType == "unit_selected" then
        showOnUnitSelection = true
    elseif showType == "path_selected" then
        showOnEndPosSelection = true
    elseif showType == "action_selected" then
        showOnActionSelected = true
    end

    local hideOnAction = true
    
    Wargroove.highlightLocation(locationId, highlight, playerColour, hideOnSelection, hideOnAction, showOnUnitSelection, showOnEndPosSelection, showOnActionSelected)
end

function Actions.modifyGroove(context)
    -- "Modify Groove of {0} at {1} for {2}: {3} {4}%"
    local operation = context:getOperation(3)
    local value = context:getInteger(4)
    local units = context:gatherUnits(2, 0, 1)

    for i, unit in ipairs(units) do
        local grooveCharge = unit.grooveCharge / unit.unitClass.maxGroove * 100.0
        unit:setGroove(operation(grooveCharge, value))
    end

    Wargroove.updateUnits(units)
end


function Actions.victory(context)
    -- "Give victory to {0}"
    Wargroove.giveVictory(context:getPlayerId(0))
end


function Actions.eliminate(context)
    -- "Eliminate {0}"
    Wargroove.eliminate(context:getPlayerId(0))
end


function Actions.convert(context)
    -- "Convert {0} from {1} at {2} to {3}"
    local targetPlayer = context:getPlayerId(3)
    local units = context:gatherUnits(1, 0, 2)

    for i, unit in ipairs(units) do
        unit.playerId = targetPlayer
    end

    Wargroove.updateUnits(units)
    Wargroove.waitFrame()
    Wargroove.clearCaches()
end


function Actions.changeUnitType(context)
    -- "Change {0} from {1} at {2} to {3}"
    local units = context:gatherUnits(1, 0, 2)
    local unitClassId = context:getString(3)

    for i, unit in ipairs(units) do
        unit.unitClassId = unitClassId
    end

    Wargroove.updateUnits(units)
    Wargroove.waitFrame()
    Wargroove.clearCaches()
end


function Actions.revealFoW(context)
    -- "Reveal Fog of War at {0} to {1}"
    -- TODO
    print("TODO: Actions.revealFoW")
end


function Actions.changeTeam(context)
    -- "Change {0} to {1}"
    Wargroove.setPlayerTeam(context:getPlayerId(0), context:getTeam(1))
end


function Actions.message(context)
    -- "Display message: {0}"
    Wargroove.showMessage(context:getString(0))
end


function Actions.dialogueBox(context)
    -- "Display dialogue box with {0} {1} saying {2} with shout {3}."
    Wargroove.showDialogueBox(context:getString(0), context:getString(1), context:getString(2), context:getString(3))
end


function Actions.dialogueBoxSimple(context)
    -- "Display dialogue box with {0} {1} saying {2}."
    Wargroove.showDialogueBox(context:getString(0), context:getString(1), context:getString(2), "")
end


function Actions.wait(context)
    -- "Wait {0} milliseconds."
    Wargroove.waitTime(context:getInteger(0) * 0.001)
end


function Actions.centreCamera(context)
    -- "Centre camera at {0}."
    local location = context:getLocation(0)
    
    if (location == nil) then
        return
    end

    local pos = findCentreOfLocation(context:getLocation(0))
    pos.x = math.floor(pos.x)
    pos.y = math.floor(pos.y)
    Wargroove.trackCameraTo(pos)
end


function Actions.aiSetProfile(context)
    local targetPlayer = context:getPlayerId(0)
    local profile = context:getString(1)
    Wargroove.setAIProfile(targetPlayer, profile)
end

function Actions.setWeather(context)
    local weatherFrequency = context:getString(0)
    local daysAhead = context:getInteger(1)
    Wargroove.setWeather(weatherFrequency, daysAhead)
end

function Actions.aiSetRestriction(context)
    -- "Set AI restriction of {0} at {1} for {2}: Set {3} to {4}"
    local restriction = context:getString(3)
    local value = context:getBoolean(4)
    local units = context:gatherUnits(2, 0, 1)

    for i, unit in ipairs(units) do
        Wargroove.setAIRestriction(unit.id, restriction, value)
    end

    Wargroove.updateUnits(units)
end

function Actions.forceAction(context)
    Actions.doForceAction(context, false)
end

function Actions.forceOpenUITutorial(context)
    Actions.doForceOpenUITutorial(context, false)
end

function Actions.queueForceAction(context)
    Actions.doForceAction(context, true)
end

function Actions.queueForceOpenUITutorial(context)
    Actions.doForceOpenUITutorial(context, true)
end

function Actions.doForceAction(context, queue)
    -- "Force a unit at location {0} to do action {1} from location {2} targeting location {3}. Auto end: {4} On failure, display dialouge box with {5} {6} saying {7}"

    local fromLocation = context:getLocation(0)
    local action = context:getString(1)
    local toLocation = context:getLocation(2)
    local targetLocation = context:getLocation(3)    
    local autoEnd = context:getBoolean(4)
    local expression = context:getString(5)
    local commander = context:getString(6)
    local dialogue = context:getString(7)

    local selectableUnits = {}
    for i, unit in ipairs(Wargroove.getUnitsAtLocation(fromLocation)) do
        if context:doesPlayerMatch(unit.playerId,  Wargroove.getCurrentPlayerId()) then
            table.insert(selectableUnits, unit.id)
        end
    end

    local toPositions = {}
    if (toLocation ~= nil) then
        toPositions = toLocation.positions
    end

    local targetPositions = {}
    if (targetLocation ~= nil) then
        targetPositions = targetLocation.positions
    end

    if (queue) then
        Wargroove.queueForceAction(selectableUnits, toPositions, targetPositions, action, autoEnd, expression, commander, dialogue)
    else
        Wargroove.forceAction(selectableUnits, toPositions, targetPositions, action, autoEnd, expression, commander, dialogue)
    end
end

function Actions.doForceOpenUITutorial(context, queue)
    -- "Force a player to do UI tutorial script {0} at {1}. On failure, display dialouge box with {2} {3} saying {4}. On tutorial completion, set Map Flag {5} to {6}."

    local uiTutorial = context:getString(0)
    local toLocation = context:getLocation(1)
    local expression = context:getString(2)
    local commander = context:getString(3)
    local dialogue = context:getString(4)
    local mapFlag = tonumber(context.params[5 + 1])
    local mapFlagValue = context:getBoolean(6)

    local toPositions = {}
    if (toLocation ~= nil) then
        toPositions = toLocation.positions
    end

    if (queue) then
        Wargroove.queueForceOpenTutorial(uiTutorial, toPositions, expression, commander, dialogue, mapFlag, mapFlagValue)
    else
        Wargroove.forceOpenTutorial(uiTutorial, toPositions, expression, commander, dialogue, mapFlag, mapFlagValue)
    end
end

function Actions.addUITutorial(context)
    -- "Starts UI tutorial {0} the next time a player opens a UI window at {1}. On tutorial completion, set Map Flag {2} to {3}."  

    local uiTutorial = context:getString(0)
    local toLocation = context:getLocation(1)
    local mapFlag = tonumber(context.params[2 + 1])
    local mapFlagValue = context:getBoolean(3)

    local toPositions = {}
    if (toLocation ~= nil) then
        toPositions = toLocation.positions
    end
    
    Wargroove.addTutorial(uiTutorial, toPositions, mapFlag, mapFlagValue)
end

function Actions.playCredits(context)
    -- "Plays credits of type {0}."
    context:setCreditsToPlay(0)
end

function Actions.setMatchSeed(context)
    -- "Sets the match seed to {0}."
    Wargroove.setMatchSeed(context:getInteger(0))
end

function Actions.updateFogOfWar(context)
    -- "Updates fog of war."
    Wargroove.updateFogOfWar()
end

function Actions.changeObjective(context)
    -- "Sets the map objective to {0}."
    Wargroove.changeObjective(context:getString(0))
end

function Actions.showObjective(context)
    -- "Shows the current objective."
    Wargroove.showObjective()
end

function Actions.moveLocationToUnit(context)
    -- "Move location {0} to {1} owned by {2} at {3}."
    location = context:getLocation(0)
    units = context:gatherUnits(2, 1, 3)
    for i, unit in ipairs(units) do
        Wargroove.moveLocationTo(location.id, unit.pos)
        return
    end
end

function Actions.moveLocationToLocation(context)
    -- "Move location {0} to {1}."
    location = context:getLocation(0)
    target = context:getLocation(1)
    Wargroove.moveLocationTo(location.id, target.centre)
end

function Actions.setMapMusic(context)
    -- "Sets the map's music to {0}."
    Wargroove.setMapMusic(context:getString(0))
end

function Actions.playGrooveCutscene(context)
    -- "Play groove cutscene for {0}."
    Wargroove.playGrooveCutsceneForCharacter(context:getString(0))
end

return Actions
