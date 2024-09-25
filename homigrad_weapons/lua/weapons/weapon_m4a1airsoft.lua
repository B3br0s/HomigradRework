if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "M4A1 Airsoft"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Страйкбольная Автоматическая Винтовка"
SWEP.Category 				= "Оружие"


SWEP.Spawnable 				= false
SWEP.AdminOnly 				= false
SWEP.IconkaInv = "vgui/weapon_csgo_m4a1.png"

------------------------------------------

SWEP.Primary.ClipSize		= 120
SWEP.Primary.DefaultClip	= 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Airsoft Balls"
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 0.0001
SWEP.Primary.Spread = 4
SWEP.RubberBullets = true
SWEP.Primary.Sound = "weapons/shotgun/shotgun_empty.wav"
SWEP.Primary.Force = 0
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.1
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true
SWEP.Efect = "PhyscannonImpact"
SWEP.Supressed = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb2/weapons/w_m4a1.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_m4a1.mdl"

SWEP.vbwPos = Vector(-2,-3.7,2)
SWEP.vbwAng = Angle(5,-30,0)

SWEP.OffsetVec = Vector(10,-2.6,2)
end