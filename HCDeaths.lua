-- This addon will save Turtle WoW hardcore deaths to "\WTF\Account\ACCOUNTNAME\SavedVariables\HCDeaths.lua" in the following format:
-- date,time,deathType,zone,playerName,playerLevel,playerClass,killerName,killerLevel,killerClass

-- Credit
-- Code from HardcoreDeath (https://github.com/Lexiebean/HardcoreDeath/) by Lexiebean

local HCDeath = CreateFrame("Frame", nil, UIParent)
HCDeath:RegisterEvent("CHAT_MSG_SYSTEM")

HCDeaths = {}

local sdate
local stime
local deathType
local zone
local playerName
local playerLevel
local playerClass
local killerName
local killerLevel
local killerClass
local logged
local environment

function HCDeath.resetVariables()
	sdate = nil
	stime = nil
	deathType = nil
	zone = nil
	playerName = nil
	playerLevel = nil
	playerClass = nil
	killerName = nil
	killerLevel = nil
	killerClass = nil
	environment = nil	
end

function HCDeath.tablelength()
	local count = 0
	for _ in pairs(HCDeaths) do
		count = count + 1
	end
	return count	
end

function HCDeath.logDeath()
	if (environment) then killerName = "Natural Causes" end
	if ((not environment) and (deathType == "PVE")) then killerClass = "NPC" end
	table.insert(HCDeaths, sdate .. "," .. stime .. "," .. tostring(deathType) .. "," .. tostring(zone) .. ","  .. tostring(playerName) .. "," .. tostring(playerLevel) .. "," .. tostring(playerClass) .. "," .. tostring(killerName) .. "," .. tostring(killerLevel) .. "," .. tostring(killerClass))
	logged = true
	HCDeath.resetVariables()
end

-- Examples of Turtle WoW HC death messages:
-- PvP = "A tragedy has occurred. Hardcore character PLAYERNAME has fallen in PvP to KILLERNAME at level PLAYERLEVEL. May this sacrifice not be forgotten."
-- PVE = "A tragedy has occurred. Hardcore character PLAYERNAME has fallen to MOBNAME1 MOBNAME2 (level KILLERLEVEL) at level PLAYERLEVEL. May this sacrifice not be forgotten."
-- PVE = "A tragedy has occurred. Hardcore character PLAYERNAME died of natural causes at level PLAYERLEVEL. May this sacrifice not be forgotten."

HCDeath:SetScript("OnEvent", function()
	local hcdeath
	local pvp
	local addedfriend
	local alreadyfriend
	_, _, hcdeath = string.find(arg1,"A tragedy has occurred. Hardcore character (%a+)")
	_, _, addedfriend = string.find(arg1,"(%a+) added to friends")
	_, _, alreadyfriend = string.find(arg1,"(%a+) is already your friend")

	if (hcdeath) then
		-- table.insert(HCDeaths, date("!%y%m%d%H%M") .. "," .. arg1) -- log default message
		playerName = hcdeath

		sdate = date("!%Y/%m/%d")
		stime = date("!%H:%M")

		_, _, pvp = string.find(arg1,"(PvP)")
		_, _, environment = string.find(arg1,"(natural causes)")

		if environment then
			deathType = "PVE"
		elseif pvp then 
			deathType = "PVP"
			_, _, killerName = string.find(arg1,"to%s+(%a+)%s+at")
		else
			deathType = "PVE"
			_, _, killerName = string.find(arg1,"to%s+(.-)%s*%(")
			_, _, killerLevel = string.find(arg1,"%(level%s*(.-)%).-at")			
		end
		
		if (deathType == "PVE") then
			AddFriend(playerName)
		elseif (deathType == "PVP") then
			AddFriend(playerName)
			AddFriend(killerName)
		end

		-- disable system messages
		ChatFrame_RemoveMessageGroup(ChatFrame1, "SYSTEM")
		return
	end

	if (not logged) then
		if (addedfriend or alreadyfriend) then
			-- get player info
			if ((addedfriend == playerName) or (alreadyfriend == playerName)) then
				if (playerName and (not playerClass)) then
					for i=0, GetNumFriends() do
						local name, level, class, area = GetFriendInfo(i)
						if (name == playerName) then
							playerLevel = level
							playerClass = class
							zone = area
							
							if addedfriend then
								RemoveFriend(playerName)								
							end
						end
					end
				end			
			end
			
			if (deathType == "PVP") then
				-- get killer info
				if ((addedfriend == killerName) or (alreadyfriend == killerName)) then
					if (killerName and (not killerClass)) then
						for i=0, GetNumFriends() do
							local name, level, class = GetFriendInfo(i)
							if (name == killerName) then
								killerLevel = level
								killerClass = class

								if addedfriend then
									RemoveFriend(killerName)									
								end
							end
						end
					end
				end
			end
		end

		-- log death if possible
		if (deathType == "PVE") then
			if playerClass then
				HCDeath.logDeath()
			end
		elseif (deathType == "PVP") then
			if playerClass and killerClass then
				HCDeath.logDeath()				
			end
		end
	elseif (logged) then
		-- enable system messages
		ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
		local info = ChatTypeInfo["SYSTEM"]
		DEFAULT_CHAT_FRAME:AddMessage("Hardcore Death Logged (" .. HCDeath.tablelength() .. " Deaths)", info.r, info.g, info.b, info.id)
		logged = nil
	end
end)