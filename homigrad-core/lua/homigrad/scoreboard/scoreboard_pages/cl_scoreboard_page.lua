local open = false
local panelka

local mute_death = false
local mute_all = false

local unmutedicon = Material( "icon32/unmuted.png", "noclamp smooth" )
local mutedicon = Material( "icon32/muted.png", "noclamp smooth" )

local ugc = {
    ["superadmin"] = Color(97,0,0),
    ["admin"] = Color(197, 50, 50),
    ["moderator"] = Color(175, 255, 156),
    ["helper"] = Color(163, 156, 255),
    ["operator"] = Color(21,255,0),
    ["setmodel"] = Color(0,225,255),
}

function CheckPlyStatus(ply)
    local AliveColor = Color(0,255,0,20)
    local DeadColor = Color(255,15,15,20)
    local SpecColor = Color(179,179,179,20)

    if ply:Team() == 1002 then
        return SpecColor,hg.GetPhrase("spectating")
    end

    if TableRound and TableRound().CanSeeAlive then
        return (ply:Alive() and AliveColor or DeadColor),(ply:Alive() and hg.GetPhrase("alive") or hg.GetPhrase("unalive"))
    end

    if ply == LocalPlayer() then
        return (ply:Alive() and AliveColor or DeadColor),(ply:Alive() and hg.GetPhrase("alive") or hg.GetPhrase("unalive"))
    end
    if LocalPlayer():Team() == 1002 or !LocalPlayer():Alive() then
        return (ply:Alive() and AliveColor or DeadColor),(ply:Alive() and hg.GetPhrase("alive") or hg.GetPhrase("unalive"))
    else
        return SpecColor,hg.GetPhrase("unknown")
    end
end

function CheckPlyTeam(ply)
    if ply:Team() == 1002 then
        return Color(200,200,200,255),hg.GetPhrase("spectator")
    end
    if TableRound and TableRound().GetTeamName then
        local name,clr,desc = TableRound().GetTeamName(ply)

        //print(clr,name,ply)

        return clr,name
    end
    if TableRound and TableRound().TeamBased then

        if !TableRound().Teams[ply:Team()] then
            return Color(255,0,0),"N/A"
        end

        local clr,name = TableRound().Teams[ply:Team()].Color,TableRound().Teams[ply:Team()].Name
        
        return clr,name
    elseif TableRound and !TableRound().TeamBased then
        return TableRound().Teams[1].Color,TableRound().Teams[1].Name
    end
end

hook.Add("Think","Mute-Handler",function() //ода доза
    local MutedPlayers = (file.Exists("hgr/muted.json","DATA") and file.Read("hgr/muted.json","DATA") or {})
        if file.Exists("hgr/muted.json","DATA") then
            MutedPlayers = util.JSONToTable(file.Read("hgr/muted.json","DATA"))
        end

        for _, ply in ipairs(player.GetAll()) do
            if mute_death then
                continue 
            end
            if MutedPlayers[ply:SteamID()] == true then
                continue 
            end

            ply:SetMuted(mute_all)
        end

        for _, ply in ipairs(player.GetAll()) do
            if mute_all then
                continue 
            end
            if MutedPlayers[ply:SteamID()] == true then
                continue 
            end
            if LocalPlayer():Alive() and LocalPlayer():Team() != 1002 then
                if ply:IsMuted() then
                    ply:SetMuted(false)
                end
                continue 
            end
            if !mute_death then
                ply:SetMuted(false)
                continue 
            end
            if ply:Alive() then
                ply:SetMuted(false)
                continue 
            end
            if ply == LocalPlayer() then
                continue 
            end
            ply:SetMuted(!ply:Alive())
        end
end)

hook.Add("HUDPaint","ScoreBoardPage",function()
    if not hg.ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false return end
    if hg.ScoreBoard == 1 and not open then
        local MutedPlayers = (file.Exists("hgr/muted.json","DATA") and file.Read("hgr/muted.json","DATA") or {})
        if file.Exists("hgr/muted.json","DATA") then
            MutedPlayers = util.JSONToTable(file.Read("hgr/muted.json","DATA"))
        end
        open = true
        local MainPanel = vgui.Create("DFrame", ScoreBoardPanel)
        MainPanel:SetSize(ScrW(), ScrH() / 1.15)
        MainPanel:Center()
        MainPanel:SetDraggable(false)
        MainPanel:SetTitle(" ")
        //MainPanel:SetMouseInputEnabled(false)
        MainPanel:ShowCloseButton(false)

        function MainPanel:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        local ScrollShit = vgui.Create("hg_frame",MainPanel)
        ScrollShit:SetSize(ScrW() / 1.3,ScrH() / 1.3)
        ScrollShit:Center()
        ScrollShit:SetDraggable(false)
        ScrollShit:SetTitle(" ")
        ScrollShit:ShowCloseButton(false)
        //ScrollShit:SetMouseInputEnabled(true)
        ScrollShit.tps = Color(0,255,0)
        ScrollShit.DefaultClr = Color(22,22,22,200)

        local function CheckTPSCock(tps)
            if tps < 15 then
                return Color(146,0,0)
            elseif tps < 25 then
                return Color(255,0,0,255)
            elseif tps < 35 then
                return Color(255,94,0)
            elseif tps < 40 then
                return Color(255,187,0)
            elseif tps < 60 then
                return Color(179,255,0)
            else
                return Color(0,255,0)
            end
        end

        function ScrollShit:SubPaint(w, h)
            local tps = math.Round(1 / engine.ServerFrameTime())

            ScrollShit.tps:Lerp(CheckTPSCock(tps),0.1)

            //draw.RoundedBox(0, 0, 0, w, h, Color(22, 22, 22, 200))

            draw.SimpleText(hg.GetPhrase("sc_status"), "HS.18", w - w / 1.16, h - h / 1.02, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(hg.GetPhrase("sc_ug"), "HS.18", w - w / 1.4, h - h / 1.02, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(hg.GetPhrase("sc_team"), "HS.18", w - w / 5.5, h - h / 1.02, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            surface.SetFont("HS.18")
            local size = surface.GetTextSize(tostring(string.format(hg.GetPhrase("sc_curround"),(TableRound and TableRound().name or "N/A"))))
            local size2 = surface.GetTextSize(tostring(string.format(hg.GetPhrase("sc_tps"),tps)))

            draw.SimpleText(string.format(hg.GetPhrase("sc_curround"),TableRound().name), "HS.18", w - w / 1.01, h - 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)          
            draw.SimpleText(string.format(hg.GetPhrase("sc_nextround"),TableRound(ROUND_NEXT).name), "HS.18", w - w / 1.01 + size * 1.1, h - 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            
            draw.SimpleText(string.format(hg.GetPhrase("sc_tps"),tps), "HS.18", w - size2 * 1.5, h - 20,ScrollShit.tps , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            
            /*surface.SetDrawColor(100,100,100,75)
            surface.DrawOutlinedRect(1,1,w,h,1)
            surface.DrawOutlinedRect(-1,-1,w,h,1)
            surface.SetDrawColor(100,100,100,5)
            surface.DrawOutlinedRect(2,2,w,h,1)
            surface.DrawOutlinedRect(-2,-2,w,h,1)*/
        end

        local ww,hh = ScrollShit:GetSize()

        local delitel = 6.5

        local MuteDead = vgui.Create("hg_button",ScrollShit)
        MuteDead:SetSize(ww/delitel,hh/20)
        MuteDead:SetText(" ")
        MuteDead:Center()
        MuteDead:SetY(hh/1.06)
        MuteDead:SetX(MuteDead:GetX()-ww/11)
        function MuteDead:SubPaint(w,h)
            draw.SimpleText(hg.GetPhrase("sc_mutedead"),"HS.18",w/2,h/2,!mute_death and Color(0,255,0) or Color(255,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        function MuteDead:DoClick()
            mute_death = not mute_death
            if !mute_death then
                surface.PlaySound("homigrad/vgui/panorama/ping_alert_01.wav")
            else
                surface.PlaySound("homigrad/vgui/panorama/ping_alert_negative.wav")
            end
        end

        local MuteAll = vgui.Create("hg_button",ScrollShit)
        MuteAll:SetSize(ww/delitel,hh/20)
        MuteAll:SetText(" ")
        MuteAll:Center()
        MuteAll:SetY(hh/1.06)
        MuteAll:SetX(MuteAll:GetX()+ww/11)
        function MuteAll:SubPaint(w,h)
            draw.SimpleText(hg.GetPhrase("sc_muteall"),"HS.18",w/2,h/2,!mute_all and Color(0,255,0) or Color(255,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        function MuteAll:DoClick()
            mute_all = not mute_all
            if !mute_all then
                surface.PlaySound("homigrad/vgui/panorama/ping_alert_01.wav")
            else
                surface.PlaySound("homigrad/vgui/panorama/ping_alert_negative.wav")
            end
        end

        local ScrollablePlayerList = vgui.Create("DScrollPanel", ScrollShit)
        ScrollablePlayerList:SetSize(ScrollShit:GetWide() / 1.05,ScrollShit:GetTall() / 1.2)
        ScrollablePlayerList:Center()
        ScrollablePlayerList:SetY(ScrollablePlayerList:GetY()-35)

        local sbar = ScrollablePlayerList:GetVBar()
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
        
        function ScrollablePlayerList:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        local function SortPlayers(a, b)
            if !LocalPlayer():Alive() or LocalPlayer():Team() == 1002 then
                if not a:Alive() and b:Alive() then return false end
                if a:Alive() and not b:Alive() then return true end
            end
            
            if a:Team() == 1 and b:Team() != 1 then return false end
            if a:Team() != 1 and b:Team() == 1 then return true end
            
            return a:Name() < b:Name()
        end
        
        local players = player.GetAll()
        table.sort(players, SortPlayers)

        for _, ply in ipairs(players) do
            if not MutedPlayers[ply:SteamID()] and ply != LocalPlayer() then
                MutedPlayers[ply:SteamID()] = false
                file.Write("hgr/muted.json", util.TableToJSON(MutedPlayers))
            end
            local PlayerButton = vgui.Create("hg_button", ScrollablePlayerList)
            PlayerButton:Dock(TOP)
            PlayerButton:DockMargin(90, 0, 0, 5)
            PlayerButton:SetText(" ")
            PlayerButton:SetTall(64)
            PlayerButton:SetWide(ScrollablePlayerList:GetWide() / 1.03)
            PlayerButton.Player = ply
            PlayerButton.NoDrawDefault = true
            --PlayerButton:SetPos(0,68 * (_ - 1))

            local PlayerAvatar = vgui.Create("AvatarImage",ScrollablePlayerList)
            PlayerAvatar:SetPlayer(ply,64)
            PlayerAvatar:SetSize(62,62)
            PlayerAvatar:SetPos(20,70 * (_ - 1) + (_ == 1 and 1 or 0))

            local PlyColor,PlySText = CheckPlyStatus(ply)
            local TeamColor,TeamSText = CheckPlyTeam(ply)

            PlyColor.a = 50

            local DefaultSizeX,DefaultSizeY = 412,64

            local MuteButton = vgui.Create("DImageButton",PlayerButton)
            MuteButton:SetMaterial(ply:IsMuted() and mutedicon or unmutedicon)
            MuteButton:SetSize(64,64)
            MuteButton:SetPos(PlayerButton:GetWide() - 128,PlayerButton:GetY())

            function MuteButton:DoClick()
                local steamID = ply:SteamID()
                if MutedPlayers[steamID] then
                    MutedPlayers[steamID] = false
                    surface.PlaySound("homigrad/vgui/panorama/ping_alert_negative.wav")
                else
                    MutedPlayers[steamID] = true
                    surface.PlaySound("homigrad/vgui/panorama/ping_alert_01.wav")
                end
                ply:SetMuted(MutedPlayers[steamID])
                file.Write("hgr/muted.json", util.TableToJSON(MutedPlayers))
            end

            PlayerButton.MuteButton = MuteButton

            if ply == LocalPlayer() then MuteButton:Remove() end
        
            function PlayerButton:SubPaint(w, h)
                if not self.CurSizeMul then
                    self.CurSizeMul = 1
                    self.CurPosMul = 0
                    self.WasHovered = false
                    self.CurColor = 24
                    self.CurAlpha = 0
                end
                if !self:IsHovered() then
                    self.CurSizeMul = LerpFT(0.1,self.CurSizeMul,1)
                    self.CurPosMul = LerpFT(0.1,self.CurPosMul,0)
                    self.CurColor = LerpFT(0.2,self.CurColor,24)
                    self.CurAlpha = LerpFT(0.15,self.CurAlpha,0)
                    self.WasHovered = false
                else
                    self.CurSizeMul = LerpFT(0.1,self.CurSizeMul,1.2)
                    self.CurPosMul = LerpFT(0.1,self.CurPosMul,15)
                    self.CurColor = LerpFT(0.2,self.CurColor,32)
                    self.CurAlpha = LerpFT(0.05,self.CurAlpha,255)
                    if !self.WasHovered then
                        self.WasHovered = true
                        surface.PlaySound("homigrad/vgui/csgo_ui_contract_type2.wav")
                    end
                end

                self.DefaultColor = Color(self.CurColor,self.CurColor,self.CurColor)

                //draw.RoundedBox(0, 0, 0, w, h, Color(self.CurColor,self.CurColor,self.CurColor))

                surface.SetDrawColor(PlyColor.r,PlyColor.g,PlyColor.b,25)
                surface.SetMaterial(Material("vgui/gradient-l"))
                surface.DrawTexturedRect(0,0,DefaultSizeX * 2 * (self.CurSizeMul * 2),DefaultSizeY * self.CurSizeMul)

                if !TeamColor then
                    TeamColor = Color(0,0,0)
                end

                surface.SetDrawColor(TeamColor.r,TeamColor.g,TeamColor.b,75)
                surface.SetMaterial(Material("vgui/gradient-r"))
                surface.DrawTexturedRect(w-DefaultSizeX * 3 * (self.CurSizeMul * 2),0,DefaultSizeX * 3 * (self.CurSizeMul * 2),DefaultSizeY * self.CurSizeMul)

                self:SetSize(DefaultSizeX,DefaultSizeY * self.CurSizeMul)

                DefaultSizeX,DefaultSizeY = 64,64

                if ply != LocalPlayer() then
                self.MuteButton:SetSize(DefaultSizeX * self.CurSizeMul,DefaultSizeY * self.CurSizeMul)
                self.MuteButton:SetPos(w - 80 - self.CurPosMul / 1.9,0)

                self.MuteButton:SetMaterial(ply:IsMuted() and mutedicon or unmutedicon)
                end

                PlayerAvatar:SetSize(DefaultSizeX * self.CurSizeMul,DefaultSizeY * self.CurSizeMul)
                PlayerAvatar:SetPos(20 - self.CurPosMul,70 * (_ - 1) + (_ == 1 and 1 or 0))
                PlayerAvatar:SetY(self:GetY())
            
                draw.SimpleText(ply:Name(), "H.18", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                TeamColor.a = 255
                
                draw.SimpleText(PlySText, "H.18", w / 19, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                if ply:GetUserGroup() != "user" then
                    draw.SimpleText(ply:GetUserGroup(), "H.18", w / 4.45, h / 2, ugc[ply:GetUserGroup()] or Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
                draw.SimpleText(hg.GetPhrase(TeamSText), "H.18", w / 1.2, h / 2, TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                /*if Developers[self.Player:SteamID()] and not ply:GetNWBool("HideTag") then
                    local time = CurTime()
    
                    local r = math.abs(math.sin(time * 1.7)) * 200
                    local g = math.abs(math.sin(time * 1.7 + 2)) * 200
                    local b = math.abs(math.sin(time * 1.7 + 4)) * 200
                    
                    draw.SimpleText("Разработчик","HOS.25", w / 1.4, h / 2, Color(r,g,b,self.CurAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end*/
            end
        
            function PlayerButton:DoRightClick()
                local DM = vgui.Create("DMenu")
                DM:AddOption(hg.GetPhrase("sc_copysteam"),function()
                if ply:IsBot() then chat.AddText(Color(255,0,0),hg.GetPhrase("sc_unable_steamid")) surface.PlaySound("homigrad/vgui/menu_invalid.wav") return end
                chat.AddText(Color(107,255,186),string.format(hg.GetPhrase("sc_success_copy"),ply:SteamID()))
                SetClipboardText(ply:SteamID())
                surface.PlaySound("homigrad/vgui/lobby_notification_chat.wav")
                end)
                DM:SetPos(input.GetCursorPos())
                DM:MakePopup()

                surface.PlaySound("homigrad/vgui/csgo_ui_page_scroll.wav")
            
                DM:AddOption(hg.GetPhrase("sc_openprofile"), function()
                if ply:IsBot() then
                chat.AddText(Color(255,0,0),hg.GetPhrase("sc_unable_prof")) surface.PlaySound("homigrad/vgui/menu_invalid.wav") return end
                ply:ShowProfile()
                surface.PlaySound("homigrad/vgui/csgo_ui_crate_open.wav")
                end)
            end
        end

        panelka = MainPanel

    elseif hg.ScoreBoard != 1 then
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
    end
end)