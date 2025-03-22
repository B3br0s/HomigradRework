SWEP.Base = "weapon_base"
SWEP.PrintName = "Homigrad Base"
SWEP.Instructions = "Если вы хукнули то знайте,вы для нас отсталый долбаебик <3"
SWEP.Author = "ZCITY SCRIPTHOOK" -- ОУ ДААА
SWEP.Spawnable = true
SWEP.DrawAmmo = false
SWEP.HoldType = "revolver"
SWEP.HolsterBone = "ValveBiped.Bip01_Pelvis"
SWEP.HolsterPos = Vector(-7,10,-5)
SWEP.HolsterAng = Angle(0,0,-90)
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.Author = "Homigrad"

hg.Weapons = hg.Weapons or {}

SWEP.CorrectPos = Vector(9.5,1.2,-3)
SWEP.CorrectAng = Angle(0,0,0)
SWEP.Primary.Wait = 0.1
SWEP.Primary.Damage = 15
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 13
SWEP.Primary.ClipSize = 13
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/hndg_colt1911/colt_1911_fire1.wav"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self.Reloading = false
    self.Inspecting = false
    self.SmoothedBolt = 0
    hg.Weapons[self] = true
    self.Instructions = ""
    self:SetNWFloat("Bolt",0)
end

function SWEP:Deploy()

end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Think()
    self:SetHoldType(self.HoldType)
    if CLIENT then
        self:Zoom()
    end
end

function SWEP:OnRemove()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
    end
end

function SWEP:OwnerChanged()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
    end
end

function SWEP:CanShoot()
    if (self.Pumped != nil and !self.Pumped) then
        return false
    end
    return (!self.Reloading and !self.Inspecting and self:Clip1() > 0)
end

function SWEP:DrawWorldModel()
    if not IsValid(self:GetOwner()) then self:DrawModel() return end
    local owner = self:GetOwner()

    if owner:GetActiveWeapon() == self then
        
        self:DrawCorrectModel()
    end
end

function SWEP:Reload()

end

function SWEP:PrimaryAttack()
    if !self:CanShoot() then return end
    if self:GetNextPrimaryFire() > CurTime() then return end
    if self.NextShoot and self.NextShoot > CurTime() then return end
    self:Shoot()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Wait)
end

hook.Add("Think", "Homigrad-Weapons", function()
	for wep in pairs(hg.Weapons) do
		if not IsValid(wep) or not wep.Step or not IsValid(wep:GetOwner()) then continue end
		wep:Step()
	end
end)

function SWEP:Step()
    if not IsValid(self:GetOwner()) then return end
    self:SetHoldType(self.HoldType)
    local owner = self:GetOwner()
    if owner:GetActiveWeapon() != self and CLIENT then
        self:DrawHolsterModel()
    end

    if SERVER then
        if self:GetNWFloat("Bolt") > 0.1 then
            self:SetNWFloat("Bolt", LerpFT(0.7, self:GetNWFloat("Bolt"), 0))
        else
            self:SetNWFloat("Bolt", 0)
        end
    else
        self.SmoothedBolt = LerpFT(0.6, self.SmoothedBolt, self:GetNWFloat("Bolt"))
    end
end