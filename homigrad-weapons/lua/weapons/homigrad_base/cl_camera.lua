SWEP.ZoomAng = Angle(0,0,0)
SWEP.ZoomPos = Vector(0,0,0)

local lerpaim = 0
local addfov = 0

vis_recoil = 0

local no_fov = (ConVarExists("hg_nofovzoom") and GetConVar("hg_nofovzoom") or CreateClientConVar("hg_nofovzoom","0",true,false,nil,0,1))

function SWEP:Camera(ply, origin, angles, fov)
	local pos, ang = self:WorldModel_Transform()

	lerpaim = LerpFT(0.1, lerpaim, self:IsSighted() and 1 or 0)

	if !pos or ply:GetNWBool("suiciding") or self.speed > 0.2 then
		return origin, angles, fov
	end

	ang[3] = 0

	ang:RotateAroundAxis(ang:Right(),self.ZoomAng[1] * lerpaim)
    ang:RotateAroundAxis(ang:Up(),self.ZoomAng[2] * lerpaim)
    ang:RotateAroundAxis(ang:Forward(),self.ZoomAng[3] * lerpaim)
	
	local neworigin, _ = LocalToWorld(self.ZoomPos, self.ZoomAng, pos, ply:EyeAngles())
	origin = Lerp(lerpaim,origin,neworigin)

	if self.Attachments["sight"][1] then
		if self.Attachments["sight"][1] and self.Attachments["sight"][1].ViewPos then
			local neworigin, _ = LocalToWorld(self.Attachments["sight"][1].ViewPos, ang, neworigin, ang)
			origin = Lerp(lerpaim,origin,neworigin)
		end
	end
	origin = origin + ang:Forward() * Recoil
	origin = origin + ang:Forward() * 2 * Recoil + ang:Up() * vis_recoil / 2

	//ang = ang + Angle(5 * vis_recoil,0,0)
	
	if !no_fov:GetBool() then
		addfov = LerpFT(0.1, addfov, self:IsSighted() and -(self.addfov or 25) or 0)
	end

	return origin, (ang * lerpaim) + angles * (1 - lerpaim), fov + addfov
end