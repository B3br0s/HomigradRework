function SWEP:GetSAttachment(obj)
	local pos, ang = self:WorldModel_Transform()
	local owner = self:GetOwner()
	
	local wep = IsValid(owner) and owner:GetNWEntity("ragdollWeapon",self) or self

	local model = self.worldModel
	
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

function SWEP:WorldModel_Transform()
    local mdl = self.worldModel

    local ply = self:GetOwner()

    if !IsValid(ply) then
        return
    end

    local Att = {}

    if !ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_R_Hand")) then
        return
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

    local plyang = ply:EyeAngles()
	//plyang:RotateAroundAxis(plyang:Forward(),180)

	local _,newAng = LocalToWorld(vector_origin,self.localAng or angle_zero,vector_origin,plyang)
	local ang = Angle(newAng[1],newAng[2],newAng[3])

    Ang = ang
    
    Pos = Pos + Ang:Forward() * self.CorrectPos[1] + Ang:Right() * self.CorrectPos[2] + Ang:Up() * self.CorrectPos[3]
    Ang:RotateAroundAxis(Ang:Forward(),self.CorrectAng[1])
    Ang:RotateAroundAxis(Ang:Right(),self.CorrectAng[2])
    Ang:RotateAroundAxis(Ang:Up(),self.CorrectAng[3])

    Ang = Ang - (self:IsSighted() and Angle(0,0,0) or Angle(12 * (self.sprayI * self.RecoilForce * 1.5)))
    
    mdl:SetAngles(Ang)
    mdl:SetPos(Pos)
    mdl:SetOwner(ply)

    self:SetNWVector("WorldPos",Pos)
    self:SetNW2Angle("WorldAng",Ang)

    return Pos,Ang
end

function SWEP:WorldModel_Holster_Transform()
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
    //WM:SetOwner(ownerEntity)
    //WM:SetParent(ownerEntity)
    WM:SetAngles(Ang)
    WM:SetPos(Pos)
    //WM:SetRenderAngles(Ang)
    //WM:SetRenderOrigin(Pos)

    return Pos,Ang
end

function SWEP:GetTrace(nomodify)
	local owner = self:GetOwner()
	local obj = self:LookupAttachment("muzzle") or 0
	
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

    pos = pos + ang:Forward() * self.AttPos[1] + ang:Right() * self.AttPos[2] + ang:Up() * self.AttPos[3]
    ang:RotateAroundAxis(ang:Forward(),self.AttAng[1])
    ang:RotateAroundAxis(ang:Right(),self.AttAng[3])
    ang:RotateAroundAxis(ang:Up(),-self.AttAng[2] + 0.75)

    self:SetNWVector("Muzzle",pos)
    self:SetNW2Angle("Muzzle",ang)

	return pos, ang
end