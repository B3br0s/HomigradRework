AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_motorcycle"
ENT.PrintName = "Sanchez"

ENT.GlideCategory = "Default"
ENT.ChassisModel = "models/gta5/vehicles/sanchez/chassis.mdl"

DEFINE_BASECLASS( "base_glide_motorcycle" )

if CLIENT then
    ENT.CameraOffset = Vector( -170, 0, 50 )

    ENT.ExhaustOffsets = {
        { pos = Vector( -40, -5, 15 ), scale = 0.7 }
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 5, 0, 5 ), angle = Angle( 40, 180, 0 ), width = 15 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( -3, 5, 5 ), angle = Angle( 90, 90, 0 ), scale = 0.4 },
        { offset = Vector( -3, -5, 5 ), angle = Angle( 90, 270, 0 ), scale = 0.4 }
    }

    ENT.LightSprites = {
        { type = "brake", offset = Vector( -43, 0, 17.5 ), dir = Vector( -1, 0, 0 ), lightRadius = 50 },
        { type = "taillight", offset = Vector( -43, 0, 17.5 ), dir = Vector( -1, 0, 0 ), size = 15 },
        { type = "headlight", offset = Vector( 26, 0, 19.6 ), dir = Vector( 1, 0, 0 ) }
    }

    ENT.Headlights = {
        { offset = Vector( 28, 0, 27 ) }
    }

    function ENT:OnCreateEngineStream( stream )
        stream.offset = Vector( 5, 0, 0 )
        stream:LoadPreset( "sanchez" )
    end

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        self.frontBoneId = self:LookupBone( "front_wheel" )
        self.rearBoneId = self:LookupBone( "rear_wheel" )
    end

    local Abs = math.abs
    local spinAng = Angle()

    function ENT:OnUpdateAnimations()
        BaseClass.OnUpdateAnimations( self )

        self:SetPoseParameter( "suspension_front", 1 - ( Abs( self:GetWheelOffset( 1 ) ) / 7 ) )
        self:SetPoseParameter( "suspension_rear", 1 - ( Abs( self:GetWheelOffset( 2 ) ) / 7 ) )
        self:InvalidateBoneCache()

        if not self.frontBoneId then return end

        spinAng[3] = -self:GetWheelSpin( 1 )
        self:ManipulateBoneAngles( self.frontBoneId, spinAng, false )

        spinAng[3] = -self:GetWheelSpin( 2 )
        self:ManipulateBoneAngles( self.rearBoneId, spinAng, false )
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.StartupTime = 0.4
    ENT.BurnoutForce = 220

    ENT.LightBodygroups = {
        { type = "headlight", bodyGroupId = 6, subModelId = 1 }, -- Headlight
        { type = "headlight", bodyGroupId = 7, subModelId = 1 } -- Tail light
    }

    function ENT:CreateFeatures()
        self:SetTransmissionEfficiency( 0.7 )
        self:SetDifferentialRatio( 1.8 )
        self:SetBrakePower( 2000 )

        self:SetMaxRPM( 15000 )
        self:SetMinRPMTorque( 500 )
        self:SetMaxRPMTorque( 600 )

        self:SetSuspensionLength( 7 )
        self:SetSpringStrength( 1000 )
        self:SetSpringDamper( 4500 )

        self:CreateSeat( Vector( -17, 0, 12 ), Angle( 0, 270, -16 ), Vector( 0, 60, 0 ), true )
        self:CreateSeat( Vector( -26, 0, 12 ), Angle( 0, 270, -5 ), Vector( 0, -60, 0 ), true )

        -- Front
        self:CreateWheel( Vector( 36, 0, -1 ), {
            model = "models/gta5/vehicles/blazer/wheel.mdl",
            modelScale = Vector( 0.4, 1, 1 ),
            modelAngle = Angle( 0, 90, 0 ),
            steerMultiplier = 1
        } )

        -- Rear
        self:CreateWheel( Vector( -29, 0, -1 ), {
            model = "models/gta5/vehicles/blazer/wheel.mdl",
            modelScale = Vector( 0.4, 1, 1 ),
            modelAngle = Angle( 0, 90, 0 )
        } )

        for _, w in ipairs( self.wheels ) do
            Glide.HideEntity( w, true )
        end

        self:ChangeWheelRadius( 14 )
    end
end
