util.AddNetworkString("JMod_EZtimeBomb")
util.AddNetworkString("JMod_LuaConfigSync")
util.AddNetworkString("JMod_ModifyMachine")
util.AddNetworkString("JMod_ModifyConnections")
util.AddNetworkString("JMod_NuclearBlast")
util.AddNetworkString("JMod_SFX")
util.AddNetworkString("JMod_Ravebreak")
util.AddNetworkString("JMod_Debugging") -- engineer gaming
util.AddNetworkString("JMod_ConfigUI")
util.AddNetworkString("JMod_ApplyConfig")
util.AddNetworkString("JMod_LiquidParticle")

net.Receive("JMod_EZtimeBomb", function(ln, ply)
	local ent = net.ReadEntity()
	local tim = net.ReadInt(16)

	if (ent:GetState() == 0) and (ent.EZowner == ply) and ply:Alive() and (ply:GetPos():Distance(ent:GetPos()) <= 150) then
		ent:SetTimer(math.min(tim, 600))
		ent.DisarmNeeded = math.Round(math.min(tim, 600) / 4)
		ent:NextThink(CurTime() + 1)
		ent:SetState(1)
		ent:EmitSound("weapons/c4/c4_plant.wav", 60, 120)
		ent:EmitSound("snd_jack_minearm.ogg", 60, 100)
	end
end)