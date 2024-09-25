local SWEP = oop.Get("hg_wep")
if not SWEP then return end

SWEP.itemType = "weapon"

SWEP.Slot					= 2
SWEP.SlotPos				= 0

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Tracer = 1
SWEP.ChamberAuto = true

/*
	0 пусто
	1 вставлен
	2 выстрелен
*/

SWEP.Primary.Ammo			= "rifle"
SWEP.Shell = "EjectBrass_556"
SWEP.HoldType = "ar2"

SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 45
SWEP.Primary.DamageDisK = {
	{3000,1},
	{16000,0.75}
}

SWEP.Primary.Spread = 0
SWEP.Primary.Force = 0

SWEP.ScopeLerp = 0.2
SWEP.ScopeLerpOut = 0.25

SWEP.CR3 = 3
SWEP.CHandUp = 0

SWEP.CRL = 0.25
SWEP.CRL_Scope = 0.25
SWEP.CR = 3
SWEP.CR_Scope = 3

SWEP.MuzzlePos = Vector(0,0,0)
SWEP.CameraPos = Vector(-20,0,0)

SWEP.CFightVec = Vector(0,0,0)
SWEP.CFightAng = Angle(0,0,0)

--SWEP.CImersiveSetL
--SWEP.CImersiveSetL_Scope

--SWEP.CImersiveL
--SWEP.CImersiveL_Scope

SWEP.vbw = true
SWEP.vbwPos = Vector(0,0,0)
SWEP.vbwAng = Angle(0,0,0)

SWEP.EnableTransformModel = true