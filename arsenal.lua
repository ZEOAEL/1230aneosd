--[[ Arsenal — Warfare Tycoon weapon data v1.4
     Every gun stores the exact default values the server expects
     in the BulletHit payload. main.lua sends these verbatim.

     REQUIRED fields for bullet weapons (all HandGuns):
       Distance, BSpeed, FireRate, Mode, MaxSpread, MaxRecoilPower
     OPTIONAL fields:
       Ammo, GunClass, GunType, Bullets, FireModes (used by equip, not BulletHit)

     Explosives use RocketHit (different payload) - only Distance matters.
]]

local Arsenal = {
    Version = "1.4.0",
    Categories = { "HandGuns", "Explosives" },

    HandGuns = {
        -- Pistols
        ["M17"] = {
            Distance = 500, BSpeed = 2000, FireRate = 550, Mode = "Semi",
            MaxSpread = 35, MaxRecoilPower = 3,
            Ammo = 17, GunClass = "Pistol", GunType = 0, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = false, Auto = false, Explosive = false },
        },
        ["M1911"] = {
            Distance = 500, BSpeed = 2000, FireRate = 500, Mode = "Semi",
            MaxSpread = 55, MaxRecoilPower = 3,
            Ammo = 7, GunClass = "Pistol", GunType = 0, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = false, Auto = false, Explosive = false },
        },

        -- Assault Rifles
        ["M4A1"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 650, Mode = "Auto",
            MaxSpread = 35, MaxRecoilPower = 3.5,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["AK47"] = {
            Distance = 3200, BSpeed = 2500, FireRate = 600, Mode = "Auto",
            MaxSpread = 47, MaxRecoilPower = 3,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["FAMAS"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 900, Mode = "Auto",
            MaxSpread = 40, MaxRecoilPower = 3,
            Ammo = 25, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["MK18 Rifle"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 800, Mode = "Auto",
            MaxSpread = 40, MaxRecoilPower = 3.5,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["SA80 Rifle"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 650, Mode = "Auto",
            MaxSpread = 40, MaxRecoilPower = 3.5,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["SA80 LSW"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 500, Mode = "Auto",
            MaxSpread = 10, MaxRecoilPower = 3.5,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["G36C"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 750, Mode = "Auto",
            MaxSpread = 40, MaxRecoilPower = 3.5,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["G3 Rifle"] = {
            Distance = 3200, BSpeed = 2500, FireRate = 550, Mode = "Auto",
            MaxSpread = 40, MaxRecoilPower = 3.5,
            Ammo = 20, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["VHS-2"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 850, Mode = "Auto",
            MaxSpread = 40, MaxRecoilPower = 3.5,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["AUG A3"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 700, Mode = "Auto",
            MaxSpread = 40, MaxRecoilPower = 3,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["IA2"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 750, Mode = "Auto",
            MaxSpread = 36, MaxRecoilPower = 3,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["HK416"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 800, Mode = "Auto",
            MaxSpread = 40, MaxRecoilPower = 3.5,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["M16"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 650, Mode = "Auto",
            MaxSpread = 40, MaxRecoilPower = 3.5,
            Ammo = 30, GunClass = "AR", GunType = 1, Bullets = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },

        -- SMGs
        ["UMP45"] = {
            Distance = 3200, BSpeed = 2000, FireRate = 700, Mode = "Auto",
            MaxSpread = 35, MaxRecoilPower = 3,
            Ammo = 25, GunClass = "SMG", GunType = 1, Bullets = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["MP9"] = {
            Distance = 500, BSpeed = 2000, FireRate = 900, Mode = "Auto",
            MaxSpread = 35, MaxRecoilPower = 3,
            Ammo = 30, GunClass = "SMG", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["Micro UZI"] = {
            Distance = 500, BSpeed = 2000, FireRate = 1000, Mode = "Auto",
            MaxSpread = 40, MaxRecoilPower = 2.5,
            Ammo = 20, GunClass = "SMG", GunType = 0, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["MP5"] = {
            Distance = 3200, BSpeed = 2000, FireRate = 800, Mode = "Auto",
            MaxSpread = 30, MaxRecoilPower = 3,
            Ammo = 30, GunClass = "SMG", GunType = 1, Bullets = 1,
            FireModes = { Burst = true, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["Mac-10"] = {
            Distance = 500, BSpeed = 2000, FireRate = 900, Mode = "Auto",
            MaxSpread = 30, MaxRecoilPower = 3,
            Ammo = 30, GunClass = "SMG", GunType = 0, Bullets = 1,
            FireModes = { Burst = false, Semi = false, ChangeFiremode = false, Auto = true, Explosive = false },
        },
        ["MP7"] = {
            Distance = 500, BSpeed = 2000, FireRate = 950, Mode = "Auto",
            MaxSpread = 35, MaxRecoilPower = 3,
            Ammo = 30, GunClass = "SMG", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["PPSH"] = {
            Distance = 3200, BSpeed = 2500, FireRate = 900, Mode = "Auto",
            MaxSpread = 20, MaxRecoilPower = 4,
            Ammo = 71, GunClass = "SMG", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },

        -- Snipers / DMRs
        ["M40 Sniper"] = {
            Distance = 8000, BSpeed = 3000, FireRate = 60, Mode = "Bolt-Action",
            MaxSpread = 100, MaxRecoilPower = 1,
            Ammo = 10, GunClass = "Sniper", GunType = 0, Bullets = 1,
            FireModes = { Burst = false, Semi = false, ChangeFiremode = false, Auto = false, Explosive = false },
        },
        ["Remington MSR"] = {
            Distance = 8000, BSpeed = 3000, FireRate = 60, Mode = "Bolt-Action",
            MaxSpread = 100, MaxRecoilPower = 1,
            Ammo = 10, GunClass = "Sniper", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = false, ChangeFiremode = false, Auto = false, Explosive = false },
        },
        ["Dragunov SVD"] = {
            Distance = 8000, BSpeed = 4200, FireRate = 100, Mode = "Semi",
            MaxSpread = 22, MaxRecoilPower = 2,
            Ammo = 10, GunClass = "Sniper", GunType = 2, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = false, Auto = false, Explosive = false },
        },
        ["VSS Vintorez"] = {
            Distance = 8000, BSpeed = 4200, FireRate = 650, Mode = "Semi",
            MaxSpread = 22, MaxRecoilPower = 2,
            Ammo = 10, GunClass = "AR", GunType = 2, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = true, Auto = true, Explosive = false },
        },
        ["M110 Rifle"] = {
            Distance = 8000, BSpeed = 2200, FireRate = 500, Mode = "Semi",
            MaxSpread = 20, MaxRecoilPower = 3.5,
            Ammo = 20, GunClass = "Sniper", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = false, Auto = false, Explosive = false },
        },
        ["Kar98K"] = {
            Distance = 8000, BSpeed = 4000, FireRate = 50, Mode = "Bolt-Action",
            MaxSpread = 100, MaxRecoilPower = 3.5,
            Ammo = 5, GunClass = "Sniper", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = false, ChangeFiremode = false, Auto = false, Explosive = false },
        },
        ["SKS"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 400, Mode = "Semi",
            MaxSpread = 40, MaxRecoilPower = 3,
            Ammo = 10, GunClass = "Sniper", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = false, Auto = false, Explosive = false },
        },
        ["Gewehr 43"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 400, Mode = "Semi",
            MaxSpread = 40, MaxRecoilPower = 3,
            Ammo = 10, GunClass = "Sniper", GunType = 1, Bullets = 1,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = false, Auto = false, Explosive = false },
        },

        -- Shotguns
        ["Remington 870"] = {
            Distance = 2500, BSpeed = 2000, FireRate = 500, Mode = "Pump-Action",
            MaxSpread = 120, MaxRecoilPower = 1,
            Ammo = 7, GunClass = "Shotgun", GunType = 2, Bullets = 8,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = false, Auto = false, Explosive = false },
        },
        ["SPAS-12"] = {
            Distance = 2500, BSpeed = 2000, FireRate = 200, Mode = "Semi",
            MaxSpread = 150, MaxRecoilPower = 1,
            Ammo = 8, GunClass = "Shotgun", GunType = 0, Bullets = 8,
            FireModes = { Burst = false, Semi = true, ChangeFiremode = false, Auto = false, Explosive = false },
        },
    },

    Explosives = {
        ["RPG"] = {
            Distance = 4000, BSpeed = 2200, FireRate = 15, Mode = "RPG",
            MaxSpread = 40, MaxRecoilPower = 6,
            Ammo = 1, GunClass = "Launcher", GunType = 3, Bullets = 1,
            FireModes = { Burst = false, Semi = false, ChangeFiremode = false, Auto = false, Explosive = false },
        },
        ["Stinger"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 15, Mode = "Lock-On",
            MaxSpread = 40, MaxRecoilPower = 6,
            Ammo = 1, GunClass = "Launcher", GunType = 3, Bullets = 1, Cooldown = 15,
            FireModes = { Burst = false, Semi = false, ChangeFiremode = false, Auto = false, Explosive = false },
        },
        ["Javelin"] = {
            Distance = 3200, BSpeed = 2200, FireRate = 15, Mode = "Lock-On",
            MaxSpread = 40, MaxRecoilPower = 6,
            Ammo = 1, GunClass = "Launcher", GunType = 3, Bullets = 1,
            FireModes = { Burst = false, Semi = false, ChangeFiremode = false, Auto = false, Explosive = false },
        },
    },
}

-- ============================================================
-- Helpers
-- ============================================================
function Arsenal.find(name)
    for _, cat in ipairs(Arsenal.Categories) do
        if Arsenal[cat][name] then
            return Arsenal[cat][name], cat
        end
    end
    return nil
end

function Arsenal.byCategory(category)
    return Arsenal[category] or {}
end

function Arsenal.list(category)
    local out = {}
    for name in pairs(Arsenal.byCategory(category)) do
        out[#out+1] = name
    end
    table.sort(out)
    return out
end

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

_G.Arsenal = Arsenal
return Arsenal
