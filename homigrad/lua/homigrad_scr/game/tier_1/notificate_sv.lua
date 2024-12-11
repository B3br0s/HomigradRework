if not engine.ActiveGamemode() == "homigradcom" then return end
util.AddNetworkString( "AddNotificate" )

function AddNotificate( ply, str )
    net.Start( "AddNotificate" )
		net.WriteString( str )
	net.Send( ply )
end