local turtle = (TargetHPText or TargetHPPercText)
if not turtle then
		HCDeath:print("This addon will only function correctly for Turtle WoW.")
    return
end

HCDeaths_Settings = {
	message = true,
	log = true,
	toast = true,
	color = false,
	deathsound = true,
	levelsound = true,
	roar = false,
	toastscale = 1,
	logscale = 1,
}

local deathsound = {
	["Dwarf"] = {
		[1] = "Sound\\Character\\Dwarf\\DwarfFemale\\Emote\\DwarfFemale_Roar01.wav",
		[2] = "Sound\\Character\\Dwarf\\DwarfMale\\Emote\\DwarfMale_Roar02.wav",
	},

	["Gnome"] = {
		[1] = "Sound\\Character\\Gnome\\GnomeFemale\\Emote\\GnomeFemale_Roar01.wav",
		[2] = "Sound\\Character\\Gnome\\GnomeMale\\Emote\\GnomeMale_Roar01.wav",
	},

	["Goblin"] = {
		[1] = "Sound\\Character\\Goblin\\GoblinFemale\\Emote\\GoblinFemale_Roar01.ogg",
		[2] = "Sound\\Character\\Goblin\\GoblinMale\\Emote\\GoblinMale_Roar02.wav",
	},
		
	["High Elf"] = {
		[1] = "Sound\\Character\\HighElf\\HighElfFemale\\Emote\\HighElfFemale_Roar01.wav",
		[2] = "Sound\\Character\\HighElf\\HighElfMale\\Emote\\HighElfMale_Roar01.wav",		
	},

	["Human"] = {
		[1] = "Sound\\Character\\Human\\HumanFemale\\Emote\\HumanFemale_Roar01.wav",
		[2] = "Sound\\Character\\Human\\HumanMale\\Emote\\HumanMale_Roar02.wav",
	},
	
	["Night Elf"] = {
		[1] = "Sound\\Character\\NightElf\\NightElfFemale\\Emote\\NightElfFemale_Roar01.wav",
		[2] = "Sound\\Character\\NightElf\\NightElfMale\\Emote\\NightElfMale_Roar02.wav",
	},

	["Orc"] = {
		[1] = "Sound\\Character\\Orc\\OrcFemale\\Emote\\OrcFemale_Roar01.wav",
		[2] = "Sound\\Character\\Orc\\OrcMale\\Emote\\OrcMale_Roar01.wav",
	},

	["Tauren"] = {
		[1] = "Sound\\Character\\Tauren\\TaurenFemale\\Emote\\TaurenFemale_Roar01.wav",
		[2] = "Sound\\Character\\Tauren\\TaurenMale\\Emote\\TaurenMale_Roar01.wav",
	},

	["Troll"] = {
		[1] = "Sound\\Character\\Troll\\TrollFemale\\Emote\\TrollFemale_Roar01.wav",
		[2] = "Sound\\Character\\Troll\\TrollMale\\Emote\\TrollMale_Roar02.wav",
	},

	["Undead"] = {
		[1] = "Sound\\Character\\Undead\\UndeadFemale\\Emote\\UndeadFemale_Roar01.wav",
		[2] = "Sound\\Character\\Undead\\UndeadMale\\Emote\\UndeadMale_Roar02.wav",
	},
}

local progress = {
	["Dwarf"] = {		
		[1] = "\\Sound\\Character\\Dwarf\\DwarfVocalFemale\\DwarfFemaleCheer01.wav",
		[2] = "\\Sound\\Character\\Dwarf\\DwarfVocalFemale\\DwarfFemaleCheer02.wav",
		[3] = "\\Sound\\Character\\Dwarf\\DwarfVocalMale\\DwarfMaleCheer01.wav",
		[4] = "\\Sound\\Character\\Dwarf\\DwarfVocalMale\\DwarfMaleCheer02.wav",
	},

	["Gnome"] = {
		[1] = "\\Sound\\Character\\Gnome\\GnomeVocalFemale\\GnomeFemaleCheer01.wav",
		[2] = "\\Sound\\Character\\Gnome\\GnomeVocalFemale\\GnomeFemaleCheer02.wav",
		[3] = "\\Sound\\Character\\Gnome\\GnomeVocalMale\\GnomeMaleCheer01.wav",
		[4] = "\\Sound\\Character\\Gnome\\GnomeVocalMale\\GnomeMaleCheer02.wav",
	},

	["Goblin"] = {
		[1] = "Sound\\Character\\Goblin\\GoblinFemale\\Emote\\GoblinFemale_Cheer01.ogg",
		[2] = "Sound\\Character\\Goblin\\GoblinFemale\\Emote\\GoblinFemale_Cheer02.ogg",
		[3] = "Sound\\Character\\Goblin\\GoblinMale\\Emote\\GoblinMale_Cheer01.wav",
		[4] = "Sound\\Character\\Goblin\\GoblinMale\\Emote\\GoblinMale_Cheer02.wav",
	},
		
	["High Elf"] = {
		[1] = "Sound\\Character\\HighElf\\HighElfFemale\\Emote\\HighElfFemale_Cheer01.wav",
		[2] = "Sound\\Character\\HighElf\\HighElfFemale\\Emote\\HighElfFemale_Cheer03.wav",
		[3] = "Sound\\Character\\HighElf\\HighElfMale\\Emote\\HighElfMale_Cheer01.wav",
		[4] = "Sound\\Character\\HighElf\\HighElfMale\\Emote\\HighElfMale_Cheer02.wav",
	},

	["Human"] = {
		[1] = "Sound\\Character\\Human\\HumanVocalFemale\\HumanFemaleCheer01.wav",
		[2] = "Sound\\Character\\Human\\HumanVocalFemale\\HumanFemaleCheer02.wav",
		[3] = "Sound\\Character\\Human\\HumanVocalMale\\HumanMaleCheer01.wav",
		[4] = "Sound\\Character\\Human\\HumanVocalMale\\HumanMaleCheer02.wav",
	},
	
	["Night Elf"] = {
		[1] = "Sound\\Character\\NightElf\\NightElfVocalFemale\\NightElfFemaleCheer01.wav",
		[2] = "Sound\\Character\\NightElf\\NightElfVocalFemale\\NightElfFemaleCheer02.wav",
		[3] = "Sound\\Character\\NightElf\\NightElfVocalMale\\NightElfMaleCheer01.wav",
		[4] = "Sound\\Character\\NightElf\\NightElfVocalMale\\NightElfMaleCheer02.wav",
	},

	["Orc"] = {
		[1] = "Sound\\Character\\Orc\\OrcVocalFemale\\OrcFemaleCheer01.wav",
		[2] = "Sound\\Character\\Orc\\OrcVocalFemale\\OrcFemaleCheer02.wav",
		[3] = "Sound\\Character\\Orc\\OrcVocalMale\\OrcMaleCheer01.wav",
		[4] = "Sound\\Character\\Orc\\OrcVocalMale\\OrcMaleCheer02.wav",
	},

	["Tauren"] = {
		[1] = "Sound\\Character\\Tauren\\TaurenVocalFemale\\TaurenFemaleCheer01.wav",
		[2] = "Sound\\Character\\Tauren\\TaurenVocalFemale\\TaurenFemaleCheer02.wav",
		[3] = "Sound\\Character\\Tauren\\TaurenVocalMale\\TaurenMaleCheer01.wav",
		[4] = "Sound\\Character\\Tauren\\TaurenVocalMale\\TaurenMaleCheer02.wav",
	},

	["Troll"] = {
		[1] = "Sound\\Character\\Troll\\TrollVocalFemale\\TrollFemaleCheer01.wav",
		[2] = "Sound\\Character\\Troll\\TrollVocalFemale\\TrollFemaleCheer02.wav",
		[3] = "Sound\\Character\\Troll\\TrollVocalMale\\TrollMaleCheer01.wav",
		[4] = "Sound\\Character\\Troll\\TrollVocalMale\\TrollMaleCheer02.wav",
	},

	["Undead"] = {
		[1] = "Sound\\Character\\Scourge\\ScourgeVocalFemale\\UndeadFemaleCheer01.wav",
		[2] = "Sound\\Character\\Scourge\\ScourgeVocalFemale\\UndeadFemaleCheer02.wav",
		[3] = "Sound\\Character\\Scourge\\ScourgeVocalMale\\UndeadMaleCheer01.wav",
		[4] = "Sound\\Character\\Scourge\\ScourgeVocalMale\\UndeadMaleCheer02.wav",
	},
}

local HCDeath = CreateFrame("Frame", nil, UIParent)
HCDeaths = {}
HCDeaths_LastWords = {}

local media = "Interface\\Addons\\HCDeaths\\media\\"
local deaths = {}
local queried
local logged
local toastTime = 10 -- number of seconds the toast will display
local toastMove -- state of toast moving

local twidth, theight = 332.8, 166.4

do	
	-- toast
	HCDeathsToast = CreateFrame("Button", "HCDeathsToast", HCDeath)
	HCDeathsToast:SetWidth(twidth)
	HCDeathsToast:SetHeight(theight)
	HCDeathsToast:Hide()

	-- texture
	HCDeath.texture = HCDeathsToast:CreateTexture(nil,"LOW")
	HCDeath.texture:SetAllPoints(HCDeathsToast)
	HCDeath.texture:SetTexture(media.."Ring\\".."Ring")	
	-- HCDeath.texture:Hide()

	HCDeath.race = HCDeathsToast:CreateTexture(nil,"BACKGROUND")
	HCDeath.race:SetPoint("CENTER", HCDeath.texture, "CENTER", -43, -24)
	-- HCDeath.race:Hide()

	HCDeath.class = HCDeathsToast:CreateTexture(nil,"BACKGROUND")
	HCDeath.class:SetPoint("CENTER", HCDeath.texture, "CENTER", 0, 10)
	-- HCDeath.class:Hide()

	-- text
	local font, size, outline = "Fonts\\FRIZQT__.TTF", 16, "OUTLINE"
	
	HCDeath.level = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")
	HCDeath.level:SetPoint("TOP", HCDeath.texture, "CENTER", 42, -15)
	HCDeath.level:SetWidth(HCDeath.texture:GetWidth())
	-- HCDeath.level:Hide()
	HCDeath.level:SetFont(font, size, outline)

	HCDeath.name = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")
	HCDeath.name:SetPoint("TOP", HCDeath.texture, "CENTER", 0, -44)
	HCDeath.name:SetWidth(HCDeath.texture:GetWidth())
	-- HCDeath.name:Hide()
	HCDeath.name:SetFont(font, size, outline)

	outline = "THINOUTLINE"

	HCDeath.guild = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")
	HCDeath.guild:SetPoint("TOP", HCDeath.name, "BOTTOM", 0, -12)
	HCDeath.guild:SetWidth(HCDeath.texture:GetWidth())
	-- HCDeath.guild:Hide()
	HCDeath.guild:SetFont(font, size-1, outline)

	HCDeath.location = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")
	HCDeath.location:SetPoint("TOP", HCDeath.guild, "BOTTOM", 0, -10)
	HCDeath.location:SetWidth(HCDeath.texture:GetWidth()*1.5)
	-- HCDeath.location:Hide()
	HCDeath.location:SetFont(font, size, outline)

	HCDeath.death = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")
	HCDeath.death:SetPoint("TOP", HCDeath.location, "BOTTOM", 0, -5)
	HCDeath.death:SetWidth(HCDeath.texture:GetWidth()*1.5)
	-- HCDeath.death:Hide()
	HCDeath.death:SetFont(font, size, outline)

	HCDeath.lastwords = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")
	HCDeath.lastwords:SetPoint("TOP", HCDeath.death, "BOTTOM", 0, -10)
	HCDeath.lastwords:SetWidth(HCDeath.texture:GetWidth())
	-- HCDeath.lastwords:Hide()
	HCDeath.lastwords:SetFont(font, size, outline)
	HCDeath.lastwords:SetTextColor(.5,.5,.5)
	
	-- HCDeath.quote = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")
	-- HCDeath.quote:SetPoint("TOP", HCDeath.death, "BOTTOM", 0, -10)
	-- HCDeath.quote:SetWidth(HCDeath.texture:GetWidth()*1.5)
	-- HCDeath.quote:Hide()
	-- HCDeath.quote:SetFont("Fonts\\SKURRI.TTF", size, outline)

	HCDeathsToast:SetMovable(true)
	HCDeathsToast:SetClampedToScreen(true)
	HCDeathsToast:SetUserPlaced(true)
	HCDeathsToast:EnableMouse(true)
	HCDeathsToast:RegisterForClicks("RightButtonDown")
	HCDeathsToast:RegisterForDrag("LeftButton")
  
	function HCDeathsToast:position()
		HCDeathsToast:ClearAllPoints()
		HCDeathsToast:SetPoint("CENTER", UIErrorsFrame, "CENTER", 0, -20)
	end
  
	HCDeathsToast:position()
  
	HCDeathsToast:SetScript("OnDragStart", function()
	  if (IsShiftKeyDown() and IsControlKeyDown()) then
		HCDeathsToast:StartMoving()
	  end
	end)
  
	HCDeathsToast:SetScript("OnDragStop", function()
		HCDeathsToast:StopMovingOrSizing()
	end)
  
	HCDeathsToast:SetScript("OnClick", function()
	  if (IsShiftKeyDown() and IsControlKeyDown()) then
		HCDeathsToast:SetUserPlaced(false)
		HCDeathsToast:position()
	  end
	end)
end

local timer = CreateFrame("Frame", nil, HCDeath)
timer:Hide()
timer:SetScript("OnUpdate", function()
	if GetTime() >= this.time then
		this.time = nil
		HCDeath:hideToast()
		this:Hide()
		HCDeath:Toast()
	end
end)

function HCDeath:classSize()
	local s = 85
	HCDeath.class:SetWidth(s)
	HCDeath.class:SetHeight(s)
end

function HCDeath:raceSize()
	local s = 25
	HCDeath.race:SetWidth(s)
	HCDeath.race:SetHeight(s)
end

function HCDeath:showToast()
	HCDeath:classSize()
	HCDeath:raceSize()
	HCDeathsToast:Show()

	-- HCDeath.texture:Show()	
	-- HCDeath.class:Show()
	-- HCDeath.race:Show()

	-- HCDeath.name:Show()
	-- HCDeath.level:Show()
	-- HCDeath.guild:Show()	
	-- HCDeath.location:Show()
	-- HCDeath.death:Show()
	-- HCDeath.lastwords:Show()

	-- HCDeath.quote:Show()

	timer.time = GetTime() + toastTime
	timer:Show()
end

function HCDeath:hideToast()
	HCDeathsToast:Hide()

	-- HCDeath.texture:Hide()
	-- HCDeath.class:Hide()
	-- HCDeath.race:Hide()

	-- HCDeath.name:Hide()
	-- HCDeath.level:Hide()
	-- HCDeath.guild:Hide()	
	-- HCDeath.location:Hide()
	-- HCDeath.death:Hide()
	-- HCDeath.lastwords:Hide()
	
	-- HCDeath.quote:Hide()

	HCDeath.name:SetText("")
	HCDeath.level:SetText("")
	HCDeath.guild:SetText("")
	HCDeath.location:SetText("")
	HCDeath.death:SetText("")
	HCDeath.lastwords:SetText("")

	-- HCDeath.quote:SetText("")
end

function HCDeath:texColor(level)
	HCDeath.texture:SetVertexColor(.75,.75,.75)
	if HCDeaths_Settings.color then
		if level == 60 then
			-- gold
			-- #ffd700
			HCDeath.texture:SetVertexColor(255/255, 215/255, 0/255)
		elseif level >= 50 then
			-- #e0cc5f
			HCDeath.texture:SetVertexColor(224/255, 204/255, 95/255)
		elseif level >= 40 then
			-- silver
			HCDeath.texture:SetVertexColor(1,1,1)
		elseif level >= 30 then
			-- #b79d8c
			HCDeath.texture:SetVertexColor(183/255, 157/255, 140/255)
		elseif level >= 20 then
			-- #ad7a56
			HCDeath.texture:SetVertexColor(173/255, 122/255, 86/255)
		end
	end
end

function HCDeath:color(level)
	HCDeath:texColor(level)
	HCDeath.guild:SetTextColor(116/255, 113/255, 255/255) -- #7471FF
end

function HCDeath:sound(deathType, playerRace, playerLevel)
	if not (deathType == "LVL") then
		if HCDeaths_Settings.deathsound then
			if HCDeaths_Settings.roar then
				local num = math.random(1, 2)
				PlaySoundFile(deathsound[playerRace][num])
			else
				PlaySoundFile("Sound/interface/RaidWarning.wav")
			end
		end
	else
		-- deathType == "LVL"
		if HCDeaths_Settings.levelsound then
			if playerLevel == 60 then
				PlaySoundFile("Sound\\Doodad\\G_FireworkLauncher02Custom0.wav")
			end

			local num = math.random(1, 4)
			PlaySoundFile(progress[playerRace][num])
		end
	end
end

function HCDeath:Toast()
	if toastMove then return end
	if HCDeaths_Settings.toast then
		if not HCDeath.texture:IsVisible() then
			for _, hcdeath in pairs(deaths) do
				if hcdeath.info then
					HCDeath:RemoveDeath(hcdeath.playerName)

					if hcdeath.deathType == "LVL" then
						HCDeath:RemoveLevelDeath(hcdeath.playerName)
					end

					local level = tonumber(hcdeath.playerLevel)
					local class = RAID_CLASS_COLORS[strupper(hcdeath.playerClass)] or { r = 1, g = .5, b = 0 }
					local hex = HCDeath:rgbToHex(class.r, class.g, class.b)

					HCDeath.class:SetTexture(media.."Ring\\"..hcdeath.playerClass)
					HCDeath.race:SetTexture(media.."Ring\\"..hcdeath.playerRace)

					HCDeath.level:SetText(hcdeath.playerLevel)
					HCDeath.name:SetText("|cff"..hex..hcdeath.playerName)

					local lastwords = HCDeaths_LastWords[hcdeath.playerName]
					if lastwords then
						HCDeath.lastwords:SetText('"'..lastwords..'"')
					end

					if hcdeath.playerGuild ~= "nil" then
						HCDeath.guild:SetText("<"..hcdeath.playerGuild..">")
					else
						HCDeath.guild:SetText("")
					end

					if hcdeath.deathType == "LVL" then
						HCDeath.death:SetText("")				
						if level == 60 then
							HCDeath.location:SetText("Has transcended death and reached level 60!")
							-- HCDeath.quote:SetText("They shall henceforth be known as the Immortal")
						else
							HCDeath.location:SetText("Has reached level "..level.."!")
							-- HCDeath.quote:SetText("Their ascendance towards immortality continues")
						end
					else				
						HCDeath.location:SetText("Has died in "..hcdeath.zone)
						if hcdeath.deathType == "PVE" then
							if hcdeath.killerLevel then
								HCDeath.death:SetText("to "..hcdeath.killerName.." level "..hcdeath.killerLevel)
							else
								HCDeath.death:SetText("to "..hcdeath.killerName)
							end
						elseif hcdeath.deathType == "PVP" then
							local class = RAID_CLASS_COLORS[strupper(hcdeath.killerClass)] or { r = 1, g = .5, b = 0 }
							local hex = HCDeath:rgbToHex(class.r, class.g, class.b)
							HCDeath.death:SetText("to |cff"..hex..hcdeath.killerName.."|r level "..hcdeath.killerLevel)
						end
						-- HCDeath.quote:SetText("May this sacrifice not be forgotten!")
					end				
					
					HCDeath:sound(hcdeath.deathType, hcdeath.playerRace, level)					
					HCDeath:color(level)
					HCDeath:showToast()
					if hcdeath.deathType ~= "LVL" then
						HCDeath:updateLog(true)
					end
					break
				end
			end			
		end
	end	
end

function HCDeath:tableLength()
	local count = 0
	for _ in pairs(HCDeaths) do
		count = count + 1
	end
	return count	
end

function HCDeath:rgbToHex(r, g, b)
    return string.format("%02X%02X%02X", r * 255, g * 255, b * 255)
end

function HCDeath:RemoveDeath(name)
	for i, hcdeath in ipairs(deaths) do
		if hcdeath.playerName == name then
			table.remove(deaths, i)
		end
	end
end

function HCDeath:RemoveLevelDeath(name)
	for i, hcdeath in ipairs(HCDeaths) do
		if hcdeath.playerName == name then
			table.remove(HCDeaths, i)
		end
	end
end

function HCDeath:GetWhoInfo(player)
    local numWhos = GetNumWhoResults()
	for i=0, numWhos do
        local name, guild, level, race, class, zone = GetWhoInfo(i)
		if (name == player) then
			if guild == "" then
				return "nil", level, race, class, zone
			else
				return guild, level, race, class, zone
			end
		end
	end
end

function HCDeath:QueryPlayer()
	for _, hcdeath in pairs(deaths) do
		if not hcdeath.playerClass then
			hcdeath.playerGuild, hcdeath.playerLevel, hcdeath.playerRace, hcdeath.playerClass, hcdeath.zone = HCDeath:GetWhoInfo(hcdeath.playerName)
			if (hcdeath.deathType == "PVE" or hcdeath.deathType == "LVL") and hcdeath.playerClass then
				hcdeath.info = true
			elseif (hcdeath.deathType == "PVP") and (not hcdeath.killerClass) then
				HCDeath:whoPlayer(hcdeath.killerName, _, hcdeath.zone)
				return
			end
		end

		if (not hcdeath.killerClass) and hcdeath.deathType == "PVP" then
			hcdeath.killerGuild, hcdeath.killerLevel, hcdeath.killerRace, hcdeath.killerClass = HCDeath:GetWhoInfo(hcdeath.killerName)
			if hcdeath.killerClass then
				hcdeath.info = true
			end
		end

		if hcdeath.info then
			logged = true
			local match
			for _, death in pairs(HCDeaths) do
				if death.playerName == hcdeath.playerName then
					match = true
					break
				end
			end

			if not match then
				table.insert(HCDeaths, {
					sdate = hcdeath.sdate,
					stime = hcdeath.stime,
					deathType = hcdeath.deathType,
					zone = hcdeath.zone,
					lastWords = tostring(HCDeaths_LastWords[hcdeath.playerName]),
					playerName = hcdeath.playerName,
					playerLevel = hcdeath.playerLevel,
					playerClass = hcdeath.playerClass,
					playerRace = hcdeath.playerRace,
					playerGuild = tostring(hcdeath.playerGuild),
					killerName = tostring(hcdeath.killerName),
					killerLevel = tostring(hcdeath.killerLevel),
					killerClass = tostring(hcdeath.killerClass),
					killerRace = tostring(hcdeath.killerRace),
					killerGuild = tostring(hcdeath.killerGuild)
				})

				-- if hcdeath.deathType ~= "LVL" then
				-- 	HCDeath:print(hcdeath.deathType.." Death Logged")
				-- else
				-- 	HCDeath:print("Progress Logged")
				-- end
			end
		end
	end
end

function HCDeath:SendWho()
	if not queried then
		for _, hcdeath in pairs(deaths) do
			if not hcdeath.info then
				HCDeath:whoPlayer(hcdeath.playerName, hcdeath.playerLevel)				
				break
			end
		end
	end
end

function HCDeath:whoPlayer(player, level, zone)
	local filter
    
	if player and level then
		filter = "n-"..player.." "..level
	elseif player and zone then
		filter = "n-"..player.." ".."z-"..zone
	end

	if filter then
		SendWho(filter)
		queried = true
	end
end

function HCDeath:systemMessage(message)
	if HCDeaths_Settings.message then
		local info = ChatTypeInfo["SYSTEM"]
		DEFAULT_CHAT_FRAME:AddMessage(message, info.r, info.g, info.b, info.id)
	end
end

function HCDeath:extractLinks(str)
	local start = 1
    local result = ""
    while true do
        local s, e, link = string.find(str, "|c.-|H.-|h%[(.-)%]|h|r", start)
        if not s then break end
        result = result .. string.sub(str, start, s - 1) .. "[" .. link .. "]"
        start = e + 1
    end
    result = result .. string.sub(str, start)
    return result
end	

local HookChatFrame_OnEvent = ChatFrame_OnEvent
function ChatFrame_OnEvent(event)	
	if (event == "CHAT_MSG_SYSTEM") then

		-- Examples of Turtle WoW HC progress messages:
		-- "PLAYERNAME has reached level 20/30/40/50 in Hardcore mode! Their ascendance towards immortality continues, however, so do the dangers they will face.
		-- "PLAYERNAME has transcended death and reached level 60 on Hardcore mode without dying once! PLAYERNAME shall henceforth be known as the Immortal!"

		-- Examples of Turtle WoW HC death messages:
		-- PvP = "A tragedy has occurred. Hardcore character PLAYERNAME has fallen in PvP to KILLERNAME at level PLAYERLEVEL. May this sacrifice not be forgotten."
		-- PVE = "A tragedy has occurred. Hardcore character PLAYERNAME has fallen to MOBNAME1 MOBNAME2 (level KILLERLEVEL) at level PLAYERLEVEL. May this sacrifice not be forgotten."
		-- PVE = "A tragedy has occurred. Hardcore character PLAYERNAME died of natural causes at level PLAYERLEVEL. May this sacrifice not be forgotten."

		-- Example of /who result messages:
		-- [PLAYERNAME]: Level PLAYERLEVEL PLAYERRACE PLAYERCLASS <PLAYERGUILD> - AREA
		-- 1 player Total

		local _, _, hcprogress = string.find(arg1, "(%a+) has reached level (%d%d) in Hardcore mode")
		local _, _, hcimmortal = string.find(arg1, "(%a+) has transcended death and reached level 60")
		local _, _, hcdeath = string.find(arg1,"A tragedy has occurred. Hardcore character (%a+)")

		if hcprogress or hcimmortal then
			HCDeath:systemMessage(arg1)
			
			local _, _, playerName = string.find(arg1,"(%a+) has")
			local _, _, playerLevel = string.find(arg1,"reached level (%d+)")

			table.insert(deaths, {
				sdate = date("!%Y/%m/%d"),
				stime = date("!%H:%M:%S"),
				deathType = "LVL",
				zone = nil,
				playerName = playerName,
				playerLevel = playerLevel,
				playerClass = nil,
				playerRace = nil,
				playerGuild = nil,
				info = nil
			})

			HCDeath:SendWho()
			return
		elseif hcdeath then
			HCDeath:systemMessage(arg1)

			local pvp, natural, playerLevel, deathType, killerName, killerLevel, killerClass
			_, _, pvp = string.find(arg1,"(PvP)")
			_, _, natural = string.find(arg1,"(natural causes)")
			_, _, playerLevel = string.find(arg1,"at level (%d+)")

			if pvp then 
				deathType = "PVP"
				_, _, killerName = string.find(arg1,"to%s+(%a+)")
			else
				deathType = "PVE"
				if natural then
					killerName = "Natural Causes"
					killerClass = "ENV"
				else
					_, _, killerName = string.find(arg1,"to%s+(.-)%s*%(")
					_, _, killerLevel = string.find(arg1,"%(level%s*(.-)%).-at")
					killerClass = "NPC"
				end
			end

			table.insert(deaths, {
				sdate = date("!%Y/%m/%d"),
				stime = date("!%H:%M:%S"),
				deathType = deathType,
				zone = nil,
				playerName = hcdeath,
				playerLevel = playerLevel,
				playerClass = nil,
				playerRace = nil,
				playerGuild = nil,
				killerName = killerName,
				killerLevel = killerLevel,
				killerClass = killerClass,
				killerRace = nil,
				killerGuild = nil,
				lastWords = nil,
				info = nil
			})

			HCDeath:SendWho()
			return
		end
		
		if queried then
			local result
			_, _, result = string.find(arg1,"(%d+) player.- total")
			if not result then
				_, _, result = string.find(arg1, "%[(.-)%]")
				for _, hcdeath in pairs(deaths) do
					if result == hcdeath.playerName then
						break
					end				
				end
			end

			if result then
				if not logged then
					HCDeath:QueryPlayer()
					return
				else
					logged = nil
					queried = nil
					HCDeath:Toast()
					return
				end
			end
		end
	elseif (event == "CHAT_MSG_SAY" or event == "CHAT_MSG_YELL" or event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER") then
		HCDeaths_LastWords[arg2] = HCDeath:extractLinks(arg1)
	end

	HookChatFrame_OnEvent(event)
end

function HCDeath:reset()
	HCDeaths_Settings.message = true
	HCDeaths_Settings.log = true
	HCDeaths_Settings.toast = true
	HCDeaths_Settings.color = false
	HCDeaths_Settings.deathsound = true
	HCDeaths_Settings.levelsound = true
	HCDeaths_Settings.roar = false
	HCDeaths_Settings.toastscale = 1
	HCDeaths_Settings.logscale = 1

	HCDeath:ToastScale()
	HCDeathsToast:SetUserPlaced(false)
	HCDeathsToast:position()

	HCDeath:ToggleLog()
	HCDeathsLog:SetUserPlaced(false)
	HCDeathsLog:position()
end

function HCDeath:print(message)
	DEFAULT_CHAT_FRAME:AddMessage("HCDeaths: "..message, 1, .5, 0)
end

local function HCDeaths_commands(msg, editbox)
	local function fontnum(msg)
		local startPos = string.find(msg, "%d")
		local numstr = string.sub(msg, startPos)
		if tonumber(numstr) then
			return tonumber(numstr)
		else
			HCDeath:print("input was not a number, please try again")
		end
	end

    local function message(setting, name)
        local state = "off"
        if setting then state = "on" end
		HCDeath:print(name.." is "..state)
    end

	local num = nil
	if string.find(msg, "toast scale %d") then
		num = fontnum(msg)
		HCDeaths_Settings.toastscale = num
		HCDeath:ToastScale()
		HCDeath:print("toast scale set to "..HCDeaths_Settings.toastscale)
	elseif string.find(msg, "log scale %d") then
		num = fontnum(msg)
		HCDeaths_Settings.logscale = num
		HCDeath:LogScale()
		HCDeath:print("log scale set to "..HCDeaths_Settings.logscale)
	elseif msg == "message" then
		if HCDeaths_Settings.message then
			HCDeaths_Settings.message = false
		else
			HCDeaths_Settings.message = true
		end
		message(HCDeaths_Settings.message, "message")
	elseif msg == "log" then
		if HCDeaths_Settings.log then
			HCDeaths_Settings.log = false
		else
			HCDeaths_Settings.log = true
		end
		message(HCDeaths_Settings.log, "log")
		HCDeath:ToggleLog()
	elseif msg == "toast" then
		if HCDeaths_Settings.toast then
			HCDeaths_Settings.toast = false
		else
			HCDeaths_Settings.toast = true
		end
		message(HCDeaths_Settings.toast, "toast")
	elseif msg == "color" then
		if HCDeaths_Settings.color then
			HCDeaths_Settings.color = false
		else
			HCDeaths_Settings.color = true
		end
		message(HCDeaths_Settings.color, "color")
	elseif msg == "deathsound" then
		if HCDeaths_Settings.deathsound then
			HCDeaths_Settings.deathsound = false
		else
			HCDeaths_Settings.deathsound = true
		end
		message(HCDeaths_Settings.deathsound, "deathsound")
	elseif msg == "levelsound" then
		if HCDeaths_Settings.levelsound then
			HCDeaths_Settings.levelsound = false
		else
			HCDeaths_Settings.levelsound = true
		end
		message(HCDeaths_Settings.levelsound, "levelsound")
	elseif msg == "roar" then
		if HCDeaths_Settings.roar then
			HCDeaths_Settings.roar = false
		else
			HCDeaths_Settings.roar = true
		end
		message(HCDeaths_Settings.roar, "roar")
	elseif msg == "move" then
		if toastMove then
			toastMove = nil
			HCDeath:print("hiding toast")
			HCDeath:hideToast()
		else
			toastMove = true
			HCDeath:print("showing toast")
			HCDeath:toastMove()
		end
    elseif msg == "reset" then
        HCDeath:reset()
		HCDeath:print("settings reset")
    else
		HCDeath:print("commands:")
		HCDeath:print("/hcd message - toggle system death messages")
		HCDeath:print("/hcd move - toggles the toast so you can move it")
		HCDeath:print("/hcd log - toggle death log")		
		HCDeath:print("/hcd log scale - sets the death log scale")
		HCDeath:print("/hcd toast - toggle toast popups")
		HCDeath:print("/hcd toast scale - sets the toast popup scale")
		HCDeath:print("/hcd color - toggle toast ring colors")
		HCDeath:print("/hcd deathsound - toggle toast deathsounds")
		HCDeath:print("/hcd levelsound - toggle toast levelsounds")
		HCDeath:print("/hcd roar - death roars instead of raid alert")
		HCDeath:print("/hcd reset - reset settings")
    end
end

do  
	local max_width = 210
	local max_height = 56
  
	local HCDeathsLog = CreateFrame("Button", "HCDeathsLog", UIParent)
	HCDeathsLog:Hide()

	HCDeathsLog:SetWidth(max_width)
	HCDeathsLog:SetHeight(max_height)
  
	HCDeathsLog:SetBackdrop({
	  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	--   edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	  tile = true, tileSize = 16, edgeSize = 18,
	  insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	HCDeathsLog:SetBackdropColor(0,0,0)
	HCDeathsLog:SetBackdropBorderColor(.5,.5,.5,1)

	HCDeathsLog.icon = HCDeathsLog:CreateTexture(nil,"LOW")
	HCDeathsLog.icon:SetPoint("CENTER", HCDeathsLog, "TOPLEFT", 14, -6)
	HCDeathsLog.icon:SetTexture(media.."Log\\".."Skull")
	HCDeathsLog.icon:SetWidth(38)
	HCDeathsLog.icon:SetHeight(38)
  
	local yoffset = -20
  
	HCDeathsLog.title = HCDeathsLog:CreateFontString(nil, "LOW", "GameFontNormal")
	HCDeathsLog.title:SetPoint("TOPLEFT", HCDeathsLog, "TOPLEFT", 30, -6)
	HCDeathsLog.title:SetText("Hardcore Deaths")
	HCDeathsLog.title:SetTextColor(1, .5, 0, 1)
  
	HCDeathsLog.scrollframe = CreateFrame("ScrollFrame", "HCDeathsLogScrollframe", HCDeathsLog, "UIPanelScrollFrameTemplate")
	HCDeathsLog.scrollframe:SetHeight(max_height + 20)
	HCDeathsLog.scrollframe:SetWidth(max_width - 40)
	HCDeathsLog.scrollframe:SetPoint('CENTER', HCDeathsLog, -10, -8)
	HCDeathsLog.scrollframe:Hide()
  
	HCDeathsLog.container = CreateFrame("Frame", "HCDeathsLogContainer", HCDeathsLog)
	HCDeathsLog.container:SetHeight(max_height - 5)
	HCDeathsLog.container:SetWidth(max_width - 40)
	HCDeathsLog.container:SetPoint("CENTER", HCDeathsLog, 10, 0)
  
	HCDeathsLog:SetMovable(true)
	HCDeathsLog:SetClampedToScreen(true)
	HCDeathsLog:SetUserPlaced(true)
	HCDeathsLog:EnableMouse(true)
	HCDeathsLog:RegisterForClicks("RightButtonDown")
	HCDeathsLog:RegisterForDrag("LeftButton")
  
	function HCDeathsLog:position()
	  HCDeathsLog:ClearAllPoints()
	  HCDeathsLog:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 45)
	end
  
	HCDeathsLog:position()
  
	HCDeathsLog:SetScript("OnDragStart", function()
	  if (IsShiftKeyDown() and IsControlKeyDown()) then
		HCDeathsLog:StartMoving()
	  end
	end)
  
	HCDeathsLog:SetScript("OnDragStop", function()
	  HCDeathsLog:StopMovingOrSizing()
	end)
  
	HCDeathsLog:SetScript("OnClick", function()
	  if (IsShiftKeyDown() and IsControlKeyDown()) then
		HCDeathsLog:SetUserPlaced(false)
		HCDeathsLog:position()
	  end
	end)

	HCDeathsLog.limit = 50
	HCDeathsLog.type = {}
	HCDeathsLog.level = {}
	HCDeathsLog.name = {}	
	HCDeathsLog.race = {}
	HCDeathsLog.class = {}
	-- HCDeathsLog.guild = {}
	HCDeathsLog.background = {}

	for i=1, HCDeathsLog.limit do
		local tex = 15
		tinsert(HCDeathsLog.type, HCDeathsLog.container:CreateTexture(nil,"LOW"))	
		HCDeathsLog.type[i]:SetWidth(tex)
		HCDeathsLog.type[i]:SetHeight(tex)
		HCDeathsLog.type[i]:Hide()

		tinsert(HCDeathsLog.level, HCDeathsLog.container:CreateFontString(nil, "LOW", "GameFontNormal"))
		HCDeathsLog.level[i]:SetJustifyH("LEFT")

		tinsert(HCDeathsLog.name, HCDeathsLog.container:CreateFontString(nil, "LOW", "GameFontNormal"))
		HCDeathsLog.name[i]:SetJustifyH("LEFT")
		
		tinsert(HCDeathsLog.race, HCDeathsLog.container:CreateTexture(nil,"LOW"))	
		HCDeathsLog.race[i]:SetWidth(tex)
		HCDeathsLog.race[i]:SetHeight(tex)
		HCDeathsLog.race[i]:Hide()

		tinsert(HCDeathsLog.class, HCDeathsLog.container:CreateTexture(nil,"LOW"))
		HCDeathsLog.class[i]:SetWidth(tex)
		HCDeathsLog.class[i]:SetHeight(tex)
		HCDeathsLog.class[i]:Hide()

		-- tinsert(HCDeathsLog.guild, HCDeathsLog.container:CreateFontString(nil, "LOW", "GameFontNormal"))
		-- HCDeathsLog.guild[i]:SetJustifyH("LEFT")
		-- HCDeathsLog.guild[i]:SetTextColor(116/255, 113/255, 255/255)

		tinsert(HCDeathsLog.background, CreateFrame("Frame",nil,HCDeathsLog.container))		
		HCDeathsLog.background[i]:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
		HCDeathsLog.background[i]:Hide()

		HCDeathsLog.background[i]:EnableMouse(true)	
		
		HCDeathsLog.background[i]:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end
end

function HCDeath:ToggleLog()
	if HCDeaths_Settings.log then
		HCDeath:LogScale()	
		HCDeathsLog:Show()
		HCDeath:updateLog()
	else
		HCDeathsLog:Hide()
	end
end

function HCDeath:updateLog()
	if not HCDeathsLog:IsShown() then return end
	local max_width = HCDeathsLog:GetWidth()
	local max_height = HCDeathsLog:GetHeight()
	local xoff = 10
	local yoff = 0

	HCDeathsLog:SetHeight(75 + 30)

	local max = HCDeath:tableLength()
	local min = max - HCDeathsLog.limit
	local limit = HCDeathsLog.limit

	for i = max, min, -1 do
		local hcdeath = HCDeaths[i]
		if not hcdeath then return end
		if not HCDeathsLog.type[limit] then return end

		if hcdeath.deathType ~= "LVL" then
			local dtype = HCDeathsLog.type[limit]		
			local level = HCDeathsLog.level[limit]
			local name = HCDeathsLog.name[limit]		
			local race = HCDeathsLog.race[limit]
			local class = HCDeathsLog.class[limit]
			-- local guild = HCDeathsLog.guild[limit]
			local background = HCDeathsLog.background[limit]
			limit = limit - 1

			dtype:SetPoint("TOPLEFT", HCDeathsLog.container, "TOPLEFT", 0, -yoff)
			level:SetPoint("TOPLEFT", HCDeathsLog.container, "TOPLEFT", 18, -yoff-2)
			name:SetPoint("TOPLEFT", HCDeathsLog.container, "TOPLEFT", 40, -yoff-2)
			race:SetPoint("TOPLEFT", HCDeathsLog.container, "TOPLEFT", 135, -yoff)
			class:SetPoint("TOPLEFT", HCDeathsLog.container, "TOPLEFT", 155, -yoff)		
			-- guild:SetPoint("TOPLEFT", HCDeathsLog.container, "TOPLEFT", 180, -yoff)
			
			-- type
			dtype:SetTexture(media.."Log\\"..hcdeath.deathType)
			dtype:Show()

			-- level
			level:SetText(hcdeath.playerLevel)

			-- name
			local pclass = RAID_CLASS_COLORS[strupper(hcdeath.playerClass)] or { r = .5, g = .5, b = .5 }
			local classhex = HCDeath:rgbToHex(pclass.r, pclass.g, pclass.b)
			name:SetText("|cff"..classhex..hcdeath.playerName)

			-- race
			race:SetTexture(media.."Log\\"..hcdeath.playerRace)
			race:Show()

			-- class
			class:SetTexture(media.."Log\\"..hcdeath.playerClass)
			class:Show()

			-- guild
			-- if hcdeath.playerGuild ~= "nil" then
			-- 	guild:SetText("<"..hcdeath.playerGuild..">")
			-- else
			-- 	guild:SetText("")
			-- end

			-- background
			background:SetPoint("TOPLEFT", dtype, "TOPLEFT")
			background:SetPoint("BOTTOMRIGHT", class, "BOTTOMRIGHT")
			if mod(i, 2) == 1 then
				background:SetBackdropColor(1,1,1,.1)
			else
				background:SetBackdropColor(.5,.5,.5,.1)
			end
			background:Show()

			background:SetScript("OnEnter", function()			
				local death = {}
				if hcdeath.deathType == "PVP" then
					death.type = "PvP Death"
					death.r = 1
					death.g = 0
					death.b = 0
				else
					death.type = "PvE Death"
					death.r = 1
					death.g = .5
					death.b = 0
				end

				local guildhex = HCDeath:rgbToHex(116/255, 113/255, 255/255)
				-- player			
				local pname = "|cff"..classhex..hcdeath.playerName.."|r"
				local pclass = "|cff"..classhex..hcdeath.playerClass.."|r"
				local pguild = ""
				if hcdeath.playerGuild ~= "nil" then
					pguild = " |cff"..guildhex.."<"..hcdeath.playerGuild..">|r"
				end

				-- killer
				local kclass = RAID_CLASS_COLORS[strupper(hcdeath.killerClass)] or { r = 1, g = .5, b = 0 }
				local classhex = HCDeath:rgbToHex(kclass.r, kclass.g, kclass.b)				
				local kname = "|cff"..classhex..hcdeath.killerName.."|r"
				kclass = "|cff"..classhex..hcdeath.killerClass.."|r"
				local kguild = ""
				if hcdeath.killerGuild ~= "nil" then
					kguild = " |cff"..guildhex.."<"..hcdeath.killerGuild..">|r"
				end
				
				local killer
				if hcdeath.deathType == "PVP" then
					killer = kname..kguild.." the level "..hcdeath.killerLevel.." "..hcdeath.killerRace.." "..kclass
				else
					if hcdeath.killerLevel ~= "nil" then
						killer = kname.." level "..hcdeath.killerLevel
					else
						killer = kname
					end
				end

				local lastwords = HCDeaths_LastWords[hcdeath.playerName] or "nil"
				if lastwords ~= "nil" then
					lastwords = 'Their last words were |cff808080"'..lastwords..'"|r.'
				else
					lastwords = ""
				end

				-- tooltip
				if not GameTooltip:IsShown() then 
					GameTooltip:SetOwner(this, ANCHOR_BOTTOMLEFT)
				end
				GameTooltip:ClearLines()
				GameTooltip:AddLine(death.type, death.r, death.g, death.b)
				GameTooltip:AddLine(pname..pguild.." the level "..hcdeath.playerLevel.." "..hcdeath.playerRace.." "..pclass.." died in "..hcdeath.zone.." to "..killer..". "..lastwords,_,_,_,true)
				-- GameTooltip:AddLine("Date: "..hcdeath.sdate.." Time: "..hcdeath.stime)
				GameTooltip:Show()
			end)
			
			yoff = yoff + 15 -- spacing between items
			HCDeathsLog.container:SetHeight(75)			
		
			if not HCDeathsLog.scrollframe:IsShown() then
				HCDeathsLog.container:SetParent(HCDeathsLog.scrollframe)
				HCDeathsLog.container:SetHeight(HCDeathsLog.scrollframe:GetHeight())
				HCDeathsLog.container:SetWidth(HCDeathsLog.scrollframe:GetWidth() + 20)
		
				HCDeathsLog.scrollframe:SetScrollChild(HCDeathsLog.container)
				HCDeathsLog.scrollframe:Show()
			end
		end
	end
end

function HCDeath:ToastScale()
	HCDeathsToast:SetScale(HCDeaths_Settings.toastscale)
end

function HCDeath:LogScale()
	HCDeathsLog:SetScale(HCDeaths_Settings.logscale)
end

HCDeath:RegisterEvent("ADDON_LOADED")
HCDeath:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" then
        if not this.loaded then
            this.loaded = true
            SLASH_HCDEATHS1 = "/hcdeaths"
            SLASH_HCDEATHS2 = "/hcd"
            SlashCmdList["HCDEATHS"] = HCDeaths_commands
			HCDeath:ToastScale()
			HCDeath:ToggleLog()			
			HCDeath:print("HCDeaths Loaded! /hcdeaths or /hcd")
		end
	end
end)

function HCDeath:toastMove()
	HCDeath.level:SetText("60")
	HCDeath.name:SetText("Toast")
	HCDeath.guild:SetText("<HCDeaths>")
	HCDeath.location:SetText("Has died in Blackrock Mountains")
	HCDeath.death:SetText("to Torta level 60")
	HCDeath.lastwords:SetText('"'.."I like turtles!"..'"')
	-- HCDeath.quote:SetText("May this sacrifice not be forgotten!")
	
	HCDeath:color(60)
	HCDeath.texture:SetVertexColor(.75,.75,.75)	
	HCDeath.class:SetTexture(media.."Ring\\".."Warrior")
	HCDeath.race:SetTexture(media.."Ring\\".."Human")
	HCDeath:classSize()
	HCDeath:raceSize()
	HCDeathsToast:Show()
end