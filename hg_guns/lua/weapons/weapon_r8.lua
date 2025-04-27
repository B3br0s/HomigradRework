SWEP.Base = "homigrad_base"
SWEP.PrintName = "R8"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_pist_r8.mdl"

SWEP.CorrectPos = Vector(-15.5,-3.5,4.7)
SWEP.CorrectAng = Angle(0,0,0)

SWEP.Primary.DefaultClip = 8
SWEP.Primary.ClipSize = 8
SWEP.Primary.Ammo = ".50 Action Express"

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "v_weapon.hammer"
SWEP.BoltVec = Angle(0,0,-35)
SWEP.BoltManual = true
SWEP.BoltLock = false

SWEP.ZoomPos = Vector(-10,-4.5,-0.8)
SWEP.ZoomAng = Angle(0,-1,0)
SWEP.AttPos = Vector(29,0.15,2.85)
SWEP.AttAng = Angle(1,0.6,0)
SWEP.IsRevolver = true

SWEP.Primary.Damage = 85
SWEP.Primary.Force = 100
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Sound = "arccw_go/revolver/revolver-1_01.wav"
SWEP.Primary.HammerSound = "arccw_go/revolver/revolver_prepare.wav"

SWEP.IconPos = Vector(1,100,-5)
SWEP.IconAng = Angle(-20,0,0)
SWEP.progmul = 0

SWEP.ReloadSounds = {
    [0.55] = "arccw_go/revolver/revolver_siderelease.wav",
    [0.65] = "arccw_go/revolver/revolver_clipout.wav",
    [0.85] = "arccw_go/revolver/revolver_clipin.wav",
    [0.95] = "arccw_go/revolver/revolver_sideback.wav"
}

SWEP.ReloadSoundsEmpty = {
    [0.55] = "arccw_go/revolver/revolver_siderelease.wav",
    [0.65] = "arccw_go/revolver/revolver_clipout.wav",
    [0.85] = "arccw_go/revolver/revolver_clipin.wav",
    [0.95] = "arccw_go/revolver/revolver_sideback.wav"
}

local function easedLerp(fraction, from, to)
	return LerpFT(math.ease.InSine(fraction), from, to)
end

function SWEP:PostAnim()
	if self.BoltBone != nil and IsValid(self.worldModel) then
		local bone = self.worldModel:LookupBone(self.BoltBone)

		if self:Clip1() <= 0 and self.BoltLock then
			self.animmul = 1.5
		else
			self.animmul = easedLerp(0.45,self.animmul,0)
		end

		self.worldModel:ManipulateBoneAngles(bone,self.BoltVec * self.progmul)
	end

    local ply = self:GetOwner()

    if ply:KeyPressed(IN_ATTACK) then
        self:EmitSound("arccw_go/revolver/revolver_prepare.wav")
        self.kp = true
    elseif !ply:KeyDown(IN_ATTACK) then
        self.kp = false
        self.Shoted = false
    end

    if ply:KeyDown(IN_ATTACK) and !self.Shoted then
        self.progmul = math.Round(LerpFT(0.15,self.progmul,1.01),2)
    else
        self.progmul = math.Round(LerpFT(0.2,self.progmul,0),2)
    end

    if self.progmul >= 0.92 and !self.Shoted then
        self.Shoted = true
        self:PrimaryAttack()
        self.progmul = 0
    end
end

function SWEP:PrimaryAttack()
    if !self:CanShoot() then self:EmitSound("arccw_go/revolver/revolver_hammer.wav") return end
    if self:GetNextPrimaryFire() > CurTime() then return end
    if self.NextShoot and self.NextShoot > CurTime() then return end
    if !self.Shoted then return end
    self:Shoot()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Wait)

	if SERVER then
		net.Start("hgwep shoot")
		net.WriteEntity(self)
		net.Broadcast()
	end
end