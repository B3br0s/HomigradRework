function hg.SetupModel(self,wm, lod, cm)
    lod = lod or 0
    if !wm then lod = 0 end
    if cm then wm = true end

    -- self:KillModel(cm)

    if !cm then
        hg.KillSpecificModel(self,wm)
    end

    local owner = self:GetOwner()

    if !wm and !IsValid(owner) then return end

    //if wm and !self.MirrorVMWM then return end

    self.LHIK_Priority = -1000
    self.RHIK_Priority = -1000
    self.MuzzleDevice_Priority = -1000
    self.MuzzleDeviceUBGL_Priority = -1000

    local basemodel = nil

    local mdl = {}

    if !wm then
        self.VModel = mdl
        self.LHIKModel = nil
        self.RHIKModel = nil
        self.MuzzleDeviceVM = nil
        self.MuzzleDeviceUBGLVM = nil

        if !owner.GetViewModel then return end -- safe check to fix random mp error

        basemodel = owner:GetViewModel()

        -- local RenderOverrideFunction = function(self2)
        --     if LocalPlayer():GetActiveWeapon() != self then LocalPlayer():GetViewModel().RenderOverride = nil return end
        --     if !IsValid(self) then LocalPlayer():GetViewModel().RenderOverride = nil return end

        --     self:SetFiremodePose()
        --     self2:DrawModel()
        -- end

        -- local vm = self:GetVM()

        -- vm.RenderOverride = RenderOverrideFunction
    else
        if cm then
            self.CModel = mdl
        else
            self.LHIKModelWM = nil
            self.RHIKModelWM = nil
            self.MuzzleDeviceWM = nil
            self.MuzzleDeviceUBGLWM = nil
            self.WModel = mdl
        end

        local csmodel = ClientsideModel(self.WorldModelMirror or self.ViewModel)
        csmodel.weapon = self
        basemodel = csmodel

        if !IsValid(csmodel) then return end

        csmodel:SetNoDraw(true)
        csmodel.atttbl = {}
        
        if cm then
            csmodel.slottbl = {
                WMBase = true,
                Pos = Vector(0, 0, 0),
                Ang = Angle(0, 0, 0)
            }
        else
            csmodel.slottbl = {
                WMBase = true,
                Pos = self.WorldPos or Vector(0, 0, 0),
                Ang = self.WorldAng or Angle(-5, 0, 180)
            }
        end

        local animentry = hg.GetAnimationEntry(self,"idle")
        local source = animentry and animentry.Source or "idle"

        if istable(source) then
            source = source[1]
        end

        if !isnumber(source) then
            source = csmodel:LookupSequence(source)
        end

        if source >= 0 then
            csmodel:ResetSequence(source)
        end

        local scale = Matrix()
        local vec = Vector(1, 1, 1) * 1
        scale:Scale(vec)
        csmodel:EnableMatrix("RenderMultiply", scale)

        local tbl = {
            Model = csmodel,
            Weapon = self,
            Version = self.ModelVersion
        }

        //table.insert(hg.CSModelPile, tbl)

        table.insert(mdl, 1, csmodel)
    end

    if !wm and owner != LocalPlayer() then return end
    if lod > 0 then return end

    //local eles = self:GetAttachmentElements()

    /*for _, ele in ipairs(eles) do

        if !ele then continue end
        if !ele.Models then continue end

        for _, model in ipairs(ele.Models) do
            local csmodel = ClientsideModel(model.Model)

            if !IsValid(csmodel) then continue end

            csmodel:SetNoDraw(true)
            csmodel.atttbl = {}

            csmodel.slottbl = {
                Pos = model.Pos or Vector(0, 0, 0),
                Ang = model.Ang or Angle(0, 0, 0),
                Bone = model.Bone
            }

            if model.BoneMerge then
                csmodel.BoneMerge = true

                csmodel:AddEffects(EF_BONEMERGE)
                csmodel:SetParent(basemodel)
            end

            local scale = Matrix()
            local vec = model.ScaleVector or (Vector(1, 1, 1) * (model.Scale or 1))
            if wm then
                vec = vec * (self.WorldModelOffset.Scale or 1)
            end
            scale:Scale(vec)
            csmodel:EnableMatrix("RenderMultiply", scale)

            csmodel:SetSkin(model.Skin or 1)
            csmodel:SetBodyGroups(model.Bodygroups or "")

            if (ele.MuzzleDevice) then
                local priority = ele.MuzzleDevice_Priority or 0
                local totalpriority = self.MuzzleDevice_Priority or 0

                if priority > totalpriority or (priority == totalpriority and i > 0) then
                    self.MuzzleDevice_Priority = priority
                    csmodel.IsMuzzleDevice = true

                    if wm then
                        self.MuzzleDeviceWM = csmodel
                    else
                        self.MuzzleDeviceVM = csmodel
                    end
                end
            end

            local tbl = {
                Model = csmodel,
                Weapon = self,
                Version = self.ModelVersion
            }

            csmodel.CustomCamoTexture = self:GetProcessedValue("CustomCamoTexture", true)
            csmodel.CustomCamoScale = self:GetProcessedValue("CustomCamoScale", true)
            csmodel.CustomBlendFactor = self:GetProcessedValue("CustomBlendFactor", true)

            table.insert(ARC9.CSModelPile, tbl)

            table.insert(mdl, 1, csmodel)
        end
    end*/

    /*for _, slottbl in ipairs(self:GetSubSlotList()) do
        if !slottbl.Installed then continue end
        if slottbl.NoDraw then continue end

        -- local atttbl = ARC9.GetAttTable(slottbl.Installed)
        local atttbl = self:GetFinalAttTable(slottbl)

        local stickertablepath = slottbl.StickerModel

        if wm then
            stickertablepath = slottbl.StickerModelWorld or stickertablepath
        end

        if stickertablepath and atttbl.StickerMaterial then
            local stickermodel = ClientsideModel(stickertablepath)

            if !IsValid(stickermodel) then continue end

            stickermodel:SetNoDraw(true)
            stickermodel.atttbl = {
                DrawFunc = atttbl.StickerDrawFunc
            }
            stickermodel.slottbl = slottbl

            stickermodel:AddEffects(EF_BONEMERGE)
            local stickerparent = basemodel
            if slottbl.ParentTable then
                if wm then
                    stickerparent = slottbl.ParentTable.WModel or basemodel
                else
                    stickerparent = slottbl.ParentTable.VModel or basemodel
                end
            end
            stickermodel:SetParent(stickerparent)
            local stickermat = atttbl.StickerMaterial

            if self.StickersNoNocull then
                local fakestickwithoutnocull = Material(stickermat)
                fakestickwithoutnocull:SetInt("$flags", bit.band(fakestickwithoutnocull:GetInt("$flags"), bit.bnot(8192)))
                fakestickwithoutnocull:Recompute()
            end
            
            stickermodel:SetMaterial(stickermat)

            local tbl = {
                Model = stickermodel,
                Weapon = self,
                Version = self.ModelVersion
            }

            table.insert(ARC9.CSModelPile, tbl)

            table.insert(mdl, stickermodel)
        end

        if !atttbl.Model then continue end

        local dupli = slottbl.DuplicateModels or {}

        local duplicheck = self:GetProcessedValue("Akimbo",true) or self:GetProcessedValue("DuplicateAttachments",true)

        for i = 0, #dupli do
            local csmodel = self:CreateAttachmentModel(wm, atttbl, slottbl, false, cm, dupli)

            if duplicheck  then
                csmodel.Duplicate = i
            end

            if atttbl.NoDraw then
                csmodel.NoDraw = true
            end

            if csmodel.DrawFunc then
                csmodel.DrawFunc(self, csmodel, wm)
            end

            csmodel.CustomCamoTexture = self:GetProcessedValue("CustomCamoTexture", true)
            csmodel.CustomCamoScale = self:GetProcessedValue("CustomCamoScale", true)
            csmodel.CustomBlendFactor = self:GetProcessedValue("CustomBlendFactor", true)

            local proxmodel

            if !cm and ((atttbl.LHIK or atttbl.RHIK) or atttbl.MuzzleDevice or atttbl.MuzzleDeviceUBGL) then
                proxmodel = self:CreateAttachmentModel(wm, atttbl, slottbl, true)
                proxmodel.NoDraw = true
                if duplicheck then
                    proxmodel.Duplicate = i
                end

                local scale = Matrix()
                local vec = Vector(1, 1, 1) * (slottbl.Scale or 1) * (atttbl.Scale or 1)
                if wm then
                    vec = vec * (self.WorldModelOffset.Scale or 1)
                end
                if i > 0 then
                    vec = vec * (slottbl.DuplicateModels[i].Scale or 1)
                end
                scale:Scale(vec)
                proxmodel:EnableMatrix("RenderMultiply", scale)

                local tbl = {
                    Model = proxmodel,
                    Weapon = self,
                    Version = self.ModelVersion
                }

                table.insert(ARC9.CSModelPile, tbl)
            end

            if atttbl.BoneMerge then
                csmodel.BoneMerge = true

                csmodel:AddEffects(EF_BONEMERGE)
                csmodel:SetParent(basemodel)
            end

            if (atttbl.MuzzleDevice or atttbl.MuzzleDeviceUBGL) and !cm then
                local priority = atttbl.MuzzleDevice_Priority or 0
                local totalpriority = self.MuzzleDevice_Priority or 0

                if atttbl.MuzzleDeviceUBGL then
                    priority = atttbl.MuzzleDeviceUBGL_Priority or 0
                    totalpriority = self.MuzzleDeviceUBGL_Priority or 0
                end

                if priority > totalpriority or (priority == totalpriority and i > 0) then
                    if atttbl.MuzzleDeviceUBGL then
                        self.MuzzleDeviceUBGL_Priority = priority
                    else
                        self.MuzzleDevice_Priority = priority
                        proxmodel.IsMuzzleDevice = true
                    end

                    local tbl

                    if atttbl.MuzzleDeviceUBGL then
                        tbl = self.MuzzleDeviceUBGLVM

                        if wm then
                            tbl = self.MuzzleDeviceUBGLWM
                        end
                    else
                        tbl = self.MuzzleDeviceVM

                        if wm then
                            tbl = self.MuzzleDeviceWM
                        end
                    end

                    if #dupli > 0 then
                        if i == 0 then
                            tbl = {proxmodel}
                        else
                            table.insert(tbl, proxmodel)
                        end
                    else
                        tbl = proxmodel
                    end

                    if atttbl.MuzzleDeviceUBGL then
                        self.MuzzleDeviceUBGLVM = tbl

                        if wm then
                            self.MuzzleDeviceUBGLWM = tbl
                        end
                    else
                        self.MuzzleDeviceVM = tbl

                        if wm then
                            self.MuzzleDeviceWM = tbl
                        end
                    end
                end
            end

            if !cm and i == 0 then
                if wm then
                    slottbl.WModel = csmodel
                else
                    slottbl.VModel = csmodel
                end
            end

            if i == 0 then
                csmodel.LaserCorrectionAngle = slottbl.LaserCorrectionAngle
            else
                csmodel.LaserCorrectionAngle = slottbl.DuplicateModels[i].LaserCorrectionAngle or slottbl.LaserCorrectionAngle
            end

            if !cm and i == 0 then
                if atttbl.IKAnimationProxy then
                    local animproxmodel = self:CreateAttachmentModel(wm, atttbl, slottbl, true)
                    animproxmodel.NoDraw = true
                    animproxmodel.IsAnimationProxy = true

                    slottbl.GunDriverModel = animproxmodel

                    local reflectproxmodel = ClientsideModel(self.ViewModel)

                    if !IsValid(reflectproxmodel) then return end

                    reflectproxmodel:SetNoDraw(true)
                    reflectproxmodel.atttbl = atttbl
                    reflectproxmodel.slottbl = slottbl

                    local tbl = {
                        Model = reflectproxmodel,
                        Weapon = self,
                        Version = self.ModelVersion
                    }

                    table.insert(ARC9.CSModelPile, tbl)

                    table.insert(mdl, reflectproxmodel)

                    reflectproxmodel.NoDraw = true
                    reflectproxmodel.IsAnimationProxy = true

                    slottbl.ReflectDriverModel = reflectproxmodel

                    local anim = self:TranslateAnimation("idle")
                    local ae = self:GetAnimationEntry(anim)
                    local seq = reflectproxmodel:LookupSequence(self:RandomChoice(ae.Source))

                    reflectproxmodel:ResetSequence(seq)
                end
            end

            if !cm and i == 0 and atttbl.LHIK or atttbl.RHIK then
                slottbl.IKModel = proxmodel

                if atttbl.LHIK then
                    if (atttbl.LHIK_Priority or 0) > self.LHIK_Priority then
                        self.LHIK_Priority = atttbl.LHIK_Priority or 0
                        if wm then
                            self.LHIKModelWM = proxmodel
                        else
                            self.LHIKModel = proxmodel
                        end
                        self.LHIKModelAddress = slottbl.Address
                    end
                end
                if atttbl.RHIK then
                    if (atttbl.RHIK_Priority or 0) > self.RHIK_Priority then
                        self.RHIK_Priority = atttbl.RHIK_Priority or 0
                        if wm then
                            self.RHIKModelWM = proxmodel
                        else
                            self.RHIKModel = proxmodel
                        end
                        self.RHIKModelAddress = slottbl.Address
                    end
                end
            end
        end
    end*/

    /*self:CreateFlashlights()

    self:DoBodygroups(wm, cm)*/
end

function hg.KillSpecificModel(self,wm)
    if wm then
        for _, model in ipairs(self.WModel or {}) do
            SafeRemoveEntity(model)
        end

        self.WModel = nil
    else
        for _, model in ipairs(self.VModel or {}) do
            SafeRemoveEntity(model)
        end

        self.VModel = nil
    end
end

function hg.KillModel(self,cmo)
    if cmo then
        for _, model in ipairs(self.CModel or {}) do
            SafeRemoveEntity(model)
        end

        self.CModel = nil

        return
    end

    if !self.VModel and !self.WModel then return end

    for _, model in ipairs(self.VModel or {}) do
        SafeRemoveEntity(model)
    end
    for _, model in ipairs(self.WModel or {}) do
        SafeRemoveEntity(model)
    end

    self.ModelVersion = self.ModelVersion + 1

    self.VModel = nil
    self.WModel = nil
end
