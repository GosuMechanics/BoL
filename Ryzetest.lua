if myHero.charName ~= "Ryze" then return end

	require 'SimpleLib'

local qRange
local eRange
local wRange
local rRange
local JungleMinions
local EnemyMinions
local JungleFarmMinions
local UsingPot = false
local lastRemove = 0

local GapCloserList = {
	{charName = "Aatrox", spellName = "AatroxQ", name = "Q"},
	{charName = "Akali", spellName = "AkaliShadowDance", name = "R"},
	{charName = "Alistar", spellName = "Headbutt", name = "W"},
	{charName = "Amumu", spellName = "BandageToss", name = "Q"},
	{charName = "Fiora", spellName = "FioraQ", name = "Q"},
	{charName = "Diana", spellName = "DianaTeleport", name = "W"},
	{charName = "Elise", spellName = "EliseSpiderQCast", name = "W"},
	{charName = "FiddleSticks", spellName = "Crowstorm", name = "R"},
	{charName = "Fizz", spellName = "FizzPiercingStrike", name = "Q"},
	{charName = "Gragas", spellName = "GragasE", name = "E"},
	{charName = "Hecarim", spellName = "HecarimUlt", name = "R"},
	{charName = "JarvanIV", spellName = "JarvanIVDragonStrike", name = "E"},
	{charName = "Irelia", spellName = "IreliaGatotsu", name = "Q"},
	{charName = "Jax", spellName = "JaxLeapStrike", name = "Q"},
	{charName = "Katarina", spellName = "ShadowStep", name = "E"},
	{charName = "Kassadin", spellName = "RiftWalk", name = "R"},
	{charName = "Khazix", spellName = "KhazixE", name = "E"},
	{charName = "Khazix", spellName = "khazixelong", name = "Evolved E"},
	{charName = "LeBlanc", spellName = "LeblancSlide", name = "W"},
	{charName = "LeBlanc", spellName = "LeblancSlideM", name = "UltW"},
	{charName = "LeeSin", spellName = "BlindMonkQTwo", name = "Q"},
	{charName = "Leona", spellName = "LeonaZenithBlade", name = "E"},
	{charName = "Malphite", spellName = "UFSlash", name = "R"},
	{charName = "Nautilus", spellName = "NautilusAnchorDrag", name = "Q"},
	{charName = "Pantheon", spellName = "Pantheon_LeapBash", name = "R"},
	{charName = "Poppy", spellName = "PoppyHeroicCharge", name = "W"},
	{charName = "Renekton", spellName = "RenektonSliceAndDice", name = "E"},
	{charName = "Riven", spellName = "RivenTriCleave", name = "E"},
	{charName = "Sejuani", spellName = "SejuaniArcticAssault", name = "E"},
	{charName = "Shen", spellName = "ShenShadowDash", name = "E"},
	{charName = "Tristana", spellName = "RocketJump", name = "W"},
	{charName = "Tryndamere", spellName = "slashCast", name = "E"},
	{charName = "Vi", spellName = "ViQ", name = "Q"},
	{charName = "MonkeyKing", spellName = "MonkeyKingNimbus", name = "Q"},
	{charName = "XinZhao", spellName = "XenZhaoSweep", name = "Q"},
	{charName = "Yasuo", spellName = "YasuoDashWrapper", name = "E"},
}


function OnLoad()

	print("<b><font color=\"#6699FF\">Ryze:</font></b> <font color=\"#FFFFFF\">Sucessfully loaded!</font>")
	Variables()
	Menu()

	QSpellQ = _Spell({Slot = _Q, DamageName = "Q", Range = 900, Width = 55, Delay = 0.25, Speed = math.huge, Collision = true, Aoe = false, Type = SPELL_TYPE.LINEAR}):AddDraw()
    QSpellW = _Spell({Slot = _W, DamageName = "W", Range = 600, Delay = 0.25, Speed = math.huge, Collision = false, Aoe = false, Type = SPELL_TYPE.TARGETTED}):AddDraw()
    QSpellE = _Spell({Slot = _E, DamageName = "E", Range = 400, Delay = 0.25, Speed = math.huge, Collision = false, Aoe = true, Type = SPELL_TYPE.TARGETTED}):AddDraw()

end

function OnTick()

	Combokey = Config.SMsbtw.sbtw
	Harasskey = Config.SMharass.qflee
	LastHitkey = Config.SMsmart.smartfarm
	JungleClearkey = Config.SMfarm.farm
	LaneClearkey = Config.SMfarm.farm

	if Config.SMother.usePots then
        AutoPots()
	elseif Config.SMother.killsteal then
		AutoIgnite()
	elseif Combokey then
		Combo(Target)
	end

	Checks()

end

function Checks()
		QREADY = (myHero:CanUseSpell(_Q) == READY)
        EREADY = (myHero:CanUseSpell(_E) == READY)
        WREADY = (myHero:CanUseSpell(_W) == READY)
        RREADY = (myHero:CanUseSpell(_R) == READY)
        IREADY = (igniteSpell ~= nil and myHero:CanUseSpell(igniteSpell) == READY)

	GetItemSlot()

    Target = ts.target
    
    ts:update()

end

function Menu()

	Config = scriptConfig("Gosu Mechanics", "Ryze")
	Config:addSubMenu("Combo Options", "SMsbtw")
    Config:addSubMenu("Harass Options", "SMharass")
    Config:addSubMenu("Last Hit Options", "SMsmart")
    Config:addSubMenu("Farm Options", "SMfarm")
    Config:addSubMenu("Other Options", "SMother")
    --Config:addSubMenu("Drawing Options", "SMdraw")

    Config.SMsbtw:addDynamicParam("sbtw", "Beast Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
    Config.SMharass:addDynamicParam("qflee", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
    Config.SMsmart:addDynamicParam("smartfarm", "Smart Last Hit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
    Config.SMfarm:addDynamicParam("farm", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
    --Config:addParam("isPressed", "debug", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
    --Config.SMharass:addParam("autoQ", "Auto-Q", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("S"))
    Config.SMsmart:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMsmart:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMsmart:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

	Config.SMharass:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMharass:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMharass:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMharass:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
    --Config.SMfarm:addParam("useOldLC", "Use old Lane Clear", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)

    --Config.SMsbtw:addParam("useOrb", "Use Orbwalking", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("combomode", "Combo Mode", SCRIPT_PARAM_LIST, 1, {"R>Q>W>E", "R>W>Q>E"})
    --Config.SMsbtw:addParam("useitems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
  
    Config.SMother:addParam("usePackets", "Use Packets", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("killsteal", "Killsteal", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("ignite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("autoW", "Auto-W", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("autoPot", "Auto-Pots", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("usePots", "use when at % hp", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
    Config.SMother:addParam("useqss", "Auto-QSS", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("delay", "Activation delay", SCRIPT_PARAM_SLICE, 0, 0, 250, 0)
    --Config:addParam("dodge", "E-vade Test", SCRIPT_PARAM_ONOFF, true)

    --OrbwalkManager:LoadCommonKeys(Config.Keys)
    
		Config.SMother:addSubMenu("GapCloser Spells", "ES2")
			for i, enemy in ipairs(GetEnemyHeroes()) do
				for _, champ in pairs(GapCloserList) do
					if enemy.charName == champ.charName then
						Config.SMother.ES2:addParam(champ.spellName, "GapCloser "..champ.charName.." "..champ.name, SCRIPT_PARAM_ONOFF, true)
					end
				end
			end

    Config.SMother:permaShow("usePackets")
    Config.SMother:permaShow("ignite")
    Config.SMother:permaShow("useqss")

	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, rRange, DAMAGE_MAGIC, true)
	ts.name = "Gosu"
	Config:addTS(ts)

end

function CastQ(unit)
	if unit ~= nil and GetDistance(unit) <= qRange then
		if VIP_USER and Config.SMother.usePackets then
			 Packet("S_CAST", {spellId = _Q, toX=CastPosition.x, toY=CastPosition.z, fromX=CastPosition.x, fromY=CastPosition.z}):send()   
		else
			QSpellQ:Cast(unit)
		end
	end
end

function CastW(unit)
	if unit ~= nil and GetDistance(unit) <= wRange then
		if VIP_USER and Config.SMother.usePackets then
			Packet("S_CAST", {spellId = _W, targetNetworkId = unit.networkID}):send()
		else
			QSpellW:Cast(unit)
		end
	end
end

function CastE(unit)
	if unit ~= nil and GetDistance(unit) <= eRange then
		if VIP_USER and Config.SMother.usePackets then
			Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
		else
			QSpellE:Cast(unit)
		end
	end
end

function Combo(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if Config.SMother.useitems then
			UseItems(unit)
		end
		if Config.SMother.combomode == 1 then
			if Config.SMsbtw.useQ and QREADY then
				CastQ(unit)
			end
			if Config.SMsbtw.useR and RREADY and not QREADY then
				CastSpell(_R)
			end
			if Config.SMsbtw.useW and WREADY then
				CastW(unit)
			end
			if Config.SMsbtw.useE and EREADY and not QREADY then
				CastE(unit)
				end
			end
		if Config.SMother.combomode == 2 then
			if Config.SMsbtw.useW and WREADY then
				CastW(unit)
			end
			if Config.SMsbtw.useQ and QREADY then
				CastQ(unit)
			end
			if Config.SMsbtw.useR and RREADY and not QREADY then
				CastSpell(_R)
			end
			if Config.SMsbtw.useQ and EREADY and not QREADY then
				CastE(unit)
			end
		end
	end
end

function KillSteal()
	for _, enemy in ipairs(GetEnemyHeroes()) do	
		local iDmg = (50 + (20 * myHero.level))
		local qDmg = getDmg("Q", enemy, myHero)
		local wDmg = getDmg("W", enemy, myHero)
		local eDmg = getDmg("E", enemy, myHero)
		
		if enemy ~= nil and ValidTarget(enemy, 650) then
			if enemy.health <= qDmg and ValidTarget(enemy, qRange) and QREADY then
				CastQ(enemy)
			elseif enemy.health <= wDmg and ValidTarget(enemy, wRange) and WREADY then
				CastW(enemy)
			elseif enemy.health <= eDmg and ValidTarget(enemy, eRange) and EREADY then
				CastE(enemy)
			elseif enemy.health <= (qDmg + wDmg) and ValidTarget(enemy, wRange) and WREADY and QREADY then
				CastW(enemy)
				CastQ(enemy)
			elseif enemy.health <= (qDmg + eDmg) and ValidTarget(enemy, eReady) and EREADY and QREADY then
				CastE(enemy)
				CastQ(enemy)
			elseif enemy.health <= (wDmg + eDmg) and ValidTarget(enemy, wRange) and WREADY and EREADY then
				CastW(enemy)
				CastE(enemy)
			elseif enemy.health <= (qDmg + wDmg + eDmg) and ValidTarget(enemy, wRange) and QREADY and WREADY and EREADY then
				CastW(enemy)
				CastQ(enemy)
				CastE(enemy)
			elseif enemy.health <= (qDmg + iDmg) and ValidTarget(enemy, Qrange) and Qready and IREADY then
				CastQ(enemy)
				CastSpell(Ignite, enemy)
			elseif enemy.health <= (wDmg + iDmg) and ValidTarget(enemy, Wrange) and Wready and IREADY then
				CastW(enemy)
				CastSpell(Ignite, enemy)
			elseif enemy.health <= (eDmg + iDmg) and ValidTarget(enemy, Erange) and Eready and IREADY then
				CastE(enemy)
				CastSpell(Ignite, enemy)
			elseif enemy.health <= (qDmg + wDmg + iDmg) and ValidTarget(enemy, wRange) and QREADY and WREADY and IREADY then
				CastW(enemy)
				CastQ(enemy)
				CastSpell(Ignite, enemy)
			elseif enemy.health <= (qDmg + eDmg + iDmg) and ValidTarget(enemy, eRange) and QREADY and EREADY and IREADY then
				CastQ(enemy)
				CastE(enemy)
				CastSpell(Ignite, enemy)
			elseif enemy.health <= (wDmg + eDmg + iDmg) and ValidTarget(enemy, wRange) and Wready and EREADY and IREADY then
				CastW(enemy)
				CastE(enemy)
				CastSpell(Ignite, enemy)
			elseif enemy.health <= (qDmg + wDmg + eDmg + iDmg) and ValidTarget(enemy, wRange) and QREADY and WREADY and EREADY and IREADY then
				CastW(enemy)
				CastQ(enemy)
				CastE(enemy)
				CastSpell(Ignite, enemy)
			end
		end
	end
end

function AutoIgnite()
    if Config.SMother.ignite and ignite ~= nil and CanCast(ignite) then
        local igniteDamage = 50 + 20 * myHero.level
    for i = 1, heroManager.iCount, 1 do
      local target = heroManager:getHero(i)
      if ValidTarget(target, 600) and target.team ~= myHero.team then
        if igniteDamage > (target.health - 25) then
          CastSpell(ignite, target)
        end
      end
    end
  end
end

function CanCast(spell)
return myHero:CanUseSpell(spell) == READY
end

function OnProcessSpell(unit, spell)
	if Config.SMother.autoW and WREADY then
		for _, x in pairs(GapCloserList) do
			if unit and unit.team ~= myHero.team and unit.type == myHero.type and spell then
				if spell.name == x.spellName and Config.SMother.ES2[x.spellName] and ValidTarget(unit, wRange) then
					if spell.target and spell.target.isMe then
						CastW(unit)
					elseif not spell.target then
						local endPos1 = Vector(unit.visionPos) + 300 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
						local endPos2 = Vector(unit.visionPos) + 100 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
						if (GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos1) or GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos2))  then
							CastW(unit)
						end
					end
				end
			end
		end
	end
end

function OnApplyBuff(source, unit, buff)

	if buff and unit == myHero then print(buff.name) end

    if not unit or not buff then return end
        if unit and unit.isMe and buff.name == "RegenerationPotion" then
            UsingPot = true
        end
    if unit.isMe and Config.SMother.useqss then
        if buff.name and buff.type == 5 or buff.type == 12 or buff.type == 11 or buff.type == 25 or buff.type == 7 or buff.type == 22 or buff.type == 21 or buff.type == 8
        or (buff.type == 10 and buff.name and buff.name:lower():find("fleeslow"))
        or (buff.name:lower():find("summonerexhaust")) then
            if buff.name and buff.name:lower():find("caitlynyor") and CountEnemiesNearUnitReg(myHero, 700) == 0   then
                return false
            elseif not buff.name:lower():find("rocketgrab2") then
                UseQSS(myHero, true)
            end          
        end                    
    end 
end

function OnRemoveBuff(unit, buff)
    if not unit or not buff or unit.type ~= myHero.type then return end
        if unit and unit.isMe and buff.name == "RegenerationPotion" then
            UsingPot = false
    end
end

function lowHp(unit)
    if unit.health <= (Config.SMother.usePots/100*myHero.maxHealth) then
        return true
    else
        return false
    end
end

function AutoPots()
    if REGPOT and CanCast(REGPOT) and lowHp(myHero) and not UsingPot and not IsRecalling then 
        CastSpell(REGPOT) 
    end
end

function GetItemSlot()
    for slot = ITEM_1, ITEM_7 do
        local currentItemName = myHero:GetSpellData(slot).name
        if currentItemName == "RegenerationPotion" then
            REGPOT = slot
        end
    end
end

--[[function Items()
    if Config.sbtw and Config.SMsbtw.useitems and ValidTarget(Target) then
        if Hydra and CanCast(Hydra) and GetDistance(Target) <= 200 then CastSpell(Hydra) end
        if BORK and CanCast(BORK) then CastSpell(BORK, Target) end
        if Ghostblade and CanCast(Ghostblade) then CastSpell(Ghostblade) end
        if RAMEN and CanCast(RAMEN) and GetDistance(Target) <= 400 then CastSpell(RAMEN) end
    end 
end]]

function UseQSS(unit, scary)
    if lastRemove > os.clock() - 1 then return end
    for i, Item in pairs(Items) do
        local Item = Items[i]
        if GetInventoryItemIsCastable(Item.id) and GetDistanceSqr(unit) <= Item.range * Item.range then
            if Item.id == 3139 or Item.id ==  3140 then
                if scary then
                    DelayAction(function()
                        CastItem(Item.id)
                    end, Config.SMother.delay/1000)    
                    lastRemove = os.clock()
                    return true
                end
            end
        end
    end
end

function UseItems(unit, scary)
    if not ValidTarget(unit) and unit ~= myHero then return end
    for i, Item in pairs(Items) do
        local Item = Items[i]
        if Item.id ~= 3140 and Item.id ~= 3139 then
            if GetInventoryItemIsCastable(Item.id) and GetDistanceSqr(unit) <= Item.range * Item.range then
                if Item.id == 3143 or Item.id == 3077 or Item.id == 3074 or Item.id == 3131 or Item.id == 3142 or Item.id == 2140 then
                    CastItem(Item.id)
                else
                    CastItem(Item.id, unit) return true
                end
            end
        end
    end
end

function GetSlotItemFromName(itemname)
    local slot
    for i = 6, 12 do
        local item = myHero:GetSpellData(i).name
        if ((#item > 0) and (item:lower() == itemname:lower())) then
            slot = i
        end
    end
    return slot
end

function GetSlotItem(id, unit)
    unit = unit or myHero

    if (not ItemNames[id]) then
        return ___GetInventorySlotItem(id, unit)
    end

    local name  = ItemNames[id]
    
    for slot = ITEM_1, ITEM_7 do
        local item = unit:GetSpellData(slot).name
        if ((#item > 0) and (item:lower() == name:lower())) then
            return slot
        end
    end
end

function Variables()

	qRange = 900
    wRange = 600
    eRange = 400
    rRange = 200

	enemyMinions = minionManager(MINION_ENEMY, qRange, myHero, MINION_SORT_HEALTH_ASC)
	
	VP = VPrediction()
	
	JungleMobs = {}
	JungleFocusMobs = {}
	
	if GetGame().map.shortName == "twistedTreeline" then
		TwistedTreeline = true 
	else
		TwistedTreeline = false
	end
	
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
	
	priorityTable = {
			AP = {
				"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
				"Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
				"Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"
			},
			
			Support = {
				"Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"
			},
			
			Tank = {
				"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear",
				"Warwick", "Yorick", "Zac"
			},
			
			AD_Carry = {
				"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
				"Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"
			},
			
			Bruiser = {
				"Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy",
				"Renekton", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"
			}
	}

	Items = {
		BRK = { id = 3153, range = 450, reqTarget = true, slot = nil },
		BWC = { id = 3144, range = 400, reqTarget = true, slot = nil },
		DFG = { id = 3128, range = 750, reqTarget = true, slot = nil },
		HGB = { id = 3146, range = 400, reqTarget = true, slot = nil },
		RSH = { id = 3074, range = 350, reqTarget = false, slot = nil },
		STD = { id = 3131, range = 350, reqTarget = false, slot = nil },
		TMT = { id = 3077, range = 350, reqTarget = false, slot = nil },
		YGB = { id = 3142, range = 350, reqTarget = false, slot = nil },
		BFT = { id = 3188, range = 750, reqTarget = true, slot = nil },
		RND = { id = 3143, range = 275, reqTarget = false, slot = nil }
	}
	
	if not TwistedTreeline then
		JungleMobNames = { 
			["SRU_MurkwolfMini2.1.3"]	= true,
			["SRU_MurkwolfMini2.1.2"]	= true,
			["SRU_MurkwolfMini8.1.3"]	= true,
			["SRU_MurkwolfMini8.1.2"]	= true,
			["SRU_BlueMini1.1.2"]		= true,
			["SRU_BlueMini7.1.2"]		= true,
			["SRU_BlueMini21.1.3"]		= true,
			["SRU_BlueMini27.1.3"]		= true,
			["SRU_RedMini10.1.2"]		= true,
			["SRU_RedMini10.1.3"]		= true,
			["SRU_RedMini4.1.2"]		= true,
			["SRU_RedMini4.1.3"]		= true,
			["SRU_KrugMini11.1.1"]		= true,
			["SRU_KrugMini5.1.1"]		= true,
			["SRU_RazorbeakMini9.1.2"]	= true,
			["SRU_RazorbeakMini9.1.3"]	= true,
			["SRU_RazorbeakMini9.1.4"]	= true,
			["SRU_RazorbeakMini3.1.2"]	= true,
			["SRU_RazorbeakMini3.1.3"]	= true,
			["SRU_RazorbeakMini3.1.4"]	= true
		}
		
		FocusJungleNames = {
			["SRU_Blue1.1.1"]			= true,
			["SRU_Blue7.1.1"]			= true,
			["SRU_Murkwolf2.1.1"]		= true,
			["SRU_Murkwolf8.1.1"]		= true,
			["SRU_Gromp13.1.1"]			= true,
			["SRU_Gromp14.1.1"]			= true,
			["Sru_Crab16.1.1"]			= true,
			["Sru_Crab15.1.1"]			= true,
			["SRU_Red10.1.1"]			= true,
			["SRU_Red4.1.1"]			= true,
			["SRU_Krug11.1.2"]			= true,
			["SRU_Krug5.1.2"]			= true,
			["SRU_Razorbeak9.1.1"]		= true,
			["SRU_Razorbeak3.1.1"]		= true,
			["SRU_Dragon6.1.1"]			= true,
			["SRU_Baron12.1.1"]			= true
		}
	else
		FocusJungleNames = {
			["TT_NWraith1.1.1"]			= true,
			["TT_NGolem2.1.1"]			= true,
			["TT_NWolf3.1.1"]			= true,
			["TT_NWraith4.1.1"]			= true,
			["TT_NGolem5.1.1"]			= true,
			["TT_NWolf6.1.1"]			= true,
			["TT_Spiderboss8.1.1"]		= true
		}		
		JungleMobNames = {
			["TT_NWraith21.1.2"]		= true,
			["TT_NWraith21.1.3"]		= true,
			["TT_NGolem22.1.2"]			= true,
			["TT_NWolf23.1.2"]			= true,
			["TT_NWolf23.1.3"]			= true,
			["TT_NWraith24.1.2"]		= true,
			["TT_NWraith24.1.3"]		= true,
			["TT_NGolem25.1.1"]			= true,
			["TT_NWolf26.1.2"]			= true,
			["TT_NWolf26.1.3"]			= true
		}
	end
	
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object and object.valid and not object.dead then
			if FocusJungleNames[object.name] then
				JungleFocusMobs[#JungleFocusMobs+1] = object
			elseif JungleMobNames[object.name] then
				JungleMobs[#JungleMobs+1] = object
			end
		end
	end
end

function SetPriority(table, hero, priority)
	for i=1, #table, 1 do
		if hero.charName:find(table[i]) ~= nil then
			TS_SetHeroPriority(priority, hero.charName)
		end
	end
end
 
function arrangePrioritys()
        for i, enemy in ipairs(GetEnemyHeroes()) do
		SetPriority(priorityTable.AD_Carry, enemy, 1)
		SetPriority(priorityTable.AP,       enemy, 2)
		SetPriority(priorityTable.Support,  enemy, 3)
		SetPriority(priorityTable.Bruiser,  enemy, 4)
		SetPriority(priorityTable.Tank,     enemy, 5)
        end
end

function arrangePrioritysTT()
        for i, enemy in ipairs(GetEnemyHeroes()) do
		SetPriority(priorityTable.AD_Carry, enemy, 1)
		SetPriority(priorityTable.AP,       enemy, 1)
		SetPriority(priorityTable.Support,  enemy, 2)
		SetPriority(priorityTable.Bruiser,  enemy, 2)
		SetPriority(priorityTable.Tank,     enemy, 3)
        end
end

function getHitBoxRadius(target)
    return GetDistance(target.minBBox, target.maxBBox)/2
end

function PriorityOnLoad()
	if heroManager.iCount < 10 or (TwistedTreeline and heroManager.iCount < 6) then
		print("<b><font color=\"#6699FF\"Ryze:</font></b> <font color=\"#FFFFFF\">Too few champions to arrange priority.</font>")
	elseif heroManager.iCount == 6 then
		arrangePrioritysTT()
    else
		arrangePrioritys()
	end
end

function GetJungleMob()
	for _, Mob in pairs(JungleFocusMobs) do
		if ValidTarget(Mob, qRange) then return Mob end
	end
	for _, Mob in pairs(JungleMobs) do
		if ValidTarget(Mob, qRange) then return Mob end
	end
end

function OnCreateObj(obj)
	if obj.valid then
		if FocusJungleNames[obj.name] then
			JungleFocusMobs[#JungleFocusMobs+1] = obj
		elseif JungleMobNames[obj.name] then
			JungleMobs[#JungleMobs+1] = obj
		end
	end
end

function OnDeleteObj(obj)
	for i, Mob in pairs(JungleMobs) do
		if obj.name == Mob.name then
			table.remove(JungleMobs, i)
		end
	end
	for i, Mob in pairs(JungleFocusMobs) do
		if obj.name == Mob.name then
			table.remove(JungleFocusMobs, i)
		end
	end
end
