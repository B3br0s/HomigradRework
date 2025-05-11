SWEP.Primary.ReloadTime = 1.3

SWEP.holdtypes = {
    ["revolver"] = {[1] = 0.45,[2] = 0.85,[3] = 0.95,[4] = 1.15},
    ["smg"] = {[1] = 0.45,[2] = 0.75,[3] = 0.85,[4] = 1.15},
    ["ar2"] = {[1] = 0.5,[2] = 0.8,[3] = 1.1,[4] = 1.3},
}

if SERVER then
    util.AddNetworkString("hg reload")
else
    net.Receive("hg reload",function()
        local ent = net.ReadEntity()
        if IsValid(ent) and ent.Reload then
        ent:Reload()
        end
    end)
end

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

function SWEP:Reload()
    self:ReloadFunc()
end