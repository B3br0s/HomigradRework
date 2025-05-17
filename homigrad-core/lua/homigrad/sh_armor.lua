hg = hg or {}

hg.Armors = {
    ["vest1"] = {
        Name = "Kirasa-N",
        Model = "models/eft_props/gear/armor/ar_kirasa_n.mdl",
        Pos = Vector(2.8,0,-0.8),
        Ang = Angle(90,0,-90),
        Scale = 0.95,
        Placement = "torso",
        Protection = 1.5,
        Bone = "ValveBiped.Bip01_Spine2",
        Icon = "entities/ent_jack_gmod_ezarmor_kirasan.png"
    },
    ["vest2"] = {
        Name = "Ars Arma A18",
        Model = "models/eft_props/gear/armor/cr/cr_ars_arma_18.mdl",
        Pos = Vector(3.6,0,0),
        Ang = Angle(90,0,-90),
        Scale = 0.95,
        Protection = 1.2,
        Placement = "torso",
        Bone = "ValveBiped.Bip01_Spine2",
        Icon = "entities/ent_jack_gmod_ezarmor_arsarmaa18.png"
    },
    ["vest3"] = {
        Name = "FirstSpear \"Strandhogg\"",
        Model = "models/eft_props/gear/armor/cr/cr_strandhogg.mdl",
        Pos = Vector(3.6,0,0),
        Ang = Angle(90,0,-90),
        Scale = 0.95,
        Protection = 2,
        Placement = "torso",
        Bone = "ValveBiped.Bip01_Spine2",
        Icon = "entities/ent_jack_gmod_ezarmor_strandhogg.png"
    },
    ["helmet1"] = {
        Name = "MSA \"Gallet TC 800 High Cut\"",
        Model = "models/eft_props/gear/helmets/helmet_msa_gallet.mdl",
        Pos = Vector(0.5,0,2.9),
        Ang = Angle(-90,0,-90),
        Scale = 0.98,
        Protection = 1.4,
        Placement = "head",
        Bone = "ValveBiped.Bip01_Head1",
        NoDraw = true,
        Overlay = "mats_jack_gmod_sprites/one-quarter-from-top-blocked.png",
        Icon = "entities/ent_jack_gmod_ezarmor_tc800.png"
    },
    ["mask1"] = {
        Name = "Knight Mask",//МАКСИМ ОДА
        Model = "models/eft_props/gear/facecover/facecover_boss_black_knight.mdl",
        Pos = Vector(0.9,0,3.78),
        Ang = Angle(-90,0,-90),
        Scale = 1,
        Placement = "head",
        Protection = 1,
        Bone = "ValveBiped.Bip01_Head1",
        NoDraw = true,
        Overlay = "mask_overlays/mask_anvis.png",
        Icon = "entities/ent_jack_gmod_ezarmor_deathknight.png"
    },
    ["mask2"] = {
        Name = "Cold Fear balaclava",
        Model = "models/eft_props/gear/facecover/facecover_coldgear.mdl",
        Pos = Vector(0.8,0,3.4),
        Ang = Angle(-90,0,-90),
        Scale = 1,
        Placement = "face",
        Protection = 1,
        Bone = "ValveBiped.Bip01_Head1",
        NoDraw = true,
        Overlay = "mats_jack_gmod_sprites/one-quarter-from-top-blocked.png",
        Icon = "entities/ent_jack_gmod_ezarmor_coldfear.png"
    },
    ["mask3"] = {
        Name = "Zryachiy balaclava",
        Model = "models/eft_props/gear/facecover/facecover_zryachii_closed.mdl",
        Pos = Vector(0.8,0,3.9),
        Ang = Angle(-90,0,-90),
        Scale = 0.88,
        Placement = "face",
        Protection = 1,
        Bone = "ValveBiped.Bip01_Head1",
        NoDraw = true,
        Overlay = "mats_jack_gmod_sprites/one-quarter-from-top-blocked.png",
        Icon = "entities/ent_jack_gmod_ezarmor_zryachiibalacvlava.png"
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