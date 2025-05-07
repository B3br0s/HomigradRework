local IsScoping = false
local ScopeLerp = 0

SWEP.ZoomPos = Vector(-15,0.15,0.65)
SWEP.ZoomAng = Angle(0,0,0)

local addfov = 0

local lerpaim = 0
local lerpaima = 0

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

SWEP.saim = 0

function SWEP:Camera(ply, origin, angles, fov)
    if !self.Deployed then
        return origin, angles, fov
    end
    local pos, ang = self:GetTrace(true)
    local _, anglef = self:GetTrace()

    local att = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))

    //pos = att.Pos
    //ang = att.Ang
    
    lerpaim = LerpFT(0.15, lerpaim, self:IsSighted() and 1 or 0)

    if !pos or !ang then
        return origin, angles, fov
    end
    
    local neworigin, _ = LocalToWorld(self.ZoomPos, self.ZoomAng, pos, ang)

    local newangs = angles
    newangs:RotateAroundAxis(newangs:Forward(),self.ZoomAng[1] * lerpaim)
    newangs:RotateAroundAxis(newangs:Right(),self.ZoomAng[2] * lerpaim)
    newangs:RotateAroundAxis(newangs:Up(),self.ZoomAng[3] * lerpaim)

    origin = Lerp(lerpaim,origin,neworigin)
    
    local animpos = Recoil * math.random(1,2) / 2
    origin = (origin + att.Ang:Forward() * animpos * 7) + att.Ang:Forward() * (0.75 * lerpaim)

    origin = origin + angles:Up() * (RecoilS / 6) * lerpaim
    
    //origin = origin + anglef:Right() * math.random(-0.1,0.1) * (animpos/200) + anglef:Up() * math.random(-0.1,0.1) * (animpos/200)
    
    addfov = LerpFT(0.1, addfov, self:IsSighted() and -(self.addfov or 30) - Recoil * 10 or 0)

    local removemul = (RecoilS / 4) * lerpaim

    if !self.reload  then
        newangs[3] = (att.Ang[3] * (0.5 - self.saim)) * (1 - self.SpeedAnim) + (angles[3] * (1 - self.saim)) * (1 - self.SpeedAnim)
        --newangs[2] = (att.Ang[2] * self.saim) * (1 - self.SpeedAnim) + (angles[2] * (1 - self.saim))
        //newangs[1] = (att.Ang[1] * 0.95 * self.saim) + (angles[1] * (1 - self.saim))
    end

    local siht = (att.Pos - origin):Angle()
    siht[2] = att.Ang[2]
    siht[3] = angles[3]
    siht[1] = att.Ang[1] + RecoilS / 1.5
    siht:RotateAroundAxis(siht:Forward(),self.ZoomAng[1] * lerpaim)
    siht:RotateAroundAxis(siht:Right(),self.ZoomAng[2] * lerpaim)
    siht:RotateAroundAxis(siht:Up(),self.ZoomAng[3] * lerpaim)

    return origin, ((siht * lerpaim) + (angles * (1 - lerpaim))), fov + addfov
end