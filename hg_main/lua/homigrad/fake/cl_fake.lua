hook.Add("PlayerFootstep", "CustomFootstep", function(ply) if IsValid(ply.FakeRagdoll) then return true end end)

net.Receive("fake",function()
	local fake = net.ReadBool()
	local rag = net.ReadEntity()
	local ply = net.ReadEntity()
	--local apptbl = net.ReadTable()

	if ply == LocalPlayer() then
		fakeTimer = CurTime()--еее третье лицо
	end

	ply.LastRagdollTime = CurTime() + 1.5
	ply.Fake = fake
	ply.FakeRagdoll = rag
	ply:SetNWEntity("FakeRagdoll",ply.FakeRagdoll)

	if IsValid(rag) then
		rag.GetPlayerColor = function()
			return ply:GetPlayerColor()
		end
	end

	--if apptbl and fake then
	--	if IsValid(rag) then
	--		rag:SetNWVector("PlayerColor",Vector(apptbl.Color.r / 255,apptbl.Color.g / 255,apptbl.Color.b / 255))
	--	end
	--end
end)


-- COMMAND TO BE IN FAKE (чо за англифицизм???)
concommand.Add("fake",function()
	net.Start("fake")
	net.SendToServer()
end)