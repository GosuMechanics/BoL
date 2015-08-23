if myHero.charName ~= "Cassiopeia" then return end

require 'SxOrbwalk'
require 'VPrediction'
require 'HPrediction'
require 'SPrediction'

if _G.BuffFix then
_G.BUFF_NONE = 0
_G.BUFF_GLOBAL = 1
_G.BUFF_BASIC = 2
_G.BUFF_DEBUFF = 3
_G.BUFF_STUN = 5
_G.BUFF_STEALTH = 6
_G.BUFF_SILENCE = 7
_G.BUFF_TAUNT = 8
_G.BUFF_SLOW = 10
_G.BUFF_ROOT = 11
_G.BUFF_DOT = 12
_G.BUFF_REGENERATION = 13
_G.BUFF_SPEED = 14
_G.BUFF_MAGIC_IMMUNE = 15
_G.BUFF_PHYSICAL_IMMUNE = 16
_G.BUFF_IMMUNE = 17
_G.BUFF_Vision_Reduce = 19
_G.BUFF_FEAR = 21
_G.BUFF_CHARM = 22
_G.BUFF_POISON = 23
_G.BUFF_SUPPRESS = 24
_G.BUFF_BLIND = 25
_G.BUFF_STATS_INCREASE = 26
_G.BUFF_STATS_DECREASE = 27
_G.BUFF_FLEE = 28
_G.BUFF_KNOCKUP = 29
_G.BUFF_KNOCKBACK = 30
_G.BUFF_DISARM = 31
    class 'BuffManager'
    
    AdvancedCallback:register('OnApplyBuff', 'OnRemoveBuff')
    
    function BuffManager:__init()
        self.heroes = {}
        self.buffs  = {}
        for i = 1, heroManager.iCount do
            local hero = heroManager:GetHero(i)
            table.insert(self.heroes, hero)
            self.buffs[hero.networkID] = {}
        end
        AddTickCallback(function () self:Tick() end)
    end

    function BuffManager:Tick()
        for i, hero in ipairs(self.heroes) do
            for i = 1, hero.buffCount do
                local buff = hero:getBuff(i)
                if self:Valid(buff) then
                    local info = {unit = hero, buff = buff, slot = i, sent = false, sent2 = false}
                    if not self.buffs[hero.networkID][info.buff.name] then
                        self.buffs[hero.networkID][info.buff.name] = info
                    end
                end
            end
        end
        for nid, table in pairs(self.buffs) do
            for i, buffs in pairs(table) do
                local buff = buffs.buff
                if self:Valid(buff) and not buffs.sent then
                    local buffinfo = {name = buff.name:lower(), slot = buff.slot, duration = (buff.endT - buff.startT), startTime = buff.startT, endTime  = buff.endT, stacks = 1, type = buff.type}
                    AdvancedCallback:OnApplyBuff(buffs.source, buffs.unit, buffinfo)
                    buffs.sent = true
                elseif not self:Valid(buff) and not buffs.sent2 then
                    local buffinfo = {name = buff.name:lower(), slot = buff.slot, duration = (buff.endT - buff.startT), startTime = buff.startT, endTime = buff.endT, stacks = 0, type = buff.type}
                    AdvancedCallback:OnRemoveBuff(buffs.unit, buffinfo)
                    self.buffs[buffs.unit.networkID][buff.name] = nil
                    buffs.sent2 = true
                end
            end
        end
    end

    function BuffManager:Valid(buff)
        return buff and buff.name and buff.startT <= GetGameTimer() and buff.endT >= GetGameTimer()
    end

    function BuffManager:HasBuff(unit, buffname)
        return self.buffs[unit.networkID][buffname]:lower() ~= nil
    end
    ----------------------------
    Buffs = BuffManager()
end
-----------------------------------

local JungleMinions
local enemyMinions
local UsingPot = false
local UsungMpot = false
local lastRemove = 0
local i
local VP = nil

--[[local GapCloserList = {
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
}]]

Interrupt = {
    ["Katarina"] = {charName = "Katarina", stop = {["KatarinaR"] = {name = "Death lotus", spellName = "KatarinaR", ult = true }}},
    ["Nunu"] = {charName = "Nunu", stop = {["AbsoluteZero"] = {name = "Absolute Zero", spellName = "AbsoluteZero", ult = true }}},
    ["Malzahar"] = {charName = "Malzahar", stop = {["AlZaharNetherGrasp"] = {name = "Nether Grasp", spellName = "AlZaharNetherGrasp", ult = true}}},
    ["Caitlyn"] = {charName = "Caitlyn", stop = {["CaitlynAceintheHole"] = {name = "Ace in the hole", spellName = "CaitlynAceintheHole", ult = true, projectileName = "caitlyn_ult_mis.troy"}}},
    ["FiddleSticks"] = {charName = "FiddleSticks", stop = {["Crowstorm"] = {name = "Crowstorm", spellName = "Crowstorm", ult = true}}},
    ["Galio"] = {charName = "Galio", stop = {["GalioIdolOfDurand"] = {name = "Idole of Durand", spellName = "GalioIdolOfDurand", ult = true}}},
    ["Janna"] = {charName = "Janna", stop = {["ReapTheWhirlwind"] = {name = "Monsoon", spellName = "ReapTheWhirlwind", ult = true}}},
    ["MissFortune"] = {charName = "MissFortune", stop = {["MissFortune"] = {name = "Bullet time", spellName = "MissFortuneBulletTime", ult = true}}},
    ["MasterYi"] = {charName = "MasterYi", stop = {["MasterYi"] = {name = "Meditate", spellName = "Meditate", ult = false}}},
    ["Pantheon"] = {charName = "Pantheon", stop = {["PantheonRJump"] = {name = "Skyfall", spellName = "PantheonRJump", ult = true}}},
    ["Shen"] = {charName = "Shen", stop = {["ShenStandUnited"] = {name = "Stand united", spellName = "ShenStandUnited", ult = true}}},
    ["Urgot"] = {charName = "Urgot", stop = {["UrgotSwap2"] = {name = "Position Reverser", spellName = "UrgotSwap2", ult = true}}},
    ["Varus"] = {charName = "Varus", stop = {["VarusQ"] = {name = "Piercing Arrow", spellName = "Varus", ult = false}}},
    ["Warwick"] = {charName = "Warwick", stop = {["InfiniteDuress"] = {name = "Infinite Duress", spellName = "InfiniteDuress", ult = true}}},
}

isAGapcloserUnit = {
    ['Ahri']        = {true, spell = _R,                  range = 450,   projSpeed = 2200, },
    ['Aatrox']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1200, },
    ['Akali']       = {true, spell = _R,                  range = 800,   projSpeed = 2200, },
    ['Alistar']     = {true, spell = _W,                  range = 650,   projSpeed = 2000, },
    ['Amumu']       = {true, spell = _Q,                  range = 1100,  projSpeed = 1800, },
    ['Corki']       = {true, spell = _W,                  range = 800,   projSpeed = 650,  },
    ['Diana']       = {true, spell = _R,                  range = 825,   projSpeed = 2000, },
    ['Darius']      = {true, spell = _R,                  range = 460,   projSpeed = math.huge, },
    ['Fiora']       = {true, spell = _Q,                  range = 600,   projSpeed = 2000, },
    ['Fizz']        = {true, spell = _Q,                  range = 550,   projSpeed = 2000, },
    ['Gragas']      = {true, spell = _E,                  range = 600,   projSpeed = 2000, },
    ['Graves']      = {true, spell = _E,                  range = 425,   projSpeed = 2000, exeption = true },
    ['Hecarim']     = {true, spell = _R,                  range = 1000,  projSpeed = 1200, },
    ['Irelia']      = {true, spell = _Q,                  range = 650,   projSpeed = 2200, },
    ['JarvanIV']    = {true, spell = _Q,                  range = 770,   projSpeed = 2000, },
    ['Jax']         = {true, spell = _Q,                  range = 700,   projSpeed = 2000, },
    ['Jayce']       = {true, spell = 'JayceToTheSkies',   range = 600,   projSpeed = 2000, },
    ['Khazix']      = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
    ['Leblanc']     = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
    --['LeeSin']      = {true, spell = 'blindmonkqtwo',     range = 1300,  projSpeed = 1800, },
    ['Leona']       = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
    ['Lucian']      = {true, spell = _E,                  range = 425,   projSpeed = 2000, },
    ['Malphite']    = {true, spell = _R,                  range = 1000,  projSpeed = 1500, },
    ['Maokai']      = {true, spell = _W,                  range = 525,   projSpeed = 2000, },
    ['MonkeyKing']  = {true, spell = _E,                  range = 650,   projSpeed = 2200, },
    ['Pantheon']    = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
    ['Poppy']       = {true, spell = _E,                  range = 525,   projSpeed = 2000, },
    ['Riven']       = {true, spell = _E,                  range = 150,   projSpeed = 2000, },
    ['Renekton']    = {true, spell = _E,                  range = 450,   projSpeed = 2000, },
    ['Sejuani']     = {true, spell = _Q,                  range = 650,   projSpeed = 2000, },
    ['Shen']        = {true, spell = _E,                  range = 575,   projSpeed = 2000, },
    ['Shyvana']     = {true, spell = _R,                  range = 1000,  projSpeed = 2000, },
    ['Tristana']    = {true, spell = _W,                  range = 900,   projSpeed = 2000, },
    ['Tryndamere']  = {true, spell = 'Slash',             range = 650,   projSpeed = 1450, },
    ['XinZhao']     = {true, spell = _E,                  range = 650,   projSpeed = 2000, },
    ['Yasuo']       = {true, spell = _E,                  range = 475,   projSpeed = 1000, },
    ['Vayne']       = {true, spell = _Q,                  range = 300,   projSpeed = 1000, },
}

function OnLoad()
    print("<b><font color=\"#6699FF\">GosuMechanics:</font></b> <font color=\"#FFFFFF\">Cassiopeia</font>")
    Variables()
    Menu()
    PriorityOnLoad()

    HP_Q = HPSkillshot({type = "DelayCircle", delay = 0.5, range = 850, radius = 100, speed = 1000})
    HP_W = HPSkillshot({type = "DelayCircle", delay = 1, range = 925, radius = 100, speed = 1000})

    ItemNames               = {
        [3303]              = "ArchAngelsDummySpell",
        [3007]              = "ArchAngelsDummySpell",
        [3144]              = "BilgewaterCutlass",
        [3188]              = "ItemBlackfireTorch",
        [3153]              = "ItemSwordOfFeastAndFamine",
        [3405]              = "TrinketSweeperLvl1",
        [3411]              = "TrinketOrbLvl1",
        [3166]              = "TrinketTotemLvl1",
        [3450]              = "OdinTrinketRevive",
        --[2041]                = "ItemCrystalFlask",
        [2054]              = "ItemKingPoroSnack",
        [2138]              = "ElixirOfIron",
        [2137]              = "ElixirOfRuin",
        [2139]              = "ElixirOfSorcery",
        [2140]              = "ElixirOfWrath",
        [3184]              = "OdinEntropicClaymore",
        [2050]              = "ItemMiniWard",
        [3401]              = "HealthBomb",
        [3363]              = "TrinketOrbLvl3",
        [3092]              = "ItemGlacialSpikeCast",
        [3460]              = "AscWarp",
        [3361]              = "TrinketTotemLvl3",
        [3362]              = "TrinketTotemLvl4",
        [3159]              = "HextechSweeper",
        [2051]              = "ItemHorn",
        [2003]              = "RegenerationPotion",
        [3146]              = "HextechGunblade",
        [3187]              = "HextechSweeper",
        [3190]              = "IronStylus",
        [2004]              = "FlaskOfCrystalWater",
        [3139]              = "ItemMercurial",
        [3222]              = "ItemMorellosBane",
        [3042]              = "Muramana",
        [3043]              = "Muramana",
        [3180]              = "OdynsVeil",
        [3056]              = "ItemFaithShaker",
        [2047]              = "OracleExtractSight",
        [3364]              = "TrinketSweeperLvl3",
        [2052]              = "ItemPoroSnack",
        [3140]              = "QuicksilverSash",
        [3143]              = "RanduinsOmen",
        [3074]              = "ItemTiamatCleave",
        [3800]              = "ItemRighteousGlory",
        [2045]              = "ItemGhostWard",
        [3342]              = "TrinketOrbLvl1",
        [3040]              = "ItemSeraphsEmbrace",
        [3048]              = "ItemSeraphsEmbrace",
        [2049]              = "ItemGhostWard",
        [3345]              = "OdinTrinketRevive",
        [2044]              = "SightWard",
        [3341]              = "TrinketSweeperLvl1",
        [3069]              = "shurelyascrest",
        [3599]              = "KalistaPSpellCast",
        [3185]              = "HextechSweeper",
        [3077]              = "ItemTiamatCleave",
        [2009]              = "ItemMiniRegenPotion",
        [2010]              = "ItemMiniRegenPotion",
        [3023]              = "ItemWraithCollar",
        [3290]              = "ItemWraithCollar",
        [2043]              = "VisionWard",
        [3340]              = "TrinketTotemLvl1",
        [3090]              = "ZhonyasHourglass",
        [3154]              = "wrigglelantern",
        [3142]              = "YoumusBlade",
        [3157]              = "ZhonyasHourglass",
        [3512]              = "ItemVoidGate",
        [3131]              = "ItemSoTD",
        [3137]              = "ItemDervishBlade",
        [3352]              = "RelicSpotter",
        [3350]              = "TrinketTotemLvl2",
        [3085]              = "AtmasImpalerDummySpell",
    }
    --[[Items = {
        ["QSS"]         = { id = 3140, range = 2500 },
        ["MercScim"]    = { id = 3139, range = 2500 },
    }]]
    Items = {
        ["ELIXIR"]      = { id = 2140, range = 2140, target = false},
        ["QSS"]         = { id = 3140, range = 2500, target = false},
        ["MercScim"]    = { id = 3139, range = 2500, target = false},
        ["BRK"]         = { id = 3153, range = 450, target = true},
        ["BWC"]         = { id = 3144, range = 450, target = true},
        --["DFG"]           = { id = 3128, range = 750, target = false},
        ["HXG"]         = { id = 3146, range = 700, target = false},
        ["ODYNVEIL"]    = { id = 3180, range = 525, target = false},
        ["DVN"]         = { id = 3131, range = 200, target = false},
        ["ENT"]         = { id = 3184, range = 350, target = false},
        ["HYDRA"]       = { id = 3074, range = 350, target = false},
        ["TIAMAT"]      = { id = 3077, range = 350, target = false},
        ["RanduinsOmen"]    = { id = 3143, range = 500, target = false},
        ["YGB"]         = { id = 3142, range = 600, target = false},
    }
    ___GetInventorySlotItem = rawget(_G, "GetInventorySlotItem")
    _G.GetInventorySlotItem = GetSlotItem

end

function OnTick()

        if Config.SMother.killsteal then KillSteal() end

        if Config.SMsbtw.sbtw then 
            Combo(Target)
        end
        if Config.SMfarm.farm and not IsMyManaLow("LaneClear") then
            LaneClear()
        end
        if Config.SMsmart.smartfarm then
            LastHit()
        end
        if Config.SMjfarm.jungle and not IsMyManaLow("JungleClear") then
            Jungle()
        end
        if Config.SMharass.qflee and not IsMyManaLow("Harass") then
            rassHa(Target)
        end

        if Config.SMother.autoPot and lowHp(myHero) then AutoPots() end
        if Config.SMother.autoMPot and lowMana(myHero) then AutoMpots() end

    Checks()
end

function OnDraw()
    if not myHero.dead then
        if Config.SMdraw.drawQ and QREADY then
            DrawCircle(myHero.x, myHero.y, myHero.z, SkillQ.range, ARGB(255, 255, 255, 255))
        end
        if Config.SMdraw.drawW and WREADY then
            DrawCircle(myHero.x, myHero.y, myHero.z, SkillW.range, ARGB(255, 255, 255, 255))
        end
        if Config.SMdraw.drawE and EREADY then
            DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, ARGB(255, 255, 255, 255))
        end
        if Config.SMdraw.drawR and RREADY then
            DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, ARGB(255, 255, 255, 255))
        end
    end
end

------------------------------------------------------
--           Functions              
------------------------------------------------------

function Combo(unit)
    if Config.SMsbtw.sbtw and Config.SMother.useZhonya and lowHp(myHero) and CountEnemyHeroInRange(300) >= 2 and GetInventoryItemIsCastable(3157)then
        CastItem(3157)
    end
    if Config.SMsbtw.sbtw and Config.SMother.useSeraph and myHero.health <= (50/100*myHero.maxHealth) and GetInventoryItemIsCastable(3048) then
        CastItem(3048)
    end

    if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
            if Config.SMsbtw.aa then SxOrb:EnableAttacks() end
        if Config.SMsbtw.sbtw and Config.pred.prediction == 1 then
            if Config.SMsbtw.useQ and QREADY and not TargetPoisoned(unit) then
                CastQ(unit)
            end
            if Config.SMsbtw.useW and WREADY and not TargetPoisoned(unit) then
                CastW(unit)
            end
            if Config.SMsbtw.useE and EREADY then
                CastE(unit)
            end
            if Config.SMsbtw.useR and RREADY then
                CastR(unit)
            end
        end
    
            if Config.SMsbtw.sbtw and Config.pred.prediction == 3 then
                if Config.SMsbtw.useQ and QREADY and not TargetPoisoned(unit) then
                    CastSQ(unit)
                end
                if Config.SMsbtw.useW and WREADY and not TargetPoisoned(unit) then
                    CastSW(unit)
                end
                if Config.SMsbtw.useE and EREADY then
                    CastE(unit)
                end
                if Config.SMsbtw.useR and RREADY then
                    CastR(unit)
                end
            end
        if Config.SMsbtw.sbtw and Config.pred.prediction == 2 then
            if Config.SMsbtw.useQ and QREADY and not TargetPoisoned(unit) then
                CastHPREDQ(unit)
            end
            if Config.SMsbtw.useW and WREADY and not TargetPoisoned(unit) then
                CastHPREDW(unit)
            end
            if Config.SMsbtw.useE and EREADY then
                CastE(unit)
            end
            if Config.SMsbtw.useR and RREADY then
                CastR(unit)
            end
        end
    end
end

function LaneClear()

    enemyMinions:update()  

    if Config.SMfarm.aa then SxOrb:EnableAttacks() end

    if Config.SMfarm.farm then
        for i, minion in pairs(enemyMinions.objects) do
            if ValidTarget(minion) and minion ~= nil then

                if Config.SMfarm.useQ and GetDistance(minion) <= SkillQ.range and QREADY then
                    local BestPos, BestHit = GetBestCircularFarmPosition(SkillQ.range, SkillQ.width, enemyMinions.objects)
                    
                    if BestPos ~= nil and not TargetPoisoned(minion) then
                        CastSpell(_Q, BestPos.x, BestPos.z)
                    end
                end
                if Config.SMfarm.useW and GetDistance(minion) <= SkillW.range and WREADY then
                    local BestPos, BestHit = GetBestCircularFarmPosition(SkillW.range, SkillW.width, enemyMinions.objects)
                    
                    if BestPos ~= nil and BestHit >= 2 and not TargetPoisoned(unit) then
                        CastSpell(_W, BestPos.x, BestPos.z)
                    end
                end
                if Config.SMfarm.useE and EREADY --[[getDmg("AD", minion, myHero) < minion.health]] then
                    if getDmg("E", minion, myHero) >= minion.health and TargetPoisoned(minion) then
                        CastSpell(_E, minion)
                    elseif TargetPoisoned(minion) then 
                        CastSpell(_E, minion)
                    end
                end
            end
        end
    end
end

function LastHit()

    enemyMinions:update() 

    if Config.SMsmart.aa and not EREADY then SxOrb:EnableAttacks() end

    if Config.SMsmart.smartfarm then
        for i, minion in pairs(enemyMinions.objects) do
            if Config.SMsmart.useQ and GetDistance(minion) <= SkillQ.range and QREADY then
                
                local BestPos, BestHit = GetBestCircularFarmPosition(SkillQ.range, SkillQ.width, enemyMinions.objects)                  
                if BestPos ~= nil and not TargetPoisoned(minion) then
                    CastSpell(_Q, BestPos.x, BestPos.z)
                end
            end
            if Config.SMsmart.useW and GetDistance(minion) <= SkillW.range and WREADY then
                
                local BestPos, BestHit = GetBestCircularFarmPosition(SkillW.range, SkillW.width, enemyMinions.objects)                  
                    if BestPos ~= nil and BestHit >= 3 and not TargetPoisoned(minion) then
                        CastSpell(_W, BestPos.x, BestPos.z)
                    end
                end
                if minion ~= nil and ValidTarget(minion, SkillE.range) and Config.SMsmart.useE and EREADY then
                    if getDmg("E", minion, myHero) >= minion.health and TargetPoisoned(minion) then
                        CastSpell(_E, minion)
                        end
                    end                  
                if Config.SMsmart.useEnplh and not TargetPoisoned(minion) then
                    if getDmg("E", minion, myHero) >= minion.health then
                        CastSpell(_E, minion)
                end
            end
        end
    end
end

function rassHa(unit)

    if Config.SMharass.aa then SxOrb:EnableAttacks() end

    if Config.SMharass.qflee then
        if Config.SMsbtw.useW and WREADY and not TargetPoisoned(unit) then
                CastW(unit)
        end
        if Config.SMsbtw.useQ and QREADY then
                CastQ(unit)
        end
        if Config.SMsbtw.useE and EREADY then
                CastE(unit)
        end
    end
end

function Jungle()

    if Config.SMjfarm.aa then SxOrb:EnableAttacks() end

    if Config.SMjfarm.jungle then
        local JungleMob = GetJungleMob() 

        if JungleMob ~= nil then
            if Config.SMfarm.useW and GetDistance(JungleMob) <= SkillW.range and WREADY and not TargetPoisoned(JungleMob) then
                CastSpell(_W, JungleMob.x, JungleMob.z)
            end
            if Config.SMjfarm.useQ and GetDistance(JungleMob) <= SkillQ.range and QREADY and not TargetPoisoned(JungleMob) then
                CastSpell(_Q, JungleMob.x, JungleMob.z)
            end
            if Config.SMfarm.useE and GetDistance(JungleMob) <= SkillE.range and EREADY and TargetPoisoned(JungleMob) then
                CastSpell(_E, JungleMob)
            end
        end
    end
end

function CastQ(unit, minion)
    if unit ~= nil then
        local IsImmobile, Position = VP:IsImmobile(unit, SkillQ.delay, SkillQ.radius, SkillQ.speed, myHero)
        if IsImmobile then
            CastSpell(_Q, Position.x, Position.z)
        else
            local TargetDashing, CanHit, Position = VP:IsDashing(unit, SkillQ.delay, SkillQ.radius, SkillQ.speed, myHero)
            if TargetDashing and GetDistance(unit) <= SkillQ.range then
                CastSpell(_Q, Position.x, Position.z)
            else
                local QCastPosition, QHitChance, QPosition = VP:GetCircularCastPosition(unit, SkillQ.delay, SkillQ.width, SkillQ.range, SkillQ.speed, myHero, false)
                if QCastPosition and QHitChance >= 2 and GetDistance(unit) <= SkillQ.range then
                    CastSpell(_Q, QCastPosition.x, QCastPosition.y,QCastPosition.z)
                end
            end
        end
    end
end

function CastW(unit, minion)
     if unit ~= nil then
        local IsImmobile, Position = VP:IsImmobile(unit, SkillW.delay, SkillW.radius, SkillW.speed, myHero)
        if IsImmobile then
            CastSpell(_W, Position.x, Position.z)
        else
            local TargetDashing, CanHit, Position = VP:IsDashing(unit, SkillW.delay, SkillW.radius, SkillW.speed, myHero)
            if TargetDashing and GetDistance(unit) <= SkillW.range then
                CastSpell(_W, Position.x, Position.z)
            else
                local WCastPosition, WHitChance, WPosition = VP:GetCircularCastPosition(unit, SkillW.delay, SkillQ.width, SkillW.range, SkillW.speed, myHero, false)
                if WHitChance >= 2 and GetDistance(unit) <= SkillW.range then
                    CastSpell(_W, WCastPosition.x, WCastPosition.y, WCastPosition.z)
                end
            end         
        end        
    end
end

function CastSQ(unit, minion)
    if unit ~= nil and GetDistance(unit) <= SkillQ.range then

        local QCastPosition, QHitChance, QPredictedPosition = SP:Predict(unit, SkillQ.range, SkillQ.speed, SkillQ.delay, SkillQ.width, false, myHero)
        if QHitChance >= 2 then
            CastSpell(_Q, QCastPosition.x,  QCastPosition.z)
        end
    end
end

function CastSW(unit, minion)
     if unit ~= nil and GetDistance(unit) <= SkillW.range then

        local WCastPosition, WHitChance, WPredictedPosition = SP:Predict(unit, SkillW.range, SkillW.speed, SkillW.delay, SkillW.width, false, myHero)
        if WHitChance >= 2 then
            CastSpell(_W, WCastPosition.x,  WCastPosition.z)
        end
    end
end

function CastHPREDQ(unit)
    if unit ~= nil and GetDistance(unit) <= SkillQ.range then

        local QPos, QHitChance = HPred:GetPredict(HPred.Presets['Cassiopeia']["Q"], unit, myHero)
        if QHitChance >= 2 then
            CastSpell(_Q, QPos.x, QPos.z)
        end
    end
end

function CastHPREDW(unit)
    if unit ~= nil and GetDistance(unit) <= SkillW.range then

        local WPos, WHitChance = HPred:GetPredict(HPred.Presets['Cassiopeia']["W"], unit, myHero)
        if WHitChance >= 2 then
            CastSpell(_W, WPos.x, WPos.z)
        end
    end
end

function CastE(unit, minion)
    if unit ~= nil and GetDistance(unit) <= SkillE.range then
        if TargetPoisoned(unit) then
            if VIP_USER and Config.SMother.usePackets then
                Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
            else
                CastSpell(_E, unit)
            end
        end
    end
end

function CastR(unit, minion)
    if unit ~= nil and GetDistance(unit) <= SkillR.range and CountEnemyHeroInRange(SkillR.range) >= Config.SMsbtw.useUlt then
        local mainCastPosition, mainHitChance, maxHit = VP:GetConeAOECastPosition(unit, SkillR.delay, SkillR.angle, SkillR.range, SkillR.speed, myHero)
        if mainHitChance >= 2 and maxHit >= 2 then
            CastSpell(_R, unit)
        end
    end
end

function KillSteal()
    for _, enemy in ipairs(GetEnemyHeroes()) do 
        local iDmg = (50 + (20 * myHero.level))
        local qDmg = getDmg("Q", enemy, myHero)
        local wDmg = getDmg("W", enemy, myHero)
        local eDmg = getDmg("E", enemy, myHero)
        
        if enemy ~= nil then
            if enemy.health <= qDmg and ValidTarget(enemy, SkillQ.range) and QREADY then
                CastQ(enemy)
            elseif enemy.health <= wDmg and ValidTarget(enemy, SkillW.range) and WREADY then
                CastW(enemy)
            elseif enemy.health <= eDmg and ValidTarget(enemy, SkillE.range) and EREADY then
                CastE(enemy)
            elseif enemy.health <= iDmg and ValidTarget(enemy, 600) and Config.SMother.ignite then AutoIgnite() end
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

function OnApplyBuff(source, unit, buff)

    if buff and unit == myHero then print(buff.name) end

    if not unit or not buff then return end
        if unit and unit.isMe and buff.name == "RegenerationPotion" then
            UsingPot = true
        end

        if unit and unit.isMe and buff.name == "FlaskOfCrystalWater" then
            UsingMpot = true
        end
    if unit.isMe and Config.SMother.useqss then
        if buff.name and buff.type == 5 or buff.type == 12 or buff.type == 11 or buff.type == 25 or buff.type == 7 or buff.type == 22 or buff.type == 21 or buff.type == 8
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

        if unit and unit.isMe and buff.name == "FlaskOfCrystalWater" then
            UsingMpot = false
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
    if GetInventoryItemIsCastable(2003) and lowHp(myHero) and not UsingPot then 
       CastItem(2003) 
    end
end

function lowMana(unit)
    if unit.mana <= (Config.SMother.useMPots/100*myHero.maxMana) then
        return true
    else
        return false
    end
end


function AutoMpots()
    if GetInventoryItemIsCastable(2004) and lowMana(myHero) and not UsingMpot then 
       CastItem(2004) 
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

------------------------------------------------------
--           Checks, menu & stuff               
------------------------------------------------------

function Checks()
    QREADY = (myHero:CanUseSpell(_Q) == READY)
    EREADY = (myHero:CanUseSpell(_E) == READY)
    WREADY = (myHero:CanUseSpell(_W) == READY)
    RREADY = (myHero:CanUseSpell(_R) == READY)
    IREADY = (igniteSpell ~= nil and myHero:CanUseSpell(igniteSpell) == READY)
    
    if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then 
        ignite = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then 
        ignite = SUMMONER_2
    else 
        ignite = nil
    end
    
    TargetSelector:update()
    Target = GetCustomTarget()
    SxOrb:ForceTarget(Target)
    
end

function IsMyManaLow(mode)
    if mode == "Harass" then
        if myHero.mana < (myHero.maxMana * ( Config.SMharass.harassMana / 100)) then
            return true
        else
            return false
        end
    elseif mode == "LaneClear" then
        if myHero.mana < (myHero.maxMana * ( Config.SMfarm.laneMana / 100)) then
            return true
        else
            return false
        end
    elseif mode == "JungleClear" then
        if myHero.mana < (myHero.maxMana * ( Config.SMjfarm.jungleMana / 100)) then
            return true
        else
            return false
        end
    end
end

function Menu()

    Config = scriptConfig("Gosu Mechanics", "GosuMechanics")
    Config:addSubMenu("Combo Options", "SMsbtw")
    Config:addSubMenu("Harass Options", "SMharass")
    Config:addSubMenu("Last Hit Options", "SMsmart")
    Config:addSubMenu("LaneClear Options", "SMfarm")
    Config:addSubMenu("JungleClear Options", "SMjfarm")
    Config:addSubMenu("Drawing Options", "SMdraw")
    Config:addSubMenu("Misc Options", "SMother")
    Config:addSubMenu("Prediction Options", "pred")

    Config.SMsmart:addParam("smartfarm", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("A"))
    Config.SMsmart:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMsmart:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMsmart:addParam("useE", "Use E-LastHit poisoned", SCRIPT_PARAM_ONOFF, true)
    Config.SMsmart:addParam("useEnplh", "E-LastHit non-poisoned", SCRIPT_PARAM_ONOFF, true)
    Config.SMsmart:addParam("aa", "Enable AutoAttacks", SCRIPT_PARAM_ONOFF, true)

    Config.SMharass:addParam("qflee", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
    Config.SMharass:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMharass:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMharass:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMharass:addParam("harassMana", "Min. Mana", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
    Config.SMharass:addParam("aa", "Enable AutoAttacks", SCRIPT_PARAM_ONOFF, true)

    Config.SMfarm:addParam("farm", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("X"))
    Config.SMfarm:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("laneMana", "Min. Mana", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
    Config.SMfarm:addParam("aa", "Enable AutoAttacks", SCRIPT_PARAM_ONOFF, true)

    Config.SMjfarm:addParam("jungle", "Jungle Clear", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("X"))
    Config.SMjfarm:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMjfarm:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMjfarm:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMjfarm:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
    Config.SMjfarm:addParam("jungleMana", "Min. Mana", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
    Config.SMfarm:addParam("aa", "Enable AutoAttacks", SCRIPT_PARAM_ONOFF, true)

    Config.SMsbtw:addParam("sbtw", "Beast Mode", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("S"))
    Config.SMsbtw:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useUlt", "Use Ult x enemy in range", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
    Config.SMsbtw:addParam("aa", "Enable AutoAttacks", SCRIPT_PARAM_ONOFF, true)

  
    Config.SMother:addParam("usePackets", "Use Packets", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("killsteal", "Kill Steal", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("ignite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("autoPot", "Auto-Pots", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("usePots", "use when at % hp", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
    Config.SMother:addParam("autoMPot", "Auto-ManaPots", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("useMPots", "use when at % mana", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
    Config.SMother:addParam("useqss", "Auto-QSS", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("delay", "Activation delay", SCRIPT_PARAM_SLICE, 0, 0, 250, 0)
    Config.SMother:addParam("useZhonya", "Auto-Zhonya LowHP", SCRIPT_PARAM_ONOFF, true)
    Config.SMother:addParam("useSeraph", "Auto-Seraph LowHP", SCRIPT_PARAM_ONOFF, true)


    Config.pred:addParam("prediction", "Choose Prediction", SCRIPT_PARAM_LIST, 1, {"VPrediction", "HPrediction", "SPrediction"  })
    
        --[[Config.SMother:addSubMenu("GapCloser Spells", "ES2")
            for i, enemy in ipairs(GetEnemyHeroes()) do
                for _, champ in pairs(GapCloserList) do
                    if enemy.charName == champ.charName then
                        Config.SMother.ES2:addParam(champ.spellName, "GapCloser "..champ.charName.." "..champ.name, SCRIPT_PARAM_ONOFF, true)
                    end
                end
            end]]

        Config.SMother:addSubMenu("[" .. myHero.charName.. "] - Auto-Interrupt", "interrupt")
        Config.SMother.interrupt:addParam("r", "Interrupt with R", SCRIPT_PARAM_ONOFF, true)
        for i, a in pairs(GetEnemyHeroes()) do
            if Interrupt[a.charName] ~= nil then
                for i, spell in pairs(Interrupt[a.charName].stop) do
                    Config.SMother.interrupt:addParam(spell.spellName, a.charName.." - "..spell.name, SCRIPT_PARAM_ONOFF, true)
                end
            end
        end

    Config.SMdraw:addParam("drawQ","Draw Q-Range",SCRIPT_PARAM_ONOFF, true)
    Config.SMdraw:addParam("drawW","Draw W-Range",SCRIPT_PARAM_ONOFF, true)
    Config.SMdraw:addParam("drawE","Draw E-Range",SCRIPT_PARAM_ONOFF, true)
    Config.SMdraw:addParam("drawR","Draw R-Range",SCRIPT_PARAM_ONOFF, true)

    Config.SMother:addSubMenu("[" .. myHero.charName.. "] - Anti Gap-Closer", "gapClose")
        for _, enemy in pairs(GetEnemyHeroes()) do
            if isAGapcloserUnit[enemy.charName] ~= nil then
                Config.SMother.gapClose:addParam(enemy.charName, enemy.charName .. " - " .. enemy:GetSpellData(isAGapcloserUnit[enemy.charName].spell).name, SCRIPT_PARAM_ONOFF, true)
            end
        end

    Config.SMother:permaShow("usePackets")
    Config.SMother:permaShow("ignite")
    --Config.SMother:permaShow("useqss")
    Config.SMother:permaShow("killsteal")
        
    Config:addSubMenu("Orbwalking Settings", "Orbwalking")
        SxOrb:LoadToMenu(Config.Orbwalking)
        
    
    TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, SkillQ.range, DAMAGE_MAGICAL, true)
    TargetSelector.name = "Gosu"
    Config:addTS(TargetSelector)

end

function Variables()

    SkillQ = { name = "CassiopeiaNoxiousBlast", range = 925, delay = 0.6, speed = 1800, width = 80, radius = 80, ready = false }
    SkillW = { name = "CassiopeiaMiasma", range = 925, delay = 0.9, speed = 2500, width = 100, radius = 80, ready = false }
    SkillE = { name = "CassiopeiaTwinFang", range = 700, delay = nil, speed = nil, width = nil, ready = false }
    SkillR = { name = "CassiopeiaPetrifyingGaze", range = 750, delay = 0.5, speed = math.huge, angle = 80, ready = false }

   enemyMinions = minionManager(MINION_ENEMY, SkillE.range, myHero, MINION_SORT_HEALTH_ASC)
    
    HPred = HPrediction()
    SP = SPrediction()
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
            ["SRU_MurkwolfMini2.1.3"]   = true,
            ["SRU_MurkwolfMini2.1.2"]   = true,
            ["SRU_MurkwolfMini8.1.3"]   = true,
            ["SRU_MurkwolfMini8.1.2"]   = true,
            ["SRU_BlueMini1.1.2"]       = true,
            ["SRU_BlueMini7.1.2"]       = true,
            ["SRU_BlueMini21.1.3"]      = true,
            ["SRU_BlueMini27.1.3"]      = true,
            ["SRU_RedMini10.1.2"]       = true,
            ["SRU_RedMini10.1.3"]       = true,
            ["SRU_RedMini4.1.2"]        = true,
            ["SRU_RedMini4.1.3"]        = true,
            ["SRU_KrugMini11.1.1"]      = true,
            ["SRU_KrugMini5.1.1"]       = true,
            ["SRU_RazorbeakMini9.1.2"]  = true,
            ["SRU_RazorbeakMini9.1.3"]  = true,
            ["SRU_RazorbeakMini9.1.4"]  = true,
            ["SRU_RazorbeakMini3.1.2"]  = true,
            ["SRU_RazorbeakMini3.1.3"]  = true,
            ["SRU_RazorbeakMini3.1.4"]  = true
        }
        
        FocusJungleNames = {
            ["SRU_Blue1.1.1"]           = true,
            ["SRU_Blue7.1.1"]           = true,
            ["SRU_Murkwolf2.1.1"]       = true,
            ["SRU_Murkwolf8.1.1"]       = true,
            ["SRU_Gromp13.1.1"]         = true,
            ["SRU_Gromp14.1.1"]         = true,
            ["Sru_Crab16.1.1"]          = true,
            ["Sru_Crab15.1.1"]          = true,
            ["SRU_Red10.1.1"]           = true,
            ["SRU_Red4.1.1"]            = true,
            ["SRU_Krug11.1.2"]          = true,
            ["SRU_Krug5.1.2"]           = true,
            ["SRU_Razorbeak9.1.1"]      = true,
            ["SRU_Razorbeak3.1.1"]      = true,
            ["SRU_Dragon6.1.1"]         = true,
            ["SRU_Baron12.1.1"]         = true
        }
    else
        FocusJungleNames = {
            ["TT_NWraith1.1.1"]         = true,
            ["TT_NGolem2.1.1"]          = true,
            ["TT_NWolf3.1.1"]           = true,
            ["TT_NWraith4.1.1"]         = true,
            ["TT_NGolem5.1.1"]          = true,
            ["TT_NWolf6.1.1"]           = true,
            ["TT_Spiderboss8.1.1"]      = true
        }       
        JungleMobNames = {
            ["TT_NWraith21.1.2"]        = true,
            ["TT_NWraith21.1.3"]        = true,
            ["TT_NGolem22.1.2"]         = true,
            ["TT_NWolf23.1.2"]          = true,
            ["TT_NWolf23.1.3"]          = true,
            ["TT_NWraith24.1.2"]        = true,
            ["TT_NWraith24.1.3"]        = true,
            ["TT_NGolem25.1.1"]         = true,
            ["TT_NWolf26.1.2"]          = true,
            ["TT_NWolf26.1.3"]          = true
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
        SetPriority(priorityTable.AP,      enemy, 2)
        SetPriority(priorityTable.Support,  enemy, 3)
        SetPriority(priorityTable.Bruiser,  enemy, 4)
        SetPriority(priorityTable.Tank,  enemy, 5)
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

function UseItems(unit)
    if unit ~= nil then
        for _, item in pairs(Items) do
            item.slot = GetInventorySlotItem(item.id)
            if item.slot ~= nil then
                if item.reqTarget and GetDistance(unit) < item.range then
                    CastSpell(item.slot, unit)
                elseif not item.reqTarget then
                    if (GetDistance(unit) - getHitBoxRadius(myHero) - getHitBoxRadius(unit)) < 50 then
                        CastSpell(item.slot)
                    end
                end
            end
        end
    end
end

function getHitBoxRadius(target)
    return GetDistance(target.minBBox, target.maxBBox)/2
end

function PriorityOnLoad()
    if heroManager.iCount < 10 or (TwistedTreeline and heroManager.iCount < 6) then
        print("<b><font color=\"#6699FF\">GosuMechanics:</font></b> <font color=\"#FFFFFF\">Too few champions to arrange priority.</font>")
    elseif heroManager.iCount == 6 then
        arrangePrioritysTT()
    else
        arrangePrioritys()
    end
end

function GetJungleMob()
    for _, Mob in pairs(JungleFocusMobs) do
        if ValidTarget(Mob, SkillE.range) then return Mob end
    end
    for _, Mob in pairs(JungleMobs) do
        if ValidTarget(Mob, SkillE.range) then return Mob end
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

function TrueRange()
    return myHero.range + GetDistance(myHero, myHero.minBBox)
end

function CountEnemyHeroInRange(range)
    local enemyinRrange = 0
        for i = 1, heroManager.iCount, 1 do
            local hero = heroManager:getHero(i)
                if ValidTarget(hero,range) then
            enemyinRrange = enemyinRrange + 1
            end
        end
    return enemyinRrange
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

function GetBestLineFarmPosition(range, width, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local EndPos = Vector(myHero.pos) + range * (Vector(object) - Vector(myHero.pos)):normalized()
        local hit = CountObjectsOnLineSegment(myHero.pos, EndPos, width, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = Vector(object)
            if BestHit == #objects then
               break
            end
         end
    end

    return BestPos, BestHit
end

function CountObjectsOnLineSegment(StartPos, EndPos, width, objects)
    local n = 0
    for i, object in ipairs(objects) do
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, object)
        if isOnSegment and GetDistanceSqr(pointSegment, object) < width * width then
            n = n + 1
        end
    end

    return n
end

function GetBestCircularFarmPosition(range, radius, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local hit = CountObjectsNearPos(object.pos or object, range, radius, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = Vector(object)
            if BestHit == #objects then
               break
            end
         end
    end

    return BestPos, BestHit
end

function CountObjectsNearPos(pos, range, radius, objects)
    local n = 0
    for i, object in ipairs(objects) do
        if GetDistanceSqr(pos, object) <= radius * radius then
            n = n + 1
        end
    end

    return n
end

-- Trees
function GetCustomTarget()
    TargetSelector:update()     
    if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
    return TargetSelector.target
end

-- Barasia, vadash, viseversa
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
  radius = radius or 300
  quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
  quality = 2 * math.pi / quality
  radius = radius*.92
  
  local points = {}
  for theta = 0, 2 * math.pi + quality, quality do
    local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
    points[#points + 1] = D3DXVECTOR2(c.x, c.y)
  end
  
  DrawLines2(points, width or 1, color or 4294967295)
end

function round(num) 
  if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
        
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        DrawCircleNextLvl(x, y, z, radius, 1, color, 300) 
    end
end

function DrawCircle2(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        DrawCircleNextLvl(x, y, z, radius, 1, color, 75)    
    end
end

function isFacing(source, target, lineLength)
    local sourceVector = Vector(source.visionPos.x, source.visionPos.z)
    local sourcePos = Vector(source.x, source.z)
    sourceVector = (sourceVector-sourcePos):normalized()
    sourceVector = sourcePos + (sourceVector*(GetDistance(target, source)))
    return GetDistanceSqr(target, {x = sourceVector.x, z = sourceVector.y}) <= (lineLength and lineLength^2 or 90000)
end

function isBothFacing(source, target, lineLength)
    return isFacing(source, target, lineLength) and isFacing(target, source, lineLength)
end


function TargetPoisoned(unit)
    if TargetHaveBuff("cassiopeianoxiousblastpoison", unit)  or TargetHaveBuff("cassiopeiamiasmapoison", unit) then
            return true
        end
    return false
end

--[[function isPoisoned(target)
    for i = 1, target.buffCount do
        local tBuff = target:getBuff(i)
        if BuffIsValid(tBuff) and tBuff.name:find("poison") and (tBuff.endT - (math.min(GetDistance(myHero.visionPos, target.visionPos), 700)/1900 + 0.25 + GetLatency()/2000) - GetGameTimer() > 0) then
            return true
        end
    end

    return false
end]]

--[[function OnProcessSpell(unit, spell)
    if Config.SMother.autoR and RREADY then
        for _, x in pairs(GapCloserList) do
            if unit and unit.team ~= myHero.team and unit.type == myHero.type and spell then
                if spell.name == x.spellName and Config.SMother.ES2[x.spellName] and ValidTarget(unit, SkillR.range) then
                    if spell.target and spell.target.isMe then
                        CastSpell(_R, unit)
                    elseif not spell.target then
                        local endPos1 = Vector(unit.visionPos) + 300 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
                        local endPos2 = Vector(unit.visionPos) + 100 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
                        if (GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos1) or GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos2))  then
                            CastSpell(_R, unit)
                        end
                    end
                end
            end
        end
    end
end]]
function OnProcessSpell(object, spellProc)
    if myHero.dead then return end
    if object.team == myHero.team then return end
    
    if Interrupt[object.charName] ~= nil then
        spell = Interrupt[object.charName].stop[spellProc.name]
        if spell ~= nil then
            if Config.SMother.interrupt[spellProc.name] then
                if ValidTarget(unit) and GetDistance(object) < SkillR.range and RREADY and Config.SMother.interrupt.r then
                    CastSpell(_R, unit)
                end
            end
        end
    end
        
    local unit = object
    local spell = spellProc
    
    if unit.type == myHero.type and unit.team ~= myHero.team and isAGapcloserUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then         
        if spell.name == (type(isAGapcloserUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isAGapcloserUnit[unit.charName].spell).name or isAGapcloserUnit[unit.charName].spell) and Config.SMother.gapClose[unit.charName] then
            if spell.target ~= nil and spell.target and spell.target.networkID == myHero.networkID or isAGapcloserUnit[unit.charName].spell == 'blindmonkqtwo' then
                CastSpell(_R, object)
            elseif not spell.target then
                local startPos1 = Vector(unit.visionPos) + 300 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
                local startPos2 = Vector(unit.visionPos) + 100 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
                if (GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos1) or GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos2))  then
                    CastSpell(_R, startPos1.x, startPos2.z)
                end
            end
        end
    end
end