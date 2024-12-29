SWEP.PrintName = "Труба"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Spawnable = true
SWEP.Base = 'hg_melee'

SWEP.WorldModel = "models/weapons/me_pipe_lead/w_me_pipe_lead.mdl"
SWEP.ViewModel =  "models/weapons/me_pipe_lead/w_me_pipe_lead.mdl"

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
SWEP.DamageType = DMG_CLUB
SWEP.Delay = 1
SWEP.StaminaCost = 6
SWEP.CustomAnim = true
SWEP.HoldType = "knife"
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

SWEP.CorrectPosX =     2
SWEP.CorrectPosY =     1.4
SWEP.CorrectPosZ =     -2

SWEP.CorrectAngPitch = 0
SWEP.CorrectAngYaw =   180
SWEP.CorrectAngRoll =  90

SWEP.CorrectSize = 1

function SWEP:Think()
    self:SetHoldType(self.HoldType)

    if self.Anim1 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)
    
        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(-80,80,0))
        self.AnimLerpRF = LerpAngleFT(0.1,self.AnimLerpRF,Angle(70,30,50))
        self.AnimLerpRH = LerpAngleFT(0.1,self.AnimLerpRH,Angle(50,0,-50))
    elseif self.Anim2 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)
    
        self.AnimLerpRC = LerpAngleFT(1.9,self.AnimLerpRC,Angle(0,0,-70))
        self.AnimLerpRF = LerpAngleFT(1.9,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(1.9,self.AnimLerpRH,Angle(0,0,0))
    elseif self.Anim3 then
        self.AnimLerpLC = Angle(0,0,0)
        self.AnimLerpLF = Angle(0,0,0)
        self.AnimLerpLH = Angle(0,0,0)
    
        self.AnimLerpRC = LerpAngleFT(0.1,self.AnimLerpRC,Angle(0,0,0))
        self.AnimLerpRF = LerpAngleFT(0.6,self.AnimLerpRF,Angle(0,0,0))
        self.AnimLerpRH = LerpAngleFT(0.3,self.AnimLerpRH,Angle(0,0,0))
    end
    
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(20,20,0) + self.AnimLerpRC, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0,-20,0) + self.AnimLerpRF, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,0,30) + self.AnimLerpRH, true)
    
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(30, -30, 0) + self.AnimLerpLC, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(10, 90, 0) + self.AnimLerpLF, true)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"), Angle(30, -20, 0) + self.AnimLerpLH, true)
    
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_Spine4"), Angle(0,-20,0), true)
end