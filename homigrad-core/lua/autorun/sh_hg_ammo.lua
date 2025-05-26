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
		name = "12/70 Gauge",
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
		name = "12/70 Beanbag",
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
	[".44magnum"] = {
		name = ".44 Magnum",
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
	},
	["4.6x30mmnato"] = {
		name = "4.6x30mm NATO",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 200,
		maxcarry = 150,
		minsplash = 10,
		maxsplash = 5
	},
	["5.7x28mm"] = {
		name = "5.7×28mm",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 200,
		maxcarry = 150,
		minsplash = 10,
		maxsplash = 5
	},
	["rpg7proj"] = {
		name = "RPG-7 Projectile",
		count = 1,
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 200,
		maxcarry = 150,
		minsplash = 10,
		maxsplash = 5
	},
}

local ammotypes = hg.ammotypes
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
	[".44magnum"] = {
		Material = "models/hmcd_ammobox_22",
		Scale = 1,
		Color = Color(255, 255, 125)
	},
	["4.6x30mmnato"] = {
		Material = "models/hmcd_ammobox_22",
		Scale = 1,
		Color = Color(255, 255, 125)
	},
	["5.7x28mm"] = {
		Material = "models/hmcd_ammobox_22",
		Scale = 1,
		Color = Color(255, 255, 125)
	},
	["rpg7proj"] = {
		Model = "models/weapons/tfa_ins/w_rpg7_projectile.mdl",
		Scale = 1,
		Color = Color(255, 255, 255)
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
		ammoent.AmmoCount = (tbl.count or 30)
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