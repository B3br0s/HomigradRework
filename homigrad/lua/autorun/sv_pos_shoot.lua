if SERVER then
	util.AddNetworkString("ChangePos")
	
	net.Receive("ChangePos",function (len,ply)
		if ply:GetNWFloat("PosaVistrela") and not ply.fake then
			if ply:GetNWFloat("PosaVistrela") > 4 then
				ply:SetNWFloat("PosaVistrela",1)
                ply:SetNWFloat("PosaVistrelaWeapon",ply:GetActiveWeapon())
                ply:SelectWeapon("weapon_hands")
                timer.Simple(0.001,function ()
                    ply:SelectWeapon(ply:GetNWFloat("PosaVistrelaWeapon"))
                    ply:SetNWFloat("PosaVistrelaWeapon",nil)
                end)
			else
				ply:SetNWFloat("PosaVistrela",ply:GetNWFloat("PosaVistrela") + 1)
                ply:SetNWFloat("PosaVistrelaWeapon",ply:GetActiveWeapon())
                ply:SelectWeapon("weapon_hands")
                timer.Simple(0.001,function ()
                    ply:SelectWeapon(ply:GetNWFloat("PosaVistrelaWeapon"))
                    ply:SetNWFloat("PosaVistrelaWeapon",nil)
                end)
            end
		end
	end)
end

if CLIENT then
concommand.Add("hg_changepos",function (ply,cmd,args)
    net.Start("ChangePos")
    net.WriteEntity(ply)
    net.SendToServer()
end)
end