SWEP.Base = "homigrad_base"
SWEP.PrintName = "MAG 7"
SWEP.Spawnable = true
SWEP.Category = "Оружие - Огнестрел"
SWEP.WorldModel = "models/weapons/arccw_go/v_shot_mag7.mdl"
SWEP.Pumped = true

SWEP.CorrectPos = Vector(-15.5,-2.5,5.3)
SWEP.CorrectAng = Angle(0,0,0)

SWEP.HolsterPos = Vector(-6,-16,0)
SWEP.HolsterAng = Angle(0,45,-90)
SWEP.BoltBone = "v_weapon.pump"
SWEP.BoltVec = Vector(0,0,-1.5)
SWEP.BoltManual = true

SWEP.ZoomPos = Vector(-5.5,0.3,3.97)
SWEP.AttPos = Vector(0,0,3.5)
SWEP.AttAng = Angle(0,0,0)

SWEP.Primary.Damage = 25
SWEP.Primary.Sound = "arccw_go/mag7/mag7_01.wav"

function SWEP:Reload()
    if self:CanPrimaryAttack() then
        if !self.Pumped then
            self.Pumped = true
        else
            --self:MainReloadFunc()
        end
    end 
end

function SWEP:PrimaryAdd()
    self.Pumped = false
end 