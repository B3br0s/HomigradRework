local function Draw(self)
    local k = (self.Start + 4 - CurTime()) / 4
    if k <= 0 then timer.Simple(0,function() if IsValid(self) then self:Remove() end end) return end

    render.SetBlend(k)
    self:DrawModel()
    render.SetBlend(1)
end

function DropProp(mdl,scale,pos,ang,vel,angvel) 
    local mdl = ents.CreateClientProp(mdl)
    if not IsValid(mdl) then return end

    mdl:SetPos(pos)
    mdl:SetAngles(ang)
    mdl:Spawn()

    local phys = mdl:GetPhysicsObject()
    if not IsValid(phys) then mdl:Remove() return end

    mdl:SetModelScale(scale or 1)

    phys:SetMass(1)
    phys:SetVelocity(vel)
    phys:SetAngleVelocity(angvel)
    phys:Wake()

    mdl:DestroyShadow()

    return mdl
end