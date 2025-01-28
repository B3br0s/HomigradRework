local IsValid = IsValid
local surfaceFX = {}

function EFFECT:Init( data )
    local origin = data:GetOrigin()
    local velocity = data:GetStart()
    local matId = data:GetSurfaceProp()
    local scale = data:GetScale()

    local emitter = ParticleEmitter( origin, false )
    if not IsValid( emitter ) then return end

    if surfaceFX[matId] then
        self:DoSurface( emitter, origin, velocity, scale, surfaceFX[matId] )
    else
        self:DoSmoke( emitter, origin, velocity, scale, data:GetEntity() )
    end

    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end

local RandomInt = math.random
local RandomFloat = math.Rand
local DEBRIS_GRAVITY = Vector( 0, 0, -40 )

function EFFECT:DoSurface( emitter, origin, velocity, scale, fx )
    local p

    for _ = 1, 5 do
        p = emitter:Add( fx.mat, origin )

        if p then
            p:SetDieTime( fx.lifetime * RandomFloat( 0.8, 1.2 ) )
            p:SetStartAlpha( fx.alpha )
            p:SetEndAlpha( 0 )
            p:SetStartSize( fx.minSize * scale * RandomFloat( 0.9, 1.1 ) )
            p:SetEndSize( fx.maxSize * scale * RandomFloat( 0.8, 1.5 ) )
            p:SetRoll( RandomFloat( -1, 1 ) )

            p:SetAirResistance( 50 )
            p:SetGravity( DEBRIS_GRAVITY )
            p:SetVelocity( velocity * RandomFloat( 0.2, 0.4 ) )
            p:SetColor( fx.r, fx.g, fx.b )
            p:SetLighting( false )
            p:SetCollide( true )
        end
    end
end

local SMOKE_MAT = "particle/smokesprites_000"
local SMOKE_GRAVITY = Vector( 0, 0, 60 )
local DEFAULT_COLOR = Vector( 0, 0, 0 )

function EFFECT:DoSmoke( emitter, origin, velocity, scale, vehicle )
    local color = ( IsValid( vehicle ) and vehicle.GetTireSmokeColor ) and vehicle:GetTireSmokeColor() or DEFAULT_COLOR
    local r, g, b = color:Unpack()

    r = r * 255
    g = g * 255
    b = b * 255

    local p
    local count = math.floor( scale )

    for _ = 1, count do
        p = emitter:Add( SMOKE_MAT .. RandomInt( 9 ), origin )

        if p then
            p:SetDieTime( RandomFloat( 2, 3 ) )
            p:SetStartAlpha( 70 )
            p:SetEndAlpha( 0 )
            p:SetStartSize( 5 + RandomFloat( 1, 2 ) * scale )
            p:SetEndSize( 50 + RandomFloat( 2, 8 ) * scale )
            p:SetRoll( RandomFloat( -1, 1 ) )

            p:SetAirResistance( 100 )
            p:SetGravity( SMOKE_GRAVITY * RandomFloat( 0.5, 1 ) )
            p:SetVelocity( velocity * RandomFloat( 0.4, 0.8 ) )
            p:SetColor( r, g, b )
            p:SetLighting( false )
            p:SetCollide( true )
        end
    end
end

surfaceFX[MAT_GRASS] = {
    mat = Material( "glide/effects/grass_debris" ),
    r = 100, g = 95, b = 40,
    lifetime = 0.8,
    alpha = 255,
    minSize = 3,
    maxSize = 7
}

surfaceFX[MAT_FOLIAGE] = surfaceFX[MAT_GRASS]

surfaceFX[MAT_SAND] = {
    mat = Material( "particle/particle_composite" ),
    r = 200, g = 170, b = 120,
    lifetime = 1.5,
    alpha = 150,
    minSize = 2,
    maxSize = 7,
}

surfaceFX[MAT_DIRT] = {
    mat = Material( "particle/particle_composite" ),
    r = 70, g = 60, b = 50,
    lifetime = 1,
    alpha = 180,
    minSize = 2,
    maxSize = 4
}

surfaceFX[MAT_SNOW] = {
    mat = Material( "particle/particle_composite" ),
    r = 230, g = 230, b = 230,
    lifetime = 1,
    alpha = 100,
    minSize = 2,
    maxSize = 4
}

surfaceFX[MAT_SLOSH] = {
    mat = Material( "effects/splash4" ),
    r = 180, g = 180, b = 180,
    lifetime = 0.3,
    alpha = 100,
    minSize = 2,
    maxSize = 5
}
