# HCDeaths
This addon will save Turtle WoW hardcore deaths to *"\WTF\Account\ACCOUNTNAME\SavedVariables\HCDeaths.lua"*.

The format of the data is as follows:

```
date,time,deathType,zone,playerName,playerLevel,playerClass,killerName,killerLevel,killerClass
```

Example of HCDeaths.lua from the SavedVariables folder:

```
HCDeaths = {
	[1] = "2023/04/02,22:18,PVE,Redridge Mountains,Calessara,19,Mage,Blackrock Outrunner,21,NPC",
	[2] = "2023/04/02,22:19,PVE,Redridge Mountains,Tassu,19,Rogue,Blackrock Outrunner,21,NPC",
	[3] = "2023/04/02,22:21,PVE,Teldrassil,Okimi,12,Mage,Oakenscowl,9,NPC",
	[4] = "2023/04/02,22:21,PVP,Westfall,Checoelevent,20,Mage,Chicagobulls,19,Hunter",
	[5] = "2023/04/02,22:28,PVE,Dun Morogh,Tommy,11,Paladin,Rockjaw Bonesnapper,9,NPC",
	[6] = "2023/04/02,22:28,PVE,Durotar,Jalda,10,Shaman,Fizzle Darkstorm,12,NPC",
	[7] = "2023/04/02,22:33,PVE,Loch Modan,Grimlly,13,Hunter,Black Bear Patriarch,17,NPC",
	[8] = "2023/04/02,22:38,PVE,Elwynn Forest,Hadzy,10,Hunter,Longsnout,11,NPC",
	[9] = "2023/04/02,22:40,PVP,Mulgore,Earthspec,12,Shaman,Lodr,10,Hunter",
	[10] = "2023/04/02,22:43,PVE,Teldrassil,Turbowarrior,13,Warrior,Gnarlpine Pathfinder,9,NPC",
}
```

## Credit
Code from [HardcoreDeath](https://github.com/Lexiebean/HardcoreDeath/) by [Lexiebean](https://github.com/Lexiebean/)
