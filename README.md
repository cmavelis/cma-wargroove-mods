# cma-wargroove-mods

A collection of Wargroove mods I've been working on

Mods contained:
- GoW Community balance mod
- CMA balance mod
- Logging mod
- Groove Testmod

## GoW Community balance mod

Groove of War community's balance for competitive play after 2.0

### Changes:
#### Commanders:
- Caesar 
    - charge speed: medium -> slow
- Dark Mercia
    - charge speed: slow -> medium
    - damage: 30 -> 25
- Elodie 
    - charge speed: slow -> medium
- Errol & Orla
    - groove mechanics:
        - both grooves may be used once groove is charged, instead of one or the other
        - Scorching Fire is shown as the only groove, then Cooling Water appears as an option afterward (due to simplicity of programming it this way)
        - choosing "Wait" while the Twins can use Cooling Water will reset groove charge to 0 (use it or lose it)
- Nuru
    - groove can no longer summon "non-formation" units:
        - Golems, Trebuchets, Ballista, Wagons, Dragons, Balloons, Warships, Harpoon Ships and Barges
        - "non-formation" refers to their appearance in fight animations as a single unit, instead of multiple
- Ryota
    - groove damage ramp per jump: +5% -> -5%
- Sigrid
    - 2-range teleport added to groove prior to targeting enemy

#### Units:
- Trebuchet
    - min range: 2 -> 4
    - structure base damage: 0.85 -> 0.7
- Mage
    - damage edits
        - harpy 1.4 -> 1.3
        - witch 1.3 -> 1.2
- Barge
    - movement: 10 -> 16
- Turtle
    - movement: 12 -> 18
- Harpoon Ship
    - movement: 4 -> 9
    - attack range: 3-6 -> 3-4
- Warship
    - movement: 8 -> 12
    - attack range: 2-4 -> 2-3

#### Game Mechanics:
- Tile movement for "sailing" type units, i.e. ships
    - Ocean: 1 -> 2
    - Beach: 2 -> 3
    - Sea: 2 -> 3
    - Bridge: 2 -> 3
    - Reef: 4 -> 6


## CMA Balance Mod

This mod adjusts balance from 2.0

- Koji drone damage taken (`damageMultiplier`) 50% -> 85%
- Giant
    - movement 5 -> 3
    - attack cleaves in shape like this
        ```
        - - X
        - G X
        - - X
        ```
implementation notes:


## Logging Mod

The purpose of this mod is to log information in a replay format for usage in a Javascript web application

Progress:
- Have confirmed access to the following:
    - unit moves
        - path taken
    - unit actions
        - damage dealt ?
    - map terrain
    

## Groove Testmod

This is the sandbox for testing new mods to incorporate into the game.  

Grooves inluded:
CO | Groove Name | ID # | Status | Notes
--- | --- | --- | --- | ---
Sedge | Marked Prey | [008] | Implemented | If someone could clip the groove audio into 3 pieces: Whirl, strike, laugh -- I would make the strike sound happen every hit
Sigrid | Effigy | [020] | (wip) | n/a
