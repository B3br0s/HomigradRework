function SWEP:IsPistolHoldType()
    if self.HoldType == "revolver" then
        return true 
    else
        return false
    end
end

function SWEP:CanShoot()
    return (!self.reload and !self.Inspecting and self:Clip1() > 0 and !self:IsSprinting() and !self:IsClose())
end

function SWEP:Lobotomy_Sharik()
	//Залупня
end

function SWEP:IsSighted()
	local ply = self:GetOwner()
	if ply:IsNPC() then return end

	if (self:IsLocal() or SERVER) and ply:IsPlayer() then
		local is = not self:IsSprinting() and ply:KeyDown(IN_ATTACK2) and !self.reload
		self:SetNWBool("IsSighted",is)
		return is
	else
		return self:GetNWBool("IsSighted")
	end
end

function SWEP:IsClose()
	local ply = self:GetOwner()

	local angs = ply:GetAngles()
	angs.p = 0

	local tf = util.TraceLine({
		start = ply:GetPos() + (ply:OBBCenter() - vector_up * 9),
		endpos = ply:GetPos() + (ply:OBBCenter() - vector_up * 9) + angs:Forward() * 40,
		filter = {ply}
	})

	local dist = tf.HitPos:Distance(ply:GetPos())

	if SERVER then
		if dist < 40 then
			self.isClose = true
		else
			self.isClose = false
		end

		self:SetNWBool("IsClose",self.isClose)

		return self.isClose
	else
		return self:GetNWBool("IsClose")
	end
end

function SWEP:IsSprinting()
	local ply = self:GetOwner() 

	if self:IsClose() then
		return true
	end

	if !IsValid(ply) then
		return false
	end

	if ply.Fake then
		return false
	end

	if ply:IsSprinting() then
		return true
	end

	return false
end

function SWEP:IsLocal()
	return CLIENT and self:GetOwner() == LocalPlayer()
end