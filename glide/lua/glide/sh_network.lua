if SERVER then
    util.AddNetworkString( "glide.command" )
    util.AddNetworkString( "glide.camdata" )
end

-- Size limit for JSON data
Glide.MAX_JSON_SIZE = 8192 -- 8 kibibytes

-- Used on net.WriteUInt for the command ID
Glide.CMD_SIZE = 3

-- Command IDs (Max. ID when CMD_SIZE == 3 is 7)
Glide.CMD_INPUT_SETTINGS = 0
Glide.CMD_CREATE_EXPLOSION = 1
Glide.CMD_SWITCH_SEATS = 2
Glide.CMD_INCOMING_DANGER = 3
Glide.CMD_LAST_AIM_ENTITY = 4
Glide.CMD_VIEW_PUNCH = 5
Glide.CMD_SET_HEADLIGHTS = 6
Glide.CMD_NOTIFY = 7

function Glide.StartCommand( id, unreliable )
    net.Start( "glide.command", unreliable or false )
    net.WriteUInt( id, Glide.CMD_SIZE )
end

function Glide.WriteTable( t )
    local data = util.Compress( Glide.ToJSON( t ) )
    local bytes = #data

    net.WriteUInt( bytes, 16 )

    if bytes > Glide.MAX_JSON_SIZE then
        Glide.PrintF( "Tried to write JSON that was too big! (%d/%d)", bytes, Glide.MAX_JSON_SIZE )
        return
    end

    net.WriteData( data )
end

function Glide.ReadTable()
    local bytes = net.ReadUInt( 16 )

    if bytes > Glide.MAX_JSON_SIZE then
        Glide.PrintF( "Tried to read JSON that was too big! (%d/%d)", bytes, Glide.MAX_JSON_SIZE )
        return {}
    end

    local data = net.ReadData( bytes )
    return Glide.FromJSON( util.Decompress( data ) )
end
