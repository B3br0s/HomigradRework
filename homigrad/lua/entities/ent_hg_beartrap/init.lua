AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/trap/trap.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end
 
function ENT:StartTouch(ent)
    if not self.Activated and ent:IsPlayer() then
        self:ActivateTrap(ent)
        self:EmitSound("beartrap/closebloody.wav")
    elseif not self.Activated and not ent:IsPlayer()     then
        if ent:GetClass() != "prop_ragdoll" then
        self:CloseTrap(ent)
        self:EmitSound("beartrap/close.wav")
        else
        if IsValid(ent:GetNWEntity("RagdollOwner")) then
        ent:GetNWEntity("RagdollOwner"):TakeDamage(70)
        ent:GetNWEntity("RagdollOwner").pain = ent:GetNWEntity("RagdollOwner").pain + 150
        ent:GetNWEntity("RagdollOwner").Bloodlosing = ent:GetNWEntity("RagdollOwner").Bloodlosing + 50
        self.Activated = true
        local faketrap = ents.Create("prop_physics")
        faketrap:SetModel("models/trap/trap_close.mdl")
        faketrap:Spawn()

        faketrap:GetPhysicsObject():Wake()

        faketrap:SetPos(self:GetPos())

        self:Remove()
        end
        self:EmitSound("beartrap/closebloody.wav")
        end
    --[[elseif not self.Activated and not ent:IsPlayer() and ent:GetClass() == "prop_ragdoll" then
        if IsValid(ent:GetNWEntity("RagdollOwner")) then
        ent:GetNWEntity("RagdollOwner"):TakeDamage(40)
        self.Activated = true
        self:SetModel("models/trap/trap_close.mdl")
        end
        self:EmitSound("beartrap/closebloody.wav")]]
    end
end

function ENT:AttachToRagdoll(ply)
    if CLIENT then return end

    local ragdoll = ply:GetNWEntity("Ragdoll")

    local faketrap = ents.Create("prop_physics")
    faketrap:SetModel("models/trap/trap_close.mdl")
    faketrap:Spawn()

    --faketrap:GetPhysicsObject():SetMass(5)
    faketrap:GetPhysicsObject():Wake()

    local Bone = ragdoll:LookupBone("ValveBiped.Bip01_R_Toe0")

    local phys = ragdoll:TranslateBoneToPhysBone(Bone)

    local Poss, Angg = ply:GetBonePosition(Bone)

    faketrap:SetPos(Poss)

    constraint.Weld(faketrap, ragdoll, 0, phys, 0, true, false)

    constraint.Rope(
        faketrap,       
        ragdoll,        
        0,              
        phys,           
        Vector(0, 0, 0),
        Vector(0, 0, 0),
        0,             
        0,              
        0,              
        0,              
        "cable/cable",  
        false           
    )
    constraint.Rope(
        faketrap,       
        ragdoll,        
        0,              
        phys,           
        Vector(0, 0, 0),
        Vector(0, 0, 0),
        0,             
        0,              
        0,              
        0,              
        "cable/cable",  
        false           
    )
    constraint.Rope(
        faketrap,       
        ragdoll,        
        0,              
        phys,           
        Vector(0, 0, 0),
        Vector(0, 0, 0),
        0,             
        0,              
        0,              
        0,              
        "cable/cable",  
        false           
    )

    self:Remove()
end

function ENT:AttachToProp(prop)
    if CLIENT then return end
    self.Activated = true
    local faketrap = ents.Create("prop_physics")
    faketrap:SetModel("models/trap/trap_close.mdl")
    faketrap:Spawn()

    faketrap:GetPhysicsObject():Wake()

    faketrap:SetPos(self:GetPos())

    prop:TakeDamage(20)

    constraint.Weld(faketrap, prop, 0, 0, 0, true, false)

    self:Remove()
end

function ENT:CloseTrap(prop)
    if CLIENT then return end
    if not self.Activated then
        self.Activated = true
        self:SetModel("models/trap/trap_close.mdl")

        self:AttachToProp(prop)
    end
end

function ENT:ActivateTrap(player)
    if CLIENT then return end
    if not self.Activated then
        self.Activated = true
        self:SetModel("models/trap/trap_close.mdl")

        local dmg = DamageInfo()
        dmg:SetDamage(35)
        dmg:SetDamageType(DMG_SLASH)

        player:TakeDamageInfo(dmg)
        
        player.Bloodlosing = player.Bloodlosing + 50

        player.pain = player.pain + 150

        player:ChatPrint("Твоя правая нога попала в капкан.")

        Faking(player)

        self:AttachToRagdoll(player)    

        --self:SetSolid(SOLID_NONE)
    end
end
