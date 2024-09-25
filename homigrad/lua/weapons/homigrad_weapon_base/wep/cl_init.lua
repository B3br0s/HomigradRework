local ENT = oop.Get("wep")
if not ENT then return end

function ENT:Draw()
	local ent = self:GetNWEntity("LinkDraw")

	if IsValid(ent) then ent:DrawWorldModel() end
end