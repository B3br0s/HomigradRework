SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Author = "Homigrad"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/tfa_nmrih/v_me_hatchet.mdl"
SWEP.WorldModel = "models/weapons/w_jjife_t.mdl"

SWEP.HoldAng = Angle(25,0,180)
SWEP.HoldPos = Vector(-1,1.2,-2)

SWEP.AnimAng = Angle(-10,-5,0)
SWEP.AnimPos = Vector(-15,-5,0)

SWEP.ModelScale = 1.2

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Rarity = 4
SWEP.HoldType = "melee"
SWEP.AnimWait = 2
SWEP.AttackTime = 0.05
SWEP.AttackAng = Angle(0,-20,0)
SWEP.AttackWait = 0.4
SWEP.AttackDist = 60
SWEP.AttackDamage = 20
SWEP.AttackType = DMG_CLUB
SWEP.NoLHand = true
SWEP.isMelee = true
SWEP.isTakeSlot = false

SWEP.IconAng = Angle(0,-90,0)
SWEP.IconPos = Vector(60,5.25,0)

SWEP.AttackHitFlesh = {"weapons/melee/flesh_impact_blunt_01.wav","weapons/melee/flesh_impact_blunt_02.wav","weapons/melee/flesh_impact_blunt_05.wav","weapons/melee/flesh_impact_blunt_03.wav"}
SWEP.AttackHit = "snd_jack_hmcd_hammerhit.wav"
SWEP.DeploySnd = "physics/metal/metal_grenade_impact_soft2.wav"

SWEP.Animations = {
	["idle"] = {
        Source = "Idle",
    },
	["draw"] = {
        Source = "Draw",
        MinProgress = 0.5,
        Time = 0.5
    },
    ["attack"] = {
        Source = "Attack_Quick",
        MinProgress = 0.5,
        Time = 1.5
    },
	["shove"] = {
        Source = "Attack_Quick2",
        MinProgress = 0.5,
        Time = 1.5
    },
}

local function TwoTrace(ply)
	local owner = ply
	local tr = {}
	tr.start = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos

	local dir = Vector(1, 0, 0)
	dir:Rotate(owner:EyeAngles())

	tr.endpos = tr.start + dir * 75
	tr.filter = {owner}

	local tRes1 = util.TraceLine(tr)
	if not IsValid(tRes1.Entity) then return end

	tr.start = tRes1.HitPos + tRes1.Normal
	tr.endpos = tRes1.HitPos + dir * 25
	tr.filter[2] = tRes1.Entity

	if SERVER then
		for _, info in pairs(constraint.GetTable(tRes1.Entity)) do
			if info.Ent1 ~= game.GetWorld() then table.insert(tr.filter, info.Ent1) end
			if info.Ent2 ~= game.GetWorld() then table.insert(tr.filter, info.Ent2) end
		end
	end

	local tRes2 = util.TraceLine(tr)
	if not tRes2.Hit then return end

	return hg.eyeTrace(ply), tRes2
end

function SWEP:SecondaryAttack()
	if not self.mode then
		local att = self:GetOwner()
		local tRes1, tRes2 = TwoTrace(att)
		if not tRes1 then return end

		if self:Clip2() == 0 then return end

		timer.Simple(self.AttackTime,function()
            if SERVER then
		    	self:SetClip2(self:Clip2() - 1)
                
		    	local ent1, ent2 = tRes1.Entity, tRes2.Entity
		    	ent1.IsWeld = (ent1.IsWeld or 0) + 1
		    	ent2.IsWeld = (ent2.IsWeld or 0) + 1
                
		    	local ply = RagdollOwner(ent1) or RagdollOwner(ent2) or false
		    	if IsValid(ply) and ply:Alive() and ply.FakeRagdoll == ent1 then
		    		self:Attack(ent1,tRes1)
                
		    		ply.bleed = ply.bleed + 10
		    	end

                if !IsValid(ent1) then
                    return
                end
            
		    	if not IsValid(ent1:GetPhysicsObject()) or not IsValid(ent2:GetPhysicsObject()) then return end
            
		    	local weldEntity = constraint.Weld(ent1, ent2, tRes1.PhysicsBone or 0, tRes2.PhysicsBone or 0, 0, false, false)
		    	ent1.weld = ent1.weld or {}
		    	ent2.weld = ent2.weld or {}
		    	ent1.weld[weldEntity] = ent2
		    	ent2.weld[weldEntity] = ent1
            
		    	self:GetOwner():EmitSound("snd_jack_hmcd_hammerhit.wav", 65)
		    end
        end)

		self:SetNextSecondaryFire(CurTime() + 1)
		hg.PlayAnim(self,"attack")
	else
		local att = self:GetOwner()
		local tRes1, tRes2 = TwoTrace(att)
		if not tRes1 then return end

		local ent1, ent2 = tRes1.Entity, tRes2.Entity
		local ply = hg.RagdollOwner(ent1) or hg.RagdollOwner(ent2)

		hg.PlayAnim(self,"shove")

		if ent1.weld then
			for weldEntity, ent in pairs(ent1.weld) do
				ent1.IsWeld = math.max((ent1.IsWeld or 0) - 1, 0)
				ent.IsWeld = math.max((ent.IsWeld or 0) - 1, 0)

				if ent1.IsWeld == 0 and ent.IsWeld == 0 then
					ent.weld[weldEntity] = nil
					ent1.weld[weldEntity] = nil

					if IsValid(weldEntity) then 
						weldEntity:Remove()
					end
				end

				self:SetClip2(self:Clip2() + 1)

				ent1:EmitSound("snd_jack_hmcd_hammerhit.wav", 65)
			end

			if IsValid(ply) and ply:Alive() and ply.FakeRagdoll == ent1 then
                self:Attack(ent1,tRes1)

				ply.bleed = ply.bleed + 10
			end
		end

		self:SetNextSecondaryFire(CurTime() + 1)
	end
end

function SWEP:Think()
	local ply = self:GetOwner()

	if SERVER then
		if ply:KeyDown(IN_ATTACK2) then
			if ply:KeyDown(IN_USE) and not self.modechanged then
				self.modechanged = true

				self.mode = not (self.mode or false)

				net.Start("hammer_mode")
					net.WriteEntity(self)
					net.WriteBool(self.mode)
				net.Send(ply)
			end
		else
			self.modechanged = false
		end
	end
end

if SERVER then
	util.AddNetworkString("hammer_mode")
else
	net.Receive("hammer_mode", function(len)
		net.ReadEntity().mode = net.ReadBool()
	end)
end

local bonenames = {
	["ValveBiped.Bip01_Head1"] = "#hg.bones.head",
	["ValveBiped.Bip01_Spine"] = "#hg.bones.spine",
	["ValveBiped.Bip01_Spine2"] = "#hg.bones.spine",
	["ValveBiped.Bip01_Pelvis"] = "#hg.bones.pelvis",

	["ValveBiped.Bip01_R_Hand"] = "#hg.bones.rhand",
	["ValveBiped.Bip01_R_Forearm"] = "#hg.bones.rforearm",
	["ValveBiped.Bip01_R_Shoulder"] = "#hg.bones.rshoulder",
	["ValveBiped.Bip01_R_UpperArm"] = "#hg.bones.rshoulder",
	["ValveBiped.Bip01_R_Elbow"] = "#hg.bones.relbow",

	["ValveBiped.Bip01_R_Foot"] = "#hg.bones.rfoot",
	["ValveBiped.Bip01_R_Thigh"] = "#hg.bones.rthigh",
	["ValveBiped.Bip01_R_Calf"] = "#hg.bones.rcalf",

	["ValveBiped.Bip01_L_Hand"] = "#hg.bones.lhand",
	["ValveBiped.Bip01_L_Forearm"] = "#hg.bones.lforearm",
	["ValveBiped.Bip01_L_Shoulder"] = "#hg.bones.lshoulder",
	["ValveBiped.Bip01_L_UpperArm"] = "#hg.bones.lshoulder",
	["ValveBiped.Bip01_L_Elbow"] = "#hg.bones.lelbow",

	["ValveBiped.Bip01_L_Foot"] = "#hg.bones.lfoot",
	["ValveBiped.Bip01_L_Thigh"] = "#hg.bones.lthigh",
	["ValveBiped.Bip01_L_Calf"] = "#hg.bones.lcalf"
}