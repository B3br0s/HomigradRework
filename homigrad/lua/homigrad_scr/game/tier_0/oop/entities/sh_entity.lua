local ENT,CLASS = oop.Reg("base_entity",{"lib_event","lib_duplicate"})
if not ENT then return end

CLASS.NonRegisterGMOD = true

ENT.Base = "base_entity"
ENT.Type = "anim"--навсякий

function ENT:Draw() self:DrawModel() end

function ENT:SpawnFunction(ply,tr,name)
    if not tr.Hit then return end

    local ent = ents.Create(name)
    ent:SetPos(tr.HitPos + tr.HitNormal * 16 + ent:OBBCenter())
    ent.spawned = true
    ent:Spawn()
    ent:Activate()

    ent:PhysWake()

    return ent
end

function ENT:OnTakeDamage(dmgInfo)
    self:TakePhysicsDamage(dmgInfo)
end

ENT:Event_Add("Construct","register",function(class)
    local content = class[1]
    if content.NonRegisterGMOD or class.NonRegisterGMOD then return end

    scripted_ents.Register(content,content.ClassName)
end)

