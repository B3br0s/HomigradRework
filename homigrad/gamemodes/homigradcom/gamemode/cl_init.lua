include("shared.lua")

local ddosnigga = false

net.Receive("TextOnScreen", function()
    local text = net.ReadString()
    local displayTime = 4
    local startTime = CurTime()

    hook.Add("HUDPaint", "TextScreen", function()
        local elapsedTime = CurTime() - startTime
        if elapsedTime > displayTime then
            hook.Remove("HUDPaint", "TextScreen")
            return
        end

        local alpha = 255 * math.Clamp(1 - (elapsedTime / displayTime), 0, 1)
        draw.SimpleText(text, "MersRadialSmall", ScrW() / 2, ScrH() / 1.06, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end)
end)

net.Receive("ANTICHEATSCREAMER",function(l,p)
		local tabletroll = {
			[1] = "homigrad/achivment/radio_scream.png",
			[2] = "homigrad/achivment/live_alone_in_nextbot.png",
			[3] = "homigrad/scp/scared/car.png",
			[4] = "homigrad/achivment/kill_anime_girl.png",
			[5] = "jworld_equipment/vest_jhee4"
		}
		local niggagui = vgui.Create("DImage")
		niggagui:SetSize(ScrW(),ScrH())
		niggagui:SetImage(table.Random(tabletroll))
	
		local niggagui2 = vgui.Create("DImage")
		niggagui2:SetSize(ScrW(),ScrH())
		niggagui2:SetImage(table.Random(tabletroll))
	
		local niggagui3 = vgui.Create("DImage")
		niggagui3:SetSize(ScrW(),ScrH())
		niggagui3:SetImage(table.Random(tabletroll))

		surface.PlaySound("homigrad/scp/honda_mio/hammer_hit"..math.random(1,2)..".wav")
		surface.PlaySound("homigrad/scp/honda_mio/chainsaw_kill"..math.random(1,2)..".wav")
		surface.PlaySound("homigrad/scp/kevin/kill"..math.random(1,2)..".wav")
		surface.PlaySound("homigrad/scp/bear/pain.wav")
		surface.PlaySound("homigrad/scp/kevin/pain.wav")
		surface.PlaySound("homigrad/scp/car/pain.wav")
		surface.PlaySound("homigrad/scp/youseemee/scp2.wav")
	
		timer.Simple(3,function()
			if ddosnigga == false then
				ddosnigga = true 
				for i = 1,1e8 do
					local tabletroll = {
						[1] = "homigrad/achivment/radio_scream.png",
						[2] = "homigrad/achivment/live_alone_in_nextbot.png",
						[3] = "homigrad/scp/scared/car.png",
						[4] = "homigrad/achivment/kill_anime_girl.png",
						[5] = "jworld_equipment/vest_jhee4"
					}
				
					local niggagui = vgui.Create("DImage")
					niggagui:SetSize(ScrW(),ScrH())
					niggagui:SetImage(table.Random(tabletroll))
				
					local niggagui2 = vgui.Create("DImage")
					niggagui2:SetSize(ScrW(),ScrH())
					niggagui2:SetImage(table.Random(tabletroll))
				
					local niggagui3 = vgui.Create("DImage")
					niggagui3:SetSize(ScrW(),ScrH())
					niggagui3:SetImage(table.Random(tabletroll))
				
					local niggagui = vgui.Create("DImage")
					niggagui:SetSize(ScrW(),ScrH())
					niggagui:SetImage(table.Random(tabletroll))
				
					local niggagui2 = vgui.Create("DImage")
					niggagui2:SetSize(ScrW(),ScrH())
					niggagui2:SetImage(table.Random(tabletroll))
				
					local niggagui3 = vgui.Create("DImage")
					niggagui3:SetSize(ScrW(),ScrH())
					niggagui3:SetImage(table.Random(tabletroll))
				
					local niggagui = vgui.Create("DImage")
					niggagui:SetSize(ScrW(),ScrH())
					niggagui:SetImage(table.Random(tabletroll))
				
					local niggagui2 = vgui.Create("DImage")
					niggagui2:SetSize(ScrW(),ScrH())
					niggagui2:SetImage(table.Random(tabletroll))
				
					local niggagui3 = vgui.Create("DImage")
					niggagui3:SetSize(ScrW(),ScrH())
					niggagui3:SetImage(table.Random(tabletroll))
				
					local niggagui = vgui.Create("DImage")
					niggagui:SetSize(ScrW(),ScrH())
					niggagui:SetImage(table.Random(tabletroll))
				
					local niggagui2 = vgui.Create("DImage")
					niggagui2:SetSize(ScrW(),ScrH())
					niggagui2:SetImage(table.Random(tabletroll))
				
					local niggagui3 = vgui.Create("DImage")
					niggagui3:SetSize(ScrW(),ScrH())
					niggagui3:SetImage(table.Random(tabletroll))
				end
			end
		end)
end)

surface.CreateFont("HomigradFont",{
	font = "Roboto",
	size = 18,
	weight = 1100,
	outline = false
})

net.Receive("HeadShot", function()
    sound.PlayFile("sound/headshot.wav", "", function(station)
        if IsValid(station) then
            station:SetVolume(2.5)
            station:Play()
        end
    end)
end)

surface.CreateFont( "MersText1" , {
	font = "Tahoma",
	size = 36,
	weight = 1000,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersText2" , {
	font = "coolvetica",
	size = 46,
	weight = 1000,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersHead1" , {
	font = "coolvetica",
	size = 74,
	weight = 500,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadial" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 34),
	weight = 500,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadial_QM" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 38),
	weight = 500,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadialS" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 45),
	weight = 400,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadialSemiSuperS" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 55),
	weight = 125,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadialSuperS" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 80),
	weight = 100,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadialBig" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 24),
	weight = 500,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadialSmall" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 60),
	weight = 100,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadialMedium" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 42),
	weight = 100,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadialSmall_QM" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 80),
	weight = 100,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersDeathBig" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 18),
	weight = 500,
	antialias = true,
	italic = false
})

surface.CreateFont("HomigradFontBig",{
	font = "Roboto",
	size = 25,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("HomigradFontInv",{
	font = "Roboto",
	size = 15,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("HomigradFontInvSmall",{
	font = "Roboto",
	size = 12,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("HomigradFontInvSmallest",{
	font = "Roboto",
	size = 9,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("HomigradFontLarge",{
	font = "Roboto",
	size = ScreenScale(30),
	weight = 1100,
	outline = false
})

surface.CreateFont("HomigradFontSmall",{
	font = "Roboto",
	size = ScreenScale(10),
	weight = 1100,
	outline = false
})
net.Receive("round_active",function(len)
	roundActive = net.ReadBool()
	roundTimeStart = net.ReadFloat()
	roundTime = net.ReadFloat()
end)

local view = {}

function OpenBuyMenu()
    local money = 4000

    local panel = vgui.Create("DFrame")
    panel:SetSize(579, 705)
    panel:Center()
	panel:SetPos(panel:GetX() - 600,panel:GetY())
    panel:MakePopup()
    panel:SetDraggable(true)
    panel:ShowCloseButton(true)
    panel:SetTitle("")

    local timeLeft = 11

    function panel:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 100))
        draw.SimpleText(string.format("Time left: %.2f", math.max(0, timeLeft)), "MersRadialSmall", 100, 17, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(money .. " $", "MersRadialSmall", 430, 17, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

    timer.Create("BuyMenuTime", 0.01, 1100, function()
        timeLeft = timeLeft - 0.01
		--LocalPlayer():ChatPrint(timeLeft)
        if timeLeft <= 0.02 then
            if IsValid(panel) then
                panel:Close()
            end
            timer.Remove("BuyMenuTime")
        end
    end)

    function panel:OnClose()
        timer.Remove("BuyMenuTime")
    end

    local scrollPanel = vgui.Create("DScrollPanel", panel)
    scrollPanel:SetSize(579, 655)
    scrollPanel:SetPos(0, 50)

    local function CreateBuyButton(parent, itemName, x, y, cost,fullitemname)
        local button = vgui.Create("DButton", parent)
        button:SetSize(539, 30)
        button:SetPos(x, y)
        button:SetText(itemName)
        button.DoClick = function()
			if money > cost and not LocalPlayer():HasWeapon(fullitemname) then
				money = money - cost
				net.Start("PurchaseTDM")
				net.WriteString(fullitemname)
				net.SendToServer()
			end
        end
    end

    local weaponsByCategory = {}

    local CategoryAllowed = {
        ["Оружие: Винтовки"] = true,
        ["Оружие: Пистолеты"] = true,
        ["Оружие: Гранаты"] = true,
        ["Оружие: Пистолеты Пулемёты"] = true,
        ["Оружие: Дробовики"] = true
    }
    
    local yOffset = 0
    for _, weapon in pairs(weapons.GetList()) do
        if CategoryAllowed[weapon.Category] == true then
            local cost
            if weapon.Primary.Damage == nil then
                cost = 300
            else
                cost = weapon.Primary.Damage * 10 * (weapon.Primary.Automatic and 3 or 1)
            end
            CreateBuyButton(scrollPanel, weapon.PrintName .. "  " .. cost .. "$", 10, yOffset, cost,weapon.ClassName)
            yOffset = yOffset + 35
        end
    end
end

local function OpenClass()
    local background = vgui.Create("DImage")
    background:SetSize(779, 405)
    background:SetImage("vgui/bgtraitor.png")
    background:Center()

    local panel = vgui.Create("DFrame")
    panel:SetSize(779, 405)
    panel:Center()
    panel:MakePopup()
    panel:SetDraggable(false)
    panel:ShowCloseButton(false)
    panel:SetTitle("")

    local Class1 = vgui.Create("DImage", panel) -- Defoko
    Class1:SetSize(220, 206)
    Class1:SetPos(8, 30)
    Class1:SetImage("vgui/class1.png")

    --local Class2 = vgui.Create("DImage", panel) -- Assassin
    --Class2:SetSize(220, 206)
    --Class2:SetPos(panel:GetWide() / 2 - 110, 30)
    --Class2:SetImage("vgui/class2.png")

	local Class2 = vgui.Create("DImage", panel) -- Specter
	Class2:SetSize(220, 206)
	Class2:SetPos(panel:GetWide() / 2 - 110, 30)
	Class2:SetImage("vgui/arc9_eft_shared/notification_icon_alert_red.png")

    local Class3 = vgui.Create("DImage", panel) -- Hunter
    Class3:SetSize(220, 206)
    Class3:SetPos(panel:GetWide() - 228, 30)
    Class3:SetImage("vgui/class3.png")

    local Select1 = vgui.Create("DButton", panel)
    Select1:SetPos(Class1:GetX(), Class1:GetY() + 270)
    Select1:SetSize(220, 20)
    Select1:SetText("Select")

    function Select1:DoClick()
        LocalPlayer().TClass = "Defoko"
        net.Start("SelectedTraitorClass")
        net.WriteString("Defoko")
        net.SendToServer()
        panel:Close()
    end

    local Select2 = vgui.Create("DButton", panel)
    Select2:SetPos(Class2:GetX(), Class2:GetY() + 270)
    Select2:SetSize(220, 20)
    Select2:SetText("Select")

    function Select2:DoClick()
        LocalPlayer().TClass = "Specter"
        net.Start("SelectedTraitorClass")
        net.WriteString("Specter")
        net.SendToServer()
        panel:Close()
    end

    local Select3 = vgui.Create("DButton", panel)
    Select3:SetPos(Class3:GetX(), Class3:GetY() + 270)
    Select3:SetSize(220, 20)
    Select3:SetText("Select")

    function Select3:DoClick()
        LocalPlayer().TClass = "Hunter"
        net.Start("SelectedTraitorClass")
        net.WriteString("Hunter")
        net.SendToServer()
        panel:Close()
    end

    local timeLeft = 3.50

    function panel:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        draw.SimpleText(string.format("Time left: %.2f", math.max(0, timeLeft)), "MersRadialSmall", 100, 17, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Defoko", "MersRadialSmall", Class1:GetX() + 110, Class1:GetY() + 230, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Specter", "MersRadialSmall", Class2:GetX() + 110, Class2:GetY() + 230, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Hunter", "MersRadialSmall", Class3:GetX() + 110, Class3:GetY() + 230, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

	timer.Create("ClassSelectionTimer", 0.01, 500, function()
	    timeLeft = timeLeft - 0.01
	    if timeLeft <= 0 then
	        if IsValid(panel) then
	            panel:Close()
				local RC = math.random(1,3)
					if RC == 1 then
						LocalPlayer().TClass = "Hunter"
						net.Start("SelectedTraitorClass")
						net.WriteString("Hunter")
						net.SendToServer()
					elseif RC == 2 then
						LocalPlayer().TClass = "Defoko"
						net.Start("SelectedTraitorClass")
						net.WriteString("Defoko")
						net.SendToServer()
					elseif RC == 3 then
						LocalPlayer().TClass = "Specter"
						net.Start("SelectedTraitorClass")
						net.WriteString("Specter")
						net.SendToServer()
					end
	        end
	        timer.Remove("ClassSelectionTimer")
	    end
	end)

    function panel:OnClose()
        if IsValid(background) then
            background:Remove()
        end
        timer.Remove("ClassSelectionTimer")
    end
end

net.Receive("ClassTraitor",function()
	OpenClass()
end)

hook.Add("PreCalcView","spectate",function(lply,pos,ang,fov,znear,zfar)
	lply = LocalPlayer()
	if lply:Alive() or GetViewEntity() ~= lply then return end

	view.fov = CameraSetFOV

	local spec = lply:GetNWEntity("HeSpectateOn")
	if not IsValid(spec) then
		view.origin = lply:EyePos()
		view.angles = ang

		return view
	end

	spec = IsValid(spec:GetNWEntity("Ragdoll")) and spec:GetNWEntity("Ragdoll") or spec

	local dir = Vector(1,0,0)
	dir:Rotate(ang)
	local tr = {}

	local head = spec:LookupBone("ValveBiped.Bip01_Head1")
	tr.start = head and spec:GetBonePosition(head) or spec:EyePos()
	tr.endpos = tr.start - dir * 75
	tr.filter = {lply,spec,lply:GetVehicle()}

	view.origin = util.TraceLine(tr).HitPos
	view.angles = ang

	return view
end)

SpectateHideNick = SpectateHideNick or false

local keyOld,keyOld2
local lply
flashlight = flashlight or nil
flashlightOn = flashlightOn or false

local gradient_d = Material("vgui/gradient-d")

hook.Add("HUDPaint","spectate",function()
	local lply = LocalPlayer()
	
	local spec = lply:GetNWEntity("HeSpectateOn")

	if lply:Alive() then
		if IsValid(flashlight) then
			flashlight:Remove()
			flashlight = nil
		end
	end

	local result = lply:PlayerClassEvent("CanUseSpectateHUD")
	if result == false then return end



	if
		(((not lply:Alive() or lply:Team() == 1002 or spec and lply:GetObserverMode() != OBS_MODE_NONE) or lply:GetMoveType() == MOVETYPE_NOCLIP)
		and not lply:InVehicle()) or result or hook.Run("CanUseSpectateHUD")
	then
		local ent = spec

		if IsValid(ent) then
			surface.SetFont("HomigradFont")
			local tw = surface.GetTextSize(ent:GetName())
			draw.SimpleText(ent:GetName(),"HomigradFont",ScrW() / 2 - tw / 2,ScrH() - 100,TEXT_ALING_CENTER,TEXT_ALING_CENTER)
			tw = surface.GetTextSize("Здоровье: " .. ent:Health())
			draw.SimpleText("Здоровье: " .. ent:Health(),"HomigradFont",ScrW() / 2 - tw / 2,ScrH() - 75,TEXT_ALING_CENTER,TEXT_ALING_CENTER)

			local func = TableRound().HUDPaint_Spectate
			if func then func(ent) end
		end

		local key = lply:KeyDown(IN_WALK)
		if keyOld ~= key and key then
			SpectateHideNick = not SpectateHideNick

			--chat.AddText("Ники игроков: " .. tostring(not SpectateHideNick))
		end
		keyOld = key

		draw.SimpleText("Отключение / Включение отображение ников на ALT","HomigradFont",15,ScrH() - 30,showRoundInfoColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)

		local key = input.IsButtonDown(KEY_F)
		if not lply:Alive() and keyOld2 ~= key and key then
			flashlightOn = not flashlightOn

			if flashlightOn then
				if not IsValid(flashlight) then
					flashlight = ProjectedTexture()
					flashlight:SetTexture("effects/flashlight001")
					flashlight:SetFarZ(900)
					flashlight:SetFOV(70)
					flashlight:SetEnableShadows( false )
				end
			else
				if IsValid(flashlight) then
					flashlight:Remove()
					flashlight = nil
				end
			end
		end
		keyOld2 = key

		if flashlight then
			flashlight:SetPos(EyePos())
			flashlight:SetAngles(EyeAngles())
			flashlight:Update()
		end

		if not SpectateHideNick then
			local func = TableRound().HUDPaint_ESP
			if func then func() end

			for _, v in ipairs(player.GetAll()) do --ESP
				if !v:Alive() or v == ent then continue end

				local ent = IsValid(v:GetNWEntity("Ragdoll")) and v:GetNWEntity("Ragdoll") or v
				local screenPosition = ent:GetPos():ToScreen()
				local x, y = screenPosition.x, screenPosition.y
				local teamColor = v:GetPlayerColor():ToColor()
				local distance = lply:GetPos():Distance(v:GetPos())
				local factor = 1 - math.Clamp(distance / 1024, 0, 1)
				local size = math.max(10, 32 * factor)
				local alpha = math.max(255 * factor, 80)

				local text = v:Name()
				surface.SetFont("Trebuchet18")
				local tw, th = surface.GetTextSize(text)

				surface.SetDrawColor(teamColor.r, teamColor.g, teamColor.b, alpha * 0.5)
				surface.SetMaterial(gradient_d)
				surface.DrawTexturedRect(x - size / 2 - tw / 2, y - th / 2, size + tw, th)

				surface.SetTextColor(255, 255, 255, alpha)
				surface.SetTextPos(x - tw / 2, y - th / 2)
				surface.DrawText(text)

				local barWidth = math.Clamp((v:Health() / 100) * (size + tw), 0, size + tw)
				local healthcolor = v:Health() / 100 * 255

				surface.SetDrawColor(255, healthcolor, healthcolor, alpha)
				surface.DrawRect(x - barWidth / 2, y + th / 1.5, barWidth, ScreenScale(1))
			end
		end
	end
end)

hook.Add("HUDDrawTargetID","no",function() return false end)

local laserweps = {
	["weapon_xm1014"] = true,
	["weapon_mp40"] = true,
	["weapon_m249"] = true,
	["weapon_fiveseven"] = true,
	["weapon_hk_usp"] = true,
	["weapon_mk18"] = true,
	["weapon_ar15"] = true,
	["weapon_m3super"] = true,
	["weapon_p220"] = true,
	["weapon_galil"] = true,
	["weapon_beanbag"] = true
}
laserplayers = laserplayers or {}
local mat = Material("sprites/bluelaser1")
local mat2 = Material("Sprites/light_glow02_add_noz")

hook.Add("HUDShouldDraw", "DisablePickupUI", function(name)
    if name == "PickupHistory" then return false end
end)

local function HasAtt(wep,attname)
	for i = 1,#wep.CurrentAtt do
		if wep.CurrentAtt[i].name == attname then
			return true
		elseif wep.CurrentAtt[i].name != attname and i == #wep.CurrentAtt then
			return false
		end
	end
end

local function OpenAttMenu()
    local ply = LocalPlayer()
    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) then return end
    if not weapon.PossibleAtt or not istable(weapon.PossibleAtt) then return end

    local panel = vgui.Create("DFrame")
    panel:SetSize(400, 400)
    panel:Center()
    panel:MakePopup()
    panel:SetTitle("Attachment Menu")
    panel:SetPos(panel:GetX() - 300, panel:GetY())
    function panel:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(150, 0, 0, 255))
    end

    local scroll = vgui.Create("DScrollPanel", panel)
    scroll:SetSize(400, 350)
    scroll:SetPos(0, 50)
    function scroll:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(100, 0, 0))
    end

    local buttonHeight = 30
    local spacing = 3
    local totalHeight = 10

    for key, data in pairs(weapon.PossibleAtt) do
        local ButtonAtt = vgui.Create("DButton", scroll)
        ButtonAtt:SetSize(scroll:GetWide() - 20, buttonHeight)
        ButtonAtt:SetPos(10, totalHeight)
        ButtonAtt:SetText("")
        local attname = string.upper(string.sub(data.name, 1, 1)) .. string.sub(data.name, 2)
        function ButtonAtt:DoClick()
			if weapon.CurrentAtt then
			local HasAtt = HasAtt(weapon,data.name)
				if not HasAtt then
            		ply:ConCommand("hg_attachmodule "..attname)
				else
					ply:ConCommand("hg_detachmodule "..attname)	
				end
			else
				ply:ConCommand("hg_attachmodule "..attname)
			end
        end

        function ButtonAtt:Paint(w, h)
            local bgColor = self:IsHovered() and Color(124, 0, 0, 220) or Color(71, 0, 0, 200)
            draw.RoundedBox(8, 0, 0, w, h, bgColor)
            
            local displayName = string.upper(string.sub(data.name, 1, 1)) .. string.sub(data.name, 2)
            draw.SimpleText(displayName or "Unknown", "DermaDefaultBold", 10, 10, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        end
        
        totalHeight = totalHeight + buttonHeight + spacing
    end

    scroll:GetCanvas():SetTall(totalHeight)
end


concommand.Add("hg_attmenu",function(ply,args)
	OpenAttMenu()
end)

hook.Add("PostDrawOpaqueRenderables", "laser", function()
	--local ply = (LocalPlayer():Alive() and LocalPlayer()) or (!LocalPlayer():Alive() and LocalPlayer():GetNWEntity("SpectateGuy"))
	--if !IsValid(ply) then return end
	for i,ply in pairs(laserplayers) do
		if not IsValid(ply) then laserplayers[i] = nil end
		ply.Laser = ply.Laser or false
		local actwep = (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass()) or (ply:GetNWString("curweapon")!=nil and ply:GetNWString("curweapon"))
		if IsValid(ply) and ply.Laser and !ply:GetNWInt("Otrub") and laserweps[IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() or ply.curweapon] then
			local wep = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon() or (IsValid(ply:GetNWEntity('wep')) and ply:GetNWEntity('wep'))
			if !IsValid(wep) then continue end
			
			local att = wep:GetAttachment(wep:LookupAttachment("muzzle"))
			
			if att==nil then continue end
			local pos = att.Pos
			local ang = att.Ang

			local t = {}

			t.start = pos+ang:Right()*2+ang:Forward()*-5+ang:Up()*-0.5
			
			t.endpos = t.start + ang:Forward()*9000
			
			t.filter = {ply,wep,LocalPlayer()}
			t.mask = MASK_SOLID
			local tr = util.TraceLine(t)

			local angle = (tr.StartPos - tr.HitPos):Angle()
			
			cam.Start3D(EyePos(),EyeAngles())

			render.SetMaterial(mat)
			render.DrawBeam(tr.StartPos, tr.HitPos, 1, 0, 15.5, Color(255, 0, 0))
			
			local Size = math.random(3,4)
			render.SetMaterial(mat2)
			local tra = util.TraceLine({
				start = tr.HitPos - (tr.HitPos - EyePos()):GetNormalized(),
				endpos = EyePos(),
				filter = {LocalPlayer(),ply,wep,ply:GetNWEntity("Ragdoll")},
				mask = MASK_SHOT
			})

			if not tra.Hit then
				render.DrawSprite(tr.HitPos, Size, Size,Color(255,0,0))
			end
			--render.DrawQuadEasy(tr.HitPos, (tr.StartPos - tr.HitPos):GetNormal(), Size, Size, Color(255,0,0), 0)

			cam.End3D()
		end
	end
end)

local function ToggleMenu(toggle)
    if toggle then
        local w,h = ScrW(), ScrH()
        if IsValid(wepMenu) then wepMenu:Remove() end
        local lply = LocalPlayer()
        local wep = lply:GetActiveWeapon()
        if !IsValid(wep) then return end
        wepMenu = vgui.Create("DMenu")
        wepMenu:SetPos(w/3,h/2)
        wepMenu:MakePopup()
        wepMenu:SetKeyboardInputEnabled(false)
		if wep:GetClass()!="weapon_hands" and wep:GetClass()!="weapon_handsinfected" then
			wepMenu:AddOption("Выкинуть",function()
				LocalPlayer():ConCommand("say *drop")
			end)
		end
        if wep:Clip1()>0 then
            wepMenu:AddOption("Разрядить",function()
                net.Start("Unload")
                net.WriteEntity(wep)
                net.SendToServer()
            end)
        end
		if laserweps[wep:GetClass()] then
        wepMenu:AddOption("Вкл/Выкл Лазер",function()
            if LocalPlayer().Laser then
				LocalPlayer().Laser = false
				net.Start("lasertgg")

				net.WriteBool(false)
				net.SendToServer()
				LocalPlayer():EmitSound("items/nvg_off.wav")
			else
				LocalPlayer().Laser = true
				net.Start("lasertgg")
				net.WriteBool(true)
				net.SendToServer()
				LocalPlayer():EmitSound("items/nvg_on.wav")
			end
        end)
		end

		plyMenu = vgui.Create("DMenu")
        plyMenu:SetPos(w/1.7,h/2)
        plyMenu:MakePopup()
        plyMenu:SetKeyboardInputEnabled(false)

		plyMenu:AddOption("Инвентарь",function()
            LocalPlayer():ConCommand("hg_inv")
        end)
		plyMenu:AddOption("Меню Патрон",function()
			LocalPlayer():ConCommand("hg_ammomenu")
		end)
		if LocalPlayer():GetActiveWeapon():GetHoldType() == "pistol" or LocalPlayer():GetActiveWeapon():GetHoldType() == "revolver" then
			if SERVER then return end
			if LocalPlayer():GetActiveWeapon().Base != "b3bros_base" then return end
			plyMenu:AddOption("Сменить Позу",function()
				LocalPlayer():ConCommand("hg_changepos")
			end)
		end
		local EZarmor = LocalPlayer().EZarmor
		if JMod.GetItemInSlot(EZarmor, "eyes") then
			plyMenu:AddOption("Активировать Маску/Забрало",function()
				LocalPlayer():ConCommand("jmod_ez_toggleeyes")
			end)
		end
    else
		if IsValid(wepMenu) then
        	wepMenu:Remove()
		end
		if IsValid(plyMenu) then
        	plyMenu:Remove()
		end
    end
end

local active,oldValue
hook.Add("Think","Thinkhuyhuy",function()
	active = input.IsKeyDown(KEY_C)
	if oldValue ~= active then
		oldValue = active
		
		if active then
			ToggleMenu(true)
		else
			ToggleMenu(false)
		end
	end
end)

net.Receive("lasertgg",function(len)
	local ply = net.ReadEntity()
	local boolen = net.ReadBool()
	if boolen then
		laserplayers[ply:EntIndex()] = ply
	else
		laserplayers[ply:EntIndex()] = nil
	end
	ply.Laser = boolen
end)

hook.Add("OnEntityCreated", "homigrad-colorragdolls", function(ent)
	if ent:IsRagdoll() then
		timer.Create("ragdollcolors-timer" .. tostring(ent), 0.1, 0, function()
			--ent.ply = ent.ply or RagdollOwner(ent)
			--local ply = ent.ply
			--if IsValid(ply) then
			if IsValid(ent) then
				ent.playerColor = ent:GetNWVector("plycolor")
				--print(ent.ply,ent.playerColor)
				ent.GetPlayerColor = function()
					return ent.playerColor
				end
				timer.Remove("ragdollcolors-timer" .. tostring(ent))
			end
		end)
	end
end)

hook.Add("Think", "SpecatorSpeedHandler", function()
    local ply = LocalPlayer()
    
    if not ply:Alive() and ply:GetMoveType() == MOVETYPE_NOCLIP then
        if input.IsKeyDown(KEY_LCONTROL) then
            net.Start("SetNoclipSpeed")
            net.WriteFloat(0.2)
            net.SendToServer()
		elseif input.IsKeyDown(KEY_LSHIFT) then
			net.Start("SetNoclipSpeed")
			net.WriteFloat(3)
			net.SendToServer()
		else
            net.Start("SetNoclipSpeed")
            net.WriteFloat(1)
            net.SendToServer()
        end
    end
end)


local function GetClipForCurrentWeapon( ply )
	if ( !IsValid( ply ) ) then return -1 end

	local wep = ply:GetActiveWeapon()
	if ( !IsValid( wep ) ) then return -1 end

	return wep:Clip1(), wep:GetMaxClip1(), ply:GetAmmoCount( wep:GetPrimaryAmmoType() )
end

hook.Add("HUDShouldDraw","HideHUD_ammo",function(name)
    if name == "CHudAmmo" then return false end
end)

local clipcolor = color_white
local clipcolorlow = Color(247, 178, 40, 255)
local clipcolorempty = Color(247, 40, 40, 255)
local colorgray = Color(200, 200, 200)
local shadow = color_black

--[[hook.Add("HUDPaint","homigrad-fancyammo",function()
	--[[local ply = LocalPlayer()
	local clip, maxclip, ammo = GetClipForCurrentWeapon(ply)
	local clipstring = tostring(clip)
	local sw, sh = ScrW(), ScrH()
	if clip != -1 and maxclip > 0 then
		if oldclip != clip then
			randomx = math.random(0, 10)
			randomy = math.random(0, 10)
			timer.Simple(0.15, function()
				oldclip = clip
			end)
		else
			randomx = 0
			randomy = 0
		end

		if clip == 0 then
			clipcolor = clipcolorempty
		elseif maxclip / clip >= 6 or clip == 1 and maxclip != 1 then
			clipcolor = clipcolorlow
		else
			clipcolor = color_white
		end

		draw.SimpleText("/ " .. ammo, "HomigradFontSmall", sw * 0.9 + 2 + #clipstring * sw * 0.02, sh * 0.97 + 2, shadow)
		draw.SimpleText("/ " .. ammo, "HomigradFontSmall", sw * 0.9 + #clipstring * sw * 0.02, sh * 0.97, colorgray)

		draw.SimpleText(clip, "HomigradFontLarge", sw * 0.89 + 5 + randomx, sh * 0.92 + 5 + randomy, shadow)
		draw.SimpleText(clip, "HomigradFontLarge", sw * 0.89 + randomx, sh * 0.92 + randomy, clipcolor)
	end
end)
]]
net.Receive("remove_jmod_effects",function(len)
	LocalPlayer().EZvisionBlur = 0
	LocalPlayer().EZflashbanged = 0
end)

local meta = FindMetaTable("Player")

function meta:HasGodMode() return self:GetNWBool("HasGodMode") end

concommand.Add("hg_getentity",function()
	local ent = LocalPlayer():GetEyeTrace().Entity
	print(ent)
	if not IsValid(ent) then return end
	print(ent:GetModel())
	print(ent:GetClass())
end)

gameevent.Listen("player_spawn")
hook.Add("player_spawn","gg",function(data)
	local ply = Player(data.userid)

	if ply.SetHull then
		ply:SetHull(ply:GetNWVector("HullMin"),ply:GetNWVector("Hull"))
		ply:SetHullDuck(ply:GetNWVector("HullMin"),ply:GetNWVector("HullDuck"))
	end

	hook.Run("Player Spawn",ply)
end)

hook.Add("DrawDeathNotice","no",function() return false end)

hook.Add("Think", "NeurotoxinMouseShake", function()
    local ply = LocalPlayer()

    if not IsValid(ply) then return end

    if ply:GetNWBool("neurotoxinshake", false) and not ply:GetNWBool("neurotoxinpripadok", false) and ply:Alive() then
		if ply:GetNWBool("fake") then
			shakeIntensity = 3--3 * ply:Health() / 80
		else
			shakeIntensity = 1--1.5 * ply:Health() / 99
		end
        local x = math.random(-shakeIntensity, shakeIntensity)
        local y = math.random(-shakeIntensity, shakeIntensity)

        local angles = ply:EyeAngles()
        angles.pitch = angles.pitch + y
        angles.yaw = angles.yaw + x

        ply:SetEyeAngles(angles)
    end
end)

hook.Add("Think", "Tremor", function()
    local ply = LocalPlayer()

    if not IsValid(ply) then return end

    if ply:GetNWBool("tremor", false) and ply:Alive() then
		if ply:GetNWBool("fake") then
			shakeIntensity = 5
		else
			shakeIntensity = 0.1
		end
        local x = math.random(-shakeIntensity, shakeIntensity)
        local y = math.random(-shakeIntensity, shakeIntensity)

        local angles = ply:EyeAngles()
        angles.pitch = angles.pitch + y
        angles.yaw = angles.yaw + x

        ply:SetEyeAngles(angles)
    end
end)

hook.Add("Think", "NeurotoxinMouseShakeMaximal", function()
    local ply = LocalPlayer()

    if not IsValid(ply) then return end

    if ply:GetNWBool("neurotoxinpripadok", false) and ply:Alive() then
		local shakeIntensitys = 20000
        local x = math.random(-shakeIntensitys, shakeIntensitys)
        local y = math.random(-shakeIntensitys, shakeIntensitys)

        local angles = ply:EyeAngles()
        angles.pitch = angles.pitch + y
        angles.yaw = angles.yaw + x

        ply:SetEyeAngles(angles)
    end
end)