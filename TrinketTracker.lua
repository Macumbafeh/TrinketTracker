local abilityIDs = {
	-- none, these can ONLY be broken by trinket
	[33786] = "none", -- Cyclone 
	[710] = "none", -- Banish
	-- physicalStun all stuns which don't break on damage
    [1833] = "physicalStun", -- Cheap Shot
    [8643] = "physicalStun", -- Kidney Shot
	[5211] = "physicalStun", -- Bash
	[25274] = "physicalStun", -- Intercept Stun
	[9005] = "physicalStun", -- Pounce stun
	[5530] = "physicalStun", -- Mace Stun Effect
	[19410] = "physicalStun", -- Improved Concussive Shot
	[12809] = "physicalStun", -- Concussion Blow	
	-- all physical effects which ONLY break on damage
    [1776] = "physicalPoly", -- Gouge
    [2094] = "physicalPoly", -- Blind
    [6770] = "physicalPoly", -- Sap
	[19503] = "physicalPoly", -- Scatter Shot
	-- all effects which can only be broken by Blessing of Freedom, Blessing of Protection or Escape Artist
	[19229] = "physicalRoot", -- Improved Wing Clip
	[23694] = "physicalRoot", -- Hamstring Proc
	-- all physical effects which can be broken by tremor
	[5246] = "physicalFearTremor", -- Intimidating Shout || this will need a hack later on, because the target of the spell breaks on 1 damage
	-- all physical effects which only break from DIRECT damage
	[22570] = "physicalPolyPeriodic", -- Maim (4p 5s)
	-- all magic effects which only break from DIRECT damage
    [33043] = "magicPolyPeriodic", -- Dragon's Breath
	-- all magic effects which break on damage
	[118] = "magicPoly", -- Poly
	[28272] = "magicPoly", -- Poly Pig
	[28271] = "magicPoly", -- Poly Turtle
	[14309] = "magicPoly", -- Freezing Trap Effect 
	[20066] = "magicPoly", -- Repentance
	-- all effects which can be dispelled but also break after ~1500 damage taken
    [26989] = "magicRoots", -- Entangling Roots
	[33395] = "magicRoots", -- Freeze (Watelemental)
	[122] = "magicRoots", -- Frost nova
	[12494] = "magicRoots", -- Frostbite
	-- all magic effects that break on damage but also break on tremor
    [2637] = "magicPolyTremor", -- Hibernate
	-- all poison effects that break on damage but also break on tremor / stoneform
	[19386] = "poisonPolyTremor", -- Wyvern Sting
	-- all magic effects which can be dispelled, break on tremor and on ~1500 damage
	[8122] = "magicFearTremor", -- Psychic Scream
	[5484] = "magicFearTremor", -- Howl of Terror
	[14326] = "magicFearTremor", -- Scare Beast
	[6215] = "magicFearTremor", -- Fear
    -- all effects which can ONLY be dispelled
    [853] = "magic", -- Hammer of Justice
	[27223] = "magic", -- Death Coil
    [19185] = "magic", -- Entrapment	
}

local categories = {
	["none"] = {
		-- these effects CANNOT be removed by anything other than trinket
		["none"] = 1, 
	},
	["physicalStun"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
	},
	["physicalPoly"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		["damage"] = 1, -- any form of damage breaks this
		["periodicDamage"] = 1, -- any form of periodic damage breaks this
	},
	["physicalRoot"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[20589] = 1, -- Escape Artist
		[1044] = 1, -- Blessing of Freedom
	},
	["physicalFearTremor"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[7744] = 1, -- Will of the Forsaken
		["tremor"] = 1, -- broken by tremor
		["bigDamage"] = 1, -- broken by ~1500 damage
	},
	["physicalPolyPeriodic"] = {
		[10278] = 1, -- Blessing of Protection
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		["damage"] = 1,
	},
	["magicPolyPeriodic"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		["damage"] = 1,
		["dispel"] = 1,
	},
	["magicPoly"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		["damage"] = 1,
		["dispel"] = 1,
		["periodicDamage"] = 1,
	},
	["magicRoots"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[20589] = 1, -- Escape Artist
		[1044] = 1, -- Blessing of Freedom
		["dispel"] = 1,
		["bigDamage"] = 1, -- broken by ~1500 damage
	},
	["magicPolyTremor"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		["damage"] = 1,
		["dispel"] = 1,
		["periodicDamage"] = 1,
		["tremor"] = 1,
	},
	["poisonPolyTremor"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[7744] = 1, -- Will of the Forsaken
		[20594] = 1, -- Stoneform
		["damage"] = 1,
		["dispel"] = 1,
		["periodicDamage"] = 1,
		["tremor"] = 1,
	},
	["magicFearTremor"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		[7744] = 1, -- Will of the Forsaken
		["bigDamage"] = 1,
		["dispel"] = 1,
		["tremor"] = 1,
	},
	["magic"] = {
		[1020] = 1, -- Divine Shield
		[45438] = 1, -- Ice Block
		["dispel"] = 1, 
	},
}

local damageEvents = {
	["SWING_DAMAGE"] = 1,
	["SPELL_DAMAGE"] = 1,
	["RANGE_DAMAGE"] = 1,
	["SPELL_DRAIN"] = 1,
	["SPELL_LEECH"] = 1,
}

local periodicDamageEvents = {
	["SPELL_PERIODIC_DAMAGE"] = 1,
	["SPELL_PERIODIC_DRAIN"] = 1,
	["SPELL_PERIODIC_LEECH"] = 1,
}
local logEvents = {
	["SWING_DAMAGE"] = 1,
	["SPELL_DAMAGE"] = 1,
	["RANGE_DAMAGE"] = 1,
	["SPELL_PERIODIC_DAMAGE"] = 1,
	["SPELL_DISPEL"] = 1,
	["SPELL_DRAIN"] = 1,
	["SPELL_LEECH"] = 1,
	["SPELL_PERIODIC_DRAIN"] = 1,
	["SPELL_PERIODIC_LEECH"] = 1,
	--["SPELL_AURA_APPLIED"] = 1,
	["SPELL_CAST_SUCCESS"] = 1,
}
local immunityIDs = {
	[1020] = 1, -- Divine Shield
	[45438] = 1, -- Ice Block
	[7744] = 1, -- Will of the Forsaken
	[20594] = 1, -- Stoneform
	[20589] = 1, -- Escape Artist
	[1044] = 1, -- Blessing of Freedom
	[10278] = 1, -- Blessing of Protection
}
local unitIDs = {
	["target"] = 1,
	["targettarget"] = 1,
	["focus"] = 1,
}

TrinketTrackerDebug = 1
TrinketTrackerDB = TrinketTrackerDB or { sync = true}
local function log(msg)
	if TrinketTrackerDebug == 1 then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	elseif TrinketTrackerDebug == 0 then
		return
	end
end -- alias for convenience

local function firstToUpper(str)
	if (str~=nil) then
		return (str:gsub("^%l", string.upper));
	else
		return nil;
	end
end

local function wipe(t)
	for k,v in pairs(t) do
		t[k]=nil
	end
end

local TrinketTracker = CreateFrame("Frame", nil, UIParent);
function TrinketTracker:OnEvent(event, ...) -- functions created in "object:method"-style have an implicit first parameter of "self", which points to object
	self[event](self, ...) -- route event parameters to LoseControl:event methods
end
TrinketTracker:SetScript("OnEvent", TrinketTracker.OnEvent)
TrinketTracker:RegisterEvent("PLAYER_ENTERING_WORLD")
TrinketTracker:RegisterEvent("PLAYER_LOGIN")

function TrinketTracker:StartTimer(destGUID, spellName, timeLeft, duration)
	-- don't create any more frames than necessary to avoid memory overload
	if self.guids[destGUID] and self.guids[destGUID][spellName] then
		self:UpdateTimer(destGUID, spellName, timeLeft, duration)
	else
		if type(self.guids[destGUID]) ~= "table" then
			self.guids[destGUID] = { }
		end
		
		--self.guids[destGUID][spellName] = CreateFrame("Frame", spellName .. "_" .. destGUID)
		self.guids[destGUID][spellName] = {}
		-- use ACTUAL GetTime() at which the spell started, regardless of when this function is called
		self.guids[destGUID][spellName].startTime = GetTime()-(duration-timeLeft)
		self.guids[destGUID][spellName].timeLeft = timeLeft
		
		log("Found timer for spell: "..spellName.." with time left: "..timeLeft)
	end
end

function TrinketTracker:UpdateTimer(destGUID, spellName, timeLeft, duration)
	if self.guids[destGUID] and self.guids[destGUID][spellName] and self.abilities[spellName] then
	
		-- update "library"
		--if self.guids[destGUID][spellName].startTime <
		self.guids[destGUID][spellName].startTime = GetTime()-(duration-timeLeft)
		self.guids[destGUID][spellName].timeLeft = timeLeft
		
		log("Found timer for spell: "..spellName.." with time left: "..timeLeft)
	end
end

function TrinketTracker:PLAYER_LOGIN(...)
	--self:CreateOptions()
end

function TrinketTracker:PLAYER_TARGET_CHANGED(...)
	self:UNIT_AURA("target")
end

function TrinketTracker:PLAYER_FOCUS_CHANGED(...)
	self:UNIT_AURA("focus")
end

function TrinketTracker:PLAYER_ENTERING_WORLD(...)
	-- clear frames, just to be sure
	if type(self.guids) == "table" then
		for k,v in pairs(self.guids) do
			for ke,va in pairs(self.abilities) do
				local frame = getglobal(ke.."_"..k)
				if frame then
					frame = nil
				end
			end
		end
	end
	
	self.guids = {}
	self.abilities = {}
	for k,v in pairs(abilityIDs) do
		self.abilities[GetSpellInfo(k)]=v;
	end
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	
end

function TrinketTracker:UNIT_AURA(unitID, ...)
	if unitIDs[unitID] then
		for i=1, 40 do
			local name, rank, icon, count, debuffType, duration, timeLeft = UnitDebuff(unitID, i)
			if timeLeft ~= nil and timeLeft > 0 and self.abilities[name] then
				self:StartTimer(UnitGUID(unitID), name, timeLeft, duration)
			end
		end
	end
end

function TrinketTracker:CheckTrinket(category, destGUID, destName, spellTimer, spellName)
	if not category then return end
	local damage, periodicDamage, bigDamage, iceblock, wotf, bubble, escapeartist,
	stoneform, freedom, protection, dispel, tremor
	if category["none"] then
		log(destName.." trinketed")
	end	
	if category["damage"] then
		damage = self:CheckDamage(destGUID, spellTimer)
		if damage == true then
			log(spellName.." on "..destName.." broke on damage")
		end
	end
	if category["periodicDamage"] then
		periodicDamage = self:CheckPeriodicDamage(destGUID, spellTimer)
		if periodicDamage  == true then
			log(spellName.." on "..destName.. "broke on periodic damage")
		end
	end
	if category[45438] then
		iceblock = self:CheckImmunity(destGUID, spellTimer, 45438)
		if iceblock == true then
			log(spellName.." on "..destName.." broke with ice block")
		end
	end
	if category[7744] then
		wotf = self:CheckImmunity(destGUID, spellTimer, 7744)
		if wotf == true then
			log(spellName.." on "..destName.." broke with will")
		end
	end
	if category[1020] then
		bubble = self:CheckImmunity(destGUID, spellTimer, 1020)
		if bubble == true then
			log(spellName.." on "..destName.." broke with bubble")
		end
	end
	if category[20594] then
		stoneform = self:CheckImmunity(destGUID, spellTimer, 20594)
		if stoneform == true then
			log(spellName.." on "..destName.." broke with stoneform")
		end	
	end
	if category[20589] then
		escapeartist = self:CheckImmunity(destGUID, spellTimer, 20589)
		if escapeartist == true then
			log(spellName.." on "..destName.." broke with escape artist")
		end	
	end
	if category[1044] then
		freedom = self:CheckImmunity(destGUID, spellTimer, 1044)
		if freedom == true then
			log(spellName.." on "..destName.." broke with freedom")
		end	
	end
	if category[10278] then
		local protection = self:CheckImmunity(destGUID, spellTimer, 10278)
		if protection == true then
			log(spellName.." on "..destName.." broke with protection")
		end	
	end
	if category["dispel"] then
		dispel = self:CheckDispel(destGUID, spellTimer, spellName)
		if dispel == true then
			log(spellName.." on "..destName.." was dispelled")
		end
	end
end

function TrinketTracker:HasTrinket()
	
end

function TrinketTracker:CheckDispel(destGUID, spellTimer, searchName)
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		spellID,spellName,spellSchool,extraSpellID,extraSpellName,extraSchool,auraType = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if eventType == "SPELL_DISPEL" and extraSpellName == searchName then			
				return true
			end
		end
	end
	return false
end

function TrinketTracker:CheckImmunity(destGUID, spellTimer, searchID)
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_CAST_SUCCESS" and spellID == searchID then	
				return true
			end
		end
	end
	return false
end

function TrinketTracker:CheckDamage(destGUID, spellTimer)
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if damageEvents[eventType] then
				--log(timestamp.."  "..eventType.."  "..sourceGUID.."  "..sourceName.."  "..sourceFlags.."  "..destGUID.."  "..destName)
				return true
			end
		end
	end
	return false
end

function TrinketTracker:CheckPeriodicDamage(destGUID, spellTimer)
	for i=0, 10 do
		local spellTable = self.guids[destGUID][i]
		if not spellTable then return end
		local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,
		spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = self:TableToArgs(spellTable)
		-- buffer in case damage event is timestamped slightly after AURA_REMOVE
		if timestamp >= spellTimer.startTime and timestamp <= GetTime()+0.1 then
			if periodicDamageEvents[eventType] then
				--log(timestamp.."  "..eventType.."  "..sourceGUID.."  "..sourceName.."  "..sourceFlags.."  "..destGUID.."  "..destName)
				return true
			end
		end
	end
	return false
end

function TrinketTracker:CombatLogCache(guidTable, ...)
	if ... == nil then log("empty event") return end
	if not guidTable then return end
	
	if not guidTable.eventCount then
		guidTable.eventCount = 0
	else
		guidTable.eventCount = guidTable.eventCount + 1
	end
	local index = mod(guidTable.eventCount, 10)
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19 = select(1, ...)
	guidTable[index] = {  
		[0] = arg1, [1] =arg2, [2] =arg3, [3] =arg4, [4] =arg5, [5] =arg6, [6] =arg7, [7] =arg8, [8] =arg9, [9] =arg10, [10] =arg11, [11] =arg12,
		[12] =arg13, [13] =arg14, [14] =arg15, [15] =arg16, [16] =arg17, [17] =arg18, [18] =arg19, 
	}
end

function TrinketTracker:TableToArgs(spellTable)
	return spellTable[0], spellTable[1], spellTable[2], spellTable[3], spellTable[4],
	spellTable[5], spellTable[6], spellTable[7], spellTable[8], spellTable[9], spellTable[10],
	spellTable[11], spellTable[12], spellTable[13],	spellTable[14], spellTable[15], spellTable[16],
	spellTable[17], spellTable[18]
end

--could take this out eventually, I think
function TrinketTracker:CombatLogEventToTable(...)
	local timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags = select(1, ...)
	--overwrite timestamp -> need to check what happened between the time a timer was saved NOW, so events need a proper timestamp
	timestamp = GetTime()
	if eventType == "SWING_DAMAGE" then
		local _,_,_,_,_,_,_,_,amount,school,resisted,blocked,absorbed,glancing,crushing = select(1, ...)
		return timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags, amount,school,resisted,blocked,absorbed,glancing,crushing
	elseif eventType == "SPELL_DAMAGE" or eventType == "RANGE_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" then
		local _,_,_,_,_,_,_,_,spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing = select(1, ...)
		return timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool,amount,school,resisted,blocked,absorbed,glancing,crushing
	elseif eventType == "SPELL_DISPEL" then
		local _,_,_,_,_,_,_,_,spellID,spellName,spellSchool,extraSpellID,extraSpellName,extraSchool,auraType = select(1, ...)
		return timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool,extraSpellID, extraSpellName, extraSchool, auraType
	elseif eventType == "SPELL_DRAIN" or eventType == "SPELL_LEECH" or eventType == "SPELL_PERIODIC_DRAIN" or eventType == "SPELL_PERIODIC_LEECH" then
		local _,_,_,_,_,_,_,_,spellID,spellName,spellSchool,amount,powerType,extraAmount = select(1, ...)
		return timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool,amount,powerType,extraAmount
	elseif eventType == "SPELL_CAST_SUCCESS" then
		local _,_,_,_,_,_,_,_,spellID,spellName,spellSchool = select(1, ...)
		return timestamp,eventType,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool
	else
		-- only track combatlog events that actually matter
		return nil
	end
end

function TrinketTracker:COMBAT_LOG_EVENT_UNFILTERED(...)
	local timestamp, eventType, sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName,spellSchool,auraType = select ( 1 , ... );
	--log(eventType.."  "..spellName)
	if eventType == "SPELL_AURA_REMOVED" and self.abilities[spellName] and self.guids[destGUID] and self.guids[destGUID][spellName] then
		local spellTimer = self.guids[destGUID][spellName]
		local category = categories[self.abilities[spellName]]
		if GetTime()+0.1 < spellTimer.startTime+spellTimer.timeLeft then -- if expected spell duration-0.1 was not reached when SPELL_AURA_REMOVED was fired do
			self:CheckTrinket(category, destGUID, destName, spellTimer, spellName)
		end
	end
	-- save last 10 combatlog events 
	if self.guids and (self.guids[destGUID] or self.guids[sourceGUID]) and logEvents[eventType] then
		if eventType == "SPELL_CAST_SUCCESS" and not immunityIDs[spellID] then return end
		-- sometimes SPELL_CAST_SUCCESS only has a sourceGUID, no destGUID. Unlike SPELL_AURA_APPLIED it's also fired before SPELL_AURA_REMOVE
		if eventType == "SPELL_CAST_SUCCESS" then
			if destGUID == nil then
				self:CombatLogCache(self.guids[sourceGUID], self:CombatLogEventToTable(...))
			else
				self:CombatLogCache(self.guids[destGUID], self:CombatLogEventToTable(...))
			end
		else
			self:CombatLogCache(self.guids[destGUID], self:CombatLogEventToTable(...))
		end
		
	end
	
end