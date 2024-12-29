AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Отбеливатель"
ENT.Author = "Homi:Cock"
ENT.Category = "Homigrad"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Model = "models/props_junk/garbage_plasticbottle002a.mdl"

if SERVER then
function ENT:Use(ply)
    ply.virus = ply.virus + 20
    ply:SetHealth(ply:Health() + 40)
    ply:EmitSound("snd_jack_drink2.ogg")
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