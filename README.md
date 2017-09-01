## CSGO-Team-Kill-Manager
Community requested plugin to allow players who were team killed to get revenge on their attackers by being allowed to select from a list of punishments.

## Download
Releases are located [here](https://github.com/ZachPerkitny/csgo-team-kill-manager/releases).

## Installation
Download the archive, extract it, and place `teamkillmanager.smx` in the plugins folder on your gameserver.

## Plugin Details
### Implemented Punishments
* Slap
* Beacon (to disclose their location to the enemy)
* Freeze
* Ignite
* Slay

If you'd like me to add more, please make an issue and tag it as an enhancement.

### Convars
`tkm_slap_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max: 1*  
**Description:**  
Whether slap is enabled in the punishments menu.

`tkm_min_tks_for_slap`  
(**Integer**) *Default: 1, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with a slap.  

`tkm_slap_damage`  
(**Integer**) *Default: 1, Min: 1*  
**Description:**  
Health to Subtract when a user is punished by a slap.  

`tkm_beacon_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max 1*  
**Description:**  
Whether beacon is enabled in the punishments menu.  

`tkm_min_tks_for_beacon`  
(**Integer**) *Default: 1, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with a beacon.  

`tkm_beacon_time`  
(**Integer**) *Default: 5, Min: 0*  
**Description:**  
Time (in seconds) the beaon is active.  

`tkm_beacon_radius`  
(**Float**) *Default 375.0, Min: 50.0, Max: 1500.0*  
**Description:**  
Sets the radius for the beacons.  

`tkm_freeze_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max 1*  
**Description:**  
Whether freeze is enabled in the punishments menu.  

`tkm_min_tks_for_freeze`  
(**Integer**) *Default: 2, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with freeze.  

`tkm_freeze_time`  
(**Integer**) *Default: 5, Min: 0*  
**Description:**  
Time (in seconds) the user is frozen for.  

`tkm_burn_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max 1*  
**Description:**  
Whether burn is enabled in the punishments menu.  

`tkm_min_tks_for_burn`  
(**Integer**) *Default: 2, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with burn.  

`tkm_burn_time`  
(**Integer**) *Default: 5, Min: 0*  
**Description:**  
Time (in seconds) the user is burned for.

`tkm_slay_punishment_enabled`  
(**Boolean**) *Default: 1, Min: 0, Max 1*  
**Description:**  
Whether slay is enabled in the punishments menu.

`tkm_min_tks_for_slay`  
(**Integer**) *Default: 3, Min: 1*  
**Description:**  
Minimum tks before a user can be punished with slay.

## Contributing and Suggestions
If there's anything you want me to add, or if there's a bug, please post a new issue and label it properly. If you'd like to contribute, go for it.
