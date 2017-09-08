## CSGO-TK-Punish
Community requested plugin to allow players who were team killed to get revenge on their attackers by being allowed to select from a list of punishments.

## Download
Releases are located [here](https://github.com/ZachPerkitny/csgo-tk-punish/releases).

## Installation
Download `teamkillmanager.smx` and place it in the plugins folder on your game server.

## Plugin Details
### Implemented Punishments
* Slap
* Beacon (to disclose their location to the enemy)
* Freeze
* Ignite
* Blind
* Slay

If you'd like me to add more, please make an issue and tag it as an enhancement.

### Convars
`tkp_slap_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max: 1*  
**Description:**  
Whether slap is enabled in the punishments menu.

`tkp_min_tks_for_slap`  
(**Integer**) *Default: 1, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with a slap.  

`tkp_slap_damage`  
(**Integer**) *Default: 15, Min: 0*  
**Description:**  
Health to Subtract when a user is punished by a slap.  

`tkp_beacon_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max: 1*  
**Description:**  
Whether beacon is enabled in the punishments menu.  

`tkp_min_tks_for_beacon`  
(**Integer**) *Default: 1, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with a beacon.  

`tkp_beacon_strip_weapons`  
(**Boolean**) *Default: 1, Min: 0, Max: 1*  
**Description**  
Strips attacker's weapons and prevents pickup while beacon is active  

`tkp_beacon_time`  
(**Integer**) *Default: 5, Min: 0*  
**Description:**  
Time (in seconds) the beacon is active.  

`tkp_beacon_radius`  
(**Float**) *Default 375.0, Min: 50.0, Max: 1500.0*  
**Description:**  
Sets the radius for the beacons.  

`tkp_freeze_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max: 1*  
**Description:**  
Whether freeze is enabled in the punishments menu.  

`tkp_min_tks_for_freeze`  
(**Integer**) *Default: 2, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with freeze.

`tkp_freeze_strip_weapons`  
(**Boolean**) *Default: 1, Min: 0, Max: 1*  
**Description**  
Strips attacker's weapons and prevents pickup while they are frozen.    

`tkp_freeze_time`  
(**Integer**) *Default: 5, Min: 0*  
**Description:**  
Time (in seconds) the user is frozen for.  

`tkp_burn_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max: 1*  
**Description:**  
Whether burn is enabled in the punishments menu.  

`tkp_min_tks_for_burn`  
(**Integer**) *Default: 2, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with burn.  

`tkp_burn_time`  
(**Float**) *Default: 5.0, Min: 0.0*  
**Description:**  
Time (in seconds) the user is burned for.  

`tkp_blind_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max: 1*  
**Description:**  
Whether blind is enabled in the punishments menu.  

`tkp_min_tks_for_blind`  
(**Integer**) *Default: 2, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with blind.  

`tkp_blind_strip_weapons`  
(**Boolean**) *Default: 1, Min: 0, Max: 1*  
**Description**  
Strips attacker's weapons and prevents pickup while they are blinded.     

`tkp_blind_time`  
(**Float**) *Default: 5.0, Min: 0.0*  
**Description:**  
Time (in seconds) the user is blinded for.    

`tkp_slay_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max: 1*  
**Description:**  
Whether slay is enabled in the punishments menu.

`tkp_min_tks_for_slay`  
(**Integer**) *Default: 3, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with slay.

## Contributing and Suggestions
If there's anything you want me to add, or if there's a bug, please post a new issue and label it properly. If you'd like to contribute, go for it.
