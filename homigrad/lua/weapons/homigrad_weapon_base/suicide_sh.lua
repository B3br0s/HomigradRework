local SWEP = oop.Get("hg_wep")
if not SWEP then return end

if SERVER then
	concommand.Add("suicide",function(ply)
		if not ply:Alive() then return end

		ply.suiciding = not ply.suiciding
		ply:SetNWBool("Suiciding",ply.suiciding)
	end)
end

event.Add("Death","suciding",function(dmgTab)
	local ply = dmgTab.target
	if not ply:IsPlayer() then return end

	ply.suiciding = false
	ply:SetNWBool("Suiciding",false)
end)

local angSuicide = Angle(160,30,90)
local angSuicide2 = Angle(160,30,90)
local angSuicide3 = Angle(60,-30,90)

SWEP:Event_Add("Step","Suicide",function(self,ply)
	if not self:CanFight() then return end

	if ply:GetNWBool("Suiciding") then
		if not self.FakeVec2 then
			self:SetStandType("normal")

			ply.rforearm:Set(angSuicide2)
			ply.rhand:Set(angSuicide3)
		else
			self:SetStandType("normal")

			ply.rhand:Set(angSuicide)
		end
	end
end)