local HealthBadges = {}

HealthBadges["unitClasses"] = {
    "city",
    "port",
    "water_city",
    "hideout",
    "hq",
    "tower",
    "barracks",
    "gate",
    "commander_mercia",
    "commander_greenfinger",
    "commander_mercival",
    "commander_emeric",
    "commander_darkmercia",
    "commander_koji",
    "commander_caesar",
    "ballista",
    "balloon",
    "commander_elodie",
    "archer",
    "commander_vesper",
    "commander_ryota",
    "commander_sigrid",
    "commander_nuru",
    "commander_twins",
    "commander_sedge",
    "commander_ragna",
    "commander_valder",
    "commander_tenri",
    "dragon",
    "giant",
    "crystal",
    "harpoonship",
    "harpy",
    "dog",
    "drone",
    "commander_wulfar",
    "commander_errol",
    "garrison",
    "ghost_mercival",
    "merman",
    "soldier",
    "spearman",
    "shadow_vesper",
    "rifleman",
    "commander_orla",
    "knight",
    "mage",
    "vine",
    "warship",
    "villager",
    "turtle",
    "wagon",
    "witch",
    "thief",
    "travelboat",
    "commander_vesper_boss",
    "thief_with_gold",
    "trebuchet"
}

function HealthBadges.createFunction()
    local HealthBadgesAnimation = "ui/icons/badges"

    local function HealthBadgesFunction(Wargroove, unit)
        if Wargroove.isSimulating() then
            return
        end

        if unit.health < 100 then
            local badgeFrame = ""
            if unit.health < 10 then
                badgeFrame = "badge0" .. unit.health
            else
                badgeFrame = "badge" .. unit.health
            end

            if not Wargroove.hasUnitEffect(unit.id, HealthBadgesAnimation) then
                Wargroove.spawnUnitEffect(unit.id, HealthBadgesAnimation, badgeFrame, startAnimation, true, false)
            elseif Wargroove.hasUnitEffect(unit.id, HealthBadgesAnimation) then
                Wargroove.deleteUnitEffectByAnimation(unit.id, HealthBadgesAnimation)
                Wargroove.spawnUnitEffect(unit.id, HealthBadgesAnimation, badgeFrame, startAnimation, true, false)
            end
        elseif Wargroove.hasUnitEffect(unit.id, HealthBadgesAnimation) then
            Wargroove.deleteUnitEffectByAnimation(unit.id, HealthBadgesAnimation)
        end
    end

    return HealthBadgesFunction
end

return HealthBadges