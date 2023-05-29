# HCDeaths

This addon displays and logs hardcore deaths.   
You can move the toast or log by holding ctrl and shift and dragging.    
You can reset the toast or log position by holding ctrl and shift and right clicking.    

## Commands:
- /hcd message - toggle system death messages
- /hcd move - toggles the toast so you can move it
- /hcd log - toggle death log		
- /hcd log scale - sets the death log scale
- /hcd toast - toggle toast popups
- /hcd toast scale - sets the toast popup scale
- /hcd toast time - sets the number of seconds the toast will display
- /hcd color - toggle toast ring colors
- /hcd deathsound - toggle toast deathsounds
- /hcd levelsound - toggle toast levelsounds
- /hcd roar - death roars instead of raid alert
- /hcd reset - reset settings

## Screenshots:

![image](https://github.com/GryllsAddons/HCDeaths/assets/107083057/ca495c25-c977-40c7-9657-a3634a900dcb)

![hcd3](https://github.com/GryllsAddons/HCDeaths/assets/107083057/cc52cf51-d0e6-4d52-a510-a884f1103827)

![hcd1](https://github.com/GryllsAddons/HCDeaths/assets/107083057/58b967c1-df33-4620-a2b4-2ae163768802)

![image](https://github.com/GryllsAddons/HCDeaths/assets/107083057/323bf4a1-5880-453a-b3e3-55c2fd7bf97e)

## Death Logs:

Hardcore deaths will be saved to *"\WTF\Account\ACCOUNTNAME\SavedVariables\HCDeaths.lua"*.

Example of an entry in SavedVariables\HCDeaths.lua:

```
	[1] = {
		["playerGuild"] = "Still Alive",
		["stime"] = "16:49:00",
		["killerName"] = "Defias Trapper",
		["lastWords"] = "any tent in GS?",
		["killerClass"] = "NPC",
		["playerName"] = "Kithix",
		["killerGuild"] = "nil",
		["killerRace"] = "nil",
		["playerClass"] = "Priest",
		["zone"] = "Westfall",
		["playerRace"] = "High Elf",
		["killerLevel"] = "12",
		["playerLevel"] = 15,
		["deathType"] = "PVE",
		["sdate"] = "2023/05/29",
	},
```
