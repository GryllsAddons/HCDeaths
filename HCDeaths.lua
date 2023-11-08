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
	levelsound = true,
	toastscale = 1,
	logscale = 1,
	toasttime = 10,
}

local instances = {
	-- Turtle
	"Hateforge Quarry",
	"Black Morass",
	"Karazhan Crypt",
	"Stormwind Vault",
	"Crescent Grove",
	-- Dungeons
	"Blackfathom Deeps",
	"Blackrock Depths",
	"Blackrock Spire",
	"Dire Maul",
	"Gnomeregan",
	"Maraudon",
	"Ragefire Chasm",
	"Razorfen Downs",
	"Razorfen Kraul",
	"Scarlet Monastery",
	"Scholomance",
	"Shadowfang Keep",
	"Stratholme",
	"The Deadmines",
	"The Stockade",
	"Uldaman",
	"Wailing Cavems",
	"Zul'Farrak",
	-- Raids
	"Blackwing Lair",
	"Molten Core",
	"Naxxramas",
	"Onyxia's Lair",
	"Ruins of Ahn'Qiraj",
	"Temple of Ahn'Qiraj",
	"Zul'Gurub",
}

local HCDeath = CreateFrame("Frame", nil, UIParent)
HCDeaths = {}
HCDeaths_LastWords = {}

local media = "Interface\\Addons\\HCDeaths\\media\\"
local deaths = {}
local toastMove -- state of toast moving
local is_pfUI
local twidth, theight = 332.8, 166.4

do
	-- toast
	local HCDeathsToast = CreateFrame("Button", "HCDeathsToast", HCDeath)
	HCDeathsToast:SetWidth(twidth)
	HCDeathsToast:SetHeight(theight)
	HCDeathsToast:Hide()

	-- texture
	HCDeath.texture = HCDeathsToast:CreateTexture(nil,"LOW")
	HCDeath.texture:SetAllPoints(HCDeathsToast)

	HCDeath.type = HCDeathsToast:CreateTexture(nil,"BACKGROUND")
	HCDeath.type:SetPoint("CENTER", HCDeath.texture, "CENTER", -43, -24)

	HCDeath.class = HCDeathsToast:CreateTexture(nil,"BACKGROUND")
	HCDeath.class:SetPoint("CENTER", HCDeath.texture, "CENTER", 0, 10)

	-- text
	local font, size, outline = "Fonts\\FRIZQT__.TTF", 16, "OUTLINE"
	
	HCDeath.level = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")
	HCDeath.level:SetPoint("TOP", HCDeath.texture, "CENTER", 42, -15)
	HCDeath.level:SetWidth(HCDeath.texture:GetWidth())
	HCDeath.level:SetFont(font, size, outline)

	HCDeath.name = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")	
	HCDeath.name:SetWidth(HCDeath.texture:GetWidth())
	HCDeath.name:SetFont(font, size, outline)

	outline = "THINOUTLINE"

	HCDeath.zone = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")	
	HCDeath.zone:SetWidth(HCDeath.texture:GetWidth()*1.5)
	HCDeath.zone:SetFont(font, size, outline)

	HCDeath.death = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")	
	HCDeath.death:SetWidth(HCDeath.texture:GetWidth()*1.5)
	HCDeath.death:SetFont(font, size, outline)

	HCDeath.lastwords = HCDeathsToast:CreateFontString(nil, "LOW", "GameFontNormal")
	HCDeath.lastwords:SetWidth(HCDeath.texture:GetWidth())
	HCDeath.lastwords:SetFont(font, size, outline)
	HCDeath.lastwords:SetTextColor(.5,.5,.5)

	if is_pfUI then
		HCDeath.texture:SetTexture(media.."Ring\\".."Ring_pfUI")
	else
		HCDeath.texture:SetTexture(media.."Ring\\".."Ring")
	end

	HCDeath.name:SetPoint("TOP", HCDeath.texture, "CENTER", 0, -44)
	HCDeath.zone:SetPoint("TOP", HCDeath.name, "BOTTOM", 0, -14)
	HCDeath.death:SetPoint("TOP", HCDeath.zone, "BOTTOM", 0, -5)		
	HCDeath.lastwords:SetPoint("TOP", HCDeath.death, "BOTTOM", 0, -10)
	

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

local toastTimer = CreateFrame("Frame", nil, HCDeath)
toastTimer:Hide()
toastTimer:SetScript("OnUpdate", function()
	if GetTime() >= this.time then
		this.time = nil
		HCDeath:hideToast()
		this:Hide()
		HCDeath:Toast()
	end
end)

function HCDeath:Check_pfUI()
    is_pfUI = IsAddOnLoaded("pfUI")
end

function HCDeath:classSize()
	local s = 85
	HCDeath.class:SetWidth(s)
	HCDeath.class:SetHeight(s)
end

function HCDeath:typeSize()
	local s = 25
	HCDeath.type:SetWidth(s)
	HCDeath.type:SetHeight(s)
end

function HCDeath:showToast()
	HCDeath:classSize()
	HCDeath:typeSize()
	HCDeathsToast:Show()

	toastTimer.time = GetTime() + HCDeaths_Settings.toasttime
	toastTimer:Show()
end

function HCDeath:hideToast()
	HCDeathsToast:Hide()

	HCDeath.name:SetText("")
	HCDeath.level:SetText("")
	HCDeath.zone:SetText("")
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
end

function HCDeath:sound(deathType, playerLevel)
	if (deathType == "PVP" or deathType == "PVE") then
		if HCDeaths_Settings.deathsound then
			PlaySoundFile("Sound/interface/RaidWarning.wav")
		end
	else		
		if HCDeaths_Settings.levelsound then
			if deathType == "LVL" then
				PlaySoundFile("Sound\\Doodad\\G_FireworkLauncher02Custom0.wav")
			elseif deathType == "INFSTART" then
				PlaySoundFile("\\Sound\\Creature\\Razuvious\\RAZ_NAXX_AGGRO01.wav")				
			end
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

					if (hcdeath.deathType == "LVL" or hcdeath.deathType == "INFSTART") then
						HCDeath:RemovePlayerDeath(hcdeath.playerName)
					end

					if (hcdeath.deathType == "LVL") and (not HCDeaths_Settings.progress) then return end					

					local level = tonumber(hcdeath.playerLevel)
					local class = RAID_CLASS_COLORS[strupper(hcdeath.playerClass)] or { r = 1, g = .5, b = 0 }
					local hex = HCDeath:rgbToHex(class.r, class.g, class.b)

					HCDeath.class:SetTexture(media.."Ring\\"..hcdeath.playerClass)
					-- set tyoe texture
					if (hcdeath.deathType == "PVP" or hcdeath.deathType == "PVE") then
						HCDeath.type:SetTexture(media.."Ring\\"..hcdeath.deathType)
					elseif (hcdeath.deathType == "INFSTART") then
						HCDeath.type:SetTexture(media.."Ring\\".."INFERNO")
					else
						HCDeath.type:SetTexture(media.."Ring\\".."LVL")
					end
					HCDeath.level:SetText(hcdeath.playerLevel)
					HCDeath.name:SetText("|cff"..hex..hcdeath.playerName)

					if hcdeath.deathType == "LVL" then
						HCDeath.death:SetText("")
						if level == 60 then
							HCDeath.zone:SetText("Has transcended death and reached level 60!")
							-- HCDeath.quote:SetText("They shall henceforth be known as the Immortal")
						else
							HCDeath.zone:SetText("Has reached level "..level.."!")
							-- HCDeath.quote:SetText("Their ascendance towards immortality continues")
						end
					elseif hcdeath.deathType == "INFSTART" then
						HCDeath.death:SetText("")
						HCDeath.zone:SetText("Has begun the Inferno Challenge!")
					else
						-- local locHex = HCDeath:locHex(hcdeath.zone)		
						-- HCDeath.zone:SetText("Has died in ".."|cff"..locHex..hcdeath.zone)
						HCDeath.zone:SetText("Has died in "..hcdeath.zone)
						HCDeath.name:SetText("|cff"..hex..hcdeath.playerName)
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

						if hcdeath.lastWords ~= "nil" then
							HCDeath.lastwords:SetText('"'..hcdeath.lastWords..'"')
						else
							HCDeath.lastwords:SetText("")
						end

						-- HCDeath.quote:SetText("May this sacrifice not be forgotten!")
					end				
					
					HCDeath:sound(hcdeath.deathType,  level)					
					HCDeath:color(level)
					HCDeath:showToast()
					if (hcdeath.deathType == "PVP" or hcdeath.deathType == "PVE") then
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

function HCDeath:isInstance(location)
	for _, loc in pairs(instances) do
		if loc == location then
			return true
		end
	end
  	return false
end

function HCDeath:locHex(location)
	if HCDeath:isInstance(location) then
		return "A330C9"
	end
	return HCDeath:rgbToHex(1, .5, 0)
end

function HCDeath:locTex(dtype, hctype, location)
	if dtype == "PVP" then
		return media.."Log\\PVP"
	elseif hctype == "INF" then
		return media.."Log\\INFERNO"
	else
		return media.."Log\\PVE"
	end
end

function HCDeath:RemoveDeath(name) -- Called by Toast
	for i, hcdeath in ipairs(deaths) do
		if (hcdeath.playerName == name) or (hcdeath.killerName == name) then
			table.remove(deaths, i)			
			break
		end
	end

	if HCDeaths_LastWords[name] then
		HCDeaths_LastWords[name] = nil
	end
end

function HCDeath:RemovePlayerDeath(name) -- Called by Toast
	for i, hcdeath in ipairs(HCDeaths) do
		if (hcdeath.playerName == name) or (hcdeath.killerName == name) then
			table.remove(HCDeaths, i)
			break
		end
	end
end

function HCDeath:LogDeath() -- Called by add friend system message
	for _, hcdeath in pairs(deaths) do
		if not hcdeath.playerClass then
			hcdeath.playerLevel, hcdeath.playerClass, hcdeath.zone = HCDeath:GetFriendInfo(hcdeath.playerName)

			if (hcdeath.deathType ~= "PVP") and hcdeath.playerClass then
				hcdeath.info = true			
			end
		end

		if (hcdeath.deathType == "PVP") and hcdeath.playerClass and (not hcdeath.killerClass) then
			hcdeath.killerLevel, hcdeath.killerClass = HCDeath:GetFriendInfo(hcdeath.killerName)
			if hcdeath.killerClass then
				hcdeath.info = true
			end
		end

		if hcdeath.info then
			-- check if we already have a death for the player, if we do don't log
			local match
			for _, death in pairs(HCDeaths) do
				if death.playerName == hcdeath.playerName then
					match = true
					break
				end
			end

			hcdeath.lastWords = tostring(HCDeaths_LastWords[hcdeath.playerName])

			if not match then
				table.insert(HCDeaths, {
					sdate = hcdeath.sdate,
					stime = hcdeath.stime,
					deathType = hcdeath.deathType,
					hcType = hcdeath.hcType,
					zone = hcdeath.zone,
					lastWords = hcdeath.lastWords,
					playerName = hcdeath.playerName,
					playerLevel = hcdeath.playerLevel,
					playerClass = hcdeath.playerClass,
					killerName = tostring(hcdeath.killerName),
					killerLevel = tostring(hcdeath.killerLevel),
					killerClass = tostring(hcdeath.killerClass)
				})
			end
			
			-- Remove friends				
			if hcdeath.addedPlayer then
				RemoveFriend(hcdeath.playerName)
			else
				-- already a friend
				if (hcdeath.deathType ~= "PVP") then
					HCDeath:Toast()
				end
			end

			if hcdeath.addedKiller then
				RemoveFriend(hcdeath.killerName)
			else
				-- already a friend
				if (hcdeath.deathType == "PVP") then
					HCDeath:Toast()
				end
			end

		end
	end
end

function HCDeath:GetFriendInfo(player)
	-- name, level, class, area, connected, status, note = GetFriendInfo(friendIndex)
	for i=0, GetNumFriends() do
		local name, level, class, zone = GetFriendInfo(i)
		if (name == player) then
			return level, class, zone
		end
	end
end

function HCDeath:AddFriends()
	for _, hcdeath in pairs(deaths) do
		if not HCDeath:isFriend(hcdeath.playerName) then
			AddFriend(hcdeath.playerName)
			hcdeath.addedPlayer = true
		else
			-- player is already your friend
			-- if pve death we can log, else we need to add the killer
			if (hcdeath.deathType == "PVE") then
				HCDeath:LogDeath()
			end
		end

		if (hcdeath.deathType == "PVP") then
			if not HCDeath:isFriend(hcdeath.killerName) then
				AddFriend(hcdeath.killerName)
				hcdeath.addedKiller = true
			else
				-- player is already your friend
				HCDeath:LogDeath()
			end
		end		
	end
end

function HCDeath:AddedFriend(player)
	-- returns true if friend was added to deaths table
	for _, hcdeath in pairs(deaths) do
		if (hcdeath.playerName == player) or (hcdeath.killerName == player) then
			return true
		end
	end
end

function HCDeath:isFriend(player)
	for i=1, GetNumFriends() do
		local name = GetFriendInfo(i)		
		if (name == player) then
			return true
		end
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

function HCDeath:systemMessage(message)
	if HCDeaths_Settings.message then
		local info = ChatTypeInfo["SYSTEM"]
		DEFAULT_CHAT_FRAME:AddMessage(message, info.r, info.g, info.b, info.id)
	end
end

local testmsg
function HCDeath:test(dtype, player, plevel, killer)	
	if dtype == "pve" then
		testmsg = "A tragedy has occurred. Hardcore character "..player.." died of natural causes at level "..plevel..". May this sacrifice not be forgotten."
	elseif dtype == "pvp" then
		testmsg = "A tragedy has occurred. Hardcore character "..player.." has fallen in PvP to "..killer.." at level "..plevel.."."
	end
	SendChatMessage(".server info")
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
		if testmsg then
			arg1 = testmsg
			testmsg = nil
		end

		-- Examples of Turtle WoW HC progress messages:
		-- "PLAYERNAME has reached level 20/30/40/50 in Hardcore mode! Their ascendance towards immortality continues, however, so do the dangers they will face.
		-- "PLAYERNAME has transcended death and reached level 60 on Hardcore mode without dying once! PLAYERNAME shall henceforth be known as the Immortal!"

		-- Examples of Turtle WoW Inferno messages:
		-- Started = "PLAYERNAME has laughed in the face of death in the Hardcore challenge. PLAYERNAME has begun the Inferno Challenge!"
		-- PVE (*does not show PLAYERNAME*) = "A tragedy has occurred. Inferno character has fallen to MOBNAME1 MOBNAME2 (level KILLERLEVEL) at level PLAYERLEVEL..."
		-- NAT = ??
		-- PVP = ??

		-- Examples of Turtle WoW Hardcore messages:
		-- PVE = "A tragedy has occurred. Hardcore character PLAYERNAME has fallen to MOBNAME1 MOBNAME2 (level KILLERLEVEL) at level PLAYERLEVEL..."
		-- NAT = "A tragedy has occurred. Hardcore character PLAYERNAME died of natural causes at level PLAYERLEVEL..."
		-- PvP = "A tragedy has occurred. Hardcore character PLAYERNAME has fallen in PvP to KILLERNAME at level PLAYERLEVEL..."

		-- Example of /who result messages:
		-- [PLAYERNAME]: Level PLAYERLEVEL PLAYERRACE PLAYERCLASS <PLAYERGUILD> - AREA
		-- 1 player Total

		-- Example of friend messages:
		-- PLAYERNAME added to friends
		-- PLAYERNAME removed from friends

		local _, _, hcprogress = string.find(arg1, "(%a+) has reached level (%d%d) in Hardcore mode")
		local _, _, hcimmortal = string.find(arg1, "(%a+) has transcended death and reached level 60")
		local _, _, hcdeath = string.find(arg1,"A tragedy has occurred. Hardcore character (%a+)")
		-- local _, _, infstart = string.find(arg1,"(%a+) has begun the Inferno Challenge")
		-- local _, _, infdeath = string.find(arg1,"A tragedy has occurred. Inferno character (%a+)")

		_, _, addedFriend = string.find(arg1,"(%a+) added to friends")
		_, _, removedFriend = string.find(arg1,"(%a+) removed from friends")
		_, _, alreadyFriend = string.find(arg1,"(%a+) is already your friend")
		
		if hcprogress or hcimmortal then
			HCDeath:systemMessage(arg1)
			
			local _, _, playerName = string.find(arg1,"(%a+) has")
			local _, _, playerLevel = string.find(arg1,"reached level (%d+)")

			table.insert(deaths, {
				sdate = date("!%Y/%m/%d"),
				stime = date("!%H:%M:%S"),
				deathType = "LVL",
				hcType = "HC",
				zone = nil,
				playerName = playerName,
				playerLevel = playerLevel,
				playerClass = nil,
				info = nil
			})

			if HCDeath:friendSlots() then
				HCDeath:AddFriends()
				return
			end
		elseif infstart then
			HCDeath:systemMessage(arg1)
			
			local _, _, playerName = string.find(arg1,"(%a+) has")

			table.insert(deaths, {
				sdate = date("!%Y/%m/%d"),
				stime = date("!%H:%M:%S"),
				deathType = "INFSTART",
				hcType = "INF",
				zone = nil,
				playerName = playerName,
				playerLevel = nil,
				playerClass = nil,
				info = nil
			})

			if HCDeath:friendSlots() then
				HCDeath:AddFriends()
				return
			end
		elseif hcdeath then --or infdeath then
			HCDeath:systemMessage(arg1)

			local hcType = "HC"
			-- local hcType 
			-- if hcdeath then
			-- 	hcType = "HC"
			-- elseif infdeath then
			-- 	hcType = "INF"
			-- end			

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
				hcType = hcType,
				zone = nil,
				playerName = hcdeath,
				playerLevel = playerLevel,
				playerClass = nil,
				killerName = killerName,
				killerLevel = killerLevel,
				killerClass = killerClass,
				lastWords = nil,
				info = nil
			})

			if HCDeath:friendSlots() then
				HCDeath:AddFriends()
				return
			end
			return
		end

		if addedFriend or alreadyFriend then
			if HCDeath:AddedFriend(addedFriend) or HCDeath:AddedFriend(alreadyFriend) then
				HCDeath:LogDeath()
				return
			end
		elseif HCDeath:AddedFriend(removedFriend) then
			HCDeath:Toast()
			return
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
	HCDeaths_Settings.toastscale = 1
	HCDeaths_Settings.logscale = 1
	HCDeaths_Settings.toasttime = 10
	HCDeaths_Settings.progress = true

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
	elseif string.find(msg, "toast time %d") then
		num = fontnum(msg)
		HCDeaths_Settings.toasttime = num
		HCDeath:print("toast time set to "..HCDeaths_Settings.toasttime.." seconds")
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
	elseif msg == "progress" then
		if HCDeaths_Settings.progress then
			HCDeaths_Settings.progress = false
		else
			HCDeaths_Settings.progress = true
		end
		message(HCDeaths_Settings.progress, "progress toast")
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
	elseif msg == "test" then
		-- HCDeath:test("pve", "player", "level")
		-- HCDeath:test("pvp", "player", "level", "killer")
		HCDeath:test("pve", "Tents", "10")
    else
		HCDeath:print("commands:")
		HCDeath:print("/hcd message - toggle system death messages")
		HCDeath:print("/hcd move - toggles the toast so you can move it")
		HCDeath:print("/hcd log - toggle death log")		
		HCDeath:print("/hcd log scale num - sets the death log scale to num")
		HCDeath:print("/hcd toast - toggle toast popups")
		HCDeath:print("/hcd toast scale num - sets the toast popup scale to num")
		HCDeath:print("/hcd toast time num - sets the number of seconds the toast will display to num")
		HCDeath:print("/hcd progress - toggle level progress toasts")
		HCDeath:print("/hcd color - toggle toast ring colors")
		HCDeath:print("/hcd deathsound - toggle toast deathsounds")
		HCDeath:print("/hcd levelsound - toggle toast levelsounds")
		HCDeath:print("/hcd reset - reset settings")
    end
end

do  
	local max_width = 185
	local max_height = 56
  
	local HCDeathsLog = CreateFrame("Button", "HCDeathsLog", HCDeath)
	HCDeathsLog:Hide()

	HCDeathsLog:SetWidth(max_width-20)
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
  
	HCDeathsLog.title = HCDeathsLog:CreateFontString(nil, "LOW", "GameFontNormal")
	-- HCDeathsLog.title:SetPoint("TOPLEFT", HCDeathsLog, "TOPLEFT", 8, -7)
	HCDeathsLog.title:SetPoint("TOP", HCDeathsLog, "TOP", 0, -7)
	HCDeathsLog.title:SetText("Hardcore Deaths")
	HCDeathsLog.title:SetTextColor(.5, .5, .5, 1)
  
	HCDeathsLog.scrollframe = CreateFrame("ScrollFrame", "HCDeathsLogScrollframe", HCDeathsLog, "UIPanelScrollFrameTemplate")
	HCDeathsLog.scrollframe:SetHeight(max_height + 20)
	HCDeathsLog.scrollframe:SetWidth(max_width - 34)
	HCDeathsLog.scrollframe:SetPoint('CENTER', HCDeathsLog, 0, -8)
	HCDeathsLog.scrollframe:Hide()	
  
	HCDeathsLog.container = CreateFrame("Frame", "HCDeathsLogContainer", HCDeathsLog)
	HCDeathsLog.container:SetHeight(max_height - 5)
	HCDeathsLog.container:SetWidth(max_width)
	HCDeathsLog.container:SetPoint("CENTER", HCDeathsLog, 0, 0)
  
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
	HCDeathsLog.class = {}
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

		tinsert(HCDeathsLog.class, HCDeathsLog.container:CreateTexture(nil,"LOW"))
		HCDeathsLog.class[i]:SetWidth(tex)
		HCDeathsLog.class[i]:SetHeight(tex)
		HCDeathsLog.class[i]:Hide()

		tinsert(HCDeathsLog.background, CreateFrame("Frame",nil,HCDeathsLog.container))		
		HCDeathsLog.background[i]:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
		HCDeathsLog.background[i]:Hide()
		HCDeathsLog.background[i]:EnableMouse(true)	
		
		HCDeathsLog.background[i]:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end

	local function mouseWheel()
		local scrollBar = getglobal(this:GetName().."ScrollBar");

		if arg1 > 0 then
		  if IsShiftKeyDown() then
			scrollBar:SetValue(0)
		  else
			scrollBar:SetValue(scrollBar:GetValue() - (scrollBar:GetHeight() / 2))
		  end
		elseif arg1 < 0 then
		  if IsShiftKeyDown() then
			scrollBar:SetValue(1000)			
		  else
			scrollBar:SetValue(scrollBar:GetValue() + (scrollBar:GetHeight() / 2))
		  end
		end

		if scrollBar:GetValue() > 0 then
			scrollBar:SetAlpha(1)
		else
			scrollBar:SetAlpha(0)
		end
	end

	HCDeathsLog.scrollframe:SetScript("OnMouseWheel", mouseWheel)
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

	HCDeathsLog:SetHeight(105)

	local max = HCDeath:tableLength()
	local min = max - HCDeathsLog.limit
	local limit = HCDeathsLog.limit

	for i = max, min, -1 do
		local hcdeath = HCDeaths[i]
		if not hcdeath then return end
		if not HCDeathsLog.type[limit] then return end

		if (hcdeath.deathType == "PVP" or hcdeath.deathType == "PVE") then
			local dtype = HCDeathsLog.type[limit]		
			local level = HCDeathsLog.level[limit]
			local name = HCDeathsLog.name[limit]
			local class = HCDeathsLog.class[limit]
			local background = HCDeathsLog.background[limit]
			limit = limit - 1

			dtype:SetPoint("TOPLEFT", HCDeathsLog.container, "TOPLEFT", 0, -yoff)
			level:SetPoint("TOPLEFT", HCDeathsLog.container, "TOPLEFT", 18, -yoff-2)
			name:SetPoint("TOPLEFT", HCDeathsLog.container, "TOPLEFT", 40, -yoff-2)
			class:SetPoint("TOPLEFT", HCDeathsLog.container, "TOPLEFT", 135, -yoff)
			
			-- type
			-- locTexture
			local locTex = HCDeath:locTex(hcdeath.deathType, hcdeath.hcType, hcdeath.zone)
			dtype:SetTexture(locTex)
			dtype:Show()

			-- level
			level:SetText(hcdeath.playerLevel)

			-- name
			local pclass = RAID_CLASS_COLORS[strupper(hcdeath.playerClass)] or { r = .5, g = .5, b = .5 }
			local classhex = HCDeath:rgbToHex(pclass.r, pclass.g, pclass.b)
			name:SetText("|cff"..classhex..hcdeath.playerName)

			-- class
			class:SetTexture(media.."Log\\"..hcdeath.playerClass)
			class:Show()

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

				-- player			
				local pname = "|cff"..classhex..hcdeath.playerName.."|r"
				local pclass = "|cff"..classhex..hcdeath.playerClass.."|r"
				local locHex = HCDeath:locHex(hcdeath.zone)	
				local zone = "|cff"..locHex..hcdeath.zone.."|r"

				local lastwords = ""
				if hcdeath.lastWords ~= "nil" then
					lastwords = NORMAL_FONT_COLOR_CODE..'Their last words were '..GRAY_FONT_COLOR_CODE..'"'..hcdeath.lastWords..'"'..NORMAL_FONT_COLOR_CODE..'.|r'
				end

				-- killer
				local kclass = RAID_CLASS_COLORS[strupper(hcdeath.killerClass)] or { r = 1, g = .5, b = 0 }
				local classhex = HCDeath:rgbToHex(kclass.r, kclass.g, kclass.b)				
				local kname = "|cff"..classhex..hcdeath.killerName.."|r"
				kclass = "|cff"..classhex..hcdeath.killerClass.."|r"
				
				local killer
				if hcdeath.deathType == "PVP" then
					killer = kname..NORMAL_FONT_COLOR_CODE.." the level "..hcdeath.killerLevel.." |r"..kclass
				else
					if hcdeath.killerLevel ~= "nil" then
						killer = kname..NORMAL_FONT_COLOR_CODE.." level "..hcdeath.killerLevel.."|r"
					else
						killer = kname
					end
				end

				-- tooltip				
				if not GameTooltip:IsShown() then 
					GameTooltip:SetOwner(this, ANCHOR_BOTTOMLEFT)
				end
				GameTooltip:ClearLines()
				GameTooltip:AddLine(death.type, death.r, death.g, death.b)
				GameTooltip:AddLine(pname..NORMAL_FONT_COLOR_CODE.." the level "..hcdeath.playerLevel.." |r"..pclass..NORMAL_FONT_COLOR_CODE.." died in |r"..zone..NORMAL_FONT_COLOR_CODE.." to |r"..killer..NORMAL_FONT_COLOR_CODE..". |r"..lastwords,_,_,_,true)
				-- GameTooltip:AddLine("Date: "..hcdeath.sdate.." Time: "..hcdeath.stime)
				GameTooltip:Show()
			end)
			
			yoff = yoff + 15 -- spacing between items
			HCDeathsLog.container:SetHeight(75)			
		
			if not HCDeathsLog.scrollframe:IsShown() then
				HCDeathsLog.container:SetParent(HCDeathsLog.scrollframe)
				HCDeathsLog.container:SetHeight(HCDeathsLog.scrollframe:GetHeight())
				HCDeathsLog.container:SetWidth(HCDeathsLog.scrollframe:GetWidth())
		
				HCDeathsLog.scrollframe:SetScrollChild(HCDeathsLog.container)
				HCDeathsLog.scrollframe:Show()
				HCDeathsLogScrollframeScrollBar:SetAlpha(0)
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

HCDeath:RegisterEvent("PLAYER_ENTERING_WORLD")
HCDeath:SetScript("OnEvent", function()
	if not this.loaded then
		this.loaded = true
		SLASH_HCDEATHS1 = "/hcdeaths"
		SLASH_HCDEATHS2 = "/hcd"
		SlashCmdList["HCDEATHS"] = HCDeaths_commands
		HCDeath:Check_pfUI()
		HCDeath:ToastScale()
		HCDeath:ToggleLog()			
		HCDeath:print("HCDeaths Loaded! /hcdeaths or /hcd")
	end
end)

function HCDeath:toastMove()
	HCDeath.level:SetText("60")
	HCDeath.name:SetText("Toast")
	HCDeath.zone:SetText("Has died in Blackrock Mountains")
	HCDeath.death:SetText("to Torta level 60")
	HCDeath.lastwords:SetText('"'.."I like turtles!"..'"')
	-- HCDeath.quote:SetText("May this sacrifice not be forgotten!")
	
	HCDeath:color(60)
	HCDeath.texture:SetVertexColor(.75,.75,.75)	
	HCDeath.class:SetTexture(media.."Ring\\".."Warrior")
	HCDeath.type:SetTexture(media.."Ring\\".."PVP")
	HCDeath:classSize()
	HCDeath:typeSize()
	HCDeathsToast:Show()
end