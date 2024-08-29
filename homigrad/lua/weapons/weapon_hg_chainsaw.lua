if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = "weapon_hg_melee_base"

SWEP.PrintName = "Бензопила"
SWEP.Category = "Ближний Бой"
SWEP.Instructions = "Зачем другие оружия если есть бензопила которая делает БРБРБРБРБРБРБРБРБРБР"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/w_chainsaw.mdl"
SWEP.WorldModel = "models/weapons/w_chainsaw.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true

SWEP.HoldTypeWep = "AR2"

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Primary.Damage = 5
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.05
SWEP.Primary.Force = 100

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawSound = "weapons/melee/chainsaw_start_01.wav"
SWEP.HitSound = "weapons/melee/metal_solid_impact_bullet1.wav"
SWEP.FlashHitSound = "weapons/melee/flesh_impact_sharp_04.wav"
SWEP.ShouldDecal = true
SWEP.DamageType = DMG_SLASH
end