-- This addon will save Turtle WoW hardcore deaths to "\WTF\Account\ACCOUNTNAME\SavedVariables\HCDeaths.lua" in the following format:
-- date,time,deathType,zone,playerName,playerLevel,playerClass,playerRace,playerGuild,killerName,killerLevel,killerClass,killerRace,killerGuild

HCDeaths_Settings = {
    log = true
}

local HCDeath = CreateFrame("Frame", nil, UIParent)
HCDeaths = {}
local deaths = {}
local logged

function HCDeath:tableLength()
	local count = 0
	for _ in pairs(HCDeaths) do
		count = count + 1
	end
	return count	
end

function HCDeath:RemoveDeath()
	for i, hcdeath in ipairs(deaths) do
		if hcdeath.info then
			table.remove(deaths, i)
		end
	end
end

function HCDeath:GetWhoInfo(player)
    local numWhos = GetNumWhoResults()
	for i=0, numWhos do
        local name, guild, level, race, class, zone = GetWhoInfo(i)
		if (name == player) then
			return guild, level, race, class, zone
		end
	end
end

function HCDeath:QueryPlayer()
	for _, hcdeath in pairs(deaths) do
		if not hcdeath.playerGuild then
			hcdeath.playerGuild, hcdeath.playerLevel, hcdeath.playerRace, hcdeath.playerClass, hcdeath.zone = HCDeath:GetWhoInfo(hcdeath.playerName)
			if hcdeath.deathType == "PVE" and hcdeath.playerGuild then
				hcdeath.info = true
			else
				SendWho(hcdeath.killerName)
				return
			end
		end

		if (not hcdeath.killerGuild) and hcdeath.deathType == "PVP" then
			hcdeath.killerGuild, hcdeath.killerLevel, hcdeath.killerRace, hcdeath.killerClass = HCDeath:GetWhoInfo(hcdeath.killerName)
			if hcdeath.killerGuild then
				hcdeath.info = true
			end
		end

		if hcdeath.info then
			logged = true
			if HCDeaths_Settings.log then
				table.insert(HCDeaths, hcdeath.sdate..","..hcdeath.stime..","..hcdeath.deathType..","..hcdeath.zone..","..hcdeath.playerName..","..hcdeath.playerLevel..","..hcdeath.playerClass..","..hcdeath.playerRace..","..tostring(hcdeath.playerGuild)..","..hcdeath.killerName..","..tostring(hcdeath.killerLevel)..","..hcdeath.killerClass..","..tostring(hcdeath.killerRace)..","..tostring(hcdeath.killerGuild))
				DEFAULT_CHAT_FRAME:AddMessage("Hardcore "..hcdeath.deathType.." Death Logged ("..HCDeath:tableLength().." Deaths)", 1, 0.5, 0)
			end
			HCDeath:RemoveDeath()			
		end
	end
end

local HookChatFrame_OnEvent = ChatFrame_OnEvent
function ChatFrame_OnEvent(event)	
	if (event == "CHAT_MSG_SYSTEM") then
		-- Examples of Turtle WoW HC death messages:
		-- PvP = "A tragedy has occurred. Hardcore character PLAYERNAME has fallen in PvP to KILLERNAME at level PLAYERLEVEL. May this sacrifice not be forgotten."
		-- PVE = "A tragedy has occurred. Hardcore character PLAYERNAME has fallen to MOBNAME1 MOBNAME2 (level KILLERLEVEL) at level PLAYERLEVEL. May this sacrifice not be forgotten."
		-- PVE = "A tragedy has occurred. Hardcore character PLAYERNAME died of natural causes at level PLAYERLEVEL. May this sacrifice not be forgotten."

		-- Example of /who result messages:
		-- 1 player total
		-- 3 players total

		local _, _, hcdeath = string.find(arg1,"A tragedy has occurred. Hardcore character (%a+)")
		local _, _, result = string.find(arg1,"(player%s?total)")

		if hcdeath then
			-- table.insert(HCDeaths, date("!%y%m%d%H%M")..","..arg1) -- log default message
			local info = ChatTypeInfo["SYSTEM"]
			DEFAULT_CHAT_FRAME:AddMessage(arg1, info.r, info.g, info.b, info.id)			

			local pvp, natural, deathType, killerName, killerLevel, killerClass
			_, _, pvp = string.find(arg1,"(PvP)")
			_, _, natural = string.find(arg1,"(natural causes)")			

			if pvp then 
				deathType = "PVP"
				_, _, killerName = string.find(arg1,"to%s+(%a+)%s+at")
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
				playerLevel = nil,
				playerClass = nil,
				playerRace = nil,
				playerGuild = nil,
				killerName = killerName,
				killerLevel = killerLevel,
				killerClass = killerClass,
				killerRace = nil,
				killerGuild = nil,
				info = nil
			})

			SendWho(hcdeath)
			return
		elseif result and (not logged) then
			HCDeath:QueryPlayer()
			return
		elseif (not logged) then
			return
		elseif logged then
			logged = nil			
		end
	end

	HookChatFrame_OnEvent(event)
end

function HCDeath:reset()
	HCDeaths_Settings.log = true
end

local function HCWarn_commands(msg, editbox)
    local function message(setting, name)
        local state = "off"
        if setting then state = "on" end
        DEFAULT_CHAT_FRAME:AddMessage("HCDeaths: "..name.." is "..state..".", 1, 0.5, 0)
    end
	if msg == "log" then
        if HCDeaths_Settings.log then
            HCDeaths_Settings.log = false
        else
            HCDeaths_Settings.log = true
        end
        message(HCDeaths_Settings.log, "Logging")
    elseif msg == "reset" then
        HCDeath:reset()
        DEFAULT_CHAT_FRAME:AddMessage("HCDeaths: Settings reset.", 1, 0.5, 0)
    else
        DEFAULT_CHAT_FRAME:AddMessage("HCDeaths usage:", 1, 0.5, 0)
        DEFAULT_CHAT_FRAME:AddMessage("/hcdeath log - toggle logging deaths", 1, 0.5, 0)        
        DEFAULT_CHAT_FRAME:AddMessage("/hcdeath reset - reset settings", 1, 0.5, 0)  
    end
end

HCDeath:RegisterEvent("ADDON_LOADED")
HCDeath:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" then
        if not this.loaded then
            this.loaded = true
            SLASH_HCWARN1 = "/hcdeaths"
            SLASH_HCWARN2 = "/hcd"
            SlashCmdList["HCWARN"] = HCWarn_commands
            DEFAULT_CHAT_FRAME:AddMessage("HCDeaths Loaded! /hcdeaths or /hcd", 1, 0.5, 0)
        end
	end
end)

-- add the hc toast