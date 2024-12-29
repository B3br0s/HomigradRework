SWEP.PrintName = "Combat Knife"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Spawnable = true
SWEP.Base = 'hg_melee'

SWEP.WorldModel = "models/weapons/w_jmod_combatknife.mdl"
SWEP.ViewModel =  "models/weapons/w_jmod_combatknife.mdl"

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = "none"

SWEP.HardAttack = false
SWEP.Damage = 45
SWEP.DamageType = DMG_SLASH
SWEP.Delay = 0.6
SWEP.StaminaCost = 1
SWEP.CustomAnim = true
SWEP.HoldType = "knife"
SWEP.TimeUntilHit = 0.2
SWEP.TwoHanded = false
SWEP.ShouldDecal = true
SWEP.DeploySound = {"weapons/melee/melee_draw_temp1.wav","weapons/melee/melee_draw_temp2.wav"}
SWEP.HolsterSound = {"weapons/melee/melee_holster_temp1.wav","weapons/melee/melee_holster_temp2.wav"}
SWEP.SwingSound = {"weapons/melee/swing_light_sharp_01.wav","weapons/melee/swing_light_sharp_02.wav","weapons/melee/swing_light_sharp_03.wav"}
SWEP.HitFleshSound = {"snd_jack_hmcd_knifestab.wav"}
SWEP.HitSound = {"weapons/melee/metal_solid_impact_bullet1.wav","weapons/melee/metal_solid_impact_bullet2.wav","weapons/melee/metal_solid_impact_bullet3.wav","weapons/melee/metal_solid_impact_bullet4.wav"}

SWEP.AnimLerpLC = Angle(0,0,0)
SWEP.AnimLerpLF = Angle(0,0,0)
SWEP.AnimLerpLH = Angle(0,0,0)

SWEP.AnimLerpRC = Angle(0,0,0)
SWEP.AnimLerpRF = Angle(0,0,0)
SWEP.AnimLerpRH = Angle(0,0,0)

SWEP.CorrectPosX =     -7.5
SWEP.CorrectPosY =     1
SWEP.CorrectPosZ =     0

SWEP.CorrectAngPitch = -25
SWEP.CorrectAngYaw =   -90
SWEP.CorrectAngRoll =  0

SWEP.CorrectSize = 1

function SWEP:Think()
    self:SetHoldType(self.HoldType)

    if self.Anim1 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(-80,60,0))
        self.AnimLerpRF = LerpAngleFT(0.1,self.AnimLerpRF,Angle(70,0,50))
        self.AnimLerpRH = LerpAngleFT(0.1,self.AnimLerpRH,Angle(-30,-0,0))
    elseif self.Anim2 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.6,self.AnimLerpRC,Angle(0,0,-70))
        self.AnimLerpRF = LerpAngleFT(0.6,self.AnimLerpRF,Angle(0,30,0))
        self.AnimLerpRH = LerpAngleFT(0.6,self.AnimLerpRH,Angle(90,0,0))
    elseif self.Anim3 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)

        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(0,0,0))
        self.AnimLerpRF = LerpAngleFT(0.6,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.3,self.AnimLerpRH,Angle(0,0,0))
    end

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(20,20, 30) + self.AnimLerpRC, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0,-30,0) + self.AnimLerpRF, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,30,30) + self.AnimLerpRH, true)

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(0,0,0))
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger01"),Angle(0,20,0))
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger1"),Angle(0,-30,0))
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger11"),Angle(0,-50,0))
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger2"),Angle(0,-30,0))
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Finger21"),Angle(0,-50,0))

	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0, 10, -25) + self.AnimLerpLC, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 40, 0) + self.AnimLerpLF, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(20, 0, 0) + self.AnimLerpLH, true)

    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine4"), Angle(0,-20, 0), true)
end