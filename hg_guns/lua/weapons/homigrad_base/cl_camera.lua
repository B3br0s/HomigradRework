--НИГГА ЩИЩ ЙОУУУ!!!
local IsScoping = false
local ScopeLerp = 0

SWEP.ZoomPos = Vector(0,0,5)
function SWEP:Camera(Pos,Ang)
    local lply = self:GetOwner()
    local Att = lply:LookupAttachment("anim_attachment_RH")
    local Attachment = lply:GetAttachment(Att)
    local CamPos = (IsScoping and Attachment.Pos or Pos)
    local CamAng = lply:EyeAngles()

    --Ang[3] = (Ang[3] * (1 - ScopeLerp)) + Attachment.Ang[3] * ScopeLerp
    Ang[2] = (Ang[2] * (1 - ScopeLerp)) + Attachment.Ang[2] * ScopeLerp
    Ang[1] = (Ang[1] * (1 - ScopeLerp)) + Attachment.Ang[1] * ScopeLerp

    if IsScoping then
        CamPos = (Attachment.Pos + Attachment.Ang:Forward() * self.ZoomPos[1] + Attachment.Ang:Right() * self.ZoomPos[2] + Attachment.Ang:Up() * self.ZoomPos[3]) * ScopeLerp + (Pos * (1 - ScopeLerp))
        --CamPos = CamPos + Attachment.Ang:Forward() * self.ZoomPos[1] + Attachment.Ang:Right() * self.ZoomPos[2] + Attachment.Ang:Up() * self.ZoomPos[3]
        CamAng = Ang
    else
        CamPos = Pos * (1 - ScopeLerp) + ((Attachment.Pos + Attachment.Ang:Forward() * self.ZoomPos[1] + Attachment.Ang:Right() * self.ZoomPos[2] + Attachment.Ang:Up() * self.ZoomPos[3]) * ScopeLerp)
        CamAng = Ang
    end

    return CamPos,CamAng
end

function SWEP:Zoom()
    local lply = self:GetOwner()
    if lply:KeyDown(IN_ATTACK2) and !lply:KeyDown(IN_SPEED) then
        IsScoping = true
        ScopeLerp = LerpFT(0.1,ScopeLerp,1)
    else
        IsScoping = false
        ScopeLerp = LerpFT(0.1,ScopeLerp,0)
    end
end