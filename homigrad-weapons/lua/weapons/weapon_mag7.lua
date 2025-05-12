//do return end
SWEP.Base = "weapon_870"
SWEP.PrintName = "MAG-7"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Дробовики"
SWEP.WorldModel = "models/weapons/arccw_go/v_shot_mag7.mdl"

SWEP.CorrectPos = Vector(-19.9,-7.25,9.5)
SWEP.CorrectAng = Angle(0,2,0)
SWEP.CorrectScale = 1.05
SWEP.HoldType = "ar2"

SWEP.HolsterPos = Vector(-13,-1,8)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.BoltBone = "v_weapon.pump"
SWEP.BoltVec = Vector(0,0,-2)

SWEP.ZoomPos = Vector(12.5,-6.45,-3.45)
SWEP.ZoomAng = Angle(0,0,0)
SWEP.AttPos = Vector(0,0.18,-0.1)
SWEP.AttAng = Angle(0,1,0)
SWEP.MuzzlePos = Vector(43,6.6,-5.3)

SWEP.IsShotgun = false
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Damage = 17.5
SWEP.Primary.Wait = 0.09
SWEP.Primary.Automatic = false
SWEP.Primary.Force = 45
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/shtg_mossberg500/m500_fire_01.wav"
SWEP.RecoilForce = 30

SWEP.IconPos = Vector(-7,50,-4)
SWEP.IconAng = Angle(-20,0,0)

SWEP.Reload1 = "arccw_go/mag7/mag7_clipout.wav"
SWEP.Reload2 = "arccw_go/mag7/mag7_clipin.wav"
SWEP.Reload3 = "arccw_go/mag7/mag7_pump_back.wav"
SWEP.Reload4 = "arccw_go/mag7/mag7_pump_forward.wav"

function SWEP:ReloadFunc()
    self.AmmoChek = 5
    if self.reload then
        return
    end
    local ply = self:GetOwner()
    if ply:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then
        return
    end
    if self:Clip1() >= self.Primary.ClipSize then
        return
    end
    self.reload = CurTime() + self.Primary.ReloadTime
    local IsPistol = self.HoldType == "revolver"
    if IsPistol then
        self:SetHoldType("pistol")

        timer.Simple(0,function()
            ply:SetAnimation(PLAYER_RELOAD)
        end)
    else
        ply:SetAnimation(PLAYER_RELOAD)
    end

    local seq = ply:LookupSequence("reload_"..self:GetHoldType())
    if seq and seq > 0 then
        ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, seq, 0, true)
    end

    if SERVER then
        net.Start("hg reload")
        net.WriteEntity(self)
        net.Broadcast()
    end
    timer.Simple(self.Primary.ReloadTime,function()
        ply:SetSequence(1)
        if not IsValid(self) or not IsValid(self:GetOwner()) then return end
        local wep = self:GetOwner():GetActiveWeapon()
        if IsValid(self) and IsValid(ply) and (IsValid(wep) and wep or self:GetOwner().ActiveWeapon) == self then
            local oldclip = self:Clip1()
            self:SetClip1(math.Clamp(self:Clip1()+ply:GetAmmoCount( self:GetPrimaryAmmoType() ),0,self:GetMaxClip1()))
            local needed = self:Clip1()-oldclip
            ply:SetAmmo(ply:GetAmmoCount( self:GetPrimaryAmmoType() )-needed, self:GetPrimaryAmmoType())
            self.AmmoChek = 5
            self:SetHoldType(self.HoldType)
        end
        self.reload = nil
    end)

    if SERVER then
        if self.Reload1 then
            timer.Simple(self.holdtypes[self.HoldType][1],function()
                sound.Play(self.Reload1,self.worldModel:GetPos(),90,100,0.8)
            end)
        end
        if self.Reload2 then
            timer.Simple(self.holdtypes[self.HoldType][2],function()
                sound.Play(self.Reload2,self.worldModel:GetPos(),90,100,0.8)
            end)
        end
        if self.Reload3 and (self.Empty3 and self:Clip1() == 0 or !self.Empty3 and true) then
            timer.Simple(self.holdtypes[self.HoldType][3],function()
                sound.Play(self.Reload3,self.worldModel:GetPos(),90,100,0.8)
            end)
        end
        if self.Reload4 and (self.Empty4 and self:Clip1() == 0 or !self.Empty4 and true) then
            timer.Simple(self.holdtypes[self.HoldType][4],function()
                sound.Play(self.Reload4,self.worldModel:GetPos(),90,100,0.8)
            end)
        end
    else
        timer.Simple(self.holdtypes[self.HoldType][2] + 0.3,function()
            if self:Clip1() != 0 and self.Empty3 then
                ply:SetLayerPlaybackRate(GESTURE_SLOT_ATTACK_AND_RELOAD, 1)
                ply:SetLayerWeight(GESTURE_SLOT_ATTACK_AND_RELOAD, 0.3)
            end
        end)
    end

    /*timer.Simple(self.Primary.ReloadTime,function()
        if ply:GetOwner():GetActiveWeapon() == self then
            self.reload = nil
            ply:RemoveAmmo(self:GetMaxClip1() - self:Clip1(),self:GetPrimaryAmmoType())
        end
    end)*/
end