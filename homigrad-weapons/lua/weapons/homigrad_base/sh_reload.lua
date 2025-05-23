SWEP.Primary.ReloadTime = 1

SWEP.Empty3 = true
SWEP.Empty4 = true

SWEP.holdtypes = {
    ["revolver"] = {[1] = 0.3,[2] = 0.7,[3] = 1,[4] = 1.2},
    ["smg"] = {[1] = 0.45,[2] = 0.75,[3] = 0.85,[4] = 1.15},
    ["ar2"] = {[1] = 0.3,[2] = 0.8,[3] = 1.1,[4] = 1.3},
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
    if !IsValid(ply) then
        return
    end
    if ply:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then
        return
    end
    if self:Clip1() >= self.Primary.ClipSize then
        return
    end
    self.reload = CurTime() + self.Primary.ReloadTime
    
    if self:Clip1() > 0 then
        hg.PlayAnim(self,"reload")
    else
        hg.PlayAnim(self,"reload_empty")
    end

    if SERVER then
        net.Start("hg reload")
        net.WriteEntity(self)
        net.Broadcast()
    end
    
    timer.Simple(self.Primary.ReloadTime,function()
        if not IsValid(self) or not IsValid(self:GetOwner()) then return end
        local wep = self:GetOwner():GetActiveWeapon()
        if IsValid(self) and IsValid(ply) and (IsValid(wep) and wep or self:GetOwner().ActiveWeapon) == self then
            local oldclip = self:Clip1()
            self:SetClip1(math.Clamp(self:Clip1()+ply:GetAmmoCount( self:GetPrimaryAmmoType() ),0,self:GetMaxClip1()))
            local needed = self:Clip1()-oldclip
            ply:SetAmmo(ply:GetAmmoCount( self:GetPrimaryAmmoType() )-needed, self:GetPrimaryAmmoType())
            self.AmmoChek = 5
        end
        self.reload = nil
        if self.Animations then
            hg.PlayAnim(self,"idle",1,true)
        end
    end)

    if SERVER then
        local ply = self:GetOwner()

        if self.Reload1 then
            timer.Simple(self.holdtypes[self.HoldType][1], function()
                local ent = hg.GetCurrentCharacter(ply)
                if IsValid(ent) then
                    sound.Play(self.Reload1, ent:GetPos(), 90, 100, 0.8)
                end
            end)
        end

        if self.Reload2 then
            timer.Simple(self.holdtypes[self.HoldType][2], function()
                local ent = hg.GetCurrentCharacter(ply)
                if IsValid(ent) then
                    sound.Play(self.Reload2, ent:GetPos(), 90, 100, 0.8)
                end
            end)
        end

        if self.Reload3 and ((self.Empty3 and self:Clip1() == 0) or (not self.Empty3)) then
            timer.Simple(self.holdtypes[self.HoldType][3], function()
                local ent = hg.GetCurrentCharacter(ply)
                if IsValid(ent) then
                    sound.Play(self.Reload3, ent:GetPos(), 90, 100, 0.8)
                end
            end)
        end

        if self.Reload4 and ((self.Empty4 and self:Clip1() == 0) or (not self.Empty4)) then
            timer.Simple(self.holdtypes[self.HoldType][4], function()
                local ent = hg.GetCurrentCharacter(ply)
                if IsValid(ent) then
                    sound.Play(self.Reload4, ent:GetPos(), 90, 100, 0.8)
                end
            end)
    end
end
end

function SWEP:Reload()
    self:ReloadFunc()
end

function SWEP:Step_Reload()
end