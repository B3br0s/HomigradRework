SWEP.Primary.ReloadTime = 2
SWEP.ReloadSounds = {
}
SWEP.ReloadSoundsEmpty = {
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
    end)

    /*timer.Simple(self.Primary.ReloadTime,function()
        if ply:GetOwner():GetActiveWeapon() == self then
            self.reload = nil
            ply:RemoveAmmo(self:GetMaxClip1() - self:Clip1(),self:GetPrimaryAmmoType())
        end
    end)*/
end

function SWEP:Reload_Step()
    local ply = self:GetOwner()
    if self.reload and self.reload > CurTime() then 
        local rtime = self.Primary.ReloadTime
        local rt = self.reload - CurTime()
        local time = math.Round(rt,1)
        local dima = (rtime - time)

        if not self.SoundsPlayed then
            self.SoundsPlayed = {}
        end

        local IsPistol = self.HoldType == "revolver"

        if IsPistol then
            ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"),Angle(0,0,0))
	        ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Upperarm"),Angle(0,0,0))
            ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),Angle(-60,0,0))
            ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),Angle(-60,50,0))
        end
        
        if self:Clip1() > 0 then
            if self.ReloadSounds[dima] != nil and !self.SoundsPlayed[dima] then
                if CLIENT then
                    self:EmitSound(self.ReloadSounds[dima])
                end
                self.SoundsPlayed[dima] = true
            end
        else
            if self.ReloadSoundsEmpty[dima] != nil and !self.SoundsPlayed[dima] then
                if CLIENT then
                    self:EmitSound(self.ReloadSoundsEmpty[dima])
                end
                self.SoundsPlayed[dima] = true
                if dima == self.Primary.ReloadTimeEnd and !self.BoltLock then
                    self.animmul = 1.5
                end
            end
        end
    else
        if self.reload != nil then
            ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"),Angle(0,0,0))
	        ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Upperarm"),Angle(0,0,0))
            ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),Angle(0,0,0))
            ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),Angle(0,0,0))
        end
        self.reload = nil
        self.SoundsPlayed = nil
    end
end

function SWEP:Reload()
    self:ReloadFunc()
end