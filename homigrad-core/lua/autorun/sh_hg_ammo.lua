-- sh_hg_ammo.lua"

--
hg.ammotypes = {
	["5.56x45mm"] = {
		name = "5.56x45 mm",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 100,
		maxcarry = 120,
		minsplash = 10,
		maxsplash = 5
	},
	["7.62x39mm"] = {
		name = "7.62x39 mm",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 160,
		maxcarry = 120,
		minsplash = 10,
		maxsplash = 5
	},
	["12/70gauge"] = {
		name = "12/70 gauge",
		dmgtype = DMG_BUCKSHOT,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 350,
		maxcarry = 46,
		minsplash = 10,
		maxsplash = 5
	},
	["12/70beanbag"] = {
		name = "12/70 beanbag",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 100,
		maxcarry = 46,
		minsplash = 10,
		maxsplash = 5
	},
	["9x19mmparabellum"] = {
		name = "9x19 mm Parabellum",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 100,
		maxcarry = 80,
		minsplash = 10,
		maxsplash = 5
	},
	[".50actionexpress"] = {
		name = ".50 Action Express",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 200,
		maxcarry = 150,
		minsplash = 10,
		maxsplash = 5
	}
}

local ammotypes = hg.ammotypes
--[[
name = "5.56x45 mm",

name = "7.62x39 mm",

name = "5.45x39 mm",

name = "12/70 gauge",

name = "12/70 beanbag",

name = "9x19 mm Parabellum",

name = ".45 ACP",

name = "4.6×30 mm",

name = "5.7×28 mm",

name = ".44 Remington Magnum",

name = "9x39 mm",

name = ".50 Action Express",

name = "7.62x51 mm",

name = "7.62x54 mm",

name = ".338 Lapua Magnum"
]]
local ammoents = {
	["5.56x45mm"] = {
		Material = "models/hmcd_ammobox_556",
		Scale = 1
	},
	["7.62x39mm"] = {
		Scale = 1
	},
	["12/70gauge"] = {
		Material = "models/hmcd_ammobox_12",
		Scale = 1.1,
	},
	["12/70beanbag"] = {
		Material = "models/hmcd_ammobox_12",
		Scale = 1.1,
	},
	["9x19mmparabellum"] = {
		Material = "models/hmcd_ammobox_9",
		Scale = 0.8,
	},
	[".50actionexpress"] = {
		Material = "models/hmcd_ammobox_22",
		Scale = 1,
		Color = Color(255, 255, 125)
	},
}

local function addAmmoTypes()
	for name, tbl in pairs(ammotypes) do
		game.AddAmmoType(tbl)
		if CLIENT then language.Add(tbl.name .. "_ammo", tbl.name) end
		local ammoent = {}
		ammoent.Base = "ammo_base"
		ammoent.PrintName = tbl.name
		ammoent.Category = "HG Ammo"
		ammoent.Spawnable = true
		ammoent.AmmoCount = 30
		ammoent.AmmoType = tbl.name
		ammoent.Model = ammoents[name].Model or "models/props_lab/box01a.mdl"
		ammoent.ModelMaterial = ammoents[name].Material or ""
		ammoent.ModelScale = ammoents[name].Scale or 1
		ammoent.Color = ammoents[name].Color or Color(255, 255, 255)
		scripted_ents.Register(ammoent, "ent_ammo_" .. name)
	end

	game.BuildAmmoTypes()
	--PrintTable(game.GetAmmoTypes())
end

addAmmoTypes()
hook.Add("Initialize", "init-ammo", addAmmoTypes)