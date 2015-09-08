if myHero.charName ~= "Ryze" then return end

local Q, W, E, R, Ignite = nil, nil, nil, nil, nil
local TS, Menu = nil, nil
local PredictedDamage = {}
local RefreshTime = 0.4

function OnLoad()

    require 'SimpleLib'

    ScriptName = "GosuMechanics"
    champName = "Ryze"
    LoadVariables()
    LoadMenu()

end

function LoadVariables()
    EnemyMinions = minionManager(MINION_ENEMY, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
    JungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
    Menu = scriptConfig(ScriptName.." "..champName, ScriptName.."29082015")
    QSpell = _Spell({Slot = _Q, DamageName = "Q", Range = 900, Width = 55, Delay = 0.25, Speed =1875, Collision = false, Aoe = false, Type = SPELL_TYPE.LINEAR}):AddDraw()
    QCSpell = _Spell({Slot = _Q, DamageName = "QC", Range = 900, Width = 55, Delay = 0.25, Speed =1875, Collision = true, Aoe = false, Type = SPELL_TYPE.LINEAR}):AddDraw()
    WSpell = _Spell({Slot = _W, DamageName = "W", Range = 600, Delay = 0.25, Type = SPELL_TYPE.TARGETTED}):AddDraw()
    ESpell = _Spell({Slot = _E, DamageName = "E", Range = 600, Delay = 0.25, Type = SPELL_TYPE.TARGETTED}):AddDraw()
    RSpell = _Spell({Slot = _R, DamageName = "R", Range = 200, Type = SPELL_TYPE.SELF}):AddDraw()
    Ignite = _Spell({Slot = FindSummonerSlot("summonerdot"), DamageName = "IGNITE", Range = 600, Type = SPELL_TYPE.TARGETTED}):AddDraw()
     
    Q = { IsReady = function() return QSpell:IsReady() end}
    W = { IsReady = function() return WSpell:IsReady() end}
    E = { IsReady = function() return ESpell:IsReady() end}
    R = { IsReady = function() return RSpell:IsReady() end}

    TS = _SimpleTargetSelector(TARGET_LESS_CAST_PRIORITY, 600, DAMAGE_MAGICAL)

end

function LoadMenu()

    Menu:addSubMenu("["..myHero.charName.."] - Combo Settings", "Combo")
        Menu.Combo:addParam("R5", "Use R in ComboWQEQ",SCRIPT_PARAM_ONOFF, true)
        Menu.Combo:addParam("R", "when x enemy in range", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
        Menu.Combo:addParam("Ignite", "Use Ignite", SCRIPT_PARAM_LIST, 1, {"Never", "If Killable" , "Always"})

        Menu.Combo:addSubMenu("["..myHero.charName.."] - Ryze Combos", "combo")
        Menu.Combo.combo:addParam("ComboWQEQ", "WQEQ 3Stacks noUlt/withUlt", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
        Menu.Combo.combo:addParam("ComboWQER", "WQER 1 Stack with Ult Only", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        Menu.Combo.combo:addParam("ComboQEWR", "EQWR 2 Stacks with Ult Only", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
        Menu.Combo.combo:addParam("ComboQEW", "EQW 2Stacks with NoUlt Only", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))

        Menu.Combo:addSubMenu("["..myHero.charName.."] - Advanced Ryze Combos", "adv")
        Menu.Combo.adv:addParam("ComboQEQ", "QEQ 3Stacks withUlt Only", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("H"))
        Menu.Combo.adv:addParam("ComboWQRE", "WQRE 3Stacks with Ult Only", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))

    Menu:addSubMenu("["..myHero.charName.."] - Harass Settings", "Harass")
        Menu.Harass:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.Harass:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.Harass:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
        
    Menu:addSubMenu("["..myHero.charName.."] - LaneClear Settings", "LaneClear")
        Menu.LaneClear:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.LaneClear:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.LaneClear:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("["..myHero.charName.."] - JungleClear Settings", "JungleClear")
        Menu.JungleClear:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.JungleClear:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.JungleClear:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
        Menu.JungleClear:addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("["..myHero.charName.."] - LastHit Settings", "LastHit")
        Menu.LastHit:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.LastHit:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.LastHit:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("["..myHero.charName.."] - Misc Settings", "Misc")
        Menu.Misc:addParam("Overkill", "Overkill % Checks", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)

        Menu.Misc:addSubMenu("Interrupt w/ EmpoweredTempest", "W")
            _Interrupter(Menu.Misc.W):CheckChannelingSpells():CheckGapcloserSpells():AddCallback(
                function(target)
                    if WSpell:IsReady() then
                        WSpell:Cast(target)
                        --print("Interrupt Test")
                    end
                end
            )
    Menu:addSubMenu("["..myHero.charName.."] - KillSteal Settings", "KillSteal")
        Menu.KillSteal:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.KillSteal:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.KillSteal:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
        Menu.KillSteal:addParam("Ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("["..myHero.charName.."] - Drawing Settings", "Draw")
        draw = Draw()
        draw:LoadMenu(Menu.Draw)

    Menu:addSubMenu("["..myHero.charName.."] - Key Settings", "Keys")
        Menu.Keys:addParam("HarassToggle", "Harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("L"))
        Menu.Keys:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("K"))
        Menu.Keys:addParam("LastHit", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
        Menu.Keys:addParam("Clear", "Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
        Menu.Keys:permaShow("HarassToggle")

        TS:AddToMenu(Menu)
end

function OnTick()
    if Menu == nil then return end
    TS:update()
    target = TS.target
    if Menu.KillSteal.Q or Menu.KillSteal.E or Menu.KillSteal.R or Menu.KillSteal.Ignite then KillSteal() end         
    if Menu.Combo.combo.ComboWQEQ then
        ComboWQEQ()
        myHero:MoveTo(mousePos.x, mousePos.z) 
    elseif Menu.Combo.combo.ComboWQER then
        ComboWQER()
        myHero:MoveTo(mousePos.x, mousePos.z) 
    elseif Menu.Combo.combo.ComboQEWR then
        ComboQEWR()
        myHero:MoveTo(mousePos.x, mousePos.z) 
    elseif Menu.Combo.combo.ComboQEW then
        ComboQEW()
        myHero:MoveTo(mousePos.x, mousePos.z) 
    elseif Menu.Combo.adv.ComboQEQ then
        ComboQEQ()
        myHero:MoveTo(mousePos.x, mousePos.z) 
    elseif Menu.Combo.adv.ComboWQRE then
        ComboWQRE()
        myHero:MoveTo(mousePos.x, mousePos.z) 
    elseif Menu.Keys.LastHit then
        LastHit()
    elseif Menu.Keys.Clear then
        Clear()
    elseif Menu.Keys.Harass then
        Harass()
    end
    if Menu.Keys.HarassToggle and not IsRecalling then
        Harass()
    end
end

function ComboWQEQ()
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
            if WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            end

            if Menu.Combo.R5 and Menu.Combo.R >0 and CountEnemyHeroInRange(WSpell.Range) >= Menu.Combo.R then
                RSpell:Cast()
            end
    end                
end

function ComboWQER()
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
            if WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and RSpell:IsReady() then
                RSpell:Cast()
            elseif not RSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and RSpell:IsReady() then
                RSpell:Cast()
            elseif not RSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            end
    end                
end

function ComboQEWR()
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
            if QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and RSpell:IsReady() then
                RSpell:Cast()
            elseif not RSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            end
    end                
end

function ComboQEW()
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
            if QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            end
    end                
end

function ComboQEQ()
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
            if QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and RSpell:IsReady() then
                RSpell:Cast()
            elseif not RSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            end
    end                
end

function ComboWQRE()
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
            if WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and RSpell:IsReady() then
                RSpell:Cast()
            elseif not RSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and RSpell:IsReady() then
                RSpell:Cast()
            elseif not RSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and RSpell:IsReady() then
                RSpell:Cast()
            elseif not RSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and RSpell:IsReady() then
                RSpell:Cast()
            elseif not RSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(target)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(target)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(target)
            end     
    end                
end

function Clear()

    if Menu.LaneClear.E then
        EnemyMinions:update()
        for i, minion in pairs(EnemyMinions.objects) do
            local eDmg = getDmg("E", minion, myHero)
            if Menu.LaneClear.E and ESpell:IsReady() and eDmg >= minion.health then
                ESpell:Cast(minion)
            else
                ESpell:Cast(minion)
            end
            local wDmg = getDmg("W", minion, myHero)
            if Menu.LaneClear.W and WSpell:IsReady() and not ESpell:IsReady() and wDmg >= minion.health then
                WSpell:Cast(minion)
            else
                WSpell:Cast(minion)
            end
            local qDmg = getDmg("Q", minion, myHero)
            if Menu.LaneClear.Q and QSpell:IsReady() and WSpell.Range and qDmg >= minion.health then
                QSpell:Cast(minion)
            else
                QSpell:Cast(minion)
            end
        end
    end
    JungleMinions:update()
    for i, minion in pairs(JungleMinions.objects) do
            if WSpell:IsReady() then
                WSpell:Cast(minion)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(minion)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(minion)
            elseif not ESpell:IsReady() and RSpell:IsReady() and Menu.JungleClear.R then
                RSpell:Cast()
            elseif not RSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(minion)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(minion)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(minion)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(minion)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(minion)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(minion)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(minion)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(minion)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(minion)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(minion)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(minion)
            elseif not ESpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(minion)
            elseif not QSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(minion)
            elseif not WSpell:IsReady() and QSpell:IsReady() then
                QSpell:Cast(minion)
            elseif not QSpell:IsReady() and ESpell:IsReady() then
                ESpell:Cast(minion)
            elseif not ESpell:IsReady() and RSpell:IsReady() and Menu.JungleClear.R then
                RSpell:Cast()
            elseif not RSpell:IsReady() and WSpell:IsReady() then
                WSpell:Cast(minion)
            end
    end
end

function LastHit()
        EnemyMinions:update()
        for i, minion in pairs(EnemyMinions.objects) do
            local eDmg = getDmg("E", minion, myHero)
            if Menu.LastHit.E and ESpell:IsReady() then
                if eDmg >= minion.health then
                    ESpell:Cast(minion)
                end
            end
            local qDmg = getDmg("Q", minion, myHero)
            if Menu.LastHit.Q and QCSpell:IsReady() then
                if qDmg >= minion.health then
                    QCSpell:Cast(minion)
                end
            end
            local wDmg = getDmg("W", minion, myHero)
            if Menu.LastHit.W and WSpell:IsReady() then
                if wDmg >= minion.health then
                    WSpell:Cast(minion)
                end
            end
    end
end

function Harass()
    local target = TS.target
    if IsValidTarget(target) then
        if Menu.Harass.Q then
            QCSpell:Cast(target)
        end
        if Menu.Harass.W then
            WSpell:Cast(target)
        end
        if Menu.Harass.W then
            ESpell:Cast(target)
        end
    end
end

function MoveToMouse()
    local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
    local Position = myHero + (Vector(MousePos) - myHero):normalized()*300
    myHero:MoveTo(Position.x, Position.z)
end

class "Draw"
function Draw:__init()
    self.Menu = nil
end

function Draw:LoadMenu(menu)
    self.Menu = menu
    self.Menu:addParam("dmg","Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)
    AddDrawCallback(function() self:OnDraw() end)
end

function Draw:OnDraw()
    if myHero.dead or self.Menu == nil then return end
    if self.Menu.dmg then self:DrawDamageCalculation()  end
end


function Draw:DrawDamageCalculation() 
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        local p = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
        if ValidTarget(enemy) and enemy.visible and OnScreen(p.x, p.y) then
            local dmg = (QSpell:Damage(enemy)+WSpell:Damage(enemy)+ESpell:Damage(enemy))
            local q = QSpell:Damage(enemy)
            local w = WSpell:Damage(enemy)
            local e = ESpell:Damage(enemy)
            if dmg >= enemy.health then
                self:DrawLineHPBar(dmg, "FUCK HIM! OR I WILL FUCK YOU!", enemy, true)
            else
                local spells = ""
                if q then spells = "Q" end
                if w then spells = spells .. "W" end
                if e then spells = spells .. "E" end
                self:DrawLineHPBar(dmg, spells, enemy, true)
            end
        end
    end
end

function Draw:GetHPBarPos(enemy)
    enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}
    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local BarPosOffsetX = -50
    local BarPosOffsetY = 46
    local CorrectionY = 39
    local StartHpPos = 31 
    barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
    barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)
    local StartPos = Vector(barPos.x , barPos.y, 0)
    local EndPos = Vector(barPos.x + 108 , barPos.y , 0)    
    return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function Draw:DrawLineHPBar(damage, text, unit, enemyteam)
    if unit.dead or not unit.visible then return end
    local p = WorldToScreen(D3DXVECTOR3(unit.x, unit.y, unit.z))
    if not OnScreen(p.x, p.y) then return end
    local thedmg = 0
    local line = 2
    local linePosA  = {x = 0, y = 0 }
    local linePosB  = {x = 0, y = 0 }
    local TextPos   = {x = 0, y = 0 }
    
    
    if damage >= unit.maxHealth then
        thedmg = unit.maxHealth - 1
    else
        thedmg = damage
    end
    
    thedmg = math.round(thedmg)
    
    local StartPos, EndPos = self:GetHPBarPos(unit)
    local Real_X = StartPos.x + 24
    local Offs_X = (Real_X + ((unit.health - thedmg) / unit.maxHealth) * (EndPos.x - StartPos.x - 2))
    if Offs_X < Real_X then Offs_X = Real_X end 
    local mytrans = 350 - math.round(255*((unit.health-thedmg)/unit.maxHealth))
    if mytrans >= 255 then mytrans=254 end
    local my_bluepart = math.round(400*((unit.health-thedmg)/unit.maxHealth))
    if my_bluepart >= 255 then my_bluepart=254 end

    
    if enemyteam then
        linePosA.x = Offs_X-150
        linePosA.y = (StartPos.y-(30+(line*15)))    
        linePosB.x = Offs_X-150
        linePosB.y = (StartPos.y-10)
        TextPos.x = Offs_X-148
        TextPos.y = (StartPos.y-(30+(line*15)))
    else
        linePosA.x = Offs_X-125
        linePosA.y = (StartPos.y-(30+(line*15)))    
        linePosB.x = Offs_X-125
        linePosB.y = (StartPos.y-15)
    
        TextPos.x = Offs_X-122
        TextPos.y = (StartPos.y-(30+(line*15)))
    end

    DrawLine(linePosA.x, linePosA.y, linePosB.x, linePosB.y , 2, ARGB(mytrans, 255, my_bluepart, 0))
    DrawText(tostring(thedmg).." "..tostring(text), 15, TextPos.x, TextPos.y , ARGB(mytrans, 255, my_bluepart, 0))
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

function GetOverkill()
    return ((Menu.Misc.Overkill/100)+100)
end

function KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth < 0.3 and ValidTarget(enemy, WSpell.Range) and enemy.visible then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health then
                if Menu.KillSteal.Q and ( q or QSpell:Damage(enemy) > enemy.health) then 
                    QSpell:Cast(enemy)
                end
                if Menu.KillSteal.E and ( e or ESpell:Damage(enemy) > enemy.health) then 
                    ESpell:Cast(enemy)
                end
                if Menu.KillSteal.E and ( w or WSpell:Damage(enemy) > enemy.health) then 
                    WSpell:Cast(enemy)
                end
            end
            if Menu.KillSteal.Ignite and Ignite:IsReady() and Ignite:Damage(enemy) >= enemy.health and not enemy.dead then Ignite:Cast(enemy) end
        end
    end
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
