ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Glide Base Vehicle"
ENT.Author = "StyledStrike"
ENT.Purpose = "Move around"
ENT.Instructions = "Aim at it, then press USE to enter"
ENT.AdminOnly = false
ENT.VJ_ID_Destructible = true
ENT.VJ_ID_Vehicle = true

-- Let Glide know it should handle this entity differently
ENT.IsGlideVehicle = true
ENT.VehicleType = Glide.VEHICLE_TYPE.UNDEFINED

-- Max. chassis health
ENT.MaxChassisHealth = 1000

function ENT:SetupDataTables()
    -- Setup default network variables. Do not override these slots
    -- when creating children classes! You can omit the 3rd "slot"
    -- argument (like how I did here) to avoid that.
    self:NetworkVar( "Entity", "Driver" )
    self:NetworkVar( "Int", "EngineState" )
    self:NetworkVar( "Bool", "IsEngineOnFire" )
    self:NetworkVar( "Bool", "IsLocked" )

    self:NetworkVar( "Int", "WeaponIndex" )
    self:NetworkVar( "Int", "LockOnState" )
    self:NetworkVar( "Entity", "LockOnTarget" )

    self:NetworkVar( "Float", "ChassisHealth" )
    self:NetworkVar( "Float", "EngineHealth" )

    -- Set default values, to avoid some weird behaviour when prediction kicks in
    self:SetDriver( NULL )
    self:SetEngineState( 0 )
    self:SetIsEngineOnFire( false )

    self:SetWeaponIndex( 1 )
    self:SetLockOnState( 0 )
    self:SetLockOnTarget( NULL )

    if CLIENT then
        -- Callback used to run `OnTurnOn` and `OnTurnOff` clientside
        self:NetworkVarNotify( "EngineState", self.OnEngineStateChange )

        -- Callback used to run `OnSwitchWeapon` clientside
        self:NetworkVarNotify( "WeaponIndex", self.OnWeaponIndexChange )

        -- Callback used to play/stop the lock-on sound clientside
        self:NetworkVarNotify( "LockOnState", self.OnLockOnStateChange )

        -- Callback used to setup the driver's HUD clientside
        self:NetworkVarNotify( "Driver", self.OnDriverChange )
    end
end

function ENT:GravGunPickupAllowed( _ply )
    return false
end

-- You can safely override these on children classes
function ENT:IsEngineOn()
    return self:GetEngineState() > 0
end

function ENT:OnPostInitialize() end
function ENT:OnTurnOn() end
function ENT:OnTurnOff() end
function ENT:OnSwitchWeapon( _weaponIndex ) end
function ENT:UpdatePlayerPoseParameters( _ply ) return false end

-- drive_airboat, drive_pd, sit, sit_rollercoaster
function ENT:GetPlayerSitSequence( seatIndex )
    return seatIndex > 1 and "sit" or "drive_jeep"
end

function ENT:GetFirstPersonOffset( _seatIndex, localEyePos )
    localEyePos[1] = localEyePos[1] + 10
    localEyePos[3] = localEyePos[3] + 5

    return localEyePos
end

if CLIENT then
    ENT.Spawnable = false -- Hide from the default spawn list clientside

    -- Setup the camera parameters for this vehicle
    ENT.CameraOffset = Vector( -200, 0, 50 )
    ENT.CameraCenterOffset = Vector( 0, 0, 0 )
    ENT.CameraAngleOffset = Angle( 6, 0, 0 )

    -- Setup how far away players can hear sounds and update misc. features
    ENT.MaxSoundDistance = 6000
    ENT.MaxMiscDistance = 3000

    -- Set label/icons for each weapon slot.
    -- This should contain a array of tables, where each table looks like these:
    --
    -- { name = "Machine Guns", icon = "glide/icons/bullets.png" }
    -- { name = "Missiles", icon = "glide/icons/rocket.png" }
    ENT.WeaponInfo = {}

    -- Set crosshair parameters per weapon slot.
    -- This should contain a array of tables, where each table looks like these:
    --
    -- { iconType = "dot", traceOrigin = Vector() }
    -- { iconType = "square", traceOrigin = Vector(), traceAngle = Angle(), size = 0.1 }
    ENT.CrosshairInfo = {}

    -- Positions where engine fire comes from.
    -- This should contain a array of tables, where each table contains:
    -- - Mandatory "offset" key with a Vector value, where the fire comes from.
    -- - Optional "angle" key with a Angle value, sets the direction of the flames. Points up by default.
    -- - Optional "scale" key with a number value, sets the size of the flames.
    ENT.EngineFireOffsets = {}

    -- How wide should the skidmarks be?
    ENT.WheelSkidmarkScale = 0.5

    -- You can safely override these on children classes.
    function ENT:ShouldActivateSounds() return true end
    function ENT:OnActivateSounds() end
    function ENT:OnDeactivateSounds() end
    function ENT:OnUpdateSounds() end

    function ENT:OnActivateMisc() end
    function ENT:OnDeactivateMisc() end
    function ENT:OnUpdateMisc() end
    function ENT:OnUpdateParticles() end

    function ENT:GetSeatBoneManipulations( _seatIndex ) end
    function ENT:AllowFirstPersonMuffledSound( _seatIndex ) return true end
    function ENT:AllowWindSound( _seatIndex ) return false, 0 end

    function ENT:GetCameraType( _seatIndex )
        return 0 -- Glide.CAMERA_TYPE.CAR
    end
end

if SERVER then
    ENT.Spawnable = true -- Allow it to be spawned serverside

    -- Children classes can choose which NW variables to save
    ENT.DuplicatorNetworkVariables = {}

    -- Setup the vehicle's chassis properties
    ENT.ChassisMass = 700
    ENT.ChassisModel = "models/props_phx/construct/metal_plate1.mdl"
    ENT.AngularDrag = Vector( -0.1, -0.1, -3 ) -- Roll, pitch, yaw

    -- Use these offsets when spawning this vehicle
    ENT.SpawnPositionOffset = Vector( 0, 0, 10 )
    ENT.SpawnAngleOffset = Angle( 0, 90, 0 )

    -- Multiply damage taken by these values
    ENT.BulletDamageMultiplier = 1.0
    ENT.BlastDamageMultiplier = 5
    ENT.CollisionDamageMultiplier = 0.5

    -- How much of the chassis damage is also applied to the engine?
    ENT.EngineDamageMultiplier = 1.2

    -- How much of the blast damage force should be applied to the vehicle?
    ENT.BlastForceMultiplier = 0.01

    -- Damage multiplier for engine fire
    ENT.ChassisFireDamageMultiplier = 0.01

    -- Given a dot product between the vehicle's forward direction
    -- and the direction to a lock-on target, how large must that dot product be
    -- for the target to be considered on the vehicle's "field of view"?
    ENT.LockOnThreshold = 0.95

    -- Max. distance to search for lock-on targets
    ENT.LockOnMaxDistance = 20000

    -- Play a heavy metal noise when hitting things hard
    ENT.IsHeavyVehicle = false

    -- Particle size multiplier for collisions
    ENT.CollisionParticleSize = 1

    -- Should passengers fall on collisions?
    ENT.FallOnCollision = false

    -- Damage things nearby when the vehicle explodes
    ENT.ExplosionRadius = 500

    -- Spawn these gibs when the vehicle explodes
    ENT.ExplosionGibs = {}

    -- Setup available weapon slots.
    -- Should contain a array of tables, where each table looks like this:
    --
    -- { maxAmmo = 0, fireRate = 0.02 }
    -- { maxAmmo = 2, fireRate = 1.0, replenishDelay = 2, ammoType = "missile" }
    ENT.WeaponSlots = {}

    -- Suspension sounds
    ENT.SuspensionHeavySound = "Glide.Suspension.CompressHeavy"
    ENT.SuspensionDownSound = "Glide.Suspension.Down"
    ENT.SuspensionUpSound = "Glide.Suspension.Up"

    -- If Wiremod is installed, this function gets called to add
    -- inputs/outputs to be created when the vehicle is initialized.
    -- Children classes can override this function, but they should
    -- call `BaseClass.SetupWiremodPorts( self, inputs, outputs )` before
    -- adding their own entries to these inputs/outputs tables.
    function ENT:SetupWiremodPorts( inputs, outputs )
        -- Input name, input type, input description
        inputs[#inputs + 1] = { "EjectDriver", "NORMAL", "When set to 1, kicks the driver out of the vehicle" }
        inputs[#inputs + 1] = { "LockVehicle", "NORMAL", "When set to 1, only the vehicle creator and friends can enter the vehicle" }

        -- Output name, output type, output description
        outputs[#outputs + 1] = { "MaxChassisHealth", "NORMAL", "Max. chassis health" }
        outputs[#outputs + 1] = { "ChassisHealth", "NORMAL", "Current chassis health (between 0.0 and MaxChassisHealth)" }
        outputs[#outputs + 1] = { "EngineHealth", "NORMAL", "Current engine health (between 0.0 and 1.0)" }
        outputs[#outputs + 1] = { "Active", "NORMAL", "0: No driver\n1: Has a driver" }
        outputs[#outputs + 1] = { "Driver", "ENTITY", "The current driver" }
        outputs[#outputs + 1] = { "DriverSeat", "ENTITY", "The driver seat" }
        outputs[#outputs + 1] = { "PassengerSeats", "ARRAY", "All other seats" }
    end

    --- When this vehicle's `FallOnCollision` is `true`,
    --- this function runs for all seats. You can use it
    --- to make only some players ragdoll off the vehicle.
    function ENT:CanFallOnCollision( _seatIndex )
        return true
    end

    -- You can safely override these on children classes
    function ENT:CreateFeatures() end

    function ENT:OnDriverEnter() end
    function ENT:OnDriverExit() end
    function ENT:OnSeatInput( _seatIndex, _action, _pressed ) end
    function ENT:OnWeaponFire( _weapon, _weaponIndex ) end
    function ENT:OnWeaponStop( _weapon, _weaponIndex ) end

    function ENT:OnPostThink( _dt, _selfTbl ) end
    function ENT:OnSimulatePhysics( _phys, _dt, _outLin, _outAng ) end
    function ENT:OnUpdateFeatures( _dt ) end
end
