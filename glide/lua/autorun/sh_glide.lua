Glide = Glide or {}

-- Vehicle types
Glide.VEHICLE_TYPE = {
    UNDEFINED = 0,
    CAR = 1,
    MOTORCYCLE = 2,
    HELICOPTER = 3,
    PLANE = 4,
    TANK = 5
}

-- Max. seats a single vehicle can have
Glide.MAX_SEATS = 10

-- Explosions are only transmitted to nearby players
Glide.MAX_EXPLOSION_DISTANCE = 15000

-- Explosion types
Glide.EXPLOSION_TYPE = {
    MISSILE = 0,
    VEHICLE = 1,
    TURRET = 2
}

-- Used to notify clients about incoming lock-on/missiles
Glide.DANGER_TYPE = {
    LOCK_ON = 1,
    MISSILE = 2
}

-- Enable lock-on for these entity classes
Glide.LOCKON_WHITELIST = {
    ["base_glide"] = true,
    ["base_glide_car"] = true,
    ["base_glide_tank"] = true,
    ["base_glide_aircraft"] = true,
    ["base_glide_heli"] = true,
    ["base_glide_plane"] = true,
    ["base_glide_motorcycle"] = true,
    ["prop_vehicle_prisoner_pod"] = true
}

-- Mouse flying control modes
Glide.MOUSE_FLY_MODE = {
    AIM = 0,        -- Point-to-aim
    DIRECT = 1,     -- Control movement directly
    CAMERA = 2      -- Free camera
}

-- Default color for vehicle lights
Glide.DEFAULT_HEADLIGHT_COLOR = Color( 255, 231, 176 )
Glide.DEFAULT_TURN_SIGNAL_COLOR = Color( 255, 164, 45 )
Glide.DEFAULT_SIREN_COLOR_A = Color( 255, 0, 0 )
Glide.DEFAULT_SIREN_COLOR_B = Color( 0, 0, 255 )

if SERVER then
    -- Surface grip multipliers for wheels
    Glide.SURFACE_GRIP = {
        [MAT_DIRT] = 0.9,
        [MAT_SNOW] = 0.8,
        [MAT_SAND] = 0.9,
        [MAT_FOLIAGE] = 0.9,
        [MAT_SLOSH] = 0.8,
        [MAT_GRASS] = 0.9,
        [MAT_GLASS] = 0.9
    }

    -- Surface rolling resistance multipliers for wheels
    Glide.SURFACE_RESISTANCE = {
        [MAT_DIRT] = 0.2,
        [MAT_SAND] = 0.2,
        [MAT_SNOW] = 0.2,
        [MAT_GRASS] = 0.15,
        [MAT_FOLIAGE] = 0.15
    }
end

if CLIENT then
    -- Vehicle camera types
    Glide.CAMERA_TYPE = {
        CAR = 0,
        TURRET = 1,
        AIRCRAFT = 2
    }

    -- Surfaces that can generate tire roll marks
    Glide.ROLL_MARK_SURFACES = {
        [MAT_DIRT] = true,
        [MAT_SNOW] = true,
        [MAT_SAND] = true,
        [MAT_FOLIAGE] = true,
        [MAT_GRASS] = true
    }

    -- Wheel surface sounds
    Glide.WHEEL_SOUNDS = {}

    Glide.WHEEL_SOUNDS.ROLL_VOLUME = {
        [MAT_METAL] = 1,
        [MAT_GRATE] = 1,
        [MAT_WOOD] = 1,
        [MAT_SNOW] = 0.7
    }

    Glide.WHEEL_SOUNDS.ROLL = {
        [MAT_DIRT] = "glide/wheels/roll_dirt.wav",
        [MAT_GRATE] = "glide/wheels/roll_metal.wav",
        [MAT_SNOW] = "glide/wheels/roll_dirt.wav",
        [MAT_PLASTIC] = "physics/plastic/plastic_barrel_scrape_rough_loop1.wav",
        [MAT_METAL] = "glide/wheels/roll_metal.wav",
        [MAT_SAND] = "glide/wheels/roll_dirt.wav",
        [MAT_FOLIAGE] = "glide/wheels/roll_dirt.wav",
        [MAT_SLOSH] = "glide/wheels/roll_road_wet.wav",
        [MAT_GRASS] = "glide/wheels/roll_dirt.wav",
        [MAT_VENT] = "ambient/machines/wall_ambient_loop1.wav",
        [MAT_WOOD] = "glide/wheels/roll_wood.wav"
    }

    Glide.WHEEL_SOUNDS.ROLL_SLOW = {
        [MAT_DEFAULT] = "glide/wheels/roll_road_slow.wav",
        [MAT_CONCRETE] = "glide/wheels/roll_road_slow.wav",
        [MAT_TILE] = "glide/wheels/roll_road_slow.wav",
        [MAT_GRASS] = "glide/wheels/roll_dirt_slow.wav",
        [MAT_DIRT] = "glide/wheels/roll_dirt_slow.wav",
        [MAT_SAND] = "glide/wheels/roll_dirt_slow.wav",
        [MAT_SNOW] = "glide/wheels/roll_dirt_slow.wav"
    }

    Glide.WHEEL_SOUNDS.SIDE_SLIP = {
        [MAT_DEFAULT] = "glide/wheels/side_skid_road_1.wav",
        [MAT_CONCRETE] = "glide/wheels/side_skid_road_1.wav",
        [MAT_TILE] = "glide/wheels/side_skid_road_1.wav",
        [MAT_DIRT] = "glide/wheels/side_skid_dirt.wav",
        [MAT_SNOW] = "physics/body/body_medium_scrape_smooth_loop1.wav",
        [MAT_PLASTIC] = "physics/plastic/plastic_barrel_scrape_smooth_loop1.wav",
        [MAT_SAND] = "physics/body/body_medium_scrape_rough_loop1.wav",
        [MAT_FOLIAGE] = "physics/cardboard/cardboard_box_scrape_rough_loop1.wav",
        [MAT_SLOSH] = "glide/wheels/side_skid_road_wet.wav",
        [MAT_GRASS] = "glide/wheels/side_skid_dirt.wav",
        [MAT_VENT] = "physics/metal/metal_box_scrape_smooth_loop1.wav",
        [MAT_WOOD] = "glide/wheels/side_skid_road_1.wav",
        [MAT_GLASS] = "physics/metal/metal_grenade_scrape_rough_loop1.wav"
    }

    Glide.WHEEL_SOUNDS.FORWARD_SLIP = {
        [MAT_DEFAULT] = "glide/wheels/torque_skid_road.wav",
        [MAT_DIRT] = "physics/body/body_medium_scrape_smooth_loop1.wav",
        [MAT_SNOW] = "physics/body/body_medium_scrape_smooth_loop1.wav",
        [MAT_PLASTIC] = "physics/plastic/plastic_barrel_scrape_smooth_loop1.wav",
        [MAT_SAND] = "physics/body/body_medium_scrape_rough_loop1.wav",
        [MAT_FOLIAGE] = "physics/cardboard/cardboard_box_scrape_rough_loop1.wav",
        [MAT_SLOSH] = "glide/wheels/side_skid_road_wet.wav",
        [MAT_GRASS] = "physics/body/body_medium_scrape_smooth_loop1.wav",
        [MAT_VENT] = "physics/metal/metal_box_scrape_smooth_loop1.wav",
        [MAT_WOOD] = "glide/wheels/side_skid_wood.wav",
        [MAT_GLASS] = "physics/metal/metal_grenade_scrape_rough_loop1.wav"
    }
end

if SERVER then
    -- Damage multiplier convars
    CreateConVar( "glide_bullet_damage_multiplier", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Damage multiplier for bullets hitting Glide vehicles.", 0, 10 )
    CreateConVar( "glide_blast_damage_multiplier", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Damage multiplier for explosions hitting Glide vehicles.", 0, 10 )
    CreateConVar( "glide_physics_damage_multiplier", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Damage multiplier taken by Glide vehicles after colliding against other things.", 0, 10 )

    -- Ragdoll time
    CreateConVar( "glide_ragdoll_max_time", "10", FCVAR_ARCHIVE + FCVAR_NOTIFY, "The max. amount of time a player can stay ragdolled. Set to 0 for infinite.", 0 )
end

-- Sandbox limits
CreateConVar( "sbox_maxglide_vehicles", "5", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Max. number of Glide vehicles that one player can have", 0 )
CreateConVar( "sbox_maxglide_standalone_turrets", "5", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Max. number of Glide Turrets that one player can have", 0 )
CreateConVar( "sbox_maxglide_missile_launchers", "5", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Max. number of Glide Missile Launchers that one player can have", 0 )
CreateConVar( "sbox_maxglide_projectile_launchers", "5", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Max. number of Glide Projectile Launchers that one player can have", 0 )

-- Turret tool convars
CreateConVar( "glide_turret_max_damage", "50", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Maximum damage dealt per bullet for Glide Turrets.", 0 )
CreateConVar( "glide_turret_min_delay", "0.02", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Minimum delay allowed for Glide Turrets.", 0, 1 )

-- Missile launcher tool convars
CreateConVar( "glide_missile_launcher_min_delay", "0.5", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Minimum delay allowed for Glide Missile Launchers.", 0.1, 5 )
CreateConVar( "glide_missile_launcher_max_lifetime", "10", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Maximum missile flight time allowed for Glide Missile Launchers.", 1 )
CreateConVar( "glide_missile_launcher_max_radius", "500", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Maximum radius from explosions created by Glide Missile Launchers.", 10 )
CreateConVar( "glide_missile_launcher_max_damage", "200", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Maximum damage dealt by explosions from Glide Missile Launchers.", 1 )

-- Projectile launcher tool convars
CreateConVar( "glide_projectile_launcher_min_delay", "0.5", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Minimum delay allowed for Glide Projectile Launchers.", 0.1, 5 )
CreateConVar( "glide_projectile_launcher_max_lifetime", "10", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Maximum projectile flight time allowed for Glide Projectile Launchers.", 1 )
CreateConVar( "glide_projectile_launcher_max_radius", "500", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Maximum radius from explosions created by Glide Projectile Launchers.", 10 )
CreateConVar( "glide_projectile_launcher_max_damage", "200", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Maximum damage dealt by explosions from Glide Projectile Launchers.", 1 )

-- Gib convars
CreateConVar( "glide_gib_lifetime", "8", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Lifetime of Glide Gibs, 0 for no despawning.", 0 )
CreateConVar( "glide_gib_enable_collisions", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY, "When set to 0, gibs wont collide with players/props.", 0, 1 )

list.Set( "ContentCategoryIcons", "Glide", "materials/glide/icons/car.png" )

function Glide.Print( str, ... )
    MsgC( Color( 0, 0, 255 ), "[Glide] ", color_white, string.format( str, ... ), "\n" )
end

do
    local isDeveloperActive = false

    function Glide.GetDevMode()
        return isDeveloperActive
    end

    -- Using `cvars.AddChangeCallback` was unreliable serverside,
    -- so we will check it periodically instead.
    local cvarDeveloper = GetConVar( "developer" )

    timer.Create( "Glide.CheckDeveloperConvar", 1, 0, function()
        isDeveloperActive = cvarDeveloper:GetBool()
    end )
end

function Glide.PrintDev( str, ... )
    if Glide.GetDevMode() then
        Glide.Print( str, ... )
    end
end

function Glide.ValidateNumber( v, min, max, default )
    return math.Clamp( tonumber( v ) or default, min, max )
end

function Glide.SetNumber( t, k, v, min, max, default )
    t[k] = Glide.ValidateNumber( v, min, max, default )
end

function Glide.ToJSON( t, prettyPrint )
    return util.TableToJSON( t, prettyPrint )
end

function Glide.FromJSON( s )
    if type( s ) ~= "string" or s == "" then
        return {}
    end

    return util.JSONToTable( s ) or {}
end

function Glide.LoadDataFile( path )
    return file.Read( path, "DATA" )
end

function Glide.SaveDataFile( path, data )
    Glide.Print( "%s: writing %s", path, string.NiceSize( string.len( data ) ) )
    file.Write( path, data )
end

if CLIENT then
    function Glide.GetLanguageText( id )
        return language.GetPhrase( "glide." .. id )
    end

    local lastViewPos = Vector()
    local lastViewAng = Angle()

    --- Get the cached position/angle of the local player's render view.
    function Glide.GetLocalViewLocation()
        return lastViewPos, lastViewAng
    end

    local EyePos = EyePos
    local EyeAngles = EyeAngles

    -- `PreDrawEffects` seems like a good place to get values from EyePos/EyeAngles reliably.
    -- `PreDrawOpaqueRenderables`/`PostDrawOpaqueRenderables` were being called
    -- twice when there was water, and `PreRender`/`PostRender`
    -- were causing `EyeAngles` to return incorrect angles.
    hook.Add( "PreDrawEffects", "Glide.CachePlayerView", function( bDepth, bSkybox, b3DSkybox )
        if bDepth or bSkybox or b3DSkybox then return end

        lastViewPos = EyePos()
        lastViewAng = EyeAngles()
    end )
end

do
    local Band = bit.band
    local PointContents = util.PointContents

    function Glide.IsUnderWater( pos )
        return Band( PointContents( pos ), 32 ) == 32
    end
end

function Glide.HasBaseClass( ent, class )
    local depth = 0
    local base = ent.BaseClass

    while depth < 10 do
        if base and base.ClassName == class then
            return true
        end

        depth = depth + 1

        if base then
            base = base.BaseClass
        else
            break
        end
    end

    return false
end

function Glide.IsAircraft( vehicle )
    return vehicle.VehicleType == Glide.VEHICLE_TYPE.HELICOPTER or vehicle.VehicleType == Glide.VEHICLE_TYPE.PLANE
end

do
    local COLOR_HIDDEN = Color( 255, 255, 255, 0 )

    --- Hide entity without using `SetNoDraw`, because it stops networking the entity, 
    --- and removes the entity from the parent's `GetChildren` clientside.
    function Glide.HideEntity( ent, hide )
        ent:SetRenderMode( hide and RENDERMODE_TRANSCOLOR or RENDERMODE_NORMAL )
        ent:SetColor( hide and COLOR_HIDDEN or color_white )
        ent.GlideIsHidden = Either( hide, true, nil )
    end
end

do
    local Exp = math.exp

    --- If you ever need `Lerp()`, use this instead.
    --- `Lerp()` is not consistent on different framerates, this is.
    function Glide.ExpDecay( a, b, decay, dt )
        return b + ( a - b ) * Exp( -decay * dt )
    end
end

do
    local function AngleDifference( a, b )
        return ( ( ( ( b - a ) % 360 ) + 540 ) % 360 ) - 180
    end

    Glide.AngleDifference = AngleDifference

    local ExpDecay = Glide.ExpDecay

    function Glide.ExpDecayAngle( a, b, decay, dt )
        return ExpDecay( a, a + AngleDifference( a, b ), decay, dt )
    end
end

hook.Add( "Initialize", "Glide.OverrideIsVehicle", function()
    local VehicleMeta = FindMetaTable( "Entity" )
    local IsVehicle = VehicleMeta.IsVehicle

    --- Override `Entity:IsVehicle` to return `true` on Glide vehicles.
    --- Also keep compatibility with Simfphys.
    function VehicleMeta:IsVehicle()
        return ( self.IsSimfphyscar and self:IsSimfphyscar() ) or self.IsGlideVehicle or IsVehicle( self )
    end
end )

local function IncludeDir( dirPath, doInclude, doTransfer )
    local files = file.Find( dirPath .. "*.lua", "LUA" )
    local path

    for _, fileName in ipairs( files ) do
        path = dirPath .. fileName

        if doInclude then
            include( path )
        end

        if doTransfer then
            AddCSLuaFile( path )
        end
    end
end

if SERVER then
    resource.AddWorkshop( "3389728250" )

    -- Shared files
    IncludeDir( "glide/", true, true )

    -- Server-only files
    IncludeDir( "glide/server/", true, false )

    -- Client-only files
    AddCSLuaFile( "styledstrike/theme.lua" )

    IncludeDir( "glide/client/", false, true )
end

if CLIENT then
    -- Shared files
    IncludeDir( "glide/", true, false )

    -- Setup UI theme
    include( "styledstrike/theme.lua" )

    Glide.THEME_COLOR = Color( 56, 113, 179 )

    Glide.Theme = StyledTheme.Create( {
        frameTitleBar = Glide.THEME_COLOR,
        buttonPress = Glide.THEME_COLOR,
        entryHighlight = Glide.THEME_COLOR
    } )

    -- Client-only files
    IncludeDir( "glide/client/", true, false )
end
