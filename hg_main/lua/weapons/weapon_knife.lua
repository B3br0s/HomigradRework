SWEP.Base = "weapon_melee"
SWEP.Category = "Оружие - Ближний Бой"
SWEP.Spawnable = true
SWEP.PrintName = "Складной Ножик"
SWEP.Instructions = "Маленький ножик складного типа, который удобно носить в кармане. Хорошее средство для самообороны, которое никто не сможет увидеть, пока вы не достанете его из кармана."

SWEP.WorldModel = "models/weapons/w_jnife_jj.mdl"

SWEP.HoldType = "melee"

SWEP.Primary.Damage = 4
SWEP.DamageBleed = 4

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.4
SWEP.Primary.Force = 150

SWEP.FlashHitSound = "snd_jack_hmcd_slash.wav"

function SWEP:Attack(ent,obj,tr,dmginfo)
    if ent.Blooded then ent.Blooded = ent.Blooded + 5 end
end

SWEP.sndTwroh = {"weapons/melee/swing_fists_01.wav","weapons/melee/swing_fists_02.wav","weapons/melee/swing_fists_03.wav"}
SWEP.sndTwrohPitch = 255

SWEP.IconPos = Vector(14,80,-3)
SWEP.IconAng = Angle(0,0,0)
SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""