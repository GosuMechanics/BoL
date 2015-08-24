if myHero.charName ~= "Yasuo" then return end
    
    require 'VPrediction'

local version = 1.01
local Author = "rainschiltz"

local UPDATE_NAME = "Yasuo-Montage"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/GosuMechanics/BoL/master/GosuYasuo.version" .. "?rand=" .. math.random(1, 10000)
local UPDATE_PATH2 = "/GosuMechanics/BoL/master/GosuYasuo.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "http://"..UPDATE_HOST..UPDATE_PATH2
_G.UseUpdater = true
----------------------------------------------------------------------------------------------------
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
Champions = {
    ["Aatrox"] = {charName = "Aatrox", skillshots = {
        ["AatroxE"] = {spellKey = _E, name = "Blade of Torment", spellName = "AatroxE", spellDelay = 250, projectileName = "AatroxBladeofTorment_mis.troy", projectileSpeed = 1200, range = 1075, radius = 100, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["AatroxW"] = {spellKey = _W, spellName = "AatroxW", checkName = true, name = "AatroxW", isAutoBuff = true, range = 125, isSelfCast = true, noAnimation = true},
        ["AatroxQ"] = {name = "AatroxQ", spellName = "AatroxQ", spellDelay = 250, projectileName = "AatroxQ.troy", projectileSpeed = 450, range = 650, radius = 145, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1},
        ["AatroxR"] = { spellKey = _R, isSelfCast = true, isAutoBuff = true, spellName = "AatroxR", name = "AatroxR", range = 125},
    }},
    ["Ahri"] = {charName = "Ahri", skillshots = {
        ["AhriOrbofDeception"] = {spellKey = _Q, name = "Orb of Deception", spellName = "AhriOrbofDeception", spellDelay = 250, projectileName = "Ahri_Orb_mis.troy", projectileSpeed = 1750, range = 800, radius = 100, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Orb of Deception Back"] = {name = "Orb of Deception Back", spellName = "AhriOrbofDeception!", spellDelay = 750, projectileName = "Ahri_Orb_mis_02.troy", projectileSpeed = 915, range = 800, radius = 100, type = "LINE"},
        ["AhriSeduce"] = {spellKey = _E, isTrueRange = true, isCollision = true, name = "Charm", spellName = "AhriSeduce", spellDelay = 250, projectileName = "Ahri_Charm_mis.troy", projectileSpeed = 1600, range = 1075, radius = 60, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["AhriFoxFire"] = { spellKey = _W, isSelfCast = true, spellName = "AhriFoxFire", name = "AhriFoxFire", range = 750, projectileSpeed = 1400},
    }},
    ["Alistar"] = {charName = "Alistar", skillshots = {
    --unfinished
        ["Headbutt"] = {spellKey = _W, isTargeted = true, name = "Headbutt", spellName = "Headbutt", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 650, type = "LINE"},
        ["Pulverize"] = {spellKey = _Q, isSelfCast = true, name = "Pulverize", spellName = "Pulverize", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 250, type = "CIRCULAR"},
    }},
    ["Amumu"] = {charName = "Amumu", skillshots = {
        ["BandageToss"] = {spellKey = _Q, isCollision = true, name = "Bandage Toss", spellName = "BandageToss", spellDelay = 250, projectileName = "Bandage_beam.troy", projectileSpeed = 2000, range = 1100, radius = 80, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Tantrum"] = {spellKey = _E, isSelfCast = true, name = "Tantrum", spellName = "Tantrum", spellDelay = 250, range = 200, type = "CIRCULAR"},
        ["AuraofDespair"] = { spellKey = _W, isSelfCast = true, heroHasNoBuff = "AuraofDespair", spellName = "AuraofDespair", name = "AuraofDespair", range = 300, },
    }},
    ["Anivia"] = {charName = "Anivia", skillshots = {
        ["FlashFrostSpell"] = {spellKey = _Q, name = "Flash Frost", spellName = "FlashFrostSpell", spellDelay = 250, projectileName = "cryo_FlashFrost_mis.troy", projectileSpeed = 850, range = 1100, radius = 110, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Frostbite"] = {spellKey = _E, isTargeted = true, targetHasBuff = "chilled", name = "Frostbite", spellName = "Frostbite", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 700, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Glacial Storm"] = {spellKey = _R, name = "Glacial Storm", spellName = "GlacialStorm", spellDelay = 250, projectileName = "Ahri_Orb_mis.troy", range = 615, radius = 400, type = "CIRCULAR"},
    }},
    ["Akali"] = {charName = "Akali", skillshots = {
    --unfinished
        ["AkaliQ"] = {spellKey = _Q, isTargeted = true, name = "AkaliQ", spellName = "AkaliQ", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 600, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Crescent Slash"] = {spellKey = _E, isSelfCast = true, name = "Crescent Slash", spellName = "CrescentSlash", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 325, type = "CIRCULAR"},
        ["Shadow Dance"] = {spellKey = _R, isTargeted = true, name = "Shadow Dance", spellName = "Shadow Dance", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 800, type = "LINE"},
    }},
    ["Ashe"] = {charName = "Ashe", skillshots = {
        ["EnchantedCrystalArrow"] = { name = "Enchanted Arrow", spellName = "EnchantedCrystalArrow", spellDelay = 250, projectileName = "EnchantedCrystalArrow_mis.troy", projectileSpeed = 1600, range = 25000, radius = 130, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Volley"] = {spellKey = _W, isTrueRange = true, name = "Volley", spellName = "Volley", spellDelay = 250, range = 1200, radius = 200, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["FrostShot"] = { spellKey = _Q, isSelfCast = true, isAutoBuff = true, heroHasNoBuff = "FrostShot", noAnimation = true, spellName = "FrostShot", name = "FrostShot", range = 600, projectileName = "IceArrow_mis.troy",},
    }},
    ["Annie"] = {charName = "Annie", skillshots = {
    --unfinished
        ["Disintegrate"] = {spellKey = _Q, isTargeted = true, name = "Disintegrate", spellName = "Disintegrate", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 625, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["MoltenShield"] = { spellKey = _E, isSelfCast = true, spellName = "MoltenShield", name = "MoltenShield", range = math.huge, },
        ["Incinerate"] = {spellKey = _W, isTrueRange = true, name = "Incinerate", spellName = "Incinerate", spellDelay = 500, projectileName = "Thresh_Q_whip_beam.troy", range = 625, radius = 200, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["InfernalGuardian"] = { spellKey = _R, type = "CIRCULAR", checkName = true, spellName = "InfernalGuardian", name = "InfernalGuardian", range = 600, radius = 290},
    }},
    ["Blitzcrank"] = {charName = "Blitzcrank", skillshots = {
        ["RocketGrabMissile"] = {spellKey = _Q, isCollision = true, isTrueRange = true, name = "Rocket Grab", spellName = "RocketGrabMissile", spellDelay = 250, projectileName = "FistGrab_mis.troy", projectileSpeed = 1800, range = 1050, radius = 70, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Power Fist"] = {spellKey = _E, isSelfCast = true, targetHasBuff = "rocketgrab2", name = "Power Fist", spellName = "PowerFist", spellDelay = 250, range = math.huge,},
        ["Static Field"] = {spellKey = _R, isSelfCast = true, name = "Static Field", spellName = "StaticField", spellDelay = 250, range = 550, type = "CIRCULAR"},
    }},
    ["Brand"] = {charName = "Brand", skillshots = {
        ["BrandBlaze"] = {spellKey = _Q, isCollision = true, name = "BrandBlaze", spellName = "BrandBlaze", spellDelay = 250, projectileName = "BrandBlaze_mis.troy", projectileSpeed = 1600, range = 900, radius = 80, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Pillar of Flame"] = {spellKey = _W, name = "Pillar of Flame", spellName = "BrandFissure", spellDelay = 875, projectileName = "BrandPOF_tar_green.troy", range = 900, radius = 240, type = "CIRCULAR"},
        ["BrandWildfire"] = {name = "BrandWildfire", spellName = "BrandWildfire", castDelay = 250, projectileName = "BrandWildfire_mis.troy", projectileSpeed = 1000, range = 1100, radius = 250, type = "circular", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Caitlyn"] = {charName = "Caitlyn", skillshots = {
        ["CaitlynPiltoverPeacemaker"] = {spellKey = _Q, name = "Piltover Peacemaker", spellName = "CaitlynPiltoverPeacemaker", spellDelay = 625, projectileName = "caitlyn_Q_mis.troy", projectileSpeed = 2200, range = 1300, radius = 90, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Caitlyn Entrapment"] = {name = "Caitlyn Entrapment", spellName = "CaitlynEntrapment", spellDelay = 150, projectileName = "caitlyn_entrapment_mis.troy", projectileSpeed = 2000, range = 950, radius = 80, type = "LINE"},
        ["CaitlynHeadshotMissile"] = {name = "Ace in the Hole", spellName = "CaitlynHeadshotMissile", range = 3000, fuckedUp = true, blockable = true, danger = 1, projectileName = "caitlyn_ult_mis.troy"},
    }},
    ["Cassiopeia"] = {charName = "Cassiopeia", skillshots = {
        ["Noxious Blast"] = {spellKey = _Q, name = "Noxious Blast", spellName = "Noxious Blast", spellDelay = 600, range = 850, radius = 75, type = "CIRCULAR"},
        ["CassiopeiaTwinFang"] = {spellKey = _E, isTargeted = true, targetHasBuff = "poison", name = "Twin Fang", spellName = "CassiopeiaTwinFang", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", projectileSpeed = 1800,  range = 700, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Chogath"] = {charName = "Chogath", skillshots = {
        ["Rupture"] = {spellKey = _Q, name = "Rupture", spellName = "Rupture", spellDelay = 875, projectileName = "rupture_cas_01_red_team.troy", range = 950, radius = 125, type = "CIRCULAR"},
        ["Feast"] = { spellKey = _R, isTargeted = true, isExecute = true, spellName = "Feast", name = "Feast", range = 150, },
--["Rupture"] = { spellKey = _Q, castType = 0, spellName = "Rupture", name = "Rupture", range = 950, projectileName = "AnnieBasicAttack_mis.troy",},
--["VorpalSpikes"] = { spellKey = _E, castType = 0, spellName = "VorpalSpikes", name = "VorpalSpikes", range = 40, projectileName = "TristanaBasicAttack_mis.troy", radius = 170,},
        ["FeralScream"] = { spellKey = _W, type = "LINE", spellName = "FeralScream", name = "FeralScream", range = 700, radius = 200, fuckedUp = false, blockable = true, danger = 1},

    }},
    ["Corki"] = {charName = "Corki", skillshots = {
        ["PhosphorusBomb"] = {spellKey = _Q, name = "Phosphorus Bomb", spellName = "PhosphorusBomb", spellDelay = 750, spellAnimationDelay = 250, projectileName = "LayWaste_point.troy", range = 825, radius = 250, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1},
        ["GGun"] = { spellKey = _E, type = "LINE", spellName = "GGun", name = "GGun", range = 600, radius = 200, noAnimation = true,},
        ["Missile Barrage"] = {spellKey = _R, isCollision = true, heroHasBuff = "corkimissilebarragenc", isTrueRange = true, name = "Missile Barrage", spellName = "MissileBarrage", spellDelay = 250, projectileName = "corki_MissleBarrage_mis.troy", projectileSpeed = 2000, range = 1300, radius = 40, type = "LINE"},
        ["MissileBarrageBig"] = {spellKey = _R, isCollision = true, name = "Missile Barrage big", heroHasBuff = "mbcheck2", spellName = "MissileBarrageBig", spellDelay = 250, projectileName = "Corki_MissleBarrage_DD_mis.troy", projectileSpeed = 2000, range = 1600, radius = 60, type = "LINE", fuckedUp = false, blockable = true, danger = 1}
    }},
    ["Darius"] = {charName = "Darius", skillshots = {
    --unfinished
        ["Noxian Guillotine"] = {spellKey = _R, isTargeted = true, isExecute = true, name = "Noxian Guillotine", spellName = "NoxianGuillotine", spellDelay = 250, range = 460, type = "LINE"},
        ["Crippling Strike"] = {spellKey = _W, isSelfCast = true, isAutoReset = true, name = "Crippling Strike", spellName = "Crippling Strike", spellDelay = 250, range = 125, type = "CIRCULAR"},
        ["DariusAxeGrabCone"] = {spellKey = _E, isTrueRange = true, name = "Apprehend", spellName = "DariusAxeGrabCone", spellDelay = 320, range = 570, radius = 200, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["DariusCleave"] = {spellKey = _Q, isSelfCast = true, name = "Decimate", spellName = "DariusCleave", spellDelay = 230, range = 425, type = "CIRCULAR"},
    }},
    ["Diana"] = {charName = "Diana", skillshots = {
        --["Diana Arc"] = {spellKey = _Q, name = "DianaArc", spellName = "DianaArc", spellDelay = 250, projectileName = "Diana_Q_trail.troy", projectileSpeed = 1600, range = 830, radius = 100, type = "CIRCULAR"},
        ["DianaArc"] = {spellKey = _Q, name = "DianaArc", spellName = "DianaArc", spellDelay = 250, projectileName = "Diana_Q_trail.troy", range = 830, radius = 200, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1},
        ["Pale Cascade"] = {spellKey = _W, isSelfCast = true, isShield = true, name = "Pale Cascade", spellName = "PaleCascade", spellDelay = 230, range = 200, type = "CIRCULAR", noAnimation = true,
            damage = function () return 25 + myHero.ap * .3 + 15 * myHero:GetSpellData(_W).level end},
        ["Lunar Rush"] = {spellKey = _R, isTargeted = true, name = "Lunar Rush", spellName = "LunarRush", spellDelay = 250, range = 825, type = "LINE"},
    }},
    ["Draven"] = {charName = "Draven", skillshots = {
        ["DravenFury"] = { spellKey = _W, isSelfCast = true, isAutoBuff = true, noAnimation = true, spellName = "DravenFury", name = "DravenFury", range = 550, },
        ["DravenSpinning"] = { spellKey = _Q, isSelfCast = true, isAutoBuff = true, noAnimation = true, spellName = "DravenSpinning", name = "DravenSpinning", range = 550, },
        ["DravenDoubleShot"] = {spellKey = _E, name = "Stand Aside", spellName = "DravenDoubleShot", spellDelay = 250, projectileName = "Draven_E_mis.troy", projectileSpeed = 1400, range = 1100, radius = 130, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["DravenRCast"] = {spellKey = _R, isExecute = true, name = "DravenR", spellName = "DravenRCast", spellDelay = 500, projectileName = "Draven_R_mis!.troy", projectileSpeed = 2000, range = 25000, radius = 160, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Elise"] = {charName = "Elise", skillshots = {
        ["EliseHumanE"] = {spellKey = _E, isCollision = true, name = "Cocoon", checkName = true, spellName = "EliseHumanE", spellDelay = 250, projectileName = "Elise_human_E_mis.troy", projectileSpeed = 1450, range = 1100, radius = 70, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["EliseHumanQ"] = {spellKey = _Q, isTargeted = true, checkName = true, name = "Neurotoxin", spellName = "EliseHumanQ", spellDelay = 250, range = 625, type = "LINE", fuckedUp = false, blockable = true, danger = 1, fuckedUp = false, blockable = true, danger = 1},
        ["Venomous Bite"] = {spellKey = _Q, isTargeted = true, checkName = true, name = "Venomous Bite", spellName = "EliseSpiderQCast", spellDelay = 250, range = 475, type = "LINE"},
        ["Skittering Frenzy"] = {spellKey = _W, isSelfCast = true, checkName = true, name = "Skittering Frenzy", spellName = "EliseSpiderW", spellDelay = 250, range = 300, type = "CIRCULAR"},
        ["EliseHumanW"] = {spellKey = _W, isCollision = true, name = "Volatile Spiderling", checkName = true, spellName = "EliseHumanW", spellDelay = 250, projectileName = "Elise_human_E_mis.troy", projectileSpeed = 1450, range = 950, radius = 100, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        
    }},
    ["Ezreal"] = {charName = "Ezreal", skillshots = {
        ["EzrealMysticShot"]             = {spellKey = _Q, isCollision = true, name = "Mystic Shot",      spellName = "EzrealMysticShot", spellDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy",  projectileSpeed = 2000, range = 1100, radius = 80, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["EzrealEssenceFlux"]            = {spellKey = _W, name = "Essence Flux",     spellName = "EzrealEssenceFlux",     spellDelay = 250, projectileName = "Ezreal_essenceflux_mis.troy", projectileSpeed = 1500, range = 900,  radius = 80,  type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["EzrealMysticShotPulse"] = {name = "Mystic Shot",      spellName = "EzrealMysticShotPulse", spellDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy",  projectileSpeed = 2000, range = 1200,  radius = 80,  type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["EzrealTrueshotBarrage"]        = {spellKey = _R, isExecute = true, name = "Trueshot Barrage", spellName = "EzrealTrueshotBarrage", spellDelay = 1000, projectileName = "Ezreal_TrueShot_mis.troy", projectileSpeed = 2000, range = 20000, radius = 160, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Evelynn"] = {charName = "Evelynn", skillshots = {
    --unfinished
        ["Ravage"] = {spellKey = _E, isTargeted = true, name = "Ravage", spellName = "Ravage", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 225, type = "LINE"},
        ["Dark Frenzy"] = {spellKey = _W, isSelfCast = true, name = "Dark Frenzy", spellName = "DarkFrenzy", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 125, type = "LINE"},
        ["Hate Spike"] = {spellKey = _Q, isSelfCast = true, name = "Hate Spike", spellName = "HateSpike", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 500, type = "LINE"},
    }},
    
    ["Heimerdinger"] = {charName = "Heimerdinger", skillshots = {
        ["HextechMicroRockets"]   = {spellKey = _W, isCollision = true, name = "Hextech Micro-Rockets",      spellName = "HextechMicroRockets", spellDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy",  projectileSpeed = 1200, range = 1100, radius = 80, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["CH-2ElectronStormGrenade"]    = {spellKey = _E, name = "CH-2 Electron Storm Grenade",     spellName = "CH-2ElectronStormGrenade",     spellDelay = 250, projectileName = "Ezreal_essenceflux_mis.troy", projectileSpeed = 1750, range = 925,  radius = 80,  type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["FiddleSticks"] = {charName = "FiddleSticks", skillshots = {
        ["DarkWind"] = {spellKey = _E, isTargeted = true, name = "Dark Wind", spellName = "DarkWind", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 750, projectileSpeed = 1500, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Fiora"] = {charName = "Fiora", skillshots = {
        ["FioraQ"] = { spellKey = _Q, isTargeted = true, spellName = "FioraQ", name = "FioraQ", range = 600,},
        ["FioraFlurry"] = { spellKey = _E, isSelfCast = true, isAutoBuff = true, noAnimation = true, spellName = "FioraFlurry", name = "FioraFlurry", range = 500, projectileSpeed = 0, projectileName = "AnnieBasicAttack_mis.troy",},
        ["FioraDance"] = { spellKey = _R, isTargeted = true, isExecute = true, spellName = "FioraDance", name = "FioraDance", range = 400, },
        --["FioraRiposte"] = { spellKey = _W, castType = 0, spellName = "FioraRiposte", name = "FioraRiposte", range = 20, projectileSpeed = 0, projectileName = "AnnieBasicAttack_mis.troy",},
    }},
    ["Fizz"] = {charName = "Fizz", skillshots = {
        ["Leap Strike"] = {spellKey = _Q, isTargeted = true, name = "Leap Strike", spellName = "LeapStrike", spellDelay = 250, range = 700,},
        ["Seastone Trident"] = {spellKey = _W, isSelfCast = true, isAutoBuff = true, noAnimation = true, name = "Seastone Trident", spellName = "SeastoneTrident", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 600, type = "CIRCULAR"},
        --["Fizz Ultimate"] = {name = "Fizz ULT", spellName = "FizzMarinerDoom", spellDelay = 250, projectileName = "Fizz_UltimateMissile.troy", projectileSpeed = 1350, range = 1275, radius = 80, type = "LINE"},
        ["FizzMarinerDoom"] = {name = "Fizz ULT", spellName = "FizzMarinerDoom", castDelay = 250, projectileName = "Fizz_UltimateMissile.troy", projectileSpeed = 1350, range = 1275, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Galio"] = {charName = "Galio", skillshots = {
        ["GalioResoluteSmite"] =  { spellKey = _Q, name = "GalioResoluteSmite", spellName = "GalioResoluteSmite", spellDelay = 250, projectileName = "galio_concussiveBlast_mis.troy", projectileSpeed = 850, range = 2000, radius = 200, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["GalioRighteousGust"] = { spellKey = _E, type = "LINE", spellName = "GalioRighteousGust", name = "GalioRighteousGust", range = 1180, projectileSpeed = 1200, radius = 120,},
        ["GalioBulwark"] = { spellKey = _W, isTargeted = true, isShield = true, spellName = "GalioBulwark", name = "GalioBulwark", range = 800, },
        ["GalioIdolOfDurand"] = { spellKey = _R, isSelfCast = true, channelDuration = 2000, spellName = "GalioIdolOfDurand", name = "GalioIdolOfDurand", range = 600, },
    }},
    ["Gangplank"] = {charName = "Gangplank", skillshots = {
        ["RaiseMorale"] = { spellKey = _E, isSelfCast = true, isAutoBuff = true, spellName = "RaiseMorale", name = "RaiseMorale", range = 125, projectileName = "pirate_raiseMorale_mis.troy",},
        --["CannonBarrage"] = { spellKey = _R, castType = 0, spellName = "CannonBarrage", name = "CannonBarrage", range = 20000, projectileName = "missing_instant.troy",},
        ["Parley"] = { spellKey = _Q, isTargeted = true, spellName = "Parley", name = "Parley", range = 625, projectileName = "pirate_parley_mis.troy",},
        --["RemoveScurvy"] = { spellKey = _W, castType = 0, spellName = "RemoveScurvy", name = "RemoveScurvy", range = 20,},
    }},
    ["Gragas"] = {charName = "Gragas", skillshots = {
        ["GragasBarrelRoll"] = {spellKey = _Q, name = "Barrel Roll", spellName = "GragasBarrelRoll", spellDelay = 250, projectileName = "gragas_barrelroll_mis.troy", projectileSpeed = 1000, range = 950, radius = 100, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Barrel Roll Missile"] = {name = "Barrel Roll Missile", spellName = "GragasBarrelRollMissile", spellDelay = 0, projectileName = "gragas_barrelroll_mis.troy", projectileSpeed = 1000, range = 1115, radius = 180, type = "CIRCULAR"},
    }},
    --edit
    ["Graves"] = {charName = "Graves", skillshots = {
        ["GravesClusterShot"] = {spellKey = _Q, name = "Buckshot", spellName = "GravesClusterShot", spellDelay = 250, projectileName = "Graves_ClusterShot_mis.troy", projectileSpeed = 1750, range = 900, radius = 60, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["SmokeScreen"] = {spellKey = _W, name = "Smoke Screen", spellName = "SmokeScreen", spellDelay = 250, projectileName = "Graves_SmokeGrenade_mis.troy", projectileSpeed = 1500, range = 950, radius = 300, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["GravesChargeShot"] = {spellKey = _R, isExecute = true, name = "Collateral Damage", spellName = "GravesChargeShot", spellDelay = 250, projectileName = "Graves_ChargedShot_mis.troy", projectileSpeed = 1500, range = 1000, radius = 100, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Irelia"] = {charName = "Irelia", skillshots = {
        ["IreliaGatotsu"] = { spellKey = _Q, isTargeted = true, spellName = "IreliaGatotsu", name = "IreliaGatotsu", range = 650,},
        ["IreliaEquilibriumStrike"] = { spellKey = _E, isTargeted = true, spellName = "IreliaEquilibriumStrike", name = "IreliaEquilibriumStrike", range = 425,
            castReq = function (target) return myHero.health < target.health end},
        ["IreliaTranscendentBlades"] = { spellKey = _R, type = "LINE", spellName = "IreliaTranscendentBlades", name = "IreliaTranscendentBlades", range = 1200, projectileSpeed = 1600, projectileName = "Irelia_ult_dagger_mis.troy", radius = 120,},
        ["IreliaHitenStyle"] = { spellKey = _W, isSelfCast = true, noAnimation = true, spellName = "IreliaHitenStyle", name = "IreliaHitenStyle", range = math.huge,},
    }},
    ["Janna"] = {charName = "Janna", skillshots = {
        ["HowlingGale"] = { spellKey = _Q, type = "LINE", spellName = "HowlingGale", name = "HowlingGale", range = 1100, projectileName = "HowlingGale_mis.troy", radius = 150, fuckedUp = false, blockable = true, danger = 1},
        ["Zephyr"] = {spellKey = _W, isTargeted = true, name = "Zephyr", spellName = "Zephyr", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 600, projectileSpeed = 1500, type = "LINE"},
        ["Eye Of The Storm"] = {spellKey = _E, isTargeted = true, isShield = true, name = "Eye Of The Storm", spellName = "EyeOfTheStorm", spellDelay = 250, range = 800, type = "CIRCULAR",
            damage = function () return 40 + 40 * myHero:GetSpellData(_E).level + myHero.ap * .7 end
            },
    }},
    ["Jax"] = {charName = "Jax", skillshots = {
    --unfinished
        ["Leap Strike"] = {spellKey = _Q, isTargeted = true, name = "Leap Strike", spellName = "LeapStrike", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 700, type = "CIRCULAR"},
        ["Empower"] = {spellKey = _W, isSelfCast = true, isAutoReset = true, name = "Empower", spellName = "Empower", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 125, type = "CIRCULAR"},
    }},
    ["Jayce"] = {charName = "Jayce", skillshots = {
        ["JayceToTheSkies"] = {spellKey = _Q, isTargeted = true, checkName = true, name = "JayceQ", spellName = "JayceToTheSkies", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 600, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Thundering Blow"] = {spellKey = _E, isTargeted = true, checkName = true, name = "Thundering Blow", spellName = "JayceThunderingBlow", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 240, type = "LINE"},
        ["Hyper Charge"] = {spellKey = _W, isSelfCast = true, checkName = true, isAutoReset = true, name = "Hyper Charge", spellName = "jaycehypercharge", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 500, type = "CIRCULAR"},
        ["JayceStaticField"] = {spellKey = _W, isSelfCast = true, checkName = true, name = "Lightning Field", spellName = "JayceStaticField", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 285, type = "CIRCULAR"},
        ["jayceshockblast"] = {spellKey = _Q, isCollision = true, checkName = true, name = "JayceShockBlast", spellName = "jayceshockblast", spellDelay = 250, projectileName = "JayceOrbLightning.troy", projectileSpeed = 1450, range = 1050, radius = 70, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["JayceShockBlastCharged"] = {name = "JayceShockBlastCharged", spellName = "JayceShockBlast", spellDelay = 250, projectileName = "JayceOrbLightningCharged.troy", projectileSpeed = 2350, range = 1600, radius = 70, type = "LINE"},
    }},
    ["Jinx"] = {charName = "Jinx", skillshots = {
        ["JinxWMissile"] =  {spellKey = _W, isCollision = true, name = "Zap", spellName = "JinxWMissile", spellDelay = 600, projectileName = "Jinx_W_mis.troy", projectileSpeed = 3300, range = 1450, radius = 70, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["JinxRWrapper"] =  {name = "Super Mega Death Rocket", spellName = "JinxRWrapper", spellDelay = 600, projectileName = "Jinx_R_Mis.troy", projectileSpeed = 2200, range = 20000, radius = 120, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }}, 
    ["Karthus"] = {charName = "Karthus", skillshots = {
        ["Lay Waste"] = {spellKey = _Q, name = "Lay Waste", spellName = "LayWaste", spellDelay = 750, spellAnimationDelay = 250, projectileName = "LayWaste_point.troy", range = 875, radius = 50, type = "CIRCULAR"},
    }},
    ["Karma"] = {charName = "Karma", skillshots = {
    --unfinished
        ["Focused Resolve"] = {spellKey = _W, isTargeted = true, name = "Focused Resolve", spellName = "FocusedResolve", spellDelay = 250, range = 650, projectileName = "swain_shadowGrasp_transform.troy", type = "LINE"},
        ["Mantra"] = {spellKey = _R, isSelfCast = true, name = "Mantra", spellName = "Mantra", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 950, type = "CIRCULAR"},
        ["KarmaQ"] = {spellKey = _Q, isCollision = true, name = "KarmaQ", spellName = "KarmaQ", spellDelay = 250, projectileName = "TEMP_KarmaQMis.troy", projectileSpeed = 1700, range = 950, radius = 90, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["KarmaSolKimShield"] = { spellKey = _E, isTargeted = true, isShield = true, spellName = "KarmaSolKimShield", name = "KarmaSolKimShield", range = 800, noAnimation = true,
            damage = function () return 40 + myHero.ap * .5 + 40 * myHero:GetSpellData(_E).level end},
    }},
    ["Kassadin"] = {charName = "Kassadin", skillshots = {
    --unfinished
        ["NullSphere"] = {spellKey = _Q, isTargeted = true, name = "Null Sphere", spellName = "NullSphere", spellDelay = 250, range = 650, projectileName = "swain_shadowGrasp_transform.troy", type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Nether Blade"] = {spellKey = _W, isSelfCast = true, isAutoReset = true, isAutoBuff = true, noAnimation = true, name = "Nether Blade", spellName = "NetherBlade", spellDelay = 250, range = 250, type = "CIRCULAR"},
        ["Force Pulse"] = {spellKey = _E, isTrueRange = true, name = "Force Pulse", spellName = "ForcePulse", spellDelay = 250, range = 700, radius = 200, type = "LINE"},
    }},
    
    ["Katarina"] = {charName = "Katarina", skillshots = {
        ["KatarinaE"] = { spellKey = _E, isTargeted = true, spellName = "KatarinaE", name = "KatarinaE", range = 700, projectileSpeed = 0, projectileName = "AnnieBasicAttack_mis.troy",},
        ["KatarinaW"] = { spellKey = _W, isSelfCast = true, spellName = "KatarinaW", name = "KatarinaW", range = 375, projectileSpeed = 1400, projectileName = "Disintegrate_mis.troy",},
        ["KatarinaR"] = { spellKey = _R, isSelfCast = true, channelDuration = 2500, spellName = "KatarinaR", name = "KatarinaR", range = 550, projectileName = "katarina_deathLotus_mis.troy", fuckedUp = false, blockable = true, danger = 1},
        ["KatarinaQ"] = { spellKey = _Q, isTargeted = true, spellName = "KatarinaQ", name = "KatarinaQ", range = 675, projectileSpeed = 1100, projectileName = "katarina_bouncingBlades_mis.troy", fuckedUp = false, blockable = true, danger = 1},
    }}, 
    ["Kayle"] = {charName = "Kayle", skillshots = {
    --unfinished
        ["Reckoning"] = {spellKey = _Q, isTargeted = true, name = "Reckoning", spellName = "Reckoning", spellDelay = 250, range = 650, fuckedUp = false, blockable = true, danger = 1},
        ["DivineBlessing"] = {spellKey = _W, isTargeted = true, isHeal = true, name = "Divine Blessing", spellName = "DivineBlessing", spellDelay = 250, range = 900, type = "LINE"},
        ["Righteous Fury"] = {spellKey = _E, isSelfCast = true, noAnimation = true, name = "Righteous Fury", spellName = "RighteousFury", spellDelay = 250, range = 650},
        ["JudicatorIntervention"] = { spellKey = _R, isTargeted = true, isShield = true, isUntargetable = true, spellName = "JudicatorIntervention", name = "JudicatorIntervention", range = 900,},
    }},
    ["Kennen"] = {charName = "Kennen", skillshots = {
        ["KennenShurikenHurlMissile1"] = {spellKey = _Q, isCollision = true, name = "Thundering Shuriken", spellName = "KennenShurikenHurlMissile1", spellDelay = 180, projectileName = "kennen_ts_mis.troy", projectileSpeed = 1700, range = 1050, radius = 50, type = "LINE", fuckedUp = false, blockable = true, danger = 1}
    }},
    ["Khazix"] = {charName = "Khazix", skillshots = {
        ["KhazixQ"] = {spellKey = _Q, isTargeted = true, name = "KhazixQ", spellName = "KhazixQ", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 375, type = "LINE"},
        ["KhazixW"] = {spellKey = _W, isCollision = true, name = "KhazixW", spellName = "KhazixW", spellDelay = 250, projectileName = "Khazix_W_mis_enhanced.troy", projectileSpeed = 1700, range = 1000, radius = 70, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["khazixwlong"] = {name = "khazixwlong", spellName = "khazixwlong", spellDelay = 250, projectileName = "Khazix_W_mis_enhanced.troy", projectileSpeed = 1700, range = 1025, radius = 70, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["KogMaw"] = {charName = "KogMaw", skillshots = {
        ["CausticSpittle"] = {spellKey = _Q, isTargeted = true, name = "Caustic Spittle", spellName = "CausticSpittle", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 625, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Bio-Arcane Barrage"] = {spellKey = _W, isSelfCast = true, isAutoBuff = true, name = "Bio-Arcane Barrage", spellName = "BioArcaneBarrage", spellDelay = 250, range = 600, type = "CIRCULAR"},
        ["KogMawVoidOozeMissile"] = {spellKey = _E, name = "Void Ooze", spellName = "KogMawVoidOozeMissile", spellDelay = 250, projectileName = "KogMawVoidOoze_mis.troy", projectileSpeed = 1450, range = 1200, radius = 100, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Living Artillery"] = {spellKey = _R, name = "Living Artillery", spellName = "KogMawLivingArtillery", spellDelay = 850, projectileName = "KogMawLivingArtillery_mis.troy", range = 2200, radius = 100, type = "CIRCULAR"}
    }},
    ["Leblanc"] = {charName = "Leblanc", skillshots = {
        --unfinished
        ["SigilQ"] = {spellKey = _Q, isTargeted = true, name = "Sigil of Silence", spellName = "SigilQ", spellDelay = 250, projectileName = "non.troy", range = 700, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["LeblancChaosOrbM"] = {spellKey = _R, isTargeted = true, checkName = true, name = "Sigil of Silence R", spellName = "LeblancChaosOrbM", spellDelay = 250, projectileName = "non.troy", range = 700, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["LeblancSoulShackle"] = {spellKey = _E, isCollision = true, name = "Ethereal Chains", spellName = "LeblancSoulShackle", spellDelay = 250, projectileName = "leBlanc_shackle_mis.troy", projectileSpeed = 1600, range = 960, radius = 70, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["LeblancSoulShackleM"] = {name = "Ethereal Chains R", spellName = "LeblancSoulShackleM", spellDelay = 250, projectileName = "leBlanc_shackle_mis_ult.troy", projectileSpeed = 1600, range = 960, radius = 70, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["LeeSin"] = {charName = "LeeSin", skillshots = {
        ["BlindMonkQOne"] = {spellKey = _Q, isCollision = true, checkName = true, name = "Sonic Wave", spellName = "BlindMonkQOne", spellDelay = 250, projectileName = "blindMonk_Q_mis_01.troy", projectileSpeed = 1800, range = 975, radius = 70, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["blindmonkqtwo"] = {spellKey = _Q, checkName = true, isSelfCast = true, name = "Sonic Wave2", spellName = "blindmonkqtwo", spellDelay = 250, range = 975, radius = 70, type = "LINE"},
        ["BlindMonkEOne"] = { spellKey = _E, isSelfCast = true, spellName = "BlindMonkEOne", name = "BlindMonkEOne", range = 350, },        
        ["BlindMonkRKick"] = { spellKey = _R, isTargeted = true, isExecute = true, spellName = "BlindMonkRKick", name = "BlindMonkRKick", range = 375, projectileSpeed = 1500,},
    }},
    ["Leona"] = {charName = "Leona", skillshots = {
        ["LeonaShieldOfDaybreakAttack"] = {spellKey = _Q, isTargeted = true, isAutoReset = true, name = "Shield of Daybreak", spellName = "LeonaShieldOfDaybreakAttack", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 125, type = "CIRCULAR"},
        ["LeonaSolarBarrier"] = { spellKey = _W, isSelfCast = true, spellName = "LeonaSolarBarrier", name = "LeonaSolarBarrier", range = 275, },
        ["Zenith Blade"] = {spellKey = _E, name = "Zenith Blade", spellName = "LeonaZenithBlade", spellDelay = 250, projectileName = "Leona_ZenithBlade_mis.troy", projectileSpeed = 2000, range = 900, radius = 80, type = "LINE"},
        ["Leona Solar Flare"] = {spellKey = _R, name = "Leona Solar Flare", spellName = "LeonaSolarFlare", spellDelay = 250, projectileName = "Leona_SolarFlare_cas.troy", projectileSpeed = 2000, range = 1200, radius = 300, type = "CIRCULAR"}
    }},
    ["Lissandra"] = {charName = "Lissandra", skillshots = {
        ["LissandraW"] = { spellKey = _W, isSelfCast = true, isRoot = true, spellName = "LissandraW", name = "LissandraW", range = 450, },
        ["LissandraR"] = { spellKey = _R, isTargeted = true, isStun = true, spellName = "LissandraR", name = "LissandraR", range = 550, },
        --find projectile speed
        ["LissandraQ"] = { spellKey = _Q, type = "LINE", spellName = "LissandraQ", name = "LissandraQ", projectileName = "Lissandra_Q_Shards.troy", projectileSpeed = 1400, range = 725, radius = 75, fuckedUp = false, blockable = true, danger = 1},
        --["LissandraE"] = { spellKey = _E, castType = 0, spellName = "LissandraE", name = "LissandraE", range = 25000, projectileSpeed = 850, projectileName = "Lissandra_E_Missile.troy", radius = 110,},
        ["LissandraE"] = {name = "LissandraE", spellName = "LissandraE", castDelay = 250, projectileName = "Lissandra_E_Missle.troy", projectileSpeed = 850, range = 1500, radius = 140, fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Lucian"] = {charName = "Lucian", skillshots = {
        ["LucianQ"] =  {spellKey = _Q, name = "LucianQ", isTargeted = true, spellName = "LucianQ", spellDelay = 350, projectileName = "Lucian_Q_laser.troy", range = 570, radius = 65, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["LucianW"] =  {spellKey = _W, name = "LucianW", spellName = "LucianW", spellDelay = 300, projectileName = "Lucian_W_mis.troy", projectileSpeed = 1600, range = 1000, radius = 80, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Lulu"] = {charName = "Lulu", skillshots = {
        ["LuluQ"] = {spellKey = _Q, name = "LuluQ", spellName = "LuluQ", spellDelay = 250, projectileName = "Lulu_Q_Mis.troy", projectileSpeed = 1450, range = 1000, radius = 50, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["LuluW"] = { spellKey = _W, isTargeted = true, isStun = true, spellName = "LuluW", name = "LuluW", range = 650, },
        ["LuluE"] = { spellKey = _E, isTargeted = true, isShield = true, spellName = "LuluE", name = "LuluE", range = 650,
            damage = function () return 40 + 40 * myHero:GetSpellData(_E).level + myHero.ap * .6 end,},
        ["LuluR"] = { spellKey = _R, isTargeted = true, isShield = true, spellName = "LuluR", name = "LuluR", range = 900,
            damage = function () return 150 + 150 * myHero:GetSpellData(_W).level + myHero.ap * .5 end,},
    }},
    ["Lux"] = {charName = "Lux", skillshots = {
        ["LuxLightBinding"] =  {spellKey = _Q, isCollision = true, name = "Light Binding", spellName = "LuxLightBinding", spellDelay = 250, projectileName = "LuxLightBinding_mis.troy", projectileSpeed = 1200, range = 1175, radius = 80, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["LuxLightStrikeKugel"] = {spellKey = _W, name = "LuxLightStrikeKugel", spellName = "LuxLightStrikeKugel", spellDelay = 250, projectileName = "LuxLightstrike_mis.troy", projectileSpeed = 1400, range = 1100, radius = 275, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["LuxMaliceCannon"] =  {spellKey = _R, isExecute = true, name = "Lux Malice Cannon", spellName = "LuxMaliceCannon", spellDelay = 950, projectileName = "Enrageweapon_buf_02.troy", range = 3500, radius = 190, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        --["LuxPrismaticWave"] = { spellKey = _W, castType = 0, spellName = "LuxPrismaticWave", name = "LuxPrismaticWave", range = 10000, radius = 150,},
    }},
    ["MasterYi"] = {charName = "Master Yi", skillshots = {
    --unfinished
        ["Alpha Strike"] = {spellKey = _Q, isTargeted = true, isUntargetable = true, name = "Alpha Strike", spellName = "AlphaStrike", spellDelay = 250, range = 600,},
        ["Wuju Style"] = {spellKey = _E, isSelfCast = true, isAutoBuff = true, noAnimation = true, name = "Wuju Style", spellName = "WujuStyle", },
        ["Meditate"] = { spellKey = _W, isSelfCast = true, isAutoReset = true, spellName = "Meditate", name = "Meditate", range = 200, },
    }},
    ["Malzahar"] = {charName = "Malzahar", skillshots = {
        ["Null Zone"] = {spellKey = _W, name = "Null Zone", spellName = "NullZone", spellDelay = 600, range = 800, radius = 250, type = "CIRCULAR"},
        ["Malefic Visions"] = {spellKey = _E, isTargeted = true, name = "Malefic Visions", spellName = "MaleficVisions", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 650, type = "LINE"},
        ["Nether Grasp"] = {spellKey = _R, isTargeted = true, channelDuration = 2500, name = "Nether Grasp", spellName = "NetherGrasp", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 700, type = "LINE"},
    }},
    ["Malphite"] = {charName = "Malphite", skillshots = {
        ["SeismicShard"] = {spellKey = _Q, isTargeted = true, name = "Seismic Shard", spellName = "SeismicShard", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 625, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Ground Slam"] = {spellKey = _E, isSelfCast = true, name = "Ground Slam", spellName = "GroundSlam", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 200, type = "CIRCULAR"},
        ["Brutal Strikes"] = {spellKey = _W, isSelfCast = true, noAnimation = true, isAutoBuff = true, name = "Brutal Strikes", spellName = "BrutalStrikes", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 200, type = "CIRCULAR"},
        ["UFSlash"] = {name = "UFSlash", spellName = "UFSlash", spellDelay = 250, projectileName = "TEST", projectileSpeed = 1800, range = 1000, radius = 160, type = "LINE"},    
    }},
    ["Maokai"] = {charName = "Maokai", skillshots = {
        ["MaokaiUnstableGrowth"] = { spellKey = _W, isTargeted = true, spellName = "MaokaiUnstableGrowth", name = "MaokaiUnstableGrowth", range = 650, },
        ["MaokaiTrunkLine"] = { spellKey = _Q, type = "LINE", spellName = "MaokaiTrunkLine", name = "MaokaiTrunkLine", range = 600, projectileSpeed = 1200, radius = 110, fuckedUp = false, blockable = true, danger = 1},
        ["MaokaiDrain3"] = { spellKey = _R, type = "CIRCULAR", spellName = "MaokaiDrain3", name = "MaokaiDrain3", range = 625, radius = 575,},
        ["MaokaiSapling2"] = { spellKey = _E, type = "LINE", spellName = "MaokaiSapling2", name = "MaokaiSapling2", range = 1100, projectileSpeed = 1750, projectileName = "Maokai_sapling_mis.troy", radius = 175},
    }},
    ["Mordekaiser"] = {charName = "Mordekaiser", skillshots = {
        ["MordekaiserMaceOfSpades"] = { spellKey = _Q, isAutoReset = true, spellName = "MordekaiserMaceOfSpades", name = "MordekaiserMaceOfSpades", range = 125,},
        ["MordekaiserCreepingDeathCast"] = { spellKey = _W, isTargeted = true, isShield = true, spellName = "MordekaiserCreepingDeathCast", name = "MordekaiserCreepingDeathCast", range = 750, projectileName = "mordekaiser_creepingDeath_mis.troy", radius = 200,},
        ["MordekaiserChildrenOfTheGrave"] = { spellKey = _R, isTargeted = true, isExecute = true, spellName = "MordekaiserChildrenOfTheGrave", name = "MordekaiserChildrenOfTheGrave", range = 850,},
        ["MordekaiserSyphonOfDestruction"] = { spellKey = _E, type = "LINE", spellName = "MordekaiserSyphonOfDestruction", name = "MordekaiserSyphonOfDestruction", range = 700, radius = 200},
    }},
    ["Morgana"] = {charName = "Morgana", skillshots = {
        ["DarkBindingMissile"] = {spellKey = _Q, isCollision = true, name = "Dark Binding", spellName = "DarkBindingMissile", spellDelay = 250, projectileName = "DarkBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["TormentedSoil"] = { spellKey = _W, spellName = "TormentedSoil", name = "TormentedSoil", range = 900, radius = 175, type = "CIRCULAR"},
        --["SoulShackles"] = { spellKey = _R, castType = 0, spellName = "SoulShackles", name = "SoulShackles", range = 625, projectileName = "AnnieBasicAttack_mis.troy",},
        --["BlackShield"] = { spellKey = _E, castType = 0, spellName = "BlackShield", name = "BlackShield", range = 750, projectileName = "AnnieBasicAttack_mis.troy",},

    }},
    ["DrMundo"] = {charName = "DrMundo", skillshots = {
        ["InfectedCleaverMissile"] = {spellKey = _Q, isCollision = true, name = "Infected Cleaver", spellName = "InfectedCleaverMissile", spellDelay = 250, projectileName = "dr_mundo_infected_cleaver_mis.troy", projectileSpeed = 2000, range = 1000, radius = 75, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        --["BurningAgony"] = { spellKey = _W, isSelfCast = true, spellName = "BurningAgony", name = "BurningAgony", range = 325, projectileName = "AnnieBasicAttack_mis.troy",},
        ["Sadism"] = { spellKey = _R, isSelfCast = true, isHeal = true, spellName = "Sadism", name = "Sadism", range = math.huge, projectileName = "dr_mundo_sadism_cas_02.troy",},
        ["Masochism"] = { spellKey = _E, isSelfCast = true, isAutoBuff = true, spellName = "Masochism", name = "Masochism", range = 300, },
    }},
    ["Nami"] = {charName = "Nami", skillshots = {
        ["NamiQ"] = {spellKey = _Q, name = "NamiQ", spellName = "NamiQ", spellDelay = 850, projectileName = "Nami_Q_mis.troy", range = 875, radius = 100, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1},
        ["Ebb and Flow"] = {spellKey = _W, isTargeted = true, name = "Ebb and Flow", spellName = "EbbAndFlow", spellDelay = 250, range = 725,},
        ["TidecallersBlessing"] = {spellKey = _E, isSelfCast = true, name = "TidecallersBlessing", spellName = "TidecallersBlessing", spellDelay = 250, range = 800, type = "CIRCULAR"},
    }},
    ["Nasus"] = {charName = "Nasus", skillshots = {
    --unfinished
        ["NasusW"] = {spellKey = _W, isTargeted = true, name = "Wither", spellName = "NasusW", spellDelay = 250, range = 600, type = "LINE"},
        ["NasusE"] = {spellKey = _E, spellName = "NasusE", name = "NasusE", range = 650, radius = 400, type = "CIRCULAR" },
        ["NasusQ"] = {spellKey = _Q, isSelfCast = true, isAutoReset = true, name = "Siphoning Strike", spellName = "NasusQ", spellDelay = 250, range = 125, type = "CIRCULAR"},
    }},
    ["Nautilus"] = {charName = "Nautilus", skillshots = {
        ["NautilusAnchorDrag"] = {spellKey = _Q, isCollision = true, name = "Dredge Line", spellName = "NautilusAnchorDrag", spellDelay = 250, projectileName = "Nautilus_Q_mis.troy", projectileSpeed = 2000, range = 1080, radius = 80, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["NautilusPiercingGaze"] = { spellKey = _W, isSelfCast = true, isShield = true, spellName = "NautilusPiercingGaze", name = "NautilusPiercingGaze", range = math.huge, },
        ["NautilusSplashZone"] = { spellKey = _E, isSelfCast = true, spellName = "NautilusSplashZone", name = "NautilusSplashZone", range = 600, },
        ["NautilusGrandLine"] = { spellKey = _R, isTargeted = true, spellName = "NautilusGrandLine", name = "NautilusGrandLine", range = 825, projectileSpeed = 1400, },
    }},
    ["Nidalee"] = {charName = "Nidalee", skillshots = {
        ["JavelinToss"] = {spellKey = _Q, isCollision = true, name = "Javelin Toss", spellName = "JavelinToss", spellDelay = 125, projectileName = "nidalee_javelinToss_mis.troy", projectileSpeed = 1300, range = 1500, radius = 60, type = "LINE", checkName = true, fuckedUp = false, blockable = true, danger = 1},
        ["PrimalSurge"] = { spellKey = _E, isTargeted = true, isHeal = true, spellName = "PrimalSurge", name = "PrimalSurge", range = 600, checkName = true, },
        ["Bushwhack"] = { spellKey = _W, type = "CIRCULAR", spellName = "Bushwhack", name = "Bushwhack", range = 900, radius = 70, checkName = true, },
        
        ["Swipe"] = { spellKey = _E, type = "LINE", spellName = "Swipe", name = "Swipe", range = 400, radius = 200, checkName = true, },
        ["Pounce"] = { spellKey = _W, isSelfCast = true, spellName = "Pounce", name = "Pounce", range = 375, checkName = true, },
        ["Takedown"] = { spellKey = _Q, isSelfCast = true, isAutoReset = true, spellName = "Takedown", name = "Takedown", range = 500, checkName = true, },
        
        --["AspectOfTheCougar"] = { spellKey = _R, castType = 0, spellName = "AspectOfTheCougar", name = "AspectOfTheCougar", range = 20, projectileName = "TeemoBasicAttack_mis.troy",},
    }},
    ["Nocturne"] = {charName = "Nocturne", skillshots = {
        ["NocturneDuskbringer"] =  {spellKey = _Q, name = "NocturneDuskbringer", spellName = "NocturneDuskbringer", spellDelay = 250, projectileName = "NocturneDuskbringer_mis.troy", projectileSpeed = 1400, range = 1200, radius = 60, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Unspeakable Horror"] = {spellKey = _E, isTargeted = true, name = "UnspeakableHorror", spellName = "UnspeakableHorror", spellDelay = 250, range = 425, type = "LINE"},
    }},
    ["Olaf"] = {charName = "Olaf", skillshots = {
        ["OlafAxeThrow"] = {spellKey = _Q, name = "Undertow", spellName = "OlafAxeThrow", spellDelay = 250, projectileName = "olaf_axe_mis.troy", projectileSpeed = 1600, range = 1000, radius = 90, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Reckless Swing"] = {spellKey = _E, isTargeted = true, name = "Reckless Swing", spellName = "RecklessSwing", spellDelay = 250, range = 325, type = "LINE"},
        ["Vicious Strikes"] = {spellKey = _W, isSelfCast = true, isAutoBuff = true, noAnimation = true, name = "Vicious Strikes", spellName = "ViciousStrikes", range = 200},
    }},
    ["Orianna"] = {charName = "Orianna", skillshots = {
        --["OrianaReturn"] = { spellKey = ExtraSpell5, castType = 1, spellName = "OrianaReturn", name = "OrianaReturn", range = 10000, projectileSpeed = 2250, projectileName = "Oriana_Ghost_mis_return.troy", radius = 200,},
        --["OrianaRedact"] = { spellKey = ExtraSpell3, castType = 3, spellName = "OrianaRedact", name = "OrianaRedact", range = 1500, projectileSpeed = 2250, projectileName = "Oriana_Ghost_mis_protect.troy", radius = 80,},
        --["OrianaIzuna"] = { spellKey = ExtraSpell1, castType = 3, spellName = "OrianaIzuna", name = "OrianaIzuna", range = 2000, projectileSpeed = 1350, projectileName = "Oriana_Ghost_mis.troy", radius = 80,},
        --["OrianaDetonateCommand"] = { spellKey = _R, castType = 0, spellName = "OrianaDetonateCommand", name = "OrianaDetonateCommand", range = 410, projectileSpeed = 1200, radius = 80,},
        ["OrianaIzunaCommand"] = { spellKey = _Q, type = "LINE", spellName = "OrianaIzunaCommand", name = "OrianaIzunaCommand", range = 825, projectileSpeed = 1200, radius = 80,},
        
        ["OrianaRedactCommand"] = { spellKey = _E, isTargeted = true, isShield = true, spellName = "OrianaRedactCommand", name = "OrianaRedactCommand", range = 1120, projectileSpeed = 1200, radius = 80,},
        ["OrianaDissonanceCommand"] = { spellKey = _W, isSelfCast = true, spellName = "OrianaDissonanceCommand", name = "OrianaDissonanceCommand", range = math.huge, radius = 80,},
    }},
    ["Pantheon"] = {charName = "Pantheon", skillshots = {
    --unfinished
        ["SpearShot"] = {spellKey = _Q, isTargeted = true, name = "Spear Shot", spellName = "SpearShot", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 600, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1},
        ["Aegis of Zeonia"] = {spellKey = _W, isTargeted = true, name = "Aegis of Zeonia", spellName = "PantheonW", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 600, type = "LINE"},
        ["Pantheon_Heartseeker"] = {spellKey = _E, channelDuration = 750, name = "Heartseeker Strike", spellName = "Pantheon_Heartseeker", spellDelay = 250, projectileName = "Thresh_Q_whip_beam.troy", projectileSpeed = 2000, range = 600, radius = 200, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Poppy"] = {charName = "Poppy", skillshots = {
    --unfinished
        ["Devastating Blow"] = {spellKey = _Q, isTargeted = true, name = "Devastating Blow", spellName = "DevastatingBlow", spellDelay = 250, range = 125, projectileName = "swain_shadowGrasp_transform.troy", type = "LINE"},
        ["Heroic Charge"] = {spellKey = _E, isTargeted = true, name = "Heroic Charge", spellName = "HeroicCharge", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 525, type = "LINE"},
        ["Paragon of Demacia"] = {spellKey = _W, isSelfCast = true, isAutoBuff = true, noAnimation = true, name = "Paragon of Demacia", spellName = "PoppyW", spellDelay = 250, range = 300,},
    }},
    ["Quinn"] = {charName = "Quinn", skillshots = {
        ["QuinnQ"] = {spellKey = _Q, isCollision = true, name = "QuinnQ", spellName = "QuinnQ", spellDelay = 250, projectileName = "Quinn_Q_missile.troy", projectileSpeed = 1550, range = 1050, radius = 80, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["QuinnE"] = { spellKey = _E, isTargeted = true, spellName = "QuinnE", name = "QuinnE", range = 750, },
    }},
    ["Rumble"] = {charName = "Rumble", skillshots = {
        ["RumbleGrenade"] =  {spellKey = _E, name = "RumbleGrenade", spellName = "RumbleGrenade", spellDelay = 250, projectileName = "rumble_taze_mis.troy", projectileSpeed = 2000, range = 800, radius = 90, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Flamespitter"] =  {spellKey = _Q, name = "Flamespitter", spellName = "Flamespitter", spellDelay = 250, range = 650, radius = 90, type = "CIRCULAR"},
        ["RumbleShield"] = { spellKey = _W, isSelfCast = true, isShield = true, spellName = "RumbleShield", name = "RumbleShield", range = math.huge, 
            damage = function () return 20 + 30 * myHero:GetSpellData(_W).level + myHero.ap * .4 end,},
    }},
    ["Rengar"] = {charName = "Rengar", skillshots = {
    --unfinished
        ["RengarE"] = {spellKey = _E, isTargeted = true, name = "Bola Strike", spellName = "RengarE", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 575, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Savagery"] = {spellKey = _Q, isSelfCast = true, isAutoReset = true, name = "Savagery", spellName = "Savagery", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 125, type = "CIRCULAR"},
        --["Empowered Savagery"] = {spellKey = _Q, isSelfCast = true, isAutoReset = true, hasBuff="" ,name = "Empowered Savagery", spellName = "EmpoweredSavagery", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 125, type = "CIRCULAR"},
        ["Battle Roar"] = {spellKey = _W, isSelfCast = true, noAnimation = true, name = "Battle Roar", spellName = "RengarQ", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 500, type = "CIRCULAR"},
    }},
    ["Renekton"] = {charName = "Renekton", skillshots = {
    --unfinished
        ["Ruthless Predator"] = {spellKey = _W, isTargeted = true, isAutoReset = true, name = "Ruthless Predator", spellName = "RuthlessPredator", spellDelay = 250, range = 125, projectileName = "swain_shadowGrasp_transform.troy", type = "LINE"},
        ["Cull the Meek"] = {spellKey = _Q, isSelfCast = true, isTrueRange = true, name = "Cull the Meek", spellName = "RenektonQ", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 225, type = "CIRCULAR"},
        ["Slice And Dice"] = {spellKey = _E, name = "Slice", spellName = "Slice", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 450, radius = 200, type = "LINE"},
    }},
    ["Riven"] = {charName = "Riven", skillshots = {
    --unfinished
        ["Ki Burst"] = {spellKey = _W, isSelfCast = true, name = "Ki Burst", spellName = "RivenW", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 125, type = "CIRCULAR"},
        ["Broken Wings"] = {spellKey = _Q, name = "Broken Wings", spellName = "RivenTriCleave", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 260, radius = 200, type = "LINE"},
        ["Valor"] = {spellKey = _E, name = "Valor", spellName = "Valor", spellDelay = 250, projectileName = "Thresh_Q_whip_beam.troy", range = 325, radius = 200, type = "LINE"},
        ["RivenR"] = {spellKey = _R, name = "Blade of the Exile", spellName = "RivenR", spellDelay = 250, projectileName = "Thresh_Q_whip_beam.troy", range = 900, radius = 200, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Ryze"] = {charName = "Ryze", skillshots = {
    --unfinished
        ["Overload"] = {spellKey = _Q, isTargeted = true, name = "Overload", spellName = "Overload", spellDelay = 250, range = 600, projectileName = "Overload_mis.troy", type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Rune Prison"] = {spellKey = _W, isTargeted = true, name = "Rune Prison", spellName = "RunePrison", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 600, type = "LINE"},
        ["SpellFlux"] = {spellKey = _E, isTargeted = true, name = "Spell Flux", spellName = "SpellFlux", spellDelay = 250, projectileName = "SpellFlux_mis.troy", range = 600, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Desperate Power"] = {spellKey = _R, isSelfCast = true, name = "Desperate Power", spellName = "Desperate Power", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 600, type = "CIRCULAR"},
    }},
    ["Sejuani"] = {charName = "Sejuani", skillshots = {
        ["SejuaniR"] = {name = "SejuaniR", spellName = "SejuaniGlacialPrisonCast", spellDelay = 250, projectileName = "Sejuani_R_mis.troy", projectileSpeed = 1600, range = 1200, radius = 110, type = "LINE"},    
    }},
    ["Shaco"] = {charName = "Shaco", skillshots = {
        ["TwoShivPoison"] = { spellKey = _E, isTargeted = true, spellName = "TwoShivPoison", name = "TwoShivPoison", range = 625, projectileName = "JesterDagger.troy", fuckedUp = false, blockable = true, danger = 1},
        --["HallucinateFull"] = { spellKey = _R, castType = 0, spellName = "HallucinateFull", name = "HallucinateFull", range = 500, projectileName = "AnnieBasicAttack_mis.troy",},
        --["Deceive"] = { spellKey = _Q, castType = 0, spellName = "Deceive", name = "Deceive", range = 25000, projectileName = "AnnieBasicAttack_mis.troy",},
        --["JackInTheBox"] = { spellKey = _W, type = "CIRCULAR", spellName = "JackInTheBox", name = "JackInTheBox", range = 425, projectileName = "TristannaBasicAttack4_mis.troy",},
    }},
    ["Shen"] = {charName = "Shen", skillshots = {
        ["ShadowDash"] = {name = "ShadowDash", spellName = "ShenShadowDash", spellDelay = 0, projectileName = "shen_shadowDash_mis.troy", projectileSpeed = 3000, range = 575, radius = 50, type = "LINE"},
        ["ShenVorpalStar"] = { spellKey = _Q, isTargeted = true, spellName = "ShenVorpalStar", name = "ShenVorpalStar", range = 475, projectileSpeed = 1500, projectileName = "shen_vorpalStar_mis.troy"},
        ["ShenFeint"] = { spellKey = _W, isShield = true, isSelfCast = true, spellName = "ShenFeint", name = "ShenFeint", range = math.huge, 
            damage = function () return 20 + 40 * myHero:GetSpellData(_W).level + myHero.ap * .6 end,},
        --["ShenStandUnited"] = { spellKey = _R, castType = 0, spellName = "ShenStandUnited", name = "ShenStandUnited", range = 25000, projectileName = "AnnieBasicAttack_mis.troy",},
    }},
    ["Shyvana"] = {charName = "Shyvana", skillshots = { 
        ["ShyvanaDoubleAttack"] = { spellKey = _Q, isSelfCast = true, isAutoReset = true, spellName = "ShyvanaDoubleAttack", name = "ShyvanaDoubleAttack", range = 125, },
        ["ShyvanaFireball"] = { spellKey = _E, spellName = "ShyvanaFireball", name = "ShyvanaFireball", range = 925, projectileSpeed = 1200, projectileName = "shyvana_flameBreath_mis.troy", radius = 60, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["ShyvanaImmolationAura"] = { spellKey = _W, isSelfCast = true, noAnimation = true, spellName = "ShyvanaImmolationAura", name = "ShyvanaImmolationAura", range = 150, },
    }}, 
    ["Skarner"] = {charName = "Skarner", skillshots = {
    --unfinished        
        ["Crystal Slash"] = {spellKey = _Q, isSelfCast = true, name = "Crystal Slash", spellName = "CrystalSlash", spellDelay = 250, range = 300, type = "CIRCULAR"},
        ["Fracture"] = {spellKey = _E, name = "Fracture", spellName = "Fracture", spellDelay = 250, projectileName = "TEMP_KarmaQMis.troy", projectileSpeed = 1700, range = 900, radius = 45, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["SkarnerExoskeleton"] = { spellKey = _W, isSelfCast = true, isShield = true, spellName = "SkarnerExoskeleton", name = "SkarnerExoskeleton", range = math.huge, 
            damage = function () return 25 + 55 * myHero:GetSpellData(_W).level + myHero.ap * .8 end,}
    }},
    ["Sion"] = {charName = "Sion", skillshots = {
        ["CrypticGaze"] = { spellKey = _Q, isTargeted = true, isStun = true, spellName = "CrypticGaze", name = "CrypticGaze", range = 550, projectileName = "CrypticGaze_mis.troy",},
        --["DeathsCaressFull"] = { spellKey = _W, castType = 0, spellName = "DeathsCaressFull", name = "DeathsCaressFull", range = 1, projectileName = "AnnieBasicAttack_mis.troy",},
        --["Cannibalism"] = { spellKey = _R, castType = 0, spellName = "Cannibalism", name = "Cannibalism", range = 1,},
        --["Enrage"] = { spellKey = _E, castType = 0, spellName = "Enrage", name = "Enrage", range = 1, projectileName = "FuryoftheAncient_mis.troy",},
    }},
    ["Sivir"] = {charName = "Sivir", skillshots = { --hard to measure speed
        --unfinished
        ["SivirQ"] = {spellKey = _Q, name = "Boomerang Blade", spellName = "SivirQ", spellDelay = 250, projectileName = "Sivir_Base_Q_mis.troy", projectileSpeed = 1350, range = 1075, radius = 101, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Ricochet"] = {spellKey = _W, isSelfCast = true, isAutoReset = true, name = "Ricochet", spellName = "Ricochet", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 550, type = "LINE"},
    }},
    ["Sona"] = {charName = "Sona", skillshots = {
        ["HymnofValor"] = {spellKey = _Q, isSelfCast = true, name = "Hymn of Valor", spellName = "HymnofValor", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 700, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["SonaAriaofPerseverance"] = { spellKey = _W, isSelfCast = true, isHeal = true, spellName = "SonaAriaofPerseverance", name = "SonaAriaofPerseverance", range = 1000,},
        ["SonaCrescendo"] = {name = "Crescendo", spellName = "SonaCrescendo", spellDelay = 250, projectileName = "SonaCrescendo_mis.troy", projectileSpeed = 2400, range = 1000, radius = 150, type = "LINE", fuckedUp = false, blockable = true, danger = 1},      
    }},
    ["Soraka"] = {charName = "Soraka", skillshots = {
        ["Infuse"] = {spellKey = _E, isTargeted = true, name = "Infuse", spellName = "Infuse", spellDelay = 250, range = 725, type = "LINE"},
        ["Starcall"] = {spellKey = _Q, isSelfCast = true, isTrueRange = true, name = "Starcall", spellName = "Starcall", spellDelay = 250, range = 675, type = "CIRCULAR"},        
        ["AstralBlessing"] = {spellKey = _W, isTargeted = true, isHeal = true, spellName = "AstralBlessing", name = "AstralBlessing", range = 750},
        ["Wish"] = { spellKey = _R, isTargeted = true, isHeal = true, spellName = "Wish", name = "Wish", range = math.huge},
    }},
    ["Swain"] = {charName = "Swain", skillshots = {
    --unfinished
        ["Decrepify"] = {spellKey = _Q, isTargeted = true, name = "Decrepify", spellName = "Decrepify", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 625, radius = 125, type = "LINE", fuckedUp = false, blockable = true, danger = 1, fuckedUp = false, blockable = true, danger = 1},
        ["Nevermove"] = {spellKey = _W, name = "Nevermove", spellName = "SwainShadowGrasp", spellDelay = 875, projectileName = "swain_shadowGrasp_transform.troy", range = 900, radius = 125, type = "CIRCULAR"},
        ["Torment"] = {spellKey = _E, isTargeted = true, name = "Torment", spellName = "Torment", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", projectileSpeed = 1000, range = 625, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Syndra"] = {charName = "Syndra", skillshots = {
        ["SyndraQ"] = {name = "SyndraQ", spellName = "SyndraQ", spellDelay = 200, projectileName = "Syndra_Q_cas.troy", projectileSpeed = 300, range = 800, radius = 180, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1}
    }},
    ["Talon"] = {charName = "Talon", skillshots = {
    --unfinished
        ["Noxian Diplomacy"] = {spellKey = _Q, isSelfCast = true, isAutoReset = true, name = "Noxian Diplomacy", spellName = "TalonQ", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 125, type = "CIRCULAR"},
        ["Cutthroat"] = {spellKey = _E, isTargeted = true, name = "Cutthroat", spellName = "Cutthroat", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 700, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1},
        ["Rake"] = {spellKey = _W, name = "Rake", spellName = "Rake", spellDelay = 250, projectileName = "Thresh_Q_whip_beam.troy", projectileSpeed = 2000, range = 600, radius = 200, type = "LINE"},
        ["ShadowAssault"] = {spellKey = _R, isSelfCast = true, name = "Shadow Assault", spellName = "ShadowAssault", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 500, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Taric"] = {charName = "Taric", skillshots = {
        ["Imbue"] = { spellKey = _Q, isTargeted = true, isHeal = true, spellName = "Imbue", name = "Imbue", range = 750, },
        ["Dazzle"] = {spellKey = _E, isTargeted = true, name = "Dazzle", spellName = "Dazzle", spellDelay = 250, range = 625, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Shatter"] = {spellKey = _W, isSelfCast = true, name = "Shatter", spellName = "Shatter", spellDelay = 250, range = 200, type = "CIRCULAR"},
        ["Radiance"] = {spellKey = _R, isSelfCast = true, name = "Radiance", spellName = "Radiance", spellDelay = 250, range = 200, type = "CIRCULAR"},
    }},
    ["Teemo"] = {charName = "Teemo", skillshots = {
    --insert projectile speed
        ["BlindingDart"] = {spellKey = _Q, isTargeted = true, name = "BlindingDart", spellName = "BlindingDart", spellDelay = 250, projectileName = "BlindShot_mis.troy", projectileSpeed = 1900, range = 680, fuckedUp = false, blockable = true, danger = 1}
    }},
    ["Thresh"] = {charName = "Thresh", skillshots = {
        ["ThreshQ"] = {spellKey = _Q, isCollision = true, name = "ThreshQ", spellName = "ThreshQ", spellDelay = 500, projectileName = "Thresh_Q_whip_beam.troy", projectileSpeed = 1900, range = 1075, radius = 65, type = "LINE", fuckedUp = false, blockable = true, danger = 1}
    }},
    ["Tristana"] = {charName = "Tristana", skillshots = {
    --unfinished
        ["Explosive Shot"] = {spellKey = _E, isTargeted = true, isAutoReset = true, name = "Explosive Shot", spellName = "ExplosiveShot", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 700, type = "LINE"},
        ["Rapid Fire"] = {spellKey = _Q, isSelfCast = true, name = "Rapid Fire", spellName = "RapidFire", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 700, type = "CIRCULAR"},
        ["BusterShot"] = {spellKey = _R, isTargeted = true, isExecute = true, name = "Buster Shot", spellName = "BusterShot", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 645, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Trundle"] = {charName = "Trundle", skillshots = {
        ["TrundlePain"] = { spellKey = _R, isTargeted = true, spellName = "TrundlePain", name = "TrundlePain", range = 700,},
        ["trundledesecrate"] = { spellKey = _W, spellName = "trundledesecrate", name = "trundledesecrate", range = 900, radius = 1000, type = "CIRCULAR"},
        ["TrundleTrollSmash"] = { spellKey = _Q, isSelfCast = true, isAutoReset = true, spellName = "TrundleTrollSmash", name = "TrundleTrollSmash", range = 125,},
        ["TrundleCircle"] = { spellKey = _E, spellName = "TrundleCircle", name = "TrundleCircle", range = 1000, radius = 62, type = "CIRCULAR"},
    }},
    ["Tryndamere"] = {charName = "Tryndamere", skillshots = {
        ["UndyingRage"] = { spellKey = _R, isSelfCast = true, isShield = true, spellName = "UndyingRage", name = "UndyingRage", range = math.huge,},
    }},
    ["TwistedFate"] = {charName = "TwistedFate", skillshots = {
        ["WildCards"] = {spellKey = _Q, name = "Loaded Dice", spellName = "WildCards", spellDelay = 250, projectileName = "Roulette_mis.troy", projectileSpeed = 1000, range = 1450, radius = 40, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Pick A Card"] = {spellKey = _W, isSelfCast = true, checkName = true, name = "Pick A Card", spellName = "PickACard", spellDelay = 250, projectileName = "Thresh_Q_whip_beam.troy", projectileSpeed = 1500, range = 700, type = "LINE"},
        ["Gold Card"] = {spellKey = _W, isSelfCast = true, checkName = true, name = "Gold Card", spellName = "goldcardlock", spellDelay = 250, projectileName = "Thresh_Q_whip_beam.troy", projectileSpeed = 1500, range = math.huge, type = "LINE"},
    }},
    ["Twitch"] = {charName = "Twitch", skillshots = {
        ["TwitchVenomCask"] = { spellKey = _W, type = "LINE", spellName = "TwitchVenomCask", name = "TwitchVenomCask", projectileName = "Twitch_Venom_Splash.troy", projectileSpeed = 1400, range = 900, radius = 200, fuckedUp = false, blockable = true, danger = 1},
        ["HideInShadows"] = { spellKey = _Q, isSelfCast = true, isAutoBuff = true, noAnimation = ture, spellName = "HideInShadows", name = "HideInShadows", range = 550, },
        ["Expunge"] = { spellKey = _E, isSelfCast = true, spellName = "Expunge", name = "Expunge", range = 1200, fuckedUp = false, blockable = true, danger = 1},
        --["FullAutomatic"] = { spellKey = _R, castType = 0, spellName = "FullAutomatic", name = "FullAutomatic", range = 1200,},
    }},
    ["Udyr"] = {charName = "Udyr", skillshots = {       
        ["UdyrPhoenixStance"] = { spellKey = _R, isSelfCast = true, noAnimation = true, isAutoBuff = true, spellName = "UdyrPhoenixStance", name = "UdyrPhoenixStance", range = math.huge,},
        ["UdyrTurtleStance"] = { spellKey = _W, isSelfCast = true, noAnimation = true, isShield = true, spellName = "UdyrTurtleStance", name = "UdyrTurtleStance", range = math.huge,},
        ["UdyrBearStance"] = { spellKey = _E, isSelfCast = true, noAnimation = true, spellName = "UdyrBearStance", name = "UdyrBearStance", range = math.huge,},
        ["UdyrTigerStance"] = { spellKey = _Q, isSelfCast = true, noAnimation = true, isAutoBuff = true, spellName = "UdyrTigerStance", name = "UdyrTigerStance", range = math.huge,},

    }},
    
    ["Urgot"] = {charName = "Urgot", skillshots = {
        ["UrgotHeatseekingLineMissile"] = {name = "Acid Hunter", spellName = "UrgotHeatseekingLineMissile", spellDelay = 175, projectileName = "UrgotLineMissile_mis.troy", projectileSpeed = 1600, range = 1000, radius = 60, type = "LINE", fuckedUp = false, blockable = true, danger = 1, fuckedUp = false, blockable = true, danger = 1},
        ["UrgotPlasmaGrenade"] = {name = "Plasma Grenade", spellName = "UrgotPlasmaGrenade", spellDelay = 250, projectileName = "UrgotPlasmaGrenade_mis.troy", projectileSpeed = 1750, range = 900, radius = 250, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["MonkeyKing"] = {charName = "MonkeyKing", skillshots = {
    --unfinished
        ["MonkeyKingNimbus"] = {spellKey = _E, isTargeted = true, name = "Nimbus Strike", spellName = "MonkeyKingNimbus", spellDelay = 250, range = 625, type = "LINE"},
        ["MonkeyKingQAttack"] = {spellKey = _Q, isSelfCast = true, isAutoReset = true, isTrueRange = true, name = "Crushing Blow", spellName = "MonkeyKingQAttack", spellDelay = 250, range = 325, type = "CIRCULAR"},
    }},
    ["Vladimir"] = {charName = "Vladimir", skillshots = {
        --["VladimirSanguinePool"] = { spellKey = _W, castType = 0, spellName = "VladimirSanguinePool", name = "VladimirSanguinePool", range = 1050, projectileName = "DarkWind_mis.troy", radius = 120,},
        ["VladimirHemoplague"] = { spellKey = _R, type = "CIRCULAR", spellName = "VladimirHemoplague", name = "VladimirHemoplague", range = 700, projectileSpeed = 1200, projectileName = "VladHemoPlague_cas.troy", radius = 175,},
        ["VladimirTidesofBlood"] = { spellKey = _E, isSelfCast = true, spellName = "VladimirTidesofBlood", name = "VladimirTidesofBlood", range = 610, projectileSpeed = 1100, projectileName = "VladTidesofBlood_mis.troy", radius = 120,},
        ["VladimirTransfusion"] = { spellKey = _Q, isTargeted = true, spellName = "VladimirTransfusion", name = "VladimirTransfusion", range = 600,},
    }},
    ["Volibear"] = {charName = "Volibear", skillshots = {
        ["VolibearQ"] = { spellKey = _Q, isAutoReset = true, spellName = "VolibearQ", name = "VolibearQ", range = 125, },
        ["VolibearR"] = { spellKey = _R, isAutoBuff = true, spellName = "VolibearR", name = "VolibearR", range = 125, },
        ["VolibearE"] = { spellKey = _E, isSelfCast = true, spellName = "VolibearE", name = "VolibearE", range = 425, projectileName = "FerosciousHowl_cas3.troy",},
        ["VolibearW"] = { spellKey = _W, isTargeted = true, isExecute = true, spellName = "VolibearW", name = "VolibearW", range = 400, },
    }},
    ["Warwick"] = {charName = "Warwick", skillshots = {
    --unfinished
        ["Hungering Strike"] = {spellKey = _Q, isTargeted = true, name = "Hungering Strike", spellName = "HungeringStrike", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 400, type = "LINE"},
        ["Hunters Call"] = {spellKey = _W, isSelfCast = true, isAutoBuff = true, noAnimation = true, name = "Hunters Call", spellName = "HuntersCall", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 300, type = "CIRCULAR"},
    }},
    ["Varus"] = {charName = "Varus", skillshots = {
        ["VarusQ!"] = {spellKey = _Q, name = "Varus Q Missile", spellName = "VarusQ!", spellDelay = 0, projectileName = "VarusQ_mis.troy", projectileSpeed = 1900, range = 1600, radius = 70, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["VarusE"] = {spellKey = _E, name = "Varus E", spellName = "VarusE", spellDelay = 250, projectileName = "VarusEMissileLong.troy", projectileSpeed = 1500, range = 925, radius = 275, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1},
        ["VarusR"] = {name = "VarusR", spellName = "VarusR", spellDelay = 250, projectileName = "VarusRMissile.troy", projectileSpeed = 1950, range = 1250, radius = 100, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    
    ["Vayne"] = {charName = "Vayne", skillshots = {
        --["VayneInquisition"] = { spellKey = _R, castType = 0, spellName = "VayneInquisition", name = "VayneInquisition", range = 1, projectileName = "AnnieBasicAttack_mis.troy",},
        --["VayneCondemn"] = { spellKey = _E, castType = 0, spellName = "VayneCondemn", name = "VayneCondemn", range = 550, projectileSpeed = 1200, projectileName = "vayne_E_mis.troy",},
        --["VayneSilveredBolts"] = { spellKey = _W, castType = 0, spellName = "VayneSilveredBolts", name = "VayneSilveredBolts", range = 10000, radius = 50,},
        ["VayneTumble"] = { isAutoReset = true, isDash = true, spellName = "VayneTumble", name = "VayneTumble", range = 300, },
        ["VayneCondemn"] = {name = "VayneCondemn", spellName = "VayneCondemn", castDelay = 250, projectileName = "vayne_E_mis.troy", projectileSpeed = 1200, range = 550, radius = 450, fuckedUp = false, blockable = true, danger = 1}
    }}, 
    ["Veigar"] = {charName = "Veigar", skillshots = {
        ["BalefulStrike"] = {spellKey = _Q, isTargeted = true, name = "Baleful Strike", spellName = "BalefulStrike", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 650, projectileSpeed = 1500, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["Dark Matter"] = {spellKey = _W, name = "VeigarDarkMatter", targetHasBuff = "Stun", spellName = "VeigarDarkMatter", spellDelay = 1250, projectileName = "!", range = 900, radius = 112, type = "CIRCULAR"},
        ["Primordial Burst"] = {spellKey = _R, isTargeted = true, isExecute = true, name = "Primordial Burst", spellName = "PrimordialBurst", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 650, projectileSpeed = 1500, type = "LINE"},
    }},
    ["Vi"] = {charName = "Vi", skillshots = {
    --unfinished
        ["Excessive Force"] = {spellKey = _E, isSelfCast = true, isAutoReset = true, name = "Excessive Force", spellName = "ExcessiveForce", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 125, type = "CIRCULAR"},
    }},
    ["XinZhao"] = {charName = "XinZhao", skillshots = {
        ["Talon Strike"] = {spellKey = _Q, isSelfCast = true, isAutoReset = true, name = "Talon Strike", spellName = "TalonStrike", spellDelay = 250, range = 175, type = "LINE"},
        ["Battle Cry"] = {spellKey = _W, isSelfCast = true, isAutoBuff = true, noAnimation = true, name = "Battle Cry", spellName = "BattleCry", spellDelay = 250, range = 300,},
        ["Crescent Sweep"] = {spellKey = _R, isSelfCast = true, name = "Crescent Sweep", spellName = "CrescentSweep", spellDelay = 250, range = 300, type = "CIRCULAR"},
        ["Audacious Charge"] = { spellKey = _E, isTargeted = true, spellName = "XinZhaoCharge", name = "Audacious Charge", range = 600, },
    }},
    ["Xerath"] = {charName = "Xerath", skillshots = {
        ["XerathMageSpear"] = { spellKey = _E, type = "LINE", isCollision = true, isStun = true, spellName = "XerathMageSpear", name = "XerathMageSpear", projectileName = "Xerath_Base_E_mis.troy", range = 1050, projectileSpeed = 1600, radius = 70, fuckedUp = false, blockable = true, danger = 1},
        ["XerathArcanopulseChargeUp"] = { spellKey = _Q, type = "LINE", spellName = "XerathArcanopulseChargeUp", heroHasNoBuff = "XerathArcanopulseChargeUp", name = "XerathArcanopulseChargeUp", range = 1000, radius = 100, },
        ["XerathArcanopulseChargeUp2"] = { spellKey = _Q, type = "LINE", spellName = "XerathArcanopulseChargeUp2", heroHasBuff = "XerathArcanopulseChargeUp", name = "XerathArcanopulseChargeUp2", range = 750, radius = 100, fuckedUp = false, blockable = true, danger = 1},
        --range function
        ["XerathArcaneBarrage2"] = { spellKey = _W, type = "CIRCULAR", spellName = "XerathArcaneBarrage2", name = "XerathArcaneBarrage2", range = 1100, spellDelay = 750, radius = 200, fuckedUp = false, blockable = true, danger = 1},
        ["XerathLocusOfPower2"] = { spellKey = _R, type = "CIRCULAR", spellName = "XerathLocusOfPower2", name = "XerathLocusOfPower2", projectileName = "Xerath_Base_R_mis.troy", range = 5600, radius = 100, spellDelay = 750, fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Yasuo"] = {charName = "Yasuo", skillshots = {
        ["Steel Tempest"] = {spellKey = _Q, name = "Steel Tempest", isTrueRange = true, spellName = "SteelTempest", spellDelay = 250, projectileName = "Yasuo_Q_WindStrike.troy", range = 475, radius = 50, type = "LINE"},
        ["yasuoq3w"] = {spellKey = _Q, name = "Steel Tempest3", checkName = true, spellName = "yasuoq3w", spellDelay = 250, projectileName = "Yasuo_Q_wind_mis.troy", projectileSpeed = 1500, range = 900, radius = 100, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Yorick"] = {charName = "Yorick", skillshots = {       
        ["YorickDecayed"] = { spellKey = _W, spellName = "YorickDecayed", name = "YorickDecayed", range = 600, radius = 100, type = "CIRCULAR"},
        --["YorickReviveAlly"] = { spellKey = _R, castType = 0, spellName = "YorickReviveAlly", name = "YorickReviveAlly", range = 850, projectileSpeed = 1500,},
        ["YorickSpectral"] = { spellKey = _Q, isSelfCast = true, isAutoReset = true, noAnimation = true, spellName = "YorickSpectral", name = "YorickSpectral", range = 125,},
        ["YorickRavenous"] = { spellKey = _E, isTargeted = true, spellName = "YorickRavenous", name = "YorickRavenous", range = 550, },
    }},
    ["Zed"] = {charName = "Zed", skillshots = {
        ["ZedShuriken"] = {spellKey = _Q, name = "ZedShuriken", spellName = "ZedShuriken", spellDelay = 250, projectileName = "Zed_Q_Mis.troy", projectileSpeed = 1700, range = 925, radius = 50, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["ZedShadowSlash"] = { spellKey = _E, isSelfCast = true, spellName = "ZedShadowSlash", name = "ZedShadowSlash", range = 290,},
    }},
    ["Ziggs"] = {charName = "Ziggs", skillshots = {
        ["ZiggsQ"] =  {spellKey = _Q, isCollision = true, name = "ZiggsQ", spellName = "ZiggsQ", spellDelay = 250, projectileName = "ZiggsQ.troy", projectileSpeed = 1700, range = 1400, radius = 155, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["ZiggsW"] =  {spellKey = _W, name = "ZiggsW", spellName = "ZiggsW", spellDelay = 250, projectileName = "ZiggsW_mis.troy", projectileSpeed = 1700, range = 1000, radius = 325, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["ZiggsE"] =  {spellKey = _E, name = "ZiggsE", spellName = "ZiggsE", spellDelay = 250, projectileName = "ZiggsE_Mis_Large.troy", projectileSpeed = 1700, range = 900, radius = 250, type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["ZiggsR"] = { spellKey = _R, isExecute = true, type = "LINE", spellName = "ZiggsR", name = "ZiggsR", range = 5000, projectileSpeed = 1750, projectileName = "ZiggsR_Mis_Nuke.troy", radius = 550, fuckedUp = false, blockable = true, danger = 1},
    }},
    ["Zilean"] = {charName = "Zilean", skillshots = {
    --unfinished
        ["TimeBomb"] = {spellKey = _Q, isTargeted = true, name = "Time Bomb", spellName = "TimeBomb", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 700, radius = 330, type = "CIRCULAR", fuckedUp = false, blockable = true, danger = 1},
        ["Rewind"] = {spellKey = _W, isSelfCast = true, name = "Rewind", spellName = "Rewind", spellDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", range = 700, type = "CIRCULAR"},
        ["ChronoShift"] = { spellKey = _R, isTargeted = true, isShield = true, spellName = "ChronoShift", name = "ChronoShift", range = 900, },
    }},
    ["Zyra"] = {charName = "Zyra", skillshots = {
        ["Deadly Bloom"]   = {spellKey = _Q, name = "Deadly Bloom", spellName = "ZyraQFissure", spellDelay = 625, projectileName = "zyra_Q_cas.troy", range = 800, radius = 220, type = "CIRCULAR"},
        ["Rampant Growth"]   = {spellKey = _W, name = "Rampant Growth", spellName = "Rampant Growth", spellDelay = 625, projectileName = "zyra_Q_cas.troy", range = 850, radius = 220, type = "CIRCULAR"},
        ["ZyraGraspingRoots"] = {spellKey = _E, name = "Grasping Roots", spellName = "ZyraGraspingRoots", spellDelay = 250, projectileName = "Zyra_E_sequence_impact.troy", projectileSpeed = 1150, range = 1150, radius = 70,  type = "LINE", fuckedUp = false, blockable = true, danger = 1},
        ["ZyraBrambleZone"] = { spellKey = _R, type = "CIRCULAR", spellName = "ZyraBrambleZone", name = "ZyraBrambleZone", range = 700, spellDelay = 250, radius = 400},
        ["zyrapassivedeathmanager"] = { spellKey = _Q, checkName = true, name = "Zyra Passive", spellName = "zyrapassivedeathmanager", spellDelay = 500, projectileName = "zyra_passive_plant_mis.troy", projectileSpeed = 2000, range = 1474, radius = 60,  type = "LINE", fuckedUp = false, blockable = true, danger = 1},
    }},
}

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

local count = 0
local isSx
local isSac
local Minions
local SteelTempest
local eStack = 0
local qBuffName = "Yasuo_Q_wind_ready_buff.troy"
local farmSafe = false
local i
local attacked = false
local isattacking = 0
local animTime = 0
local IsRecalling = false
local knockedUp = 0
local Knockups = {}
local Tower = nil
local towerUnit = nil
local Tdashing = false
local Tdashing2 = false
local UsingPot = false
local lastRemove = 0
local TornadoReady = false

------------------------------------------------------
--           Callbacks              
------------------------------------------------------

function OnLoad()

    if VIP_USER then
        AdvancedCallback:bind('OnTowerFocus', function(tower, unit) OnTowerFocus(tower,unit) end)
        AdvancedCallback:bind('OnTowerIdle', function(tower) OnTowerIdle(tower) end)
        AdvancedCallback:bind('OnApplyBuff', function(source, unit, buff) OnApplyBuff(source, unit, buff) end)
        AdvancedCallback:bind('OnUpdateBuff', function(unit, buff) OnUpdateBuff(unit, buff) end)
        AdvancedCallback:bind('OnRemoveBuff', function(unit, buff) OnLoseBuff(unit, buff) end)
    end

    Tower = GetTurrets()

    print("<b><font color=\"#6699FF\">GosuMechanics: </font></b> <font color=\"#FFFFFF\">Yasuo 1.0</font>")
    Variables()
    Menu()
    PriorityOnLoad()
    VP = VPrediction()
    LoadOrbwalker()

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
        [2041]              = "ItemCrystalFlask",
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

function CheckUpdate()
    local function AutoupdaterMsg(msg) print("<font color=\"#FF794C\"><b>GosuMechanics:Yasuo : </b></font> <font color=\"#FFDFBF\">"..msg..".</b></font>") end
    if _G.UseUpdater then
        local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
        if ServerData then
            local ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
            if ServerVersion then
                ServerVersion = tonumber(ServerVersion)
                if tonumber(version) < ServerVersion then
                    AutoupdaterMsg("New version available"..ServerVersion)
                    AutoupdaterMsg("Updating, please don't press F9")
                    DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end)         
                else
                    AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
                end
            end
        else
        AutoupdaterMsg("Error downloading version info")
        end
    end
end

function LoadOrbwalker()
    if _G.Reborn_Initialised then
      print("GosuMechanics:Yasuo : Reborn loaded and authed")
            isSac = true
            loaded = true
            Settings:addSubMenu("["..myHero.charName.."] - Orbwalker", "Orbwalker")
            Settings.Orbwalker:addParam("info", "SAC:R detected", SCRIPT_PARAM_INFO, "")
    elseif _G.Reborn_Loaded and not _G.Reborn_Initialised and count < 30 then
            if printedWaiting == false then
      print("GosuMechanics:Yasuo : Waiting for Reborn auth")
            printedWaiting = true
            end
      DelayAction(LoadOrbwalker, 1)
            count = count + 1
    else
            if count >= 30 then
            print("GosuMechanics:Yasuo : SAC failed to auth")
            end
            require 'SxOrbWalk'
      print("SxOrbWalk: Loading...")
                Settings:addSubMenu("["..myHero.charName.."] - Orbwalker", "Orbwalker")
                SxOrb:LoadToMenu(Settings.Orbwalker)
                isSx = true
            print("SxOrbWalk: Loaded")
            loaded = true
        end
end

function OnTick()
    ComboKey = Settings.combo.comboKey
    HarassKey = Settings.harass.harassKey
    HarassToggle = Settings.harass.harassToggle
    JungleClearKey = Settings.jungle.jungleKey
    LaneClearKey = Settings.lane.laneKey
    FarmKey = Settings.farm.farmKey

    if Tdashing ~= false and os.clock() > Eduration2 then
        Tdashing = false
    end
    if Tdashing2 ~= false and os.clock() > Eduration3 then
        Tdashing2 = false
    end

    if dashed ~= nil and dashed - os.clock() < 0 then 
        posAfterE = nil
        dashed = nil
    end
    
    if ComboKey then
        Combo(Target)
    end
    
    if HarassKey or HarassToggle then
        Harass(Target)
    end
    
    if FarmKey then
        LastHit()
    end
    if JungleClearKey then
        JungleClear()
    end
    
    if LaneClearKey then
        LaneClear()
    end
    
    if Settings.ks.killSteal then
        KillSteal()
    end 

    if Settings.ks.autoIgnite then
        AutoIgnite()
    end 

    if Settings.esc.run then
        flee()
    end

    if Settings.misc.autoPot then
        AutoPots()
    end

        AutoUltKillable()
     
    if Settings.harass.harassToggle then
        AutoQenemy()
    end

    if Settings.harass.useQjungle then
        AutoQminion()
    end

    if Settings.harass.useQminion then
        AutoQenemyminion()
    end
    
    Checks()

    AutoUlt()

    GetItemSlot()
end

function OnDraw()
    if not myHero.dead and not Settings.drawing.mDraw then
        if SkillQ.ready and Settings.drawing.qDraw then 
            DrawCircle(myHero.x, myHero.y, myHero.z, SkillQ.range, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
        end
        if SkillW.ready and Settings.drawing.wDraw then 
            DrawCircle(myHero.x, myHero.y, myHero.z, SkillW.range, RGB(Settings.drawing.wColor[2], Settings.drawing.wColor[3], Settings.drawing.wColor[4]))
        end
        if SkillE.ready and Settings.drawing.eDraw then 
            DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, RGB(Settings.drawing.eColor[2], Settings.drawing.eColor[3], Settings.drawing.eColor[4]))
        end
        if SkillR.ready and Settings.drawing.rDraw then 
            DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, RGB(Settings.drawing.rColor[2], Settings.drawing.rColor[3], Settings.drawing.rColor[4]))
        end
        
        if Settings.drawing.myHero then
            DrawCircle(myHero.x, myHero.y, myHero.z, TrueRange(), RGB(Settings.drawing.myColor[2], Settings.drawing.myColor[3], Settings.drawing.myColor[4]))
        end
        
        if Settings.drawing.Target and Target ~= nil then
            DrawCircle(Target.x, Target.y, Target.z, 80, ARGB(255, 10, 255, 10))
        end
    end
end

------------------------------------------------------
--           Functions              
------------------------------------------------------

function Combo(unit)
    if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then

        teamfight()
        local TargetDistance = GetDistance(Target)
        
        if Settings.combo.comboItems then
            UseItems(unit)
        end
        if Settings.combo.useQ then
            Q12(unit)
        end
        if Settings.combo.useQ then
            Q3(unit)
        end
        if Settings.combo.useR then    
            sbtwR()
        end
        if SkillE.ready and Settings.combo.useE and TargetDistance == SkillE.range then
            if eStack == 2 then
                E(Target)
            end
            checkMinion = getNearestMinion(Target)
            if eStack < 2 and checkMinion ~= nil and GetDistance(eEndPos(checkMinion)) < SkillQ.width then
                E(checkMinion)
            elseif TargetDistance == SkillE.range then
                E(Target)
            end
        end
    end
        mPos = getNearestMinion(mousePos)
        if SkillE.ready and mPos and (not UnderTurret(eEndPos(minion),true)) or towerUnit~=nil then
            E(mPos)
        end
end

function LastHit(unit)
    enemyMinions:update()
    if FarmKey then
        for i, minion in pairs(enemyMinions.objects) do
            if ValidTarget(minion) and minion ~= nil then
                if Settings.farm.useQ12 and SkillQ12.ready and GetDistance(minion) <= SkillQ12.range then
                    if minion.health <= getDmg("Q", minion, myHero) then
                       Q12(minion)
                    end
                end
                if Settings.farm.useQ3 and SkillQ3.ready and GetDistance(minion) <= SkillQ3.range then
                    if minion.health <= getDmg("Q", minion, myHero) then
                       Q3(minion)
                    end
                end
                if Settings.farm.useE and GetDistance(minion, myHero) <= SkillE.range and SkillE.ready then
                    if getDmg("E", minion, myHero) >= minion.health and (not UnderTurret(eEndPos(minion),true)) or towerUnit~=nil then
                        E(minion)
                    end
                end
            end
        end
    end
end

function Harass(unit)
    if Settings.harass.useQ12 then Q12(unit) end
    if Settings.harass.useQ3 then Q3(unit) end
end

function LaneClear()

    if VIP_USER and Tower then
        local getOut = dodgeTowerMinion(Tower, 775)
        if getOut ~= nil then
            E(getOut)
        end
    end
    enemyMinions:update()
    if LaneClearKey then
        for i, minion in pairs(enemyMinions.objects) do
            if ValidTarget(minion) and minion ~= nil then
                if Settings.lane.useQ and GetDistance(minion) <= SkillQ12.range and SkillQ12.ready then
                    local BestPos, BestHit = GetBestLineFarmPosition(SkillQ12.range, SkillQ12.width, enemyMinions.objects)
                    
                    if BestPos ~= nil and BestHit >= 2 and getDmg("Q", minion, myHero) >= minion.health  then
                        CastSpell(0, BestPos.x, BestPos.z)
                    else
                        CastSpell(0, BestPos.x, BestPos.z)
                    end
                end
                if Settings.lane.useQ and GetDistance(minion) <= SkillQ3.range and SkillQ3.ready then
                 local BestPos, BestHit = GetBestLineFarmPosition(SkillQ3.range, SkillQ3.width, enemyMinions.objects)
                    
                    if BestPos ~= nil and BestHit >= 2 and getDmg("Q", minion, myHero) >= minion.health  then
                        CastSpell(0, BestPos.x, BestPos.z)
                    else
                        CastSpell(0, BestPos.x, BestPos.z)
                    end
                end
                if Settings.lane.useELH and GetDistance(minion, myHero) <= SkillE.range and SkillE.ready then
                    if getDmg("E", minion, myHero) >= minion.health and (not UnderTurret(eEndPos(minion),true)) or towerUnit~=nil then
                        E(minion)
                    elseif Settings.lane.useEalways and (not UnderTurret(eEndPos(minion),true)) or towerUnit~=nil and GetDistance(minion, myHero) <= SkillE.range then
                        E(minion)
                    end
                end 
            end
        end
    end
end

function JungleClear()
        if Settings.jungle.jungleKey then
        local JungleMob = GetJungleMob()
        
        if JungleMob ~= nil then
            if Settings.jungle.useQ and GetDistance(JungleMob) <= SkillQ.range and SkillQ.ready then
                CastSpell(_Q, JungleMob.x, JungleMob.z)
            end
            if Settings.jungle.useE and GetDistance(JungleMob) <= SkillE.range and SkillE.ready then
                CastSpell(_E, JungleMob)
            end
        end
    end
end

function flee()
    mPos = getNearestMinion(mousePos)
    if SkillE.ready and mPos then
        E(mPos) 
    else 
        myHero:MoveTo(mousePos.x, mousePos.z) 
    end
end

function Q12(unit, minion)
    local CastPacket = Settings.misc.usePackets
    if SkillQ12.ready and ValidTarget(unit, SkillQ12.range) then
        local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(unit, SkillQ12.delay, SkillQ12.width, SkillQ12.range, SkillQ12.speed, myHero, false)
        if HitChance >= 2 and CastPacket and not IsDashing() and GetDistance(unit) <= SkillQ12.range then
            Packet("S_CAST", {spellId = _Q, toX=CastPosition.x, toY=CastPosition.z, fromX=CastPosition.x, fromY=CastPosition.z}):send()   
        else
            CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
    end
end

function Q3(unit, minion)
    local CastPacket = Settings.misc.usePackets
    if myHero:GetSpellData(_Q).name == "yasuoq3w" and ValidTarget(unit, SkillQ3.range) then  
        local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(unit, SkillQ3.delay, SkillQ3.width, SkillQ3.range, SkillQ3.speed, myHero, false)
        if HitChance >= 2 and CastPacket and not IsDashing() and TornadoReady and GetDistance(unit) <= SkillQ3.range then
            Packet("S_CAST", {spellId = 0, toX=CastPosition.x, toY=CastPosition.z, fromX=CastPosition.x, fromY=CastPosition.z}):send()
        else
            CastSpell(0, CastPosition.x, CastPosition.z)
        end     
    end
end

function AutoQminion(unit, minion)
   local JungleMob = GetJungleMob()

    if JungleMob ~= nil and not IsRecalling then
        if SkillQ12.ready and Settings.harass.useQjungle and GetDistance(JungleMob) <= SkillQ12.range then
            CastSpell(_Q, JungleMob.x, JungleMob.z)
        end
    end
end

function AutoQenemyminion(unit, minion)
    enemyMinions:update()
    for index, minion in pairs(enemyMinions.objects) do
        if ValidTarget(minion) and not IsRecalling then
            if SkillQ12.ready and Settings.harass.useQminion and GetDistance(minion) <= SkillQ12.range then
               Q12(minion)
            end
        end
    end
end

function AutoQenemy()

    if Settings.harass.useQ12 and SkillQ12.ready and Tower and (not UnderTurret(myHero)) then
        Q12(Target)
    end
    if Settings.harass.useQ3 and SkillQ3.ready and Tower and (not UnderTurret(myHero)) then
        Q3(Target)
    end
end    

function Rks(unit)
    if unit.health <= (Settings.ks.autoRkillable/100*unit.maxHealth)*1.5 then
        return true
    else
        return false
    end
end

function E(unit)
    posAfterE = eEndPos(unit)
    if VIP_USER and Settings.misc.usePackets then
        Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
    else
        CastSpell(_E, unit) 
    end
end

function sbtwR()
    for i = 1, heroManager.iCount, 1 do
        local Target = heroManager:getHero(i)
        if ValidTarget(Target, SkillR.range) and Rks(Target) then
            DelayAction(function()
                CastSpell(_R)
            end, 0.5 - GetLatency() / 1000)
        end
    end
end

function AutoUltKillable()
    for i = 1, heroManager.iCount, 1 do
        local Target = heroManager:getHero(i)
        if Settings.ks.autoR and ValidTarget(Target, SkillR.range) and Rks(Target) and not isRecalling then
            DelayAction(function()
                CastSpell(_R)
            end, 0.5 - GetLatency() / 1000)
        end
    end
end

function AutoUlt()
    knocked = 0
    for i, v in ipairs(GetEnemyHeroes()) do
        if not v.canMove and v.y > 130 and ValidTarget(v) then
            knocked = knocked + 1
            if Settings.combo.autoult and SkillR.ready and CanCast(_R) and not isRecalling then
                if knocked >= Settings.combo.Ult3 then
                    CastSpell(_R)
                end
            end
        end
    end
end

function KillSteal()
    for i = 1, heroManager.iCount, 1 do
        if ksTarget == nil then
            local damage = 0
            local eTarget = heroManager:getHero(i)
            if ValidTarget(eTarget, SkillE.range) then
                local qDmg = myHero:CalcDamage(eTarget,(GetSpellData(_Q).level*20)+myHero.totalDamage)
                local eDmg = getEDmg(eTarget)
                if SkillQ12.ready then 
                    damage = qDmg
                end
                if SkillE.ready then 
                    damage = damage + eDmg
                end 
                if damage > eTarget.health then
                    ksTarget = eTarget
                end
            end
        end
    end
    if ksTarget and GetDistance(ksTarget)<SkillE.range then
        if ValidTarget(ksTarget) then
            E(ksTarget)
        end
        if ValidTarget(ksTarget) then
            if dashed ~= nil and GetDistance(ksTarget) <= SkillQ12.width then
                Q12(ksTarget)
            end
        end
    else 
      ksTarget = nil
    end
end 

function IsDashing()
    return Tdashing
end

function IsDashing2()
    return Dashing
end

function AutoIgnite()
    if Settings.ks.autoIgnite and ignite ~= nil and CanCast(ignite) then
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

function teamfight()
    local checkTarget = nil
        local count = 0
    for i = 1, heroManager.iCount, 1 do
        local eTarget = heroManager:getHero(i)
        if ValidTarget(eTarget, SkillQ12.width) then
            checkTarget = eTarget
            count = count + 1
        end
    end
    if dashed ~= nil and count >= 2 then
        Q12(checkTarget)
    end
end

function getEDmg(minion)      
        return myHero:CalcMagicDamage(minion,((GetSpellData(_E).level*20)+50)*(1+0.25*eStack)+(myHero.ap*0.6))
end

function MoveToMouse()
        local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
        local Position = myHero + (Vector(MousePos) - myHero):normalized()*300
        myHero:MoveTo(mousePos.x, mousePos.z)
end

function eEndPos(unit)
    --[[local endPos = Point(unit.x-myHero.x, unit.z-myHero.z)
    abs = math.sqrt(endPos.x*endPos.x + endPos.y*endPos.y)
    endPos2 = Point(myHero.x + (eRange*(endPos.x/abs)), myHero.z + (eRange*(endPos.y/abs)))
    return endPos2]]
    if unit ~= nil then
        --local endPos = Point(unit.x - myHero.x, unit.z - myHero.z)
        --abs = math.sqrt(endPos.x * endPos.x + endPos.y * endPos.y)
        --endPos2 = Point(myHero.x + Ranges.E * (endPos.x / abs), myHero.z + Ranges.E * (endPos.y / abs))
        --return endPos2
        if GetDistance(myHero,unit) < 410 then
           dashPointT = myHero + (Vector(unit) - myHero):normalized() * 485
        else 
           dashPointT = myHero + (Vector(unit) - myHero):normalized() * (GetDistance(myHero,unit) + 65)
        end
        return dashPointT
    end
end

function getNearestMinion(unit)

    local closestMinion = nil
    local nearestDistance = 0

        Minions:update()
        JungleMinions:update()
        for index, minion in pairs(Minions.objects) do
            if minion ~= nil and minion.valid and string.find(minion.name,"Minion_") == 1 and minion.team ~= player.team and minion.dead == false then
                if GetDistance(minion) <= SkillE.range then
                    --PrintChat(GetDistance(eEndPos(minion), unit) .. "  -  ".. GetDistance(unit))
                    if GetDistance(eEndPos(minion), unit) < GetDistance(unit) and nearestDistance < GetDistance(minion) then
                        nearestDistance = GetDistance(minion)
                        closestMinion = minion
                    end
                end
            end
        end
        for index, minion in pairs(JungleMinions.objects) do
            if minion ~= nil and minion.valid and minion.dead == false then
                if GetDistance(minion) <= SkillE.range then
                    if GetDistance(eEndPos(minion), unit) < GetDistance(unit) and nearestDistance < GetDistance(minion) then
                        nearestDistance = GetDistance(minion)
                        closestMinion = minion
                    end
                end
            end
        end
        for i = 1, heroManager.iCount, 1 do
            local minion = heroManager:getHero(i)
            if ValidTarget(minion, SkillE.range) then
                if GetDistance(minion) <= SkillE.range then
                    if GetDistance(eEndPos(minion), unit) < GetDistance(unit) and nearestDistance < GetDistance(minion) then
                        nearestDistance = GetDistance(minion)
                        closestMinion = minion
                    end
                end
            end
        end
    return closestMinion
end

function OnRecall(hero, channelTimeInMs)
        if hero.isMe then
                IsRecalling = true
        end
end

function OnAbortRecall(hero)
        if hero.isMe then
                IsRecalling = false
        end        
end

function OnFinishRecall(hero)
        if hero.isMe then
                IsRecalling = false
        end
end

function OnApplyBuff(source, unit, buff)

    --if buff and unit == myHero then print(buff.name) end

    if not unit or not buff then return end
        if unit and unit.isMe and buff.name == "RegenerationPotion" then
            UsingPot = true
        end
        if unit and unit.isMe and buff.name == "yasuoq3w" then
            TornadoReady = true
        end
    if unit.isMe and Settings.misc.useqss then
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
    if unit and unit.isMe and buff.name == "yasuoq3w" then
        TornadoReady = false
    end
end

------------------------------------------------------
--           Checks, menu & stuff               
------------------------------------------------------

function Checks()
    SkillQ12.ready = (myHero:CanUseSpell(_Q) == READY and ( myHero:GetSpellData(_Q).name == "YasuoQW" or myHero:GetSpellData(_Q).name == "yasuoq2w"))
    SkillQ3.ready  = (myHero:CanUseSpell(_Q) == READY and myHero:GetSpellData(_Q).name == "yasuoq3w")
    SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
    SkillW.ready = (myHero:CanUseSpell(_W) == READY)
    SkillE.ready = (myHero:CanUseSpell(_E) == READY)
    SkillR.ready = (myHero:CanUseSpell(_R) == READY)
    
    IREADY = (igniteSpell ~= nil and myHero:CanUseSpell(igniteSpell) == READY)
    
    TargetSelector:update()
    Target = GetCustomTarget()
    --SxOrb:ForceTarget(Target)
    
    if Settings.drawing.lfc.lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end


function Menu()
    Settings = scriptConfig("GosuMechanics", "Yasuo")
    
    Settings:addSubMenu("["..myHero.charName.."] - Combo Settings", "combo")
        Settings.combo:addParam("comboKey", "Beast Mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        Settings.combo:addParam("useQ", "Use "..SkillQ.name.." ", SCRIPT_PARAM_ONOFF, true)
        Settings.combo:addParam("useE", "Use "..SkillE.name.." ", SCRIPT_PARAM_ONOFF, true)
        Settings.combo:addParam("useR", "Use "..SkillR.name.." ",  SCRIPT_PARAM_ONOFF, true)
        Settings.combo:addParam("autoult", "AutoR Toggle", SCRIPT_PARAM_ONOFF, true)
        Settings.combo:addParam("Ult3", "When x enemy in air", SCRIPT_PARAM_SLICE, 3,0,5,0)
        Settings.combo:addParam("comboItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
        Settings.combo:permaShow("autoult")
    
    Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "harass")
        Settings.harass:addParam("harassKey", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
        Settings.harass:addParam("harassToggle", "Harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("L"))
        Settings.harass:addParam("useQ12", "Use "..SkillQ.name.." ", SCRIPT_PARAM_ONOFF, true)
        Settings.harass:addParam("useQ3", "Use "..SkillQ3.name.." ", SCRIPT_PARAM_ONOFF, true)
        Settings.harass:addParam("useE", "Use "..SkillE.name.." ", SCRIPT_PARAM_ONOFF, true)
        Settings.harass:addParam("useQminion", "AutoQ EnemyMinion", SCRIPT_PARAM_ONOFF, true)
        Settings.harass:addParam("useQjungle", "AutoQ JungleMob", SCRIPT_PARAM_ONOFF, true)
        Settings.harass:permaShow("harassToggle")
        
    Settings:addSubMenu("["..myHero.charName.."] - LastHit", "farm")
        Settings.farm:addParam("farmKey", "KastHit", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("A"))
        Settings.farm:addParam("useQ12", "use "..SkillQ12.name.." ", SCRIPT_PARAM_ONOFF, true)
        Settings.farm:addParam("useQ3", "use "..SkillQ3.name.." ", SCRIPT_PARAM_ONOFF, true)
        Settings.farm:addParam("useE", "use "..SkillE.name.." ", SCRIPT_PARAM_ONOFF, true)
        
    Settings:addSubMenu("["..myHero.charName.."] - Lane Clear Settings", "lane")
        Settings.lane:addParam("laneKey", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("X"))
        Settings.lane:addParam("useQ", "LaneClear with "..SkillQ.name.." ", SCRIPT_PARAM_ONOFF, true)
        Settings.lane:addParam("useELH", "LastHit with "..SkillE.name.." ", SCRIPT_PARAM_ONOFF, true)
        Settings.lane:addParam("useEalways", "Always use "..SkillE.name.." ", SCRIPT_PARAM_ONOFF, true)
        --Settings.lane:addParam("laneItems", "Use Items in LaneClear", SCRIPT_PARAM_ONOFF, true)
        
    Settings:addSubMenu("["..myHero.charName.."] - Jungle Clear Settings", "jungle")
        Settings.jungle:addParam("jungleKey", "Jungle Clear", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("X"))
        Settings.jungle:addParam("useQ", "use "..SkillQ.name.." ", SCRIPT_PARAM_ONOFF, true)
        Settings.jungle:addParam("useE", "use "..SkillE.name.." ", SCRIPT_PARAM_ONOFF, true)

    Settings:addSubMenu("["..myHero.charName.."] - Escape Settings", "esc")
        Settings.esc:addParam("run", "Escape Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("Z"))
        
    Settings:addSubMenu("["..myHero.charName.."] - KillSteal Settings", "ks")
        Settings.ks:addParam("killSteal", "Use Smart Kill Steal", SCRIPT_PARAM_ONOFF, true)
        Settings.ks:addParam("autoR", "Auto-R KS", SCRIPT_PARAM_ONOFF, true)
        Settings.ks:addParam("autoRkillable", "when at % Health",SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
        Settings.ks:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
        Settings.ks:permaShow("killSteal")
        Settings.ks:permaShow("autoR")

    Settings:addSubMenu("[" .. myHero.charName.. "] - Auto-Interrupt", "interrupt")
        Settings.interrupt:addParam("r", "Interrupt with Yasuoq3w", SCRIPT_PARAM_ONOFF, true)
        for i, a in pairs(GetEnemyHeroes()) do
            if Interrupt[a.charName] ~= nil then
                for i, spell in pairs(Interrupt[a.charName].stop) do
                    Settings.interrupt:addParam(spell.spellName, a.charName.." - "..spell.name, SCRIPT_PARAM_ONOFF, true)
                end
            end
        end
    Settings:addSubMenu("[" .. myHero.charName.. "] - Anti Gap-Closer", "gapClose")
        for _, enemy in pairs(GetEnemyHeroes()) do
            if isAGapcloserUnit[enemy.charName] ~= nil then
                Settings.gapClose:addParam(enemy.charName, enemy.charName .. " - " .. enemy:GetSpellData(isAGapcloserUnit[enemy.charName].spell).name, SCRIPT_PARAM_ONOFF, true)
            end
        end

    Settings:addSubMenu("["..myHero.charName.."] - WindWall Settings", "blocks")
        Settings.blocks:addParam("autoW", " Auto "..SkillW.name.." ", SCRIPT_PARAM_ONOFF, true)

    for i = 1, heroManager.iCount,1 do
        local hero = heroManager:getHero(i)
        if hero.team ~= player.team then
            if Champions[hero.charName] ~= nil then
                for index, skillshot in pairs(Champions[hero.charName].skillshots) do
                    if skillshot.blockable == true then
                        Settings.blocks:addParam(skillshot.spellName, hero.charName .. " - " .. skillshot.name, SCRIPT_PARAM_ONOFF, true)
                    end
                    --[[
                    if skillshot.blockable == true then
                        Config.SMevade:addParam(skillshot.spellName, hero.charName .. " - " .. skillshot.name, SCRIPT_PARAM_ONOFF, true)
                    end
                    ]]
                end
            end
        end
    end

    Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "drawing")   
        Settings.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
        Settings.drawing:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
        Settings.drawing:addParam("Text", "Draw Text on Target", SCRIPT_PARAM_ONOFF, true)
        Settings.drawing:addParam("myHero", "Draw My Range", SCRIPT_PARAM_ONOFF, true)
        Settings.drawing:addParam("myColor", "Draw My Range Color", SCRIPT_PARAM_COLOR, {255, 74, 26, 255})
        Settings.drawing:addParam("qDraw", "Draw "..SkillQ.name.." Range", SCRIPT_PARAM_ONOFF, true)
        Settings.drawing:addParam("qColor", "Draw "..SkillQ.name.." Color", SCRIPT_PARAM_COLOR, {255, 74, 26, 255})
        Settings.drawing:addParam("wDraw", "Draw "..SkillW.name.." Range", SCRIPT_PARAM_ONOFF, true)
        Settings.drawing:addParam("wColor", "Draw "..SkillW.name.." Color", SCRIPT_PARAM_COLOR, {255, 74, 26, 255})
        Settings.drawing:addParam("eDraw", "Draw "..SkillE.name.." Range", SCRIPT_PARAM_ONOFF, true)
        Settings.drawing:addParam("eColor", "Draw "..SkillE.name.." Color", SCRIPT_PARAM_COLOR, {255, 74, 26, 255})
        Settings.drawing:addParam("rDraw", "Draw "..SkillR.name.." Range", SCRIPT_PARAM_ONOFF, true)
        Settings.drawing:addParam("rColor", "Draw "..SkillR.name.." Color", SCRIPT_PARAM_COLOR, {255, 74, 26, 255})
        
        Settings.drawing:addSubMenu("Lag Free Circles", "lfc")  
            Settings.drawing.lfc:addParam("lfc", "Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
            Settings.drawing.lfc:addParam("CL", "Quality", 4, 75, 75, 2000, 0)
            Settings.drawing.lfc:addParam("Width", "Width", 4, 1, 1, 10, 0)
    
    Settings:addSubMenu("["..myHero.charName.."] - Misc Settings", "misc")
        Settings.misc:addParam("usePackets", "Use Packets", SCRIPT_PARAM_ONOFF, true)
        Settings.misc:addParam("autoPot", "Auto-Pots", SCRIPT_PARAM_ONOFF, true)
        Settings.misc:addParam("usePots", "use when at % hp", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
        Settings.misc:addParam("useqss", "Auto-QSS", SCRIPT_PARAM_ONOFF, true)
        Settings.misc:addParam("delay", "Activation delay", SCRIPT_PARAM_SLICE, 0, 0, 250, 0)
        Settings.misc:permaShow("usePackets")
        Settings.misc:permaShow("useqss")

    --Settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
        --SxOrb:LoadToMenu(Settings.Orbwalking)
    
    TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, SkillQ.range, DAMAGE_PHYSICAL)
    TargetSelector.name = "Gosu"
    Settings:addTS(TargetSelector)

end

function Variables()
    SkillQ12 = { name = "Steel Tempest", range = 475, delay = 0.25, speed = 1200, width = 55, ready = false }
    SkillQ3 = { name = "Yasuoq3w", range = 1000, delay = 0.5, speed = 1500, width = 90, ready = false }
    SkillQ = { name = "Steel Tempest", range = 475, delay = 0.25, speed = 1200, width = 55, ready = false }
    SkillW = { name = "WindWall", range = 475, delay = 0.4, speed = math.huge, width = 400, ready = false }
    SkillE = { name = "Sweeping Blade", range = 475, delay = 0.25, speed = 1200, width = nil, ready = false }
    SkillR = { name = "Last Breath", range = 1200, delay = 0.4, speed = math.huge, ready = false }
    ignite = { name = "summonerdot", range = 600, slot = nil }
    
    enemyMinions = minionManager(MINION_ENEMY, SkillQ.range, myHero, MINION_SORT_HEALTH_ASC)
    JungleMinions = minionManager(MINION_JUNGLE, SkillQ.range, myHero, MINION_SORT_HEALTH_ASC)
    Minions = minionManager(MINION_ENEMY, 1300, player, MINION_SORT_HEALTH_ASC)
    
    VP = VPrediction()
    
    JungleMobs = {}
    JungleFocusMobs = {}
    
    if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
        ignite = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
        ignite = SUMMONER_2
    end
    
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
        if ValidTarget(Mob, SkillQ.range) then return Mob end
    end
    for _, Mob in pairs(JungleMobs) do
        if ValidTarget(Mob, SkillQ.range) then return Mob end
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
        --if GetDistance(obj)<50 then PrintChat(""..obj.name) end
    if GetDistance(obj)<100 and obj.name:lower():find("yasuo") and obj.name:lower():find("trail") then
        --PrintChat("BLA")
        attacked = true
    end
    if obj and obj.name==Champions["Ezreal"].skillshots["EzrealTrueshotBarrage"].projectileName then 
        fuckedUpParticle = obj 
        fuckedUpSpell = Champions["Ezreal"].skillshots["EzrealTrueshotBarrage"]
    end
    if obj and obj.name==Champions["Ashe"].skillshots["EnchantedCrystalArrow"].projectileName then 
        fuckedUpParticle = obj 
        fuckedUpSpell = Champions["Ashe"].skillshots["EnchantedCrystalArrow"]        
    end
    if obj and obj.name==Champions["Ziggs"].skillshots["ZiggsR"].projectileName then 
        fuckedUpParticle = obj 
        fuckedUpSpell = Champions["Ziggs"].skillshots["ZiggsR"]
    end
    if obj and obj.name==Champions["Caitlyn"].skillshots["CaitlynHeadshotMissile"].projectileName then 
        fuckedUpParticle = obj 
        fuckedUpSpell = Champions["Caitlyn"].skillshots["CaitlynHeadshotMissile"]
    end

 
    if obj and GetDistance(obj)<=50 then
        if obj.name == qBuffName then 
            SteelTempest = true
        end
    end

    if obj.name=="Yasuo_base_R_indicator.beam.troy" then
        knockedUp = knockedUp + 1
    end
    if GetDistance(myHero, obj) < 50 and obj.name:lower():find("teleporthome") then
        isRecalling = true
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
        if obj.name=="Yasuo_base_R_indicator.beam.troy" then
        knockedUp = knockedUp - 1
    end

    if obj and GetDistance(obj)<=50 then
        if obj.name == qBuffName then 
                SteelTempest = false
        end
    end
    if GetDistance(myHero, obj) < 50 and obj.name:lower():find("teleporthome") then
        DelayAction(function() isRecalling = false end, 0.5)
    end
end

function lowHp(unit)
    if unit.health <= (Settings.misc.usePots/100*myHero.maxHealth) then
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

function CanCast(spell)
return myHero:CanUseSpell(spell) == READY
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
                    end, Settings.misc.delay/1000)    
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

function CountEnemiesNearUnitReg(unit, range)
    local count = 0
    for i, enemy in pairs(sEnemies) do
        if not enemy.dead and enemy.visible then
            if  GetDistanceSqr(unit, enemy) < range * range  then 
                count = count + 1 
            end
        end
    end
    return count
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

function TrueRange()
    return myHero.range + GetDistance(myHero, myHero.minBBox)
end

-- Trees
function GetCustomTarget()
    TargetSelector:update()     
    if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
    return TargetSelector.target
end

function ResetAA()
    if _G.AutoCarry then _G.AutoCarry.Orbwalker:ResetAttackTimer() end
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
        local hit = CountObjectsNearPos(object.visionPos or object, range, radius, objects)
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
        if GetDistance(pos, object) <= radius then
            n = n + 1
        end
    end
    return n
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

function DrawCircle2(x, y, z, radius, color)
  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
  
  if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
    DrawCircleNextLvl(x, y, z, radius, Settings.drawing.lfc.Width, color, Settings.drawing.lfc.CL) 
  end
end

function findClosestEnemy(obj)
    local closestEnemy = nil
    local currentEnemy = nil
    for i, currentEnemy in pairs(sEnemies) do
        if ValidTarget(currentEnemy) then
            if closestEnemy == nil then
                closestEnemy = currentEnemy
            end
            if GetDistanceSqr(currentEnemy.pos, obj) < GetDistanceSqr(closestEnemy.pos, obj) then
                closestEnemy = currentEnemy
            end
        end
    end
    return closestEnemy
end

function OnTowerFocus(tower, unit) 
    if GetDistance(tower) < 775+SkillE.range and not (myHero.team == tower.team) and not unit.isMe then
        towerUnit = unit
    end
    if unit.isMe then 
        Tower = tower
    end
end 

function OnTowerIdle(tower) 
    if GetDistance(tower) < 775+SkillE.range and not (myHero.team == tower.team) then
        --towerUnit = nil
    end    
    if towerUnit and towerUnit.dead then
        towerUnit = nil
    end
    Tower = nil
end

function OnProcessSpell(object,spellProc)
    --if(object.charName=="Yasuo") then PrintChat(spellProc.name .. " " .. object.charName) end
    if object.isMe and spellProc.name:lower():find("recall") then
        --PrintChat(spellProc.name)
    end    

    if myHero.dead then return end
    if object.isMe and spellProc.name:lower():find("attack") then
        animTime = spellProc.animationTime*0.1
    end
    if object.isMe and (spellProc.name == "yasuoq" or spellProc.name == "yasuoq2" or spellProc.name == "yasuoq3w")then
        ResetAA()
    end

    if Settings.blocks.autoW then 
        if object.team ~= player.team and string.find(spellProc.name, "Basic") == nil then
            if Champions[object.charName] ~= nil then
                skillshot = Champions[object.charName].skillshots[spellProc.name]
                if  skillshot ~= nil and skillshot.blockable == true and not skillshot.fuckedUp then
                    range = skillshot.range
                    if not spellProc.startPos then
                        spellProc.startPos.x = object.x
                        spellProc.startPos.z = object.z                        
                    end                    
                    if GetDistance(spellProc.startPos) <= range then
                        if GetDistance(spellProc.endPos) <= SkillW.range then
                            if SkillW.ready and Settings.blocks[spellProc.name] == true then 
                                if Settings.misc.usePackets then
                                --PrintChat("W TEST")
                                    Packet("S_CAST", {spellId = _W, toX=object.x, toY=object.z, fromX=object.x, fromY=object.z}):send()
                                else
                                    CastSpell(_W, object.x, object.z)
                                end
                            end
                        end
                    end
                end
                if skillshot ~= nil and skillshot.fuckedUp then 
                    if fuckedUpObject == nil then
                        fuckedUpSpell = skillshot 
                        fuckedUpObject = object
                    end
                end
            end
        end 
    end
    if myHero.dead then return end
    if object.team == myHero.team then return end
    
    if Interrupt[object.charName] ~= nil then
        spell = Interrupt[object.charName].stop[spellProc.name]
        if spell ~= nil then
            if Settings.interrupt[spellProc.name] then
                if ValidTarget(unit) and GetDistance(object) < SkillQ3.range and SkillQ3.ready and Settings.interrupt.r then
                    Q3(unit)
                end
            end
        end
    end
        
    local unit = object
    local spell = spellProc
    
    if unit.type == myHero.type and unit.team ~= myHero.team and isAGapcloserUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then         
        if spell.name == (type(isAGapcloserUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isAGapcloserUnit[unit.charName].spell).name or isAGapcloserUnit[unit.charName].spell) and Settings.gapClose[unit.charName] then
            if spell.target ~= nil and spell.target and spell.target.networkID == myHero.networkID or isAGapcloserUnit[unit.charName].spell == 'blindmonkqtwo' then
               Q3(object)
            elseif not spell.target then
                local startPos1 = Vector(unit.visionPos) + 300 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
                local startPos2 = Vector(unit.visionPos) + 100 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
                if (GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos1) or GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos2))  then
                   Q3(startPos1.x, startPos2.z)
                end
            end
        end
    end
end


function dodge(skillshot)
    if canDodge(skillshot) then
        PrintChat("1")
        local Minion = nil
        enemyMinions:update()
        for index, minion in pairs(enemyMinions.objects) do
            if ValidTarget(minion) and getNearestMinion(mousePos) then
                if GetDistance(skillshot.endPos, minion)+(SkillE.range/2) > skillshot.radius then
                    PrintChat("2")  
                    Minion = enemyMinions
                end
            end
        end 
        E(_E, Minion)
    end
end

function canDodge(skillshot)
    PrintChat("D1")
    if ((myHero.ms + SkillE.range)/skillshot.radius) > (skillshot.castDelay + (skillshot.projectileSpeed/GetDistance(skillshot.startPos, skillshot.endPos))) then 
        return true
    else 
        return false
    end
end

function dodgeTowerMinion(position, distance)
    enemyMinions:update()
    for index, minion in pairs(enemyMinions.objects) do
        if ValidTarget(minion) and getNearestMinion(myHero) and GetDistance(eEndPos(minion), position) > distance then
                return minion
        end
    end 
    return nil    
end

function fuckedUpSpells()
    if fuckedUpSpell.spellName == "KatarinaR" and fuckedUpObject.charName == "Katarina" then
        local object = fuckedUpObject
        if GetDistance(fuckedUpObject)-SkillW.range < fuckedUpSpell.range then
            if SKillW.ready and Settings.blocks[fuckedUpSpell.spellName] then
                fuckedUpSpell = nil
                fuckedUpObject = nil
                CastSpell(_W, object, object)
            end            
        end 
    elseif fuckedUpParticle ~= nil and GetDistance(fuckedUpParticle) < SkillW.range and (fuckedUpSpell.spellName == "EzrealTrueshotBarrage" or fuckedUpSpell.spellName == "EnchantedCrystalArrow" or fuckedUpSpell.spellName == "ZiggsR" or fuckedUpSpell.spellName == "CaitlynHeadshotMissile" or fuckedUpSpell.spellName == "RocketGrabMissile" or fuckedUpSpell.spellName == "DarkBindingMissile" or fuckedUpSpell.spellName == "GravesClusterShot" or fuckedUpSpell.spellName == "LuxLightBinding" or fuckedUpSpell.spellName == "AatroxE" or fuckedUpSpell.spellName == "AatroxQ" or fuckedUpSpell.spellName == "AhriOrbofDeception" or fuckedUpSpell.spellName == "AhriSeduce" or fuckedUpSpell.spellName == "BandageToss" or fuckedUpSpell.spellName == "FlashFrostSpell" or fuckedUpSpell.spellName == "Frostbite" or fuckedUpSpell.spellName == "AkaliQ" or fuckedUpSpell.spellName == "Volley" or fuckedUpSpell.spellName == "Disintegrate" or fuckedUpSpell.spellName == "Incinerate" or fuckedUpSpell.spellName == "BrandBlaze" or fuckedUpSpell.spellName == "BrandWildfire" or fuckedUpSpell.spellName == "CaitlynPiltoverPeacemaker" or fuckedUpSpell.spellName == "CassiopeiaTwinFang" or fuckedUpSpell.spellName == "FeralScream" or fuckedUpSpell.spellName == "PhosphorusBomb" or fuckedUpSpell.spellName == "MissileBarrageBig" or fuckedUpSpell.spellName == "DariusAxeGrabCone" or fuckedUpSpell.spellName == "DianaArc" or fuckedUpSpell.spellName == "DravenDoubleShot" or fuckedUpSpell.spellName == "DravenRCast" or fuckedUpSpell.spellName == "EliseHumanE" or fuckedUpSpell.spellName == "EliseHumanQ" or fuckedUpSpell.spellName == "EliseHumanW" or fuckedUpSpell.spellName == "EzrealMysticShot" or fuckedUpSpell.spellName == "EzrealEssenceFlux" or fuckedUpSpell.spellName == "EzrealMysticShotPulse" or fuckedUpSpell.spellName == "HextechMicroRockets" or fuckedUpSpell.spellName == "CH-2ElectronStormGrenade" or fuckedUpSpell.spellName == "DarkWind" or fuckedUpSpell.spellName == "FizzMarinerDoom" or fuckedUpSpell.spellName == "GalioResoluteSmite" or fuckedUpSpell.spellName == "GragasBarrelRoll" or fuckedUpSpell.spellName == "GravesChargeShot" or fuckedUpSpell.spellName == "SmokeScreen" or fuckedUpSpell.spellName == "HowlingGale" or fuckedUpSpell.spellName == "JayceToTheSkies" or fuckedUpSpell.spellName == "jayceshockblast" or fuckedUpSpell.spellName == "JinxWMissile" or fuckedUpSpell.spellName == "JinxRWrapper" or fuckedUpSpell.spellName == "KarmaQ" or fuckedUpSpell.spellName == "NullSphere" or fuckedUpSpell.spellName == "KatarinaQ" or fuckedUpSpell.spellName == "Reckoning" or fuckedUpSpell.spellName == "KennenShurikenHurlMissile1" or fuckedUpSpell.spellName == "KhazixW" or fuckedUpSpell.spellName == "khazixwlong" or fuckedUpSpell.spellName == "CausticSpittle" or fuckedUpSpell.spellName == "KogMawVoidOozeMissile" or fuckedUpSpell.spellName == "" or fuckedUpSpell.spellName == "SigilQ" or fuckedUpSpell.spellName == "LeblancChaosOrbM" or fuckedUpSpell.spellName == "LeblancSoulShackle" or fuckedUpSpell.spellName == "LeblancSoulShackleM" or fuckedUpSpell.spellName == "BlindMonkQOne" or fuckedUpSpell.spellName == "LissandraQ" or fuckedUpSpell.spellName == "LissandraE" or fuckedUpSpell.spellName == "LucianQ" or fuckedUpSpell.spellName == "LucianW" or fuckedUpSpell.spellName == "LuluQ" or fuckedUpSpell.spellName == "LuxLightStrikeKugel" or fuckedUpSpell.spellName == "LuxMaliceCannon" or fuckedUpSpell.spellName == "SeismicShard" or fuckedUpSpell.spellName == "MaokaiTrunkLine" or fuckedUpSpell.spellName == "InfectedCleaverMissile" or fuckedUpSpell.spellName == "NamiQ" or fuckedUpSpell.spellName == "NautilusAnchorDrag" or fuckedUpSpell.spellName == "JavelinToss" or fuckedUpSpell.spellName == "NocturneDuskbringer" or fuckedUpSpell.spellName == "OlafAxeThrow" or fuckedUpSpell.spellName == "SpearShot" or fuckedUpSpell.spellName == "QuinnQ" or fuckedUpSpell.spellName == "RumbleGrenade" or fuckedUpSpell.spellName == "RengarE" or fuckedUpSpell.spellName == "RivenR" or fuckedUpSpell.spellName == "Overload" or fuckedUpSpell.spellName == "SpellFlux" or fuckedUpSpell.spellName == "TwoShivPoison" or fuckedUpSpell.spellName == "ShyvanaFireball" or fuckedUpSpell.spellName == "Fracture" or fuckedUpSpell.spellName == "SivirQ" or fuckedUpSpell.spellName == "HymnofValor" or fuckedUpSpell.spellName == "SonaCrescendo" or fuckedUpSpell.spellName == "Decrepify" or fuckedUpSpell.spellName == "Torment" or fuckedUpSpell.spellName == "SyndraQ" or fuckedUpSpell.spellName == "Cutthroat" or fuckedUpSpell.spellName == "ShadowAssault" or fuckedUpSpell.spellName == "Dazzle" or fuckedUpSpell.spellName == "BlindingDart" or fuckedUpSpell.spellName == "ThreshQ" or fuckedUpSpell.spellName == "BusterShot" or fuckedUpSpell.spellName == "WildCards" or fuckedUpSpell.spellName == "goldcardlock" or fuckedUpSpell.spellName == "TwitchVenomCask" or fuckedUpSpell.spellName == "Expunge" or fuckedUpSpell.spellName == "UdyrPhoenixStance" or fuckedUpSpell.spellName == "UrgotHeatseekingLineMissile" or fuckedUpSpell.spellName == "UrgotPlasmaGrenade" or fuckedUpSpell.spellName == "VayneCondemn" or fuckedUpSpell.spellName == "BalefulStrike" or fuckedUpSpell.spellName == "XerathArcanopulseChargeUp2" or fuckedUpSpell.spellName == "XerathArcaneBarrage2" or fuckedUpSpell.spellName == "XerathLocusOfPower2" or fuckedUpSpell.spellName == "yasuoq3w" or fuckedUpSpell.spellName == "ZedShuriken" or fuckedUpSpell.spellName == "ZiggsQ" or fuckedUpSpell.spellName == "ZiggsW" or fuckedUpSpell.spellName == "ZiggsE" or fuckedUpSpell.spellName == "TimeBomb" or fuckedUpSpell.spellName == "ZyraGraspingRoots" or fuckedUpSpell.spellName == "zyrapassivedeathmanager") then 
            if SkillW.ready and Settings.blocks[fuckedUpSpell.spellName] and fuckedUpParticle.x > 0 and fuckedUpParticle.z > 0 then
                fuckedUpSpell = nil
                fuckedUpObject = nil
                object = fuckedUpParticle
                PrintChat("FUP: "..fuckedUpParticle.x .."/"..fuckedUpParticle.z.."   MH:"..myHero.x..""..myHero.z)
                fuckedUpParticle = nil                
                CastSpell(_W, object.x, object.z)
            end 
    end
end
