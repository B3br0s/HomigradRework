local SWEP = oop.Get("hg_wep")
if not SWEP then return end

SWEP.eyeSpray = Angle()
SWEP.eyeSpraySet = Angle()

local angZero = Angle()

SWEP.eyeSprayLSet = 0.5
SWEP.eyeSprayLReset = 0.25

SWEP:Event_Add("Step Local","Eye",function(self,ply)
    self:ApplyEye()
    
    self.eyeSpray:LerpFT(self.eyeSprayLSet,self.eyeSpraySet)
    self.eyeSpraySet:LerpFT(self.eyeSprayLReset)
end)

local min = math.min

SWEP.eyeSprayHoldK = 1

function SWEP:ApplyEye()
    local ply = self:GetOwner()
    local k = min(1 + (CurTime() - self.attackHold) * self.eyeSprayHoldK,5)

    ply:SetEyeAngles(ply:EyeAngles():Add(self.eyeSpray * k))
end

SWEP.eyeSprayH = 0.3

SWEP.eyeSpraySinAddW = 0
SWEP.eyeSpraySinW = 0.075
SWEP.eyeSpraySinFreqW = 3

SWEP.eyeSpraySinRandW = 0.2
SWEP.eyeSprayRandW = 0.1

function SWEP:ApplySpray()
    local time = CurTime() - self.attackHold

    local add = Angle(
        -math.Rand(0.1,0.2) * self.eyeSprayH * math.Rand(0.95,1.05),
        math.sin(self.eyeSpraySinAddW + time * self.eyeSpraySinFreqW + self.eyeSpraySinRandW * math.Rand(-0.1,0.1)) * self.eyeSpraySinW * math.Rand(0.95,1.05) +
        self.eyeSprayRandW * math.Rand(-0.35,0.35) * math.Rand(0.95,1.05),
        0)

    add:Add(Angle(0,math.Rand(-0.15,0.15)))

    self.eyeSpraySet:Add(add)

    self:ApplyEye()
end