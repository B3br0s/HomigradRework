SWEP.Base = "weapon_base"
SWEP.PrintName = "Homigrad Weapon Base"
SWEP.Spawnable = true
SWEP.DrawAmmo = false
SWEP.HoldType = "revolver"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.Author = "Homigrad"

SWEP.WorldModel = "models/weapons/arccw_go/v_pist_p2000.mdl"

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(-13.5,-3.75,5)
SWEP.HolsterBone = "ValveBiped.Bip01_Pelvis"
SWEP.HolsterPos = Vector(0,0,0)
SWEP.HolsterAng = Angle(0,0,0)
SWEP.animmul = 0
SWEP.Empty3 = true
SWEP.Empty4 = true

SWEP.DrawTime = 0.1
SWEP.Deployed = true
SWEP.ishgweapon = true

SWEP.Primary.DefaultClip = 13
SWEP.Primary.ClipSize = 13
SWEP.Primary.Sound = "arccw_go/hkp2000/hkp2000_01.wav"
SWEP.Primary.ReloadTime = 2
SWEP.Primary.Wait = 0.1
SWEP.Primary.Damage = 15
SWEP.Primary.Force = 35
SWEP.Primary.Automatic = false
SWEP.RecoilForce = 1
SWEP.TwoHands = false
SWEP.Bodygroups = {[1] = 0,[2]=0,[3]=0,[4]=0,[5]=0}

SWEP.BoltLock = true
SWEP.SupportsTPIK = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

hg.Weapons = hg.Weapons or {}

function SWEP:Initialize()
    self.Reloading = false
    self.Inspecting = false
    self.SmoothedBolt = 0
	self.ishgwep = true
    hg.Weapons[self] = true
    self.Instructions = ""

	self:Initialize_Spray()
	self.Deployed = true

	self:SetHoldType(weapons.Get(self:GetClass()).HoldType)
end

function SWEP:OwnerChanged()
	if IsValid(self.worldModel) then
		self.worldModel:Remove()
	end

	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Smooth(value)
	if self.NextShoot + 0.125 > CurTime() then
        return 0.03
    end
    return math.ease.InSine(value) + math.max(math.ease.InElastic(value) - 0.6,0)
end

function SWEP:Deploy()
    local ply = self:GetOwner()
	self:SetHoldType("normal")
	self.Deployed = false
	if self:IsPistolHoldType() then
		self:EmitSound("homigrad/weapons/draw_pistol.mp3")
	else
		self:EmitSound("homigrad/weapons/draw_rifle.mp3")
	end
	timer.Simple(self.DrawTime,function()
		self:SetHoldType(weapons.Get(self:GetClass()).HoldType)
		self.Deployed = true
	end)
end

function SWEP:SecondaryAttack()
    return
end

if SERVER then
	util.AddNetworkString("hgwep shoot")
else
	net.Receive("hgwep shoot",function()
		local ent = net.ReadEntity()

		if ent.Shoot then
			ent:Shoot()
		end
	end)
end

function SWEP:PrimaryAdd()
end

function SWEP:PrimaryAttack()
	if self:Clip1() == 0 and SERVER then
		self.Primary.Automatic = false
		sound.Play("weapons/clipempty_pistol.wav",self:GetPos(),75,math.random(95,105),1)
		return
	end
	self.Primary.Automatic = weapons.Get(self:GetClass()).Primary.Automatic
	if !self:CanShoot() then if !self:IsSprinting() and !self:IsClose() then self.Primary.Automatic = false sound.Play("weapons/clipempty_pistol.wav",self:GetPos(),75,math.random(95,105),1) end return end
    if self:GetNextPrimaryFire() > CurTime() then return end
    if self.NextShoot and self.NextShoot > CurTime() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Wait)

	self:Shoot()

	if SERVER then
		net.Start("hgwep shoot")
		net.WriteEntity(self)
		net.SendOmit(self:GetOwner())
	end
end

function SWEP:PostStep()
end

function SWEP:GetRightMul()
	return self.RRightMul or 0
end

function SWEP:GetUpMul()
	return self.RUpMul or 1
end

function SWEP:Step()
	local ply = self:GetOwner()

	self:DrawWorldModel()

	if !IsValid(ply) or IsValid(ply) and ply:IsPlayer() and ply:GetActiveWeapon() != self then
		return
	end

	self:PostStep()

	if CLIENT and ply == LocalPlayer() then
		if self.NextShoot < CurTime() then
			RecoilDown = false
		else
			RecoilDown = true 
		end
	end

	local hand_index = ply:LookupBone("ValveBiped.Bip01_R_Hand")
	local forearm_index = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
	local clavicle_index = ply:LookupBone("ValveBiped.Bip01_R_Clavicle")
	
	local matrix = ply:GetBoneMatrix(hand_index)
	if not matrix then return end

	local plyang = ply:EyeAngles()
	plyang:RotateAroundAxis(plyang:Forward(),180)

	local _,newAng = LocalToWorld(vector_origin,self.localAng or angle_zero,vector_origin,plyang)
	local ang = Angle(newAng[1],newAng[2],newAng[3])

	if !self:IsSprinting() and !self:IsClose() and !self.reload then
		if self.PumpTarg and self.Pump <= 0.05 then
			matrix:SetAngles(ang - Angle(12 * (self.sprayI * self.RecoilForce * 1.5) * self:GetUpMul(),-1 * (self.sprayI * self.RecoilForce * 1.5) * self:GetRightMul(),0))
		elseif !self.PumpTarg then
			matrix:SetAngles(ang - Angle(12 * (self.sprayI * self.RecoilForce * 1.5) * self:GetUpMul(),-1 * (self.sprayI * self.RecoilForce * 1.5) * self:GetRightMul(),0))
		end
	end

	ply:SetBoneMatrix2(hand_index, matrix, false)
	
	self:Step_Spray()
	
	if CLIENT then
		self:Step_Anim()
	end
end

function SWEP:Think()
	self:Lobotomy_Sharik()
end

function SWEP:DrawWorldModel()
	if self.Bodygroups then
        for _, v in ipairs(self.Bodygroups) do
            if IsValid(self.worldModel) then
                self.worldModel:SetBodygroup(_,v)
            end
            self:SetBodygroup(_,v)
        end
    end

	if !IsValid(self.worldModel) and IsValid(self:GetOwner()) and self:GetOwner() != NULL then
		self:CreateWorldModel()
	end

	if !IsValid(self:GetOwner()) then
		self:DrawModel()
		if CLIENT then
    		self:DrawAttachments(self)
		end
		return
	end

	if IsValid(self:GetOwner()) and self:GetOwner():GetActiveWeapon() != self then
		self:WorldModel_Holster_Transform()
	else
		self:GetTrace()
		self:WorldModel_Transform()
		if CLIENT then
    		self:DrawAttachments()
		end
	end

	if CLIENT then
    	self:DrawAttachments()
	end
end

function SWEP:CreateWorldModel()
	if SERVER then
		local wm = ents.Create("prop_physics")
		/*if GetConVar("developer"):GetBool() then
			wm:SetNoDraw(false)
		else
			wm:SetNoDraw(true)
		end*/
		wm:SetModel(self.WorldModel)
		wm:SetMaterial("null")
		wm:Spawn()
		wm:GetPhysicsObject():EnableMotion(false)
		wm:PhysicsDestroy()
		wm:SetMoveType(MOVETYPE_NONE)
		wm:SetNWBool("nophys", true)
		wm:SetSolidFlags(FSOLID_NOT_SOLID)
		wm:AddEFlags(EFL_NO_DISSOLVE)
		wm:SetNoDraw(true)
        self:CallOnRemove("RemoveWM", function() wm:Remove() end)

		self.worldModel = wm

		return wm
	else
		local wm = ClientsideModel(self.WorldModel,RENDERGROUP_OPAQUE)

        self:CallOnRemove("RemoveWM", function() wm:Remove() end)
		self.worldModel = wm

		return wm
	end
end

hook.Add("Think", "Homigrad-Weapons", function()
	for wep in pairs(hg.Weapons) do
		if not IsValid(wep) or not wep.Step or not IsValid(wep:GetOwner()) then continue end
		wep:Step()
		//wep:DrawWorldModel()
	end
end)

if CLIENT then
	hook.Add("PostDrawOpaqueRenderables", "Homigrad-Weapons", function()
		for wep in pairs(hg.Weapons) do
			if not IsValid(wep) or !wep.DrawWorldModel then continue end
			//wep:DrawWorldModel()
		end
	end)
end