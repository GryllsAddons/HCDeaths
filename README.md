# HCDeaths
This addon will save Turtle WoW hardcore deaths to *"\WTF\Account\ACCOUNTNAME\SavedVariables\HCDeaths.lua"*.

The format of the data is as follows:

```
date,time,deathType,zone,playerName,playerLevel,playerClass,killerName,killerLevel,killerClass
```

Example of HCDeaths.lua from the SavedVariables folder:

```
HCDeaths = {
	[1] = "2023/03/31,17:24:11,PVE,Elwynn Forest,Tents,10,Rogue,Mangy Wolf,5,NPC",
	[2] = "2023/03/31,17:24:37,PVP,Elwynn Forest,Tents,10,Rogue,Strongwind,60,Warrior",
	[3] = "2023/03/31,17:25:35,PVE,Elwynn Forest,Tents,10,Rogue,Natural Causes,nil,ENV",
}
```

## Credit
Code from [HardcoreDeath](https://github.com/Lexiebean/HardcoreDeath/) by [Lexiebean](https://github.com/Lexiebean/)
