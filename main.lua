--[[ Warfare Tycoon — INSUI
     UI library: INSUI by neaxusxgod-png
     UI credit: (INS UI)
     Stats engine: Matcha getgc / applygc
]]

-- ============================================================
-- 0. Global Settings & Services
-- ============================================================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/neaxusxgod-png/INS-ui/main/uilib.min.lua"))() or INSUI

-- ============================================================
-- 1. Config & Filters
-- ============================================================
local acs = {
	fireRateOn = false, spreadOn = false, maxSpread = 0,
	ammoOn = false, overheatOn = false, bulletOn = false,
	bullets = 10, punchOn = false,
}

local killCfg = {
    selectedWeapon = "M4A1", height = 3100,
    shotDelay = 0.08, aimDelay = 0.15, maxShots = 15
}

local lastAppliedState = {
    fireRateOn = false, spreadOn = false, ammoOn = false,
    overheatOn = false, bulletOn = false, punchOn = false,
    fallDamageOn = false
}

local excludedValues = {
    ["ProgressBar"] = true, ["UIGradient"] = true, ["RightGradient"] = true, ["RingScale"] = true,
    ["IconButton"] = true, ["OverlayProvider"] = true, ["TopControls"] = true, ["Popover"] = true,
    ["useVariants"] = true, ["Corner"] = true, ["View"] = true, ["Button"] = true, ["Label"] = true,
    ["Text"] = true, ["Icon"] = true, ["Caption"] = true, ["FailedStroke"] = true, ["NumberValue"] = true,
    ["transparencyValue"] = true, ["AudioType"] = true, ["assetId"] = true, ["GetProductInfo"] = true,
    ["HoldDuration"] = true, ["total_duration"] = true, ["offset_duration"] = true,
}

local function relevant(entry)
    local value = tostring(entry.value)
    local reportedType = tostring(entry.type):lower()
    if excludedValues[value] then return false end
    if reportedType ~= "number" then return false end
    return true
end

-- ============================================================
-- 2. Caches for Fast Apply
-- ============================================================
local fallDamageCache = nil
local overheatCache = nil

local function refreshCaches()
    local fdRaw = getgc({ "MaxVelocity", "DamageMult", "FDMG" })
    fallDamageCache = {}
    for _, e in ipairs(fdRaw) do
        if relevant(e) then fallDamageCache[#fallDamageCache+1] = e end
    end
    
    local ohRaw = getgc("OverheatCount")
    overheatCache = {}
    for _, e in ipairs(ohRaw) do
        if relevant(e) then overheatCache[#overheatCache+1] = e end
    end
    
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
    
    if (applyAll or acs.ammoOn ~= lastAppliedState.ammoOn) and acs.ammoOn then
        t.Ammo = 1e6
    end
    
    if (applyAll or acs.bulletOn ~= lastAppliedState.bulletOn) and acs.bulletOn then
        t.Bullets = acs.bullets
    end
    
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
        for _, e in ipairs(raw) do
            if relevant(e) then filtered[#filtered+1] = e end
        end
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
			ownerCache[ownerName] = { username = plr.Name, displayName = tostring(plr.DisplayName or plr.Name), userId = plr.UserId, avatarUrl = nil }
			break
		end
	end

	local info = ownerCache[ownerName]
	if not info then
		local body = HttpService:JSONEncode({ usernames = { ownerName }, excludeBannedUsers = true })
		local response = httpPostSafe("https://users.roblox.com/v1/usernames/users", body, "application/json")
		if response then
			local decodedOk, data = pcall(function() return HttpService:JSONDecode(response) end)
			if decodedOk and data and data.data and data.data[1] then
				local u = data.data[1]
				info = { username = u.name or ownerName, displayName = u.displayName or ownerName, userId = u.id, avatarUrl = nil }
			end
		end
	end
	if not info then info = { username = ownerName, displayName = ownerName, userId = nil, avatarUrl = nil } end

	if info.userId and not info.avatarUrl then
		local url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(info.userId) .. "&size=150x150&format=Png&isCircular=false"
		local response = httpGetSafe(url)
		if response then
			local decodedOk, data = pcall(function() return HttpService:JSONDecode(response) end)
			if decodedOk and data and data.data and data.data[1] then
				info.avatarUrl = data.data[1].imageUrl
			end
		end
	end
	ownerCache[ownerName] = info
	return info
end

-- ============================================================
-- 5. Window + Tabs
-- ============================================================
local win = Lib:CreateWindow({
	title = "Warfare Tycoon", subtitle = "UI credit: (INS UI)", size = Vector2.new(640, 520),
	menuKey = "p", configName = "warfaretycoon", configFolder = "WarfareTycoon", startOpen = true,
})

local combatTab = win:Tab("Combat", "swords")
local playersTab = win:Tab("Players", "users")
local basesTab = win:Tab("Bases", "home")
local notesTab = win:Tab("Notes", "circle-i")
local settingsTab = win:Tab("Settings", "cog")

-- ============================================================
-- 6. Combat Tab
-- ============================================================
local fire = combatTab:Section("─ Fire Rate ─", "Left")
fire:Toggle("Zero fire rate", false, function(on) acs.fireRateOn = on end)

local spread = combatTab:Section("─ Spread ─", "Left")
spread:Toggle("Enable spread overrides", false, function(on) acs.spreadOn = on end)
spread:Slider("MaxSpread value", 0, 1, -100, 100, "", function(v) acs.maxSpread = v end)

local overheat = combatTab:Section("─ Heat ─", "Left")
overheat:Toggle("Infinite ammo (visual)", false, function(on) acs.ammoOn = on end)
overheat:Toggle("No Overheat", false, function(on) acs.overheatOn = on end)

local applySection = combatTab:Section("─ Apply ─", "Left")
applySection:Button("Apply New Only", function()
    task.spawn(function()
        notify("Applying", "Applying newly toggled items...", 4)
        applyStats(false)
        notify("Successful!", "New items applied.", 4)
    end)
end)

applySection:Button("Apply All", function()
    task.spawn(function()
        notify("Applying", "Re-applying all active items...", 4)
        applyStats(true)
        notify("Successful!", "All items applied.", 4)
    end)
end)

applySection:Button("Refresh Caches", function()
    task.spawn(function()
        notify("Cache", "Refreshing caches...", 3)
        refreshCaches()
        notify("Cache", "Caches refreshed!", 3)
    end)
end)

-- Bullet Behavior Section (Only Pellets)
local bullet = combatTab:Section("─ Bullet Behavior ─", "Right")
bullet:Toggle("Enable bullet overrides", false, function(on) acs.bulletOn = on end)
bullet:Slider("Bullets per shot", 10, 1, 1, 15, "", function(v) acs.bullets = v end)

local punch = combatTab:Section("─ Recoil ─", "Right")
punch:Toggle("Zero punch / sway", false, function(on) acs.punchOn = on end)

local fallDamageSection = combatTab:Section("─ Fall Damage ─", "Right")
fallDamageSection:Toggle("No Fall Damage", false, function(on) acs.fallDamageOn = on end)
    :Tooltip("Requires clicking Apply All or Apply New to take effect.")

local killSetup = combatTab:Section("─ Kill Setup ─", "Right")
killSetup:Dropdown("Weapon Type", {"M4A1"}, {"M4A1", "RPG"}, false, function(v) killCfg.selectedWeapon = v[1] end)
killSetup:Slider("Teleport Height", 3100, 50, 500, 5000, " studs", function(v) killCfg.height = v end)

-- ============================================================
-- 7. Kill Player Logic
-- ============================================================
local function killPlayer(targetUsername)
    if not HYBRID_MODE then 
        notify("Warfare Tycoon", "Enable Hybrid Mode for better features!", 4)
        return 
    end
    
    task.spawn(function()
        local FireGun = RS:WaitForChild("BulletFireSystem"):WaitForChild("FireGun")
        local BulletHit = RS:WaitForChild("BulletFireSystem"):WaitForChild("BulletHit")
        local RocketHit = RS:WaitForChild("RocketSystem"):WaitForChild("Events"):WaitForChild("RocketHit")

        local targetChar = workspace:FindFirstChild(targetUsername)
        if not targetChar then return end
        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        local targetHead = targetChar:FindFirstChild("Head")
        if not targetHum or not targetRoot or not targetHead or targetHum.Health <= 0 then return end
        
        local myChar = workspace:FindFirstChild(localPlayer.Name)
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        
        if killCfg.selectedWeapon == "RPG" then
            local rpg = myChar:FindFirstChild("RPG") or workspace:FindFirstChild("RPG")
            if not rpg then notify("Warfare Tycoon", "Please equip the RPG first!", 4) return end
            notify("Warfare Tycoon", "Firing RPG at " .. targetUsername .. "...", 3)
            for i = 1, 5 do
                if targetHum.Health <= 0 then break end
                local payload = { Position = targetHead.Position, Normal = Vector3.new(0, 1, 0), HitPart = targetHead, Vehicle = rpg, Origin = myRoot.Position, Player = localPlayer, Label = localPlayer.Name .. "Rocket" .. i, Weapon = rpg }
                pcall(function() RocketHit:FireServer(payload) end)
                task.wait(0.5)
            end
            if targetHum.Health <= 0 then notify("Warfare Tycoon", "Killed " .. targetUsername .. " with RPG!", 4) else notify("Warfare Tycoon", "RPG shots fired, target survived.", 3) end
            return
        end
        
        local m4 = myChar:FindFirstChild("M4A1") or workspace:FindFirstChild("M4A1")
        local sm4 = myChar:FindFirstChild("SM4A1") or workspace:FindFirstChild("SM4A1")
        if not m4 or not sm4 then notify("Warfare Tycoon", "Please equip the M4A1 first!", 4) return end
        
        local origX, origY, origZ = myRoot.CFrame.Position.X, myRoot.CFrame.Position.Y, myRoot.CFrame.Position.Z
        local tX, tY, tZ = targetHead.Position.X, targetHead.Position.Y + killCfg.height, targetHead.Position.Z
        pcall(function() myRoot.CFrame = CFrame.new(tX, tY, tZ) end)
        
        for i = 1, math.floor(killCfg.aimDelay / 0.05) do
            if not myRoot or not myRoot.Parent then break end
            myRoot.Velocity = Vector3.zero
            task.wait(0.05)
        end
        
        local settings = { Distance = 3200, MaxSpread = 35, Mode = "Auto", MaxRecoilPower = 3.5, BSpeed = 2200, FireRate = 650 }
        local shots = 0
        while targetHum.Health > 0 and shots < killCfg.maxShots do
            if not targetChar.Parent or not targetHead.Parent then break end
            local origin = myRoot.CFrame.Position + Vector3.new(0, 2, 0)
            local hitPos = targetHead.Position
            local dir = (hitPos - origin).Unit
            local distNow = (hitPos - origin).Magnitude
            
            pcall(function() FireGun:FireServer({dir}, m4, sm4, origin, false) end)
            task.wait(0.02)
            pcall(function() BulletHit:FireServer(m4, targetHead, hitPos, {{origin, dir, distNow}, {hitPos, dir, 0}}, Vector3.new(0, 1, 0), settings) end)
            shots = shots + 1
            task.wait(killCfg.shotDelay)
        end
        
        pcall(function() myRoot.CFrame = CFrame.new(origX, origY, origZ); myRoot.Velocity = Vector3.zero end)
        if targetHum.Health <= 0 then notify("Warfare Tycoon", "Killed " .. targetUsername .. "!", 4) else notify("Warfare Tycoon", "Finished " .. shots .. " shots.", 3) end
    end)
end

-- ============================================================
-- 8. Plot Scanning & UI
-- ============================================================
local function scanPlots()
	local list = {}
	local tycoons = workspace:FindFirstChild("Tycoon") and workspace.Tycoon:FindFirstChild("Tycoons")
	if not tycoons then return list end
	for _, plot in ipairs(tycoons:GetChildren()) do
		local owner = plot:GetAttribute("Owner")
		local info = getOwnerInfo(owner)
		task.wait()
		list[#list + 1] = { plotName = plot.Name, owner = owner, display = info.displayName, userId = info.userId, avatarUrl = info.avatarUrl, isMine = (owner == localPlayer.Name) }
	end
	table.sort(list, function(a, b)
		if a.isMine ~= b.isMine then return a.isMine end
		return tostring(a.display or a.owner or a.plotName) < tostring(b.display or b.owner or b.plotName)
	end)
	return list
end

local function plotsSignature(list)
	local parts = {}
	for i = 1, #list do
		local p = list[i]
		parts[#parts + 1] = table.concat({p.plotName, tostring(p.owner), tostring(p.display), tostring(p.userId), tostring(p.avatarUrl ~= nil)}, "|")
	end
	return table.concat(parts, ";")
end

local playersLocalSection = playersTab:Section("Local Player", "Full")

-- Kill Self Button (Hybrid Check)
local killSelfBtn = playersLocalSection:Button("Kill Self", function() 
    killPlayer(localPlayer.Name) 
end)
if not HYBRID_MODE then killSelfBtn:SetText("Kill Self [Locked - Requires Hybrid]") end

local playersLocalLabel = playersLocalSection:Label("—")

local PLAYER_POOL = 10
local playerCards = {}
for i = 1, PLAYER_POOL do
	local sec = playersTab:Section("Player " .. i, "Full")
	local nameLbl = sec:Label(" ")
	sec:Divider("Actions")
	local currentTarget = nil
	
	-- Kill Player Button (Hybrid Check)
	local killBtn = sec:Button("Kill Player", function() 
        if currentTarget then killPlayer(currentTarget) else notify("Warfare Tycoon", "No player in this slot.", 3) end 
    end)
    if not HYBRID_MODE then killBtn:SetText("Kill Player [Locked]") end
    
	playerCards[i] = { section = sec, nameLbl = nameLbl, setTarget = function(t) currentTarget = t end }
end

local function renderPlayers(list)
	local mine = nil
	local others = {}
	for i = 1, #list do local p = list[i]; if p.isMine then mine = p else others[#others + 1] = p end end
	if mine then playersLocalLabel:SetText(mine.display or mine.owner or "(Unclaimed)") else playersLocalLabel:SetText("—") end
	for i = 1, PLAYER_POOL do
		local card = playerCards[i]
		local p = others[i]
		if p then
			local name = p.display or p.owner or "(Unclaimed)"
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

local basesMineSection = basesTab:Section("Your Base", "Full")
local basesMineLabel = basesMineSection:Label("—")
local BASE_POOL = 10
local baseCards = {}
for i = 1, BASE_POOL do
	local sec = basesTab:Section("Base " .. i, "Full")
	local nameLbl = sec:Label(" ")
	local ownerLbl = sec:Label(" ")
	sec:Divider("Actions")
	local soonLbl = sec:Label("Coming soon")
	baseCards[i] = { section = sec, nameLbl = nameLbl, ownerLbl = ownerLbl, soonLbl = soonLbl }
end

local function renderBases(list)
	local mine = nil
	local others = {}
	for i = 1, #list do local p = list[i]; if p.isMine then mine = p else others[#others + 1] = p end end
	if mine then
		local owner = mine.display or mine.owner or "(Unclaimed)"
		basesMineLabel:SetText(mine.plotName .. "  —  " .. owner)
	else basesMineLabel:SetText("—") end
	for i = 1, BASE_POOL do
		local card = baseCards[i]
		local p = others[i]
		if p then
			local owner = p.display or p.owner or "(Unclaimed)"
			pcall(function() if type(card.section.SetTitle) == "function" then card.section:SetTitle(p.plotName) end end)
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

local lastSig = ""
local lastFull = 0
local POLL_INTERVAL = 8
local FULL_REFRESH = 20

task.spawn(function()
	while true do
		local ok, list = pcall(scanPlots)
		if ok and type(list) == "table" then
			local sig = plotsSignature(list)
			local now = os.clock()
			local changed = (sig ~= lastSig)
			local stale = (now - lastFull > FULL_REFRESH)
			if changed or stale then
				lastSig = sig
				lastFull = now
				pcall(renderPlayers, list)
				pcall(renderBases, list)
			end
		end
		task.wait(POLL_INTERVAL)
	end
end)

local about = notesTab:Section("Credits", "Left")
about:Label("UI: (INS UI)")
local cav = notesTab:Section("Caveats", "Right")
cav:Info("Apply New only applies toggles changed since your last Apply. Apply All re-applies everything.")

local settingsSoon = settingsTab:Section("Coming Soon", "Full")
settingsSoon:Info("This tab is under construction.")

task.defer(function() task.wait(0.5) refreshCaches() end)
task.defer(function() task.wait(0.5) notify("Warfare Tycoon", "Ready to use!", 5) end)
task.defer(function() task.wait(1.2) notify("Warfare Tycoon", "UI credit: (INS UI). Press P for the menu.", 5) end)