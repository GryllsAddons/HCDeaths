-- This addon will save Turtle WoW hardcore deaths to "\WTF\Account\ACCOUNTNAME\SavedVariables\HCDeaths.lua" in the following format:
-- date,time,deathType,zone,playerName,playerLevel,playerClass,killerName,killerLevel,killerClass

local HCDeath = CreateFrame("Frame", nil, UIParent)
HCDeath:RegisterEvent("CHAT_MSG_SYSTEM")

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

function HCDeath:showDeaths()
	for _, hcdeath in pairs(deaths) do
		DEFAULT_CHAT_FRAME:AddMessage(hcdeath.playerName)
	end
end

function HCDeath:friendSlots()
	-- the maximum friend limit for a vanilla client is 50
	-- the addon requires 2 free friend slots to add the player and killer (if pvp death) info
	local numFriends = GetNumFriends()
	if (numFriends > 48) then
		local requiredSlots = 50 - numFriends
		DEFAULT_CHAT_FRAME:AddMessage("|cfffc5100Unable to log hardcore death due to friend list limit, please remove "..requiredSlots.." friend(s) to enable logging.|r")
		return false
	else
		return true
	end
end

function HCDeath:isFriend(player)
	for i=0, GetNumFriends() do
		local name = GetFriendInfo(i)
		if (name == player) then
			return true
		end
	end
end

function HCDeath:friendInfo(player)
	for i=0, GetNumFriends() do
		local name, level, class, area = GetFriendInfo(i)
		if (name == player) then
			return level, class, area
		end
	end
end

function HCDeath:AddFriends()	
	for _, hcdeath in pairs(deaths) do
		if HCDeath:isFriend(hcdeath.playerName) then
			HCDeath:logDeath(hcdeath.playerName)
		else
			hcdeath.addedPlayer = true
			AddFriend(hcdeath.playerName)
		end

		if (hcdeath.deathType == "PVP") then
			if HCDeath:isFriend(hcdeath.killerName) then
				HCDeath:logDeath(hcdeath.killerName)
			else
				hcdeath.addedKiller = true
				AddFriend(hcdeath.killerName)
			end
		end
	end
end

function HCDeath:logDeath(player)
	for _, hcdeath in pairs(deaths) do
		if (player == hcdeath.playerName) then
			hcdeath.playerLevel, hcdeath.playerClass, hcdeath.zone = HCDeath:friendInfo(hcdeath.playerName)				
		elseif (player == hcdeath.killerName) then
			hcdeath.killerLevel, hcdeath.killerClass = HCDeath:friendInfo(hcdeath.killerName)			
		end

		if (hcdeath.deathType == "PVE") then
			if (not hcdeath.info) and hcdeath.playerLevel and hcdeath.playerClass and hcdeath.zone then
				hcdeath.info = true
			end
		elseif (hcdeath.deathType == "PVP") then
			if (not hcdeath.info) and hcdeath.playerLevel and hcdeath.playerClass and hcdeath.zone and hcdeath.killerLevel and hcdeath.killerClass then
				hcdeath.info = true
			end
		end

		if hcdeath.info then
			table.insert(HCDeaths, hcdeath.sdate..","..hcdeath.stime..","..hcdeath.deathType..","..hcdeath.zone..","..hcdeath.playerName..","..hcdeath.playerLevel..","..hcdeath.playerClass..","..hcdeath.killerName..","..tostring(hcdeath.killerLevel)..","..hcdeath.killerClass)
			DEFAULT_CHAT_FRAME:AddMessage("|cfffc5100Hardcore "..hcdeath.deathType.." Death Logged ("..HCDeath:tableLength().." Deaths)|r")
			logged = true

			if hcdeath.addedPlayer then
				RemoveFriend(hcdeath.playerName)
			end

			if hcdeath.addedKiller then
				RemoveFriend(hcdeath.killerName)
			end
		end
	end

	if logged then
		HCDeath:remove()
	end
end

function HCDeath:remove(removedfriend)
	for i, hcdeath in ipairs(deaths) do
		if (hcdeath.deathType == "PVE") then
			if (removedfriend == hcdeath.playerName) or (not hcdeath.addedPlayer) then
				HCDeath:reset(i)
				break
			end
		elseif (hcdeath.deathType == "PVP") then
			if (removedfriend == hcdeath.killerName) or (not hcdeath.addedKiller) or (not hcdeath.addedPlayer) then
				HCDeath:reset(i)
				break
			end
		end
	end
end

function HCDeath:reset(i)
	table.remove(deaths, i)
	logged = nil
	HCDeath:enableMessages()
end

function HCDeath:enableMessages()
	ChatFrame1:RegisterEvent("CHAT_MSG_SYSTEM")
end

function HCDeath:disableMessages()
	ChatFrame1:UnregisterEvent("CHAT_MSG_SYSTEM")
end

HCDeath:SetScript("OnEvent", function()	
	-- Examples of Turtle WoW HC death messages:
	-- PvP = "A tragedy has occurred. Hardcore character PLAYERNAME has fallen in PvP to KILLERNAME at level PLAYERLEVEL. May this sacrifice not be forgotten."
	-- PVE = "A tragedy has occurred. Hardcore character PLAYERNAME has fallen to MOBNAME1 MOBNAME2 (level KILLERLEVEL) at level PLAYERLEVEL. May this sacrifice not be forgotten."
	-- PVE = "A tragedy has occurred. Hardcore character PLAYERNAME died of natural causes at level PLAYERLEVEL. May this sacrifice not be forgotten."

	local hcdeath, addedfriend, removedfriend
	_, _, hcdeath = string.find(arg1,"A tragedy has occurred. Hardcore character (%a+)")
	_, _, addedfriend = string.find(arg1,"(%a+) added to friends")
	_, _, removedfriend = string.find(arg1,"(%a+) removed from friends")	
	
	if hcdeath then
		if HCDeath:friendSlots() then
			-- table.insert(HCDeaths, date("!%y%m%d%H%M")..","..arg1) -- log default message

			local pvp, natural, dType, kName, kLevel, kClass
			_, _, pvp = string.find(arg1,"(PvP)")
			_, _, natural = string.find(arg1,"(natural causes)")			

			if pvp then 
				dType = "PVP"
				_, _, kName = string.find(arg1,"to%s+(%a+)%s+at")
			else
				dType = "PVE"
				if natural then
					kName = "Natural Causes"
					kClass = "ENV"
				else
					_, _, kName = string.find(arg1,"to%s+(.-)%s*%(")
					_, _, kLevel = string.find(arg1,"%(level%s*(.-)%).-at")
					kClass = "NPC"
				end
			end

			table.insert(deaths, {
				sdate = date("!%Y/%m/%d"),
				stime = date("!%H:%M:%S"),
				deathType = dType,
				zone = nil,
				playerName = hcdeath,
				playerLevel = nil,
				playerClass = nil,
				killerName = kName,
				killerLevel = kLevel,
				killerClass = kClass,
				addedPlayer = nil,
				addedKiller = nil,
				info = nil
			})

			HCDeath:disableMessages()
			HCDeath:AddFriends()
			return
		end
	elseif addedfriend and (not logged) then
		HCDeath:logDeath(addedfriend)
		return
	elseif removedfriend and logged then
		HCDeath:remove(removedfriend)
		return
	end
end)

HCDeath:enableMessages()
DEFAULT_CHAT_FRAME:AddMessage("|cfffc5100HCDeaths Loaded!|r")