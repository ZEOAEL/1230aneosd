--[[ Arsenal — Warfare Tycoon weapon data
     Returns a structured table of every known weapon's
     fire payloads, equip payloads, and config values.
     
     Usage:
       local Arsenal = loadstring(game:HttpGet("https://raw.githubusercontent.com/.../main/data/arsenal.lua"))()
       
       Arsenal.HandGuns.M17.Fire        -- fire event code string
       Arsenal.HandGuns.M17.Hit         -- hit event code string
       Arsenal.HandGuns.M17.Equip       -- equip payload string
       Arsenal.HandGuns.M17.Distance    -- 500
       Arsenal.HandGuns.M17.BSpeed      -- 2000
       Arsenal.HandGuns.M17.FireRate    -- 550
       Arsenal.HandGuns.M17.Mode        -- "Semi"
       Arsenal.HandGuns.M17.FireModes   -- { Semi = true, ... }
       Arsenal.Explosives.RPG.Origin    -- payload template
       Arsenal.byCategory("HandGuns")   -- returns filtered subtable
]]

local Arsenal = {
    Version = "1.0.0",
    Categories = { "HandGuns", "Explosives" },

    -- ============================================================
    -- Hand Guns
    -- ============================================================
    HandGuns = {
        ["M17"] = {
            Distance  = 500,
            BSpeed    = 2000,
            FireRate  = 550,
            Mode      = "Semi",
            Ammo      = 17,
            GunClass  = "Pistol",
            GunType   = 0,
            Bullets   = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = false, Auto = false, Explosive = false },
            -- payload templates (replace PureFlitch with local user)
            Fire  = [=[game.ReplicatedStorage.BulletFireSystem.FireGun:FireServer({Vector3.new(0.94, 0.12, 0.33)}, game.Workspace.PureFlitch.M17, game.Workspace.PureFlitch.SM17, Vector3.new(845.77, 67.80, -4763.10), false)]=],
            Hit   = [=[game.ReplicatedStorage.BulletFireSystem.BulletHit:FireServer(game.Workspace.PureFlitch.M17, game.Workspace.Tycoon.Tycoons.Charlie.PurchasedObjects["Upper Walls 1st Floor"].Collision, Vector3.new(916.60, 77.19, -4738.11), {{Vector3.new(845.77, 67.80, -4763.10), Vector3.new(0.94, 0.12, 0.33), 28.0903}, {Vector3.new(902.32, 75.30, -4743.15), Vector3.new(0.94, 0.12, 0.33), 15.2686}}, Vector3.new(-0.97, 0.00, -0.26), {["Distance"] = 500, ["MaxSpread"] = 35, ["Mode"] = "Semi", ["MaxRecoilPower"] = 3, ["BSpeed"] = 2000, ["FireRate"] = 550})]=],
            Equip = [=[game.ReplicatedStorage.ACS_Engine.Events.Equip:FireServer(game.Workspace.PureFlitch.M17, {["MaxSpread"] = 35, ["Mode"] = "Semi", ["Ammo"] = 17, ["GunClass"] = "Pistol", ["GunType"] = 0, ["Distance"] = 500, ["BSpeed"] = 2000, ["FireRate"] = 550, ["Bullets"] = 1, ["FireModes"] = {["Burst"] = false, ["Semi"] = true, ["ChangeFiremode"] = false, ["Auto"] = false, ["Explosive"] = false}})]=],
        },

        ["M4A1"] = {
            Distance  = 3200,
            BSpeed    = 2200,
            FireRate  = 650,
            Mode      = "Auto",
            Ammo      = 30,
            GunClass  = "AR",
            GunType   = 1,
            Bullets   = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
            Fire  = [=[game.ReplicatedStorage.BulletFireSystem.FireGun:FireServer({Vector3.new(-0.95, -0.14, -0.28)}, game.Workspace.PureFlitch.M4A1, game.Workspace.PureFlitch.SM4A1, Vector3.new(880.24, 67.94, -4757.44), false)]=],
            Hit   = [=[game.ReplicatedStorage.BulletFireSystem.BulletHit:FireServer(game.Workspace.PureFlitch.M4A1, game.Workspace.Tycoon.Tycoons.Charlie["Base Floor"].Collision, Vector3.new(853.96, 63.93, -4765.14), {{Vector3.new(880.24, 67.94, -4757.44), Vector3.new(-0.95, -0.14, -0.28), 27.3877}, {Vector3.new(880.24, 67.94, -4757.44), Vector3.new(-0.95, -0.14, -0.28), 27.3877}}, Vector3.new(0.00, 1.00, 0.00), {["Distance"] = 3200, ["MaxSpread"] = 35, ["Mode"] = "Auto", ["MaxRecoilPower"] = 3.5, ["BSpeed"] = 2200, ["FireRate"] = 650})]=],
            Equip = [=[game.ReplicatedStorage.ACS_Engine.Events.Equip:FireServer(game.Workspace.PureFlitch.M4A1, {["MaxSpread"] = 35, ["Mode"] = "Auto", ["Ammo"] = 30, ["GunClass"] = "AR", ["GunType"] = 1, ["Distance"] = 3200, ["BSpeed"] = 2200, ["FireRate"] = 650, ["Bullets"] = 1, ["FireModes"] = {["Burst"] = true, ["Semi"] = true, ["ChangeFiremode"] = true, ["Auto"] = true, ["Explosive"] = false}})]=],
        },

        ["AK47"] = {
            Distance  = 3200,
            BSpeed    = 2500,
            FireRate  = 600,
            Mode      = "Auto",
            Ammo      = 30,
            GunClass  = "AR",
            GunType   = 1,
            Bullets   = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
            Fire  = [=[game.ReplicatedStorage.BulletFireSystem.FireGun:FireServer({Vector3.new(-0.19, -0.15, 0.97)}, game.Workspace.PureFlitch.AK47, game.Workspace.PureFlitch.SAK47, Vector3.new(855.42, 67.88, -4833.04), false)]=],
            Hit   = [=[game.ReplicatedStorage.BulletFireSystem.BulletHit:FireServer(game.Workspace.PureFlitch.AK47, game.Workspace.Tycoon.Tycoons.Charlie["Base Floor"].Collision, Vector3.new(850.41, 63.93, -4807.33), {{Vector3.new(855.42, 67.88, -4833.04), Vector3.new(-0.19, -0.15, 0.97), 26.1989}, {Vector3.new(855.42, 67.88, -4833.04), Vector3.new(-0.19, -0.15, 0.97), 26.1989}}, Vector3.new(0.00, 1.00, 0.00), {["Distance"] = 3200, ["MaxSpread"] = 47, ["Mode"] = "Auto", ["MaxRecoilPower"] = 3, ["BSpeed"] = 2500, ["FireRate"] = 600})]=],
            Equip = [=[game.ReplicatedStorage.ACS_Engine.Events.Equip:FireServer(game.Workspace.PureFlitch.AK47, {["MaxSpread"] = 47, ["Mode"] = "Auto", ["Ammo"] = 30, ["GunClass"] = "AR", ["GunType"] = 1, ["Distance"] = 3200, ["BSpeed"] = 2500, ["FireRate"] = 600, ["Bullets"] = 1, ["FireModes"] = {["Burst"] = false, ["Semi"] = true, ["ChangeFiremode"] = true, ["Auto"] = true, ["Explosive"] = false}})]=],
        },

        ["FAMAS"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 900, Mode = "Auto", Ammo = 25, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
            Fire  = [=[game.ReplicatedStorage.BulletFireSystem.FireGun:FireServer({Vector3.new(-0.96, -0.19, -0.21)}, game.Workspace.PureFlitch.FAMAS, game.Workspace.PureFlitch.SFAMAS, Vector3.new(886.83, 68.01, -4749.67), false)]=],
            Hit   = [=[game.ReplicatedStorage.BulletFireSystem.BulletHit:FireServer(game.Workspace.PureFlitch.FAMAS, game.Workspace.Tycoon.Tycoons.Charlie["Base Floor"].Collision, Vector3.new(865.95, 63.93, -4754.27), {{Vector3.new(886.83, 68.01, -4749.67), Vector3.new(-0.96, -0.19, -0.21), 21.5417}, {Vector3.new(886.83, 68.01, -4749.67), Vector3.new(-0.96, -0.19, -0.21), 21.5417}}, Vector3.new(0.00, 1.00, 0.00), {["Distance"] = 3200, ["MaxSpread"] = 40, ["Mode"] = "Auto", ["MaxRecoilPower"] = 3, ["BSpeed"] = 2200, ["FireRate"] = 900})]=],
            Equip = [=[game.ReplicatedStorage.ACS_Engine.Events.Equip:FireServer(game.Workspace.PureFlitch.FAMAS, {["MaxSpread"] = 40, ["Mode"] = "Auto", ["Ammo"] = 25, ["GunClass"] = "AR", ["GunType"] = 1, ["Distance"] = 3200, ["BSpeed"] = 2200, ["FireRate"] = 900, ["Bullets"] = 1, ["FireModes"] = {["Burst"] = true, ["Semi"] = true, ["ChangeFiremode"] = true, ["Auto"] = true, ["Explosive"] = false}})]=],
        },

        ["UMP45"] = {
            Distance = 3200, BSpeed = 2000, FireRate = 700, Mode = "Auto", Ammo = 25, GunClass = "SMG", GunType = 1, Bullets = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
            Fire  = [=[game.ReplicatedStorage.BulletFireSystem.FireGun:FireServer({Vector3.new(0.83, -0.30, 0.46)}, game.Workspace.PureFlitch.UMP45, game.Workspace.PureFlitch.SUMP45, Vector3.new(845.98, 68.01, -4841.40), false)]=],
            Hit   = [=[game.ReplicatedStorage.BulletFireSystem.BulletHit:FireServer(game.Workspace.PureFlitch.UMP45, game.Workspace.Tycoon.Tycoons.Charlie["Base Floor"].Collision, Vector3.new(857.24, 63.93, -4835.12), {{Vector3.new(845.98, 68.01, -4841.40), Vector3.new(0.83, -0.30, 0.46), 7.08295}, {Vector3.new(845.98, 68.01, -4841.40), Vector3.new(0.83, -0.30, 0.46), 7.08295}}, Vector3.new(0.00, 1.00, 0.00), {["Distance"] = 3200, ["MaxSpread"] = 35, ["Mode"] = "Auto", ["MaxRecoilPower"] = 3, ["BSpeed"] = 2000, ["FireRate"] = 700})]=],
            Equip = [=[game.ReplicatedStorage.ACS_Engine.Events.Equip:FireServer(game.Workspace.PureFlitch.UMP45, {["MaxSpread"] = 35, ["Mode"] = "Auto", ["Ammo"] = 25, ["GunClass"] = "SMG", ["GunType"] = 1, ["Distance"] = 3200, ["BSpeed"] = 2000, ["FireRate"] = 700, ["Bullets"] = 1, ["FireModes"] = {["Burst"] = true, ["Semi"] = true, ["ChangeFiremode"] = true, ["Auto"] = true, ["Explosive"] = false}})]=],
        },

        ["MP9"] = {
            Distance = 500, BSpeed = 2000, FireRate = 900, Mode = "Auto", Ammo = 30, GunClass = "SMG", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
            Fire  = [=[game.ReplicatedStorage.BulletFireSystem.FireGun:FireServer({Vector3.new(0.90, -0.26, 0.36)}, game.Workspace.PureFlitch.MP9, game.Workspace.PureFlitch.SMP9, Vector3.new(848.97, 67.86, -4836.88), false)]=],
            Hit   = [=[game.ReplicatedStorage.BulletFireSystem.BulletHit:FireServer(game.Workspace.PureFlitch.MP9, game.Workspace.Tycoon.Tycoons.Charlie["Base Floor"].Collision, Vector3.new(862.77, 63.93, -4831.40), {{Vector3.new(848.97, 67.86, -4836.88), Vector3.new(0.90, -0.26, 0.36), 15.1994}, {Vector3.new(848.97, 67.86, -4836.88), Vector3.new(0.90, -0.26, 0.36), 15.1994}}, Vector3.new(0.00, 1.00, 0.00), {["Distance"] = 500, ["MaxSpread"] = 35, ["Mode"] = "Auto", ["MaxRecoilPower"] = 3, ["BSpeed"] = 2000, ["FireRate"] = 900})]=],
            Equip = [=[game.ReplicatedStorage.ACS_Engine.Events.Equip:FireServer(game.Workspace.PureFlitch.MP9, {["MaxSpread"] = 35, ["Mode"] = "Auto", ["Ammo"] = 30, ["GunClass"] = "SMG", ["GunType"] = 1, ["Distance"] = 500, ["BSpeed"] = 2000, ["FireRate"] = 900, ["Bullets"] = 1, ["FireModes"] = {["Burst"] = false, ["Semi"] = true, ["ChangeFiremode"] = true, ["Auto"] = true, ["Explosive"] = false}})]=],
        },

        -- Add the rest of your guns here. I've included the metadata
        -- pattern; you'd fill in Fire / Hit / Equip strings from your dump.
        ["M40 Sniper"] = { Distance = 8000, BSpeed = 3000, FireRate = 60, Mode = "Bolt-Action", Ammo = 10, GunClass = "Sniper", GunType = 0, Bullets = 1,
            FireModes = { Burst = false, Semi = false, ChangeFiremode = false, Auto = false, Explosive = false } },

        ["Micro UZI"] = { Distance = 500, BSpeed = 2000, FireRate = 1000, Mode = "Auto", Ammo = 20, GunClass = "SMG", GunType = 0, Bullets = 1 },
        ["MK18 Rifle"] = { Distance = 3200, BSpeed = 2200, FireRate = 800, Mode = "Auto", Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1 },
        ["Dragunov SVD"] = { Distance = 8000, BSpeed = 4200, FireRate = 100, Mode = "Semi", Ammo = 10, GunClass = "Sniper", GunType = 2, Bullets = 1 },
        ["Remington 870"] = { Distance = 2500, BSpeed = 2000, FireRate = 500, Mode = "Pump-Action", Ammo = 7, GunClass = "Shotgun", GunType = 2, Bullets = 8 },
        ["SA80 Rifle"] = { Distance = 3200, BSpeed = 2200, FireRate = 650, Mode = "Auto", Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1 },
        ["Remington MSR"] = { Distance = 8000, BSpeed = 3000, FireRate = 60, Mode = "Bolt-Action", Ammo = 10, GunClass = "Sniper", GunType = 1, Bullets = 1 },
        ["G36C"] = { Distance = 3200, BSpeed = 2200, FireRate = 750, Mode = "Auto", Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1 },
        ["MP5"] = { Distance = 3200, BSpeed = 2000, FireRate = 800, Mode = "Auto", Ammo = 30, GunClass = "SMG", GunType = 1, Bullets = 1 },
        ["G3 Rifle"] = { Distance = 3200, BSpeed = 2500, FireRate = 550, Mode = "Auto", Ammo = 20, GunClass = "AR", GunType = 1, Bullets = 1 },
        ["VSS Vintorez"] = { Distance = 8000, BSpeed = 4200, FireRate = 650, Mode = "Semi", Ammo = 10, GunClass = "AR", GunType = 2, Bullets = 1 },
        ["Mac-10"] = { Distance = 500, BSpeed = 2000, FireRate = 900, Mode = "Auto", Ammo = 30, GunClass = "SMG", GunType = 0, Bullets = 1 },
        ["SPAS-12"] = { Distance = 2500, BSpeed = 2000, FireRate = 200, Mode = "Semi", Ammo = 8, GunClass = "Shotgun", GunType = 0, Bullets = 8 },
        ["SA80"] = { Distance = 3200, BSpeed = 2200, FireRate = 500, Mode = "Auto", Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1 },
        ["VHS-2"] = { Distance = 3200, BSpeed = 2200, FireRate = 850, Mode = "Auto", Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1 },
        ["AUG A3"] = { Distance = 3200, BSpeed = 2200, FireRate = 700, Mode = "Auto", Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1 },
        ["IA2"] = { Distance = 3200, BSpeed = 2200, FireRate = 750, Mode = "Auto", Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1 },
        ["M110 Rifle"] = { Distance = 8000, BSpeed = 2200, FireRate = 500, Mode = "Semi", Ammo = 20, GunClass = "Sniper", GunType = 1, Bullets = 1 },
        ["HK416"] = { Distance = 3200, BSpeed = 2200, FireRate = 800, Mode = "Auto", Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1 },
        ["M1911"] = { Distance = 500, BSpeed = 2000, FireRate = 500, Mode = "Semi", Ammo = 7, GunClass = "Pistol", GunType = 0, Bullets = 1 },
        ["Gewehr 43"] = { Distance = 3200, BSpeed = 2200, FireRate = 400, Mode = "Semi", Ammo = 10, GunClass = "Sniper", GunType = 1, Bullets = 1 },
        ["PPSH"] = { Distance = 3200, BSpeed = 2500, FireRate = 900, Mode = "Auto", Ammo = 71, GunClass = "SMG", GunType = 1, Bullets = 1 },
        ["Kar98K"] = { Distance = 8000, BSpeed = 4000, FireRate = 50, Mode = "Bolt-Action", Ammo = 5, GunClass = "Sniper", GunType = 1, Bullets = 1 },
        ["M16"] = { Distance = 3200, BSpeed = 2200, FireRate = 650, Mode = "Auto", Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1 },
        ["SKS"] = { Distance = 3200, BSpeed = 2200, FireRate = 400, Mode = "Semi", Ammo = 10, GunClass = "Sniper", GunType = 1, Bullets = 1 },
        ["MP7"] = { Distance = 500, BSpeed = 2000, FireRate = 950, Mode = "Auto", Ammo = 30, GunClass = "SMG", GunType = 1, Bullets = 1 },
    },

    -- ============================================================
    -- Explosives
    -- ============================================================
    Explosives = {
        ["RPG"] = {
            Distance = 4000, BSpeed = 2200, FireRate = 15, Mode = "RPG", Ammo = 1,
            GunClass = "Launcher", GunType = 3, Bullets = 1,
            FireModes = { Burst = false, Semi = false, RPG = false, ChangeFiremode = false, Auto = false, Explosive = false },
            Fire  = [=[game.ReplicatedStorage.RocketSystem.Events.RocketHit:FireServer({["Position"] = Vector3.new(-2610.67, 83.66, 2519.74), ["Normal"] = Vector3.new(-0.71, 0.00, 0.71), ["HitPart"] = game.Workspace.Tycoon.Tycoons.Sierra.PurchasedObjects["Armoury 2"].Collision, ["Vehicle"] = game.Players.PureFlitch.Backpack.RPG, ["Origin"] = Vector3.new(-2663.15, 81.08, 2570.54), ["Player"] = game.Players.PureFlitch, ["Label"] = "PureFlitchRocket1", ["Weapon"] = game.Players.PureFlitch.Backpack.RPG})]=],
            Hit   = nil, -- N/A
            Equip = [=[game.ReplicatedStorage.ACS_Engine.Events.Equip:FireServer(game.Workspace.PureFlitch.RPG, {["Mode"] = "RPG", ["Ammo"] = 1, ["Distance"] = 4000, ["GunType"] = 3})]=],
        },
        ["Stinger"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 15, Mode = "Lock-On", Ammo = 1,
            GunClass = "Launcher", GunType = 3, Bullets = 1, Cooldown = 15,
            Fire = nil, -- N/A (uses Lock-On path)
            Hit  = [=[game.ReplicatedStorage.RocketSystem.Events.RocketHit:FireServer({["Position"] = Vector3.new(-2658.52, 349.76, 2437.95), ["Normal"] = Vector3.new(0.00, 0.00, 0.00), ["Vehicle"] = game.Workspace.PureFlitch.Stinger, ["Origin"] = Vector3.new(-2524.97, 68.70, 2184.85), ["Weapon"] = game.Workspace.PureFlitch.Stinger, ["DirectHit"] = true, ["Target"] = game.Workspace["Game Systems"]["Helicopter Workspace"]["AH-64 Apache"].Functionality.TargetPart, ["Player"] = game.Players.PureFlitch, ["Label"] = "PureFlitchRocket0"})]=],
            Equip = [=[game.ReplicatedStorage.ACS_Engine.Events.Equip:FireServer(game.Workspace.PureFlitch.Stinger, {["Mode"] = "Lock-On", ["Ammo"] = 1, ["Cooldown"] = 15, ["GunType"] = 3})]=],
        },
        ["Javelin"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 15, Mode = "Lock-On", Ammo = 1,
            GunClass = "Launcher", GunType = 3, Bullets = 1,
            Fire = nil,
            Hit  = [=[game.ReplicatedStorage.RocketSystem.Events.RocketHit:FireServer({["Position"] = Vector3.new(-3435.99, 64.91, 619.74), ["Normal"] = Vector3.new(0.99, 0.00, 0.15), ["HitPart"] = game.Workspace["Game Systems"]["Vehicle Workspace"]["Humvee TOW-II"].Misc.Doors.Bright.Collision, ["Vehicle"] = game.Workspace.PureFlitch.Javelin, ["Origin"] = Vector3.new(-2695.86, 66.31, 602.98), ["Target"] = game.Workspace["Game Systems"]["Vehicle Workspace"]["Humvee TOW-II"].Body.TargetPart, ["Player"] = game.Players.PureFlitch, ["Label"] = "PureFlitchRocket2", ["Weapon"] = game.Workspace.PureFlitch.Javelin})]=],
            Equip = [=[game.ReplicatedStorage.ACS_Engine.Events.Equip:FireServer(game.Workspace.PureFlitch.Javelin, {["Mode"] = "Lock-On", ["Ammo"] = 1, ["GunType"] = 3})]=],
        },
    },
}

-- ============================================================
-- Helper methods
-- ============================================================

-- Look up a weapon by name across all categories
function Arsenal.find(name)
    for _, cat in ipairs(Arsenal.Categories) do
        local found = Arsenal[cat][name]
        if found then
            return found, cat
        end
    end
    return nil
end

-- Get everything in a category as { name -> data }
function Arsenal.byCategory(category)
    return Arsenal[category] or {}
end

-- List all gun names in a category
function Arsenal.list(category)
    local out = {}
    for name in pairs(Arsenal.byCategory(category)) do
        out[#out+1] = name
    end
    table.sort(out)
    return out
end

-- List every gun across every category
function Arsenal.listAll()
    local out = {}
    for _, cat in ipairs(Arsenal.Categories) do
        for name in pairs(Arsenal[cat]) do
            out[#out+1] = { name = name, category = cat }
        end
    end
    table.sort(out, function(a, b) return a.name < b.name end)
    return out
end

-- Replace a username in a payload string with a new one
function Arsenal.retarget(payload, fromUser, toUser)
    if type(payload) ~= "string" then return payload end
    return (payload:gsub(fromUser, toUser))
end

return Arsenal
