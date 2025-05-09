util.AddNetworkString("JMod_ColorAndArm")
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

net.Receive("JMod_ColorAndArm", function(l, ply)
	if not (IsValid(ply) and ply:Alive()) then return end
	local ent = net.ReadEntity()
	if not (IsValid(ent) and ent.JModGUIcolorable) then return end
	if ply:GetPos():DistToSqr(ent:GetPos()) > 15000 then return end

	local AutoColor = net.ReadBit()
	local Col = net.ReadColor()

	if AutoColor == 1 then
		local Tr = util.QuickTrace(ent:GetPos() + Vector(0, 0, 10), Vector(0, 0, -50), ent)
		if Tr.Hit then
			local Info = JMod.HitMatColors[Tr.MatType]

			if Info then
				ent:SetColor(Info[1])

				if Info[2] then
					ent:SetMaterial(Info[2])
				end
			end
		end
		timer.Simple(.1, function()
			if not(IsValid(ent) and IsValid(ply) and ply:Alive()) then return end
			net.Start("JMod_ColorAndArm")
			net.WriteEntity(ent)
			net.WriteBool(true)
			net.Send(ply)
		end)
	else
		ent:SetColor(Col)
	end

	if net.ReadBit() == 1 then
		if ent.Prime then
			ent:Prime(ply)
		elseif ent.Arm then
			ent:Arm(ply)
		end
	end
end)

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

net.Receive("JMod_ApplyConfig", function(ln, ply)
	if not ply:IsValid() then return end
	if not ply:IsSuperAdmin() then return end
	local data = util.JSONToTable(util.Decompress(net.ReadData(ln)))
	JMod.InitGlobalConfig(true, data)
end)
