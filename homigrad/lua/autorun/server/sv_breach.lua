hook.Add("PlayerUse","BreachKCSys",function(ply,ent)
	if roundActiveName == "scpcb" then
        if ply:KeyPressed(IN_USE) then
	        if ent.KeyClass and ply:GetActiveWeapon().KeyClass and ent.KeyClass <= ply:GetActiveWeapon().KeyCardClass then
                sound.Play("scp/keycardaccept.wav",ply:GetPos())
	        		return true
	        elseif ent.KeyClass and ply:GetActiveWeapon().KeyClass and ent.KeyClass > ply:GetActiveWeapon().KeyCardClass then
                sound.Play("scp/keycarddeny.wav",ply:GetPos())
	        		return false
	        elseif ent.KeyClass and not ply:GetActiveWeapon().KeyCardClass then
                sound.Play("scp/keycarddeny.wav",ply:GetPos())
	        		return false
            elseif table.HasValue(WARHEAD_DETONATION,ent:GetPos()) and not ent.Armed then
                ent.Armed = true
                TableRound().AlphaArmed = true
                net.Start("SoundPlay")
                net.WriteString("scp/announcements/warhead.wav")
                net.Broadcast()
                timer.Simple(95.3,function()
                    if not TableRound().AlphaArmed then return end
                    for _, ply in ipairs(player.GetAll()) do
                        if !ply:Alive() then continue end
                        if ply:GetPos()[3] < 2177 then
                            ply:Kill()
                            ply:ChatPrint("Вы были взорваны АЛЬФА-БОЕГОЛОВКОЙ")
                        end
                    end
                end)
            end
	    end
    end
end)

hook.Add("Think", "BreachKeyCardSystem", function()
    if roundActiveName == "scpcb" then
        K2 = {
            Vector(3896.000000, 3745.000000, 53.000000),
            Vector(195.679993, -1387.290039, -75.000000),
            Vector(5281.000000, -1016.000000, 53.000000),
            Vector(-1928.000000, 3551.000000, 53.000000),
            Vector(-944.000000, -705.500000, 53.000000),
            Vector(1393.000000, 728.000000, 53.000000),
            Vector(2072.000000, 1185.000000, 53.000000),
            Vector(393.000000, -152.000000, 53.000000),
            Vector(737.000000, -1240.000000, 53.000000),
            Vector(-2239.000000, 1832.000000, 181.000000)
        }

        WARHEAD_DETONATION = {
            Vector(3991.762939, 261.911407, -347.979004)
        }

        K3 = {
            Vector(3723.500000, -1162.000000, -75.000000),
            Vector(-1288.000000, 2465.000000, 53.000000),
            Vector(-936.000000, 2465.000000, 53.000000),
            Vector(1536.000000, 3648.000000, 53.000000),
            Vector(2176.000000, 2368.000000, 53.000000),
            Vector(2816.000000, 1088.000000, 53.000000),
            Vector(2816.000000, -192.000000, 53.000000),
            Vector(1264.000000, -958.500000, 53.000000),
            Vector(2968.000000, 273.000000, 53.000000),
            Vector(2616.000000, 641.000000, 53.000000),
            Vector(792.000000, 3977.000000, 53.000000),
            Vector(3664.000000, 2156.000000, 59.000000),
            Vector(1688.000000, 4113.000000, 53.000000)
        }

        K4 = {
            Vector(-2328.000000, 3775.000000, 53.000000),
            Vector(-321.000000, 4784.000000, 53.000000),
            Vector(1801.000000, -1432.000000, 53.000000),
            Vector(1289.000000, 2055.989990, 53.000000),
            Vector(1289.000000, 2216.000000, 53.000000),
            Vector(2570.000000, 3100.000000, -331.250000)
        }

        K5 = {
            Vector(-3790.500000, 2472.500000, 53.000000),
            Vector(193.000000, 1768.000000, 309.000000),
            Vector(393.000000, 1288.000000, 181.000000),
            Vector(2200.000000, 4145.000000, 53.000000),
            Vector(2441.000000, 1896.000000, 53.000000),
            Vector(4993.000000, 3432.000000, 53.000000)
        }
		
        for _, ent in ipairs(ents.GetAll()) do
            if table.HasValue(K2, ent:GetPos()) then
                ent.KeyClass = 2
            elseif table.HasValue(K3, ent:GetPos()) then
                ent.KeyClass = 3
            elseif table.HasValue(K4, ent:GetPos()) then
                ent.KeyClass = 4
            elseif table.HasValue(K5, ent:GetPos()) then
                ent.KeyClass = 5
            end
        end
    end
end)