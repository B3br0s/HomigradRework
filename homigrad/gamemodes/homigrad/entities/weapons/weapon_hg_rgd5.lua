SWEP.Base = "weapon_hg_granade_base"

SWEP.PrintName = "RGD-5"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Наступательная ручная граната, относится к противопехотным осколочным ручным гранатам дистанционного действия наступательного типа."
SWEP.Category = "Гранаты"
SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true
SWEP.RequiresPin = true
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/rgd5' )
SWEP.BounceWeaponIcon = false
end
SWEP.PinOut = false
SWEP.PinSound = "weapons/tfa_csgo/flashbang/pinpull.wav"
SWEP.Leveractivatedonce = false
SWEP.a = 1
SWEP.LeverProebal = false

SWEP.ViewModel = "models/pwb/weapons/w_rgd5.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_rgd5.mdl"

SWEP.Granade = "ent_hgjack_rgd5nade"