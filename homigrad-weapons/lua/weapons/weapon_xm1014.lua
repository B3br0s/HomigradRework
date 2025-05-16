SWEP.Base = "homigrad_base"
SWEP.PrintName = "XM1014"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Дробовики"
SWEP.WorldModel = "models/weapons/arccw_go/v_shot_m1014.mdl"

SWEP.CorrectPos = Vector(-11.5,-4.9,7.6)
SWEP.CorrectAng = Angle(0,3,0)
SWEP.HoldType = "ar2"
SWEP.TwoHands = true

SWEP.HolsterPos = Vector(-20,-1,8)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.BoltBone = "v_weapon.xm1014_Bolt"
SWEP.BoltVec = Vector(0,0,-2.3)
SWEP.BoltLock = true

SWEP.ZoomPos = Vector(10,-4.32,-2.75)
SWEP.ZoomAng = Angle(0,1.35,0.02)
SWEP.AttPos = Vector(-2,0,0)
SWEP.AttAng = Angle(0,0.75,0)

SWEP.MuzzlePos = Vector(36,4.15,-4)
SWEP.MuzzleAng = Angle(0,0,0)

SWEP.IsShotgun = true
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Damage = 17.5
SWEP.Primary.Wait = 0.2
SWEP.Primary.ReloadTime = 1
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Primary.Damage = 23
SWEP.Primary.Force = 75
SWEP.Primary.Sound = "pwb2/weapons/m4super90/xm1014-1.wav"//{"zcitysnd/sound/weapons/firearms/shtg_winchestersx3/shotgun_semiauto_fire1.wav","zcitysnd/sound/weapons/firearms/shtg_winchestersx3/shotgun_semiauto_fire2.wav"}
SWEP.InsertSound = "pwb2/weapons/m4super90/shell.wav"
SWEP.NumBullet = 8
SWEP.RecoilForce = 7.5

SWEP.IconPos = Vector(-4.25,50,-4)
SWEP.IconAng = Angle(-20,0,0)

function SWEP:ReloadFunc()
    self.AmmoChek = 5
    if self.reload then
        self.NextShoot = CurTime() + 1
        return
    end
    local ply = self:GetOwner()
    if ply:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then
        return
    end
    if self:Clip1() >= self.Primary.ClipSize or self:Clip1() >= self:GetMaxClip1() then
        return
    end

    self.reload = CurTime() + self.Primary.ReloadTime

    self.NextShoot = CurTime() + 1
    
    if SERVER then
        net.Start("hg reload")
        net.WriteEntity(self)
        net.Broadcast()
    end

    ply:SetAnimation(PLAYER_RELOAD)

    if not IsValid(self) or not IsValid(self:GetOwner()) then return end
        local wep = self:GetOwner():GetActiveWeapon()
        if IsValid(self) and IsValid(ply) and (IsValid(wep) and wep or self:GetOwner().ActiveWeapon) == self then
            self.AmmoChek = 5
            self:SetHoldType(self.HoldType)
            timer.Simple(self.Primary.ReloadTime,function()
                if SERVER then
                    if self:Clip1() == 0 and self.BoltLock then
                        timer.Simple(0.3,function()
                            self:SetClip1(math.Clamp(self:Clip1()+1,0,self:GetMaxClip1()))
                            sound.Play("weapons/shotgun/shotgun_cock_forward.wav",self:GetPos(),80,math.random(95,105))
                        end)
                    else
                        self:SetClip1(math.Clamp(self:Clip1()+1,0,self:GetMaxClip1()))
                    end
                end

                ply:SetAmmo(ply:GetAmmoCount( self:GetPrimaryAmmoType() )-1, self:GetPrimaryAmmoType())

                if SERVER then
                    sound.Play(self.InsertSound,self:GetPos(),95,math.random(95,105),0.75)
                end

                self.reload = nil

                if ply:GetAmmoCount( self:GetPrimaryAmmoType()) != 0 and self:Clip1() != self:GetMaxClip1() then                    
                    ply:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
    
                    ply:SetAnimation(PLAYER_IDLE)
                end
            end)
        end
end