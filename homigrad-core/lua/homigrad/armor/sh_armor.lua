hg = hg or {}

hg.Armors = {
    ["vest1"] = {
        Name = "Kirasa-N",
        Model = "models/eft_props/gear/armor/ar_kirasa_n.mdl",
        Pos = Vector(2.8,0,-0.8),
        FemPos = Vector(1.8,0,-2),
        Ang = Angle(90,0,-90),
        Scale = 0.95,
        FemScale = 0.8,
        Placement = "torso",
        Protection = 1.5,
        Rarity = 2,
        Bone = "ValveBiped.Bip01_Spine2",
        Icon = "entities/ent_jack_gmod_ezarmor_kirasan.png"
    },
    ["vest2"] = {
        Name = "Ars Arma A18",
        Model = "models/eft_props/gear/armor/cr/cr_ars_arma_18.mdl",
        Pos = Vector(3.6,0,0),
        FemPos = Vector(2,0,0),
        FemScale = 0.75,
        Ang = Angle(90,0,-90),
        Scale = 0.9,
        Protection = 1.75,
        Rarity = 3,
        Placement = "torso",
        Bone = "ValveBiped.Bip01_Spine2",
        Icon = "entities/ent_jack_gmod_ezarmor_arsarmaa18.png"
    },
    ["vest3"] = {
        Name = "FirstSpear \"Strandhogg\"",
        Model = "models/eft_props/gear/armor/cr/cr_strandhogg.mdl",
        Pos = Vector(3.6,0,0),
        Ang = Angle(90,0,-90),
        FemPos = Vector(2,0,0),
        FemScale = 0.75,
        Scale = 0.95,
        Protection = 2.5,
        Rarity = 4,
        Placement = "torso",
        Bone = "ValveBiped.Bip01_Spine2",
        Icon = "entities/ent_jack_gmod_ezarmor_strandhogg.png"
    },

    ["back1"] = {
        Name = "Duffle Bag",
        Model = "models/eft_props/gear/backpacks/bp_forward.mdl",
        Pos = Vector(2.8,-1,-0.6),
        Ang = Angle(90,0,-90),
        FemPos = Vector(2.1,-0.7,-1),
        FemScale = 0.7,
        Scale = 0.9,
        Placement = "back",
        Protection = 0,
        Rarity = 1,
        Bone = "ValveBiped.Bip01_Spine2",
        Icon = "entities/ent_jack_gmod_ezarmor_dufflebag.png"
    },
    ["back2"] = {
        Name = "Piligrim",
        Model = "models/eft_props/gear/backpacks/bp_piligrimm.mdl",
        Pos = Vector(2,0,-0.6),
        Ang = Angle(90,0,-90),
        FemPos = Vector(2.1,0,-1),
        FemScale = 0.7,
        Scale = 0.88,
        Placement = "back",
        Protection = 0,
        Rarity = 2,
        Bone = "ValveBiped.Bip01_Spine2",
        Icon = "entities/ent_jack_gmod_ezarmor_piligrim.png"
    },
    ["back3"] = {
        Name = "Hazard 4 \"Takedown\"",
        Model = "models/eft_props/gear/backpacks/bp_takedown_sling.mdl",
        Pos = Vector(2,0,0),
        Ang = Angle(90,0,-90),
        FemPos = Vector(2.1,-0.7,-1),
        FemScale = 0.74,
        Scale = 0.82,
        Placement = "back",
        Protection = 0,
        Rarity = 2,
        Bone = "ValveBiped.Bip01_Spine2",
        Icon = "entities/ent_jack_gmod_ezarmor_takedownbbp.png"
    },

    ["rcalf1"] = {
        Name = "Right Calf Armour",
        Model = "models/snowzgmod/payday2/armour/armourrcalf.mdl",
        Pos = Vector(3.6,0,0),
        Ang = Angle(90,0,-90),
        Scale = 0.95,
        Protection = 1.2,
        Placement = "rleg",
        Rarity = 3,
        Bone = "ValveBiped.Bip01_R_Calf",
        Icon = "entities/ent_jack_gmod_ezarmor_srcalf.png"
    },
    ["lcalf1"] = {
        Name = "Left Calf Armour",
        Model = "models/snowzgmod/payday2/armour/armourlcalf.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(90,0,-90),
        Scale = 0.95,
        Protection = 1.2,
        Placement = "lleg",
        Rarity = 3,
        Bone = "ValveBiped.Bip01_L_Calf",
        Icon = "entities/ent_jack_gmod_ezarmor_slcalf.png"
    },
    ["rfarm1"] = {
        Name = "Right Arm Armour",
        Model = "models/snowzgmod/payday2/armour/armourrforearm.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(90,0,-90),
        Scale = 0.95,
        Protection = 1.2,
        Placement = "rarm",
        Rarity = 3,
        Bone = "ValveBiped.Bip01_R_Forearm",
        Icon = "entities/ent_jack_gmod_ezarmor_srforearm.png"
    },
    ["lfarm1"] = {
        Name = "Left Arm Armour",
        Model = "models/snowzgmod/payday2/armour/armourlforearm.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(0,0,0),
        Scale = 0.95,
        Protection = 1.2,
        Placement = "larm",
        Rarity = 3,
        Bone = "ValveBiped.Bip01_L_Forearm",
        Icon = "entities/ent_jack_gmod_ezarmor_slforearm.png"
    },
    ["helmet1"] = {
        Name = "MSA \"Gallet TC 800 High Cut\"",
        Model = "models/eft_props/gear/helmets/helmet_msa_gallet.mdl",
        Pos = Vector(0.5,0,2.9),
        FemPos = Vector(0.8,0,2.1),
        Ang = Angle(-90,0,-90),
        Scale = 0.98,
        FemScale = 0.9,
        Protection = 1.4,
        Rarity = 4,
        Placement = "head",
        Bone = "ValveBiped.Bip01_Head1",
        NoDraw = true,
        Overlay = "mats_jack_gmod_sprites/one-quarter-from-top-blocked.png",
        Icon = "entities/ent_jack_gmod_ezarmor_tc800.png"
    },
    ["mask1"] = {
        Name = "Knight Mask",//МАКСИМ ОДА
        Model = "models/eft_props/gear/facecover/facecover_boss_black_knight.mdl",
        Pos = Vector(0.9,0,2.5),
        FemPos = Vector(0.9,0,2.3),
        FemScale = 1,
        Ang = Angle(-90,0,-90),
        Scale = 1,
        Placement = "head",
        Protection = 1.5,
        Rarity = 3,
        Bone = "ValveBiped.Bip01_Head1",
        NoDraw = true,
        Overlay = "mask_overlays/mask_anvis.png",
        Icon = "entities/ent_jack_gmod_ezarmor_deathknight.png"
    },
    ["mask2"] = {
        Name = "Cold Fear balaclava",
        Model = "models/eft_props/gear/facecover/facecover_coldgear.mdl",
        Pos = Vector(0.8,0,3.4),
        FemPos = Vector(1.2,0,2),
        Ang = Angle(-90,0,-90),
        Scale = 1,
        FemScale = 0.9,
        Placement = "face",
        Protection = 1,
        Rarity = 2,
        Bone = "ValveBiped.Bip01_Head1",
        NoDraw = true,
        Overlay = "mats_jack_gmod_sprites/one-quarter-from-top-blocked.png",
        Icon = "entities/ent_jack_gmod_ezarmor_coldfear.png"
    },
    ["mask3"] = {
        Name = "Zryachiy balaclava",
        Model = "models/eft_props/gear/facecover/facecover_zryachii_closed.mdl",
        Pos = Vector(1,0,3.3),
        FemPos = Vector(1.15,0,2.8),
        FemScale = 0.95,
        Ang = Angle(-90,0,-90),
        Scale = 1,
        Placement = "face",
        Protection = 1,
        Rarity = 2,
        Bone = "ValveBiped.Bip01_Head1",
        NoDraw = true,
        Overlay = "mats_jack_gmod_sprites/one-quarter-from-top-blocked.png",
        Icon = "entities/ent_jack_gmod_ezarmor_zryachiibalacvlava.png"
    },
    ["mask4"] = {
        Name = "Jason Mask",
        Model = "models/eft_props/gear/facecover/facecover_halloween_jason.mdl",
        Pos = Vector(0.7,0,3.2),
        FemPos = Vector(1.15,0,2.2),
        FemScale = 0.95,
        Ang = Angle(-90,0,-90),
        Scale = 1,
        Placement = "head",
        Protection = 1,
        Rarity = 2,
        Bone = "ValveBiped.Bip01_Head1",
        NoDraw = true,
        Overlay = "mask_overlays/mask_anvis.png",
        Icon = "entities/ent_jack_gmod_ezarmor_jason.png"
    },
    ["mask5"] = {
        Name = "Kaonashi Mask",
        Model = "models/eft_props/gear/facecover/facecover_halloween_kaonasi.mdl",
        Pos = Vector(1,0,3.3),
        FemPos = Vector(1.15,0,2.8),
        FemScale = 0.95,
        Ang = Angle(-90,0,-90),
        Scale = 1,
        Placement = "head",
        Protection = 1,
        Rarity = 2,
        Bone = "ValveBiped.Bip01_Head1",
        NoDraw = true,
        Overlay = "mask_overlays/mask_anvis.png",
        Icon = "entities/ent_jack_gmod_ezarmor_faceless.png"
    }
}

local function addArmor()
	for name, tbl in pairs(hg.Armors) do
		if CLIENT then language.Add(tbl.Name .. "_armor", tbl.Name) end
		local ent = {}
		ent.Base = "armor_base"
		ent.PrintName = tbl.Name
		ent.Category = "Броня"
		ent.Spawnable = true
		ent.Armor = name
		scripted_ents.Register(ent, "ent_armor_" .. name)
	end
end

addArmor()
hook.Add("Initialize", "init-armor", addArmor)