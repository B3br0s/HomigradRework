SWEP.Base = "weapon_hg_granade_base"

SWEP.PrintName = "Неизвестный Напиток"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Какие то неизвестные надписи на этикетке"
SWEP.Category = "Вкусности"
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

SWEP.ViewModel = "models/foodnhouseholditems/sodacan01.mdl"
SWEP.WorldModel = "models/foodnhouseholditems/sodacan01.mdl"

SWEP.Granade = "ent_jack_gmod_ezimpactnadeiraq"