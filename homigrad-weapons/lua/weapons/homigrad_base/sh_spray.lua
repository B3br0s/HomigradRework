SWEP.Recoil_Shit = Angle(0,0,0)
SWEP.RecoilForce = 1

function SWEP:PrimarySpread()
    local high_recoil = (self:IsPistolHoldType() and self:GetOwner():GetNWInt("post") == 2)

    local mul = high_recoil and 3 or 1

    self.Recoil_Shit = Angle(-(self.Primary.Force / 65 + self.Primary.Damage / 100),math.random(-0.5,0.5) * -(self.Primary.Force / 140 + self.Primary.Damage / 140),0) * self.RecoilForce * mul
end

function SWEP:Step_Spray()
    local ply = self:GetOwner()

    self.Recoil_Shit = LerpAngleFT(0.3,self.Recoil_Shit,Angle(0,0,0))

    if SERVER then
        return
    end

    ply:SetEyeAngles(ply:EyeAngles() + self.Recoil_Shit)
end