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
    end
end
