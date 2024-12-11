SWEP.PrintName = "Деревянная Бита"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Spawnable = true
SWEP.Base = 'hg_melee'

SWEP.WorldModel = "models/weapons/w_knije_t.mdl"
SWEP.ViewModel =  "models/weapons/w_knije_t.mdl"

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = "none"

SWEP.HardAttack = false
SWEP.Damage = 35
SWEP.DamageType = DMG_CLUB
SWEP.Delay = 1
SWEP.StaminaCost = 5
SWEP.CustomAnim = true
SWEP.HoldType = "melee2"
SWEP.TimeUntilHit = 0.2
SWEP.TwoHanded = true
SWEP.ShouldDecal = false
SWEP.DeploySound = {"weapons/melee/melee_draw_temp1.wav","weapons/melee/melee_draw_temp2.wav"}
SWEP.HolsterSound = {"weapons/melee/melee_holster_temp1.wav","weapons/melee/melee_holster_temp2.wav"}
SWEP.SwingSound = {"weapons/melee/swing_heavy_blunt_01.wav","weapons/melee/swing_heavy_blunt_02.wav"}
SWEP.HitFleshSound = {"weapons/melee/flesh_impact_blunt_05.wav","weapons/melee/flesh_impact_blunt_06.wav","weapons/melee/flesh_impact_blunt_01.wav"}
SWEP.HitSound = {"weapons/shove_hit.wav"}

SWEP.AnimLerpLC = Angle(0,0,0)
SWEP.AnimLerpLF = Angle(0,0,0)
SWEP.AnimLerpLH = Angle(0,0,0)

SWEP.AnimLerpRC = Angle(0,0,0)
SWEP.AnimLerpRF = Angle(0,0,0)
SWEP.AnimLerpRH = Angle(0,0,0)

SWEP.CorrectPosX =     -1.5
SWEP.CorrectPosY =     1
SWEP.CorrectPosZ =     -2

SWEP.CorrectAngPitch = -25
SWEP.CorrectAngYaw =   0
SWEP.CorrectAngRoll =  180

SWEP.CorrectSize = 1.3

function SWEP:Think()
    self:SetHoldType(self.HoldType)

    if CLIENT and IsValid(self:GetOwner()) then
		self:CreateClientsideModel()
	
		local weaponRef = self
	
		hook.Add("PostDrawOpaqueRenderables", "DrawSWEPWorldModel_" .. self:EntIndex(), function()
			if IsValid(weaponRef) and weaponRef.DrawClientModel then
				weaponRef:DrawClientModel()
			else
				hook.Remove("PostDrawOpaqueRenderables", "DrawSWEPWorldModel_" .. weaponRef:EntIndex())
			end
		end)
	
	elseif CLIENT and not IsValid(self:GetOwner()) then
		hook.Remove("PostDrawOpaqueRenderables", "DrawSWEPWorldModel_" .. self:EntIndex())
	end

    if self.Anim1 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(0,0,90))
        self.AnimLerpRF = LerpAngleFT(0.1,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.1,self.AnimLerpRH,Angle(0,-50,0))
    elseif self.Anim2 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.6,self.AnimLerpRC,Angle(40,0,0))
        self.AnimLerpRF = LerpAngleFT(0.6,self.AnimLerpRF,Angle(-40,60,0))
        self.AnimLerpRH = LerpAngleFT(0.6,self.AnimLerpRH,Angle(-50,0,90))
    elseif self.Anim3 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(0,0,0))
        self.AnimLerpRF = LerpAngleFT(0.6,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.3,self.AnimLerpRH,Angle(0,0,0))
    end

	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(0,-30, 0) + self.AnimLerpRC, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0,0,0) + self.AnimLerpRF, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,-40,-40) + self.AnimLerpRH, true)

	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0, 0, 0) + self.AnimLerpLC, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0) + self.AnimLerpLF, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0) + self.AnimLerpLH, true)
end