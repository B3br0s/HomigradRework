if CLIENT then
	concommand.Add("wm_getbones",function(ply)
		local self = ply:GetActiveWeapon()
		if not ply:IsAdmin() then chat.AddText("ПОШЕЛ НАХУЙ") return end
		if self.Base != "homigrad_base" then print("ADS") return end
		if self.worldModel then
			for boneID = 0, self.worldModel:GetBoneCount() - 1 do
				local boneName = self.worldModel:GetBoneName(boneID)
				print(boneName)
			end
		end
	end)
end

function SWEP:DrawCorrectModel()
    if not IsValid(self:GetOwner()) then return end 
    local WM = self.worldModel
    if not IsValid(WM) then self:CreateWorldModel() return end
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

    WM:SetOwner(self:GetOwner())    
    WM:SetParent(self:GetOwner())    
    WM:SetAngles(Ang)
    WM:SetPos(Pos)

    self:SetPos(Pos)
    self:SetAngles(Ang)

    WM:SetRenderAngles(Ang)
    WM:SetRenderOrigin(Pos)
end

function SWEP:DrawHolsterModel()
    local owner = self:GetOwner()
    if not IsValid(owner) or not owner:Alive() then return end

    local WM = self.worldModel
    if not IsValid(WM) then
        self:CreateWorldModel()
        return
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