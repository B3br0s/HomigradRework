SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие: Ближний Бой"
SWEP.Spawnable = true
SWEP.PrintName = "Байонет"

SWEP.WorldModel = "models/weapons/insurgency/w_marinebayonet.mdl"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.HoldType = "knife"

SWEP.Primary.Damage = 37
SWEP.DamageBleed = -30

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.65
SWEP.Primary.Force = 240

SWEP.IconPos = Vector(13.5,100,-6)
SWEP.IconAng = Angle(60,0,0)
SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""

function SWEP:dmgTabPost(ent,dmgTab)
    if ent:IsPlayer() then FakeDown(ent) end
end

SWEP.sndTwroh = {"weapons/melee/swing_fists_01.wav","weapons/melee/swing_fists_02.wav","weapons/melee/swing_fists_03.wav"}