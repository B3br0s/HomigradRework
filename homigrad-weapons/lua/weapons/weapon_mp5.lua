SWEP.Base = "homigrad_base"
SWEP.PrintName = "MP5"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Пистолеты-Пулемёты"
SWEP.WorldModel = "models/weapons/arccw_go/v_smg_mp5.mdl"

SWEP.CorrectPos = Vector(-12.5,-5.8,8)
SWEP.CorrectAng = Angle(0,2,0)

SWEP.HolsterPos = Vector(-18,-2,9)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.BoltBone = "v_weapon.bolt"
SWEP.BoltVec = Vector(-0.1,3.4,0)

SWEP.ZoomPos = Vector(13,-5.215,-1.7)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(-5,-0.015,0.15)
SWEP.AttAng = Angle(0,0.8,0.2)
SWEP.MuzzlePos = Vector(33.5,5.15,-4)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.Primary.DefaultClip = 25
SWEP.Primary.ClipSize = 25
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 5
SWEP.Primary.ReloadTime = 1.25
SWEP.Primary.Sound = "pwb/weapons/mp7/shoot.wav"
SWEP.Primary.Ammo = "9x19 mm Parabellum"
SWEP.HoldType = "ar2"
SWEP.Primary.Automatic = true
SWEP.Primary.Wait = 0.07
SWEP.TwoHands = true
SWEP.RecoilForce = 1
SWEP.BoltManual = true
SWEP.Bodygroups = {[1] = 0,[2]=0,[3]=0,[4]=1,[5]=1}

SWEP.Empty3 = false
SWEP.Empty4 = false

SWEP.IconPos = Vector(-2,60,-5)
SWEP.IconAng = Angle(-20,0,0)
SWEP.mul_reload = 0
SWEP.mul_reload2 = 0

SWEP.Reload1 = "arccw_go/mp5/mp5_slideback.wav"
SWEP.Reload2 = "arccw_go/mp5/mp5_clipout.wav"
SWEP.Reload3 = "arccw_go/mp5/mp5_clipin.wav"
SWEP.Reload4 = "arccw_go/mp5/mp5_slideforward.wav"

local function easedLerp(fraction, from, to)
	return LerpFT(math.ease.InSine(fraction), from, to)
end

function SWEP:PostAnim()
	if self.BoltBone and IsValid(self.worldModel) then
		local bone = self.worldModel:LookupBone(self.BoltBone)

		if self:Clip1() <= 0 and self.BoltLock then
			self.animmul = 1.5
		else
			self.animmul = easedLerp(0.45,self.animmul,0)
		end

		self.worldModel:ManipulateBonePosition(bone,self.BoltVec * self.mul_reload)
		self.worldModel:ManipulateBoneAngles(bone,Angle(-90,0,0) * self.mul_reload2)
	end

    if self.reload then
        local reload_time = self.reload - CurTime()
        if reload_time < 0.2 then
            self.mul_reload = LerpFT(0.7, self.mul_reload, 0)
        elseif reload_time < 0.27 then
            self.mul_reload2 = LerpFT(0.6, self.mul_reload2, 0)
        elseif reload_time < 0.8 then
            self.mul_reload2 = LerpFT(0.3, self.mul_reload2, 1)
        elseif reload_time < 0.9 then
            self.mul_reload = LerpFT(0.3, self.mul_reload, 1)
        end
    end
end