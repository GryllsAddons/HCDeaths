# HCDeaths

This addon displays and logs hardcore deaths.   
You can move the log by holding ctrl and shift and dragging ther log.    
You can reset the position by holding ctrl and shift and right clicking the log.    

## Commands:
- /hcdeath message - toggle system death messages
- /hcdeath toast - toggle toast popups
- /hcdeath color - toggle toast ring colors
- /hcdeath deathsound - toggle toast deathsounds
- /hcdeath levelsound - toggle toast levelsounds
- /hcdeath roar - death roars instead of raid alert
- /hcdeath reset - reset settings

## Screenshots:

![hcd2](https://github.com/GryllsAddons/HCDeaths/assets/107083057/f12e7732-d9e2-433c-b987-bc880ef186ed)

![hcd3](https://github.com/GryllsAddons/HCDeaths/assets/107083057/cc52cf51-d0e6-4d52-a510-a884f1103827)

![hcd1](https://github.com/GryllsAddons/HCDeaths/assets/107083057/58b967c1-df33-4620-a2b4-2ae163768802)

## Death Logs:

Hardcore deaths will be saved to *"\WTF\Account\ACCOUNTNAME\SavedVariables\HCDeaths.lua"*.

Example of an entry in SavedVariables\HCDeaths.lua:

```
	[1] = {
		["playerLevel"] = 12,
		["zone"] = "Westfall",
		["stime"] = "16:34:47",
		["killerRace"] = "nil",
		["killerName"] = "Defias Trapper",
		["killerGuild"] = "nil",
		["killerLevel"] = "13",
		["playerGuild"] = "Still Alive",
		["playerClass"] = "Mage",
		["playerRace"] = "Human",
		["sdate"] = "2023/05/21",
		["killerClass"] = "NPC",
		["playerName"] = "Fireinferno",
		["deathType"] = "PVE",
	},
```
