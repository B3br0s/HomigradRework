do return end
SWEP.Base = "homigrad_base"
SWEP.PrintName = "R8"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Пистолеты"
SWEP.WorldModel = "models/weapons/arccw_go/v_pist_r8.mdl"

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(-13,-5.25,5)

SWEP.Primary.DefaultClip = 8
SWEP.Primary.ClipSize = 8
SWEP.Primary.Ammo = ".50 Action Express"

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "v_weapon.hammer"
SWEP.CylBone = "v_weapon.cylinder"
SWEP.BoltVec = Angle(0,0,-35)
SWEP.BoltManual = true
SWEP.BoltLock = false

SWEP.ZoomPos = Vector(3,-3.74,0.06)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(0,0.04,-0.4)
SWEP.AttAng = Angle(0,0.7,0)
SWEP.MuzzlePos = Vector(23.5,3.85,-1.4)
SWEP.MuzzleAng = Angle(0,0,0)
SWEP.IsRevolver = true

SWEP.Primary.Damage = 85
SWEP.Primary.Force = 100
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Sound = "arccw_go/revolver/revolver-1_01.wav"
SWEP.Primary.HammerSound = "arccw_go/revolver/revolver_prepare.wav"
SWEP.RecoilForce = 25

SWEP.RRightMul = 0.5

SWEP.IconPos = Vector(1,100,-5)
SWEP.IconAng = Angle(-20,0,0)
SWEP.Shoted = false

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
    self.worldModel:ManipulateBoneAngles(self.worldModel:LookupBone(self.BoltBone), Angle(0, 0, -35) * self.animmul)
end

function SWEP:PostStep()
    local ply = self:GetOwner()

    local k = math.max((self.AttackStart or CurTime() + 0.15) - CurTime(),0) / 0.15

    k = math.Round(k,2)

    if ply:KeyDown(IN_ATTACK) then
        if !self.WasAttacked then
            self.WasAttacked = true

            self.AttackStart = CurTime() + (SERVER and 0.16 or 0.15)

            sound.Play("arccw_go/revolver/revolver_prepare.wav",self:GetPos(),80,100,0.6)
        end

        self.animmul = (1 - k)

        if k == 0 and !self.Shoted then
            self.Shoted = true
            self:Shoot()
        elseif k == 0 and self.Shoted then
            self.animmul = 0
        end
    else
        self.animmul = LerpFT(0.2,self.animmul,0)
        self.WasAttacked = false
        self.AttackStart = nil
        self.Shoted = false
    end
end

function SWEP:Smooth(value)
	if self.NextShoot + 0.125 > CurTime() then
        return 0.02
    end
    return math.ease.InSine(value) + math.max(math.ease.InElastic(value) - 0.6,0)
end

function SWEP:PrimaryAttack()
end