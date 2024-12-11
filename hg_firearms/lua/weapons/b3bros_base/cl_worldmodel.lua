AddCSLuaFile()

--привет сыншалавы2013 со скриптхуком

if CLIENT then

    function SWEP:SlideOutSlow()
        if self.Breaking then return end
        local boneName = self.SlideBone
        local slideAmount = self.SlideAmount
        if boneName == nil then return end

        local endPos = self.SlideVector

        local startPos = Vector(0, 0, 0)
        local lerpAmount = 0
        local lerpSpeed = 10

        if not IsValid(self.ClientModel) then return end
        local boneIndex = self.ClientModel:LookupBone(boneName)
        if not boneIndex then return end

        local hookName = "BoneSlideOutSlow_" .. self:GetPrintName()

        hook.Add("Think", hookName, function()
            if not IsValid(self) or not IsValid(self.ClientModel) then
                hook.Remove("Think", hookName)
                return
            end

            lerpAmount = math.min(lerpAmount + FrameTime() * lerpSpeed, 1)
            local currentPos = LerpVector(lerpAmount, startPos, endPos)

            self.ClientModel:ManipulateBonePosition(boneIndex, currentPos)

            if lerpAmount >= 1 then
                hook.Remove("Think", hookName)
            end
        end)
    end

    function SWEP:SlideOutEmpty()
        if self.Breaking then return end
        local boneName = self.SlideBone
        local slideAmount = self.SlideAmount
        if boneName == nil then return end

        local startPos, endPos = self.SlideVector,self.SlideVector

        local lerpAmount = 0
        local lerpSpeed = 10

        if not IsValid(self.ClientModel) then return end
        local boneIndex = self.ClientModel:LookupBone(boneName)
        if not boneIndex then return end

        local hookName = "BoneSlideOutEmpty_" .. self:GetPrintName()

        hook.Add("Think", hookName, function()
            if not IsValid(self) or not IsValid(self.ClientModel) then
                hook.Remove("Think", hookName)
                return
            end

            lerpAmount = math.min(lerpAmount + FrameTime() * lerpSpeed, 1)
            local currentPos = LerpVector(lerpAmount, startPos, endPos)

            self.ClientModel:ManipulateBonePosition(boneIndex, currentPos)

            if lerpAmount >= 1 then
                hook.Remove("Think", hookName)
            end
        end)
    end

    function SWEP:SlideRotate()
        local boneName = self.SlideBone
        local slideAmount = self.SlideAmount

        if boneName == nil then return end

        local startPos = Angle(0, 0, 0)
        local endPos = self.SlideAngle

        if not IsValid(self.ClientModel) then return end
        local boneIndex = self.ClientModel:LookupBone(boneName)
        if not boneIndex then return end

        local hookName = "BoneSlideRotate_" .. self:GetPrintName()

        hook.Add("Think", hookName, function()
            if not IsValid(self) or not IsValid(self.ClientModel) then
                hook.Remove("Think", hookName)
                return
            end

            local currentPos = LerpAngle(self:GetNWFloat("Delay"), startPos, endPos)

            self.ClientModel:ManipulateBoneAngles(boneIndex, currentPos)

            if self:GetNWFloat("Delay") <= 0 or self:GetNWFloat("Delay") >= 1 then
                hook.Remove("Think", hookName)
            end
        end)
    end

    net.Receive("BroadcastAttachments", function()
        local wep = net.ReadEntity()
        local atts = net.ReadTable()
        wep.CurrentAtt = atts
    end)

    function SWEP:SlideIn()
        if self.Breaking then return end
        local boneName = self.SlideBone
        local slideAmount = self.SlideAmount

        if boneName == nil then return end

        local startPos = self.SlideVector

        local endPos = Vector(0, 0, 0)
        local lerpAmount = 0
        local lerpSpeed = 8

        if not IsValid(self.ClientModel) then return end
        local boneIndex = self.ClientModel:LookupBone(boneName)
        if not boneIndex then return end

        local hookName = "BoneSlideIn_" .. self:GetPrintName()

        hook.Add("Think", hookName, function()
            if not IsValid(self) or not IsValid(self.ClientModel) then
                hook.Remove("Think", hookName)
                return
            end

            lerpAmount = math.min(lerpAmount + FrameTime() * lerpSpeed, 1)
            local currentPos = LerpVector(lerpAmount, startPos, endPos)

            self.ClientModel:ManipulateBonePosition(boneIndex, currentPos)

            if lerpAmount >= 1 then
                hook.Remove("Think", hookName)
            end
        end)
    end

    function SWEP:DrawAttachments(index)
    -- local att = self.CurrentAtt[index]
    -- if not att then return end
    -- if self:GetOwner():GetMoveType() == MOVETYPE_NOCLIP then return end
    --    
    -- local owner = self:GetOwner()
    -- local attachmentIndex = (IsValid(owner) and owner:LookupAttachment("anim_attachment_rh")) or 0
    -- local attachment = (attachmentIndex > 0 and IsValid(owner)) and owner:GetAttachment(attachmentIndex) or nil
    -- local Pos, Ang
    --    
    -- if attachment then
    --     Pos = attachment.Pos
    --     Ang = attachment.Ang
    -- else
    --     Pos = self:GetPos()
    --     Ang = self:GetAngles()
    -- end
 --
    -- Pos = Pos + Ang:Forward() * (self.CorrectPosX + (att.CorrectPosX or 0))
    -- Pos = Pos + Ang:Right() * (self.CorrectPosY + (att.CorrectPosY or 0))
    -- Pos = Pos + Ang:Up() * (self.CorrectPosZ + (att.CorrectPosZ or 0))
 --
    -- Ang:RotateAroundAxis(Ang:Right(), self.CorrectAngPitch + (att.CorrectAngPitch or 0))
    -- Ang:RotateAroundAxis(Ang:Up(), self.CorrectAngYaw + (att.CorrectAngYaw or 0))
    -- Ang:RotateAroundAxis(Ang:Forward(), self.CorrectAngRoll + (att.CorrectAngRoll or 0))
 --
    -- local attModel = ClientsideModel(att.AttModel, RENDER_GROUP_OPAQUE_ENTITY)
    -- attModel:SetPos(Pos)
    -- attModel:SetAngles(Ang)
    -- attModel:SetModelScale(self.CorrectSize or 1)
    -- attModel:SetNoDraw(false)
    -- if att.Holo or self.Optic then
    --     self.SightModel = attModel
    --     self:SetNWVector("PositionSight", Pos)
    --     if not self.HasSight then
    --         self.HasSight = true
    --     end
    -- end
    -- attModel:Remove()
    end

    function SWEP:CreateClientsideModel()
        if not IsValid(self.ClientModel) then
            if not self.CorrectModel then
            self.ClientModel = ClientsideModel(self.WorldModel, RENDER_GROUP_OPAQUE_ENTITY)
            else
            self.ClientModel = ClientsideModel(self.CorrectModel, RENDER_GROUP_OPAQUE_ENTITY)
            end
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

    function SWEP:ClearAttachments()
        if self.modelAtt then
            for _, model in pairs(self.modelAtt) do
                if IsValid(model) then model:Remove() end
            end
            self.modelAtt = nil
        end
    end

    function SWEP:BoltProgress()--о да посмейся дура) мне поебать
        local boneName = self.BoltBone1
        local boneName2 = self.BoltBone2

        if boneName == nil then return end

        local startPos = Vector(0, 0, 0)
        local endPos = Vector(0, 0, 0)
        local startAng = Angle(0, 0, 0)
        local endAng = Angle(0, -90, 0)

        local lerpSpeed = 12
        local lerpAmount = 0

        if not IsValid(self.ClientModel) then return end
        local boneIndex = self.ClientModel:LookupBone(boneName)
        if not boneIndex then return end
        local boneIndex2 = self.ClientModel:LookupBone(boneName2)
        if not boneIndex2 then return end

        local hookName = "BoneBolt_" .. self:GetPrintName()

        timer.Simple(0.1, function()
            hook.Add("Think", hookName, function()
                if not IsValid(self) or not IsValid(self.ClientModel) then
                    hook.Remove("Think", hookName)
                    return
                end

                lerpAmount = math.min(lerpAmount + FrameTime() * lerpSpeed, 1)
                local currentAng = LerpAngle(lerpAmount, startAng, endAng)
                self.ClientModel:ManipulateBoneAngles(boneIndex2, currentAng)

                if lerpAmount >= 1 then
                    hook.Remove("Think", hookName)
                    lerpAmount = 0

                    timer.Simple(0.05, function()
                        lerpSpeed = 9
                        endPos = Vector(0, 0, -5)

                        net.Start("RifleShellVFX")
                        net.WriteEntity(self:GetOwner())
                        net.SendToServer()

                        hook.Add("Think", hookName, function()
                            if not IsValid(self) or not IsValid(self.ClientModel) then
                                hook.Remove("Think", hookName)
                                return
                            end

                            lerpAmount = math.min(lerpAmount + FrameTime() * lerpSpeed, 1)
                            local currentPos = LerpVector(lerpAmount, startPos, endPos)
                            self.ClientModel:ManipulateBonePosition(boneIndex, currentPos)

                            if lerpAmount >= 1 then
                                hook.Remove("Think", hookName)
                                lerpAmount = 0

                                timer.Simple(0.05, function()
                                    endPos = Vector(0, 0, 0)
                                    lerpSpeed = 5

                                    hook.Add("Think", hookName, function()
                                        if not IsValid(self) or not IsValid(self.ClientModel) then
                                            hook.Remove("Think", hookName)
                                            return
                                        end

                                        lerpAmount = math.min(lerpAmount + FrameTime() * lerpSpeed, 1)
                                        local currentPos = LerpVector(lerpAmount, startPos, endPos)
                                        self.ClientModel:ManipulateBonePosition(boneIndex, currentPos)

                                        if lerpAmount >= 1 then
                                            hook.Remove("Think", hookName)
                                            lerpAmount = 0

                                            timer.Simple(0.1, function()
                                                endAng = Angle(0, 0, 0)
                                                startAng = Angle(0, -90, 0)

                                                lerpSpeed = 10

                                                hook.Add("Think", hookName, function()
                                                    if not IsValid(self) or not IsValid(self.ClientModel) then
                                                        hook.Remove("Think", hookName)
                                                        return
                                                    end

                                                    lerpAmount = math.min(lerpAmount + FrameTime() * lerpSpeed, 1)
                                                    local currentAng = LerpAngle(lerpAmount, startAng, endAng)
                                                    self.ClientModel:ManipulateBoneAngles(boneIndex2, currentAng)

                                                    if lerpAmount >= 1 then
                                                        hook.Remove("Think", hookName)
                                                    end
                                                end)
                                            end)
                                        end
                                    end)
                                end)
                            end
                        end)
                    end)
                end
            end)
        end)
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

    function SWEP:DrawClientModel()
        if not IsValid(self.ClientModel) or not IsValid(self:GetOwner()) then self:CreateClientsideModel() return end
        if self:GetOwner():GetActiveWeapon() ~= self or self:GetOwner():GetMoveType() == MOVETYPE_NOCLIP then
            self.ClientModel:SetNoDraw(true)
            return
        end

        local owner = self:GetOwner()
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

        Ang:Normalize()

        self.ClientModel:SetPos(Pos)
        self.ClientModel:SetAngles(Ang)
        self.ClientModel:SetModelScale(self.CorrectSize or 1)
        self.ClientModel:SetNoDraw(false)

        self:WorldModel_Transform()

        if self.BodyGroup then
            for i = 1, #self.BodyGroup do
                self.ClientModel:SetBodygroup(i, self.BodyGroup[i])
            end
        end

        --if self.CurrentAtt then
        --    for i = 1, #self.CurrentAtt do
        --        self:DrawAttachments(i)
        --    end
        --end
    end

    function SWEP:OnRemove()
        self:ClearAttachments()
        if IsValid(self.ClientModel) then
            self.ClientModel:Remove()
            self.ClientModel = nil
        end
    end

end