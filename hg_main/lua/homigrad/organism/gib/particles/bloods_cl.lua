local util_Decal = util.Decal
local sound_Play = sound.Play

local Rand,random = math.Rand,math.random

ParticleMatBlood = {}
for i = 1,3 do ParticleMatBlood[i] = Material("decals/blood" .. i + 5) end

local util_TraceLine = util.TraceLine

local tr = {}

local bloods = {}

function blood_CollideFunc(part,hitPos,hitNormal)
    util_Decal("Blood",hitPos + hitNormal,hitPos - hitNormal)
    sound_Play("ambient/water/drip" .. random(1,4) .. ".wav",hitPos,60,random(230,240))

    part:SetDieTime(0)

    /*tr.start = hitPos
    tr.endpos = hitPos
    
    local tr = util_TraceLine(tr)
    local lply = LocalPlayer()
    local ent = tr.Entity
    
    if ent == lply and hitPos:Distance(lpy:GetPos()) <= 128 then
        local pos = (hitPos):ToScreen()--ну блядь........................
        if not pos.visible then return end

        lply:EmitSound("ambient/water/rain_drip" .. random(1,4) .. ".wav",75,255,1,nil,nil,nil)

        local delay = Rand(1,3)

        bloods[#bloods + 1] = {pos.x,pos.y,random(300,400),random(300,400),random(0,360),CurTime() + delay,delay}
    end*/
end

local timer_Simple = timer.Simple

function blood_CollideFunc2(part,hitPos,hitNormal)
    util_Decal("Blood",hitPos + hitNormal,hitPos - hitNormal)

    if part.Pos:Distance(hitPos) > 75 then
        sound.Emit(nil,"physics/flesh/flesh_bloody_impact_hard1.wav",75,0.5,Rand(125,130),hitPos)
    end

    part:SetDieTime(0)
end

/*local Mat = Material("particle/smokestack_nofog")

hook.Add("HUDPaint","Blood In Screen",function()
    local i = 1
    local Time = CurTime()

    surface.SetMaterial(Mat)

    while true do
        local bld = bloods[i]
        if not bld then break end

        local anim = 1 - (Time - bld[6]) / bld[7]
        if anim <= 0 then table.remove(bloods,i) continue end
        
        surface.SetDrawColor(255,0,0,125 * anim)
        surface.DrawTexturedRectRotated(bld[1],bld[2],bld[3],bld[4],bld[5])

        i = i + 1
    end
end)*/

local function think(self)
    if bit.band(util.PointContents(self:GetPos() + Vector(0,0,32)),CONTENTS_WATER) ~= CONTENTS_WATER then
        part:SetVelocity(part:GetVelocity() + Vector(0,0,250))
    end
end

local function bleedInWater(pos,vel)
    local emitter = ParticleEmitter(pos)

    vel = VectorRand():Mul(12)

    local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
    if part then
        part:SetDieTime(Rand(15,20))

        part:SetColor(Rand(75,80),0,0)
        part:SetStartAlpha(Rand(90,100))
        part:SetEndAlpha(0)

        part:SetStartSize(Rand(8,10))
        part:SetEndSize(Rand(75,100))

        part:SetVelocity(vel)
        part:SetRoll(Rand(-10,10))
    end
    emitter:Finish()
end

function blood_Bleed(pos,vel,sizeStart,sizeend,dieTime)
    if bit.band(util.PointContents(pos),CONTENTS_WATER) == CONTENTS_WATER then
        bleedInWater(pos,vel)
    else
        local emitter = ParticleEmitter(pos)

        local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
        if part then
            part:SetDieTime(dieTime or Rand(15,20))

            part:SetStartAlpha(200)
            part:SetEndAlpha(0)

            part:SetStartSize(sizeStart or 8)
            part:SetEndSize(sizeend or 5)

            part:SetGravity(ParticleGravity)
            part:SetVelocity(vel)
            part:SetCollide(true)
            part:SetCollideCallback(blood_CollideFunc)
        end
        emitter:Finish()
    end
end

function blood_BleedArtery(pos,vel)
    if bit.band(util.PointContents(pos),CONTENTS_WATER) == CONTENTS_WATER then
        bleedInWater(pos,vel)
    else
        local emitter = ParticleEmitter(pos)

        local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
        if part then
            part:SetDieTime(Rand(3,4))

            part:SetStartAlpha(200)
            part:SetEndAlpha(0)

            part:SetStartSize(5)
            part:SetEndSize(15)

            part:SetStartLength(15)
            part:SetEndLength(0)

            part:SetGravity(ParticleGravity)
            part:SetVelocity(vel)
            part:SetCollide(true)
            part:SetCollideCallback(blood_CollideFunc)
        end
        emitter:Finish()
    end
end

concommand.Add("test_bleed",function()
    blood_Bleed(Vector(),Vector())
end)