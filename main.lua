--[[ Warfare Tycoon — INSUI
     UI library: INSUI by neaxusxgod-png
     UI credit: (INS UI) / inspecttor
     Menu: zerkly_
     Stats engine: Matcha getgc / applygc
]]

-- ============================================================
-- 0. Global Settings & Services
-- ============================================================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local HYBRID_MODE = true
if _G.hybrid ~= nil then HYBRID_MODE = _G.hybrid end

-- Matcha detection (needed to pick the right notify path)
local HAS_MATCHA_NOTIFY = false
do
    if type(notify) == "function" and type(identifyexecutor) == "function" then
        local ok, name = pcall(identifyexecutor)
        if ok and tostring(name) == "Matcha" then
            HAS_MATCHA_NOTIFY = true
        end
    end
end

local ARSENAL_URL = "https://raw.githubusercontent.com/ZEOAEL/1230aneosd/refs/heads/main/arsenal.lua"
local Arsenal = nil
do
    local ok, err = pcall(function()
        local bust = "?v=" .. tostring(math.floor(os.time()))
        local headers = { ["Cache-Control"] = "no-cache, no-store, must-revalidate", ["Pragma"] = "no-cache" }
        local src
        if type(httpget) == "function" then src = httpget(ARSENAL_URL .. bust, headers) end
        if type(src) ~= "string" or #src < 100 then src = game:HttpGet(ARSENAL_URL .. bust) end
        if type(src) ~= "string" or #src < 100 then error("HttpGet returned " .. tostring(src and #src or "nil") .. " bytes") end
        _G.Arsenal = nil
        local chunk = loadstring(src)
        if not chunk then error("loadstring returned nil — syntax error in arsenal.lua") end
        chunk()
        Arsenal = _G.Arsenal
        if type(Arsenal) ~= "table" then error("arsenal.lua did not set _G.Arsenal (got " .. type(Arsenal) .. ")") end
    end)
    if ok then
        print("[Arsenal] Loaded " .. #Arsenal.listAll() .. " weapons (v" .. tostring(Arsenal.Version) .. ")")
    else
        warn("[Arsenal] Load failed: " .. tostring(err))
    end
end

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/neaxusxgod-png/INS-ui/main/uilib.min.lua"))() or INSUI

-- Native-notify wrapper.
-- Prefers Matcha's native toast (fast, no frames) with debounce per title.
local lastNotifyAt = {}
local NOTIFY_DEBOUNCE = 0.3

local function popup(title, text, duration, kind)
    title = tostring(title or "Warfare Tycoon")
    text = tostring(text or "")
    duration = duration or 5

    local now = tick()
    if lastNotifyAt[title] and now - lastNotifyAt[title] < NOTIFY_DEBOUNCE then return end
    lastNotifyAt[title] = now

    if HAS_MATCHA_NOTIFY then
        pcall(notify, text, title, duration)
        return
    end
    pcall(function()
        if Lib and type(Lib.Notify) == "function" then
            Lib:Notify(title, text, duration, kind or "info")
        end
    end)
end

-- ============================================================
-- 1. Config
-- ============================================================
local acs = {
	fireRateOn = false, spreadOn = false, maxSpread = 0,
	ammoOn = false, overheatOn = false, bulletOn = false,
	bullets = 10, punchOn = false, fallDamageOn = false,
}

local killCfg = {
    shotDelay = 0.08, aimDelay = 0.15, maxShots = 15,
    rangeOffset = 100, autoRange = true, manualRange = 1000,
}

local whitelist = {}
local sortOptions = { "No Sort", "Distance", "Name (A-Z)", "Name (Z-A)" }
local sortIndex = { players = 2, bases = 2 }

-- Empty string "" = UNBOUND. Only apply/killSelf have defaults; every teleport
-- starts unbound so users opt in per-action via the "X key" widget.
local boundKeys = {
    applyNew = "f2", applyAll = "f3", refresh = "f4",
    killSelf = "k",
    tpBase = "", tpCapture = "", tpOil1 = "", tpOil2 = "", tpOil3 = "",
}

-- Complete list of possible action names — used to pre-seed prevKeyDown so
-- unbound-then-bound keys don't fire on the first poll after binding.
local ALL_ACTION_NAMES = {
    "applyNew", "applyAll", "refresh", "killSelf",
    "tpBase", "tpCapture", "tpOil1", "tpOil2", "tpOil3",
}

local VK = {
    a=0x41, b=0x42, c=0x43, d=0x44, e=0x45, f=0x46, g=0x47, h=0x48, i=0x49,
    j=0x4A, k=0x4B, l=0x4C, m=0x4D, n=0x4E, o=0x4F, p=0x50, q=0x51, r=0x52,
    s=0x53, t=0x54, u=0x55, v=0x56, w=0x57, x=0x58, y=0x59, z=0x5A,
    ["0"]=0x30, ["1"]=0x31, ["2"]=0x32, ["3"]=0x33, ["4"]=0x34,
    ["5"]=0x35, ["6"]=0x36, ["7"]=0x37, ["8"]=0x38, ["9"]=0x39,
    f1=0x70, f2=0x71, f3=0x72, f4=0x73, f5=0x74, f6=0x75,
    f7=0x76, f8=0x77, f9=0x78, f10=0x79, f11=0x7A, f12=0x7B,
    space=0x20, enter=0x0D, tab=0x09, escape=0x1B, backspace=0x08,
    shift=0x10, ctrl=0x11, alt=0x12,
    leftshift=0xA0, rightshift=0xA1,
    leftctrl=0xA2, rightctrl=0xA3,
    leftalt=0xA4, rightalt=0xA5,
}

local vkMemo = {}
local function keyNameToVK(raw)
    if not raw then return nil end
    local s = string.lower(tostring(raw))
    if s == "" or s == "none" or s == "nil" then return nil end
    if vkMemo[s] ~= nil then return vkMemo[s] or nil end
    local cleaned = s:gsub("%s+", ""):gsub("keycode", ""):gsub("^enum", "")
    local digitMap = { one="1", two="2", three="3", four="4", five="5",
                       six="6", seven="7", eight="8", nine="9", zero="0" }
    cleaned = digitMap[cleaned] or cleaned
    local code = VK[cleaned]
    vkMemo[s] = code or false
    return code
end

local keyActions = {}
local prevKeyDown = {}

local lastAppliedState = {
    fireRateOn = false, spreadOn = false, ammoOn = false,
    overheatOn = false, bulletOn = false, punchOn = false,
    fallDamageOn = false
}

local excludedValues = {
    ["ProgressBar"]=true, ["UIGradient"]=true, ["RightGradient"]=true, ["RingScale"]=true,
    ["IconButton"]=true, ["OverlayProvider"]=true, ["TopControls"]=true, ["Popover"]=true,
    ["useVariants"]=true, ["Corner"]=true, ["View"]=true, ["Button"]=true, ["Label"]=true,
    ["Text"]=true, ["Icon"]=true, ["Caption"]=true, ["FailedStroke"]=true, ["NumberValue"]=true,
    ["transparencyValue"]=true, ["AudioType"]=true, ["assetId"]=true, ["GetProductInfo"]=true,
    ["HoldDuration"]=true, ["total_duration"]=true, ["offset_duration"]=true,
}

local function relevant(entry)
    local value = tostring(entry.value)
    local reportedType = tostring(entry.type):lower()
    if excludedValues[value] then return false end
    if reportedType ~= "number" then return false end
    return true
end

-- ============================================================
-- 2. Caches
-- ============================================================
local fallDamageCache = nil
local overheatCache = nil

local function refreshCaches()
    local fdRaw = getgc({ "MaxVelocity", "DamageMult", "FDMG" })
    fallDamageCache = {}
    for _, e in ipairs(fdRaw) do if relevant(e) then fallDamageCache[#fallDamageCache+1] = e end end
    local ohRaw = getgc("OverheatCount")
    overheatCache = {}
    for _, e in ipairs(ohRaw) do if relevant(e) then overheatCache[#overheatCache+1] = e end end
    print("[GC] Caches refreshed.")
end

-- ============================================================
-- 3. Apply Logic
-- ============================================================
local function applyStats(applyAll)
    local t = {}
    if (applyAll or acs.fireRateOn ~= lastAppliedState.fireRateOn) and acs.fireRateOn then
        t.FireRate = 0; t.BurstFireRate = 0
    end
    if (applyAll or acs.spreadOn ~= lastAppliedState.spreadOn) and acs.spreadOn then
        t.BulletSpread = 0; t.MaxSpread = acs.maxSpread; t.MinSpread = 0
    end
    if (applyAll or acs.ammoOn ~= lastAppliedState.ammoOn) and acs.ammoOn then t.Ammo = 1e6 end
    if (applyAll or acs.bulletOn ~= lastAppliedState.bulletOn) and acs.bulletOn then t.Bullets = acs.bullets end
    if (applyAll or acs.punchOn ~= lastAppliedState.punchOn) and acs.punchOn then
        t.MaxRecoilPower = 0; t.VPunchBase = 0; t.HPunchBase = 0
        t.DPunchBase = 0; t.RecoilPunch = 0; t.RecoilPowerStepAmount = 0
        t.SwayBase = 0; t.WalkMultiplier = 0
    end
    if next(t) ~= nil then
        local names = {}
        for k in pairs(t) do names[#names+1] = k end
        local raw = getgc(names)
        local filtered = {}
        for _, e in ipairs(raw) do if relevant(e) then filtered[#filtered+1] = e end end
        applygc(filtered, t)
    end
    if (applyAll or acs.overheatOn ~= lastAppliedState.overheatOn) and acs.overheatOn then
        if not overheatCache then refreshCaches() end
        applygc(overheatCache, { OverheatCount = 1e6 })
    end
    if (applyAll or acs.fallDamageOn ~= lastAppliedState.fallDamageOn) and acs.fallDamageOn then
        if not fallDamageCache then refreshCaches() end
        applygc(fallDamageCache, { MaxVelocity = 999999, DamageMult = 0, FDMG = 0 })
    end
    lastAppliedState.fireRateOn = acs.fireRateOn
    lastAppliedState.spreadOn = acs.spreadOn
    lastAppliedState.ammoOn = acs.ammoOn
    lastAppliedState.overheatOn = acs.overheatOn
    lastAppliedState.bulletOn = acs.bulletOn
    lastAppliedState.punchOn = acs.punchOn
    lastAppliedState.fallDamageOn = acs.fallDamageOn
end

-- ============================================================
-- 4. Owner Lookup
-- ============================================================
local ownerCache = {}
local ownerFetching = {}

local function httpGetSafe(url)
	local ok, res = pcall(function() return game:HttpGet(url) end)
	if ok and type(res) == "string" and #res > 0 then return res end
	if type(httpget) == "function" then
		local ok2, res2 = pcall(httpget, url)
		if ok2 and type(res2) == "string" and #res2 > 0 then return res2 end
	end
	return nil
end

local function httpPostSafe(url, body, contentType)
	local ok, res = pcall(function() return game:HttpPost(url, body, contentType) end)
	if ok and type(res) == "string" and #res > 0 then return res end
	if type(httppost) == "function" then
		local ok2, res2 = pcall(httppost, url, body, contentType)
		if ok2 and type(res2) == "string" and #res2 > 0 then return res2 end
	end
	return nil
end

local function getOwnerInfo(ownerName)
	if ownerName == nil or tostring(ownerName) == "" then
		return { username = nil, displayName = "Unclaimed", userId = nil, avatarUrl = nil }
	end
	ownerName = tostring(ownerName)
	if ownerCache[ownerName] then return ownerCache[ownerName] end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Name == ownerName then
			local info = { username = plr.Name, displayName = tostring(plr.DisplayName or plr.Name), userId = plr.UserId, avatarUrl = nil }
			ownerCache[ownerName] = info
			return info
		end
	end
	if not ownerFetching[ownerName] then
		ownerFetching[ownerName] = true
		task.spawn(function()
			local info = nil
			local body = HttpService:JSONEncode({ usernames = { ownerName }, excludeBannedUsers = true })
			local response = httpPostSafe("https://users.roblox.com/v1/usernames/users", body, "application/json")
			if response then
				local decodedOk, data = pcall(function() return HttpService:JSONDecode(response) end)
				if decodedOk and data and data.data and data.data[1] then
					local u = data.data[1]
					info = { username = u.name or ownerName, displayName = u.displayName or ownerName, userId = u.id, avatarUrl = nil }
				end
			end
			if info and info.userId then
				local url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(info.userId) .. "&size=150x150&format=Png&isCircular=false"
				local r2 = httpGetSafe(url)
				if r2 then
					local ok2, d2 = pcall(function() return HttpService:JSONDecode(r2) end)
					if ok2 and d2 and d2.data and d2.data[1] then info.avatarUrl = d2.data[1].imageUrl end
				end
			end
			if not info then info = { username = ownerName, displayName = ownerName, userId = nil, avatarUrl = nil } end
			ownerCache[ownerName] = info
			ownerFetching[ownerName] = nil
			print("[Owner] Resolved '" .. ownerName .. "' -> " .. tostring(info.displayName))
		end)
	end
	return { username = ownerName, displayName = ownerName, userId = nil, avatarUrl = nil }
end

-- ============================================================
-- 5. Window + Tabs
-- ============================================================
local win = Lib:CreateWindow({
    title          = "Warfare Tycoon",
    subtitle       = "by zerkly_ | UI: inspecttor",
    size           = Vector2.new(700, 520),
    menuKey        = "p",
    smartFps       = true,
    checkboxStyle  = true,
    opacity        = 98,
    keybindOverlay = true,
    configName     = "warfaretycoon",
    configFolder   = "WarfareTycoon",
    startOpen      = true,
})

win:AddSettingsTab("gear")

local combatTab    = win:Tab("Combat", "sword")
local playersTab   = win:Tab("Players", "two-people")
local basesTab     = win:Tab("Bases", "house")
local teleportsTab = win:Tab("Teleports", "location-pin-map")
local notesTab     = win:Tab("Notes", "book-closed")

-- ============================================================
-- 6. Combat Tab
-- ============================================================
local fire = combatTab:Section("Fire Rate", "Left")
local fireToggle = fire:Toggle("Zero fire rate", false, function(on) acs.fireRateOn = on end)
fireToggle:Tooltip("Sets FireRate and BurstFireRate to 0.")

local spread = combatTab:Section("Spread", "Left")
spread:Toggle("Enable spread overrides", false, function(on) acs.spreadOn = on end)
spread:Slider("MaxSpread value", 0, 1, -100, 100, "", function(v) acs.maxSpread = v end)

local overheat = combatTab:Section("Heat & Ammo", "Left")
overheat:Toggle("Infinite ammo (visual)", false, function(on) acs.ammoOn = on end)
overheat:Toggle("No Overheat", false, function(on) acs.overheatOn = on end)

local applySection = combatTab:Section("Apply", "Left", "action + rebindable hotkey")

local function doApplyNew()
    task.spawn(function()
        popup("Warfare Tycoon", "Applying newly toggled items...", 3, "info")
        applyStats(false)
        popup("Warfare Tycoon", "New items applied.", 3, "success")
    end)
end

local function doApplyAll()
    task.spawn(function()
        popup("Warfare Tycoon", "Re-applying all active items...", 3, "info")
        applyStats(true)
        popup("Warfare Tycoon", "All items applied.", 3, "success")
    end)
end

local function doRefresh()
    task.spawn(function()
        popup("Warfare Tycoon", "Refreshing caches...", 2, "info")
        refreshCaches()
        popup("Warfare Tycoon", "Caches refreshed!", 2, "success")
    end)
end

local keybindToggles = {}
local lastActionTime = {}

local function guardedAction(name, fn)
    local now = tick()
    if lastActionTime[name] and now - lastActionTime[name] < 0.2 then return end
    lastActionTime[name] = now
    pcall(fn)
end

-- Keep default-bound helper for Apply/KillSelf.
local function registerHotkey(parent, actionName, label, defaultKey, actionFn)
    local toggle = parent:Toggle(label .. " hotkey", true, function() end)
    local regTime = tick()
    toggle:AddKeybind(defaultKey, "Hold", function(on)
        if tick() - regTime < 1.0 then return end
        if on then guardedAction(actionName, actionFn) end
    end)
    keybindToggles[actionName] = toggle

    parent:Keybind(label .. " key", defaultKey, function(key)
        local kk = string.lower(tostring(key or ""))
        local newKey = (kk ~= "" and kk ~= "none" and kk ~= "nil") and kk or ""
        boundKeys[actionName] = newKey
        if newKey ~= "" then vkMemo[newKey] = nil end
        prevKeyDown[actionName] = true
    end)
end

applySection:Button("Apply New Only", doApplyNew)
registerHotkey(applySection, "applyNew", "Apply New", "f2", doApplyNew)

applySection:Button("Apply All", doApplyAll)
registerHotkey(applySection, "applyAll", "Apply All", "f3", doApplyAll)

applySection:Button("Refresh Caches", doRefresh)
registerHotkey(applySection, "refresh", "Refresh", "f4", doRefresh)

local bullet = combatTab:Section("Bullet Behavior", "Right")
bullet:Toggle("Enable bullet overrides", false, function(on) acs.bulletOn = on end)
bullet:Slider("Bullets per shot", 10, 1, 1, 15, "", function(v) acs.bullets = v end)

local punch = combatTab:Section("Recoil", "Right")
punch:Toggle("Zero punch / sway", false, function(on) acs.punchOn = on end)

local fallDamageSection = combatTab:Section("Fall Damage", "Right")
local fallToggle = fallDamageSection:Toggle("No Fall Damage", false, function(on) acs.fallDamageOn = on end)
fallToggle:Tooltip("Requires clicking Apply All or Apply New to take effect.")

local killSetup = combatTab:Section("Kill Setup", "Right")
local autoRangeToggle = killSetup:Toggle("Auto Range", true, function(on) killCfg.autoRange = on end)
autoRangeToggle:Tooltip("Range derived from the equipped weapon's Distance minus offset.")
killSetup:Slider("Range Offset", 100, 25, 0, 1000, " studs", function(v) killCfg.rangeOffset = v end)
killSetup:Slider("Manual Range", 1000, 100, 50, 8000, " studs", function(v) killCfg.manualRange = v end)
killSetup:Slider("Shot Delay", 0.08, 0.01, 0.02, 0.5, " s", function(v) killCfg.shotDelay = v end)
killSetup:Slider("Aim Delay", 0.15, 0.01, 0.05, 1.0, " s", function(v) killCfg.aimDelay = v end)
killSetup:Slider("Max Shots", 15, 1, 1, 50, "", function(v) killCfg.maxShots = math.floor(v) end)

-- ============================================================
-- 7. Kill Player Logic
-- ============================================================
local function getEquippedGunName()
    local myChar = workspace:FindFirstChild(localPlayer.Name)
    if not myChar then return nil end
    local skip = { ForceFieldCustom = true, Shirt = true, Pants = true, ["Drone EMP"] = true }
    for _, child in ipairs(myChar:GetChildren()) do
        if child:IsA("Tool") and not skip[child.Name] then
            local serverClone = myChar:FindFirstChild("S" .. child.Name)
            if serverClone and serverClone:IsA("Model") then return child.Name end
        end
    end
    return nil
end

local function findGunData(name)
    if type(name) ~= "string" or name == "" then return nil, nil, nil end
    if Arsenal.find then
        local data, cat = Arsenal.find(name)
        if data then return data, cat, name end
    end
    if name:sub(1, 1) == "S" and #name > 1 then
        local stripped = name:sub(2)
        if Arsenal.find then
            local data, cat = Arsenal.find(stripped)
            if data then return data, cat, stripped end
        end
    end
    local function normalize(s) return string.lower(string.gsub(s, "[%s%-_]", "")) end
    local normName = normalize(name)
    for _, cat in ipairs(Arsenal.Categories) do
        for key, data in pairs(Arsenal[cat]) do
            if normalize(key) == normName then return data, cat, key end
        end
    end
    return nil, nil, nil
end

local function killPlayer(targetUsername)
    if not HYBRID_MODE then popup("Warfare Tycoon", "Enable Hybrid Mode for better features!", 4, "warning") return end
    if whitelist[targetUsername] then popup("Warfare Tycoon", targetUsername .. " is whitelisted.", 3, "warning") return end
    if not Arsenal then popup("Warfare Tycoon", "Arsenal data failed to load.", 4, "error") return end

    local gunName = getEquippedGunName()
    if not gunName then popup("Warfare Tycoon", "Equip a gun first!", 4, "warning") return end

    local gunData, gunCategory, matchedKey = findGunData(gunName)
    if not gunData then
        popup("Warfare Tycoon", "No Arsenal data for '" .. gunName .. "'", 4, "error")
        print("[Arsenal] Unknown gun from Character: '" .. gunName .. "'")
        return
    end
    local realName = matchedKey or gunName
    if realName ~= gunName then print("[Arsenal] Resolved '" .. gunName .. "' -> '" .. realName .. "'") end

    local REQUIRED_FIELDS = { "Distance", "BSpeed", "FireRate", "Mode", "MaxSpread", "MaxRecoilPower" }
    local missing = {}
    for _, key in ipairs(REQUIRED_FIELDS) do
        if gunData[key] == nil then missing[#missing + 1] = key end
    end
    if #missing > 0 then
        popup("Warfare Tycoon", realName .. " missing: " .. table.concat(missing, ", "), 5, "error")
        return
    end

    local killRange
    if killCfg.autoRange then killRange = gunData.Distance - killCfg.rangeOffset
    else killRange = killCfg.manualRange end
    if killRange < 50 then killRange = 50 end

    task.spawn(function()
        local FireGun = RS:WaitForChild("BulletFireSystem"):WaitForChild("FireGun")
        local BulletHit = RS:WaitForChild("BulletFireSystem"):WaitForChild("BulletHit")
        local RocketHit = RS:WaitForChild("RocketSystem"):WaitForChild("Events"):WaitForChild("RocketHit")

        local targetChar = workspace:FindFirstChild(targetUsername)
        if not targetChar then return end
        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
        local targetHead = targetChar:FindFirstChild("Head")
        if not targetHum or not targetHead or targetHum.Health <= 0 then return end

        local myChar = workspace:FindFirstChild(localPlayer.Name)
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local isExplosive = (gunData.GunType == 3) or (gunData.Mode == "RPG") or (gunData.Mode == "Lock-On")
        local currentDist = (myRoot.Position - targetHead.Position).Magnitude
        local needsTeleport = currentDist > killRange

        if isExplosive then
            local gunModel = myChar:FindFirstChild(realName) or workspace:FindFirstChild(realName)
            if not gunModel then popup("Warfare Tycoon", "Please equip the " .. realName .. " first!", 4, "warning") return end
            popup("Warfare Tycoon", "Firing " .. realName .. " at " .. targetUsername .. "...", 3)
            for i = 1, 5 do
                if targetHum.Health <= 0 then break end
                local payload = {
                    Position = targetHead.Position, Normal = Vector3.new(0, 1, 0),
                    HitPart = targetHead, Vehicle = gunModel, Origin = myRoot.Position,
                    Player = localPlayer, Label = localPlayer.Name .. "Rocket" .. i, Weapon = gunModel
                }
                pcall(function() RocketHit:FireServer(payload) end)
                task.wait(0.5)
            end
            if targetHum.Health <= 0 then popup("Warfare Tycoon", "Killed " .. targetUsername, 4, "success")
            else popup("Warfare Tycoon", "Target survived.", 3, "warning") end
            return
        end

        local clientGun = myChar:FindFirstChild(realName) or workspace:FindFirstChild(realName)
        local serverGun = myChar:FindFirstChild("S" .. realName) or workspace:FindFirstChild("S" .. realName)
        if not clientGun or not serverGun then
            popup("Warfare Tycoon", "Please equip the " .. realName .. " first!", 4, "warning")
            return
        end

        local origX, origY, origZ = myRoot.CFrame.Position.X, myRoot.CFrame.Position.Y, myRoot.CFrame.Position.Z
        local didTeleport = false
        if needsTeleport then
            pcall(function() myRoot.CFrame = CFrame.new(targetHead.Position.X, targetHead.Position.Y + killRange, targetHead.Position.Z) end)
            didTeleport = true
            for i = 1, math.floor(killCfg.aimDelay / 0.05) do
                if not myRoot or not myRoot.Parent then break end
                myRoot.Velocity = Vector3.zero
                task.wait(0.05)
            end
        end

        local settings = {
            Distance = gunData.Distance, MaxSpread = gunData.MaxSpread,
            Mode = gunData.Mode, MaxRecoilPower = gunData.MaxRecoilPower,
            BSpeed = gunData.BSpeed, FireRate = gunData.FireRate,
        }

        local shots = 0
        while targetHum.Health > 0 and shots < killCfg.maxShots do
            if not targetChar.Parent or not targetHead.Parent then break end
            local origin = myRoot.CFrame.Position + Vector3.new(0, 2, 0)
            local hitPos = targetHead.Position
            local dir = (hitPos - origin).Unit
            local distNow = (hitPos - origin).Magnitude
            pcall(function() FireGun:FireServer({dir}, clientGun, serverGun, origin, false) end)
            task.wait(0.02)
            pcall(function() BulletHit:FireServer(clientGun, targetHead, hitPos, {{origin, dir, distNow}, {hitPos, dir, 0}}, Vector3.new(0, 1, 0), settings) end)
            shots = shots + 1
            task.wait(killCfg.shotDelay)
        end

        if didTeleport then
            pcall(function() myRoot.CFrame = CFrame.new(origX, origY, origZ); myRoot.Velocity = Vector3.zero end)
        end

        if targetHum.Health <= 0 then popup("Warfare Tycoon", "Killed " .. targetUsername, 4, "success")
        else popup("Warfare Tycoon", "Finished " .. shots .. " shots.", 3, "warning") end
    end)
end

-- ============================================================
-- 8. Plot Scanning & Sort Helpers
-- ============================================================
local plotCache = {}

local function updateDistances()
    local myChar = workspace:FindFirstChild(localPlayer.Name)
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position
    for _, entry in pairs(plotCache) do
        local plot = entry.plot
        if plot and plot.Parent then
            local basePos = entry.basePos
            if entry.spawnViz and entry.spawnViz.Parent then
                basePos = entry.spawnViz.Position
                entry.basePos = basePos
            end
            entry.baseDistance = (myPos and basePos) and math.floor((myPos - basePos).Magnitude) or nil
            local pDist = nil
            if entry.owner and entry.owner ~= "" then
                local ownerChar = workspace:FindFirstChild(entry.owner)
                local ownerRoot = ownerChar and ownerChar:FindFirstChild("HumanoidRootPart")
                if myPos and ownerRoot then pDist = math.floor((myPos - ownerRoot.Position).Magnitude) end
            end
            entry.playerDistance = pDist
        end
    end
end

local function scanStructure()
    local tycoons = workspace:FindFirstChild("Tycoon") and workspace.Tycoon:FindFirstChild("Tycoons")
    if not tycoons then plotCache = {} return end
    local seen = {}
    for _, plot in ipairs(tycoons:GetChildren()) do
        seen[plot.Name] = true
        local owner = plot:GetAttribute("Owner")
        local info = getOwnerInfo(owner)
        local essentials = plot:FindFirstChild("Essentials")
        local spawnViz = essentials and essentials:FindFirstChild("Spawn Visualizer")
        local root = plot:FindFirstChild("Root")
        local basePos = (spawnViz and spawnViz.Position) or (root and root.Position)
        local entry = plotCache[plot.Name]
        if not entry then entry = { plotName = plot.Name } plotCache[plot.Name] = entry end
        entry.plot = plot
        entry.owner = owner
        entry.display = info.displayName
        entry.userId = info.userId
        entry.avatarUrl = info.avatarUrl
        entry.spawnViz = spawnViz
        entry.basePos = basePos
        entry.isMine = (owner == localPlayer.Name)
        entry.isWhitelisted = whitelist[owner] or false
    end
    for name in pairs(plotCache) do if not seen[name] then plotCache[name] = nil end end
end

local function buildView()
    local list = {}
    for _, entry in pairs(plotCache) do
        if entry.plot and entry.plot.Parent then list[#list + 1] = entry end
    end
    return list
end

local function plotsSignature(list)
	local parts = {}
	for i = 1, #list do
		local p = list[i]
		parts[#parts + 1] = table.concat({
			p.plotName, tostring(p.owner), tostring(p.display), tostring(p.userId),
			tostring(p.avatarUrl ~= nil), tostring(p.playerDistance),
			tostring(p.baseDistance), tostring(p.isWhitelisted),
		}, "|")
	end
	return table.concat(parts, ";")
end

local function sortList(list, mode, distField)
    distField = distField or "baseDistance"
    table.sort(list, function(a, b)
        if a.isMine ~= b.isMine then return a.isMine end
        if mode == "Distance" then return (a[distField] or math.huge) < (b[distField] or math.huge)
        elseif mode == "Name (A-Z)" then return tostring(a.display or a.owner) < tostring(b.display or b.owner)
        elseif mode == "Name (Z-A)" then return tostring(a.display or a.owner) > tostring(b.display or b.owner) end
        return false
    end)
    return list
end

local renderPlayers, renderBases

-- ============================================================
-- 9. Players Tab
-- ============================================================
local playersSortSection = playersTab:Section("Sort & Filter", "Left", "how players are listed")
playersSortSection:Dropdown("Sort Players", {"Distance"}, sortOptions, false, function(v)
    for i, m in ipairs(sortOptions) do if m == v[1] then sortIndex.players = i break end end
    if renderPlayers then renderPlayers(buildView()) end
end)

local playersLocalSection = playersTab:Section("Local Player", "Left", "actions on yourself")
local killSelfBtn = playersLocalSection:Button("Kill Self", function() killPlayer(localPlayer.Name) end)
if not HYBRID_MODE then
    killSelfBtn:SetText("Kill Self [Locked]")
    killSelfBtn:SetRisk()
end

local killSelfToggle = playersLocalSection:Toggle("Kill Self hotkey", true, function() end)
local killSelfRegTime = tick()
killSelfToggle:AddKeybind("k", "Hold", function(on)
    if tick() - killSelfRegTime < 1.0 then return end
    if on then guardedAction("killSelf", function() killPlayer(localPlayer.Name) end) end
end)
keybindToggles.killSelf = killSelfToggle

playersLocalSection:Keybind("Kill Self key", "k", function(key)
    local kk = string.lower(tostring(key or ""))
    local newKey = (kk ~= "" and kk ~= "none" and kk ~= "nil") and kk or ""
    boundKeys.killSelf = newKey
    if newKey ~= "" then vkMemo[newKey] = nil end
    prevKeyDown.killSelf = true
end)

local playersLocalLabel = playersLocalSection:Label("—")

local PLAYER_POOL = 10
local playerCards = {}
for i = 1, PLAYER_POOL do
    local sec = playersTab:Section("Player " .. i, "Right", "target slot " .. i)
    local nameLbl = sec:Label(" ")
    sec:Divider("Actions")
    local currentTarget = nil

    local killBtn = sec:Button("Kill Player", function()
        if currentTarget then killPlayer(currentTarget)
        else popup("Warfare Tycoon", "No player in this slot.", 2, "warning") end
    end)
    if not HYBRID_MODE then
        killBtn:SetText("Kill Player [Locked]")
        killBtn:SetRisk()
    end

    sec:Toggle("Whitelist", false, function(on)
        if currentTarget then
            whitelist[currentTarget] = on or nil
            popup("Warfare Tycoon", (on and "Whitelisted " or "Unwhitelisted ") .. currentTarget, 2)
            local view = buildView()
            if renderPlayers then renderPlayers(view) end
            if renderBases then renderBases(view) end
        end
    end)

    playerCards[i] = { section = sec, nameLbl = nameLbl, setTarget = function(t) currentTarget = t end }
end

function renderPlayers(list)
    sortList(list, sortOptions[sortIndex.players], "playerDistance")
    local mine, others = nil, {}
    for i = 1, #list do
        local p = list[i]
        if p.isMine then mine = p else others[#others + 1] = p end
    end
    if mine then playersLocalLabel:SetText(mine.display or mine.owner or "(Unclaimed)")
    else playersLocalLabel:SetText("—") end

    for i = 1, PLAYER_POOL do
        local card = playerCards[i]
        local p = others[i]
        if p then
            local wlTag = p.isWhitelisted and " [WL]" or ""
            local distTag = p.playerDistance and (" · " .. p.playerDistance .. "s") or " · offline"
            local name = (p.display or p.owner or "(Unclaimed)") .. distTag .. wlTag
            pcall(function() if type(card.section.SetTitle) == "function" then card.section:SetTitle(name) end end)
            card.nameLbl:SetText(name)
            card.setTarget(p.owner)
        else
            pcall(function() if type(card.section.SetTitle) == "function" then card.section:SetTitle(" ") end end)
            card.nameLbl:SetText(" ")
            card.setTarget(nil)
        end
    end
end

-- ============================================================
-- 10. Bases Tab
-- ============================================================
local basesSortSection = basesTab:Section("Sort & Filter", "Left", "how bases are listed")
basesSortSection:Dropdown("Sort Bases", {"Distance"}, sortOptions, false, function(v)
    for i, m in ipairs(sortOptions) do if m == v[1] then sortIndex.bases = i break end end
    if renderBases then renderBases(buildView()) end
end)

local basesMineSection = basesTab:Section("Your Base", "Left", "your current plot")
local basesMineLabel = basesMineSection:Label("—")

local BASE_POOL = 10
local baseCards = {}
for i = 1, BASE_POOL do
    local sec = basesTab:Section("Base " .. i, "Right", "plot slot " .. i)
    local nameLbl = sec:Label(" ")
    local ownerLbl = sec:Label(" ")
    sec:Divider("Actions")
    local soonLbl = sec:Label("Coming soon")
    baseCards[i] = { section = sec, nameLbl = nameLbl, ownerLbl = ownerLbl, soonLbl = soonLbl }
end

function renderBases(list)
    sortList(list, sortOptions[sortIndex.bases], "baseDistance")
    local mine, others = nil, {}
    for i = 1, #list do
        local p = list[i]
        if p.isMine then mine = p else others[#others + 1] = p end
    end
    if mine then
        local owner = mine.display or mine.owner or "(Unclaimed)"
        basesMineLabel:SetText(mine.plotName .. "  —  " .. owner)
    else basesMineLabel:SetText("—") end

    for i = 1, BASE_POOL do
        local card = baseCards[i]
        local p = others[i]
        if p then
            local owner = p.display or p.owner or "(Unclaimed)"
            local wlTag = p.isWhitelisted and " [WL]" or ""
            local distTag = p.baseDistance and (" · " .. p.baseDistance .. "s") or ""
            local title = p.plotName .. distTag .. wlTag
            pcall(function() if type(card.section.SetTitle) == "function" then card.section:SetTitle(title) end end)
            card.nameLbl:SetText(p.plotName)
            card.ownerLbl:SetText(owner)
            card.soonLbl:SetText("Coming soon")
        else
            pcall(function() if type(card.section.SetTitle) == "function" then card.section:SetTitle(" ") end end)
            card.nameLbl:SetText(" ")
            card.ownerLbl:SetText(" ")
            card.soonLbl:SetText(" ")
        end
    end
end

-- ============================================================
-- 10.5 Teleports Tab
-- ============================================================
-- Entry shape:
--   * name         : label for button + toast
--   * position     : Vector3 → teleport to pos + (0,5,0)
--   * cframe       : CFrame  → exact position + rotation
--   * cameraCFrame : CFrame  → optional, snaps camera for ~0.1s
--   * dynamic      : fn → returns Vector3/CFrame or (nil, "reason")
--   * defaultKey   : "" or nil = UNBOUND by default; user opts in via widget
local teleports = {
    base = {
        name = "My Base",
        defaultKey = "",
        dynamic = function()
            scanStructure()
            updateDistances()
            local mine = nil
            for _, entry in pairs(plotCache) do
                if entry.isMine and entry.plot and entry.plot.Parent then mine = entry break end
            end
            if not mine then return nil, "No base found for you." end
            if not mine.basePos then return nil, "No spawn point on your base." end
            return mine.basePos
        end,
    },

    capture = {
        name = "Capture Point",
        defaultKey = "",
        position = Vector3.new(-502.4330, 177.0361, -1022.2966),
    },

    oil1 = {
        name = "Oil 1",
        defaultKey = "",
        cframe = CFrame.new(
            1705.9021, 120.9477, 3777.9307,
            -0.9991, -0.0000, -0.0427,
            -0.0000,  1.0000, -0.0000,
             0.0427, -0.0000, -0.9991
        ),
        cameraCFrame = CFrame.new(
            1705.1234, 129.7897, 3759.5476,
            -0.9991,  0.0157, -0.0393,
             0.0000,  0.9288,  0.3706,
             0.0423,  0.3703, -0.9280
        ),
    },

    oil2 = {
        name = "Oil 2",
        defaultKey = "",
        cframe = CFrame.new(
            -1936.6952, 120.9477, -3698.1614,
             0.9998, -0.0000,  0.0219,
             0.0000,  1.0000,  0.0000,
            -0.0219, -0.0000,  0.9998
        ),
        cameraCFrame = CFrame.new(
            -1935.3724, 134.9026, -3682.8127,
             0.9963, -0.0540,  0.0668,
             0.0000,  0.7776,  0.6287,
            -0.0859, -0.6264,  0.7748
        ),
    },

    oil3 = {
        name = "Oil 3",
        defaultKey = "",
        cframe = CFrame.new(
            -1209.5551, 72.6963, -880.2206,
             0.7541, -0.0000, -0.6567,
            -0.0000,  1.0000, -0.0000,
             0.6567,  0.0000,  0.7541
        ),
        cameraCFrame = CFrame.new(
            -1220.2773, 82.4751, -871.3811,
             0.6361,  0.3949, -0.6629,
             0.0000,  0.8591,  0.5118,
             0.7716, -0.3256,  0.5465
        ),
    },
}

local tpSection = teleportsTab:Section("Teleports", "Left", "action + rebindable hotkey")
local tpInfo    = teleportsTab:Section("Info", "Right", "how keybinds + adding work")

local function doTeleport(key)
    local entry = teleports[key]
    if not entry then
        popup("Warfare Tycoon", "Unknown teleport: " .. tostring(key), 2, "warning")
        return
    end

    local myChar = workspace:FindFirstChild(localPlayer.Name)
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        popup("Warfare Tycoon", "Character not loaded.", 2, "warning")
        return
    end

    local targetCFrame
    if entry.cframe then
        targetCFrame = entry.cframe
    elseif entry.position then
        local p = entry.position
        targetCFrame = CFrame.new(p.X, p.Y + 5, p.Z)
    elseif entry.dynamic then
        local ok, res, err = pcall(entry.dynamic)
        if not ok then
            popup("Warfare Tycoon", entry.name .. ": " .. tostring(res), 3, "error")
            return
        end
        if not res then
            popup("Warfare Tycoon", entry.name .. ": " .. (err or "no position."), 3, "warning")
            return
        end
        if typeof(res) == "CFrame" then
            targetCFrame = res
        else
            targetCFrame = CFrame.new(res.X, res.Y + 5, res.Z)
        end
    end

    if not targetCFrame then
        popup("Warfare Tycoon", entry.name .. ": no position set.", 2, "warning")
        return
    end

    pcall(function()
        myRoot.CFrame = targetCFrame
        myRoot.Velocity = Vector3.zero
    end)

    if entry.cameraCFrame then
        task.defer(function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            local oldType = cam.CameraType
            pcall(function()
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = entry.cameraCFrame
            end)
            task.delay(0.1, function()
                pcall(function()
                    if cam and cam.CameraType == Enum.CameraType.Scriptable then
                        cam.CameraType = oldType
                    end
                end)
            end)
        end)
    end

    popup("Warfare Tycoon", "Teleported to " .. entry.name .. ".", 2, "success")
end

local tpOrder = { "base", "capture", "oil1", "oil2", "oil3" }
local tpBindKey = {
    base = "tpBase", capture = "tpCapture",
    oil1 = "tpOil1", oil2 = "tpOil2", oil3 = "tpOil3",
}

for _, key in ipairs(tpOrder) do
    local entry = teleports[key]
    if entry then
        local actionName = tpBindKey[key]
        tpSection:Button("Teleport: " .. entry.name, function() doTeleport(key) end)

        local toggle = tpSection:Toggle(entry.name .. " hotkey", true, function() end)
        keybindToggles[actionName] = toggle

        -- Only register :AddKeybind() if a default key is set.
        -- Empty defaultKey ⇒ no Settings entry until user binds via :Keybind() widget.
        if entry.defaultKey and entry.defaultKey ~= "" then
            local regTime = tick()
            pcall(function()
                toggle:AddKeybind(entry.defaultKey, "Hold", function(on)
                    if tick() - regTime < 1.0 then return end
                    if on then guardedAction(actionName, function() doTeleport(key) end) end
                end)
            end)
            boundKeys[actionName] = string.lower(tostring(entry.defaultKey))
        else
            boundKeys[actionName] = "" -- unbound
        end

        -- Rebind widget: user opts in here. Empty input = unbind.
        tpSection:Keybind(entry.name .. " key", entry.defaultKey or "", function(k)
            local kk = string.lower(tostring(k or ""))
            local newKey = (kk ~= "" and kk ~= "none" and kk ~= "nil") and kk or ""
            boundKeys[actionName] = newKey
            if newKey ~= "" then vkMemo[newKey] = nil end
            prevKeyDown[actionName] = true -- skip this frame so bind doesn't instantly fire
        end)
    end
end

tpInfo:Info("All teleports start with NO keybind — set only what you need.")
tpInfo:Info("Click the 'X key' row to bind a key. Clear the field to unbind.")
tpInfo:Info("DM zerkly_ on discord for teleport recommendations...")

-- ============================================================
-- 11. Keybind dispatcher (Matcha polling) + polling loops
-- ============================================================
keyActions.applyNew  = doApplyNew
keyActions.applyAll  = doApplyAll
keyActions.refresh   = doRefresh
keyActions.killSelf  = function() killPlayer(localPlayer.Name) end
keyActions.tpBase    = function() doTeleport("base") end
keyActions.tpCapture = function() doTeleport("capture") end
keyActions.tpOil1    = function() doTeleport("oil1") end
keyActions.tpOil2    = function() doTeleport("oil2") end
keyActions.tpOil3    = function() doTeleport("oil3") end

local hasMatchaInput = (type(iskeypressed) == "function")
local hasActiveCheck = (type(isrbxactive) == "function")

-- Warm up Matcha's input binding at t=0.5s, during UI build.
task.spawn(function()
    task.wait(0.5)
    if hasMatchaInput then
        pcall(iskeypressed, VK.f1)
        pcall(iskeypressed, VK.k)
    end
    if hasActiveCheck then
        pcall(isrbxactive)
    end
end)

if hasMatchaInput then
    task.spawn(function()
        -- Wait for startup notifs to finish. Poll loop covers every action name
        -- (bound or not) so binding a key later can't accidentally fire.
        task.wait(5)
        for _, name in ipairs(ALL_ACTION_NAMES) do
            prevKeyDown[name] = true
        end
        print("[Keybinds] Polling loop started.")
        while true do
            local active = true
            if hasActiveCheck then
                local okActive, a = pcall(isrbxactive)
                if okActive and a ~= nil then active = (a == true) end
            end
            if active then
                for _, actionName in ipairs(ALL_ACTION_NAMES) do
                    local rawKey = boundKeys[actionName]
                    local vk = keyNameToVK(rawKey)
                    if vk then
                        local okDown, raw = pcall(iskeypressed, vk)
                        local down = okDown and ((raw == true) or (raw == 1)) or false
                        if down and not prevKeyDown[actionName] then
                            local action = keyActions[actionName]
                            local toggle = keybindToggles[actionName]
                            local enabled = true
                            if toggle then
                                pcall(function()
                                    local v = toggle:Get()
                                    if v ~= nil then enabled = v end
                                end)
                            end
                            if action and enabled then
                                guardedAction(actionName, action)
                            end
                        end
                        prevKeyDown[actionName] = down
                    else
                        -- Unbound: keep the "was up" state so binding later is safe
                        prevKeyDown[actionName] = true
                    end
                end
            end
            task.wait(0.1)
        end
    end)
else
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local pressed = string.lower(tostring(input.KeyCode.Name))
        for _, actionName in ipairs(ALL_ACTION_NAMES) do
            local key = boundKeys[actionName]
            if key and key ~= "" and string.lower(tostring(key)) == pressed and keyActions[actionName] then
                task.spawn(keyActions[actionName])
                return
            end
        end
    end)
    print("[Keybinds] Using UserInputService fallback.")
end

local lastSig = ""

task.spawn(function()
    while true do
        local ok, err = pcall(function()
            updateDistances()
            local view = buildView()
            local sig = plotsSignature(view)
            if sig ~= lastSig then
                lastSig = sig
                renderPlayers(view)
                renderBases(view)
            end
        end)
        if not ok then warn("[Distance] " .. tostring(err)) end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        local ok, err = pcall(scanStructure)
        if not ok then warn("[Structure] " .. tostring(err)) end
        task.wait(3)
    end
end)

task.spawn(function()
    task.wait(1)
    local ok, err = pcall(function()
        scanStructure()
        updateDistances()
        local view = buildView()
        lastSig = plotsSignature(view)
        renderPlayers(view)
        renderBases(view)
    end)
    if not ok then warn("[Init] " .. tostring(err)) end
end)

-- ============================================================
-- 12. Notes + Credits + Startup
-- ============================================================
local about = notesTab:Section("Credits", "Left", "who built what")
about:Label("Menu: zerkly_")
about:Label("UI: inspecttor (INS UI)")
about:Label("Arsenal: " .. (Arsenal and "Loaded" or "Failed to load"))

local cav = notesTab:Section("Caveats", "Right", "behaviour you should know")
cav:Info("Player distances update every 1s (live character position).")
cav:Info("Base distances update every 1s (spawn visualizer).")
cav:Info("New players/bases detected every 3s.")
cav:Info("Whitelisted players are skipped by kill features.")
cav:Info("Hotkeys fire via Matcha iskeypressed() polling — only while Roblox is focused.")
cav:Info("Apply New / Apply All / Refresh default to F2/F3/F4. Kill Self to K.")
cav:Info("Teleports start UNBOUND — bind them from the Teleports tab per-action.")
cav:Info("Uses Matcha's native notify when available (fast, no INSUI frame building).")

task.spawn(function()
    popup("Warfare Tycoon", "Created By zerkly_, Make sure to vote a star in discord!", 10.5, "success")
    task.wait(1.5)
    if Arsenal then
        popup("Arsenal", "Loaded " .. #Arsenal.listAll() .. " weapons (v" .. tostring(Arsenal.Version) .. ")", 5, "info")
    end
    task.wait(1.5)
    popup("UI", "UI Created by - inspecttor", 5, "info")
    task.wait(1.5)
    popup("Warfare Tycoon", "Ready to use! Press P for the menu.", 5, "info")
end)