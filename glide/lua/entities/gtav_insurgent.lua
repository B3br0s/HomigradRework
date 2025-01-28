-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "Insurgent Pick-up"

ENT.GlideCategory = "Default"
ENT.ChassisModel = "models/gta5/vehicles/insurgent/chassis.mdl"
ENT.MaxChassisHealth = 2000

DEFINE_BASECLASS( "base_glide_car" )

function ENT:SetupDataTables()
    BaseClass.SetupDataTables( self )

    self:NetworkVar( "Entity", "Turret" )
    self:NetworkVar( "Entity", "TurretSeat" )
end

function ENT:GetPlayerSitSequence( seatIndex )
    return seatIndex == 5 and "drive_airboat" or ( seatIndex > 1 and "sit" or "drive_jeep" )
end

if CLIENT then
    ENT.CameraOffset = Vector( -400, 0, 120 )

    ENT.ExhaustOffsets = {
        { pos = Vector( -65, 40, 7 ) },
        { pos = Vector( -65, -40, 7 ) }
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 119, 0, 14 ), angle = Angle(), width = 45 }
    }

    ENT.EngineSmokeMaxZVel = 150

    ENT.EngineFireOffsets = {
        { offset = Vector( 70, 0, 40 ), angle = Angle() }
    }

    ENT.Headlights = {
        { offset = Vector( 115, 34, 18 ), color = color_white },
        { offset = Vector( 115, -34, 18 ), color = color_white }
    }

    ENT.LightSprites = {
        { type = "brake", offset = Vector( -132, 30.5, 11 ), dir = Vector( -1, 0, 0 ) },
        { type = "brake", offset = Vector( -132, -30.5, 11 ), dir = Vector( -1, 0, 0 ) },
        { type = "taillight", offset = Vector( -132, 30.5, 11 ), dir = Vector( -1, 0, 0 ), size = 15 },
        { type = "taillight", offset = Vector( -132, -30.5, 11 ), dir = Vector( -1, 0, 0 ), size = 15 },

        { type = "reverse", offset = Vector( -132, 24, 11 ), dir = Vector( -1, 0, 0 ) },
        { type = "reverse", offset = Vector( -132, -24, 11 ), dir = Vector( -1, 0, 0 ) },

        { type = "headlight", offset = Vector( 115, 34, 17.5 ), dir = Vector( 1, 0, 0 ), color = color_white },
        { type = "headlight", offset = Vector( 115, -34, 17.5 ), dir = Vector( 1, 0, 0 ), color = color_white },

        { type = "signal_left", offset = Vector( -132, 38.3, 11 ), dir = Vector( -1, 0, 0 ), color = Glide.DEFAULT_TURN_SIGNAL_COLOR },
        { type = "signal_right", offset = Vector( -132, -38.3, 11 ), dir = Vector( -1, 0, 0 ), color = Glide.DEFAULT_TURN_SIGNAL_COLOR }
    }

    ENT.ExhaustPopSound = ""

    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "insurgent" )
    end

    function ENT:OnLocalPlayerEnter( seatIndex )
        self:DisableCrosshair()
        self.isUsingTurret = false

        if seatIndex == 5 then
            self:EnableCrosshair( { iconType = "dot", color = Color( 0, 255, 0 ) } )
            self.isUsingTurret = true
        else
            BaseClass.OnLocalPlayerEnter( self, seatIndex )
        end
    end

    function ENT:OnLocalPlayerExit()
        self:DisableCrosshair()
        self.isUsingTurret = false
    end

    function ENT:UpdateCrosshairPosition()
        self.crosshair.origin = Glide.GetCameraAimPos()
    end

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        self.turretBaseBone = self:LookupBone( "turret_base" )
        self.turretWeaponBone = self:LookupBone( "turret_weapon" )
    end

    local ang = Angle()
    local offset = Vector()
    local matrix = Matrix()

    function ENT:OnUpdateAnimations()
        BaseClass.OnUpdateAnimations( self )

        local turret = self:GetTurret()
        if not IsValid( turret ) then return end

        local bodyAng = self.isUsingTurret and turret.predictedBodyAngle or turret:GetLastBodyAngle()
        local seat = self:GetTurretSeat()

        if IsValid( seat ) then
            ang[1] = 0
            ang[2] = bodyAng[2]
            ang[3] = 0

            -- Manually move/rotate the seat to match the turret angles
            local rad = math.rad( ang[2] )

            offset[1] = math.sin( rad ) * 12.5
            offset[2] = 13 + math.cos( rad ) * -13
            offset[3] = 0

            matrix:SetTranslation( offset )
            matrix:SetAngles( ang )
            seat:EnableMatrix( "RenderMultiply", matrix )
        end

        if not self.turretBaseBone then return end

        bodyAng[1] = math.NormalizeAngle( bodyAng[1] ) -- Stay on the -180/180 range

        ang[1] = 0
        ang[2] = bodyAng[2]
        ang[3] = 0
        self:ManipulateBoneAngles( self.turretBaseBone, ang )

        ang[2] = 0
        ang[3] = -bodyAng[1] * 1.4
        self:ManipulateBoneAngles( self.turretWeaponBone, ang )
    end

    function ENT:GetFirstPersonOffset( seatIndex, localEyePos )
        if seatIndex == 5 then
            return Vector( -30, 0, 115 )
        end

        return BaseClass.GetFirstPersonOffset( self, seatIndex, localEyePos )
    end

    function ENT:GetCameraType( seatIndex )
        return seatIndex == 5 and 1 or 0 -- Glide.CAMERA_TYPE.TURRET or Glide.CAMERA_TYPE.CAR
    end

    function ENT:AllowFirstPersonMuffledSound( seatIndex )
        return seatIndex < 5
    end

    local POSE_DATA = {
        ["ValveBiped.Bip01_L_UpperArm"] = Angle( 0.1, -21.7, -18.1 ),
        ["ValveBiped.Bip01_L_Forearm"] = Angle( -6, -19.5, -64.5 ),

        ["ValveBiped.Bip01_R_UpperArm"] = Angle( 0.1, -21.7, 18.1 ),
        ["ValveBiped.Bip01_R_Forearm"] = Angle( -6.3, -16.4, 90 ),

        ["ValveBiped.Bip01_L_Thigh"] = Angle( 3, -4.3, 0 ),
        ["ValveBiped.Bip01_L_Calf"] = Angle( -10.3, 91.6, -16.3 ),

        ["ValveBiped.Bip01_R_Thigh"] = Angle( -3, -4.3, 0 ),
        ["ValveBiped.Bip01_R_Calf"] = Angle( 10.3, 91.6, 16.3 )
    }

    function ENT:GetSeatBoneManipulations( seatIndex )
        if seatIndex == 5 then
            return POSE_DATA
        end
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 45 )
    ENT.ChassisMass = 2000
    ENT.BulletDamageMultiplier = 0.5

    ENT.FallOnCollision = true
    ENT.BurnoutForce = 30
    ENT.AirControlForce = Vector( 0.3, 0.2, 0.2 )

    ENT.LightBodygroups = {
        { type = "headlight", bodyGroupId = 10, subModelId = 1 },  -- Headlights
        { type = "headlight", bodyGroupId = 12, subModelId = 1 }, -- Tail lights
        { type = "headlight", bodyGroupId = 13, subModelId = 1 },  -- Extra lights
        { type = "reverse", bodyGroupId = 11, subModelId = 1 },
        { type = "signal_left", bodyGroupId = 14, subModelId = 1 },
        { type = "signal_right", bodyGroupId = 15, subModelId = 1 }
    }

    function ENT:CanFallOnCollision( seatIndex )
        return seatIndex > 5
    end

    function ENT:CreateFeatures()
        self.engineBrakeTorque = 1300

        self:SetBrakePower( 3800 )
        self:SetDifferentialRatio( 3.3 )
        self:SetPowerDistribution( -0.4 )
        self:SetMinRPMTorque( 2000 )
        self:SetMaxRPMTorque( 2500 )

        self:SetMaxSteerAngle( 30 )
        self:SetSteerConeMaxSpeed( 1100 )

        self:SetSuspensionLength( 14 )
        self:SetSpringStrength( 900 )
        self:SetSpringDamper( 3500 )

        self:SetSideTractionMultiplier( 38 )
        self:SetForwardTractionMax( 4700 )
        self:SetSideTractionMax( 4500 )
        self:SetSideTractionMin( 2000 )

        self:CreateSeat( Vector( -2, 21.5, 9 ), Angle( 0, 270, -5 ), Vector( 40, 100, 0 ), true )
        self:CreateSeat( Vector( 15, -21.5, 7 ), Angle( 0, 270, 5 ), Vector( 40, -100, 0 ), true )
        self:CreateSeat( Vector( -35, 20, 6 ), Angle( 0, 270, 5 ), Vector( -40, 100, 0 ), true )
        self:CreateSeat( Vector( -35, -20, 6 ), Angle( 0, 270, 5 ), Vector( -40, -100, 0 ), true )

        local turretSeat = self:CreateSeat( Vector( -44.7, 0, 55.6 ), Angle( 0, 270, -10 ), Vector( -80, -100, 0 ), true )

        self:CreateSeat( Vector( -110, 30, 20.5 ), Angle( 0, 180, 3 ), Vector( 40, 100, 0 ), true )
        self:CreateSeat( Vector( -110, -30, 20.5 ), Angle( 0, 0, 3 ), Vector( 40, 100, 0 ), true )

        local turret = Glide.CreateTurret( self, Vector( -30, 0, 90 ), Angle() )
        turret:SetFireDelay( 0.13 )
        turret:SetBulletOffset( Vector( 80, 0, 0 ) )
        turret:SetMinPitch( -40 )
        turret:SetMaxPitch( 20 )
        turret:SetSingleShotSound( "Glide.InsurgentShoot" )
        turret:SetShootLoopSound( "" )
        turret:SetShootStopSound( "" )

        turret.BulletDamage = 40

        self:SetTurret( turret )
        self:SetTurretSeat( turretSeat )

        Glide.HideEntity( turret, true )
        Glide.HideEntity( turret:GetGunBody(), true )

        -- Front left
        self:CreateWheel( Vector( 82, 48, -8 ), {
            model = "models/gta5/vehicles/insurgent/wheel.mdl",
            modelAngle = Angle( 0, 90, 0 ),
            steerMultiplier = 1
        } )

        -- Front right
        self:CreateWheel( Vector( 82, -48, -8 ), {
            model = "models/gta5/vehicles/insurgent/wheel.mdl",
            modelAngle = Angle( 0, -90, 0 ),
            steerMultiplier = 1
        } )

        -- Rear left
        self:CreateWheel( Vector( -82, 48, -8 ), {
            model = "models/gta5/vehicles/insurgent/wheel.mdl",
            modelAngle = Angle( 0, 90, 0 ),
            modelScale = Vector( 0.35, 1, 1 )
        } )

        -- Rear right
        self:CreateWheel( Vector( -82, -48, -8 ), {
            model = "models/gta5/vehicles/insurgent/wheel.mdl",
            modelAngle = Angle( 0, -90, 0 ),
            modelScale = Vector( 0.35, 1, 1 )
        } )

        self:ChangeWheelRadius( 24 )
    end

    function ENT:OnUpdateFeatures()
        local turret = self:GetTurret()

        if IsValid( turret ) then
            turret:UpdateUser( self:GetSeatDriver( 5 ) )
        end
    end
end
