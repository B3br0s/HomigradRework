-- sh_hg_armor.lua"

hg.armor = {}
hg.armor.torso = {
	["vest1"] = {
		"torso",
		"models/combataegis/body/ballisticvest_d.mdl",
		Vector(19, 3, 0),
		Angle(0, 90, 90),
		protection = 13,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/combataegis/body/ballisticvest.mdl",
		femPos = Vector(-3, 0, 1)
	},
	["vest2"] = {
		"torso",
		"models/eu_homicide/armor_prop.mdl",
		Vector(-1, 2, 0),
		Angle(0, 90, 90),
		protection = 6.5,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/eu_homicide/armor_on.mdl",
		femPos = Vector(-2, 0, 1.5)
	}
}

hg.armor.head = {
	["helmet1"] = {
		"head",
		"models/barney_helmet.mdl",
		Vector(1, -2, 0),
		Angle(180, 110, 90),
		protection = 10,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/barney_helmet.mdl",
		femPos = Vector(-1, 0, 0),
		material = "sal/hanker",
		norender = true,
		viewmaterial = Material("sprites/mat_jack_hmcd_helmover")
	},
	["helmet2"] = {
		"head",
		"models/dean/gtaiv/helmet.mdl",
		Vector(2.6, 0, 0),
		Angle(180, 110, 90),
		protection = 5,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/dean/gtaiv/helmet.mdl",
		femPos = Vector(-1, 0, 0),
		norender = true,
		viewmaterial = Material("sprites/mothelm_over")
	},
	["helmet3"] = {
		"head",
		"models/eu_homicide/helmet.mdl",
		Vector(2, 0.2, 0),
		Angle(180, 110, 90),
		protection = 4,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/eu_homicide/helmet.mdl",
		femPos = Vector(-1.2, 0, 0.5),
		norender = true,
		viewmaterial = Material("sprites/mat_jack_helmoverlay_r")
	}
}

--[[["mask1"] = {
		"head", -- "face"
		"models/jmod/ballistic_mask.mdl",
		Vector(1, -2, 0),
		Angle(180, 110, 90),
		protection = 10,`
		bone = "ValveBiped.Bip01_Head1",
		model = "models/jmod/ballistic_mask.mdl",
		femPos = Vector(-3, 0, 1),
		material = "sal/hanker",
		norender = true
	},]]
if SERVER then
	hg.organism = hg.organism or {}
	hg.organism.input_list = hg.organism.input_list or {}
	hg.organism.input_list.armor1 = function(org, bone, dmg, dmgInfo)
		if org.owner.armors["torso"] ~= "vest1" then return 0 end
		local prot = hg.armor["torso"]["vest1"].protection - (dmgInfo:GetInflictor().Penetration or 1)
		if prot < 0 then return 0 end
		dmgInfo:ScaleDamage(0)
		return 1
	end

	hg.organism.input_list.helmet1 = function(org, bone, dmg, dmgInfo)
		if org.owner.armors["head"] ~= "helmet1" then return 0 end
		local prot = hg.armor["head"]["helmet1"].protection - (dmgInfo:GetInflictor().Penetration or 1)
		if org.owner:IsPlayer() and not IsValid(org.owner.FakeRagdoll) then org.owner:EmitSound("homigrad/player/headshot_helmet.wav") end
		if prot < 0 then return 0 end
		if org.owner:IsPlayer() and org.alive then org.owner:ViewPunch(AngleRand(-30, 30)) end
		dmgInfo:ScaleDamage(0)
		return 1
	end

	hg.organism.input_list.helmet2 = function(org, bone, dmg, dmgInfo)
		if org.owner.armors["head"] ~= "helmet2" then return 0 end
		local prot = hg.armor["head"]["helmet2"].protection - (dmgInfo:GetInflictor().Penetration or 1)
		if org.owner:IsPlayer() and not IsValid(org.owner.FakeRagdoll) then end
		if prot < 0 then return 0 end
		if org.owner:IsPlayer() and org.alive then org.owner:ViewPunch(AngleRand(-30, 30)) end
		dmgInfo:ScaleDamage(0)
		return 1
	end

	hg.organism.input_list.helmet3 = function(org, bone, dmg, dmgInfo)
		if org.owner.armors["head"] ~= "helmet3" then return 0 end
		local prot = hg.armor["head"]["helmet3"].protection - (dmgInfo:GetInflictor().Penetration or 1)
		if org.owner:IsPlayer() and not IsValid(org.owner.FakeRagdoll) then end
		if prot < 0 then return 0 end
		if org.owner:IsPlayer() and org.alive then org.owner:ViewPunch(AngleRand(-30, 30)) end
		dmgInfo:ScaleDamage(0)
		return 1
	end

	hg.organism.input_list.armor2 = function(org, bone, dmg, dmgInfo)
		if org.owner.armors["torso"] ~= "vest2" then return 0 end
		local prot = hg.armor["torso"]["vest2"].protection - (dmgInfo:GetInflictor().Penetration or 1)
		if prot < 0 then return 0 end
		dmgInfo:ScaleDamage(0)
		return 1
	end
	--[[hg.organism.input_list.mask1 = function(org, bone, dmg, dmgInfo)
		if org.owner.armors["head"] ~= "mask1" then return 0 end
		local prot = hg.armor["head"]["mask1"].protection - (dmgInfo:GetInflictor().Penetration or 1)
		if org.owner:IsPlayer() and not IsValid(org.owner.FakeRagdoll) then org.owner:EmitSound("homigrad/player/headshot_helmet.wav") end
		if prot < 0 then return 0 end
		if org.owner:IsPlayer() and org.alive then org.owner:ViewPunch(AngleRand(-30, 30)) end
		dmgInfo:ScaleDamage(0)
		return 1
	end]]
end

local armorNames = {
	["vest1"] = "Plate Body Armor IV",
	["helmet1"] = "ACH Helmet III",
	["helmet2"] = "Biker Helmet",
	["helmet3"] = "Riot Helmet",
	["vest2"] = "Police Riot Vest"
}

local entityMeta = FindMetaTable("Entity")
function entityMeta:SyncArmor()
	if self.armors then
		self:SetNetVar("Armor", self.armors)
	end
end

--["mask1"] = "Баллистическая Маска",
local function initArmor()
	for possibleArmor, armors in pairs(hg.armor) do
		for armorkey, armorData in pairs(armors) do
			if CLIENT then language.Add(armorkey, armorNames[armorkey] or armorkey) end
			local armor = {}
			armor.Base = "armor_base"
			armor.PrintName = CLIENT and language.GetPhrase(armorkey) or armorkey
			armor.name = armorkey
			armor.Category = "HG Armor"
			armor.Spawnable = true
			armor.Model = armorData[2]
			armor.WorldModel = armorData[2]
			armor.SubMats = armorData[4]
			armor.armor = armorData
			armor.placement = armorData[1]
			armor.PhysModel = armorData.PhysModel or nil
			armor.PhysPos = armorData.PhysPos or nil
			armor.PhysAng = armorData.PhysAng or nil
			armor.material = armorData.material or nil
			scripted_ents.Register(armor, "ent_armor_" .. armorkey)
		end
	end
end

function hg.GetArmorPlacement(armor)
	armor = string.Replace(armor,"ent_armor_","")
	
	local found
	for i,armplc in pairs(hg.armor) do
		for i2,armor2 in pairs(armplc) do
			if i2 == armor then found = i end
		end
	end
	return found
end

local stringToNum = {
	["torso"] = 1,
	["head"] = 2,
}

function hg.GetArmorPlacementNum(armor)
	return stringToNum[hg.GetArmorPlacement(armor)]
end

initArmor()
hook.Add("Initialize", "init-atts", initArmor)