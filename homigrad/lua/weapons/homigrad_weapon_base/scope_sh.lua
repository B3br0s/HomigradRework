local SWEP = oop.Get("hg_wep")
if not SWEP then return end

SWEP.lerpScope = 0

function SWEP:IsScopePre() return true end

function SWEP:IsScope()
	local ply = self:GetOwner()

	if self:IsLocal() then
		if not self:CanFight() then return false end

		if not IsValid(ply:GetNWEntity("Ragdoll")) and ply:KeyDown(IN_ATTACK2) and not ply:GetNWBool("Suiciding") then return self:IsScopePre() end
	else
		return self:GetNWBool("IsScope")
	end

	return false
end

SWEP:Event_Add("Step","Scope",function(self,owner)
	if owner:IsNPC() then return end

	local scope = self:IsScope()

	if SERVER then
		self:SetNWBool("IsScope",scope)
	elseif self:IsLocal() then
		if self.oldScope ~= scope then
			self.oldScope = scope

			SoundEmit(-1,scope and (self.ZoomInSound or "homigrad/player/deploy1.wav") or (self.ZoomOutSound or "homigrad/player/holster2.wav"),70,1,125,owner:GetPos())
		end
	end
end)