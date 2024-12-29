SWEP.Base = "weapon_base"

SWEP.PrintName = "База Медицины"
SWEP.Author = "HG:R"

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.Spawnable = false

SWEP.ViewModel = "models/illusion/eftcontainers/carmedkit.mdl"
SWEP.WorldModel = "models/illusion/eftcontainers/carmedkit.mdl"

SWEP.HoldType = "slam"

if CLIENT then
    include("cl_worldmodel.lua")
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Uses = 2

SWEP.CorrectPosX =     0
SWEP.CorrectPosY =     0
SWEP.CorrectPosZ =     0 

SWEP.CorrectAngPitch = 0
SWEP.CorrectAngYaw =   0
SWEP.CorrectAngRoll =  0

if SERVER then
    util.AddNetworkString("SyncUses")
else
    net.Receive("SyncUses",function()
    local uses = net.ReadFloat()
    local item = net.ReadEntity()
    item.Uses = uses
    end)
end

function SWEP:GetEyeTraceDist(dist)
    local owner = self:GetOwner()
    if not owner or not owner:IsValid() then return end
    local trace = util.TraceLine({
        start = owner:EyePos(),
        endpos = owner:EyePos() + owner:EyeAngles():Forward() * dist,
        filter = owner
    })
    return trace
end

function SWEP:Think()
    self:SetHoldType(self.HoldType)

    if self.Uses == 0 and SERVER then
        self:Remove()
    end
end

function SWEP:DrawHUD()
    local ply = self:GetOwner()
	local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
	local textpos = (hand.Pos + hand.Ang:Forward() * 0 + hand.Ang:Up() * -2 + hand.Ang:Right() * -3):ToScreen()
	
       draw.DrawText("Uses left:" .. self.Uses, "HomigradFontBig", textpos.x, textpos.y, Color(255,255,255), TEXT_ALIGN_RIGHT)
end

function SWEP:Heal(entity)
    self.Uses = self.Uses - 1
    net.Start("SyncUses")
    net.WriteFloat(self.Uses)
    net.WriteEntity(self)
    net.Broadcast()
    if not entity:Alive() then return end
    for attribute, value in pairs(self.Healing) do
        if attribute == "health" then
            entity:SetHealth(entity:Health() + value)
        elseif attribute == "Bloodlosing" then
            entity[attribute] = entity[attribute] - value
        elseif attribute != "health" and attribute != "LeftLeg" and attribute != "RightLeg" and attribute != "LeftArm" and attribute != "RightArm" then
            if type(entity[attribute]) == "number" then
                if self:GetOwner():Health() >= self:GetOwner():GetMaxHealth() then
                entity[attribute] = entity[attribute] + value / 60
                elseif self:GetOwner():Health() < self:GetOwner():GetMaxHealth() then
                entity[attribute] = entity[attribute] + value
                end
            end
        elseif attribute == "LeftLeg" or attribute == "RightLeg" or attribute == "LeftArm" or attribute == "RightArm" then
            entity[attribute] = value
        end
    end
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    self:SetNextPrimaryFire(CurTime() + 0.5)
    self:SetNextSecondaryFire(CurTime() + 0.5)
    local owner = self:GetOwner()

    self:Heal(owner)
end

function SWEP:SecondaryAttack()
    if CLIENT then return end
    self:SetNextPrimaryFire(CurTime() + 0.5)
    self:SetNextSecondaryFire(CurTime() + 0.5)
    local owner = self:GetOwner()
    local trace = self:GetEyeTraceDist(150)
    local ent = trace.Entity
    ent = (ent:IsPlayer() and ent) or RagdollOwner(ent) or (ent:GetClass() == "prop_ragdoll" and ent)
    if not ent then return end
    if ent:IsPlayer() then
        self:Heal(ent)
    end
end

function SWEP:DrawWorldModel()
    local owner = self:GetOwner()
    if IsValid(owner) then
        if not IsValid(self.ClientModel) then
            self:CreateClientsideModel()
            return
        end

        if owner:GetActiveWeapon() ~= self or owner:GetMoveType() == MOVETYPE_NOCLIP then
            self.ClientModel:SetNoDraw(true)
            return
        end

        local attachmentIndex = owner:LookupAttachment("anim_attachment_rh")
        if attachmentIndex == 0 then return end

        local attachment = owner:GetAttachment(attachmentIndex)
        if not attachment then return end

        local Pos = attachment.Pos
        local Ang = attachment.Ang

        Pos:Add(Ang:Forward() * (self.CorrectPosX or 0))
        Pos:Add(Ang:Right() * (self.CorrectPosY or 0))
        Pos:Add(Ang:Up() * (self.CorrectPosZ or 0))

        Ang:RotateAroundAxis(Ang:Right(), self.CorrectAngPitch or 0)
        Ang:RotateAroundAxis(Ang:Up(), self.CorrectAngYaw or 0)
        Ang:RotateAroundAxis(Ang:Forward(), self.CorrectAngRoll or 0)

        Ang:Normalize()

        self.ClientModel:SetPos(Pos)
        self.ClientModel:SetAngles(Ang)
        if self.Skin then
            self.ClientModel:SetSkin(self.Skin)
        end
        self.ClientModel:SetModelScale(self.CorrectSize or 1)
        self.ClientModel:SetNoDraw(false)

        self:WorldModel_Transform()

        self.ClientModel:DrawModel()
    else
        if IsValid(self.ClientModel) then
            self.ClientModel:SetNoDraw(true)
        end
        if self.Skin then
            self:SetSkin(self.Skin)
        end
        self:DrawModel()
    end
end