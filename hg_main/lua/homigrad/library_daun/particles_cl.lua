local min,max = math.min,math.max

ParticleMatSmoke = {}
for i = 1,6 do ParticleMatSmoke[i] = Material("particle/smokesprites_000" .. i) end

local nextCalculateThinkMin,nextCalculateThinkMax

local Rand,random = math.Rand,math.random

hook.Add("Think","hg",function()
    CTime = CurTime()
end)

ParticleLightFunc = function(self)
    local Time = CTime

    if (self.delayLight or 0) < Time then
       // self.delayLight = Time + Rand(nextCalculateThinkMin,nextCalculateThinkMax)

        local r,g,b = self.r,self.g,self.b

        if not r then
            r,g,b = self:GetColor()
 
            self.r = r
            self.g = g
            self.b = b
        end

        /*local matrix = LightCalculate(self:GetPos(),Lerp(self:GetLifeTime() / self:GetDieTime(),self:GetStartSize(),self:GetEndSize()) / 2)

        local r,g,b = LightApply(matrix,r,g,b)

        self.sR = r
        self.sG = g
        self.sB = b*/
    end

    local r,g,b = self:GetColor()

    self.start = Time
    
    local t = 0.75

    //self:SetColor(Lerp(t,r,self.sR),Lerp(t,g,self.sG),Lerp(t,b,self.sB))

    if self:Think() ~= false then
        self:SetNextThink(Time + Rand(0.1,0.25))
    else
        self:SetNextThink(Time)
    end
end

ParticlesList = ParticlesList or {}
local ParticlesList = ParticlesList

local meta = FindMetaTable("CLuaEmitter")
local meta_Add = meta.Add
local meta_Finish = meta.Finish

local function Remove(self)
    if self.removed then return end
    self.removed = true

    ParticlesList[self] = nil

    if self.OnRemove then self:OnRemove() end
    
    self:SetDieTime(0)
end

local function Think()

end

local function IsValid(self)
    return self:GetDieTime() < CurTime()
end

local function Add(self,mat,pos)
    local part = meta_Add(self.original,mat,pos)
    
    ParticlesList[part] = true
    
    part.create = CTime
    
    part.Think = Think

    if CTime then
    part:SetNextThink(CTime)
    end
    part:SetThinkFunction(ParticleLightFunc)
    part.IsValid = IsValid

    part.Remove = Remove

    return part
end

local function Finish(self)
    meta_Finish(self.original)
end

ParticleGravity = Vector(0,0,-400)

function ParticleEmit(pos)
    local fake = {}
    fake.Add = Add
    fake.original = ParticleEmitter(pos)
    fake.Finish = Finish

    return fake
end

concommand.Add("hg_particle",function(ply)
    local tr =  LocalPlayer():GetEyeTrace()
    local pos = tr.HitPos + tr.HitNormal * 25
    
    local emitter = ParticleEmit(pos)
    
    for i = 0,250 do
        local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)

        if part then
            part:SetDieTime(Rand(9,11))
    
            part:SetStartAlpha(200)
            part:SetEndAlpha(0)
    
            part:SetStartSize(125)
            part:SetEndSize(100)
    
            part:SetGravity(Vector(0,0,0))
            part:SetVelocity(Vector(Rand(-55,55) * Rand(0.5,2),Rand(-55,55) * Rand(0.5,2),Rand(-5,5)))
            part:SetCollide(true)
            part:SetBounce(0.25)
            part:SetLighting(false)--пашол нахуй
        end
    end
    
    emitter:Finish()
end)

local delay = 0

hook.Add("Think","ParticlesList",function()
    local time = CurTime()
    if delay > time then return end
    delay = time + 0.25

    for part in pairs(ParticlesList) do--меня убъют на районе за такое блядь
        if not IsValid(part) then part:Remove() end
    end
end)

hook.Add("PostCleanupMap","ParticlesList",function()
    for part in pairs(ParticlesList) do
        if IsValid(part) then
            part:Remove()
        end
    end
end)