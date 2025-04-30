if CLIENT then
	concommand.Add("wm_getbones",function(ply)
		local self = ply:GetActiveWeapon()
		if self.worldModel then
			for boneID = 0, self.worldModel:GetBoneCount() - 1 do
				local boneName = self.worldModel:GetBoneName(boneID)
				print(boneName)
			end
		end
	end)
end

SWEP.localpos = Vector(0,0,0)
SWEP.localang = Angle(0,0,0)

function SWEP:GetTransform(model, force)
    local owner = self:GetOwner()
	local model = IsValid(model) and model
	
    if owner:GetActiveWeapon() != self then
        return
    end

	if not IsValid(owner) then return self:GetPos(),self:GetAngles() end

	if not IsValid(model) then
		self.worldModel = IsValid(self.worldModel) and self.worldModel or self:CreateWorldModel()
		model = self.worldModel
	end

	local wep = owner:GetNWEntity("ragdollWeapon")
	if IsValid(wep) and not force then return wep:GetPos(),wep:GetAngles() end
	
	local owner = IsValid(owner.FakeRagdoll) and owner.FakeRagdoll or owner
	local model = IsValid(wep) and wep or model

	if CLIENT then model:SetPredictable(true) end

	if CLIENT then owner:SetupBones() model:SetupBones() end

	local bon = owner:LookupBone("ValveBiped.Bip01_R_Hand")

	if not bon then return self:GetPos(),self:GetAngles() end

	local rh = owner:GetBoneMatrix(bon)

	if owner:IsRagdoll() then--fuck source engine
		rh = Matrix()
		local phys = owner:GetPhysicsObjectNum(owner:TranslateBoneToPhysBone(bon))
		local pos, ang = phys:GetPos(), phys:GetAngles()
		rh:SetTranslation(pos)
		rh:SetAngles(ang)
	end

	if not rh then return self:GetPos(),self:GetAngles() end

	local pos,ang = rh:GetTranslation(),rh:GetAngles()

	local oldpos,oldang = model:GetPos(),model:GetAngles()

	local owner = self:GetOwner()
    if owner.Fake then self.worldModel:Remove() return end 
    if !owner:Alive() then return end
    local Att = owner:GetAttachment(owner:LookupAttachment("anim_attachment_RH"))

    local Pos = Att.Pos
    local Ang = Att.Ang

    Pos = Pos + Ang:Forward() * self.CorrectPos[1] + Ang:Right() * self.CorrectPos[2] + Ang:Up() * self.CorrectPos[3]
    Ang:RotateAroundAxis(Ang:Forward(),self.CorrectAng[1])
    Ang:RotateAroundAxis(Ang:Right(),self.CorrectAng[2])
    Ang:RotateAroundAxis(Ang:Up(),self.CorrectAng[3])

	if CLIENT then
		model:SetRenderOrigin(Pos)
    	model:SetRenderAngles(Ang)
	end
	
	if CLIENT then model:SetupBones() end

	local bon2 = model:LookupBone("ValveBiped.Bip01_R_Hand")
	if bon2 then
		local rh_wep = model:GetBoneMatrix(bon2)

		if rh_wep and rh then
			local newmat = rh_wep:GetInverse() * rh

			pos, ang = LocalToWorld(newmat:GetTranslation(),newmat:GetAngles(), pos, ang)
		end
	end

	model:SetPos(oldpos)
	model:SetAngles(oldang)

    --pos:Add(ang:Forward() * self.CorrectPos[1])
    --pos:Add(ang:Right() * self.CorrectPos[2])
    --pos:Add(ang:Up() * self.CorrectPos[3])

	local timehuy = 0.1
	local animpos = math.ease.InBack(math.max(self:LastShootTime() - CurTime() + timehuy,0) / timehuy) * 1
	
    return pos, ang
end

function SWEP:DrawWM()
    if not IsValid(self:GetOwner()) then return end 
        local WM = self.worldModel
        local owner = self:GetOwner()
        if owner:GetActiveWeapon() != self then
            return
        end
        if not IsValid(WM) then self:CreateWorldModel() return end
        WM:SetNoDraw(false)
        if owner.Fake then self.worldModel:Remove() return end 
        if !owner:Alive() then return end
        local Att = owner:GetAttachment(owner:LookupAttachment("anim_attachment_RH"))
        
        local Pos = Att.Pos
        local Ang = Att.Ang
        
        Pos = Pos + Ang:Forward() * self.CorrectPos[1] + Ang:Right() * self.CorrectPos[2] + Ang:Up() * self.CorrectPos[3]
        Ang:RotateAroundAxis(Ang:Forward(),self.CorrectAng[1])
        Ang:RotateAroundAxis(Ang:Right(),self.CorrectAng[2])
        Ang:RotateAroundAxis(Ang:Up(),self.CorrectAng[3])
        
        WM:SetAngles(Ang)
        WM:SetPos(Pos)
        WM:SetOwner(owner)
        WM:SetParent(owner)
        WM:SetPredictable(true)
        
        WM:SetRenderAngles(Ang)
        WM:SetRenderOrigin(Pos)

        return Pos,Ang
end

function SWEP:DrawHolsterModel()
    local owner = self:GetOwner()
    if not IsValid(owner) or not owner:Alive() then return end

    local WM = self.worldModel
    if not IsValid(WM) then
        self:CreateWorldModel()
        return
    end

    if self:GetNWBool("DontShow") then
        if IsValid(self.worldModel) then
           self.worldModel:SetNoDraw(true)
        end
    else
        if IsValid(self.worldModel) then
            self.worldModel:SetNoDraw(false)
        end
   end

    local fakeRagdoll = owner:GetNWEntity("FakeRagdoll")
    local boneEntity = IsValid(fakeRagdoll) and fakeRagdoll or owner
    local Bone = boneEntity:LookupBone(self.HolsterBone)
    if not Bone then return end

    local Pos, Ang = boneEntity:GetBonePosition(Bone)
    if not Pos or not Ang then return end

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

function SWEP:CreateWorldModel()
    if not IsValid(self:GetOwner()) then return end
    if IsValid(self.worldModel) then return end
    local WorldModel = ClientsideModel(self.WorldModel)

    WorldModel:SetOwner(self:GetOwner())

    self:CallOnRemove("RemoveWM", function() WorldModel:Remove() end)

    self.worldModel = WorldModel

    return WorldModel
end