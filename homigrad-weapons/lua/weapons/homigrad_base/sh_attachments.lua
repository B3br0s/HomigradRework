SWEP.Attachments = {
    ["sight"] = {nil},
    ["barrel"] = {nil},
}

SWEP.AttDrawModels = {
}

SWEP.AvaibleAtt = {
    ["sight"] = false,
    ["barrel"] = false,
}

SWEP.AttachmentPos = {
    ['sight'] = Vector(0,0,0),
    ['barrel'] = Vector(0,0,0),
}

SWEP.AttachmentAng = {
    ['sight'] = Angle(0,0,0),
    ['barrel'] = Angle(0,0,0),
}

if SERVER then
    util.AddNetworkString("att sync")

    function SWEP:AddAttachment(att_tbl)
        self.Attachments[att_tbl.Placement][1] = att_tbl

        net.Start("att sync")
        net.WriteTable(self.Attachments)
        net.WriteEntity(self)
        net.Broadcast()
    end

    function SWEP:RemoveAttachment(att_tbl)
        self.Attachments[att_tbl.Placement][1] = nil

        net.Start("att sync")
        net.WriteTable(self.Attachments)
        net.WriteEntity(self)
        net.Broadcast()
    end

else
    net.Receive("att sync",function()
        local att_tbl = net.ReadTable()
        local ent = net.ReadEntity()

        ent.Attachments = att_tbl
    end)
end

concommand.Add("attach",function(ply,cmd,arg)
    if !ply:IsSuperAdmin() then
        return
    end
    if ply:GetActiveWeapon().ishgwep then
        local tbl = hg.Attachments[arg[1]]

        if !tbl then
            return
        end

        ply:GetActiveWeapon():AddAttachment(tbl)
    end
end)

concommand.Add("dettach",function(ply,cmd,arg)
    if !ply:IsSuperAdmin() then
        return
    end
    if ply:GetActiveWeapon().ishgwep then
        local tbl = hg.Attachments[arg[1]]

        if !tbl then
            return
        end

        ply:GetActiveWeapon():RemoveAttachment(tbl)
    end
end)

function SWEP:DrawAttachments(modeltodraw)
    local ply = self:GetOwner()
    if !modeltodraw then
        modeltodraw = self.worldModel
    end
    if !IsValid(modeltodraw) then
        return
    end
    for placement, att in pairs(self.Attachments) do
        if self.Attachments[placement][1] then
            local tbl = self.Attachments[placement][1]
            local shit_pos = (self.AttBone and modeltodraw:LookupBone(self.AttBone) != nil and modeltodraw:GetBoneMatrix(modeltodraw:LookupBone(self.AttBone)) != nil) and modeltodraw:GetBoneMatrix(modeltodraw:LookupBone(self.AttBone)):GetTranslation() or nil
            local shit_ang = (self.AttBone and modeltodraw:LookupBone(self.AttBone) != nil and modeltodraw:GetBoneMatrix(modeltodraw:LookupBone(self.AttBone)) != nil) and modeltodraw:GetBoneMatrix(modeltodraw:LookupBone(self.AttBone)):GetAngles() or nil
            local Pos = shit_pos or modeltodraw:GetPos()
            local Ang = shit_ang or modeltodraw:GetAngles()
            local mdl = self.AttDrawModels[placement]
            if !IsValid(mdl) and tbl.Model then
                mdl = ClientsideModel(tbl.Model,RENDERGROUP_BOTH)
                self:CallOnRemove("RemoveAtt", function() mdl:Remove() end)
                modeltodraw:CallOnRemove("RemoveAtt", function() mdl:Remove() end)
                mdl.DontOptimise = true

                table.insert(hg.csm,mdl)

                self.AttDrawModels[placement] = mdl
            end
            if IsValid(mdl) then
                local aaa = self.AttachmentAng[placement]
                Ang:RotateAroundAxis(Ang:Forward(),aaa[1])
                Ang:RotateAroundAxis(Ang:Right(),aaa[2])
                Ang:RotateAroundAxis(Ang:Up(),aaa[3])
                mdl:SetModelScale(tbl.CorrectSize,0)
                Pos = Pos + Ang:Forward() * self.AttachmentPos[placement][1] + Ang:Right() * self.AttachmentPos[placement][2] + Ang:Up() * self.AttachmentPos[placement][3]
                mdl:SetPos(Pos)
                mdl:SetAngles(Ang)
                        
                mdl:SetRenderAngles(Ang)
                mdl:SetRenderOrigin(Pos)
                //mdl:DrawModel()
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