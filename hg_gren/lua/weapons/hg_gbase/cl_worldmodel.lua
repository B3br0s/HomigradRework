AddCSLuaFile()

if CLIENT then
    function SWEP:Initialize()
        self:CreateClientsideModel()
    end

    function SWEP:OnRemove()
        if IsValid(self.ClientModel) then
            self.ClientModel:Remove()
        end
    end

    function SWEP:PinOutFunc()
        local bone = self.Bone
        local bone2 = self.Bone2

        if bone == nil then return end
        
        self.ClientModel:ManipulateBonePosition(self.ClientModel:LookupBone(bone),Vector(0,999,0))
        self.ClientModel:ManipulateBonePosition(self.ClientModel:LookupBone(bone2),Vector(0,999,0))
    end

    function SWEP:SkobaOutFunc()
        local bone = self.BoneSkoba
        if bone == nil then return end
        
        self.ClientModel:ManipulateBoneAngles(self.ClientModel:LookupBone(bone),self.SkobaLerpp)

        self.ClientModel:ManipulateBonePosition(self.ClientModel:LookupBone(bone),self.SkobaPos)
    end

    function SWEP:CreateClientsideModel()
        if not IsValid(self.ClientModel) then
            self.ClientModel = ClientsideModel(self.WorldModel, RENDER_GROUP_OPAQUE_ENTITY)
            self.ClientModel:SetNoDraw(true)

            local owner = self:GetOwner()
            if IsValid(owner) and not self.ACHO then
                self.ACHO = true
                local boneIndex = owner:LookupBone("ValveBiped.Bip01_R_Hand")
                if boneIndex then
                    self.ClientModel:ManipulateBonePosition(boneIndex, Vector(0, 0, 0))
                end
            end

            local hookName = "DrawSWEPWorldModel_" .. self:EntIndex()
            hook.Add("PostDrawOpaqueRenderables", hookName, function()
                if not IsValid(self) or not IsValid(self.ClientModel) then
                    hook.Remove("PostDrawOpaqueRenderables", hookName)
                    return
                end 
                self:DrawClientModel()
            end)
        end
    end

    function SWEP:DrawClientModel()
        if not IsValid(self.ClientModel) or not IsValid(self:GetOwner()) then return end
        local owner = self:GetOwner()
        
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

        self.ClientModel:SetPos(Pos)
        self.ClientModel:SetAngles(Ang)
        self.ClientModel:SetModelScale(self.CorrectSize or 1)
        self.ClientModel:SetNoDraw(false)

        self:SetNoDraw(true)
        self.ClientModel:DrawModel()
    end
end
