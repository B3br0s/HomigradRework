include( "shared.lua" )

function ENT:Initialize()
    self.smokeSpinSpeed = math.random( 60, 110 )

    -- Create a RangedFeature to handle missile sounds
    self.missileSounds = Glide.CreateRangedFeature( self, 4000 )
    self.missileSounds:SetActivateCallback( "ActivateSound" )
    self.missileSounds:SetDeactivateCallback( "DeactivateSound" )

    -- Assume we have one for now, to avoid issues with the lock-on warnings clientside
    self:SetHasTarget( true )
end

function ENT:OnRemove()
    if self.missileSounds then
        self.missileSounds:Destroy()
        self.missileSounds = nil
    end
end

function ENT:ActivateSound()
    if not self.missileLoop then
        self.missileLoop = CreateSound( self, "glide/weapons/missile_loop.wav" )
        self.missileLoop:SetSoundLevel( 80 )
        self.missileLoop:Play()
    end
end

function ENT:DeactivateSound()
    if self.missileLoop then
        self.missileLoop:Stop()
        self.missileLoop = nil
    end
end

local Effect = util.Effect
local EffectData = EffectData
local CurTime = CurTime

function ENT:Think()
    if self.missileSounds then
        self.missileSounds:Think()
    end

    if self:WaterLevel() > 0 then
        self.smokeSpinSpeed = nil

    elseif self.smokeSpinSpeed then
        local eff = EffectData()
        eff:SetOrigin( self:GetPos() )
        eff:SetNormal( -self:GetForward() )
        eff:SetColor( self.smokeSpinSpeed )
        eff:SetScale( self:GetEffectiveness() )
        Effect( "glide_missile", eff )
    end

    self:SetNextClientThink( CurTime() + 0.02 )

    return true
end
