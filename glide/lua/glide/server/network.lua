local commands = {}

commands[Glide.CMD_INPUT_SETTINGS] = function( ply )
    local data = Glide.ReadTable()

    Glide.Print( "Received input data from %s <%s>", ply:Nick(), ply:SteamID() )
    Glide.SetupPlayerInput( ply, data )
end

commands[Glide.CMD_SWITCH_SEATS] = function( ply )
    local seatIndex = net.ReadUInt( 5 )
    Glide.SwitchSeat( ply, seatIndex )
end

commands[Glide.CMD_SET_HEADLIGHTS] = function( ply )
    local toggle = net.ReadBool()
    local veh = ply:GlideGetVehicle()

    if IsValid( veh ) and ply:GlideGetSeatIndex() == 1 and veh.SetHeadlightState then
        veh:ChangeHeadlightState( toggle and 2 or 0 )
    end
end

-- Store the last entity the CLIENT told it was aiming at.
-- Used for lag compensation on turrets.
local lastAimEntity = Glide.lastAimEntity or {}

Glide.lastAimEntity = lastAimEntity

commands[Glide.CMD_LAST_AIM_ENTITY] = function( ply )
    local ent = net.ReadEntity()

    if IsValid( ent ) then
        lastAimEntity[ply] = ent
    end
end

-- Safeguard against spam
local cooldowns = {
    [Glide.CMD_INPUT_SETTINGS] = { interval = 1, players = {} },
    [Glide.CMD_SWITCH_SEATS] = { interval = 0.5, players = {} },
    [Glide.CMD_SET_HEADLIGHTS] = { interval = 0.5, players = {} },
    [Glide.CMD_LAST_AIM_ENTITY] = { interval = 0.01, players = {} }
}

-- Receive and validate network commands
net.Receive( "glide.command", function( _, ply )
    local id = ply:SteamID()
    local cmd = net.ReadUInt( Glide.CMD_SIZE )

    if not commands[cmd] then
        Glide.Print( "%s <%s> sent a unknown network command! (%d)", ply:Nick(), id, cmd )
        return
    end

    local cooldown = cooldowns[cmd]
    if not cooldown then return end

    local t = RealTime()
    local players = cooldown.players

    if players[id] and players[id] > t then
        Glide.Print( "%s <%s> sent network commands too fast!", ply:Nick(), id )
        return
    end

    players[id] = t + cooldown.interval
    commands[cmd]( ply )
end )

local ReadFloat = net.ReadFloat

net.Receive( "glide.camdata", function( _, ply )
    local data = ply.GlideCam

    if not data then
        ply.GlideCam = {
            origin = Vector(),
            angle = Angle()
        }

        data = ply.GlideCam
    end

    local origin = data.origin
    origin[1] = ReadFloat()
    origin[2] = ReadFloat()
    origin[3] = ReadFloat()

    local angle = data.angle
    angle[1] = ReadFloat()
    angle[2] = ReadFloat()
    angle[3] = ReadFloat()
end )

-- Cleanup cooldown/last aim entity entries for this player
hook.Add( "PlayerDisconnected", "Glide.NetCleanup", function( ply )
    local id = ply:SteamID()

    for _, c in pairs( cooldowns ) do
        c.players[id] = nil
    end

    lastAimEntity[ply] = nil
end )

local type = type

--- Send a notification message to the target(s).
function Glide.SendNotification( target, data )
    if type( target ) == "table" and #target == 0 then return end

    Glide.StartCommand( Glide.CMD_NOTIFY )
    Glide.WriteTable( data )
    net.Send( target )
end

--- Let the target client(s) know about a incoming lock-on.
function Glide.SendLockOnDanger( target )
    if type( target ) == "table" and #target == 0 then return end

    Glide.StartCommand( Glide.CMD_INCOMING_DANGER, false )
    net.WriteUInt( Glide.DANGER_TYPE.LOCK_ON, 3 )
    net.Send( target )
end

--- Let the target client(s) know about a incoming missile.
function Glide.SendMissileDanger( target, missile )
    if type( target ) == "table" and #target == 0 then return end

    Glide.StartCommand( Glide.CMD_INCOMING_DANGER, false )
    net.WriteUInt( Glide.DANGER_TYPE.MISSILE, 3 )
    net.WriteUInt( missile:EntIndex(), 32 )
    net.Send( target )
end

--- Apply a camera shake to the target's Glide camera.
function Glide.SendViewPunch( target, force )
    if type( target ) == "table" and #target == 0 then return end

    Glide.StartCommand( Glide.CMD_VIEW_PUNCH, false )
    net.WriteFloat( force )
    net.Send( target )
end
