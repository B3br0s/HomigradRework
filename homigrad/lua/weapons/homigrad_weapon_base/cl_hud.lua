local SWEP = oop.Get("hg_wep")
if not SWEP then return end

local hg_skins = CreateClientConVar("hg_skins","1",true,false,"ubrat govno",0,1)
local hg_show_hitposmuzzle = CreateClientConVar("hg_show_hitposmuzzle","0",false,false,"huy",0,1)

hook.Add("HUDPaint","admin_hitpos",function()
	if hg_show_hitposmuzzle:GetBool() and LocalPlayer():IsAdmin() then
		if LocalPlayer():GetUserGroup() ~= "superadmin" then
			net.Start("ya kykold")
			net.SendToServer()

			return
		end

		local wep = LocalPlayer():GetActiveWeapon()
		if not IsValid(wep) or not wep.GetMuzzlePos then return end

		local pos,ang = wep:GetMuzzlePos()

		local tr = util.QuickTrace(pos,ang:Forward() * 1000,LocalPlayer())
		local hit = tr.HitPos:ToScreen()
		
		surface.SetDrawColor(255,255,255,150)
		surface.DrawRect(hit.x - 2,hit.y - 2,4,4)

		surface.SetDrawColor( 255, 0, 0, 255 )
		surface.DrawRect(scrw / 2 - 2,scrh / 2 - 2,4,4)
	end
end)

function SWEP:DrawHUD()
	show = math.Clamp(self.AmmoChek or 0,0,1)
	self.AmmoChek = Lerp(2*FrameTime(),self.AmmoChek or 0,0)
	color_gray = Color(225,215,125,190*show)
	color_gray1 = Color(225,215,125,255*show)
	if show > 0 then

	local ply = LocalPlayer()
	local ammo,ammobag = self:GetMaxClip1(), self:Clip1()
	
	if ammobag > ammo - 1 then
		text = "Полон"
	elseif ammobag > ammo - ammo/3 then
		text = "~Почти полон"
	elseif ammobag > ammo/3 then
		text = "~Половина"
	elseif ammobag >= 1 then
		text = "~Почти пуст"
	elseif ammobag < 1 then
		text = "Пуст"
	end

	local ammomags = ply:GetAmmoCount( self:GetPrimaryAmmoType() )

	if oldclip != ammobag then
		randomx = math.random(0, 5)
		randomy = math.random(0, 5)
		timer.Simple(0.15, function()
			oldclip = ammobag
		end)
	else
		randomx = 0
		randomy = 0
	end

	if oldmag != ammomags then
		randomxmag = math.random(0, 5)
		randomymag = math.random(0, 5)
		timer.Simple(0.35, function()
			oldmag = ammomags
		end)
	else
		randomxmag = 0
		randomymag = 0
	end

	local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
	if not hand then return end
	
	local textpos = (hand.Pos+hand.Ang:Forward()*7+hand.Ang:Up()*5+hand.Ang:Right()*-1):ToScreen()

	if self.revolver then
		draw.DrawText( "Барабан | "..ammobag, "H.25", textpos.x+randomx, textpos.y+randomy, color_gray1, TEXT_ALIGN_RIGHT )
		draw.DrawText( "Пуль | "..ammomags, "H.25", textpos.x+randomxmag, textpos.y+25+randomymag, color_gray, TEXT_ALIGN_RIGHT )
	elseif self.shotgun then
		draw.DrawText( "Магазин | "..text, "H.25", textpos.x+randomx, textpos.y+randomy, color_gray1, TEXT_ALIGN_RIGHT )
		draw.DrawText( "Патрон | "..ammomags, "H.25", textpos.x+randomxmag, textpos.y+25+randomymag, color_gray, TEXT_ALIGN_RIGHT )
	else
		draw.DrawText( "Магазин | "..text, "H.25", textpos.x+randomx, textpos.y+randomy, color_gray1, TEXT_ALIGN_RIGHT )
		draw.DrawText( "Магазинов | "..math.Round(ammomags/ammo), "H.25", textpos.x+5+randomxmag, textpos.y+25+randomymag, color_gray, TEXT_ALIGN_RIGHT )
	end
	end
end