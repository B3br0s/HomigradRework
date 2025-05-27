SWEP.ZoomAng = Angle(0,0,0)
SWEP.ZoomPos = Vector(0,0,0)

local lerpaim = 0
local addfov = 0

vis_recoil = 0

function SWEP:Camera(ply, origin, angles, fov)
	local pos, ang = self:WorldModel_Transform()

	lerpaim = LerpFT(0.1, lerpaim, self:IsSighted() and 1 or 0)

	if !pos or ply:GetNWBool("suiciding") or self.speed > 0.2 then
		return origin, angles, fov
	end

	ang:RotateAroundAxis(ang:Right(),self.ZoomAng[1] * lerpaim)
    ang:RotateAroundAxis(ang:Up(),self.ZoomAng[2] * lerpaim)
    ang:RotateAroundAxis(ang:Forward(),self.ZoomAng[3] * lerpaim)
	
	local neworigin, _ = LocalToWorld(self.ZoomPos, self.ZoomAng, pos, ang)
	origin = Lerp(lerpaim,origin,neworigin)

	origin = origin + ang:Forward() * 2 * Recoil + ang:Up() * vis_recoil / 2
	origin = origin + ang:Forward() * Recoil
	//ang = ang + Angle(5 * vis_recoil,0,0)
	
	addfov = LerpFT(0.1, addfov, self:IsSighted() and -(self.addfov or 10) or 0)
	return origin, (ang * lerpaim) + angles * (1 - lerpaim), fov + addfov
end

hook.Add("AdjustMouseSensitivity","Homigrad-Camera",function()
	local lply = LocalPlayer()

	vis_recoil = LerpFT(0.075,vis_recoil,0)

	if !lply:Alive() then
		return 1
	end

	local wep = lply:GetActiveWeapon()

	if wep.IsSighted and wep:IsSighted() then
		return 0.5
	end
	
	return 1
end)