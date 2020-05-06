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
- Emeric
- Errol & Orla
- Mercival
- Nuru
- Ryota
    - groove damage ramp per jump: +5% -> -5%
- Sigrid

#### Units:
- Trebuchet
    - min range: 2 -> 4
    - structure base damage: 0.85 -> 0.7

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
