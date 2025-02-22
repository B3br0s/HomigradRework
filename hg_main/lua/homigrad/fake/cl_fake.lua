hook.Add("PlayerFootstep", "CustomFootstep", function(ply) if IsValid(ply.FakeRagdoll) then return true end end)

hook.Add("Player Think","Player_Fake",function(ply,time)
	ply.Fake = ply:GetNWBool("Fake")
	ply.FakeRagdoll = ply:GetNWEntity("FakeRagdoll")
end)

hook.Add("Think","Homigrad_Ragdoll_Color",function()
	for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do
		if ent:IsRagdoll() then
			if ent:GetNWVector("PlayerColor") then
				if IsValid(ent) then
					ent.GetPlayerColor = function()
						return ent:GetNWVector("PlayerColor")
					end
				end
			end
		end
	end
end)

concommand.Add("fake",function()
	net.Start("fake")
	net.SendToServer()
end)