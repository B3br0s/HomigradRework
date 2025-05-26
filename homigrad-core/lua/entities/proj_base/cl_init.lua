include("shared.lua")
function ENT:Draw()
	self:DrawModel()

	if self:GetNWBool("Launched") then
		local Eff = EffectData()
		Eff:SetOrigin(self:GetPos()+ self:GetAngles():Forward() * -75)
		Eff:SetNormal(-self:GetAngles():Forward() * 10)
		Eff:SetScale(1.5)
		util.Effect("eff_jack_rockettrust", Eff, true, true)
	end
end