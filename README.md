# HCDeaths
This addon will save Turtle WoW hardcore deaths to *"\WTF\Account\ACCOUNTNAME\SavedVariables\HCDeaths.lua"*.

The format of the data is as follows:

```
date,time,deathType,zone,playerName,playerLevel,playerClass,killerName,killerLevel,killerClass
```

Example of HCDeaths.lua from the SavedVariables folder:

```
HCDeaths = {
	[1] = "2023/04/08,17:24:11,PVE,The Barrens,Binkybae,18,Mage,Razormane Geomancer,13,NPC",
	[2] = "2023/04/08,17:24:37,PVE,Dun Morogh,Pinkdog,10,Priest,Winter Wolf,8,NPC",
	[3] = "2023/04/08,17:27:00,PVE,Westfall,Svonma,14,Hunter,Defias Smuggler,11,NPC",
	[4] = "2023/04/08,17:31:42,PVE,Loch Modan,Paulissa,14,Hunter,Stonesplinter Bonesnapper,16,NPC",
	[5] = "2023/04/08,17:32:27,PVE,Silverpine Forest,Rivas,20,Hunter,Pyrewood Tailor,14,NPC",
	[6] = "2023/04/08,17:32:55,PVE,Thousand Needles,Omegalock,33,Warlock,Galak Mauler,28,NPC",
	[7] = "2023/04/08,17:32:56,PVE,Westfall,Stavropol,20,Warlock,Carver Molsen,21,NPC",
	[8] = "2023/04/08,17:40:38,PVE,Durotar,Dosar,14,Warrior,Sand Shark,12,NPC",
	[9] = "2023/04/08,17:44:42,PVE,Dun Morogh,Scalefisher,10,Warrior,Rockjaw Bonesnapper,10,NPC",
	[10] = "2023/04/08,17:45:42,PVE,Stonetalon Mountains,Nakhunkorn,20,Hunter,Young Pridewing,19,NPC",
}
```

## Credit
Code from [HardcoreDeath](https://github.com/Lexiebean/HardcoreDeath/) by [Lexiebean](https://github.com/Lexiebean/)
