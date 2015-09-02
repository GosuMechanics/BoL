if myHero.charName ~= "Cassiopeia" then return end

local Ignite = nil
local TS, Menu = nil, nil
local PredictedDamage = {}
local RefreshTime = 0.4
local UsingPot = false
local UsingMPot = false
local lastRemove = 0

function OnLoad()

    require 'SimpleLib'

    TS = _SimpleTargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_MAGIC)

    ScriptName = "GosuMechanics"
    champName = "Cassiopeia"
    LoadVariables()
    LoadMenu()

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

function LoadVariables()
    --TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1100, DAMAGE_PHYSICAL)
    EnemyMinions = minionManager(MINION_ENEMY, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
    JungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
    Menu = scriptConfig(ScriptName.." "..champName, ScriptName.."29082015")
    AA = {            Range = function(target) return 620 end, Damage = function(target) return getDmg("AD", target, myHero) end }
    QSpell  = _Spell({ Slot = _Q, DamageName = "Q", Range = 800, Width = 100, Delay = 0.25, Speed = math.huge, Type = SPELL_TYPE.CIRCULAR, LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) end}):AddDraw()
    WSpell  = _Spell({ Slot = _W, DamageName = "W", Range = 800, Width = 100, Delay = 0.5, Speed = math.huge, Type = SPELL_TYPE.CIRCULAR, LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end}):AddDraw()
    ESpell  = _Spell({ Slot = _E, DamageName = "E", Range = 700, Width = nil, Delay = nil, Speed = 1500, Type = SPELL_TYPE.TARGETTED, LastCastTime = 0, Collision = false, Aoe = false, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end, Missile = true}):AddDraw()
    RSpell  = _Spell({ Slot = _R, DamageName = "R", Range = 850, Width = 410, Delay = 0.5, Speed = math.huge, Type = SPELL_TYPE.CONE, LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end}):AddDraw()
    Ignite = _Spell({Slot = FindSummonerSlot("summonerdot"), DamageName = "IGNITE", Range = 600, Type = SPELL_TYPE.TARGETTED}):AddDraw()

end

function LoadMenu()

    Menu:addSubMenu("["..myHero.charName.."] - Combo Settings", "Combo")
        Menu.Combo:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        --Menu.Combo:addParam("delayQ", "Use Q Humanizer", SCRIPT_PARAM_SLICE, 0, 0, 5, 3)
        Menu.Combo:addParam("QP", "Use Q on Poisoned", SCRIPT_PARAM_ONOFF, true)
        Menu.Combo:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
        --Menu.Combo:addParam("delayW", "Use W Humanizer", SCRIPT_PARAM_SLICE, 0, 0, 5, 3)
        Menu.Combo:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
        Menu.Combo:addParam("delayE", "Use E Humanizer", SCRIPT_PARAM_SLICE, 0, 0, 5, 3)
        Menu.Combo:addParam("Ignite", "Use Ignite", SCRIPT_PARAM_LIST, 1, {"Never", "If Killable" , "Always"})

    Menu.Combo:addSubMenu("["..myHero.charName.."] - Combo Ult Settings", "ults")
        Menu.Combo.ults:addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
        --Menu.Combo.ults:addParam("RL", "at x enemy hp ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
        Menu.Combo.ults:addParam("R1", "when will Hit x enemy", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)

    Menu:addSubMenu("["..myHero.charName.."] - Harass Settings", "Harass")
        Menu.Harass:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.Harass:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.Harass:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)  
        
    Menu:addSubMenu("["..myHero.charName.."] - LaneClear Settings", "LaneClear")
        Menu.LaneClear:addParam("Q", "Use Q (min. hit)", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
        Menu.LaneClear:addParam("W", "Use W (min. hit)", SCRIPT_PARAM_SLICE, 3 , 0, 5, 0)
        Menu.LaneClear:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true) 

    Menu:addSubMenu("["..myHero.charName.."] - JungleClear Settings", "JungleClear")
        Menu.JungleClear:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.JungleClear:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.JungleClear:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("["..myHero.charName.."] - LastHit Settings", "LastHit")
        Menu.LastHit:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.LastHit:addParam("E", "Use LastHit E Poisoned ", SCRIPT_PARAM_ONOFF, true)
        Menu.LastHit:addParam("ENP", "Use LastHit E NonPoisoned ", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("["..myHero.charName.."] - Misc Settings", "Misc")
        Menu.Misc:addParam("Overkill", "Overkill % Checks", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
        Menu.Misc:addParam("autoPots", "Use HP Pots", SCRIPT_PARAM_ONOFF, true)
        Menu.Misc:addParam("usePots", "Use when x HP", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
        Menu.Misc:addParam("autoMPots", "Use Mana Pots", SCRIPT_PARAM_ONOFF, true)
        Menu.Misc:addParam("useMPots", "Use when x mana", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

    Menu.Combo:addSubMenu("Interrupt w/ PetrifyingGaze", "R")
            _Interrupter(Menu.Combo.R):CheckChannelingSpells():CheckGapcloserSpells():AddCallback(
                function(target)
                    local Position = Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized() * RSpell.Range
                    if RSpell:IsReady() and IsValidTarget(target, RSpell.Range) then
                        CastSpell(RSpell.Slot, Position.x, Position.z)
                        --print("Interrupt Test")
                    end
                end
            )
    Menu:addSubMenu("["..myHero.charName.."] - KillSteal Settings", "KillSteal")
        Menu.KillSteal:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.KillSteal:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.KillSteal:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
        Menu.KillSteal:addParam("R", "Use R", SCRIPT_PARAM_ONOFF, false)
        Menu.KillSteal:addParam("Ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

        TS:AddToMenu(Menu)

end

function OnTick()
    if Menu == nil then return end
    TS:update()
    target = TS.target
    --if Menu.Combo.ults.ultR then AutoR() end
    if Menu.Misc.autoPots then AutoPots() end
    if Menu.Misc.autoMPots then AutoMpots() end
    if Menu.KillSteal.Q or Menu.KillSteal.E or Menu.KillSteal.R or Menu.KillSteal.Ignite then KillSteal() end         
    if OrbwalkManager:IsCombo() then
        Combo()
    elseif OrbwalkManager:IsLastHit() then
        LastHit()
    elseif OrbwalkManager:IsClear() then
        Clear()
    elseif OrbwalkManager:IsHarass() then
        Harass()
    end

function Combo()
    if OrbwalkManager.GotReset then return end
        local target = TS.target
        if IsValidTarget(target) then
            local q, w, e, r, dmg = GetBestCombo(target)

                if Menu.Combo.Ignite > 1 and Ignite:IsReady() then 
                    if Menu.Combo.Ignite == 2 then
                        if dmg / GetOverkill() > target.health then Ignite:Cast(target) end
                    else
                        Ignite:Cast(target)
                    end
                end
                if Menu.Combo.Q and not Menu.Combo.QP and not TargetPoisoned(target) then
                    --DelayAction(function()
                            QSpell:Cast(target)
                        --end, Menu.Combo.delayQ)
                    end
                    if Menu.Combo.Q and Menu.Combo.QP and TargetPoisoned(target) then
                        --DelayAction(function()
                            QSpell:Cast(target)
                        --end, Menu.Combo.delayQ)
                    end
                    if Menu.Combo.W and not Menu.Combo.WP then
                        --DelayAction(function()
                                WSpell:Cast(target)
                           -- end, Menu.Combo.delayW)
                        end
                        if Menu.Combo.E and TargetPoisoned(target) then
                            DelayAction(function()
                                    ESpell:Cast(target)
                                end, Menu.Combo.delayE)
                            end
                            --if Menu.Combo.Items and lowHp(myHero) and CountEnemyHeroInRange(300) >= 2 and GetInventoryItemIsCastable(3157)then
                                    --CastItem(3157)
                                --end
                                ---if Menu.Combo.Items and myHero.health <= (50/100*myHero.maxHealth) and GetInventoryItemIsCastable(3048) then
                                        ---CastItem(3048)
                                    ---end
                                    if Menu.Combo.ults.R and Menu.Combo.ults.R1 > 0 then
                                        if RSpell:IsReady() then
                                            for i, enemy in ipairs(GetEnemyHeroes()) do
                                                local CastPosition, WillHit, NumberOfHits = RSpell:GetPrediction(enemy, {TypeOfPrediction = "VPrediction", Type = SPELL_TYPE.CONE, Delay = 0.5, Width = 410, Range = 850, Collision = false, Aoe = true, Accuracy = 60, Source = myHero})
                                                if NumberOfHits and type(NumberOfHits) == "number" and NumberOfHits >= Menu.Combo.ults.R1 and WillHit then
                                                    CastSpell(RSpell.Slot, CastPosition.x, CastPosition.z)
                                                end
                                        end
                                 end
                        end
                end
        end
end

function Clear()

    if Menu.LaneClear.E then
        EnemyMinions:update()
        for i, minion in pairs(EnemyMinions.objects) do
            if ESpell:IsReady() and TargetPoisoned(minion) then
                ESpell:Cast(minion)
            end
            if Menu.LaneClear.Q then
                QSpell:LaneClear({ NumberOfHits = Menu.LaneClear.Q})
            end
            if Menu.LaneClear.W then
                WSpell:LaneClear({ NumberOfHits = Menu.LaneClear.W})
            end
            if Menu.LaneClear.E and ESpell:IsReady() and ESpell:Damage(minion) >= minion.health and TargetPoisoned(minion) then
                ESpell:Cast(minion)
            end
        end
    end
    if Menu.JungleClear.E then
        JungleMinions:update()
        for i, minion in pairs(JungleMinions.objects) do
            if ESpell:IsReady() and TargetPoisoned(minion) then
                ESpell:Cast(minion)
            end
            if Menu.JungleClear.Q then
                QSpell:JungleClear()
            end
            if Menu.JungleClear.W then
                WSpell:JungleClear()
            end
        end
    end
end

function LastHit()

    EnemyMinions:update()
        for i, minion in pairs(EnemyMinions.objects) do
            if ESpell:IsReady() and Menu.LastHit.E and not Menu.LastHit.ENP and ESpell:Damage(minion) >= minion.health and TargetPoisoned(minion) then
                ESpell:Cast(minion)
            end
            if ESpell:IsReady() and Menu.LastHit.ENP and not Menu.LastHit.E and ESpell:Damage(minion) >= minion.health then
                ESpell:Cast(minion)
            end
            if QSpell:IsReady() and Menu.LastHit.Q and not TargetPoisoned(minion) then
                QSpell:Cast(minion)
            end
        end
end

function Harass()
    local target = TS.target
    if IsValidTarget(target) then
        if Menu.Harass.Q then
            QSpell:Cast(target)
        end
        if Menu.Harass.W then
            WSpell:Cast(target)
        end
        if Menu.Harass.E and TargetPoisoned(target) then
            ESpell:Cast(target)
        end
    end
end

function GetOverkill()
    return ((Menu.Misc.Overkill/100)+100)
end

function GetBestCombo(target)
    if not IsValidTarget(target) then return false, false, false, false, 0 end
    local q = {false}
    local w = {false}
    local e = {false}
    local r = {false}
    local damagetable = PredictedDamage[target.networkID]
    if damagetable ~= nil then
        local time = damagetable[6]
        if os.clock() - time <= RefreshTime then 
            return damagetable[1], damagetable[2], damagetable[3], damagetable[4], damagetable[5] 
        else
            if QSpell:IsReady() then q = {false, true} end
            if WSpell:IsReady() then w = {false, true} end
            if ESpell:IsReady() then e = {false, true} end
            if RSpell:IsReady() then r = {false, true} end
            local bestdmg = 0
            local best = {QSpell:IsReady(), WSpell:IsReady(), ESpell:IsReady(), RSpell:IsReady()}
            local dmg, mana = GetComboDamage(target, QSpell:IsReady(), WSpell:IsReady(), ESpell:IsReady(), RSpell:IsReady() )
            bestdmg = dmg
            if dmg > target.health then
                for qCount = 1, #q do
                    for wCount = 1, #w do
                        for eCount = 1, #e do
                            for rCount = 1, #r do
                                local d, m = GetComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
                                if d >= target.health and myHero.mana >= m then
                                    if d < bestdmg then 
                                        bestdmg = d 
                                        best = {q[qCount], w[wCount], e[eCount], r[rCount]} 
                                    end
                                end
                            end
                        end
                    end
                end
                --return best[1], best[2], best[3], best[4], bestdmg
                damagetable[1] = best[1]
                damagetable[2] = best[2]
                damagetable[3] = best[3]
                damagetable[4] = best[4]
                damagetable[5] = bestdmg
                damagetable[6] = os.clock()
            else
                local table2 = {false,false,false,false}
                local bestdmg, mana = 0, 0
                for qCount = 1, #q do
                    for wCount = 1, #w do
                        for eCount = 1, #e do
                            for rCount = 1, #r do
                                local d, m = GetComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
                                if d > bestdmg and myHero.mana > m then 
                                    table2 = {q[qCount],w[wCount],e[eCount],r[rCount]}
                                    bestdmg = d
                                end
                            end
                        end
                    end
                end
                --return table2[1],table2[2],table2[3],table2[4], bestdmg
                damagetable[1] = table2[1]
                damagetable[2] = table2[2]
                damagetable[3] = table2[3]
                damagetable[4] = table2[4]
                damagetable[5] = bestdmg
                damagetable[6] = os.clock()
            end
            return damagetable[1], damagetable[2], damagetable[3], damagetable[4], damagetable[5]
        end
    else
        local dmg, mana = GetComboDamage(target, QSpell:IsReady(), WSpell:IsReady(), ESpell:IsReady(), RSpell:IsReady())
        PredictedDamage[target.networkID] = {false, false, false, false, dmg, os.clock() - RefreshTime * 2}
        return GetBestCombo(target)
    end
end

function GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if IsValidTarget(target) then
        if q then
            comboDamage = comboDamage + QSpell:Damage(target)
            currentManaWasted = currentManaWasted + QSpell:Mana()
        end
        if w then
            comboDamage = comboDamage + WSpell:Damage(target)
            currentManaWasted = currentManaWasted + WSpell:Mana()
        end
        if e then
            comboDamage = comboDamage + ESpell:Damage(target)
            currentManaWasted = currentManaWasted + ESpell:Mana()
        end
        if r then
            comboDamage = comboDamage + RSpell:Damage(target)
            currentManaWasted = currentManaWasted + RSpell:Mana()
        end
        if Ignite:IsReady() then comboDamage = comboDamage + Ignite:Damage(target) end
        comboDamage = comboDamage + getDmg("AD", target, myHero) * 2
    end
    comboDamage = comboDamage * GetOverkill()
    return comboDamage, currentManaWasted
end

function KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth < 0.3 and ValidTarget(enemy, TS.range) and enemy.visible then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health then
                if Menu.KillSteal.Q and ( q or QSpell:Damage(enemy) > enemy.health) then
                    QSpell:Cast(enemy)
                end
                if Menu.KillSteal.W and ( w or WSpell:Damage(enemy) > enemy.health) then 
                    WSpell:Cast(enemy)
                end
                if Menu.KillSteal.E and ( e or ESpell:Damage(enemy) > enemy.health) then 
                    ESpell:Cast(enemy)
                end
                if Menu.KillSteal.R and ( r or RSpell:Damage(enemy) > enemy.health) then 
                    RSpell:Cast(enemy)
                end
            end
            if Menu.KillSteal.Ignite and Ignite:IsReady() and Ignite:Damage(enemy) >= enemy.health and not enemy.dead then Ignite:Cast(enemy) end
        end
    end
end


function OnApplyBuff(source, unit, buff)

    --if buff and unit == myHero then print(buff.name) end
    if unit and unit.isMe and buff.name == "recall" then
        isRecalling = true
    end

    if not unit or not buff then return end
        if unit and unit.isMe and buff.name == "RegenerationPotion" then
            UsingPot = true
        end
        if unit and unit.isMe and buff.name == "FlaskOfCrystalWater" then
            UsingMpot = true
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
    if unit and unit.isMe and buff.name == "recall" then
        isRecalling = false
    end
end

function AutoPots()
    if GetInventoryItemIsCastable(2003) and lowHp(myHero) and not UsingPot and not IsRecalling then 
        CastItem(2003)
    end
end

function lowMana(unit)
    if unit.mana <= (Menu.Misc.useMPots/100*myHero.maxMana) then
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

function lowHp(unit)
    if unit.health <= (Menu.Misc.usePots/100*myHero.maxHealth) then
        return true
    else
        return false
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

function TargetPoisoned(unit)
    if TargetHaveBuff("cassiopeianoxiousblastpoison", unit)  or TargetHaveBuff("cassiopeiamiasmapoison", unit) then
            return true
        end
    return false
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
