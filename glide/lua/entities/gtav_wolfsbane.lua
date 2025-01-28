AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_motorcycle"
ENT.PrintName = "Wolfsbane"

ENT.GlideCategory = "Default"
ENT.ChassisModel = "models/gta5/vehicles/wolfsbane/chassis.mdl"

DEFINE_BASECLASS( "base_glide_motorcycle" )

function ENT:GetFirstPersonOffset( _, localEyePos )
    return localEyePos
end

if CLIENT then
    ENT.CameraOffset = Vector( -170, 0, 40 )
    ENT.StartSound = "Glide.Engine.BikeStart2"
    ENT.WheelSkidmarkScale = 0.45

    ENT.ExhaustOffsets = {
        { pos = Vector( -30, -7.5, -13.5 ), scale = 0.7 },
        { pos = Vector( -7, -5.5, -15.6 ), scale = 0.7 }
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 5, 0, -5 ), angle = Angle( 40, 180, 0 ), width = 15 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( -3, 5, -5 ), angle = Angle( 90, 90, 0 ), scale = 0.4 },
        { offset = Vector( -3, -5, -5 ), angle = Angle( 90, 270, 0 ), scale = 0.4 }
    }

    ENT.LightSprites = {
        { type = "brake", offset = Vector( -45, 0, 5 ), dir = Vector( -1, 0, 0 ), lightRadius = 50 },
        { type = "taillight", offset = Vector( -45, 0, 5 ), dir = Vector( -1, 0, 0 ), size = 15 },
        { type = "headlight", offset = Vector( 27, 0, 17 ), dir = Vector( 1, 0, 0 ) }
    }

    ENT.Headlights = {
        { offset = Vector( 28, 0, 27 ) }
    }

    function ENT:OnCreateEngineStream( stream )
        stream.offset = Vector( 5, 0, 0 )
        stream:LoadPreset( "wolfsbane" )
    end

    local POSE_DATA = {
        ["ValveBiped.Bip01_L_Thigh"] = Angle( -5, -25, 0 ),
        ["ValveBiped.Bip01_L_Calf"] = Angle( -8, 30, 25 ),
        ["ValveBiped.Bip01_R_Thigh"] = Angle( 5, -25, 0 ),
        ["ValveBiped.Bip01_R_Calf"] = Angle( 8, 30, -25 )
    }

    local DRIVER_POSE_DATA = {
        ["ValveBiped.Bip01_L_UpperArm"] = Angle( -8, 10, 0 ),
        ["ValveBiped.Bip01_R_UpperArm"] = Angle( 10, 8, 5 ),

        ["ValveBiped.Bip01_L_Thigh"] = Angle( -3, 2, 0 ),
        ["ValveBiped.Bip01_L_Calf"] = Angle( -1, 7, 0 ),
        ["ValveBiped.Bip01_L_Foot"] = Angle( 0, -35, 0 ),

        ["ValveBiped.Bip01_R_Thigh"] = Angle( 5, 2, 0 ),
        ["ValveBiped.Bip01_R_Calf"] = Angle( -1, 7, 0 ),
        ["ValveBiped.Bip01_R_Foot"] = Angle( 0, -35, 0 ),
    }

    local FrameTime = FrameTime
    local ExpDecayAngle = Glide.ExpDecayAngle

    function ENT:GetSeatBoneManipulations( seatIndex )
        if seatIndex > 1 then
            return POSE_DATA
        end

        local decay = 5
        local dt = FrameTime()
        local resting = self:GetVelocity():Length() < 30

        local thigh = DRIVER_POSE_DATA["ValveBiped.Bip01_L_Thigh"]
        local calf = DRIVER_POSE_DATA["ValveBiped.Bip01_L_Calf"]
        local foot = DRIVER_POSE_DATA["ValveBiped.Bip01_L_Foot"]

        thigh[1] = ExpDecayAngle( thigh[1], resting and -25 or -3, decay, dt )
        thigh[2] = ExpDecayAngle( thigh[2], resting and 15 or 2, decay, dt )
        thigh[3] = ExpDecayAngle( thigh[3], resting and -5 or 0, decay, dt )

        calf[1] = ExpDecayAngle( calf[1], resting and -3 or -1, decay, dt )
        calf[2] = ExpDecayAngle( calf[2], resting and 3 or 7, decay, dt )

        foot[2] = ExpDecayAngle( foot[2], resting and 0 or -35, decay, dt )

        return DRIVER_POSE_DATA
    end

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        self.frontBoneId = self:LookupBone( "wheel_f" )
        self.rearBoneId = self:LookupBone( "wheel_r" )
    end

    local spinAng = Angle()

    function ENT:OnUpdateAnimations()
        BaseClass.OnUpdateAnimations( self )

        if not self.frontBoneId then return end

        spinAng[3] = -self:GetWheelSpin( 1 )
        self:ManipulateBoneAngles( self.frontBoneId, spinAng, false )

        spinAng[3] = -self:GetWheelSpin( 2 )
        self:ManipulateBoneAngles( self.rearBoneId, spinAng, false )
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 30 )
    ENT.StartupTime = 0.5

    ENT.BurnoutForce = 160
    ENT.WheelieForce = 400

    ENT.LightBodygroups = {
        { type = "headlight", bodyGroupId = 7, subModelId = 1 }, -- Headlight
        { type = "headlight", bodyGroupId = 8, subModelId = 1 } -- Tail light
    }

    function ENT:CreateFeatures()
        self:SetTransmissionEfficiency( 0.65 )
        self:SetDifferentialRatio( 1.8 )
        self:SetBrakePower( 2000 )
        self:SetMaxSteerAngle( 25 )

        self:SetMaxRPM( 15000 )
        self:SetMinRPMTorque( 500 )
        self:SetMaxRPMTorque( 600 )

        self:SetSuspensionLength( 8 )
        self:SetSpringStrength( 800 )
        self:SetSpringDamper( 4000 )

        self:CreateSeat( Vector( -20, 0, 2 ), Angle( 0, 270, -16 ), Vector( 0, 60, 0 ), true )
        self:CreateSeat( Vector( -36, 0, 2.5 ), Angle( 0, 270, -16 ), Vector( 0, 50, 0 ), true )

        -- Front
        self:CreateWheel( Vector( 39, 0, -1 ), {
            model = "models/gta5/vehicles/blazer/wheel.mdl",
            modelScale = Vector( 0.4, 1, 1 ),
            modelAngle = Angle( 0, 90, 0 ),
            steerMultiplier = 1
        } )

        -- Rear
        self:CreateWheel( Vector( -32, 0, -1 ), {
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
