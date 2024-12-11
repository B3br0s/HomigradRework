AddCSLuaFile()

if CLIENT then

    function SWEP:CreateClientsideModel()
        if not IsValid(self.ClientModel) then
            self.ClientModel = ClientsideModel(self.WorldModel, RENDER_GROUP_OPAQUE_ENTITY)
            self.ClientModel:SetNoDraw(true)

            if not self.ACHO then
                local boneName = self.SlideBone
                if boneName == nil then return end
                local boneIndex = self.ClientModel:LookupBone(boneName)
                self.ACHO = 1
                self.ClientModel:ManipulateBonePosition(boneIndex, Vector(0, 0, 0))
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

    function SWEP:WorldModel_Transform()
        local model, owner = self.ClientModel, self:GetOwner()
        if not IsValid(model) then
            self:CreateClientsideModel()
            model = self.ClientModel
        end
        if IsValid(owner) then
            local matrix = owner:GetBoneMatrix(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
            if not matrix then return end

            local pos, ang = matrix:GetTranslation(), matrix:GetAngles()
            pos = pos + ang:Forward() * (self.CorrectPosX or 0)
            pos = pos + ang:Right() * (self.CorrectPosY or 0)
            pos = pos + ang:Up() * (self.CorrectPosZ or 0)

            ang:RotateAroundAxis(ang:Right(), self.CorrectAngPitch or 0)
            ang:RotateAroundAxis(ang:Up(), self.CorrectAngYaw or 0)
            ang:RotateAroundAxis(ang:Forward(), self.CorrectAngRoll or 0)

            model:SetRenderOrigin(pos)
            model:SetRenderAngles(ang)
            model:SetupBones()
            model:SetNoDraw(true)
        else
            model:SetRenderOrigin(self:GetPos())
            model:SetRenderAngles(self:GetAngles())
        end
    end

    function SWEP:OnRemove()
        self:ClearAttachments()
        if IsValid(self.ClientModel) then
            self.ClientModel:Remove()
            self.ClientModel = nil
        end
    end

end