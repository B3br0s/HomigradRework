local commands = {}

commands[Glide.CMD_CREATE_EXPLOSION] = function()
    local pos = net.ReadVector()
    local normal = net.ReadVector()
    local explosionType = net.ReadUInt( 2 )

    Glide.CreateExplosion( pos, normal, explosionType )
end

commands[Glide.CMD_INCOMING_DANGER] = function()
    local dangerType = net.ReadUInt( 3 )

    if dangerType == Glide.DANGER_TYPE.LOCK_ON then
        Glide.LockOnHandler:OnIncomingLockOn()

    elseif dangerType == Glide.DANGER_TYPE.MISSILE then
        Glide.LockOnHandler:OnIncomingMissile( net.ReadUInt( 32 ) )

        if IsValid( Glide.currentVehicle ) and Glide.IsAircraft( Glide.currentVehicle ) then
            Glide.ShowKeyTip(
                "#glide.notify.tip.countermeasures",
                Glide.Config.binds["aircraft_controls"]["countermeasures"],
                "materials/glide/icons/rocket.png"
            )
        end
    end
end

commands[Glide.CMD_VIEW_PUNCH] = function()
    Glide.Camera:ViewPunch( net.ReadFloat() )
end

commands[Glide.CMD_NOTIFY] = function()
    local data = Glide.ReadTable()

    if string.sub( data.text, 1, 1 ) == "#" then
        data.text = language.GetPhrase( data.text )
    end

    Glide.Notify( data )
end

net.Receive( "glide.command", function()
    local cmd = net.ReadUInt( Glide.CMD_SIZE )

    if commands[cmd] then
        commands[cmd]()
    end
end )
