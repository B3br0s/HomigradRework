AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Кокаин"
ENT.Author = "Homi:Cock"
ENT.Category = "Homigrad"
ENT.Purpose = "По просьбе виктора вишни)"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Model = "models/carlsmei/escapefromtarkov/medical/bandage_army.mdl"

if SERVER then
function ENT:Use(ply)
    ply.adrenaline = ply.adrenaline + 0.2
    ply.Drunk = ply.Drunk + 2
    ply.stamina = ply.stamina - 40
    ply:EmitSound("snds_jack_hmcd_breathing/m1.wav")
    self:Remove()
end
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    --self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    if SERVER then
    self:SetUseType(SIMPLE_USE)
    end
    if self:GetPhysicsObject() then
        self:GetPhysicsObject():Wake() 
    end
end