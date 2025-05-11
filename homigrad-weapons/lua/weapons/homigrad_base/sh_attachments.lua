SWEP.Attachments = {
    ['sight'] = NULL,
    ['barrel'] = NULL
}

SWEP.AttDrawModels = {
    ['sight'] = NULL,
    ['barrel'] = NULL
}

SWEP.AttachmentPos = Vector(0,0,0)

function SWEP:AddAttachment(att_tbl)
    if SERVER then
        self.Attachments[att_tbl.placement] = att_tbl

        net.Start("att sync")
        net.WriteTable(self.Attachments)
        net.WriteEntity(self)
        net.Broadcast()
    end
end

function SWEP:RemoveAttacment(att_tbl)
    if SERVER then
        self.Attachments[att_tbl.placement] = NULL

        net.Start("att sync")
        net.WriteTable(self.Attachments)
        net.WriteEntity(self)
        net.Broadcast()
    end
end

function SWEP:DrawAttachments()
    local ply = self:GetOwner()
    for placement, att in pairs(self.Attachments) do
        if self.Attachments[placement] != NULL then
            local tbl = self.Attachments[placement]
            local Pos = self.worldModel:GetPos()
            local Ang = self.worldModel:GetAngles()
            local mdl = self.AttDrawModels[placement]
            if !IsValid(mdl) and tbl.Model then
                mdl = ClientsideModel(tbl.Model,RENDERGROUP_BOTH)
                mdl:SetOwner(ply)
                mdl:SetPredictable(true)
                self:CallOnRemove("RemoveAtt", function() mdl:Remove() end)
                self.worldModel:CallOnRemove("RemoveAtt", function() mdl:Remove() end)

                self.AttDrawModels[placement] = mdl
            end
            if IsValid(mdl) then
                Ang:RotateAroundAxis(Ang:Forward(),tbl.CorrectAng[1])
                Ang:RotateAroundAxis(Ang:Right(),tbl.CorrectAng[2])
                Ang:RotateAroundAxis(Ang:Up(),tbl.CorrectAng[3])
                mdl:SetModelScale(tbl.CorrectSize,0)
                mdl:SetOwner(ply)
                mdl:SetParent(ply)
                mdl:SetPredictable(true)
                Pos = self.worldModel:GetPos() + Ang:Forward() * tbl.CorrectPos[1] + Ang:Right() * tbl.CorrectPos[2] + Ang:Up() * tbl.CorrectPos[3]
                Pos = Pos + Ang:Forward() * self.AttachmentPos[placement][1] + Ang:Right() * self.AttachmentPos[placement][2] + Ang:Up() * self.AttachmentPos[placement][3]
                mdl:SetPos(Pos)
                mdl:SetAngles(Ang)
                        
                mdl:SetRenderAngles(Ang)
                mdl:SetRenderOrigin(Pos)
                mdl:DrawModel()
            end
        else
            local mdl = self.AttDrawModels[placement]
            if IsValid(mdl) then
                mdl:Remove()
                mdl = nil
            end
        end
    end
end

if SERVER then
    util.AddNetworkString("att sync")
else
    net.Receive("att sync",function()
        local att_tbl = net.ReadTable()
        local ent = net.ReadEntity()

        ent.Attachments = att_tbl
    end)
end