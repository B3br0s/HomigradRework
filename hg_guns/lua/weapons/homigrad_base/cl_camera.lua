local IsScoping = false
local ScopeLerp = 0

SWEP.ZoomPos = Vector(0,0,0)
SWEP.ZoomAng = Angle(0, 0, 0)

local addfov = 0

local lerpaim = 0

function SWEP:IsSprinting()
    if IsValid(self:GetOwner()) then
        return self:GetOwner():IsSprinting()
    else
        return false
    end
end

function SWEP:AdjustMouseSensitivity()
    return self:IsSighted() and 0.5 or 1
end

function SWEP:Camera(ply, origin, angles, fov)
    if !self.Deployed then
        return origin, angles, fov
    end
    local pos, ang = self:GetTraceModel(true)
    local tr = self:GetTrace()
    local _, anglef = self:GetTraceModel()

    local att = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))

    //pos = att.Pos
    //ang = att.Ang
    
    lerpaim = LerpFT(0.2, lerpaim, self:IsSighted() and 1 or 0)
    
    local neworigin, _ = LocalToWorld(self.ZoomPos, self.ZoomAng, pos, ang)

    local newangs = angles
    newangs:RotateAroundAxis(newangs:Forward(),self.ZoomAng[1] * lerpaim)
    newangs:RotateAroundAxis(newangs:Right(),self.ZoomAng[2] * lerpaim)
    newangs:RotateAroundAxis(newangs:Up(),self.ZoomAng[3] * lerpaim)

    origin = Lerp(lerpaim,origin,neworigin)
    
    local animpos = math.max(self:LastShootTime() - CurTime() + 0.1,0) * 20
    origin = origin + anglef:Forward() * animpos
    
    origin = origin + anglef:Right() * math.random(-0.1,0.1) * (animpos/200) + anglef:Up() * math.random(-0.1,0.1) * (animpos/200)
    
    addfov = LerpFT(0.1, addfov, self:IsSighted() and -(self.addfov or 30) or 0)

    if !self.reload then
        newangs[3] = (att.Ang[3] * (0.5 - self.saim)) * (1 - self.SpeedAnim) + (angles[3] * (1 - self.saim)) * (1 - self.SpeedAnim)
        --newangs[2] = (att.Ang[2] * self.saim) * (1 - self.SpeedAnim) + (angles[2] * (1 - self.saim))
        //newangs[1] = (att.Ang[1] * 0.95 * self.saim) + (angles[1] * (1 - self.saim))
    end

    return origin, newangs, fov + addfov
end