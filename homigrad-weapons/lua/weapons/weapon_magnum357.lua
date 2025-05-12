SWEP.Base = "homigrad_base"
SWEP.PrintName = ".357 Magnum"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Half-Life"
SWEP.WorldModel = "models/sirgibs/hl2/weapons/357.mdl"

SWEP.CorrectAng = Angle(0,0,0)
SWEP.CorrectPos = Vector(1.8,-1.5,-0.3)
SWEP.HolsterPos = Vector(-7,0,2)
SWEP.HolsterAng = Angle(0,-45,-90)
SWEP.BoltBone = "Hammer"
SWEP.BoltVec = Angle(0,0,-45)

SWEP.IsRevolver = true

SWEP.ZoomPos = Vector(-6,0.025,5.33)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(-2,0,0)
SWEP.AttAng = Angle(0,0.4,0)
SWEP.MuzzlePos = Vector(12,0,4)
SWEP.MuzzleAng = Angle(0,0,0)
SWEP.Empty3 = false
SWEP.Empty4 = false

SWEP.Primary.DefaultClip = 6
SWEP.Primary.ClipSize = 6
SWEP.Primary.Damage = 45
SWEP.Primary.Force = 15
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Wait = 0.5
SWEP.Primary.Sound = {"weapons/357/357_fire1.wav","weapons/357/357_fire2.wav","weapons/357/357_fire3.wav"}
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.RecoilForce = 8

SWEP.IconPos = Vector(13.5,100,-5)
SWEP.IconAng = Angle(0,0,0)

SWEP.Reload1 = "weapons/357/357_reload1.wav"
SWEP.Reload2 = "weapons/357/357_reload2.wav"
SWEP.Reload3 = "weapons/357/357_reload3.wav"
SWEP.Reload4 = "weapons/357/357_reload4.wav"

function SWEP:PostAnim()
	if self.BoltBone and IsValid(self.worldModel) and self.BoltVec != nil then
		local bone = self.worldModel:LookupBone(self.BoltBone)

		self.animmul = LerpFT(0.15,self.animmul,0)

		self.worldModel:ManipulateBoneAngles(bone,self.BoltVec * (1 - self.animmul))
	end
end