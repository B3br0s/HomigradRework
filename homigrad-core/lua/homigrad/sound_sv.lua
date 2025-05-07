util.AddNetworkString("sound")
function sound.Emit(ent,sndName,level,volume,pitch,pos)
    net.Start("sound")
    net.WriteTable({sndName,ent != nil and ent:GetPos() or pos,(ent != nil and ent:EntIndex() or math.random(1,150)),level,volume,pitch,dsp})
    net.Broadcast()
end

util.AddNetworkString("sound surface")
function sound.EmitSurface(ply,sndName)
    net.Start("sound surface")
    net.WriteString(sndName)
    net.Send(ply)
end