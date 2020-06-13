# cma-wargroove-mods

A collection of Wargroove mods

Contributors:
 - CMAvelis
 - Unicarn

Mods contained:
- Expanded HP badges mod
- CMA balance mod
- Logging mod
- Groove Testmod

## Expanded HP badges Mod 

Official modpacker version of Unicarn's new Expanded HP badges
Now adds all hp badges, not just increments of 5!

Known bug: 
 - Icons/animations applied using this mod's method (same method as riflemen ammo) flip on/off on clicking units when multiple are on-screen

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
