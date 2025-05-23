SWEP.WorldAng = Angle(0,0,0)
SWEP.WorldPos = Vector(0,0,0)

function SWEP:CreateWorldModel()
    if not IsValid(self:GetOwner()) then return end
    if IsValid(self.worldModel) then return end
    local WorldModel = ClientsideModel(self.WorldModel)

    WorldModel:SetOwner(self:GetOwner())

    self:CallOnRemove("RemoveWM", function() WorldModel:Remove() end)

    self.worldModel = WorldModel

    return WorldModel
end

function SWEP:DrawWM()
    if not IsValid(self:GetOwner()) then return end 
        local WM = self.worldModel
        local owner = self:GetOwner()
        if owner:GetActiveWeapon() != self then
            return
        end
        if not IsValid(WM) then self:CreateWorldModel() return end
        if owner.Fake then self.worldModel:Remove() return end 
        if !owner:Alive() then return end
        local Att = owner:GetAttachment(owner:LookupAttachment("anim_attachment_RH"))
        
        local Pos = Att.Pos
        local Ang = Att.Ang

        WM:SetModelScale(self.CorrectScale or 1,0)
        
        Pos = Pos + Ang:Forward() * self.WorldPos[1] + Ang:Right() * self.WorldPos[2] + Ang:Up() * self.WorldPos[3]
        Ang:RotateAroundAxis(Ang:Forward(),self.WorldAng[1])
        Ang:RotateAroundAxis(Ang:Right(),self.WorldAng[2])
        Ang:RotateAroundAxis(Ang:Up(),self.WorldAng[3])
        
        WM:SetAngles(Ang)
        WM:SetPos(Pos)
        WM:SetOwner(owner)
        WM:SetParent(owner)
        WM:SetPredictable(true)
        
        WM:SetRenderAngles(Ang)
        WM:SetRenderOrigin(Pos)

        return Pos,Ang
end

function SWEP:DrawWorldModel()
    if not IsValid(self:GetOwner()) then self:DrawModel() return end
    local owner = self:GetOwner()

	local Pos,Ang = self:DrawWM()

	if IsValid(self.worldModel) and Pos then
		self.worldModel:SetPos(Pos)
		self.worldModel:SetAngles(Ang)
	end
end