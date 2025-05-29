zs = zs or {}

zs.wave = zs.wave or 0

function zs.GetTeam(ply)
    if ply:Team() == 1002 then
        return hg.GetPhrase("spectator"),Color(200,200,200,255),"nothing."
    end
    local tbl = zs.Teams[ply:Team()]

    local n = tbl.Name
    local c = tbl.Color
    local d = tbl.Desc
    return n,c,d
end
local posadd = 0

local gradient_d = Material("vgui/gradient-d")

net.Receive("zs wave",function()
    zs.wave = net.ReadFloat()
end)

local soundplayed = false
local soundplayed2 = false
local soundplayed3 = false
local sw,sh = ScrW(),ScrH()

function zs.HUDPaint()
    if !hg.ROUND_START then
        hg.ROUND_START = CurTime()
    end

    local StartTime = ((hg.ROUND_START + 7) - CurTime())
    local time = GetGlobalFloat("zs_wavein")
    local time2 = GetGlobalFloat("zs_waveendin")

    if LocalPlayer():Team() == 1 and LocalPlayer():Alive() then
        draw.SimpleText( string.format(hg.GetPhrase("zs_peopleleft"),team.GetCountLive(team.GetPlayers(2))) , "hg_HomicideMedium", sw * 0.02, sh * 0.9, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        zs.zombie_vision()
    end

    if time - CurTime() > 0 then
        draw.SimpleText( string.format(hg.GetPhrase("zs_wavein"),string.FormattedTime(time - CurTime(), "%02i:%02i")) , "hg_HomicideMedium", sw * 0.02, sh * 0.95, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if LocalPlayer():Team() == 2 and LocalPlayer():Alive() then
            draw.SimpleText( hg.GetPhrase("zs_buymenu_open") , "hg_HomicideMedium", sw / 2, sh * 0.95, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        soundplayed2 = false
    else
        if ZS_BUY_OPEN then
            Open_Zshoppa()
        end
        if !soundplayed2 then
            soundplayed2 = true
            surface.PlaySound("ambient/creatures/town_zombie_call1.wav")
        end
        draw.SimpleText( string.format(hg.GetPhrase("zs_waveendin"),string.FormattedTime(time2 - CurTime(), "%02i:%02i")) , "hg_HomicideMedium", sw * 0.02, sh * 0.95, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    draw.DrawText(zs.wave,"hg_HomicideMediumLarge",sw-sw/1.07,sh-sh/1.07,soundplayed2 and Color(255,0,0) or Color(0,255,0),TEXT_ALIGN_LEFT)

    if StartTime < 0 then
        return
    end

    if !soundplayed then
        soundplayed = true
        surface.PlaySound("snd_jack_hmcd_zombies.mp3")
    end

    local DarkMul = math.Clamp(StartTime,0,1)

    local Name,color,Desc = zs.GetTeam(LocalPlayer())

    color.a = (255 * DarkMul)

    local PrintName = hg.GetPhrase(Name)

    local w,h = ScrW(),ScrH()

    surface.SetDrawColor(0,0,0,220 * DarkMul)
    surface.DrawRect(0,0,w,h)

    draw.DrawText(string.format(hg.GetPhrase("you_are"),PrintName),"H.25",w / 2,h / 2,color,TEXT_ALIGN_CENTER)
    draw.DrawText(zs.name,"H.45",w / 2,h / 8,Color(255,0,0,255 * DarkMul),TEXT_ALIGN_CENTER)
    draw.DrawText(hg.GetPhrase(Desc),"H.25",w / 2,h / 1.2,color,TEXT_ALIGN_CENTER)
end

function zs.zombie_vision()
    local tab = {
    	[ "$pp_colour_addr" ] = 0.1,
    	[ "$pp_colour_addg" ] = 0,
    	[ "$pp_colour_addb" ] = 0,
    	[ "$pp_colour_brightness" ] = -0.1,
    	[ "$pp_colour_contrast" ] = 1,
    	[ "$pp_colour_colour" ] = 1,
    	[ "$pp_colour_mulr" ] = 0,
    	[ "$pp_colour_mulg" ] = 0,
    	[ "$pp_colour_mulb" ] = 0
    }
    DrawColorModify(tab)
    cam.Start3D()
    local mat = Material("hlmv/debugmrmfullbright2")
	for _, ply in ipairs(team.GetPlayers(2)) do
		if !ply:Alive() then
			render.DepthRange(0, 1)
    		render.SetColorModulation(1, 1, 1)
    		render.SuppressEngineLighting(false)
    		render.MaterialOverride(nil)
			continue 
		end
        local ent = hg.GetCurrentCharacter(ply)
        if !IsValid(ent) then
            render.DepthRange(0, 1)
    		render.SetColorModulation(1, 1, 1)
    		render.SuppressEngineLighting(false)
    		render.MaterialOverride(nil)
            continue 
        end
		render.MaterialOverride(mat)
        render.SuppressEngineLighting(true)
		local hp = Color(255 * (1 - (ply:Health() / ply:GetMaxHealth())),255 * (ply:Health() / ply:GetMaxHealth()),0)
        render.SetColorModulation(hp.r/255,hp.g/255,hp.b/255)
		//halo.Add({ent},hp,1,1,1,true,true)

        render.DepthRange(0, 0)
        ent:DrawModel()
    end
	
	render.DepthRange(0, 1)
    render.SetColorModulation(1, 1, 1)
    render.SuppressEngineLighting(false)
    render.MaterialOverride(nil)
    cam.End3D()
end

function zs.RenderScreenspaceEffects()
end

function zs.RoundStart()
    hg.ROUND_START = CurTime()
    soundplayed = false
    soundplayed2 = false
    soundplayed3 = false
    zs.wave = 0
end

ZS_BUY_OPEN = ZS_BUY_OPEN or false 

ZS_MENU = ZS_MENU or nil

function Open_Zshoppa()
    ZS_BUY_OPEN = not ZS_BUY_OPEN
    if IsValid(ZS_MENU) and !ZS_BUY_OPEN then
        ZS_MENU:Remove()
        ZS_MENU = nil
        return
    end

    local vklad = 1

    /*
    Нулевой тир - Патроны
    Первый тир - Начальные пушки
    Второй тир - Средние пушки
    Третий тир - Дробовики + хорошие пушки
    Четвёртвый тир - имба
    */

    local weps = {
        [1] = {
            ["type"] = "ammo",
            ["name"] = "Ammunition",
            ["ent_ammo_5.56x45mm"] = 35,
            ["ent_ammo_7.62x39mm"] = 45,
            ["ent_ammo_7.62x51mm"] = 50,
            ["ent_ammo_12/70gauge"] = 50,
            ["ent_ammo_12/70beanbag"] = 30,
            ["ent_ammo_9x19mmparabellum"] = 20,
            ["ent_ammo_.44magnum"] = 125,
            ["ent_ammo_.50actionexpress"] = 75,
            ["ent_ammo_4.6x30mmnato"] = 45,
            ["ent_ammo_5.7x28mm"] = 50,
            ["ent_ammo_rpg7proj"] = 300,
            ["ent_ammo_nails"] = 5,
            ["ent_ammo_.30win"] = 45,
        },

        [2] = {
            ["type"] = "weps",
            ["name"] = "Medicine",
            ["weapon_medkit_hg"] = 60,
            ["weapon_adrenaline"] = 150,
            ["weapon_bandage"] = 30,
            ["weapon_painkillers_hg"] = 20
        },

        [3] = {
            ["type"] = "weps",
            ["name"] = "Tier-1",
            ["weapon_hammer"] = 10,    
            ["weapon_glock17"] = 50,  
            ["weapon_fiveseven"] = 60,
            ["weapon_tec9"] = 50,     
            ["weapon_usp_match"] = 60,
            ["weapon_fubar"] = 90,    
        },

        [4] = {
            ["type"] = "weps",
            ["name"] = "Tier-2",
            ["weapon_329pd"] = 200,       
            ["weapon_doublebarrel"] = 230,
            ["weapon_ar15"] = 230,        
            ["weapon_m4a1"] = 270,        
            ["weapon_kar98k"] = 200,        
            ["weapon_w1894"] = 250,        
            ["weapon_870_b"] = 260,       
        },

        [5] = {
            ["type"] = "weps",
            ["name"] = "Tier-3",
            ["weapon_sawnoff"] = 280, 
            ["weapon_mp7"] = 260,     
            ["weapon_mp5"] = 180,     
            ["weapon_deagle_b"] = 250,
            ["weapon_deagle_a"] = 270,
            ["weapon_rpk"] = 300,     
            ["weapon_m16a1"] = 250,   
        },

        [6] = {
            ["type"] = "weps",
            ["name"] = "Tier-4",
            ["weapon_rpg7"] = 900,
            ["weapon_deagle_golden"] = 1250
        }
    }

    ZS_MENU = vgui.Create("hg_frame")
    local p = ZS_MENU
    p:SetSize(ScrW()/3,ScrH()/2)
    p:MakePopup()
    p:Center()
    p:SetDraggable(false)
    p:ShowCloseButton(false)
    p:SetKeyboardInputEnabled(false)
    p:SetTitle(" ")

    local vkladki = {
    }

    local f_vk = vgui.Create("hg_frame",p)
    f_vk:SetTall(p:GetTall()/9)
    f_vk:SetWide(p:GetWide())
    f_vk:SetY(f_vk:GetY() + f_vk:GetTall()/3)

    for i = 1, #weps do
        local buto = vgui.Create("hg_button",f_vk)
        buto:SetText(" ")
        buto:SetSize(f_vk:GetWide()/#weps,f_vk:GetTall())
        buto:SetX(buto:GetWide() * (i - 1))

        local hov = false

        function buto:SubPaint(w,h)
            if self:IsHovered() and !hov then
                hov = true
                surface.PlaySound("homigrad/vgui/csgo_ui_contract_type2.wav")
            elseif !self:IsHovered() then
                hov = false
            end

            draw.SimpleText(weps[i].name,"HS.18",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        function buto:DoClick()
            vklad = i

            surface.PlaySound("homigrad/vgui/csgo_ui_store_rollover.wav")
        end

        local scr = vgui.Create("DScrollPanel",p)
        scr:SetSize(p:GetWide(),p:GetTall() / 1.4)
        scr:Center()
        scr:SetY(scr:GetY() + (p:GetTall() - p:GetTall() / 1.01))
        local sbar = scr:GetVBar()
        sbar:SetSize(0,0)
        function sbar:Paint(w, h)
        	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end
        function sbar.btnUp:Paint(w, h)
        	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end
        function sbar.btnDown:Paint(w, h)
        	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end
        function sbar.btnGrip:Paint(w, h)
        	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        vkladki[i] = scr

        for wep, cost in pairs(weps[i]) do
            if wep == "type" or wep == "name" then
                continue 
            end
            local v = scr:Add("hg_button")
            v:Dock(TOP)
            v:DockMargin(0,10,0,0)
            v:SetTall(scr:GetTall()/12)
            v:SetText(" ")

            local hov = false

            function v:DoClick()

                if LocalPlayer():GetNWInt("ZS_POINTS") >= cost then
                    surface.PlaySound("homigrad/vgui/panorama/case_unlock_immediate_01.wav")
                    net.Start("zs buy")
                    net.WriteString(wep)
                    net.WriteString(weps[i].type)
                    net.SendToServer()
                else
                    surface.PlaySound("homigrad/vgui/weapon_cant_buy.wav")
                end
            end

            function v:SubPaint(w,h)
                if self:IsHovered() and !hov then
                    hov = true
                    surface.PlaySound("homigrad/vgui/csgo_ui_contract_type2.wav")
                elseif !self:IsHovered() then
                    hov = false
                end

                if weapons.Get(wep) then
                    surface.SetFont("HS.18")
                    local sizex = surface.GetTextSize(weapons.Get(wep).PrintName)
                    draw.SimpleText(weapons.Get(wep).PrintName,"HS.18",20,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                    draw.SimpleText(((weapons.Get(wep).Primary.Ammo != "none") and weapons.Get(wep).Primary.Ammo or (weapons.Get(wep).Secondary.Ammo != "none" and weapons.Get(wep).Secondary.Ammo or " ")),"HS.12",25 + sizex,h/2,Color(255,255,255,101),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                elseif scripted_ents.Get(wep) then
                    draw.SimpleText(scripted_ents.Get(wep).PrintName,"HS.18",20,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                end
                draw.SimpleText(cost.."$","HS.18",w/1.02,h/2,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
            end
        end
    end

    function p:SubPaint(w,h)
        for n, a in pairs(vkladki) do
            if vklad == n then
                a:Show()
            else
                a:Hide()
            end
        end

        draw.SimpleText(hg.GetPhrase("r_close"),"HS.18",w/2,h/1.05,Color(255,255,255,25),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(LocalPlayer():GetNWInt("ZS_POINTS",0).."$","HS.18",w/1.05,10,Color(0,175,0),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)

        if input.IsKeyDown(KEY_R) then
            self:OnClose()
        end
    end

    function p:OnClose()
        if IsValid(ZS_MENU) then
            ZS_MENU:Remove()
        end
        ZS_MENU = nil
        ZS_BUY_OPEN = false
    end
end

concommand.Add("zs_buy",function()
    Open_Zshoppa()
end)

net.Receive("zs_buymenu",function()
    Open_Zshoppa()
end)