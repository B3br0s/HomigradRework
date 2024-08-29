CreateConVar("realistic_blood_stream", "1", FCVAR_ARCHIVE)
CreateConVar("realistic_blood_stream_mintime", "4", FCVAR_ARCHIVE)
CreateConVar("realistic_blood_stream_maxtime", "8", FCVAR_ARCHIVE)

local material = Material("effects/slime1")
local droplet_mats = {}

for i = 1, 11 do
    local imat = Material("effects/droplets/drop"..i)
    table.insert(droplet_mats, imat)
end

local splatter_materials = {
    "decals/lowdenseblood/blood15",
    "decals/lowdenseblood/blood16",
    "decals/lowdenseblood/blood17",
    "decals/lowdenseblood/blood18",
    "decals/lowdenseblood/blood19",
    "decals/lowdenseblood/blood20",
    "decals/lowdenseblood/blood21",
    "decals/lowdenseblood/blood22",
    "decals/lowdenseblood/blood23",
    "decals/lowdenseblood/blood24",
    "decals/lowdenseblood/blood25",
    "decals/lowdenseblood/blood26",
    "decals/lowdenseblood/blood27",
    "decals/lowdenseblood/blood28",
    "decals/lowdenseblood/blood29",
    "decals/lowdenseblood/blood30",
    "decals/lowdenseblood/blood31",
    "decals/lowdenseblood/blood32",
}

for k,v in ipairs(splatter_materials) do
    local imat = Material(v)
    splatter_materials[k] = imat
end

local sounds = {
    "realistic_blood_drips/drip_01.wav",
    "realistic_blood_drips/drip_02.wav",
    "realistic_blood_drips/drip_03.wav",
    "realistic_blood_drips/drip_04.wav",
    "realistic_blood_drips/drip_05.wav",
    "realistic_blood_drips/drip_06.wav",
    "realistic_blood_drips/drip_07.wav",
    "realistic_blood_drips/drip_08.wav",
}

local white = Color(255,255,255)

function EFFECT:Init(data)
    local ent = data:GetEntity()

    if !GetConVar("realistic_blood_stream"):GetBool() or !IsValid(ent) or ( !GetConVar("realistic_blood_player_effects"):GetBool() && IsValid(ent:GetOwner()) && ent:GetOwner() == LocalPlayer() ) then
        self.Die = true
        return
    end

    self.StartTime = CurTime()
    self.CurrentStrenght = 1
    self:UpdateExtraForce()
    self.TimerName = "RealisticBlood_StreamTimer"..ent:EntIndex()
    self.FPS = 30
    self.Reps = math.random(self.FPS*GetConVar("realistic_blood_stream_mintime"):GetFloat(), self.FPS*GetConVar("realistic_blood_stream_maxtime"):GetFloat())

    local emitter = ParticleEmitter(ent:GetPos(), false)
    local emitter3D = ParticleEmitter(ent:GetPos(), true)
    local width = math.Rand(0.4, 0.8)

    local last_decal_pos

    timer.Create(self.TimerName, 1/self.FPS, self.Reps, function()
        if !IsValid(ent) or !IsValid(ent:GetOwner()) then
            emitter:Finish()
            emitter3D:Finish()
            timer.Remove(self.TimerName)
            return
        end

        local length = math.Rand(16, 20)

        local particle = emitter:Add( material, ent:GetPos() )
        particle:SetDieTime( 1.5 )
        particle:SetStartSize( width )
        particle:SetEndSize(0)
        particle:SetStartLength( length*0.1 )
        particle:SetEndLength( length )
        particle:SetGravity( Vector(0,0,-300) )
        particle:SetAngles( particle:GetVelocity():Angle() )
        particle:SetColor(100,0,0)

        local mult = math.sin(CurTime()*3.5 + self.StartTime)*0.24*(1-self.CurrentStrenght)
        local normal = ( ent:GetForward() + ent:GetRight()*mult + ent:GetUp()*mult ):GetNormalized()
        particle:SetVelocity( ent:GetOwner():GetVelocity() + normal*-(80+self.ExtraForce)*self.CurrentStrenght )

        particle:SetCollide( true )
        particle:SetCollideCallback( function( me, pos, normal )
            if math.random(1, 2) == 1 then
                local lerp_ratio = me:GetVelocity():LengthSqr() / 38000

                if math.random(1,2) == 1 then sound.Play( table.Random(sounds), pos, 70, Lerp(lerp_ratio, 130, 90 ), Lerp(lerp_ratio, 0.35, 0.75 ) ) end

                if lerp_ratio > 0.2 then
                    for i = 1, math.random(1, 3) do RealisticBlood_Droplet( pos, -normal, emitter, emitter3D ) end
                end

                if (!last_decal_pos or last_decal_pos:DistToSqr(pos) > 175) then
                    if normal:Angle().pitch < 22.5 then
                        -- Create animated wall stain:
                        local effectdata = EffectData()
                        effectdata:SetStart( pos )
                        effectdata:SetNormal( normal )
                        effectdata:SetFlags(2)
                        util.Effect("realisticblood_animatedstain", effectdata)
                    end

                    if math.random(1, 2) == 1 then
                        util.DecalEx( table.Random(splatter_materials), Entity(0), pos, normal, white, 1+math.Rand(0, 0.15), 1+math.Rand(0, 0.15) )
                        last_decal_pos = pos
                    end
                elseif lerp_ratio > 0.2 then
                    if GetConVar("realistic_blood_pcf_particles"):GetBool() then ParticleEffect("blood_stream_goop", pos-normal*9, normal:Angle()) end
                end
            end
        end)

        if timer.RepsLeft(self.TimerName) == 0 then
            emitter:Finish()
            emitter3D:Finish()
        end
    end)
end

function EFFECT:UpdateExtraForce()
    self.ExtraForce = 15 * self.CurrentStrenght * (1+math.sin(CurTime()*7))
end

local min_strenght = 0.42

function EFFECT:Think()
    if !self.Die && timer.Exists(self.TimerName) then
        local lifetime = CurTime()-self.StartTime
        local dietime = self.Reps*(1/self.FPS)

        self.CurrentStrenght = math.Clamp( 1 - (lifetime/dietime)*(1-min_strenght), 0, 1 )
        self:UpdateExtraForce()

        return true
    else
        return false
    end
end

function EFFECT:Render() end