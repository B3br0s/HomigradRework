AddCSLuaFile()	

CreateConVar("jmod_eft_durmult", 1, {FCVAR_ARCHIVE}, "EFT Armor Durability Multiplier")
CreateConVar("jmod_eft_wghtmult", 1, {FCVAR_ARCHIVE}, "EFT Armor Weight Multiplier")

--[[
⣿⡟⢸⣿⣿⣿⣄⠹⣷⠰⣤⣌⡙⢿⠏⣠⣿⣿⣿⣿⡇⣸
⣿⡇⣾⣿⣿⣿⣿⡧⠈⣀⣹⣿⣿⣦⣰⣿⣿⣿⣿⣿⡇⣿
⣿⡇⢿⣿⣿⣿⣿⣶⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿
⣿⣇⢸⣿⡿⠿⠿⠿⠿⣿⣿⣿⣿⠿⠟⠛⠛⢻⣿⣿⢁⣿
⡿⠿⠄⠻⡖⢰⡆⠀⠀⢸⣿⣿⡇⠀⠀⢸⡆⢹⠋⠁⠚⣿
⣷⡀⠲⣶⡇⢺⣷⡀⢀⡾⠿⣿⣷⣀⣀⣾⠇⣸⡿⠋⣰⣿
⣿⣿⢁⣦⣀⣡⣿⣿⡿⠿⠛⠻⠟⢻⣿⣥⣀⣽⣷⡌⢻⣿
⣿⣿⣬⣭⣌⡙⠛⠿⣷⣶⣾⣿⣿⣿⠛⢛⣀⣬⣥⣤⣼⣿
⣿⣿⣿⣿⣿⣿⣄⠒⢶⣾⣿⣿⣿⣿⣧⡈⢿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡏⠐⢻⣿⣿⣿⣿⣿⣿⣧⠘⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⠃⣼⣿⣿⣿⣿⣿⣿⣿⡇⢻⣿⣿⣿⣿
]]--

JMod.ArmorSlotNiceNames={
	eyes="Eyes",
	mouthnose="Mouth & Nose",
	ears="Ears",
	head="Head",
	chest="Chest",
	back="Back",
	abdomen="Abdomen",
	pelvis="Pelvis",
	waist = "Waist",
	leftthigh="Left Thigh",
	leftcalf="Left Calf",
	rightthigh="Right Thigh",
	rightcalf="Right Calf",
	rightshoulder="Right Shoulder",
	rightforearm="Right Forearm",
	leftshoulder="Left Shoulder",
	leftforearm="Left Forearm",
	acc_head ="Facecover",
	acc_eyes ="Eyewear",
	acc_chestrig ="Chest Rig",
	acc_ears ="Headphones",
	acc_neck ="Neck Protection",
	aventail ="Aventail",
	armband = "Armband",
	acc_rshoulder = "R. Shoulderguard",
	acc_lshoulder = "L. Shoulderguard",
}

local Class1 = {
	[DMG_BUCKSHOT] = .2,
	[DMG_BLAST] = .05,
	[DMG_BULLET] = .15,
	[DMG_SNIPER] = .01,
	[DMG_AIRBOAT] = .1,
	[DMG_CLUB] = .1,
	[DMG_SLASH] = .3,
	[DMG_CRUSH] = .1,
	[DMG_VEHICLE] = .1,
	[DMG_BURN] = .1,
	[DMG_PLASMA] = .1,
	[DMG_ACID] = .1
}
local Class2 = {
	[DMG_BUCKSHOT] = .35,
	[DMG_BLAST] = .2,
	[DMG_BULLET] = .25,
	[DMG_SNIPER] = .1,
	[DMG_AIRBOAT] = .25,
	[DMG_CLUB] = .25,
	[DMG_SLASH] = .35,
	[DMG_CRUSH] = .35,
	[DMG_VEHICLE] = .25,
	[DMG_BURN] = .25,
	[DMG_PLASMA] = .25,
	[DMG_ACID] = .25
}
local Class3 = {
	[DMG_BUCKSHOT] = .45,
	[DMG_BLAST] = .35,
	[DMG_BULLET] = .55,
	[DMG_SNIPER] = .2,
	[DMG_AIRBOAT] = .45,
	[DMG_CLUB] = .5,
	[DMG_SLASH] = .5,
	[DMG_CRUSH] = .5,
	[DMG_VEHICLE] = .25,
	[DMG_BURN] = .25,
	[DMG_PLASMA] = .45,
	[DMG_ACID] = .45
}
local Class4 = {
	[DMG_BUCKSHOT] = .65,
	[DMG_BLAST] = .5,
	[DMG_BULLET] = .7,
	[DMG_SNIPER] = .35,
	[DMG_AIRBOAT] = .6,
	[DMG_CLUB] = .6,
	[DMG_SLASH] = .6,
	[DMG_CRUSH] = .6,
	[DMG_VEHICLE] = .3,
	[DMG_BURN] = .35,
	[DMG_PLASMA] = .6,
	[DMG_ACID] = .6
}
local Class5 = {
	[DMG_BUCKSHOT] = .9,
	[DMG_BLAST] = .7,
	[DMG_BULLET] = .8,
	[DMG_SNIPER] = .5,
	[DMG_AIRBOAT] = .75,
	[DMG_CLUB] = .75,
	[DMG_SLASH] = .8,
	[DMG_CRUSH] = .75,
	[DMG_VEHICLE] = .4,
	[DMG_BURN] = .35,
	[DMG_PLASMA] = .75,
	[DMG_ACID] = .75
}
local Class6 = {
	[DMG_BUCKSHOT] = .95,
	[DMG_BLAST] = .8,
	[DMG_BULLET] = .9,
	[DMG_SNIPER] = .75,
	[DMG_AIRBOAT] = .9,
	[DMG_CLUB] = .9,
	[DMG_SLASH] = 0.95,
	[DMG_CRUSH] = .9,
	[DMG_VEHICLE] = .6,
	[DMG_BURN] = .45,
	[DMG_PLASMA] = .9,
	[DMG_ACID] = .9
}

local NonArmorProtectionProfile = {
	[DMG_BUCKSHOT] = .1,
	[DMG_BLAST] = .05,
	[DMG_BULLET] = .05,
	[DMG_SNIPER] = .05,
	[DMG_AIRBOAT] = .05,
	[DMG_CLUB] = .05,
	[DMG_SLASH] = .05,
	[DMG_CRUSH] = .05,
	[DMG_VEHICLE] = .05,
	[DMG_BURN] = .05,
	[DMG_PLASMA] = .05,
	[DMG_ACID] = .05
}

local durmult = GetConVarNumber( "jmod_eft_durmult" )
local wgtmult = GetConVarNumber( "jmod_eft_wghtmult" )

local ArmorSounds = {
eq = "eft_gear_sounds/gear_armor_use.wav",
uneq = "eft_gear_sounds/gear_armor_drop.wav"
}
local BackpackSounds = {
eq = "eft_gear_sounds/gear_backpack_use.wav",
uneq = "eft_gear_sounds/gear_backpack_drop.wav"
}
local GenericSounds = {
eq = "eft_gear_sounds/gear_generic_use.wav",
uneq = "eft_gear_sounds/gear_generic_drop.wav"
}
local GogglesSounds = {
eq = "eft_gear_sounds/gear_goggles_use.wav",
uneq = "eft_gear_sounds/gear_goggles_drop.wav"
}
local HelmetSounds = {
eq = "eft_gear_sounds/gear_helmet_use.wav",
uneq = "eft_gear_sounds/gear_helmet_drop.wav"
}
local FShieldSounds = {
eq = "eft_gear_sounds/glassshield_on.wav",
uneq = "eft_gear_sounds/glassshield_off.wav"
}

-- this was configured for male 07

local size_bdy =  Vector(0.9,0.9,0.9)
local pos_bdy =   Vector(-2.7,-0.2,0)
local ang_bdy =   Angle(-93,0,90)

local size_head = Vector(0.95,0.95,0.95)
local pos_head =  Vector(0.5,2.2,0.15)
local ang_head =  Angle(-80,0,-90)

local size_eye =  Vector(0.95,0.95,0.95)
local pos_eye =   Vector(0.45,2.1,0.12)
local ang_eye =   Angle(-80,0,-90)

local size_arms = Vector(0.9,0.9,0.9)

local pos_rarm =  Vector(0,6.7,0.8)
local ang_rarm =  Angle(180,90,5)

local pos_larm =  Vector(0,6.7,-0.8)
local ang_larm =  Angle(0,-90,-5)

local size_armband = Vector(0.85,0.85,0.85)

local pos_rarmband =  Vector(0,6.7,0.8)
local ang_rarmband =  Angle(180,90,5)

local pos_larmband =  Vector(0.15,7,-1.1)
local ang_larmband =  Angle(0,-92,-5)

JMod.EFTArmorTable = JMod.EFTArmorTable or {}

--[[
            _          
           (_)         
  _ __ ___  _ ___  ___ 
 | '_ ` _ \| / __|/ __|
 | | | | | | \__ \ (__ 
 |_| |_| |_|_|___/\___|
                                              
]]--

	JMod.EFTArmorTable["White Catphones"] = {
		PrintName = "[HS] Catears [W]",
		mdl = "models/maku/catearheadphones_white.mdl", -- sci fi lt
		snds = GeneralSounds,
		slots = {
			acc_ears = 1
		},
		def = NonArmorProtectionProfile,
		bon = "ValveBiped.Bip01_Head1",
		siz = Vector(1, 1, 1),
		pos = Vector(.75, -.5, 0),
		ang = Angle(-80, 0, -90),
		wgt = wgtmult * .5,
		dur = durmult * 200,
		chrg = {
			power = 10
		},
		ent = "ent_jack_gmod_ezarmor_catphonewhite",
		eff = {
			teamComms = true,
			earPro = true
		},
		tgl = {
		bon = "ValveBiped.Bip01_Head1",
			eff = {},
			slots = {
				acc_ears = 0
			},
			pos = Vector(.75, -.5, 0),
			ang = Angle(-80, 0, -90),
		}
	}

	JMod.EFTArmorTable["Black Catphones"] = {
		PrintName = "[HS] Catears [B]",
		mdl = "models/maku/catearheadphones_black.mdl", -- sci fi lt
		snds = GeneralSounds,
		slots = {
			acc_ears = 1
		},
		def = NonArmorProtectionProfile,
		bon = "ValveBiped.Bip01_Head1",
		siz = Vector(1, 1, 1),
		pos = Vector(.75, -.5, 0),
		ang = Angle(-80, 0, -90),
		wgt = wgtmult * .5,
		dur = durmult * 200,
		chrg = {
			power = 10
		},
		ent = "ent_jack_gmod_ezarmor_catphoneblack",
		eff = {
			teamComms = true,
			earPro = true
		},
		tgl = {
		bon = "ValveBiped.Bip01_Head1",
			eff = {},
			slots = {
				acc_ears = 0
			},
			pos = Vector(.75, -.5, 0),
			ang = Angle(-80, 0, -90),
		}
	}

		JMod.EFTArmorTable["SC Alpha"] = {
			PrintName = "[SC] Alpha",
			mdl = "models/eft_props/secureconts/alpha.mdl",
			slots = {
				waist = .5
			},
			snds = GenericSounds,
			storage = 4,
			def = NonArmorProtectionProfile,
			clr = { r = 255, g = 255, b = 255 },
			clrForced = true,
			bon = "ValveBiped.Bip01_Pelvis",
			siz = Vector(0.6, 0.6, 0.6),
			pos = Vector(4, -5, -4),
			ang = Angle(-100, 230, 90),
			wgt = 0.6,
			dur = 9999,
			ent = "ent_jack_gmod_ezarmor_sc_alpha"
		}

		JMod.EFTArmorTable["SC Beta"] = {
			PrintName = "[SC] Beta",
			mdl = "models/eft_props/secureconts/beta.mdl",
			slots = {
				waist = .5
			},
			snds = GenericSounds,
			storage = 6,
			def = NonArmorProtectionProfile,
			clr = { r = 255, g = 255, b = 255 },
			clrForced = true,
			bon = "ValveBiped.Bip01_Pelvis",
			siz = Vector(0.6, 0.6, 0.6),
			pos = Vector(4, -5, -4),
			ang = Angle(100, 40, 90),
			wgt = 0.8,
			dur = 9999,
			ent = "ent_jack_gmod_ezarmor_sc_beta"
		}

		JMod.EFTArmorTable["SC Epsilon"] = {
			PrintName = "[SC] Epsilon",
			mdl = "models/eft_props/secureconts/epsilon.mdl",
			slots = {
				waist = .5
			},
			snds = GenericSounds,
			storage = 8,
			def = NonArmorProtectionProfile,
			clr = { r = 255, g = 255, b = 255 },
			clrForced = true,
			bon = "ValveBiped.Bip01_Pelvis",
			siz = Vector(0.65, 0.65, 0.65),
			pos = Vector(4, -5, -4),
			ang = Angle(-100, 230, 90),
			wgt = 1.1,
			dur = 9999,
			ent = "ent_jack_gmod_ezarmor_sc_epsilon"
		}

		JMod.EFTArmorTable["SC Gamma"] = {
			PrintName = "[SC] Gamma",
			mdl = "models/eft_props/secureconts/gamma.mdl",
			slots = {
				waist = .5
			},
			snds = GenericSounds,
			storage = 9,
			def = NonArmorProtectionProfile,
			clr = { r = 255, g = 255, b = 255 },
			clrForced = true,
			bon = "ValveBiped.Bip01_Pelvis",
			siz = Vector(0.8, 0.8, 0.8),
			pos = Vector(4, -5, -4),
			ang = Angle(100, 40, 90),
			wgt = 1.2,
			dur = 9999,
			ent = "ent_jack_gmod_ezarmor_sc_gamma"
		}

		JMod.EFTArmorTable["SC Kappa"] = {
			PrintName = "[SC] Kappa",
			mdl = "models/eft_props/secureconts/kappa.mdl",
			slots = {
				waist = .5
			},
			snds = GenericSounds,
			storage = 12,
			def = NonArmorProtectionProfile,
			clr = { r = 255, g = 255, b = 255 },
			clrForced = true,
			bon = "ValveBiped.Bip01_Pelvis",
			siz = Vector(1, 1, 1),
			pos = Vector(4, -5, -4),
			ang = Angle(-100, 230, 90),
			wgt = 2,
			dur = 9999,
			ent = "ent_jack_gmod_ezarmor_sc_kappa"
		}

		JMod.EFTArmorTable["Armband [C]"] = {
			PrintName = "[ACC] Armband [COLOR]",
			mdl = "models/eft_props/gear/armbands/armband_colorable.mdl",
			snds = GenericSounds,
			slots = {
				armband = 1
			},
			def = NonArmorProtectionProfile,
			clr = { r = 255, g = 255, b = 255 },
			bon = "ValveBiped.Bip01_L_UpperArm",
			siz = size_armband,
			pos = pos_larmband,
			ang = ang_larmband,
			wgt = wgtmult * 0.05,
			dur = durmult * 9999,
			ent = "ent_jack_gmod_ezarmor_larmbandcolor"
		}

--[[
   __ _ _ __ _ __ ___   ___  _ __ 
  / _` | '__| '_ ` _ \ / _ \| '__|
 | (_| | |  | | | | | | (_) | |   
  \__,_|_|  |_| |_| |_|\___/|_|    

]]--

	JMod.EFTArmorTable["Module 3M"] = {
		PrintName = "[AR-2] Module 3M",
		mdl = "models/eft_props/gear/armor/ar_module3m.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 6,
		dur = durmult * 160,
		ent = "ent_jack_gmod_ezarmor_module3m"
	}

	JMod.EFTArmorTable["PACA"] = {
		PrintName = "[AR-2] PACA",
		mdl = "models/eft_props/gear/armor/ar_paca.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 3.5,
		dur = durmult * 200,
		ent = "ent_jack_gmod_ezarmor_paca"
	}

	JMod.EFTArmorTable["6B2"] = {
		PrintName = "[AR-2] 6B2",
		mdl = "models/eft_props/gear/armor/ar_6b2.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 5.4,
		dur = durmult * 145,
		ent = "ent_jack_gmod_ezarmor_6b2"
	}

	JMod.EFTArmorTable["Untar Vest"] = {
		PrintName = "[AR-3] Untar Vest",
		mdl = "models/eft_props/gear/armor/ar_untar.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 5.4,
		dur = durmult * 145,
		ent = "ent_jack_gmod_ezarmor_untar"
	}

	JMod.EFTArmorTable["Kora-Kulon"] = {
		PrintName = "[AR-2] Kora-Kulon",
		mdl = "models/eft_props/gear/armor/ar_kirasa_black.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 5.4,
		dur = durmult * 145,
		ent = "ent_jack_gmod_ezarmor_kora_kulon_b"
	}

	JMod.EFTArmorTable["Kora-Kulon DFL"] = {
		PrintName = "[AR-2] Kora-Kulon DFL",
		mdl = "models/eft_props/gear/armor/ar_kirasa_camo.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 5.4,
		dur = durmult * 145,
		ent = "ent_jack_gmod_ezarmor_kora_kulon_dfl"
	}

	JMod.EFTArmorTable["Zhuk3 Press"] = {
		PrintName = "[AR-3] Zhuk3 Press",
		mdl = "models/eft_props/gear/armor/ar_beetle3.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 5.2,
		dur = durmult * 111,
		ent = "ent_jack_gmod_ezarmor_zhukpress"
	}

	JMod.EFTArmorTable["6B23"] = {
		PrintName = "[AR-3] 6B23-1",
		mdl = "models/eft_props/gear/armor/ar_6b23-1.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.9,
		dur = durmult * 86,
		ent = "ent_jack_gmod_ezarmor_6b23"
	}

	JMod.EFTArmorTable["Kirasa-N"] = {
		PrintName = "[AR-3] BNTI Kirasa-N",
		mdl = "models/eft_props/gear/armor/ar_kirasa_n.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.1,
		dur = durmult * 140,
		ent = "ent_jack_gmod_ezarmor_kirasan"
	}

	JMod.EFTArmorTable["Trooper TFO"] = {
		PrintName = "[AR-4] Trooper TFO",
		mdl = "models/eft_props/gear/armor/ar_trooper.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 6.8,
		dur = durmult * 189,
		ent = "ent_jack_gmod_ezarmor_trooper"
	}

	JMod.EFTArmorTable["NFM THOR CRV"] = {
		PrintName = "[AR-4] NFM THOR CRV",
		mdl = "models/eft_props/gear/armor/ar_thor_crv.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 9,
		dur = durmult * 70,
		ent = "ent_jack_gmod_ezarmor_thorcrv"
	}

	JMod.EFTArmorTable["6B13"] = {
		PrintName = "[AR-4] 6B13 (Digi)",
		mdl = "models/eft_props/gear/armor/ar_6b13_digi.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 10.5,
		dur = durmult * 59,
		ent = "ent_jack_gmod_ezarmor_6b13"
	}

	JMod.EFTArmorTable["6B13 Flora"] = {
		PrintName = "[AR-4] 6B13 (Flora)",
		mdl = "models/eft_props/gear/armor/ar_6b13_flora.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 10.5,
		dur = durmult * 59,
		ent = "ent_jack_gmod_ezarmor_6b13flora"
	}

	JMod.EFTArmorTable["6B232"] = {
		PrintName = "[AR-4] 6B23-2",
		mdl = "models/eft_props/gear/armor/ar_6b23-2.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.2,
		dur = durmult * 69,
		ent = "ent_jack_gmod_ezarmor_6b232"
	}

	JMod.EFTArmorTable["OTV"] = {
		PrintName = "[AR-4] OTV (UCP)",
		mdl = "models/eft_props/gear/armor/ar_otv_ucp.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.4,
		dur = durmult * 75,
		ent = "ent_jack_gmod_ezarmor_interceptor"
	}

	JMod.EFTArmorTable["HPC"] = {
		PrintName = "[AR-5] Hexatac HPC",
		mdl = "models/eft_props/gear/armor/ar_hexatac.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 8.5,
		dur = durmult * 111,
		ent = "ent_jack_gmod_ezarmor_hexatachpc"
	}

	JMod.EFTArmorTable["Korund"] = {
		PrintName = "[AR-5] Korund-VM",
		mdl = "models/eft_props/gear/armor/ar_korundvm.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 9.8,
		dur = durmult * 64,
		ent = "ent_jack_gmod_ezarmor_korundvm"
	}

	JMod.EFTArmorTable["Redut-M"] = {
		PrintName = "[AR-5] Redut-M",
		mdl = "models/eft_props/gear/armor/ar_redut_m.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 10,
		dur = durmult * 140,
		ent = "ent_jack_gmod_ezarmor_redutm"
	}

	JMod.EFTArmorTable["Redut-M Neck"] = {
		PrintName = "[AR-5] Redut-M Neck",
		mdl = "models/eft_props/gear/armor/ar_redut_m_neck.mdl", 
		snds = ArmorSounds,
		slots = {
			acc_neck = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 1.5,
		dur = durmult * 60,
		ent = "ent_jack_gmod_ezarmor_redutm_neck"
	}

	JMod.EFTArmorTable["Redut-M Pelvis"] = {
		PrintName = "[AR-5] Redut-M Pelvis",
		mdl = "models/eft_props/gear/armor/ar_redut_m_pelvis.mdl", 
		snds = ArmorSounds,
		slots = {
			pelvis = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 2,
		dur = durmult * 60,
		ent = "ent_jack_gmod_ezarmor_redutm_pelvis"
	}

	JMod.EFTArmorTable["6B13 M"] = {
		PrintName = "[AR-5] 6B13M (Killa)",
		mdl = "models/eft_props/gear/armor/ar_6b13_killa.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.5,
		dur = durmult * 133,
		ent = "ent_jack_gmod_ezarmor_6b13m"
	}

	JMod.EFTArmorTable["Gzhel-K"] = {
		PrintName = "[AR-5] Gzhel-K",
		mdl = "models/eft_props/gear/armor/ar_gjel.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 8.9,
		dur = durmult * 81,
		ent = "ent_jack_gmod_ezarmor_gzhelk"
	}

	JMod.EFTArmorTable["Defender-2"] = {
		PrintName = "[AR-5] Defender-2",
		mdl = "models/eft_props/gear/armor/ar_defender2.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 11.5,
		dur = durmult * 100,
		ent = "ent_jack_gmod_ezarmor_defender2"
	}

	JMod.EFTArmorTable["IOTV Gen4 Vest"] = {
		PrintName = "[AR-5] IOTV Gen4 Vest",
		mdl = "models/eft_props/gear/armor/ar_iotv.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 13,
		dur = durmult * 85,
		ent = "ent_jack_gmod_ezarmor_iotvvest",
		gayPhysics = true
	}

	JMod.EFTArmorTable["IOTV Gen4 Pelvis"] = {
		PrintName = "[AR-5] IOTV Gen4 Pelvis",
		mdl = "models/eft_props/gear/armor/ar_iotv_lower.mdl", -- csgo misc
		snds = ArmorSounds,
		slots = {
			pelvis = 1
		},
		bdg = {
			[1] = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 1.5,
		dur = durmult * 90,
		ent = "ent_jack_gmod_ezarmor_iotvpelvis"
	}

	JMod.EFTArmorTable["IOTV Gen4 Left Shoulder"] = {
		PrintName = "[AR-5] IOTV Gen4 L.Shoulder",
		mdl = "models/eft_props/gear/armor/ar_iotv_shoulder_l.mdl", -- csgo hydra
		snds = ArmorSounds,
		slots = {
			leftshoulder = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_L_UpperArm",
		siz = size_arms,
		pos = pos_larm,
		ang = ang_larm,
		wgt = wgtmult * 1.5,
		dur = durmult * 95,
		ent = "ent_jack_gmod_ezarmor_iotvlshoulder"
	}

	JMod.EFTArmorTable["IOTV Gen4 RightShoulder"] = {
		PrintName = "[AR-5] IOTV Gen4 R.Shoulder",
		mdl = "models/eft_props/gear/armor/ar_iotv_shoulder_r.mdl", -- csgo hydra
		snds = ArmorSounds,
		slots = {
			rightshoulder = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_R_UpperArm",
		siz = size_arms,
		pos = pos_rarm,
		ang = ang_rarm,
		wgt = wgtmult * 1.5,
		dur = durmult * 95,
		ent = "ent_jack_gmod_ezarmor_iotvrhoulder"
	}

	JMod.EFTArmorTable["Redut-T5 Vest"] = {
		PrintName = "[AR-5] Redut-T5 Vest",
		mdl = "models/eft_props/gear/armor/ar_redut_t5.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 9,
		dur = durmult * 180,
		ent = "ent_jack_gmod_ezarmor_redutt5vest"
	}

	JMod.EFTArmorTable["Redut-T5 Neck"] = {
		PrintName = "[AR-5] Redut-T5 Neck",
		mdl = "models/eft_props/gear/armor/ar_redut_t5_neck.mdl", 
		snds = ArmorSounds,
		slots = {
			acc_neck = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 2.5,
		dur = durmult * 60,
		ent = "ent_jack_gmod_ezarmor_redutt5_neck"
	}

	JMod.EFTArmorTable["Redut-T5 Pelvis"] = {
		PrintName = "[AR-5] Redut-T5 Pelvis",
		mdl = "models/eft_props/gear/armor/ar_redut_t5_lower.mdl", 
		snds = ArmorSounds,
		slots = {
			pelvis = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 3.5,
		dur = durmult * 60,
		ent = "ent_jack_gmod_ezarmor_redutt5pelvis"
	}

	JMod.EFTArmorTable["Redut-T5 L. Brassard"] = {
		PrintName = "[AR-5] Redut-T5 L. Brassard",
		mdl = "models/eft_props/gear/armor/ar_redut_t5_shoulder_l.mdl", -- csgo hydra
		snds = ArmorSounds,
		slots = {
			leftshoulder = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_L_UpperArm",
		siz = size_arms,
		pos = pos_larm,
		ang = ang_larm,
		wgt = wgtmult * 1.5,
		dur = durmult * 170,
		ent = "ent_jack_gmod_ezarmor_redutt5lshoulder"
	}

	JMod.EFTArmorTable["Redut-T5 R. Brassard"] = {
		PrintName = "[AR-5] Redut-T5 R. Brassard",
		mdl = "models/eft_props/gear/armor/ar_redut_t5_shoulder_r.mdl", -- csgo hydra
		snds = ArmorSounds,
		slots = {
			rightshoulder = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_R_UpperArm",
		siz = size_arms,
		pos = pos_rarm,
		ang = ang_rarm,
		wgt = wgtmult * 1.5,
		dur = durmult * 170,
		ent = "ent_jack_gmod_ezarmor_redutt5rshoulder"
	}

	JMod.EFTArmorTable["Hexgrid"] = {
		PrintName = "[AR-6] 5.11 Hexgrid",
		mdl = "models/eft_props/gear/armor/ar_custom_hexgrid.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.7,
		dur = durmult * 111,
		ent = "ent_jack_gmod_ezarmor_hexgrid"
	}

	JMod.EFTArmorTable["Slick Black"] = {
		PrintName = "[AR-6] Slick Black",
		mdl = "models/eft_props/gear/armor/ar_slick_b.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 9.7,
		dur = durmult * 114,
		ent = "ent_jack_gmod_ezarmor_slickblack"
	}

		JMod.EFTArmorTable["Slick Tan"] = {
		PrintName = "[AR-6] Slick Tan",
		mdl = "models/eft_props/gear/armor/ar_slick_t.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 9.7,
		dur = durmult * 114,
		ent = "ent_jack_gmod_ezarmor_slicktan"
	}

	JMod.EFTArmorTable["Slick Olive"] = {
		PrintName = "[AR-6] Slick Olive",
		mdl = "models/eft_props/gear/armor/ar_slick_o.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 9.7,
		dur = durmult * 114,
		ent = "ent_jack_gmod_ezarmor_slickolive"
	}

	JMod.EFTArmorTable["BNTI Zhuk-6a"] = {
		PrintName = "[AR-6] Zhuk-6a",
		mdl = "models/eft_props/gear/armor/ar_beetle6a.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 9,
		dur = durmult * 94,
		ent = "ent_jack_gmod_ezarmor_zhuk6a"
	}

	JMod.EFTArmorTable["THOR IC Vest"] = {
		PrintName = "[AR-6] NFM THOR IC Vest",
		mdl = "models/eft_props/gear/armor/ar_thor_intcar.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 10.0,
		dur = durmult * 110,
		ent = "ent_jack_gmod_ezarmor_thoricvest"
	}

	JMod.EFTArmorTable["THOR IC Pelvis"] = {
		PrintName = "[AR-6] NFM THOR IC Pelvis",
		mdl = "models/eft_props/gear/armor/ar_thor_intcar_pelvis.mdl", -- csgo misc
		snds = ArmorSounds,
		slots = {
			pelvis = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 2.0,
		dur = durmult * 110,
		ent = "ent_jack_gmod_ezarmor_thoricpelvis"
	}

	JMod.EFTArmorTable["THOR IC Neck"] = {
		PrintName = "[AR-6] NFM THOR IC Neck",
		mdl = "models/eft_props/gear/armor/ar_thor_intcar_neck.mdl", -- csgo misc
		snds = ArmorSounds,
		slots = {
			acc_neck = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 2.0,
		dur = durmult * 110,
		ent = "ent_jack_gmod_ezarmor_thoricneck"
	}

	JMod.EFTArmorTable["NFM THOR IC Left Shoulder"] = {
		PrintName = "[AR-6] NFM THOR IC Left Shoulder",
		mdl = "models/eft_props/gear/armor/ar_thor_intcar_shoulder_l.mdl", -- csgo hydra
		snds = ArmorSounds,
		slots = {
			leftshoulder = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_L_UpperArm",
		siz = size_arms,
		pos = pos_larm,
		ang = ang_larm,
		wgt = wgtmult * 2.0,
		dur = durmult * 110,
		ent = "ent_jack_gmod_ezarmor_thoriclshoulder"
	}

	JMod.EFTArmorTable["NFM THOR IC Right Shoulder"] = {
		PrintName = "[AR-6] NFM THOR IC Right Shoulder",
		mdl = "models/eft_props/gear/armor/ar_thor_intcar_shoulder_r.mdl", -- csgo hydra
		snds = ArmorSounds,
		slots = {
			rightshoulder = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_R_UpperArm",
		siz = size_arms,
		pos = pos_rarm,
		ang = ang_rarm,
		wgt = wgtmult * 2.0,
		dur = durmult * 110,
		ent = "ent_jack_gmod_ezarmor_thoricrhoulder"
	}

	JMod.EFTArmorTable["6B43 Vest"] = {
		PrintName = "[AR-6] 6B43 Vest",
		mdl = "models/eft_props/gear/armor/ar_6b43_body.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 13.0,
		dur = durmult * 150,
		ent = "ent_jack_gmod_ezarmor_6b43vest",
		gayPhysics = true
	}

	JMod.EFTArmorTable["6B43 Pelvis"] = {
		PrintName = "[AR-6] 6B43 Pelvis",
		mdl = "models/eft_props/gear/armor/ar_6b43_pelvis.mdl", 
		snds = ArmorSounds,
		slots = {
			pelvis = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 1.5,
		dur = durmult * 120,
		ent = "ent_jack_gmod_ezarmor_6b43pelvis"
	}

	JMod.EFTArmorTable["6B43 Neck"] = {
		PrintName = "[AR-6] 6B43 Neck",
		mdl = "models/eft_props/gear/armor/ar_6b43_neck.mdl", 
		snds = ArmorSounds,
		slots = {
			acc_neck = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 2.0,
		dur = durmult * 120,
		ent = "ent_jack_gmod_ezarmor_6b43neck"
	}

	JMod.EFTArmorTable["6B43 Left Shoulder"] = {
		PrintName = "[AR-6] 6B43 L.Sh",
		mdl = "models/eft_props/gear/armor/ar_6b43_shoulder_l.mdl", 
		snds = ArmorSounds,
		slots = {
			leftshoulder = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_L_UpperArm",
		siz = size_arms,
		pos = pos_larm,
		ang = ang_larm,
		wgt = wgtmult * 1.75,
		dur = durmult * 120,
		ent = "ent_jack_gmod_ezarmor_6b43lshoulder"
	}

	JMod.EFTArmorTable["6B43 RightShoulder"] = {
		PrintName = "[AR-6] 6B43 R.Sh",
		mdl = "models/eft_props/gear/armor/ar_6b43_shoulder_r.mdl", 
		snds = ArmorSounds,
		slots = {
			rightshoulder = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_R_UpperArm",
		siz = size_arms,
		pos = pos_rarm,
		ang = ang_rarm,
		wgt = wgtmult * 1.75,
		dur = durmult * 120,
		ent = "ent_jack_gmod_ezarmor_6b43rhoulder"
	}

--[[
                                          _        _               _        _           
                                         | |      | |             | |      (_)          
   __ _ _ __ _ __ ___   ___  _ __ ___  __| |   ___| |__   ___  ___| |_ _ __ _  __ _ ___ 
  / _` | '__| '_ ` _ \ / _ \| '__/ _ \/ _` |  / __| '_ \ / _ \/ __| __| '__| |/ _` / __|
 | (_| | |  | | | | | | (_) | | |  __/ (_| | | (__| | | |  __/\__ \ |_| |  | | (_| \__ \
  \__,_|_|  |_| |_| |_|\___/|_|  \___|\__,_|  \___|_| |_|\___||___/\__|_|  |_|\__, |___/
                                                                               __/ |    
                                                                              |___/     
]]--

	JMod.EFTArmorTable["6B516"] = {
		PrintName = "[ACR-3] 6B5-16",
		mdl = "models/eft_props/gear/armor/cr/cr_6b5_16.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1,
			acc_chestrig = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.1,
		dur = durmult * 145,
		storage = 10,
		ent = "ent_jack_gmod_ezarmor_6b516"
	}

	JMod.EFTArmorTable["TV115"] = {
		PrintName = "[ACR-3] WT TV-115",
		mdl = "models/eft_props/gear/armor/cr/cr_tv115.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 4.5,
		dur = durmult * 144,
		storage = 13,
		ent = "ent_jack_gmod_ezarmor_tv115"
	}

	JMod.EFTArmorTable["EAI MBSS"] = {
		PrintName = "[ACR-3] MBSS",
		mdl = "models/eft_props/gear/armor/cr/cr_mbss.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 5.2,
		dur = durmult * 155,
		storage = 12,
		ent = "ent_jack_gmod_ezarmor_eaimbss"
	}

	JMod.EFTArmorTable["Eagle Industries MMAC"] = {
		PrintName = "[ACR-4] MMAC",
		mdl = "models/eft_props/gear/armor/cr/cr_mmac.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,

		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.2,
		dur = durmult * 89,
		storage	= 14,
		ent = "ent_jack_gmod_ezarmor_mmac"
	}

	JMod.EFTArmorTable["Banshee"] = {
		PrintName = "[ACR-4] Banshee",
		mdl = "models/eft_props/gear/armor/cr/cr_shellback_tactical_banshee.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 6.9,
		dur = durmult * 100,
		storage = 16,
		ent = "ent_jack_gmod_ezarmor_banshee"
	}

	JMod.EFTArmorTable["Ars Arma A18"] = {
		PrintName = "[ACR-4] A18 Skanda",
		mdl = "models/eft_props/gear/armor/cr/cr_ars_arma_18.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 8.2,
		dur = durmult * 160,
		storage = 25,
		ent = "ent_jack_gmod_ezarmor_arsarmaa18"
	}

	JMod.EFTArmorTable["TV110"] = {
		PrintName = "[ACR-4] WT TV-110",
		mdl = "models/eft_props/gear/armor/cr/cr_tv110.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 10.3,
		dur = durmult * 121,
		storage = 23,
		ent = "ent_jack_gmod_ezarmor_tv110"
	}

	JMod.EFTArmorTable["Strandhogg"] = {
		PrintName = "[ACR-4] Strandhogg",
		mdl = "models/eft_props/gear/armor/cr/cr_strandhogg.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1,
			acc_chestrig = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 6.5,
		dur = durmult * 75,
		storage = 17,
		ent = "ent_jack_gmod_ezarmor_strandhogg"
	}

	JMod.EFTArmorTable["RBAV-AF"] = {
		PrintName = "[ACR-4] RBAV-AF",
		mdl = "models/eft_props/gear/armor/cr/cr_bae_rbav_af.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1,
			acc_chestrig = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.5,
		dur = durmult * 82,
		storage = 19,
		ent = "ent_jack_gmod_ezarmor_rbavaf"
	}

	JMod.EFTArmorTable["Osprey MK4A A"] = {
		PrintName = "[ACR-4] Osprey MK4A A",
		mdl = "models/eft_props/gear/armor/cr/cr_osprey_assault.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 8.7,
		dur = durmult * 100,
		storage = 25,
		ent = "ent_jack_gmod_ezarmor_ospreyass"
	}

	JMod.EFTArmorTable["MK4A Neck"] = {
		PrintName = "[AGC-0] MK4A Neck",
		mdl = "models/eft_props/gear/armor/cr/cr_osprey_neck.mdl", 
		snds = ArmorSounds,
		slots = {
			acc_neck = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 8.7,
		dur = durmult * 100,
		ent = "ent_jack_gmod_ezarmor_ospreyassneck"
	}

	JMod.EFTArmorTable["MK4A L.SH.Guard"] = {
		PrintName = "[AGC-0] MK4A L.Sh.Guard",
		mdl = "models/eft_props/gear/armor/cr/cr_osprey_brassard_l.mdl", 
		snds = ArmorSounds,
		slots = {
			acc_lshoulder = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * .5,
		dur = durmult * 100,
		ent = "ent_jack_gmod_ezarmor_ospreylshguard"
	}

	JMod.EFTArmorTable["MK4A R.SH.Guard"] = {
		PrintName = "[AGC-0] MK4A R.Sh.Guard",
		mdl = "models/eft_props/gear/armor/cr/cr_osprey_brassard_r.mdl", 
		snds = ArmorSounds,
		slots = {
			acc_rshoulder = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * .5,
		dur = durmult * 100,
		ent = "ent_jack_gmod_ezarmor_ospreyrshguard"
	}

	JMod.EFTArmorTable["MK4A A L.Brassard"] = {
		PrintName = "[ACR-4] MK4A A L.Brassard",
		mdl = "models/eft_props/gear/armor/cr/cr_osprey_shoulder_l.mdl", 
		snds = ArmorSounds,
		slots = {
			leftshoulder = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_L_UpperArm",
		siz = size_arms,
		pos = pos_larm,
		ang = ang_larm,
		wgt = wgtmult * 1.0,
		dur = durmult * 75,
		ent = "ent_jack_gmod_ezarmor_mk4aalbrassard"
	}

	JMod.EFTArmorTable["MK4A A R.Brassard"] = {
		PrintName = "[ACR-4] MK4A A R.Brassard",
		mdl = "models/eft_props/gear/armor/cr/cr_osprey_shoulder_r.mdl", 
		snds = ArmorSounds,
		slots = {
			rightshoulder = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_R_UpperArm",
		siz = size_arms,
		pos = pos_rarm,
		ang = ang_rarm,
		wgt = wgtmult * 1.0,
		dur = durmult * 75,
		ent = "ent_jack_gmod_ezarmor_mk4aarbrassard"
	}

	JMod.EFTArmorTable["6B3TM"] = {
		PrintName = "[ACR-4] 6B3TM-01M",
		mdl = "models/eft_props/gear/armor/cr/cr_6b3.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1,
			acc_chestrig = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 9.2,
		dur = durmult * 73,
		storage = 12,
		ent = "ent_jack_gmod_ezarmor_6b3tm"
	}	

	JMod.EFTArmorTable["6B515"] = {
		PrintName = "[ACR-4] 6B5-15",
		mdl = "models/eft_props/gear/armor/cr/cr_6b5_15.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1,
			acc_chestrig = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 12.2,
		dur = durmult * 63,
		storage = 10,
		ent = "ent_jack_gmod_ezarmor_6b515"
	}

	JMod.EFTArmorTable["M2"] = {
		PrintName = "[ACR-4] M2",
		mdl = "models/eft_props/gear/armor/cr/cr_m2.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1,
			acc_chestrig = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.0,
		dur = durmult * 109,
		storage = 18,
		ent = "ent_jack_gmod_ezarmor_m2"
	}

	JMod.EFTArmorTable["M1"] = {
		PrintName = "[ACR-4] M1",
		mdl = "models/eft_props/gear/armor/cr/cr_m1.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1,
			acc_chestrig = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 8.3,
		dur = durmult * 93,
		storage = 20,
		ent = "ent_jack_gmod_ezarmor_m1"
	}

	JMod.EFTArmorTable["Crye Precision AVS"] = {
		PrintName = "[ACR-4] CRYE AVS",
		mdl = "models/eft_props/gear/armor/cr/cr_crye_avs.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1,
			pelvis = 1,
			acc_chestrig = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 8.7,
		dur = durmult * 140,
		storage = 23,
		ent = "ent_jack_gmod_ezarmor_cryeavs",
	}

	JMod.EFTArmorTable["TacTec"] = {
		PrintName = "[ACR-5] 5.11 TacTec",
		mdl = "models/eft_props/gear/armor/cr/cr_carrier_tactec.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 9.5,
		dur = durmult * 111,
		storage = 18,
		ent = "ent_jack_gmod_ezarmor_tactec"
	}

	JMod.EFTArmorTable["AACPC"] = {
		PrintName = "[ACR-5] Ars Arma CPC MOD.2",
		mdl = "models/eft_props/gear/armor/cr/cr_arscpc.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 8.5,
		dur = durmult * 133,
		storage = 23,
		ent = "ent_jack_gmod_ezarmor_aacpc"
	}

	JMod.EFTArmorTable["CPC GE"] = {
		PrintName = "[ACR-5] CPC GE",
		mdl = "models/eft_props/gear/armor/cr/cr_black_knight.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 9.6,
		dur = durmult * 150,
		storage = 18,
		ent = "ent_jack_gmod_ezarmor_cpcge"
	}

	JMod.EFTArmorTable["PlateFrame GE"] = {
		PrintName = "[ACR-5] PlateFrame GE",
		mdl = "models/eft_props/gear/armor/cr/cr_precision_bigpipe.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 6.4,
		dur = durmult * 189,
		storage = 10,
		ent = "ent_jack_gmod_ezarmor_plateframege"
	}


	JMod.EFTArmorTable["Osprey MK4A P"] = {
		PrintName = "[ACR-5] Osprey MK4A P",
		mdl = "models/eft_props/gear/armor/cr/cr_osprey_defence.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 10.5,
		dur = durmult * 100,
		storage = 24,
		ent = "ent_jack_gmod_ezarmor_ospreyprotec"
	}

	JMod.EFTArmorTable["MK4A P L.Brassard"] = {
		PrintName = "[ACR-5] MK4A P L.Brassard",
		mdl = "models/eft_props/gear/armor/cr/cr_osprey_shoulder_l.mdl", 
		snds = ArmorSounds,
		slots = {
			leftshoulder = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_L_UpperArm",
		siz = size_arms,
		pos = pos_larm,
		ang = ang_larm,
		wgt = wgtmult * 1.0,
		dur = durmult * 75,
		ent = "ent_jack_gmod_ezarmor_mk4aplbrassard"
	}

	JMod.EFTArmorTable["MK4A P R.Brassard"] = {
		PrintName = "[ACR-5] MK4A P R.Brassard",
		mdl = "models/eft_props/gear/armor/cr/cr_osprey_shoulder_r.mdl", 
		snds = ArmorSounds,
		slots = {
			rightshoulder = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_R_UpperArm",
		siz = size_arms,
		pos = pos_rarm,
		ang = ang_rarm,
		wgt = wgtmult * 1.0,
		dur = durmult * 75,
		ent = "ent_jack_gmod_ezarmor_mk4aprbrassard"
	}

	JMod.EFTArmorTable["Bagariy"] = {
		PrintName = "[ACR-5] Bagariy",
		mdl = "models/eft_props/gear/armor/cr/cr_bagarii.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			abdomen = 1,
			acc_chestrig = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 13.0,
		dur = durmult * 79,
		storage = 25,
		ent = "ent_jack_gmod_ezarmor_bagariy"
	}

	JMod.EFTArmorTable["TT SK"] = {
		PrintName = "[ACR-6] TT SK",
		mdl = "models/eft_props/gear/armor/cr/cr_tt_plate_carrier.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.5,
		dur = durmult * 50,
		storage = 8,
		ent = "ent_jack_gmod_ezarmor_ttsk"
	}

	JMod.EFTArmorTable["MBAV Tagilla"] = {
		PrintName = "[ACR-6] AVS MBAV",
		mdl = "models/eft_props/gear/armor/cr/cr_tagilla.mdl", 
		snds = ArmorSounds,
		slots = {
			chest = 1,
			acc_chestrig = 1,
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		wgt = wgtmult * 7.8,
		dur = durmult * 109,
		storage = 12,
		ent = "ent_jack_gmod_ezarmor_tagilla"
	}

--[[
  _                _                     _        
 | |              | |                   | |       
 | |__   __ _  ___| | ___ __   __ _  ___| | _____ 
 | '_ \ / _` |/ __| |/ / '_ \ / _` |/ __| |/ / __|
 | |_) | (_| | (__|   <| |_) | (_| | (__|   <\__ \
 |_.__/ \__,_|\___|_|\_\ .__/ \__,_|\___|_|\_\___/
                       | |                        
                       |_|                        
]]--

	JMod.EFTArmorTable["6Sh118"] = {
		PrintName = "[BP] 6Sh118",
		mdl = "models/eft_props/gear/backpacks/bp_6sh118.mdl",
		snds = BackpackSounds,
		BackpackSlots = 12,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 3.5,
		dur = durmult * 999,
		storage	= 48,
		ent = "ent_jack_gmod_ezarmor_6sh118",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["LBT-2670 SFMP"] = {
		PrintName = "[BP] LBT-2670 SFMP",
		mdl = "models/eft_props/gear/backpacks/bp_medpack.mdl",
		snds = BackpackSounds,
		BackpackSlots = 4,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.92,
		dur = durmult * 999,
		storage	= 48,
		ent = "ent_jack_gmod_ezarmor_sfmp",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Blackjack"] = {
		PrintName = "[BP] Blackjack",
		mdl = "models/eft_props/gear/backpacks/bp_blackjack.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 3.265,
		dur = durmult * 999,
		storage	= 42,
		ent = "ent_jack_gmod_ezarmor_blackjack",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["F4 Terminator"] = {
		PrintName = "[BP] F4 Terminator",
		mdl = "models/eft_props/gear/backpacks/bp_f4terminator.mdl",
		snds = BackpackSounds,
		BackpackSlots = 8,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 4.194,
		dur = durmult * 999,
		storage	= 40,
		ent = "ent_jack_gmod_ezarmor_f4terminator",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["SATL"] = {
		PrintName = "[BP] Mystery Ranch SATL",
		mdl = "models/eft_props/gear/backpacks/bp_mystery_ranch_satl.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 2.95,
		dur = durmult * 999,
		storage	= 36,
		ent = "ent_jack_gmod_ezarmor_mystery_ranch_satl",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["SSO Attack 2"] = {
		PrintName = "[BP] SSO Attack 2",
		mdl = "models/eft_props/gear/backpacks/bp_s_so.mdl",
		snds = BackpackSounds,
		BackpackSlots = 8,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 2.8,
		dur = durmult * 999,
		storage	= 35,
		ent = "ent_jack_gmod_ezarmor_attack2",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["TT Trooper 35"] = {
		PrintName = "[BP] Trooper 35",
		mdl = "models/eft_props/gear/backpacks/bp_trooper_35.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.004,
		dur = durmult * 999,
		storage	= 35,
		ent = "ent_jack_gmod_ezarmor_tttrooper35",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Pilgrim"] = {
		PrintName = "[BP] Pilgrim",
		mdl = "models/eft_props/gear/backpacks/bp_piligrimm.mdl",
		snds = BackpackSounds,
		BackpackSlots = 8,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 3.48,
		dur = durmult * 999,
		storage	= 35,
		ent = "ent_jack_gmod_ezarmor_piligrim",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Paratus 3-Day"] = {
		PrintName = "[BP] Paratus 3-Day",
		mdl = "models/eft_props/gear/backpacks/bp_paratus_3_day.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 2.01,
		dur = durmult * 999,
		storage	= 35,
		ent = "ent_jack_gmod_ezarmor_paratus",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Gunslinger"] = {
		PrintName = "[BP] G2 Gunslinger II",
		mdl = "models/eft_props/gear/backpacks/bp_g2_gunslinger.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 2.948,
		dur = durmult * 999,
		storage	= 35,
		ent = "ent_jack_gmod_ezarmor_gunslinger",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Mechanism"] = {
		PrintName = "[BP] Mechanism",
		mdl = "models/eft_props/gear/backpacks/bp_oakley_mechanism.mdl",
		snds = BackpackSounds,
		BackpackSlots = 8,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 0.997,
		dur = durmult * 999,
		storage	= 32,
		ent = "ent_jack_gmod_ezarmor_mechanismbp",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Beta 2 Battle BP"] = {
		PrintName = "[BP] Beta 2 Battle BP",
		mdl = "models/eft_props/gear/backpacks/bp_anatactical_beta.mdl",
		snds = BackpackSounds,
		BackpackSlots = 4,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 2.0,
		dur = durmult * 999,
		storage	= 30,
		ent = "ent_jack_gmod_ezarmor_beta2bp",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Gruppa 99 T30 (B)"] = {
		PrintName = "[BP] Gruppa 99 T30 (B)",
		mdl = "models/eft_props/gear/backpacks/bp_gr99_t30_b.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.4,
		dur = durmult * 999,
		storage	= 30,
		ent = "ent_jack_gmod_ezarmor_gruppa99t30b",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Gruppa 99 T30 (M)"] = {
		PrintName = "[BP] Gruppa 99 T30 (M)",
		mdl = "models/eft_props/gear/backpacks/bp_gr99_t30_m.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.4,
		dur = durmult * 999,
		storage	= 30,
		ent = "ent_jack_gmod_ezarmor_gruppa99t30m",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["F5 Switchblade"] = {
		PrintName = "[BP] F5 Switchblade",
		mdl = "models/eft_props/gear/backpacks/bp_f5switchblade.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.632,
		dur = durmult * 999,
		storage	= 30,
		ent = "ent_jack_gmod_ezarmor_switchblade",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Tri-Zip"] = {
		PrintName = "[BP] Tri-Zip",
		mdl = "models/eft_props/gear/backpacks/bp_trizip.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 2.2,
		dur = durmult * 999,
		storage	= 30,
		ent = "ent_jack_gmod_ezarmor_trizip",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["RK-PT-25"] = {
		PrintName = "[BP] Tehinkom RK-PT-25",
		mdl = "models/eft_props/gear/backpacks/bp_tehnikom_patrol.mdl",
		snds = BackpackSounds,
		BackpackSlots = 8,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.1,
		dur = durmult * 999,
		storage	= 25,
		ent = "ent_jack_gmod_ezarmor_tehinkom",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Dragon Egg MkII"] = {
		PrintName = "[BP] Dragon Egg Mark II",
		mdl = "models/eft_props/gear/backpacks/bp_dragon_egg_mk2.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.1,
		dur = durmult * 999,
		storage	= 25,
		ent = "ent_jack_gmod_ezarmor_dragonegg",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["LBT-1476A"] = {
		PrintName = "[BP] LBT-1476A",
		mdl = "models/eft_props/gear/backpacks/bp_lbt1476a.mdl",
		snds = BackpackSounds,
		BackpackSlots = 4,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.133,
		dur = durmult * 999,
		storage	= 25,
		ent = "ent_jack_gmod_ezarmor_lbt1476a",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Gruppa 99 T20 (T)"] = {
		PrintName = "[BP] Gruppa 99 T20 (T)",
		mdl = "models/eft_props/gear/backpacks/bp_gr99t20_o.mdl",
		snds = BackpackSounds,
		BackpackSlots = 10,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.25,
		dur = durmult * 999,
		storage	= 25,
		ent = "ent_jack_gmod_ezarmor_gruppa99t20t",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Gruppa 99 T20 (M)"] = {
		PrintName = "[BP] Gruppa 99 T20 (M)",
		mdl = "models/eft_props/gear/backpacks/bp_gr99t20_m.mdl",
		snds = BackpackSounds,
		BackpackSlots = 10,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.25,
		dur = durmult * 999,
		storage	= 25,
		ent = "ent_jack_gmod_ezarmor_gruppa99t20m",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Drawbridge"] = {
		PrintName = "[BP] Drawbridge",
		mdl = "models/eft_props/gear/backpacks/bp_drawbridge.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.67,
		dur = durmult * 999,
		storage	= 25,
		ent = "ent_jack_gmod_ezarmor_drawbridge",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Takedown Black"] = {
		PrintName = "[BP] Takedown",
		mdl = "models/eft_props/gear/backpacks/bp_takedown_sling.mdl",
		snds = BackpackSounds,
		BackpackSlots = 4,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.58,
		dur = durmult * 999,
		storage	= 24,
		ent = "ent_jack_gmod_ezarmor_takedownbbp",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Takedown Multicam"] = {
		PrintName = "[BP] Takedown",
		mdl = "models/eft_props/gear/backpacks/bp_takedown_sling_m.mdl",
		snds = BackpackSounds,
		BackpackSlots = 4,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.58,
		dur = durmult * 999,
		storage	= 24,
		ent = "ent_jack_gmod_ezarmor_takedownmbp",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Pillbox"] = {
		PrintName = "[BP] Pillbox",
		mdl = "models/eft_props/gear/backpacks/bp_pillbox.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 2.338,
		dur = durmult * 999,
		storage	= 20,
		ent = "ent_jack_gmod_ezarmor_pillboxbp",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Scav Backpack"] = {
		PrintName = "[BP] Scav Backpack",
		mdl = "models/eft_props/gear/backpacks/bp_scav_backpack.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 2.214,
		dur = durmult * 999,
		storage	= 20,
		ent = "ent_jack_gmod_ezarmor_scavbackpack",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Berkut BP"] = {
		PrintName = "[BP] WT Berkut",
		mdl = "models/eft_props/gear/backpacks/bp_wartech.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.0,
		dur = durmult * 999,
		storage	= 20,
		ent = "ent_jack_gmod_ezarmor_berkutbp",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["LBT-8005A Day Pack"] = {
		PrintName = "[BP] LBT-8005A Day Pack",
		mdl = "models/eft_props/gear/backpacks/bp_daypack.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 0.57,
		dur = durmult * 999,
		storage	= 20,
		ent = "ent_jack_gmod_ezarmor_daypack",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Sanitar's Bag"] = {
		PrintName = "[BP] Sanitar's Bag",
		mdl = "models/eft_props/gear/backpacks/bp_med_bag.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.44,
		dur = durmult * 999,
		storage	= 16,
		ent = "ent_jack_gmod_ezarmor_sanitarbag",
	}

	JMod.EFTArmorTable["Flyye MBSS"] = {
		PrintName = "[BP] Flyye MBSS",
		mdl = "models/eft_props/gear/backpacks/bp_mbss.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.1,
		dur = durmult * 999,
		storage	= 16,
		ent = "ent_jack_gmod_ezarmor_flyyembss",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["NICE COMM 3 BVS"] = {
		PrintName = "[BP] NICE COMM 3 BVS",
		mdl = "models/eft_props/gear/backpacks/bp_mystery_ranch.mdl",
		snds = BackpackSounds,
		BackpackSlots = 4,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 15,
		dur = durmult * 999,
		storage	= 14,
		ent = "ent_jack_gmod_ezarmor_birdeyebackpack",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Duffle Bag"] = {
		PrintName = "[BP] Duffle Bag",
		mdl = "models/eft_props/gear/backpacks/bp_forward.mdl",
		snds = BackpackSounds,
		BackpackSlots = 4,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 1.08,
		dur = durmult * 999,
		storage	= 12,
		ent = "ent_jack_gmod_ezarmor_dufflebag",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["LolKek 3F"] = {
		PrintName = "[BP] LolKek 3F",
		mdl = "models/eft_props/gear/backpacks/bp_redfox.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 0.984,
		dur = durmult * 999,
		storage	= 12,
		ent = "ent_jack_gmod_ezarmor_lolkek3f",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Tactical Sling Bag"] = {
		PrintName = "[BP] Tactical Sling Bag",
		mdl = "models/eft_props/gear/backpacks/bp_tactical_backpack.mdl",
		snds = BackpackSounds,
		BackpackSlots = 2,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 0.84,
		dur = durmult * 999,
		storage	= 9,
		ent = "ent_jack_gmod_ezarmor_tacticalslingb",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["VKBO Army Bag"] = {
		PrintName = "[BP] VKBO Army Bag",
		mdl = "models/eft_props/gear/backpacks/bp_vkbo.mdl",
		snds = BackpackSounds,
		BackpackSlots = 4,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 0.96,
		dur = durmult * 999,
		storage	= 8,
		ent = "ent_jack_gmod_ezarmor_vkboarmybag",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

	JMod.EFTArmorTable["Transformer Bag"] = {
		PrintName = "[BP] Transformer Bag",
		mdl = "models/eft_props/gear/backpacks/bp_max_fuchs.mdl",
		snds = BackpackSounds,
		BackpackSlots = 6,
		IsBackpack = true,
		slots = {
			back = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 1
		},
		wgt = wgtmult * 0.48,
		dur = durmult * 999,
		storage	= 6,
		ent = "ent_jack_gmod_ezarmor_transformerbag",
		tgl = {
			bdg = {
				[0] = 2
			},
			slots = {
				back = 1,
			}
		}
	}

--[[
       _               _          _           
      | |             | |        (_)          
   ___| |__   ___  ___| |_   _ __ _  __ _ ___ 
  / __| '_ \ / _ \/ __| __| | '__| |/ _` / __|
 | (__| | | |  __/\__ \ |_  | |  | | (_| \__ \
  \___|_| |_|\___||___/\__| |_|  |_|\__, |___/
                                     __/ |    
                                    |___/     
]]--

	JMod.EFTArmorTable["Scav Vest"] = {
		PrintName = "[CR] Scav Vest",
		mdl = "models/eft_props/gear/chestrigs/cr_vestwild.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 0.4,
		dur = durmult * 999,
		storage = 6,
		ent = "ent_jack_gmod_ezarmor_scavvest",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Security Vest"] = {
		PrintName = "[CR] Security Vest",
		mdl = "models/eft_props/gear/chestrigs/cr_ctacticall.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 0.51,
		dur = durmult * 999,
		storage = 6,
		ent = "ent_jack_gmod_ezarmor_securityvest",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["M4 RSCR"] = {
		PrintName = "[CR] M4 RSCR",
		mdl = "models/eft_props/gear/chestrigs/cr_rscr_zulu.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 0.521,
		dur = durmult * 999,
		storage = 6,
		ent = "ent_jack_gmod_ezarmor_m4rscr",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["DIY IDEA CR"] = {
		PrintName = "[CR] IDEA CR",
		mdl = "models/eft_props/gear/chestrigs/cr_razgruz_ikea.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 0.22,
		dur = durmult * 999,
		storage = 8,
		ent = "ent_jack_gmod_ezarmor_ideacr",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Bank Robber"] = {
		PrintName = "[CR] Bank Robber",
		mdl = "models/eft_props/gear/chestrigs/cr_bank_robber.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 0.4,
		dur = durmult * 999,
		storage = 8,
		ent = "ent_jack_gmod_ezarmor_bankrobber",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["MRig"] = {
		PrintName = "[CR] Micro Rig",
		mdl = "models/eft_props/gear/chestrigs/cr_micro_rig_series.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 0.8,
		dur = durmult * 999,
		storage = 8,
		ent = "ent_jack_gmod_ezarmor_microrig",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Chicom"] = {
		PrintName = "[CR] Type 56 Chicom",
		mdl = "models/eft_props/gear/chestrigs/cr_chicom.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 0.65,
		dur = durmult * 999,
		storage = 10,
		ent = "ent_jack_gmod_ezarmor_chicomcr",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["TV-109"] = {
		PrintName = "[CR] WT TV-109",
		mdl = "models/eft_props/gear/chestrigs/cr_tv109.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.8,
		dur = durmult * 999,
		storage = 10,
		ent = "ent_jack_gmod_ezarmor_wtrig",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["CSA"] = {
		PrintName = "[CR] CSA CR",
		mdl = "models/eft_props/gear/chestrigs/cr_cs_assault.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 0.75,
		dur = durmult * 999,
		storage = 10,
		ent = "ent_jack_gmod_ezarmor_csa",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["UMTBS 6sh112"] = {
		PrintName = "[CR] UMTBS 6sh112",
		mdl = "models/eft_props/gear/chestrigs/cr_6h112.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.7,
		dur = durmult * 999,
		storage = 12,
		ent = "ent_jack_gmod_ezarmor_6h112",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Khamelion"] = {
		PrintName = "[CR] Khamelion",
		mdl = "models/eft_props/gear/chestrigs/cr_zryachii.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.7,
		dur = durmult * 999,
		storage = 12,
		ent = "ent_jack_gmod_ezarmor_khamelion",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Tarzan"] = {
		PrintName = "[CR] Tarzan",
		mdl = "models/eft_props/gear/chestrigs/cr_tarzan.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.45,
		dur = durmult * 999,
		storage = 14,
		ent = "ent_jack_gmod_ezarmor_tarzan",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["D3CRX"] = {
		PrintName = "[CR] D3CRX",
		mdl = "models/eft_props/gear/chestrigs/cr_d3crx.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 0.9,
		dur = durmult * 999,
		storage = 16,
		ent = "ent_jack_gmod_ezarmor_d3crx",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Triton"] = {
		PrintName = "[CR] Triton",
		mdl = "models/eft_props/gear/chestrigs/cr_triton.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.3,
		dur = durmult * 999,
		storage = 16,
		ent = "ent_jack_gmod_ezarmor_triton",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Commando Black"] = {
		PrintName = "[CR] Commando B",
		mdl = "models/eft_props/gear/chestrigs/cr_commando_b.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.34,
		dur = durmult * 999,
		storage = 16,
		ent = "ent_jack_gmod_ezarmor_commandoblack",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Commando Tan"] = {
		PrintName = "[CR] Commando T",
		mdl = "models/eft_props/gear/chestrigs/cr_commando_t.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.34,
		dur = durmult * 999,
		storage = 16,
		ent = "ent_jack_gmod_ezarmor_commandotan",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Thunderbolt"] = {
		PrintName = "[CR] Thunderbolt",
		mdl = "models/eft_props/gear/chestrigs/cr_thunderbolt.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 0.62,
		dur = durmult * 999,
		storage = 16,
		ent = "ent_jack_gmod_ezarmor_thunderbolt",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["BSS-MK1"] = {
		PrintName = "[CR] BSS-MK1",
		mdl = "models/eft_props/gear/chestrigs/cr_bssmk1.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.0,
		dur = durmult * 999,
		storage = 16,
		ent = "ent_jack_gmod_ezarmor_bssmk1",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Umka"] = {
		PrintName = "[CR] Umka M33-SET1",
		mdl = "models/eft_props/gear/chestrigs/cr_umka_m33.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.2,
		dur = durmult * 999,
		storage = 16,
		ent = "ent_jack_gmod_ezarmor_umka",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["LBT-1961A"] = {
		PrintName = "[CR] LBT-1961A",
		mdl = "models/eft_props/gear/chestrigs/cr_bearing.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.36,
		dur = durmult * 999,
		storage = 18,
		ent = "ent_jack_gmod_ezarmor_bearing",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["LBCR GE"] = {
		PrintName = "[CR] LBT-1961A GE",
		mdl = "models/eft_props/gear/chestrigs/cr_lbt_1961_boss.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.36,
		dur = durmult * 999,
		storage = 18,
		ent = "ent_jack_gmod_ezarmor_birdeyerig",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["SProfi MK2 R"] = {
		PrintName = "[CR] SProfi MK2 (R)",
		mdl = "models/eft_props/gear/chestrigs/cr_sprofi_mk2_smg.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.4,
		dur = durmult * 999,
		storage = 18,
		ent = "ent_jack_gmod_ezarmor_sprofirecon",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["SProfi MK2 A"] = {
		PrintName = "[CR] SProfi MK2 (A)",
		mdl = "models/eft_props/gear/chestrigs/cr_sprofi_mk2_ak.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.75,
		dur = durmult * 999,
		storage = 18,
		ent = "ent_jack_gmod_ezarmor_sprofiass",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["BlackRock"] = {
		PrintName = "[CR] BlackRock",
		mdl = "models/eft_props/gear/chestrigs/cr_blackrock.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.8,
		dur = durmult * 999,
		storage = 20,
		ent = "ent_jack_gmod_ezarmor_blackrock",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["MK3 Chest Rig"] = {
		PrintName = "[CR] WT MK3 TV-104",
		mdl = "models/eft_props/gear/chestrigs/cr_mk3.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.65,
		dur = durmult * 999,
		storage = 20,
		ent = "ent_jack_gmod_ezarmor_mk3chestrig",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Alpha CR"] = {
		PrintName = "[CR] Alpha CR",
		mdl = "models/eft_props/gear/chestrigs/cr_alpha.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.7,
		dur = durmult * 999,
		storage = 20,
		ent = "ent_jack_gmod_ezarmor_alphacr",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Azimut B"] = {
		PrintName = "[CR] Azimut",
		mdl = "models/eft_props/gear/chestrigs/cr_azimut_b.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.6,
		dur = durmult * 999,
		storage = 20,
		ent = "ent_jack_gmod_ezarmor_azimutb",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["Azimut S"] = {
		PrintName = "[CR] Azimut",
		mdl = "models/eft_props/gear/chestrigs/cr_azimut_s.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.6,
		dur = durmult * 999,
		storage = 20,
		ent = "ent_jack_gmod_ezarmor_azimuts",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["MPPV"] = {
		PrintName = "[CR] MPPV",
		mdl = "models/eft_props/gear/chestrigs/cr_patrol.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.6,
		dur = durmult * 999,
		storage = 24,
		ent = "ent_jack_gmod_ezarmor_mppv",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

	JMod.EFTArmorTable["BeltAB"] = {
		PrintName = "[CR] Belt-A+B",
		mdl = "models/eft_props/gear/chestrigs/cr_beld_ab.mdl",
		snds = GenericSounds,
		slots = {
			acc_chestrig = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Spine2",
		siz = size_bdy,
		pos = pos_bdy,
		ang = ang_bdy,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.7,
		dur = durmult * 999,
		storage = 25,
		ent = "ent_jack_gmod_ezarmor_beltab",
		tgl = {
			bdg = {
				[0] = 1
			},
			slots = {
				acc_chestrig = 1,
			}
		}
	}

--[[
  _                    _          _       
 | |                  | |        | |      
 | |__   ___  __ _  __| |___  ___| |_ ___ 
 | '_ \ / _ \/ _` |/ _` / __|/ _ \ __/ __|
 | | | |  __/ (_| | (_| \__ \  __/ |_\__ \
 |_| |_|\___|\__,_|\__,_|___/\___|\__|___/
                                          
]]--

	JMod.EFTArmorTable["FAST RAC Headset"] = {
		PrintName = "[HS] FAST RAC Headset",
		mdl = "models/eft_props/gear/helmets/helmet_ops_core_rac_headset.mdl", -- sci fi lt
		snds = GenericSounds,
		slots = {
			ears = 1,
			acc_ears = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.6,
		dur = durmult * 200,
		ent = "ent_jack_gmod_ezarmor_fastracheadset",
		chrg = {
			power = 10
		},
		eff = {
			teamComms = true,
			earPro = true
		},
		tgl = {
		slots = {
			ears = 0,
			acc_ears = 0,
		},
			eff = {},
		}
	}

	JMod.EFTArmorTable["GSSh-01"] = {
		PrintName = "[HS] GSSh-01",
		mdl = "models/eft_props/gear/headsets/headset_gsh01.mdl",
		snds = GenericSounds,
		slots = {
			acc_ears = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.5,
		dur = durmult * 200,
		ent = "ent_jack_gmod_ezarmor_gssh01",
	}

	JMod.EFTArmorTable["Sordin"] = {
		PrintName = "[HS] Sordin Supreme PRO-X/L",
		mdl = "models/eft_props/gear/headsets/headset_msa.mdl",
		snds = GenericSounds,
		slots = {
			acc_ears = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 6.5,
		dur = durmult * 200,
		ent = "ent_jack_gmod_ezarmor_sordin",
	}

	JMod.EFTArmorTable["M32"] = {
		PrintName = "[HS] M32",
		mdl = "models/eft_props/gear/headsets/headset_m32.mdl",
		snds = GenericSounds,
		slots = {
			acc_ears = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .7,
		dur = durmult * 200,
		chrg = {
			power = 10
		},
		ent = "ent_jack_gmod_ezarmor_m32",
		eff = {
			teamComms = true,
			earPro = true
		},
		tgl = {
		bon = "ValveBiped.Bip01_Head1",
			eff = {},
			slots = {
				acc_ears = 0
			},
		}
	}

	JMod.EFTArmorTable["ComTac"] = {
		PrintName = "[HS] Peltor ComTac 2",
		mdl = "models/eft_props/gear/headsets/headset_comtacii.mdl",
		snds = GenericSounds,
		slots = {
			acc_ears = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .7,
		dur = durmult * 200,
		chrg = {
			power = 10
		},
		ent = "ent_jack_gmod_ezarmor_comtac",
		eff = {
			teamComms = true,
			earPro = true
		},
		tgl = {
		bon = "ValveBiped.Bip01_Head1",
			eff = {},
			slots = {
				acc_ears = 0
			},
		}
	}

	JMod.EFTArmorTable["Tactical Sport"] = {
		PrintName = "[HS] Tactical Sport",
		mdl = "models/eft_props/gear/headsets/headset_tactical_sport.mdl",
		snds = GenericSounds,
		slots = {
			acc_ears = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 6.5,
		dur = durmult * 200,
		ent = "ent_jack_gmod_ezarmor_tacticalsport",
	}

	JMod.EFTArmorTable["Razor"] = {
		PrintName = "[HS] Razor",
		mdl = "models/eft_props/gear/headsets/headset_razor.mdl",
		snds = GenericSounds,
		slots = {
			acc_ears = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 6.5,
		dur = durmult * 200,
		ent = "ent_jack_gmod_ezarmor_razor",
	}

	JMod.EFTArmorTable["XCEL"] = {
		PrintName = "[HS] XCEL 500BT",
		mdl = "models/eft_props/gear/headsets/headset_xcel.mdl",
		snds = GenericSounds,
		slots = {
			acc_ears = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 6.5,
		dur = durmult * 200,
		ent = "ent_jack_gmod_ezarmor_xcel",
	}

	JMod.EFTArmorTable["ComTac 4"] = {
		PrintName = "[HS] Peltor ComTac 4",
		mdl = "models/eft_props/gear/headsets/headset_comtaciv.mdl",
		snds = GenericSounds,
		slots = {
			acc_ears = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .6,
		dur = durmult * 200,
		chrg = {
			power = 10
		},
		ent = "ent_jack_gmod_ezarmor_comtac4",
		eff = {
			teamComms = true,
			earPro = true
		},
		tgl = {
		bon = "ValveBiped.Bip01_Head1",
			eff = {},
			slots = {
				acc_ears = 0
			},
		}
	}

--[[
   ___ _   _  _____      _____  __ _ _ __ 
  / _ \ | | |/ _ \ \ /\ / / _ \/ _` | '__|
 |  __/ |_| |  __/\ V  V /  __/ (_| | |   
  \___|\__, |\___| \_/\_/ \___|\__,_|_|   
        __/ |                             
       |___/                              
]]--

	JMod.EFTArmorTable["Tactical Glasses"] = {
		PrintName = "[EW] Tactical",
		mdl = "models/eft_props/gear/eyewear/glasses_tactical.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.05,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_tactical",
	}

	JMod.EFTArmorTable["AF Glasses"] = {
		PrintName = "[EW] AF Glasses",
		mdl = "models/eft_props/gear/eyewear/glasses_afg.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.11,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_afglasses",

	}

	JMod.EFTArmorTable["6B34"] = {
		PrintName = "[EW] 6B34",
		mdl = "models/eft_props/gear/eyewear/glasses_6b34.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.12,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_6b34",

	}

	JMod.EFTArmorTable["Dundukk sunglasses"] = {
		PrintName = "[EW] Dundukk",
		mdl = "models/eft_props/gear/eyewear/glasses_duduma.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.05,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_dundukglass",

	}

	JMod.EFTArmorTable["M Frame Glasses"] = {
		PrintName = "[EW] M Frame",
		mdl = "models/eft_props/gear/eyewear/glasses_m_frame.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.032,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_mframe",

	}

	JMod.EFTArmorTable["Pyramex Proximity"] = {
		PrintName = "[EW] Proximity",
		mdl = "models/eft_props/gear/eyewear/glasses_proximity.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.026,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_proximityglasses",

	}

	JMod.EFTArmorTable["Gascan Glasses"] = {
		PrintName = "[EW] Gascan",
		mdl = "models/eft_props/gear/eyewear/glasses_gascan.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.034,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_gascan",

	}

	JMod.EFTArmorTable["Round Sunglasses"] = {
		PrintName = "[EW] Round",
		mdl = "models/eft_props/gear/eyewear/glasses_aoron.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.04,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_roundglasses",

	}

	JMod.EFTArmorTable["RayBench Glasses"] = {
		PrintName = "[EW] RayBench",
		mdl = "models/eft_props/gear/eyewear/glasses_rayban.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.08,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_raybench",

	}

	JMod.EFTArmorTable["Aviator Glasses"] = {
		PrintName = "[EW] Aviator",
		mdl = "models/eft_props/gear/eyewear/glasses_aviator.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.027,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_aviators",

	}

	JMod.EFTArmorTable["JohnB Glasses"] = {
		PrintName = "[EW] JohnB Liquid DNB",
		mdl = "models/eft_props/gear/eyewear/glasses_johnb.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.06,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_johnb",

	}

	JMod.EFTArmorTable["Crossbow Glasses"] = {
		PrintName = "[EW] Crossbow",
		mdl = "models/eft_props/gear/eyewear/glasses_ess.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.03,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_crossbow",

	}

	JMod.EFTArmorTable["Gas Welder Glasses"] = {
		PrintName = "[EW] Gas Welder",
		mdl = "models/eft_props/gear/eyewear/glasses_welder.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = NonArmorProtectionProfile		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.45,
		dur = durmult * 999,
		ent = "ent_jack_gmod_ezarmor_gaswelderglass",

	}

	JMod.EFTArmorTable["Batwolf Glasses"] = {
		PrintName = "[EW] Batwolf",
		mdl = "models/eft_props/gear/eyewear/glasses_oakley.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = Class1		,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.5,
		dur = durmult * 25,
		ent = "ent_jack_gmod_ezarmor_batwolf",

	}

	JMod.EFTArmorTable["Condor Glasses"] = {
		PrintName = "[EW] NPP KlASS Condor",
		mdl = "models/eft_props/gear/eyewear/glasses_npp.mdl", 
		snds = GogglesSounds,
		slots = {
			acc_eyes = 1,
		},

		def = Class1,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_eye,
		pos = pos_eye,
		ang = ang_eye,
		wgt = wgtmult * 0.03,
		dur = durmult * 31,
		ent = "ent_jack_gmod_ezarmor_condorglass",

	}


--[[
  _ ____   ____ _ ___ 
 | '_ \ \ / / _` / __|
 | | | \ V / (_| \__ \
 |_| |_|\_/ \__, |___/
             __/ |    
            |___/     
]]--

	JMod.EFTArmorTable["PVS-14 NVM"] = {
		PrintName = "[HGC] PVS-14 NVM",
		mdl = "models/eft_props/gear/nvgs/nvg_pvs14.mdl",
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		slots = {
			eyes = 1
		},
		bdg = {
			[0] = 1,
			[1] = 0,
			[2] = 1,
		},
		def = NonArmorProtectionProfile,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = 0.79,
		dur = 20,
		chrg = {
			power = 80
		},
		mskmat = "mask_overlays/mask_old_monocular.png",
		eqsnd = "snds_jack_gmod/tinycapcharge.wav",
		ent = "ent_jack_gmod_ezarmor_pvs14nvm",
		eff = {
			nightVision = true
		},
		blackvisionwhendead=true,
		tgl = {
			bdg = {
			[0] = 2,
			[1] = 1,
			[2] = 1,
		},
			blackvisionwhendead=false,
			mskmat = "",
			eff = {},
			slots = {
				eyes = 0
			}
		}
	}

	JMod.EFTArmorTable["PNV-10T NVG"] = {
		PrintName = "[HGC] PNV-10T NVG",
		mdl = "models/eft_props/gear/nvgs/nvg_alpha_pnv_10t.mdl",
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		slots = {
			eyes = 1
		},
		bdg = {
			[0] = 1,
			[1] = 0,
			[2] = 1,
		},
		def = NonArmorProtectionProfile,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = 0.95,
		dur = 20,
		chrg = {
			power = 80
		},
		mskmat = "mask_overlays/mask_binocular.png",
		eqsnd = "snds_jack_gmod/tinycapcharge.wav",
		ent = "ent_jack_gmod_ezarmor_pnv10t",
		eff = {
			nightVision = true
		},
		blackvisionwhendead=true,
		tgl = {
			bdg = {
			[0] = 2,
			[1] = 1,
			[2] = 1,
		},
			blackvisionwhendead=false,
			mskmat = "",
			eff = {},
			slots = {
				eyes = 0
			}
		}
	}

	JMod.EFTArmorTable["N-15 NVG"] = {
		PrintName = "[HGC] N-15 NVG + Strap",
		mdl = "models/eft_props/gear/nvgs/nvg_armasight_n15.mdl",
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		slots = {
			eyes = 1
		},
		bdg = {
			[1] = 0,
		},
		def = NonArmorProtectionProfile,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = 1.115,
		dur = 20,
		chrg = {
			power = 80
		},
		mskmat = "mask_overlays/mask_binocular.png",
		eqsnd = "snds_jack_gmod/tinycapcharge.wav",
		ent = "ent_jack_gmod_ezarmor_n15nvg",
		eff = {
			nightVisionWP = true
		},
		blackvisionwhendead=true,
		tgl = {
			bdg = {
			[1] = 1,
		},
			blackvisionwhendead=false,
			mskmat = "",
			eff = {},
			slots = {
				eyes = 0
			}
		}
	}

	JMod.EFTArmorTable["GPNVG-18"] = {
		PrintName = "[HGC] GPNVG-18",
		mdl = "models/eft_props/gear/nvgs/nvg_l3_gpnvg_18_anvis.mdl",
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		slots = {
			eyes = 1
		},
		bdg = {
			[0] = 1,
			[1] = 0,
		},
		def = NonArmorProtectionProfile,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = 0.88,
		dur = 20,
		chrg = {
			power = 80
		},
		mskmat = "mask_overlays/mask_anvis.png",
		eqsnd = "snds_jack_gmod/tinycapcharge.wav",
		ent = "ent_jack_gmod_ezarmor_gpnvg18",
		eff = {
			nightVision = true
		},
		blackvisionwhendead=true,
		tgl = {
			bdg = {
			[0] = 1,
			[1] = 1,
		},
			blackvisionwhendead=false,
			mskmat = "",
			eff = {},
			slots = {
				eyes = 0
			}
		}
	}

	JMod.EFTArmorTable["T-7 Thermal Goggles"] = {
		PrintName = "[HGC] T-7 Thermal",
		mdl = "models/eft_props/gear/nvgs/nvg_spi_t7.mdl",
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		slots = {
			eyes = 1
		},
		bdg = {
			[0] = 1,
			[1] = 0,
			[2] = 1,
		},
		def = NonArmorProtectionProfile,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = 1,
		dur = 20,
		chrg = {
			power = 80
		},
		mskmat = "mask_overlays/thermal.png",
		eqsnd = "snds_jack_gmod/tinycapcharge.wav",
		ent = "ent_jack_gmod_ezarmor_t7thermal",
		eff = {
			thermalVision = true
		},
		blackvisionwhendead=true,
		tgl = {
			bdg = {
		[0] = 2,
		[1] = 1,
		[2] = 1,
		},
			blackvisionwhendead=false,
			mskmat = "",
			eff = {},
			slots = {
				eyes = 0
			}
		}
	}

	JMod.EFTArmorTable["Skull Lock"] = {
		PrintName = "[HW] Skull Lock",
		mdl = "models/eft_props/gear/nvgs/nvg_wilcox_skull_lock.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.5,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_slock",
	}

--[[
  _           _       
 | |         | |      
 | |__   __ _| |_ ___ 
 | '_ \ / _` | __/ __|
 | | | | (_| | |_\__ \
 |_| |_|\__,_|\__|___/
                      
]]--

	JMod.EFTArmorTable["Bomber"] = { --IDK IF I SHOULD PUT THIS IN HELMETS OR HATS 
		PrintName = "[HW-1] Bomber Beanie",
		mdl = "models/eft_props/gear/headwear/head_bomber.mdl",
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = Class1,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 600,
		ent = "ent_jack_gmod_ezarmor_bomber",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.5, 1, 0),

		}
	}

	JMod.EFTArmorTable["LLCS"] = {
		PrintName = "[HW] LLCS",
		mdl = "models/eft_props/gear/headwear/head_panama_jackpyke.mdl",
		snds = GenericSounds,
		slots = {
			head = 1,
			acc_head = 1,
			acc_ears = 1,
			acc_eyes = 1,
			eyes = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.18,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_jackpyke",
		tgl = {
			slots = {
				head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.1, 1, 0),

		}
	}

	JMod.EFTArmorTable["Chimera"] = {
		PrintName = "[HW] Chimera",
		mdl = "models/eft_props/gear/headwear/head_panama_stichprofi.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.15,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_chimera",
		tgl = {
			slots = {
				head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.1, 1, 0),

		}
	}

	JMod.EFTArmorTable["Cowboy"] = {
		PrintName = "[HW] Cowboy",
		mdl = "models/eft_props/gear/headwear/head_cowboy.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .2,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_cowboy",
		tgl = {
			slots = {
				head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.8, 0),

		}
	}

	JMod.EFTArmorTable["Ushanka"] = {
		PrintName = "[HW] Ushanka",
		mdl = "models/eft_props/gear/headwear/head_ushanka.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_ushanka",
		tgl = {
			slots = {
				head = 1
			},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Panama"] = {
		PrintName = "[HW] Panama",
		mdl = "models/eft_props/gear/headwear/head_panama.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_panama",
		tgl = {
			slots = {
				head = 1
			},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Door Kicker"] = {
		PrintName = "[HW] Door Kicker",
		mdl = "models/eft_props/gear/headwear/head_doorkicker.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_doorkicker",
		tgl = {
			slots = {
				head = 1
			},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Beanie"] = {
		PrintName = "[HW] Beanie",
		mdl = "models/eft_props/gear/headwear/head_knitcap.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_scavbeanie",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Kotton"] = {
		PrintName = "[HW] Kotton",
		mdl = "models/eft_props/gear/headwear/head_kotton.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .2,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_kotton",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Army Cap"] = {
		PrintName = "[HW] Army Cap",
		mdl = "models/eft_props/gear/headwear/head_military_hat.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_armycap",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Army Cap Black"] = {
		PrintName = "[HW] Army Cap (Black)",
		mdl = "models/eft_props/gear/headwear/head_military2_black.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_armycapblack",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Army Cap Brown"] = {
		PrintName = "[HW] Army Cap (Brown)",
		mdl = "models/eft_props/gear/headwear/head_military2_brown.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_armycapbrown",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Army Cap CADPAT"] = {
		PrintName = "[HW] Army Cap (CADPAT)",
		mdl = "models/eft_props/gear/headwear/head_military2_cadpat.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_armycapcadpat",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Army Cap Flora"] = {
		PrintName = "[HW] Army Cap (Flora)",
		mdl = "models/eft_props/gear/headwear/head_military2_flora.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_armycapflora",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Army Cap Sand"] = {
		PrintName = "[HW] Army Cap (Sand)",
		mdl = "models/eft_props/gear/headwear/head_military2_sand.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_armycapsand",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Army Cap UCP"] = {
		PrintName = "[HW] Army Cap (UCP)",
		mdl = "models/eft_props/gear/headwear/head_military_hat.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_armycapucp",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Baseball cap"] = {
		PrintName = "[HW] Baseball cap",
		mdl = "models/eft_props/gear/headwear/cap_scav.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_scavcap",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Santa hat"] = {
		PrintName = "[HW] Santa hat",
		mdl = "models/eft_props/gear/headwear/head_claus.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_santahat",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}	

	JMod.EFTArmorTable["Ded Moroz hat"] = {
		PrintName = "[HW] Ded Moroz",
		mdl = "models/eft_props/gear/headwear/head_dedmoroz.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_dedmorozhat",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Police"] = {
		PrintName = "[HW] Police",
		mdl = "models/eft_props/gear/headwear/cap_police.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_police",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Fleece"] = {
		PrintName = "[HW] Fleece",
		mdl = "models/eft_props/gear/headwear/head_fleece.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_fleece",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["UX PRO"] = {
		PrintName = "[HW] UX PRO",
		mdl = "models/eft_props/gear/headwear/head_uf_pro.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_uxpro",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["USEC cap black"] = {
		PrintName = "[HW] USEC cap (Black)",
		mdl = "models/eft_props/gear/headwear/cap_usec_black.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_useccapblack",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["USEC cap tan"] = {
		PrintName = "[HW] USEC cap (Tan)",
		mdl = "models/eft_props/gear/headwear/cap_usec_tan.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_useccaptan",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["BEAR cap black"] = {
		PrintName = "[HW] BEAR cap (Black)",
		mdl = "models/eft_props/gear/headwear/cap_bear_black.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_bearcapblack",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["BEAR cap green"] = {
		PrintName = "[HW] BEAR cap (Green)",
		mdl = "models/eft_props/gear/headwear/cap_bear_green.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_bearcapgreen",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["EMERCOM"] = {
		PrintName = "[HW] EMERCOM",
		mdl = "models/eft_props/gear/headwear/cap_mhs.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_emercom",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Pompon"] = {
		PrintName = "[HW] Pompon",
		mdl = "models/eft_props/gear/headwear/head_pompon.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_pompon",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Bandana"] = {
		PrintName = "[HW] Bandana",
		mdl = "models/eft_props/gear/headwear/head_bandana.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_bandana",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Ski Hat"] = {
		PrintName = "[HW] Ski Hat",
		mdl = "models/eft_props/gear/headwear/head_slots.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_skihat",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Beret Olive"] = {
		PrintName = "[HW] Beret (Olive)",
		mdl = "models/eft_props/gear/headwear/head_beret_od.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_beretolive",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Beret Blue"] = {
		PrintName = "[HW] Beret (Blue)",
		mdl = "models/eft_props/gear/headwear/head_beret_blue.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_beretblue",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),
		}
	}

	JMod.EFTArmorTable["Beret Black"] = {
		PrintName = "[HW] Beret (Black)",
		mdl = "models/eft_props/gear/headwear/head_beret_blk.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_beretblack",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Leather cap"] = {
		PrintName = "[HW] Leather cap",
		mdl = "models/eft_props/gear/headwear/head_leather_cap.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .15,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_leathercap",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Tagilla Cap"] = {
		PrintName = "[HW] BOSS Cap",
		mdl = "models/eft_props/gear/headwear/cap_boss_tagillacap.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_bosscap",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Big Pipe's Bandana"] = {
		PrintName = "[HW] Big Pipe's Bandana",
		mdl = "models/eft_props/gear/headwear/head_bandana_boxx_big_pipe.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_bossbandana",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Zryachiy Mask"] = {
		PrintName = "[HW] Zryachiy's Mask",
		mdl = "models/eft_props/gear/headwear/head_boss_zryachii_balaklava_copen.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_zryachiyhat",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Gus Baseball Cap"] = {
		PrintName = "[HW] Gus Baseball Cap",
		mdl = "models/eft_props/gear/headwear/cap_security_flagcap.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_gusbaseballcap",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

	JMod.EFTArmorTable["Basmach Leather Cap"] = {
		PrintName = "[HW] Basmach Leather Cap",
		mdl = "models/eft_props/gear/headwear/cap_security_leathercap.mdl", 
		snds = GenericSounds,
		slots = {
			head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_basmachleathercap",
		tgl = {
		slots = {
			head = 1
		},
			siz = size_head * Vector(1.05, 1.05, 1.05),
			pos = pos_head + Vector(-0.4, 0.4, 0),

		}
	}

--[[
   __                                       
  / _|                                      
 | |_ __ _  ___ ___  ___ _____   _____ _ __ 
 |  _/ _` |/ __/ _ \/ __/ _ \ \ / / _ \ '__|
 | || (_| | (_|  __/ (_| (_) \ V /  __/ |   
 |_| \__,_|\___\___|\___\___/ \_/ \___|_|   
                                            
]]--

	JMod.EFTArmorTable["Glorious"] = {
		PrintName = "[FW-1] Glorious",
		mdl = "models/eft_props/gear/facecover/facecover_glorious.mdl", 
		snds = HelmetSounds,
		slots = {
			acc_head = 1,
			head = 1,
			acc_eyes = 1,
			eyes = 1,
			mouthnose = 1,
		},
		def = Class1,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.28,
		dur = durmult * 160,
		ent = "ent_jack_gmod_ezarmor_glorious"
	}

	JMod.EFTArmorTable["Shattered"] = {
		PrintName = "[FW-1] Shattered",
		mdl = "models/eft_props/gear/facecover/facecover_shatteredmask.mdl", 
		snds = HelmetSounds,
		slots = {
			acc_ears = 1,
			eyes = 1,
			mouthnose = 1,
		},
		def = Class1,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.3,
		dur = durmult * 160,
		ent = "ent_jack_gmod_ezarmor_shattered"
	}

	JMod.EFTArmorTable["Death Knight"] = {
		PrintName = "[FW-1] Death Knight",
		mdl = "models/eft_props/gear/facecover/facecover_boss_black_knight.mdl", 
		snds = HelmetSounds,
		slots = {
			head = 1,
			eyes = 1,
		},
		bdg = {
			[0] = 1
		},
		tgl = {
			bdg = {
				[0] = 0
			},
			slots = {
				head = 1,
				eyes = 1,
			},
		},
		def = Class1,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.78,
		dur = durmult * 220,
		ent = "ent_jack_gmod_ezarmor_deathknight"
	}

	JMod.EFTArmorTable["Death Shadow"] = {
		PrintName = "[FW-2] Death Shadow",
		mdl = "models/eft_props/gear/facecover/facecover_strikeball_mask.mdl", 
		snds = HelmetSounds,
		slots = {
			eyes = 1,
			mouthnose = 1,
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.25,
		dur = durmult * 89,
		ent = "ent_jack_gmod_ezarmor_airsoftmask"
	}

	JMod.EFTArmorTable["CQCM"] = {
		PrintName = "[FW-4] Atomic Defense CQCM",
		mdl = "models/eft_props/gear/facecover/facecover_ballistic_mask.mdl", 
		snds = HelmetSounds,
		slots = {
			head = 0,
			eyes = 1,
			mouthnose = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 2.1,
		dur = durmult * 103,
		ent = "ent_jack_gmod_ezarmor_ballisticmask"
	}

	JMod.EFTArmorTable["UBEY"] = {
		PrintName = "[FW-5] Welding Mask",
		mdl = "models/eft_props/gear/facecover/facecover_boss_welding_ubey.mdl", 
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
			eyes = 1,
			mouthnose = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.5,
		dur = durmult * 57,
		mskmat = "mask_overlays/altyn.png",
		ent = "ent_jack_gmod_ezarmor_weldingkill"
	}

	JMod.EFTArmorTable["GORILLA"] = {
		PrintName = "[FW-5] Welding Mask",
		mdl = "models/eft_props/gear/facecover/facecover_boss_welding_gorilla.mdl", 
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
			eyes = 1,
			mouthnose = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.5,
		dur = durmult * 57,
		mskmat = "mask_overlays/altyn.png",
		ent = "ent_jack_gmod_ezarmor_weldinggorilla"
	}

	JMod.EFTArmorTable["Hockey Captain"] = {
		PrintName = "[FW] Hockey Captain",
		mdl = "models/eft_props/gear/facecover/facecover_hockey_01.mdl", 
		snds = HelmetSounds,
		slots = {
			head = 1,
			eyes = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_hockeycaptain"
	}

	JMod.EFTArmorTable["Hockey Brawler"] = {
		PrintName = "[FW] Hockey Brawler",
		mdl = "models/eft_props/gear/facecover/facecover_hockey_02.mdl", 
		snds = HelmetSounds,
		slots = {
			head = 1,
			eyes = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_hockeybrawler"
	}

	JMod.EFTArmorTable["Hockey Quiet"] = {
		PrintName = "[FW] Hockey Quiet",
		mdl = "models/eft_props/gear/facecover/facecover_hockey_03.mdl", 
		snds = HelmetSounds,
		slots = {
			head = 1,
			eyes = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_hockeyquiet"
	}

	JMod.EFTArmorTable["GP-5"] = {
		PrintName = "[FW] GP-5",
		mdl = "models/eft_props/gear/facecover/facecover_gasmask_gp5.mdl", -- kf2
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		snds = GenericSounds,
		slots = {
			head = 1,
			eyes = 1,
			mouthnose = 1
		},
		def = table.Inherit({
			[DMG_NERVEGAS] = 1,
			[DMG_RADIATION] = .85
		}, NonArmorProtectionProfile),
		dur = durmult * 2,
		chrg = {
			chemicals = 25
		},
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .45,
		sndlop = "eft/bear2_breath_ok.wav",
		mskmat = "mask_overlays/mask_anvis.png",
		ent = "ent_jack_gmod_ezarmor_gp5"
	}

	JMod.EFTArmorTable["GP-7"] = {
		PrintName = "[FW] GP-7",
		mdl = "models/eft_props/gear/facecover/facecover_gasmask_gp7.mdl", -- kf2
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		snds = GenericSounds,
		slots = {
			eyes = 1,
			mouthnose = 1
		},
		def = table.Inherit({
			[DMG_NERVEGAS] = 1,
			[DMG_RADIATION] = .75
		}, NonArmorProtectionProfile),
		dur = durmult * 2,
		chrg = {
			chemicals = 25
		},
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .6,
		sndlop = "eft/bear2_breath_ok.wav",
		mskmat = "mask_overlays/mask_anvis.png",
		ent = "ent_jack_gmod_ezarmor_gp7"
	}


	JMod.EFTArmorTable["Deadly Skull"] = {
		PrintName = "[FW] Deadly Skull",
		mdl = "models/eft_props/gear/facecover/facecover_skullmask.mdl", 
		snds = HelmetSounds,
		slots = {
			acc_head = 1,
			eyes = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .2,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_deadlyskull"
	}

	JMod.EFTArmorTable["Respirator 3M"] = {
		PrintName = "[FW] Respirator",
		mdl = "models/eft_props/gear/facecover/facecover_respirator_3m.mdl",
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		snds = GenericSounds,
		slots = {
			mouthnose = 1
		},
		def = table.Inherit({
			[DMG_NERVEGAS] = .35,
			[DMG_RADIATION] = .75
		}, NonArmorProtectionProfile),
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		chrg = {
			chemicals = 10
		},
		wgt = wgtmult * .1,
		dur = durmult * 2,
		sndlop = "eft/bear2_breath_ok.wav",
		ent = "ent_jack_gmod_ezarmor_3m",
	}

	JMod.EFTArmorTable["SOTR"] = {
		PrintName = "[FW] Ops-Core SOTR",
		mdl = "models/eft_props/gear/facecover/facecover_ops_core_sotr_respirator.mdl",
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		snds = GenericSounds,
		slots = {
			mouthnose = 1
		},
		def = table.Inherit({
			[DMG_NERVEGAS] = .35,
			[DMG_RADIATION] = .75
		}, NonArmorProtectionProfile),
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		chrg = {
			chemicals = 10
		},
		wgt = wgtmult * .1,
		dur = durmult * 2,
		sndlop = "eft/bear2_breath_ok.wav",
		ent = "ent_jack_gmod_ezarmor_sotr",
	}

	JMod.EFTArmorTable["Pestily"] = {
		PrintName = "[FW] Pestily",
		mdl = "models/eft_props/gear/facecover/facecover_pestily.mdl", 
		snds = HelmetSounds,
		slots = {
			acc_head = 1,
			eyes = 1,
			mouthnose = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .18,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_pestily"
	}

	JMod.EFTArmorTable["Spooky Skull Mask"] = {
		PrintName = "[FW] Spooky Skull",
		mdl = "models/eft_props/gear/facecover/facecover_halloween_skull.mdl", 
		snds = HelmetSounds,
		slots = {
			acc_head = 1,
			eyes = 1,
			mouthnose = 1,
		},
		bdg = {
			[0] = 1
		},
		tgl = {
			bdg = {
				[0] = 0
			},
			slots = {
				acc_head = 1,
				eyes = 1,
				mouthnose = 1,
			},
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .2,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_spookyskull"
	}

	JMod.EFTArmorTable["Slender"] = {
		PrintName = "[FW] Slender",
		mdl = "models/eft_props/gear/facecover/facecover_halloween_slander.mdl", 
		snds = HelmetSounds,
		slots = {
			acc_head = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_slender"
	}

	JMod.EFTArmorTable["Misha Mayorov"] = {
		PrintName = "[FW] Misha Mayorov",
		mdl = "models/eft_props/gear/facecover/facecover_halloween_micheal.mdl", 
		snds = HelmetSounds,
		slots = {
			head = 1,
			acc_head = 1,
			eyes = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_misha"
	}

	JMod.EFTArmorTable["Ghoul"] = {
		PrintName = "[FW] Ghoul",
		mdl = "models/eft_props/gear/facecover/facecover_halloween_vampire.mdl", 
		snds = HelmetSounds,
		slots = {
			head = 1,
			eyes = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .15,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_ghoul"
	}

	JMod.EFTArmorTable["Faceless"] = {
		PrintName = "[FW] Faceless",
		mdl = "models/eft_props/gear/facecover/facecover_halloween_kaonasi.mdl", 
		snds = HelmetSounds,
		slots = {
			head = 1,
			acc_head = 1,
			eyes = 1,
		},
		bdg = {
			[0] = 1
		},
		tgl = {
			bdg = {
				[0] = 0
			},
			slots = {
				head = 1,
				acc_head = 1,
				eyes = 1,
			},
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .2,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_faceless"
	}

	JMod.EFTArmorTable["Jason"] = {
		PrintName = "[FW] Jason",
		mdl = "models/eft_props/gear/facecover/facecover_halloween_jason.mdl", 
		snds = HelmetSounds,
		slots = {
			acc_head = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_jason"
	}

	JMod.EFTArmorTable["Balaclava"] = {
		PrintName = "[FW] Balaclava",
		mdl = "models/eft_props/gear/facecover/facecover_scavbalaclava.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			acc_head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_balaclava"
	}

	JMod.EFTArmorTable["Balaclava (Black)"] = {
		PrintName = "[FW] Balaclava (B)",
		mdl = "models/eft_props/gear/facecover/facecover_scavbalaclava_black.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			acc_head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_balaclavablack"
	}

	JMod.EFTArmorTable["Cold Fear"] = {
		PrintName = "[FW] Cold Fear",
		mdl = "models/eft_props/gear/facecover/facecover_coldgear.mdl", 
		snds = GenericSounds,
		slots = {
			acc_head = 1,
		},
		bdg = {
			[0] = 1
		},
		tgl = {
			bdg = {
				[0] = 0
			},
			slots = {
				acc_head = 1,
			},
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head + Vector(0.1,0.1,0),
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_coldfear"
	}

	JMod.EFTArmorTable["Ghost Balaclava"] = {
		PrintName = "[FW] Ghost Balaclava",
		mdl = "models/eft_props/gear/facecover/facecover_mask_skull.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			acc_head = 1,
		},
		bdg = {
			[0] = 1
		},
		tgl = {
			bdg = {
				[0] = 0
			},
			slots = {
				acc_head = 1,
			},
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_ghostbalacvlava"
	}

	JMod.EFTArmorTable["Ghost Half-Mask"] = {
		PrintName = "[FW] Ghost Half-Mask",
		mdl = "models/eft_props/gear/facecover/facecover_skull_half_mask.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			acc_head = 1,
		},
		bdg = {
			[0] = 1
		},
		tgl = {
			bdg = {
				[0] = 0
			},
			slots = {
				acc_head = 1,
			},
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_ghosthalfmask"
	}

	JMod.EFTArmorTable["Nomex Balaclava"] = {
		PrintName = "[FW] Nomex Balaclava",
		mdl = "models/eft_props/gear/facecover/facecover_nomex.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			acc_head = 1,
		},
		bdg = {
			[0] = 1
		},
		tgl = {
			bdg = {
				[0] = 0
			},
			slots = {
				acc_head = 1,
			},
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_nomexbalacvlava"
	}

	JMod.EFTArmorTable["Smoke Balaclava"] = {
		PrintName = "[FW] Smoke Balaclava",
		mdl = "models/eft_props/gear/facecover/facecover_smoke.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			acc_head = 1,
		},
		bdg = {
			[0] = 1
		},
		tgl = {
			bdg = {
				[0] = 0
			},
			slots = {
				acc_head = 1,
			},
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_smokebalacvlava"
	}

	JMod.EFTArmorTable["Shemagh (Green)"] = {
		PrintName = "[FW] Shemagh (Green)",
		mdl = "models/eft_props/gear/facecover/facecover_arafat.mdl", 
		snds = GenericSounds,
		slots = {
			acc_head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_shemaghgreen"
	}

	JMod.EFTArmorTable["Shemagh (Tan)"] = {
		PrintName = "[FW] Shemagh (Tan)",
		mdl = "models/eft_props/gear/facecover/facecover_shemagh.mdl", 
		snds = GenericSounds,
		slots = {
			acc_head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_shemaghtan",
	}

	JMod.EFTArmorTable["Lower Half-Mask"] = {
		PrintName = "[FW] Lower Half-Mask",
		mdl = "models/eft_props/gear/facecover/facecover_mask.mdl",
		snds = GenericSounds,
		slots = {
			acc_head = 1
		},
		bdg = {
			[0] = 1
		},
		tgl = {
			bdg = {
				[0] = 0
			},
			slots = {
				acc_head = 1
			},
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_halfmask"
	}

	JMod.EFTArmorTable["Neoprene Mask"] = {
		PrintName = "[FW] Neoprene Mask",
		mdl = "models/eft_props/gear/facecover/facecover_redflame.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			acc_head = 1
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_neoprenemask"
	}

	JMod.EFTArmorTable["Mustache"] = {
		PrintName = "[FW] Mustache",
		mdl = "models/eft_props/gear/facecover/facecover_mustache.mdl",
		snds = HelmetSounds,
		slots = {
			acc_head = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head - Vector(0,0.4,0),
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_mustache"
	}

	JMod.EFTArmorTable["Santa"] = {
		PrintName = "[FW] B. Santa",
		mdl = "models/eft_props/gear/facecover/facecover_beard_santa.mdl",
		snds = HelmetSounds,
		slots = {
			acc_head = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head * 0.9,
		pos = pos_head - Vector(-0.45,0.6,0),
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_santa"
	}

	JMod.EFTArmorTable["Baddie"] = {
		PrintName = "[FW] B. Baddie",
		mdl = "models/eft_props/gear/facecover/facecover_beard_red.mdl",
		snds = HelmetSounds,
		slots = {
			acc_head = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head * 0.9,
		pos = pos_head - Vector(-0.45,0.6,0),
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_baddie"
	}

	JMod.EFTArmorTable["Pipe"] = {
		PrintName = "[FW] Pipe",
		mdl = "models/eft_props/gear/facecover/facecover_pipe.mdl",
		snds = HelmetSounds,
		slots = {
			acc_head = 1,
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head - Vector(0,0.6,0),
		ang = ang_head,
		wgt = wgtmult * .1,
		dur = durmult * 222,
		ent = "ent_jack_gmod_ezarmor_pipe"
	}

	JMod.EFTArmorTable["Zryachiy's Balaclava"] = {
		PrintName = "[FW] Zryachiy's Balaclava",
		mdl = "models/eft_props/gear/facecover/facecover_zryachii_closed.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			acc_head = 1,
		},
		bdg = {
			[0] = 1
		},
		tgl = {
			bdg = {
				[0] = 0
			},
			slots = {
				acc_head = 1,
			},
		},
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.1,
		dur = durmult * 9999,
		ent = "ent_jack_gmod_ezarmor_zryachiibalacvlava"
	}

--[[
  _          _                _       
 | |        | |              | |      
 | |__   ___| |_ __ ___   ___| |_ ___ 
 | '_ \ / _ \ | '_ ` _ \ / _ \ __/ __|
 | | | |  __/ | | | | | |  __/ |_\__ \
 |_| |_|\___|_|_| |_| |_|\___|\__|___/
                                      
 ]]--

 	JMod.EFTArmorTable["Tac-Kek FAST MT"] = {
		PrintName = "[HLM-1] Tac-Kek FAST MT",
		mdl = "models/eft_props/gear/helmets/helmet_hops_core_fast.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class1,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .45,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_tackekfastmt"
	}

	JMod.EFTArmorTable["TSh-4M-L"] = {
		PrintName = "[HLM-1] TSh-4M-L",
		mdl = "models/eft_props/gear/helmets/helmet_tsh_4m2.mdl",
		snds = GenericSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
		def = Class1,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .9,
		dur = durmult * 400,
		ent = "ent_jack_gmod_ezarmor_shlemofon",
		chrg = {
			power = 60
		},
		eff = {
			teamComms = true,
			earPro = true
		},
		tgl = {
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
			eff = {},
		},
	}

	JMod.EFTArmorTable["Kolpak-1S"] = {
		PrintName = "[HLM-2] Kolpak-1S",
		mdl = "models/eft_props/gear/helmets/helmet_k1c.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.9,
		dur = durmult * 100,
		ent = "ent_jack_gmod_ezarmor_kolpak1s"
	}

	JMod.EFTArmorTable["SHPM Firefighter Helmet"] = {
		PrintName = "[HLM-2] SHPM Firefighter",
		mdl = "models/eft_props/gear/helmets/helmet_shpm.mdl",
		snds = HelmetSounds,
		mskmat = "mask_overlays/dirty_glass",
		bdg = {
			[0] = 0,
			[1] = 0
		},
		slots = {
			head = .9,
			ears = .8,
			acc_ears = .8,
			eyes = .1,
			mouthnose = .1,
		},
		tgl = {
			mskmat = "",
			slots = {
				head = .9,
				ears = .8,
				acc_ears = .8,
				eyes = 0,
				mouthnose = 0
			},
			bdg = {
			[0] = 0,
			[1] = 1
			}
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.5,
		dur = durmult * 160,
		ent = "ent_jack_gmod_ezarmor_shpmhelm"
	}

	JMod.EFTArmorTable["PSh-97 DJETA"] = {
		PrintName = "[HLM-2] PSh-97 DJETA",
		mdl = "models/eft_props/gear/helmets/helmet_psh97_jeta.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			eyes = .2,
			acc_ears = 1,
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.3,
		dur = durmult * 260,
		mskmat = "mask_overlays/dirty_glass",
		ent = "ent_jack_gmod_ezarmor_djeta",
		bdg = {
		[1] = 0
		},
		tgl = {
		slots = {
				head = 1,
				ears = 1,
				eyes = 0,
				acc_ears = 1,
			},
		bdg = {
			[1] = 1
		},
		mskmat = "",
		}
	}

	JMod.EFTArmorTable["LShZ"] = {
		PrintName = "[HLM-3] LShZ L. Helm",
		mdl = "models/eft_props/gear/helmets/helmet_lshz.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.95,
		dur = durmult * 120,
		ent = "ent_jack_gmod_ezarmor_lshz"
	}

	JMod.EFTArmorTable["SSh-68"] = {
		PrintName = "[HLM-3] SSh-68 Steel Helmet",
		mdl = "models/eft_props/gear/helmets/helmet_s_sh_68.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.5,
		dur = durmult * 43,
		ent = "ent_jack_gmod_ezarmor_ssh68"
	}

	JMod.EFTArmorTable["Galvion Caiman"] = {
		PrintName = "[HLM-3] Caiman",
		mdl = "models/eft_props/gear/helmets/helmet_galvion_caiman.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.12,
		dur = durmult * 100,
		ent = "ent_jack_gmod_ezarmor_caiman"
	}

	JMod.EFTArmorTable["Galvion Caiman Applique"] = {
		PrintName = "[HLM-4] Caiman + Applique",
		mdl = "models/eft_props/gear/helmets/helmet_galvion_applique.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.8,
		dur = durmult * 129,
		ent = "ent_jack_gmod_ezarmor_caimanapplique"
	}

	JMod.EFTArmorTable["NeoSteel"] = {
		PrintName = "[HLM-3] NeoSteel",
		mdl = "models/eft_props/gear/helmets/helmet_neosteel.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 192,
		ent = "ent_jack_gmod_ezarmor_neosteel"
	}

	JMod.EFTArmorTable["HJELM"] = {
		PrintName = "[HLM-3] HJELM",
		mdl = "models/eft_props/gear/helmets/helmet_nfm_hjelm.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .8,
		dur = durmult * 130,
		ent = "ent_jack_gmod_ezarmor_hjelm"
	}

	JMod.EFTArmorTable["Untar Helmet"] = {
		PrintName = "[HLM-3] Untar Helmet",
		mdl = "models/eft_props/gear/helmets/helmet_un.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 2.2,
		dur = durmult * 100,
		ent = "ent_jack_gmod_ezarmor_untarhelm"
	}

	JMod.EFTArmorTable["6B47"] = {
		PrintName = "[HLM-3] 6B47",
		mdl = "models/eft_props/gear/helmets/helmet_6b47.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.3,
		dur = durmult * 100,
		ent = "ent_jack_gmod_ezarmor_6b47"
	}

	JMod.EFTArmorTable["6B47 Cover"] = {
		PrintName = "[HLM-3] 6B47 (Cover)",
		mdl = "models/eft_props/gear/helmets/helmet_6b47_cover.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.3,
		dur = durmult * 100,
		ent = "ent_jack_gmod_ezarmor_6b47chehol"
	}

	JMod.EFTArmorTable["KiverM"] = {
		PrintName = "[HLM-3] Kiver-M",
		mdl = "models/eft_props/gear/helmets/helmet_kiverm.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 78,
		ent = "ent_jack_gmod_ezarmor_kiverm"
	}

	JMod.EFTArmorTable["Tor2"] = {
		PrintName = "[HLM-3] Tor-2",
		mdl = "models/eft_props/gear/helmets/helmet_tor_2.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 2.4,
		dur = durmult * 216,
		ent = "ent_jack_gmod_ezarmor_tor2"
	}

	JMod.EFTArmorTable["SFERA-S"] = {
		PrintName = "[HLM-3] SFERA-S",
		mdl = "models/eft_props/gear/helmets/helmet_sphera_c.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 3.5,
		dur = durmult * 143,
		ent = "ent_jack_gmod_ezarmor_sferas"
	}

	JMod.EFTArmorTable["DevTac Ronin"] = {
		PrintName = "[HLM-3] DevTac Ronin",
		mdl = "models/eft_props/gear/helmets/helmet_devtac.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
			eyes = 1,
			mouthnose = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.6,
		dur = durmult * 240,
		mskmat = "mask_overlays/mask_anvis.png",
		ent = "ent_jack_gmod_ezarmor_devtacronin"
	}

	JMod.EFTArmorTable["MSA ACH TC-2001"] = {
		PrintName = "[HLM-4] TC-2001",
		mdl = "models/eft_props/gear/helmets/helmet_mich2001.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.4,
		dur = durmult * 50,
		ent = "ent_jack_gmod_ezarmor_mich2001"
	}

	JMod.EFTArmorTable["MSA ACH TC-2002"] = {
		PrintName = "[HLM-4] TC-2002",
		mdl = "models/eft_props/gear/helmets/helmet_mich2002.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.45,
		dur = durmult * 54,
		ent = "ent_jack_gmod_ezarmor_mich2002"
	}

	JMod.EFTArmorTable["ACHHC Black"] = {
		PrintName = "[HLM-4] ACHHC Black",
		mdl = "models/eft_props/gear/helmets/helmet_achhc_b.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 60,
		ent = "ent_jack_gmod_ezarmor_achhcblack"
	}

	JMod.EFTArmorTable["ACHHC Olive"] = {
		PrintName = "[HLM-4] ACHHC Olive",
		mdl = "models/eft_props/gear/helmets/helmet_achhc_g.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 120,
		ent = "ent_jack_gmod_ezarmor_achhcolive"
	}

	JMod.EFTArmorTable["TC 800"] = {
		PrintName = "[HLM-4] Gallet TC 800",
		mdl = "models/eft_props/gear/helmets/helmet_msa_gallet.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.17,
		dur = durmult * 60,
		ent = "ent_jack_gmod_ezarmor_tc800"
	}

	JMod.EFTArmorTable["Bastion"] = {
		PrintName = "[HLM-4] Bastion",
		mdl = "models/eft_props/gear/helmets/helmet_diamond_age_bastion.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.96,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_bastion"
	}

	JMod.EFTArmorTable["Bastion Shield"] = {
		PrintName = "[HLM-6] Bastion + Plate",
		mdl = "models/eft_props/gear/helmets/helmet_diamond_age_bastion_shield.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.95,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_bastionshield"
	}

	JMod.EFTArmorTable["Fast MT Black"] = {
		PrintName = "[HLM-4] FAST MT Black",
		mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_black.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.9,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_fastmtblack"
	}

	JMod.EFTArmorTable["Fast MT Black SLAAP"] = {
		PrintName = "[HLM-5] FAST MT Black SLAAP",
		mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_black_slaap.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 2.4,
		dur = durmult * 67,
		ent = "ent_jack_gmod_ezarmor_fastmtblackslaap"
	}

	JMod.EFTArmorTable["Fast MT Tan"] = {
		PrintName = "[HLM-4] FAST MT Tan",
		mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_tan.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.9,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_fastmttan"
	}

	JMod.EFTArmorTable["Fast MT Tan SLAAP"] = {
		PrintName = "[HLM-5] FAST MT Tan SLAAP",
		mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_tan_slaap.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 2.4,
		dur = durmult * 67,
		ent = "ent_jack_gmod_ezarmor_fastmttanslaap"
	}

	JMod.EFTArmorTable["Crye AirFrame"] = {
		PrintName = "[HLM-4] Crye AirFrame",
		mdl = "models/eft_props/gear/helmets/helmet_crye_airframe.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.88,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_cryeairframe"
	}

	JMod.EFTArmorTable["TW EXFIL B"] = {
		PrintName = "[HLM-4] TW EXFIL",
		mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_black.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.18,
		dur = durmult * 90,
		ent = "ent_jack_gmod_ezarmor_twexfilb"
	}

	JMod.EFTArmorTable["TW EXFIL C"] = {
		PrintName = "[HLM-4] TW EXFIL",
		mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_coyote.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.18,
		dur = durmult * 90,
		ent = "ent_jack_gmod_ezarmor_twexfilc"
	}

	JMod.EFTArmorTable["ZSH-1-2M"] = {
		PrintName = "[HLM-4] ZSH-1-2M",
		mdl = "models/eft_props/gear/helmets/helmet_zsh_1_2m_v1.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 3.7,
		dur = durmult * 70,
		ent = "ent_jack_gmod_ezarmor_zshhelm"
	}

	JMod.EFTArmorTable["ZSH-1-2M v2"] = {
		PrintName = "[HLM-4] ZSH-1-2M v2",
		mdl = "models/eft_props/gear/helmets/helmet_zsh_1_2m_v2.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 3.7,
		dur = durmult * 70,
		ent = "ent_jack_gmod_ezarmor_zshhelmv2"
	}

	JMod.EFTArmorTable["ULACH B"] = {
		PrintName = "[HLM-4] ULACH B",
		mdl = "models/eft_props/gear/helmets/helmet_ulach_b.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.9,
		dur = durmult * 84,
		ent = "ent_jack_gmod_ezarmor_ulach"
	}

	JMod.EFTArmorTable["ULACH C"] = {
		PrintName = "[HLM-4] ULACH C",
		mdl = "models/eft_props/gear/helmets/helmet_ulach_c.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.9,
		dur = durmult * 84,
		ent = "ent_jack_gmod_ezarmor_ulachcoyote"
	}


	JMod.EFTArmorTable["LShZ-2DTM"] = {
		PrintName = "[HLM-4] LShZ-2DTM",
		mdl = "models/eft_props/gear/helmets/helmet_lshz2dtm.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 3.4,
		dur = durmult * 110,
		ent = "ent_jack_gmod_ezarmor_lshz2dtm"
	}

	JMod.EFTArmorTable["LShZ-2DTM Cover"] = {
		PrintName = "[HLM-4] LShZ-2DTM (w/Cover)",
		mdl = "models/eft_props/gear/helmets/helmet_lshz2dtm_damper.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 3.5,
		dur = durmult * 110,
		ent = "ent_jack_gmod_ezarmor_lshz2dtmcovered"
	}

	JMod.EFTArmorTable["Shlem Maska 1SH"] = {
		PrintName = "[HLM-4] ShMaska",
		mdl = "models/eft_props/gear/helmets/helmet_maska_1sh.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 2.6,
		dur = durmult * 86,
		ent = "ent_jack_gmod_ezarmor_maska1sh",
	}

	JMod.EFTArmorTable["Shlem Maska 1SH (Killa)"] = {
		PrintName = "[HLM-4] ShMaska (K)",
		mdl = "models/eft_props/gear/helmets/helmet_maska_1sh_killa.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 2.6,
		dur = durmult * 86,
		ent = "ent_jack_gmod_ezarmor_maska1shkilla",
	}

	JMod.EFTArmorTable["Altyn"] = {
		PrintName = "[HLM-5] Altyn",
		mdl = "models/eft_props/gear/helmets/helmet_altyn.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 4.0,
		dur = durmult * 64,
		ent = "ent_jack_gmod_ezarmor_altyn"
	}

	JMod.EFTArmorTable["Rys-T"] = {
		PrintName = "[HLM-5] Rys-T",
		mdl = "models/eft_props/gear/helmets/helmet_rys_t.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1,
			ears = 1,
			acc_ears = 1,
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 4.5,
		dur = durmult * 64,
		ent = "ent_jack_gmod_ezarmor_ryst"
	}

	JMod.EFTArmorTable["Vulkan-5"] = {
		PrintName = "[HLM-6] Vulkan-5",
		mdl = "models/eft_props/gear/helmets/helmet_vulkan_5.mdl",
		snds = HelmetSounds,
		slots = {
			head = 1
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 4.5,
		dur = durmult * 110,
		ent = "ent_jack_gmod_ezarmor_vulkan5"
	}

--[[
                     _                    
                    (_)                   
   __ _  ___  __   ___ ___  ___  _ __ ___ 
  / _` |/ __| \ \ / / / __|/ _ \| '__/ __|
 | (_| | (__   \ V /| \__ \ (_) | |  \__ \
  \__, |\___|   \_/ |_|___/\___/|_|  |___/
   __/ |                                  
  |___/                                   

]]--

	JMod.EFTArmorTable["FAST Visor"] = {
		PrintName = "[HGC-2] FAST MT Visor",
		mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_visor.mdl",
		snds = FShieldSounds,
		slots = {
			eyes = 1,
		},

		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		mskmat = "mask_overlays/dirty_glass",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * .32,
		dur = durmult * 25,
		ent = "ent_jack_gmod_ezarmor_fastmtvisor",
		bdg = {
			[0] = 0,
			[1] = 1
		},
		tgl = {
			slots = {
				eyes= 0,
			},
			bdg = {
				[0] = 1,
				[1] = 1
			},
			mskmat = ""
		}

	}

	JMod.EFTArmorTable["Caiman FA Visor"] = {
		PrintName = "[HGC-2] Caiman FA Visor",
		mdl = "models/eft_props/gear/helmets/helmet_galvioned_arm_visor.mdl",
		snds = FShieldSounds,
		slots = {
			eyes = 1,
		},

		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		mskmat = "mask_overlays/dirty_glass",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.27,
		dur = durmult * 38,
		ent = "ent_jack_gmod_ezarmor_caimanvisor",

	}

	JMod.EFTArmorTable["Kolpak-1S Visor"] = {
		PrintName = "[HGC-2] Kolpak-1S Visor",
		mdl = "models/eft_props/gear/helmets/helmet_k1c_shield.mdl",
		snds = FShieldSounds,
		slots = {
			eyes = 1,
			mouthnose = 1
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.0,
		dur = durmult * 38,
		bdg = {
		[0] = 0
		},
		mskmat = "mask_overlays/dirty_glass",
		ent = "ent_jack_gmod_ezarmor_koplak1svisor",
		tgl = {
			bdg = {
			[0] = 1
			},
			mskmat = "",
			slots = {
				eyes = 0,
				mouthnose = 0
			}
		}
	}

	JMod.EFTArmorTable["Tac-Kek Heavy Trooper"] = {
		PrintName = "[HGC-2] Tac-Kek Heavy Trooper",
		mdl = "models/eft_props/gear/helmets/helmet_galactac_heavy_gunner.mdl", -- tarkov
		snds = HelmetSounds,
		slots = {
			eyes = 1,
			mouthnose = 1,
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.4,
		dur = durmult * 180,
		ent = "ent_jack_gmod_ezarmor_tackekhtrooper"
	}

	JMod.EFTArmorTable["Tor-2 Shield"] = {
		PrintName = "[HGC-3] Tor-2 FaceShield",
		mdl = "models/eft_props/gear/helmets/helmet_tor_2_faceshield.mdl", -- tarkov
		snds = FShieldSounds,
		slots = {
			eyes = 1,
			mouthnose = 1,
		},

		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		mskmat = "mask_overlays/dirty_glass",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.15,
		dur = durmult * 50,
		ent = "ent_jack_gmod_ezarmor_tor2shield",
		bdg = {
			[0] = 1,
			[1] = 0
		},
		tgl = {
			slots = {
				eyes=0,
				mouthnose = 0,
			},
			bdg = {
				[0] = 1,
				[1] = 1
			},
			mskmat = ""
		}

	}

	JMod.EFTArmorTable["Fast MT Shield"] = {
		PrintName = "[HGC-3] FAST MT Face Shield",
		mdl = "models/eft_props/gear/helmets/helmet_ops_core_handgun_face_shield.mdl", -- tarkov
		snds = FShieldSounds,
		slots = {
			eyes = 1,
			mouthnose = 1,
		},

		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		mskmat = "mask_overlays/dirty_glass",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 50,
		ent = "ent_jack_gmod_ezarmor_fastmtshield",
		bdg = {
			[0] = 0,
			[1] = 1
		},
		tgl = {
			slots = {
				eyes=0,
				mouthnose = 0,
			},
			bdg = {
				[0] = 1,
				[1] = 1
			},
			mskmat = ""
		}

	}

	JMod.EFTArmorTable["Kiver Shield"] = {
		PrintName = "[HGC-3] Kiver-M FShield",
		mdl = "models/eft_props/gear/helmets/helmet_kiverm_shield.mdl", -- tarkov
		snds = FShieldSounds,
		slots = {
			eyes = 1,
			mouthnose = 1,
		},

		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		mskmat = "mask_overlays/dirty_glass",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 50,
		ent = "ent_jack_gmod_ezarmor_kivermshield",
		bdg = {
			[0] = 0,
			[1] = 1
		},
		tgl = {
			slots = {
				eyes= 0,
				mouthnose= 0
			},
			bdg = {
				[0] = 1,
				[1] = 1
			},
			mskmat = ""
		}

	}

	JMod.EFTArmorTable["TW EXFIL Shield B"] = {
		PrintName = "[HGC-3] TW EXFIL FS",
		mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_face_shield_black.mdl", -- tarkov
		snds = FShieldSounds,
		slots = {
			eyes = 1,
			mouthnose = 1,
		},

		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		mskmat = "mask_overlays/dirty_glass",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.8,
		dur = durmult * 56,
		ent = "ent_jack_gmod_ezarmor_twexfilshieldb",
		bdg = {
			[0] = 0,
			[1] = 1
		},
		tgl = {
			slots = {
				eyes = 0,
				mouthnose = 0,
			},
			bdg = {
				[0] = 1,
				[1] = 1
			},
			mskmat = ""
		}

	}

	JMod.EFTArmorTable["TW EXFIL Shield C"] = {
		PrintName = "[HGC-3] TW EXFIL FS",
		mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_face_shield_coyo.mdl", -- tarkov
		snds = FShieldSounds,
		slots = {
			eyes = 1,
			mouthnose = 1,
		},

		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		mskmat = "mask_overlays/dirty_glass",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.8,
		dur = durmult * 56,
		ent = "ent_jack_gmod_ezarmor_twexfilshieldc",
		bdg = {
			[0] = 0,
			[1] = 1
		},
		tgl = {
			slots = {
				eyes = 0,
				mouthnose = 0,
			},
			bdg = {
				[0] = 1,
				[1] = 1
			},
			mskmat = ""
		}

	}

	JMod.EFTArmorTable["ZSH-1-2M Face Shield"] = {
		PrintName = "[HGC-3] ZSH-1-2M FShield",
		mdl = "models/eft_props/gear/helmets/helmet_zsh_1_2m_face_shield.mdl",
		snds = FShieldSounds,
		slots = {
			eyes = .85,
			mouthnose = .85
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		bdg = {
			[0] = 0
		},
		wgt = wgtmult * 1.0,
		dur = durmult * 63,
		mskmat = "mask_overlays/dirty_glass",
		ent = "ent_jack_gmod_ezarmor_zshface",
		tgl = {
			bdg = {
				[0] = 1
			},
			mskmat = "",
			slots = {
				eyes = 0,
				mouthnose = 0
			}
		}
	}
	

	JMod.EFTArmorTable["LShZ-2DTM Shield"] = {
		PrintName = "[HGC-4] LShZ-2DTM FShield",
		mdl = "models/eft_props/gear/helmets/helmet_lshz2dtm_shield.mdl", -- tarkov
		snds = FShieldSounds,
		slots = {
			eyes = 1,
			mouthnose = 1,
		},

		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		mskmat = "mask_overlays/dirty_glass",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.0,
		dur = durmult * 63,
		ent = "ent_jack_gmod_ezarmor_lshz2dtmshield",
		bdg = {
			[0] = 0
		},
		tgl = {
			slots = {
				eyes = 0,
				mouthnose = 0,
			},
			bdg = {
				[0] = 1
			},
			mskmat = ""
		}
	}

	JMod.EFTArmorTable["Vulkan-5 Shield"] = {
		PrintName = "[HGC-4] Vulkan-5 Shield",
		mdl = "models/eft_props/gear/helmets/helmet_vulkan_shield.mdl", -- tarkov
		snds = FShieldSounds,
		slots = {
			eyes = 1,
			mouthnose = 1,
		},

		def = Class4,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		mskmat = "mask_overlays/dirty_glass",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.8,
		dur = durmult * 106,
		ent = "ent_jack_gmod_ezarmor_vulkan5shield",
		bdg = {
			[0] = 0,
			[1] = 1
		},
		tgl = {
			slots = {
				eyes = 0,
				mouthnose = 0,
			},
			bdg = {
				[0] = 1,
				[1] = 1
			},
			mskmat = ""
		}
	}

	JMod.EFTArmorTable["Altyn Face Shield"] = {
		PrintName = "[HGC-5] Altyn Face Shield",
		mdl = "models/eft_props/gear/helmets/helmet_altyn_face_shield.mdl",
		snds = GenericSounds,
		slots = {
			eyes = 1,
			mouthnose = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		bdg = {
			[0] = 0
		},
		tgl = {
			mskmat = "",
			bdg = {
				[0] = 1
			},
			slots = {
				eyes = 0,
				mouthnose = 0
			}
		},
		wgt = wgtmult * 1.4,
		dur = durmult * 100,
		mskmat = "mask_overlays/altyn.png",
		ent = "ent_jack_gmod_ezarmor_altynface",

	}

	JMod.EFTArmorTable["Rys-T Face Shield"] = {
		PrintName = "[HGC-5] Rys-T FShield",
		mdl = "models/eft_props/gear/helmets/helmet_rys_t_shield.mdl",
		snds = GenericSounds,
		slots = {
			eyes = 1,
			mouthnose = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		bdg = {
			[0] = 0
		},
		tgl = {
			mskmat = "",
			bdg = {
				[0] = 1
			},
			slots = {
				eyes = 0,
				mouthnose = 0
			}
		},
		wgt = wgtmult * 1.2,
		dur = durmult * 110,
		mskmat = "mask_overlays/altyn.png",
		ent = "ent_jack_gmod_ezarmor_rystface",
	}

	JMod.EFTArmorTable["Shmaska 1SH Shield"] = {
		PrintName = "[HGC-6] ShMaska FS",
		mdl = "models/eft_props/gear/helmets/helmet_maska_1sh_shield.mdl", -- csgo misc
		snds = GenericSounds,
		slots = {
			eyes = .9,
			mouthnose = .9
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		bdg = {
			[0] = 0
		},
		tgl = {
			bdg = {
				[0] = 1
			},
			mskmat = "",
			slots = {
				eyes = 0,
				mouthnose = 0
			}
		},
		wgt = wgtmult * 1.1,
		dur = durmult * 71,
		mskmat = "mats_jack_gmod_sprites/slit_vignette.png",
		ent = "ent_jack_gmod_ezarmor_shlemmask"
	}

	JMod.EFTArmorTable["Shmaska 1SH Shield (Killa)"] = {
		PrintName = "[HGC-6] ShMaska FS (K)",
		mdl = "models/eft_props/gear/helmets/helmet_maska_1sh_shield_killa.mdl", -- csgo misc
		snds = GenericSounds,
		slots = {
			eyes = .9,
			mouthnose = .9
		},
		def = Class6,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		bdg = {
			[0] = 0
		},
		tgl = {
			bdg = {
				[0] = 1
			},
			mskmat = "",
			slots = {
				eyes = 0,
				mouthnose = 0
			}
		},
		wgt = wgtmult * 1.1,
		dur = durmult * 71,
		mskmat = "mats_jack_gmod_sprites/slit_vignette.png",
		ent = "ent_jack_gmod_ezarmor_shlemmaskkilla"
	}

--[[
   __ _  ___    __ _ _ __ _ __ ___   ___  _ __ ___ 
  / _` |/ __|  / _` | '__| '_ ` _ \ / _ \| '__/ __|
 | (_| | (__  | (_| | |  | | | | | | (_) | |  \__ \
  \__, |\___|  \__,_|_|  |_| |_| |_|\___/|_|  |___/
   __/ |                                           
  |___/                                            

]]--

	JMod.EFTArmorTable["Fast Mandible"] = {
		PrintName = "[HGC-2] FAST Gunsight Mandible",
		mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_gunsight_mandible.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			mouthnose = 1,
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		bdg ={
			[0] = 1,
			[1] = 1,
		},
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_fastmandible"
	}

	JMod.EFTArmorTable["Caiman Mandible"] = {
		PrintName = "[HGC-2] Caiman Mandible",
		mdl = "models/eft_props/gear/helmets/helmet_galvion_mandible.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			mouthnose = 1,
		},
		def = Class2,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.1,
		dur = durmult * 80,
		ent = "ent_jack_gmod_ezarmor_caimanmandible"
	}

	JMod.EFTArmorTable["Fast Side Armor Black"] = {
		PrintName = "[HGC-3] FAST Side Armor Black",
		mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_side_armor_b.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			ears = 1,
			acc_ears = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 42,
		ent = "ent_jack_gmod_ezarmor_fastsidearmorblack"
	}

	JMod.EFTArmorTable["Fast Side Armor Tan"] = {
		PrintName = "[HGC-3] FAST Side Armor Tan",
		mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_side_armor_t.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			ears = 1,
			acc_ears = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 42,
		ent = "ent_jack_gmod_ezarmor_fastsidearmortan"
	}

	JMod.EFTArmorTable["Crye AirFrame Ears"] = {
		PrintName = "[HGC-3] Crye AirFrame Ears",
		mdl = "models/eft_props/gear/helmets/helmet_crye_airframe_ears.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			ears = 1,
			acc_ears = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 45,
		ent = "ent_jack_gmod_ezarmor_cryeairframeears"
	}

	JMod.EFTArmorTable["TW EXFIL Ears B"] = {
		PrintName = "[HGC-3] TW EXFIL EC",
		mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_ear_covers_b.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			ears = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.172,
		dur = durmult * 60,
		ent = "ent_jack_gmod_ezarmor_twexfilearb"
	}

	JMod.EFTArmorTable["TW EXFIL Ears C"] = {
		PrintName = "[HGC-3] TW EXFIL EC",
		mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_ear_covers_c.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			ears = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 0.172,
		dur = durmult * 60,
		ent = "ent_jack_gmod_ezarmor_twexfilearc"
	}

	JMod.EFTArmorTable["Crye AirFrame Chops"] = {
		PrintName = "[HGC-3] Crye AirFrame Chops",
		mdl = "models/eft_props/gear/helmets/helmet_crye_airframe_chops.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			mouthnose = .9,
			ears = .9,
			acc_ears = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.45,
		dur = durmult * 50,
		ent = "ent_jack_gmod_ezarmor_cryeairframechops"
	}

	JMod.EFTArmorTable["NeoSteel Mandible"] = {
		PrintName = "[HGC-3] NeoSteel Mandible",
		mdl = "models/eft_props/gear/helmets/helmet_neosteel_mandible.mdl", -- tarkov
		snds = GenericSounds,
		slots = {
			mouthnose = .9,
			ears = .9,
			acc_ears = 1,
		},
		def = Class3,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 48,
		ent = "ent_jack_gmod_ezarmor_neosteelmandible"
	}

	JMod.EFTArmorTable["LShZ-2DTM Aventail"] = {
		PrintName = "[HGC] LShZ-2DTM Aventail",
		mdl = "models/eft_props/gear/helmets/helmet_lshz2dtm_aventail.mdl", -- tarkov
		snds = HelmetSounds,
		slots = {
			aventail = 1
		},
		def = Class5,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Head1",
		siz = size_head,
		pos = pos_head,
		ang = ang_head,
		wgt = wgtmult * 1.2,
		dur = durmult * 70,
		ent = "ent_jack_gmod_ezarmor_lshz2dtmaventail"
	}

function JMod.GenerateArmorEntities(tbl)
	for class, info in pairs(tbl) do
		if info.noent then continue end
		local armorent = {}
		armorent.Base = "ent_jack_gmod_ezarmor"
		armorent.PrintName = info.PrintName or class
		armorent.Spawnable = info.Spawnable or true
		armorent.AdminOnly = info.AdminOnly or false
		armorent.Category = info.Category or "JMod - EZ EFT Armor"
		armorent.ArmorName = class
		armorent.ModelScale = info.gayPhysics and nil or info.entsiz -- or math.max(info.siz.x, info.siz.y, info.siz.z)
		scripted_ents.Register( armorent, info.ent )
	end
end
JMod.GenerateArmorEntities(JMod.EFTArmorTable)

local function LoadEFTAdditionalArmor()
	if JMod.EFTArmorTable then
		table.Merge(JMod.ArmorTable, JMod.EFTArmorTable)
		JMod.GenerateArmorEntities(JMod.EFTArmorTable)
	end
end
hook.Add("Initialize","JMod_LoadEFTAdditionalArmor", LoadEFTAdditionalArmor)

LoadEFTAdditionalArmor()