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
local Stacks5 = false
local Stack = false

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

    QSpell = _Spell({Slot = _Q, DamageName = "Q", Range = 900, Width = 55, Delay = 0.5, Speed = math.huge, Collision = false, Aoe = false, Type = SPELL_TYPE.LINEAR}):AddDraw()
    WSpell = _Spell({Slot = _W, DamageName = "W", Range = 600, Delay = 0.25, Speed = math.huge, Collision = false, Aoe = false, Type = SPELL_TYPE.TARGETTED}):AddDraw()
    ESpell = _Spell({Slot = _E, DamageName = "E", Range = 600, Delay = 0.25, Speed = math.huge, Collision = false, Aoe = true, Type = SPELL_TYPE.TARGETTED}):AddDraw()

    Menu()
    Init()

    enemyMinions = minionManager(MINION_ENEMY, qRange, myHero, MINION_SORT_HEALTH_ASC)

    VP = VPrediction()

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
        --[2003]            = "RegenerationPotion",
        [3146]              = "HextechGunblade",
        [3187]              = "HextechSweeper",
        [3190]              = "IronStylus",
        --[2004]                = "FlaskOfCrystalWater",
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

function Init()
       
    qRange = 900
    wRange = 600
    eRange = 600
    rRange = 200

    if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then 
        ignite = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then 
        ignite = SUMMONER_2
    else 
        ignite = nil
    end

    ts = TargetSelector(TARGET_NEAR_MOUSE, qRange, DAMAGE_PHYSICAL, true)   
    ts.name = "Gosu"
    Config:addTS(ts)

    initDone = true
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
    Config.SMfarm:addDynamicParam("jfarm", "Jungle Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))

    --Config:addParam("isPressed", "debug", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
    --Config.SMharass:addParam("autoQ", "Auto-Q", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("S"))
    Config.SMsmart:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMsmart:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMsmart:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMsmart:addParam("aa", "Enable AutoAttacks", SCRIPT_PARAM_ONOFF, true)

    Config.SMharass:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMharass:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMharass:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMharass:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
    Config.SMharass:addParam("aa", "Enable AutoAttacks", SCRIPT_PARAM_ONOFF, true)
    --Config.SMfarm:addParam("useOldLC", "Use old Lane Clear", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
    Config.SMfarm:addParam("aa", "Enable AutoAttacks", SCRIPT_PARAM_ONOFF, true)

    --Config.SMsbtw:addParam("useOrb", "Use Orbwalking", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("aa", "Enable AutoAttacks", SCRIPT_PARAM_ONOFF, true)
    Config.SMsbtw:addParam("combomode", "Combo Mode", SCRIPT_PARAM_LIST, 3, {"QWER", "WQER", "QWER"})
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

end

function OnTick()
    if initDone then

        --[[if OrbwalkManager:IsCombo() and Config.SMsbtw.aa then
        OrbwalkManager:DisableAttacks()
        end

        if OrbwalkManager:IsHarass() and Config.SMharass.aa then
        OrbwalkManager:DisableAttacks()
        end

        if OrbwalkManager:IsClear() and Config.SMfarm.aa then
        OrbwalkManager:DisableAttacks()
        end

        if OrbwalkManager:IsLastHit() and Config.SMsmart.aa then
        OrbwalkManager:DisableAttacks()
        end]]


        GetItemSlot()

        ts:update()
        Target = ts.target

        enemyMinions:update()

        QREADY = (myHero:CanUseSpell(_Q) == READY)
        EREADY = (myHero:CanUseSpell(_E) == READY)
        WREADY = (myHero:CanUseSpell(_W) == READY)
        RREADY = (myHero:CanUseSpell(_R) == READY)
        IREADY = (igniteSpell ~= nil and myHero:CanUseSpell(igniteSpell) == READY)

        if Config.SMother.killsteal then KillSteal() end

        if Config.SMsbtw.sbtw then 
            Combo(Target) 
        elseif Config.SMfarm.farm then
            LaneClear()
        elseif Config.SMsmart.smartfarm then
            smartfarm()
        end

        if Config.SMother.usePots then
            AutoPots()
        end
        
        AutoIgnite()

    end
end

function Combo(unit)
    if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then

        if Config.SMsbtw.combomode == 1 then
            if Config.SMsbtw.useQ and QREADY then
                CastQ(unit)
            end
            if Config.SMsbtw.useR and RREADY and Stacks5 then
               CastSpell(_R)
            end
            if Config.SMsbtw.useW and WREADY then
                CastW(unit)
            end
            if Config.SMsbtw.useE and EREADY and not QREADY then
                CastE(unit)
                end
            end
        if Config.SMsbtw.combomode == 2 then
            if Config.SMsbtw.useW and WREADY then
                CastW(unit)
            end
            if Config.SMsbtw.useQ and QREADY then
                CastQ(unit)
            end
            if Config.SMsbtw.useR and RREADY and Stacks5 then
               CastSpell(_R)
            else
                CastSpell(_R)
            end
            if Config.SMsbtw.useQ and EREADY and not QREADY then
                CastE(unit)
            end
        end
        if Config.SMsbtw.combomode == 3 then
            if Config.SMsbtw.useQ and QREADY then
                CastQ(unit)
            end
            if Config.SMsbtw.useW and WREADY then
                CastW(unit)
            end
            if Config.SMsbtw.useQ and QREADY then
                CastQ(unit)
            end
            if Config.SMsbtw.useE and EREADY and not QREADY then
                CastE(unit)
            end
            if Config.SMsbtw.useQ and QREADY then
                CastQ(unit)
            end
            if Config.SMsbtw.useR and RREADY and Stacks5 then
               CastSpell(_R)
            end
            if Config.SMsbtw.useQ and QREADY then
                CastQ(unit)
            end
        end
    end
end

function LaneClear()

    enemyMinions:update()  

    for i, minion in pairs(enemyMinions.objects) do
        if minion ~= nil and ValidTarget(minion, qRange) and Config.SMfarm.useQ and QREADY and getDmg("AD", minion, myHero) < minion.health then
            if getDmg("Q", minion, myHero) >= minion.health then
                CastSpell(_Q, minion)
            else
                CastSpell(_Q, minion)
            end 
        end
        if minion ~= nil and ValidTarget(minion, wRange) and Config.SMfarm.useR and RREADY and Stacks5 then
                CastSpell(_R)
            end
            if minion ~= nil and ValidTarget(minion, eRange) and Config.SMfarm.useE and ERADY and not Qready then
                if getDmg("E", minion, myHero) >= minion.health then
                    CastSpell(_E, minion)
                else
                    CastSpell(_E, minion)
            end
        end
            if minion ~= nil and ValidTarget(minion, wRange) and Config.SMfarm.useW and WREADY and not Qready and getDmg("AD", minion, myHero) < minion.health then
                if not Config.SMfarm.useW then
                    if getDmg("W", minion, myHero) >= minion.health then
                        CastSpell(_W, minion)
                    else
                        CastSpell(_W, minion)
                    end
                end
            end
    end
end

function CastQ(unit)
    if unit ~= nil and GetDistance(unit) <= qRange then
        if VIP_USER and Config.SMother.usePackets then
             Packet("S_CAST", {spellId = _Q, toX=CastPosition.x, toY=CastPosition.z, fromX=CastPosition.x, fromY=CastPosition.z}):send()   
        else
            QSpell:Cast(unit)
        end
    end
end

function CastW(unit)
    if unit ~= nil and GetDistance(unit) <= wRange then
        if VIP_USER and Config.SMother.usePackets then
            Packet("S_CAST", {spellId = _W, targetNetworkId = unit.networkID}):send()
        else
            WSpell:Cast(unit)
        end
    end
end

function CastE(unit)
    if unit ~= nil and GetDistance(unit) <= eRange then
        if VIP_USER and Config.SMother.usePackets then
            Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
        else
            ESpell:Cast(unit)
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

    if unit and unit.isMe and buff.name == "ryzepassivecharged" then
        Stacks5 = true
    end
    if unit and unit.isMe and buff.name == "ryzepassivestack" then
        Stack = true
    end
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
        if unit and unit.isMe and buff.name == "ryzepassivecharged" then
            Stacks5 = false
        end
        if unit and unit.isMe and buff.name == "ryzepassivestack" then
            Stack = false
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
