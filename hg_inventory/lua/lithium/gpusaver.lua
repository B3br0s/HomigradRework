local hg_disable_stoprenderunfocus = CreateClientConVar("hg_disable_stoprenderunfocus","0",true)
hook.Add("PreRender", "LITHIUM_GPUSaver", function()
	if system.HasFocus() or hg_disable_stoprenderunfocus:GetBool() then return end
	cam.Start2D()
		local lp = LocalPlayer()
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(0, 0, ScrW(), ScrH())
		draw.DrawText("HG:R", "MersRadial", ScrW() * 0.5, ScrH() * 0.24 + 18, Color(100,100,100,50), TEXT_ALIGN_CENTER)
		draw.DrawText("не пошел бы ты нахуй???", "MersRadialSmall", ScrW() * 0.5, ScrH() * 0.28 + 18, Color(55,55,55,1), TEXT_ALIGN_CENTER)
	cam.End2D()
	return true
end)