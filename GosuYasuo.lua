if myHero.charName ~= "Yasuo" then return end
    
    require 'SimpleLib'

local Q, W, E, R, Ignite = nil, nil, nil, nil, nil
local TS, Menu = nil, nil
local PredictedDamage = {}
local RefreshTime = 0.4
local UsingPot = false
local lastRemove = 0
local TS = _SimpleTargetSelector(TARGET_LESS_CAST_PRIORITY, 1100, DAMAGE_PHYSICAL)

function OnLoad()

    ScriptName = "GosuMechanics"
    champName = "Yasuo"
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

    local ToUpdate = {}
    ToUpdate.Version = 1.24
    DelayAction(function()
        ToUpdate.UseHttps = true
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/GosuMechanics/BoL/master/GosuYasuo.version"
        ToUpdate.ScriptPath =  "/GosuMechanics/BoL/master/GosuYasuo.lua"
        ToUpdate.SavePath = SCRIPT_PATH.._ENV.FILE_NAME
        ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) Print("Updated to v("..NewVersion..").  .Please reload script. ") end
        ToUpdate.CallbackNoUpdate = function(OldVersion) Print("No Updates Found.") end
        ToUpdate.CallbackNewVersion = function(NewVersion) Print("New Version found ("..NewVersion.."). Please wait until its downloaded") end
        ToUpdate.CallbackError = function(NewVersion) Print("Error while Downloading. Please try again.") end
        SxScriptUpdate(ToUpdate.Version,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
    end, 0.5)
    Print("Version "..ToUpdate.Version.." loaded.")

end

class "SxScriptUpdate"
function SxScriptUpdate:__init(LocalVersion,UseHttps, Host, VersionPath, ScriptPath, SavePath, CallbackUpdate, CallbackNoUpdate, CallbackNewVersion,CallbackError)
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..math.random(99999999)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..math.random(99999999)
    self.SavePath = SavePath
    self.CallbackUpdate = CallbackUpdate
    self.CallbackNoUpdate = CallbackNoUpdate
    self.CallbackNewVersion = CallbackNewVersion
    self.CallbackError = CallbackError
    AddDrawCallback(function() self:OnDraw() end)
    self:CreateSocket(self.VersionPath)
    self.DownloadStatus = 'Connect to Server for VersionInfo'
    AddTickCallback(function() self:GetOnlineVersion() end)
end

function SxScriptUpdate:print(str)
    print('<font color="#FFFFFF">'..os.clock()..': '..str)
end

function SxScriptUpdate:OnDraw()
    if self.DownloadStatus ~= 'Downloading Script (100%)' and self.DownloadStatus ~= 'Downloading VersionInfo (100%)'then
        DrawText('Download Status: '..(self.DownloadStatus or 'Unknown'),50,10,50,ARGB(0xFF,0xFF,0xFF,0xFF))
    end
end

function SxScriptUpdate:CreateSocket(url)
    if not self.LuaSocket then
        self.LuaSocket = require("socket")
    else
        self.Socket:close()
        self.Socket = nil
        self.Size = nil
        self.RecvStarted = false
    end
    self.LuaSocket = require("socket")
    self.Socket = self.LuaSocket.tcp()
    self.Socket:settimeout(0, 'b')
    self.Socket:settimeout(99999999, 't')
    self.Socket:connect('sx-bol.eu', 80)
    self.Url = url
    self.Started = false
    self.LastPrint = ""
    self.File = ""
end

function SxScriptUpdate:Base64Encode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function SxScriptUpdate:GetOnlineVersion()
    if self.GotScriptVersion then return end

    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading VersionInfo (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</s'..'ize>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading VersionInfo ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading VersionInfo (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.File:find('<scr'..'ipt>')
        local ContentEnd, _ = self.File:find('</sc'..'ript>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            self.OnlineVersion = (Base64Decode(self.File:sub(ContentStart + 1,ContentEnd-1)))
            self.OnlineVersion = tonumber(self.OnlineVersion)
            if self.OnlineVersion > self.LocalVersion then
                if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
                    self.CallbackNewVersion(self.OnlineVersion,self.LocalVersion)
                end
                self:CreateSocket(self.ScriptPath)
                self.DownloadStatus = 'Connect to Server for ScriptDownload'
                AddTickCallback(function() self:DownloadUpdate() end)
            else
                if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
                    self.CallbackNoUpdate(self.LocalVersion)
                end
            end
        end
        self.GotScriptVersion = true
    end
end

function SxScriptUpdate:DownloadUpdate()
    if self.GotSxScriptUpdate then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading Script (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</si'..'ze>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading Script ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading Script (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.NewFile:find('<sc'..'ript>')
        local ContentEnd, _ = self.NewFile:find('</scr'..'ipt>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            local newf = self.NewFile:sub(ContentStart+1,ContentEnd-1)
            local newf = newf:gsub('\r','')
            if newf:len() ~= self.Size then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
                return
            end
            local newf = Base64Decode(newf)
            if type(load(newf)) ~= 'function' then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
            else
                local f = io.open(self.SavePath,"w+b")
                f:write(newf)
                f:close()
                if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                    self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
                end
            end
        end
        self.GotSxScriptUpdate = true
    end
end

function LoadVariables()
    --TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1100, DAMAGE_PHYSICAL)
    EnemyMinions = minionManager(MINION_ENEMY, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
    JungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
    Menu = scriptConfig(ScriptName.." "..champName, ScriptName.."29082015")
    QSpell = _Spell({Slot = _Q, DamageName = "Q", Range = 475, Width = 55, Delay = 0.25, Speed = math.huge, Aoe = true, IsForEnemies = true, Type = SPELL_TYPE.LINEAR}):AddDraw():SetAccuracy(50)
    Q3Spell = _Spell({Slot = _Q, DamageName = "Q3", Range = 900, Width = 90, Delay = 0.75, Speed = 1500, Aoe = true, IsForEnemies = true, Type = SPELL_TYPE.LINEAR}):AddDraw():SetAccuracy(50)
    WSpell = _Spell({Slot = _W, DamageName = "W", Range = 400, Delay = 0, IsForEnemies = false, Type = SPELL_TYPE.SELF}):AddDraw()
    ESpell = _Spell({Slot = _E, DamageName = "E", Range = 475, Delay = 0, Speed = 1600, IsForEnemies = true, Type = SPELL_TYPE.TARGETTED}):AddDraw()
    RSpell = _Spell({Slot = _R, DamageName = "R", Range = 2500, IsForEnemies = true, Type = SPELL_TYPE.SELF}):AddDraw()
    Ignite = _Spell({Slot = FindSummonerSlot("summonerdot"), DamageName = "IGNITE", Range = 600, Type = SPELL_TYPE.TARGETTED}):AddDraw()
     
    Q = { IsReady = function() return QSpell:IsReady() end}
    Q3 = { IsReady = function() return Q3Spell:IsReady() end}
    W = { IsReady = function() return WSpell:IsReady() end}
    E = { IsReady = function() return ESpell:IsReady() end}
    R = { IsReady = function() return RSpell:IsReady() end}

    QState = 1
    IsDashing = false
    DashedUnits = {}
    KnockedUnits = {}

end

function LoadMenu()

    Menu:addSubMenu("["..myHero.charName.."] - Combo Settings", "Combo")
        Menu.Combo:addParam("Q", "Use SteelTempest", SCRIPT_PARAM_ONOFF, true)
        Menu.Combo:addParam("E", "Use SweepingBlade", SCRIPT_PARAM_ONOFF, true)
        Menu.Combo:addParam("MinERange", "Min E Range", SCRIPT_PARAM_SLICE, 300, 150, 475, 0)
        Menu.Combo:addParam("Ignite", "Use Ignite", SCRIPT_PARAM_LIST, 1, {"Never", "If Killable" , "Always"})
        Menu.Combo:addParam("Items","Use Items", SCRIPT_PARAM_ONOFF, true)
    Menu.Combo:addSubMenu("["..myHero.charName.."] - Combo Ult Settings", "ults")
        Menu.Combo.ults:addParam("R1", "Use LastBreath when Killable", SCRIPT_PARAM_ONOFF, true)
        --Menu.Combo.ults:addParam("RL", "at x enemy hp ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
        Menu.Combo.ults:addParam("R2", "when x enemy in air ", SCRIPT_PARAM_SLICE, 2, 0, 5)

    Menu:addSubMenu("["..myHero.charName.."] - Harass Settings", "Harass")
        Menu.Harass:addParam("Q", "Use SteelTempest", SCRIPT_PARAM_ONOFF, true)
        
    Menu:addSubMenu("["..myHero.charName.."] - LaneClear Settings", "LaneClear")
        Menu.LaneClear:addParam("Q", "Use SteelTempest", SCRIPT_PARAM_ONOFF, true)
        Menu.LaneClear:addParam("E", "Use SweepingBlade", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("["..myHero.charName.."] - JungleClear Settings", "JungleClear")
        Menu.JungleClear:addParam("Q", "Use SteelTempest", SCRIPT_PARAM_ONOFF, true)
        Menu.JungleClear:addParam("E", "Use SweepingBlade", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("["..myHero.charName.."] - LastHit Settings", "LastHit")
        Menu.LastHit:addParam("Q", "Use SteelTempest", SCRIPT_PARAM_LIST, 3, {"Never", "Smart", "Always"})
        Menu.LastHit:addParam("E", "Use SweepingBlade", SCRIPT_PARAM_LIST, 2, {"Never", "Smart", "Always"})

    Menu:addSubMenu("["..myHero.charName.."] - Misc Settings", "Misc")
        Menu.Misc:addParam("Overkill", "Overkill % Checks", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
        Menu.Misc:addParam("useqss", "Use QSS", SCRIPT_PARAM_ONOFF, true)
        Menu.Misc:addParam("delay", "Activation delay", SCRIPT_PARAM_SLICE, 0, 0, 250, 0)
        Menu.Misc:addParam("autoPots", "Use HP Pots", SCRIPT_PARAM_ONOFF, true)
        Menu.Misc:addParam("usePots", "Use when x HP", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
        Menu.Misc:addParam("ultR", "Auto R Toggle", SCRIPT_PARAM_ONOFF, true)
        Menu.Misc:addParam("R", "when x enemy in air ", SCRIPT_PARAM_SLICE, 3, 0, 5)
    Menu.Misc:addSubMenu("Use WindWall", "W")
            _Evader(Menu.Misc.W):CheckCC():AddCallback(
                function(target) 
                    if WSpell:IsReady() then
                        local FixedPos = Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized() * WSpell.Range
                        CastSpell(WSpell.Slot, FixedPos.x, FixedPos.z)
                        print("Block Test")
                    end
                end
            )
    Menu.Misc:addSubMenu("Interrupt w/ EmpoweredTempest", "Q3")
            _Interrupter(Menu.Misc.Q3):CheckChannelingSpells():CheckGapcloserSpells():AddCallback(
                function(target, spell)
                    if Q3Spell:IsReady() and QState == 3 then
                        Q3Spell:Cast(target)
                        print("Interrupt Test")
                    end
                end
            )
    Menu.Misc:addSubMenu("Use E-vade", "E")
        _Evader(Menu.Misc.E):CheckCC():AddCallback(
            function(target)
                if ESpell:IsReady() and IsValidTarget(target) then
                    local object = SearchEObject(mousePos)
                    if IsValidTarget(object) then
                        if object.networkID ~= target.networkID then
                            CastE(object)
                            print("E-vade Test")
                        end
                    end
                end
            end
        )

    Menu:addSubMenu("["..myHero.charName.."] - KillSteal Settings", "KillSteal")
        Menu.KillSteal:addParam("Q", "Use SteelTempest", SCRIPT_PARAM_ONOFF, true)
        Menu.KillSteal:addParam("E", "Use SweepingBlade", SCRIPT_PARAM_ONOFF, true)
        Menu.KillSteal:addParam("R", "Use LastBreath", SCRIPT_PARAM_ONOFF, false)
        Menu.KillSteal:addParam("Ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("["..myHero.charName.."] - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(Menu.Keys)
        Menu.Keys:addParam("StackQM", "Auto-Q EnemyMinions", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("L"))
        Menu.Keys.StackQM = false
        Menu.Keys:permaShow("StackQM")
        Menu.Keys:addParam("StackQJ", "Auto-Q JungleMinions", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("K"))
        Menu.Keys.StackQJ = false
        Menu.Keys:permaShow("StackQJ")
        Menu.Keys:addParam("StackQE", "Harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("J"))
        Menu.Keys.StackQE = false
        Menu.Keys:permaShow("StackQE")
        Menu.Keys:addParam("esc", "Escape", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
        Menu.Keys.esc = false
        Menu.Keys:addParam("egap", "E Gapcloser", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("E"))
        Menu.Keys.egap = false

        TS:AddToMenu(Menu)

end

function OnTick()
    if Menu == nil then return end
    TS:update()
    target = TS.target
    if Menu.Misc.ultR then AutoR() end
    if Menu.Misc.autoPots then AutoPots() end
    if Menu.Keys.esc then Escape() end
    if Menu.Keys.egap then EgapCloser() end
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
    if Menu.Keys.StackQE then Harass() end
    if Menu.Keys.StackQJ then AutoQminion() end
    if Menu.Keys.StackQM then AutoQEnemyMinion() end
    if IsDashing then
        QSpell.Type = SPELL_TYPE.SELF
        QSpell.Range = 270
        QSpell.Width = 270
        QSpell.Delay = 0--0.147
        QSpell.Speed = math.huge
    elseif QState == 3 then
        QSpell.Type = SPELL_TYPE.LINEAR
        QSpell.Range = 1100
        QSpell.Width = 90
        QSpell.Delay = 0.25
        QSpell.Speed = 1200
    else
        QSpell.Type = SPELL_TYPE.LINEAR
        QSpell.Range = 475
        QSpell.Width = 20
        QSpell.Delay = 0.35
        QSpell.Speed = 8700
    end
end

function Combo()
    if OrbwalkManager.GotReset then return end
        local target = TS.target
        if IsValidTarget(target) then
            local q, w, e, r, dmg = GetBestCombo(target)

            if Menu.Combo.Items then UseItems(target) end
                if Menu.Combo.Ignite > 1 and Ignite:IsReady() then 
                    if Menu.Combo.Ignite == 2 then
                        if dmg / GetOverkill() > target.health then Ignite:Cast(target) end
                    else
                        Ignite:Cast(target)
                    end
                end
                if Menu.Combo.ults.R2 > 0 and #EnemiesKnocked() >= Menu.Combo.ults.R2 then
                    RSpell:Cast(TS.target)
                    myHero:Attack(target)
                end
                if Menu.Combo.ults.R1 and dmg >= target.health then
                    CastR(target)
                    myHero:Attack(target)
                end
                if Menu.Combo.Q then
                    QSpell:Cast(target)
                    myHero:Attack(target)
                end
                if Menu.Combo.Q and QState == 3 then
                    Q3Spell:Cast(target)
                    myHero:Attack(target)
                end
                if Menu.Combo.E and GetDistanceSqr(myHero, target) > math.pow(myHero.range + myHero.boundingRadius + 50, 2) then
                    local object = SearchEObject(target)
                    if IsValidTarget(object) then
                        if object.networkID ~= target.networkID then
                            CastE(object)
                        elseif GetDistanceSqr(myHero, target) > math.pow(Menu.Combo.MinERange, 2) then
                            CastE(object)
                        end
                    end
            end
    end
end

function Clear()

    if Menu.LaneClear.E then
        EnemyMinions:update()
        for i, minion in pairs(EnemyMinions.objects) do
            if ESpell:IsReady() and ESpell:Damage(minion) >= minion.health then
                CastE(minion)
            end
            if Menu.LaneClear.Q then
                QSpell:LaneClear()
            end
        end
    end
    if Menu.JungleClear.E then
        JungleMinions:update()
        for i, minion in pairs(JungleMinions.objects) do
            if ESpell:IsReady() then
                CastE(minion)
            end
            if Menu.JungleClear.Q then
                QSpell:JungleClear()
            end
        end
    end
end

function LastHit()
    QSpell:LastHit({Mode = Menu.LastHit.Q})
    ESpell:LastHit({Mode = Menu.LastHit.E})
end

function Harass()
    local target = TS.target
    if IsValidTarget(target) then
        if Menu.Harass.Q then
            QSpell:Cast(target)
        end
        if Menu.Harass.Q and QState == 3 then
            Q3Spell:Cast(target)
        end
    end
end

function CastR(target)
    if RSpell:IsReady() and IsValidTarget(target) and KnockedUnits[target.networkID] ~= nil then
        RSpell:Cast(target)
    end
end

function AutoR()
    if Menu.Misc.R > 0 and #EnemiesKnocked() >= Menu.Misc.R then
        RSpell:Cast(TS.target)
    end
end

function Escape()
    local object = SearchEObject(mousePos)
    if IsValidTarget(object) then
        ESpell:Cast(object)
    else
        myHero:MoveTo(mousePos.x, mousePos.z)
    end
end

function EgapCloser()
    local object = SearchEObject(TS.target)
    if IsValidTarget(object) then
        ESpell:Cast(object)
    elseif not QSpell:IsReady() then
        local object = SearchEObject(mousePos)
        if IsValidTarget(object) then
            ESpell:Cast(object)
        end
    else
        myHero:MoveTo(mousePos.x, mousePos.z)
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

function EnemiesKnocked()
    local Knockeds = {}
    for i, enemy in ipairs(GetEnemyHeroes()) do
        if IsValidTarget(enemy) and KnockedUnits[enemy.networkID] ~= nil then table.insert(Knockeds, enemy) end
    end
    return Knockeds
end

function KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth < 0.3 and ValidTarget(enemy, TS.range) and enemy.visible then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health then
                if Menu.KillSteal.Q and ( q or QSpell:Damage(enemy) > enemy.health) then 
                    QSpell:Cast(enemy)
                    local object = SearchEObject(enemy)
                    if IsValidTarget(object) and GetDistanceSqr(enemy, EEndPos(object)) < GetDistanceSqr(enemy, myHero) then
                        CastE(object)
                    end
                end
                if Menu.KillSteal.E and ( e or ESpell:Damage(enemy) > enemy.health) then 
                    CastE(enemy)
                    local object = SearchEObject(enemy)
                    if IsValidTarget(object) and GetDistanceSqr(enemy, EEndPos(object)) < GetDistanceSqr(enemy, myHero) then
                        CastE(object)
                    end
                end
                if Menu.KillSteal.R and ( r or RSpell:Damage(enemy) > enemy.health) then 
                    CastR(enemy)
                end
            end
            if Menu.KillSteal.Ignite and Ignite:IsReady() and Ignite:Damage(enemy) >= enemy.health and not enemy.dead then Ignite:Cast(enemy) end
        end
    end
end

function CastE(target)
    if ESpell:IsReady() and IsValidTarget(target) and not HaveEBuff(target) then
        if (not UnderTurret(EEndPos(minion),true)) then
            ESpell:Cast(target)
        end
    end
end

function AutoQminion(unit, minion)
    JungleMinions:update()
    for index, minion in pairs(JungleMinions.objects) do
        if QState < 3 then
            QSpell:Cast(minion)
        end
    end
end

function AutoQEnemyMinion(unit, minion)
    EnemyMinions:update()
    for index, minion in pairs(EnemyMinions.objects) do
        if QState < 3 then
            QSpell:Cast(minion)
        end
    end
end

function SearchEObject(vector)
    if vector ~= nil and ESpell:IsReady() then
        local best = nil
        EnemyMinions:update()
        for i, object in ipairs(EnemyMinions.objects) do
            if ESpell:ValidTarget(object) and not HaveEBuff(object) and GetDistanceSqr(vector, EEndPos(object)) < GetDistanceSqr(vector, myHero) then
                if best == nil then best = object
                elseif GetDistanceSqr(vector, EEndPos(best)) > GetDistanceSqr(vector, EEndPos(object)) then best = object end
            end
        end
        if IsValidTarget(best) then
            return best
        end
        JungleMinions:update()
        for i, object in ipairs(JungleMinions.objects) do
            if ESpell:ValidTarget(object) and not HaveEBuff(object) and GetDistanceSqr(vector, EEndPos(object)) < GetDistanceSqr(vector, myHero) then
                if best == nil then best = object
                elseif GetDistanceSqr(vector, EEndPos(best)) > GetDistanceSqr(vector, EEndPos(object)) then best = object end
            end
        end
        if IsValidTarget(best) then
            return best
        end
        for i, object in ipairs(GetEnemyHeroes()) do
            if ESpell:ValidTarget(object) and not HaveEBuff(object) and GetDistanceSqr(vector, EEndPos(object)) < GetDistanceSqr(vector, myHero) then
                if best == nil then best = object
                elseif GetDistanceSqr(vector, EEndPos(best)) > GetDistanceSqr(vector, EEndPos(object)) then best = object end
            end
        end
        if IsValidTarget(best) then
            return best
        end
    end
    return nil
end

function EEndPos(target)
    return Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized() * ESpell.Range
end

function HaveEBuff(target)
    return DashedUnits[target.networkID] ~= nil
end

function OnCreateObj(obj)
    if obj and obj.name and obj.valid then
         if obj.name:lower():find("yasuo_base_e_dash_hit") and IsDashing then
            IsDashing = true
        end
        if obj.name:lower():find("q_wind_ready_buff") and GetDistanceSqr(myHero, obj) < 80 * 80 then
            QState = 3
        end
    end
end

function OnDeleteObj(obj)
    if obj and obj.name and obj.valid then
         if obj.name:lower():find("yasuo_base_e_dash_hit") and IsDashing then
            IsDashing = false
        end
        if obj.name:lower():find("q_wind_ready_buff") and GetDistanceSqr(myHero, obj) < 80 * 80 then
            QState = 1
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
    if unit and source and buff and buff.name and unit.team and buff.type then
        if buff.type == 29 and unit.team ~= myHero.team then
            KnockedUnits[unit.networkID] = true
        end
    end
    if unit.isMe and Menu.Misc.useqss then
        if buff.name and buff.type == 5 or buff.type == 12 or buff.type == 11 or buff.type == 25 or buff.type == 7 or buff.type == 22 or buff.type == 21 or buff.type == 8
        or buff.name == "MordekaiserChildrenOfTheGrave" or buff.name ==  "SkarnerImpale" or buff.name == "LuxLightBindingMis" or buff.name == "Wither" or buff.name == "SonaCrescendo" 
        or buff.name == "DarkBindingMissile" or buff.name == "CurseoftheSadMummy" or buff.name == "EnchantedCrystalArrow" or buff.name == "BlindingDart" or buff.name == "LuluWTwo" 
        or buff.name == "AhriSeduce" or buff.name == "CassiopeiaPetrifyingGaze" or buff.name == "Terrify" or buff.name == "HowlingGale" or buff.name == "JaxCounterStrike" or buff.name == "KennenShurikenStorm" 
        or buff.name == "LeblancSoulShackle" or buff.name == "LeonaSolarFlare" or buff.name == "LissandraR" or buff.name == "AlZaharNetherGrasp" or buff.name == "MonkeyKingDecoy" 
        or buff.name == "NamiQ" or buff.name == "OrianaDetonateCommand" or buff.name == "Pantheon_LeapBash" or buff.name == "PuncturingTaunt" or buff.name == "SejuaniGlacialPrisonStart"
        or buff.name == "SwainShadowGrasp" or buff.name == "Imbue" or buff.name == "ThreshQ" or buff.name == "UrgotSwap2" or buff.name == "VarusR" or buff.name == "VeigarEventHorizon" 
        or buff.name == "ViR" or buff.name == "InfiniteDuress" or buff.name == "ZyraGraspingRoots" or(buff.type == 10 and buff.name and buff.name:lower():find("fleeslow"))or (buff.name:lower():find("summonerexhaust")) then
            UseQSS(myHero, true)         
        end                    
    end 
end

function OnRemoveBuff(unit, buff)
    if not unit or not buff or unit.type ~= myHero.type then return end
        if unit and unit.isMe and buff.name == "RegenerationPotion" then
            UsingPot = false
        end
    if unit and unit.isMe and buff.name == "recall" then
        isRecalling = false
    end
    if unit and source and buff and buff.name and unit.team and buff.type then
        if buff.type == 29 and unit.team ~= myHero.team then
            KnockedUnits[unit.networkID] = false
        end
    end
end

function AutoPots()
    if GetInventoryItemIsCastable(2003) and lowHp(myHero) and not UsingPot and not IsRecalling then 
        CastItem(2003)
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

function UseQSS(unit, scary)
    if lastRemove > os.clock() - 1 then return end
    for i, Item in pairs(Items) do
        local Item = Items[i]
        if GetInventoryItemIsCastable(Item.id) and GetDistanceSqr(unit) <= Item.range * Item.range then
            if Item.id == 3139 or Item.id ==  3140 then
                if scary then
                    DelayAction(function()
                        CastItem(Item.id)
                    end, Menu.Misc.delay/1000)    
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

