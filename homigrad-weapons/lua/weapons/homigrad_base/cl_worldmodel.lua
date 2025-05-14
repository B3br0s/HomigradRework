function SWEP:WorldModel_Transform()
    local mdl = self.worldModel

    if !IsValid(mdl) then
        return
    end

    if self.Bodygroups then
        for _, v in ipairs(self.Bodygroups) do
            if IsValid(self.worldModel) then
                self.worldModel:SetBodygroup(_,v)
            end
            self:SetBodygroup(_,v)
        end
    end

    local ply = self:GetOwner()

    local Att = {}

    if !ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_R_Hand")) then
        return
    end

    if self:GetOwner():GetActiveWeapon() == self then
        self.worldModel:SetNoDraw(false)
    end

    Att.Pos = ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_R_Hand")):GetTranslation()
    Att.Ang = ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_R_Hand")):GetAngles()

    Att.Ang:RotateAroundAxis(Att.Ang:Forward(),180)
        
    local Pos = Att.Pos
    local Ang = Att.Ang
    if !IsValid(mdl) then
        return
    end
    mdl:SetModelScale(self.CorrectScale or 1,0)
    
    Pos = Pos + Ang:Forward() * self.CorrectPos[1] + Ang:Right() * self.CorrectPos[2] + Ang:Up() * self.CorrectPos[3]
    Ang:RotateAroundAxis(Ang:Forward(),self.CorrectAng[1])
    Ang:RotateAroundAxis(Ang:Right(),self.CorrectAng[2])
    Ang:RotateAroundAxis(Ang:Up(),self.CorrectAng[3])
    
    mdl:SetAngles(Ang)
    mdl:SetPos(Pos)
    mdl:SetOwner(ply)
    mdl:SetParent(ply)
    mdl:SetPredictable(true)
    
    mdl:SetRenderAngles(Ang)
    mdl:SetRenderOrigin(Pos)

    return Pos,Ang
end

function SWEP:WorldModel_Holster_Transform()
    local owner = self:GetOwner()
    if !owner:HasWeapon(self:GetClass()) then
        self.worldModel:Remove()
        return
    end
    if !owner then
        return
    end
    if !IsValid(owner) then
        return
    end
    if self.Bodygroups then
        for _, v in ipairs(self.Bodygroups) do
            if IsValid(self.worldModel) then
                self.worldModel:SetBodygroup(_,v)
            end
            self:SetBodygroup(_,v)
        end
    end

    if not IsValid(owner) or not owner:Alive() then return end

    local WM = self.worldModel
    if not IsValid(WM) then
        self:CreateWorldModel()
        return
    end

    if self:GetOwner():GetActiveWeapon() == self then
        self.worldModel:SetNoDraw(false)
        return
    end

    if self:GetNWBool("DontShow") then
        if IsValid(self.worldModel) then
           self.worldModel:SetNoDraw(true)
           return
        end
    else
        if IsValid(self.worldModel) then
            self.worldModel:SetNoDraw(false)
        end
   end

    local fakeRagdoll = owner:GetNWEntity("FakeRagdoll")
    local zaebal_entity = IsValid(fakeRagdoll) and fakeRagdoll or owner
    local Bone = zaebal_entity:LookupBone(self.HolsterBone)
    if not Bone then return end

    if !zaebal_entity:GetBoneMatrix(Bone) then
        return
    end

    if CLIENT then
        if zaebal_entity:GetPos():Distance(LocalPlayer():GetPos()) > 2000 then
            self.worldModel:SetNoDraw(true)
            return
        else
            self.worldModel:SetNoDraw(false)
        end
    end

    local Pos, Ang = zaebal_entity:GetBonePosition(Bone)
    if not Pos or not Ang then self.worldModel:SetNoDraw(true) return end

    Pos = Pos + Ang:Forward() * self.HolsterPos[1] + Ang:Right() * self.HolsterPos[2] + Ang:Up() * self.HolsterPos[3]
    Ang:RotateAroundAxis(Ang:Forward(), self.HolsterAng[1])
    Ang:RotateAroundAxis(Ang:Right(), self.HolsterAng[2])
    Ang:RotateAroundAxis(Ang:Up(), self.HolsterAng[3])

    local ownerEntity = owner:GetNWBool("Fake") and fakeRagdoll or owner
    WM:SetOwner(ownerEntity)
    WM:SetParent(ownerEntity)
    WM:SetAngles(Ang)
    WM:SetPos(Pos)
    WM:SetRenderAngles(Ang)
    WM:SetRenderOrigin(Pos)

    return Pos,Ang
end

function SWEP:GetSAttachment(obj)
	local pos, ang = self:WorldModel_Transform()
	local owner = self:GetOwner()
	
	local wep = IsValid(owner) and owner:GetNWEntity("ragdollWeapon",self) or self

	local model = self.worldModel

    if !model then
        return
    end
	
	local att = model:GetAttachment(obj)
	
	if not att then return end

	if IsValid(wep) then return att end
	
	local bon = att.Bone or 0
	local mat = model:GetBoneMatrix(bon)
	local bonepos, boneang = mat:GetTranslation(), mat:GetAngles()
	local lpos, lang = WorldToLocal(att.Pos or bonepos, att.Ang or boneang, bonepos, boneang)
	
	if CLIENT then self:SetupBones() end

	local mat = model:GetBoneMatrix(bon)
	local bonepos, boneang = mat:GetTranslation(), mat:GetAngles()

	local pos, ang = LocalToWorld(lpos, lang, bonepos, boneang)
	
	return {Pos = pos, Ang = ang, Bone = bon}
end

function SWEP:GetTraceMuzzle(nomodify)
	local owner = self:GetOwner()
    if !IsValid(self.worldModel) then
        return
    end
	local obj = self.worldModel:LookupAttachment("muzzle") or 0
	
	local att = self:GetSAttachment(self.att or obj)
	
	if not att then
		local Pos, Ang
		
		local wep = IsValid(owner) and owner:GetNWEntity("ragdollWeapon")
		if wep and IsValid(wep) then
			Pos, Ang = wep:GetPos(), wep:GetAngles()
		else
			Pos, Ang = self:WorldModel_Transform()
		end

		att = {Pos = Pos, Ang = Ang}
	end
	
	local pos, ang = att.Pos, att.Ang

    if !ang then
        ang = Angle(0,0,0)
    end

    if !pos then
        pos = Vector(0,0,0)
    end

    pos = pos + ang:Forward() * self.MuzzlePos[1] + ang:Right() * self.MuzzlePos[2] + ang:Up() * self.MuzzlePos[3]
    ang:RotateAroundAxis(ang:Forward(),self.MuzzleAng[1])
    ang:RotateAroundAxis(ang:Right(),self.MuzzleAng[3])
    ang:RotateAroundAxis(ang:Up(),-self.MuzzleAng[2] + 0.75)

	return pos, ang
end

function SWEP:GetTrace(nomodify)
	local owner = self:GetOwner()
	local obj = self:LookupAttachment("muzzle") or 0
	
	local att = self:GetSAttachment(self.att or obj)
	
	if not att then
		local Pos, Ang = self:WorldModel_Transform()

		att = {Pos = Pos, Ang = Ang}
	end
	
	local pos, ang = att.Pos, att.Ang

    if !ang then
        ang = Angle(0,0,0)
    end

    if !pos then
        pos = Vector(0,0,0)
    end

    pos = pos + ang:Forward() * self.AttPos[1] + ang:Right() * self.AttPos[2] + ang:Up() * self.AttPos[3]
    ang:RotateAroundAxis(ang:Forward(),self.AttAng[1])
    ang:RotateAroundAxis(ang:Right(),self.AttAng[3])
    ang:RotateAroundAxis(ang:Up(),-self.AttAng[2] + 0.75)

	return pos, ang
end

concommand.Add("wm_getbones",function(ply)
    local self = ply:GetActiveWeapon()
    if self.worldModel then
        for boneID = 0, self.worldModel:GetBoneCount() - 1 do
            local boneName = self.worldModel:GetBoneName(boneID)
            print(boneName)
        end
    end
end)

concommand.Add("wm_getsequence",function(ply)
    local self = ply:GetActiveWeapon()
    if self.worldModel then
        PrintTable(self.worldModel:GetSequenceList())
    end
end)

hook.Add("PostDrawOpaqueRenderables","Weapon_WorldModelDraw",function()
    for _, ply in ipairs(player.GetAll()) do
        if !ply:Alive() then
        continue 
    end
    if ply == LocalPlayer() then
        continue 
    end
    if ply:GetActiveWeapon().ishgwep then
        local self = ply:GetActiveWeapon()

        self:WorldModel_Transform()
    
        for placement, att in pairs(self.Attachments) do
        if self.Attachments[placement] != NULL then
            local tbl = self.Attachments[placement]
            if self.worldModel == nil then
                continue 
            end
            if !IsValid(self.worldModel) then
                continue 
            end
            if !self.worldModel.GetPos then
                continue 
            end

            if !self.worldModel.GetAngles then
                continue 
            end
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
    end
end)