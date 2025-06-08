SWEP.ZoomAng = Angle(0,0,0)
SWEP.ZoomPos = Vector(0,0,0)

local lerpaim = 0
local addfov = 0

local aim_shit = 0
local aim_shit_lerp = 0

local MAMA_KSILANA_SHLUHA = Angle(0,0,0)

local aimed = false

vis_recoil = 0

govno_recoil = 0

local no_fov = (ConVarExists("hg_nofovzoom") and GetConVar("hg_nofovzoom") or CreateClientConVar("hg_nofovzoom","0",true,false,nil,0,1))

function SWEP:UnZoom()
	aim_shit = 0
	if IsValid(self.worldModel) then
		self.worldModel:EmitSound("weapons/shove_0"..math.random(1,5)..".wav",50,math.random(110,120),0.5)
	end
end

function SWEP:Zoom()
	aim_shit = 2
	if IsValid(self.worldModel) then
		self.worldModel:EmitSound("weapons/shove_0"..math.random(1,5)..".wav",50,math.random(90,110),0.5)
	end
end

function SWEP:Camera(ply, origin, angles, fov)
	local pos, ang = self:WorldModel_Transform()

	vis_recoil = LerpFT(0.075,vis_recoil,0)
	govno_recoil = LerpFT(0.25,govno_recoil,0)

	lerpaim = LerpFT(self:IsSighted() and 0.04 or 0.05, lerpaim, self:IsSighted() and 1 or 0)

	if !no_fov:GetBool() then
		addfov = -(self.addfov or 25) * lerpaim
	end

	if (!pos or ply:GetNWBool("suiciding") or self:IsSprinting()) and !ply:GetNWBool("Fake") or self.reload then
		lerpaim = LerpFT(0.05, lerpaim,0)
		MAMA_KSILANA_SHLUHA = angles
		addfov = 0
		return origin, angles, fov + addfov
	end

	if !self:IsSighted() and aimed then
		aimed = false
		self:UnZoom()
	elseif self:IsSighted() and !aimed then
		aimed = true
		self:Zoom()
	end

	aim_shit_lerp = LerpFT(0.2,aim_shit_lerp,aim_shit)

	if !ang then
		ang = angles
	end

	ang[3] = angles[3] + aim_shit_lerp

	ang:RotateAroundAxis(ang:Right(),self.ZoomAng[1] * lerpaim)
    ang:RotateAroundAxis(ang:Up(),self.ZoomAng[2] * lerpaim)
    ang:RotateAroundAxis(ang:Forward(),self.ZoomAng[3] * lerpaim)

	local zalupa = math.AngleDifference(MAMA_KSILANA_SHLUHA[2],angles[2])
	local zalupa2 = math.AngleDifference(MAMA_KSILANA_SHLUHA[1],angles[1])

	if !self:IsSighted() then
		MAMA_KSILANA_SHLUHA = LerpAngleFT(0.2,MAMA_KSILANA_SHLUHA,angles)
	elseif self:IsSighted() then
		MAMA_KSILANA_SHLUHA = LerpAngleFT(0.15,MAMA_KSILANA_SHLUHA,ang)
	end

	origin = origin + angles:Right() * zalupa / 6
	origin = origin + angles:Up() * zalupa2 / 4

	if !pos then
		pos = origin
	end
	
	local neworigin, _ = LocalToWorld(self.ZoomPos, self.ZoomAng, pos, ply:EyeAngles())
	origin = Lerp(lerpaim,origin,neworigin)

	if self.Attachments["sight"][1] then
		if self.Attachments["sight"][1] and hg.GetAtt(self.Attachments["sight"][1]).ViewPos then
			local neworigin, _ = LocalToWorld(hg.GetAtt(self.Attachments["sight"][1]).ViewPos + (IsValid(self.AttDrawModels["sight_mount"]) and Vector(0,0,0.7) or Vector(0,0,0)), ang, neworigin, ang)
			origin = Lerp(lerpaim,origin,neworigin)
		end
	end
	origin = origin + ang:Forward() * Recoil
	origin = origin + ang:Forward() * 2 * Recoil + ang:Up() * vis_recoil / 2
	//origin = origin + ang:Right() * govno_recoil * Recoil

	//ang = ang + Angle(5 * vis_recoil,0,0)

	angles[2] = MAMA_KSILANA_SHLUHA[2]
	angles[1] = MAMA_KSILANA_SHLUHA[1]

	return origin, (MAMA_KSILANA_SHLUHA * lerpaim) + angles * (1 - lerpaim), fov + addfov
end