include("shared.lua")

function SWEP:Cuff(ent)
    local owner = self:GetOwner()
    local boneL = ent:LookupBone("ValveBiped.Bip01_L_Hand")
    local boneR = ent:LookupBone("ValveBiped.Bip01_R_Hand")
    
    if not boneL or not boneR then return end

    local ent1 = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(boneL))
    local ent2 = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(boneR))

    if not IsValid(ent1) or not IsValid(ent2) then return end

    ent1:SetPos(ent2:GetPos())

    if owner.IsCloaker then
        owner:EmitSound("cloaker/cuffed1.wav")
    end

    local cuff = ents.Create("prop_physics")
    if not IsValid(cuff) then return end

    local ang = ent2:GetAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)

    cuff:SetModel("models/freeman/flexcuffs.mdl")
    cuff:SetBodygroup(1, 1)
    cuff:SetPos(ent2:GetPos())
    cuff:SetAngles(ang)
    cuff:SetModelScale(1.2)
    cuff:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    cuff:Spawn()

    cuff:EmitSound("rust/handcuffs/handcuffs-lock-01.ogg")

    local ropeMaterial = "cable/rope.vmt"
    local color = Color(255, 255, 255)

    for i = 1, 3 do
        constraint.Rope(ent, ent, 5, 7, Vector(0, 0, 0), Vector(0, 0, 0), -2, 0, 0, 0, ropeMaterial, false, color)
    end

    constraint.Weld(cuff, ent, 0, 7, 0, true, false)
    constraint.Weld(cuff, ent, 0, 5, 0, true, false)

    self:Remove()
end

local constraint_FindConstraint = constraint.FindConstraint

function PlayerIsCuffs(ply)
    if not ply:Alive() then return false end

    local ent = ply:GetNWEntity("Ragdoll")
    if not IsValid(ent) then return false end

    return constraint_FindConstraint(ent, "Rope") ~= nil
end
