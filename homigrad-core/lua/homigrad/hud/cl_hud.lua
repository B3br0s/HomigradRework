hook.Add("HUDPaint","OpenShit",function()
    draw.SimpleText(hg.GetPhrase("open_alpha"),"H.25",ScrW() / 2,ScrH() / 1.3,Color(255,255,255,52.5),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    //draw.SimpleText("homigrad.com 548 commit","HS.14",ScrW()/1.002,ScrH(),Color(255,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM) //затролл
    draw.SimpleText("hg rework alpha 130 commit","HS.14",ScrW()/1.002,ScrH(),Color(255,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
    draw.SimpleText(hg.GetPhrase("report_bugs"),"H.18",ScrW() / 2,ScrH() / 1.27,Color(255,255,255,52.5),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    draw.SimpleText(LocalPlayer():SteamID(),"H.18",ScrW() / 2,ScrH() / 1.23,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end)
hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = false,
	["CHudSecondaryAmmo"] = true,
	["CHudCrosshair"] = true
}

hook.Add("HUDShouldDraw", "homigrad", function(name) if hide[name] then return false end end)
hook.Add("HUDDrawPickupHistory","homigrad",function() return true end)
hook.Add("HUDItemPickedUp","homigrad",function() return true end)
hook.Add("HUDDrawTargetID", "homigrad", function() return false end)
hook.Add("DrawDeathNotice", "homigrad", function() return false end)
surface.CreateFont("HomigradFont", {
	font = "Roboto",
	size = ScreenScale(10),
	weight = 1100,
	outline = false
})

surface.CreateFont("HomigradFontBig", {
	font = "Roboto",
	size = 35,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("HomigradFontLarge", {
	font = "Roboto",
	size = 40,
	weight = 1100,
	outline = false
})

surface.CreateFont("HomigradFontSmall", {
	font = "Roboto",
	size = 17,
	weight = 1100,
	outline = false
})

local w, h
local lply = LocalPlayer()
hook.Add("HUDPaint", "homigrad-dev", function()
	if engine.ActiveGamemode() != "sandbox" then return end
	w, h = ScrW(), ScrH()
end)

--draw.SimpleText(lply:Health(),"HomigradFontBig",100,h - 50,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
function draw.CirclePart(x, y, radius, seg, parts, pos)
	local cir = {}
	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad((i / seg) * -360 / parts - pos * 360 / parts)
		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
		--draw.DrawText("asd","HomigradFontBig",x + math.sin(a) * radius,y + math.cos(a) * radius)
	end

	--local a = math.rad(0)
	--table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})
	surface.DrawPoly(cir)
end

local menuPanel
hg.radialOptions = hg.radialOptions or {}
local colBlack = Color(0, 0, 0, 122)
local colWhite = Color(255, 255, 255, 255)
local colWhiteTransparent = Color(255, 255, 255, 122)
local colTransparent = Color(0, 0, 0, 0)
local matHuy = Material("vgui/white")
local vecXY = Vector(0, 0)
local vecDown = Vector(0, 1)
local isMouseIntersecting = false
local isMouseOnRadial = false
local current_option = 1
local current_option_select = 1
local hook_Run = hook.Run
local function dropWeapon()
	RunConsoleCommand("say", "*drop")
end

hook.Add( "HUDShouldDraw", "RemoveThatShit", function( name ) 
    if ( name == "CHudDamageIndicator" ) then 
       return false 
    end
end )

net.Receive("localized_chat",function()
    LocalPlayer():ChatPrint(hg.GetPhrase(net.ReadString()))
end)

hook.Add("HUDPaint","Spectator_Locate",function()
	for _, ply in ipairs(player.GetAll()) do
		if !ply:Alive() then
			continue 
		end
		if ply:Team() != 1002 then
			continue 
		end
		if ply == LocalPlayer() then
			continue 
		end

		local dist = ply:GetPos():Distance((LocalPlayer():GetPos()))

		local pos = (ply:GetPos() + ply:OBBCenter()):ToScreen()

		if dist < 600 then

			draw.SimpleText(hg.GetPhrase("spectator"),"HS.25",pos.x,pos.y,Color(255,255,255,255 * (100 / dist)),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
end)