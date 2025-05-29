local lply = LocalPlayer()

local spectr = {
    [1] = "First-Person",
    [2] = "Third-Person",
    [3] = "Free Flight"
}

local gradient_d = Material("vgui/gradient-d")

function DrawWHEnt(ent,pos)
	local pos2 = pos:ToScreen()
	local x,y = pos2.x, pos2.y

	local teamColor = ent.GetPlayerColor and ent:GetPlayerColor():ToColor() or ent:GetColor()
	local distance = EyePos():Distance(pos)

	local factor = 1 - math.Clamp(distance / 1024, 0, 1)
	local size = math.max(10,32 * factor)
	local alpha = math.max(255 * factor,80)

	local text = ent.Name and ent:Name() or ent.PrintName
	surface.SetFont("Trebuchet18")
	local tw, th = surface.GetTextSize(text)

	surface.SetDrawColor(teamColor.r, teamColor.g, teamColor.b, alpha * 0.5)
	surface.SetMaterial(gradient_d)
	surface.DrawTexturedRect(x - size / 2 - tw / 2, y - th / 2, size + tw, th)

	surface.SetTextColor(255, 255, 255, alpha)
	surface.SetTextPos(x - tw / 2, y - th / 2)
	surface.DrawText(text)

	local barWidth = math.Clamp((ent:Health() / ent:GetMaxHealth()) * (size + tw), 0,size + tw)
	local healthcolor = ent:Health() / ent:GetMaxHealth() * 255

	surface.SetDrawColor(255, healthcolor, healthcolor, alpha)
	surface.DrawRect(x - barWidth / 2, y + th / 1.5, barWidth, ScreenScale(1))
end

local rp = false
local wp = false
local ap = false
local a2p = false

local show = false

hook.Add("HUDPaint","Spectate-HUD",function()
	local lply = LocalPlayer()
	
    if lply:Alive() and lply:Team() != 1002 then
        return
    end

	if lply:KeyDown(IN_WALK) and !wp then
		wp = true
		show = not show
	elseif !lply:KeyDown(IN_WALK) then
		wp = false
	end

	if lply:KeyDown(IN_RELOAD) and !rp then
		rp = true
		net.Start("spect_shit")
		net.WriteFloat(IN_RELOAD)
		net.SendToServer()
	elseif !lply:KeyDown(IN_RELOAD) then
		rp = false
	end
	if lply:KeyDown(IN_ATTACK) and !ap then
		ap = true
		net.Start("spect_shit")
		net.WriteFloat(IN_ATTACK)
		net.SendToServer()
	elseif !lply:KeyDown(IN_ATTACK) then
		ap = false
	end
	if lply:KeyDown(IN_ATTACK2) and !a2p then
		a2p = true
		net.Start("spect_shit")
		net.WriteFloat(IN_ATTACK2)
		net.SendToServer()
	elseif !lply:KeyDown(IN_ATTACK2) then
		a2p = false
	end

	if lply:Team() == 1002 and lply:Alive() then
		lply:SetNWEntity("SpectEnt",NULL)
	end
    
    local ent = lply:GetNWEntity("SpectEnt",NULL)

	if lply:GetNWInt("SpecMode",1) == 3 then
		ent = NULL
	end
 
    if IsValid(ent) then

    local entcolor = ent.GetPlayerColor and ent:GetPlayerColor() or ent:GetColor():ToVector()
    local entname = ent.GetName and ent:GetName() or ent.PrintName

    local x,y = ScrW() / 2,ScrH() - 80

    surface.SetFont("H.25")
    surface.SetDrawColor(entcolor[1] * 255,entcolor[2] * 255,entcolor[3] * 255,255)

    local tw, th = surface.GetTextSize(entname)
    local teamColor = ent.GetPlayerColor and ent:GetPlayerColor():ToColor() or ent:GetColor()

	local factor = 1
	local size = math.max(10,32 * factor)
	local alpha = math.max(255 * factor,80)

	local text = ent.Name and ent:Name() or ent.PrintName
	surface.SetFont("HS.25")
	local tw, th = surface.GetTextSize(text)

	surface.SetDrawColor(teamColor.r, teamColor.g, teamColor.b, alpha * 0.5)
	surface.SetMaterial(gradient_d)
	surface.DrawTexturedRect(x - size / 2 - tw / 2, y - th / 2, size + tw, th)

	surface.SetTextColor(255, 255, 255, alpha)
	surface.SetTextPos(x - tw / 2, y - th / 2)
	surface.DrawText(text)

	local barWidth = math.Clamp((ent:Health() / ent:GetMaxHealth()) * (size + tw), 0,size + tw)
	local healthcolor = ent:Health() / ent:GetMaxHealth() * 255

	surface.SetDrawColor(255, healthcolor, healthcolor, alpha)
	surface.DrawRect(x - barWidth / 2, y + th / 1.5, barWidth, ScreenScale(1))

	draw.SimpleText(string.format(hg.GetPhrase("SpectHP"),ent:Health()),"H.18",ScrW() / 2,y + 35,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	draw.SimpleText(string.format(hg.GetPhrase("SpectMode"),spectr[lply:GetNWInt("SpecMode",1)]),"H.12",ScrW() / 2,y + 58,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

	end
    for _, v in ipairs(player.GetAll()) do --ESP
        if not v:Alive() or v == ent or !show then continue end

        DrawWHEnt(v,((v:GetNWBool("Fake") and IsValid(v:GetNWEntity("FakeRagdoll"))) and v:GetNWEntity("FakeRagdoll"):GetPos() or v:GetPos()))
    end
end)