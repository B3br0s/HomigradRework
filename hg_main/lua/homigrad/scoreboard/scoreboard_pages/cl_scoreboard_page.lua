local open = false
local panelka

local unmutedicon = Material( "icon32/unmuted.png", "noclamp smooth" )
local mutedicon = Material( "icon32/muted.png", "noclamp smooth" )

function CheckPlyStatus(ply)
    local AliveColor = Color(0,255,0,20)
    local DeadColor = Color(255,15,15,20)
    local SpecColor = Color(179,179,179,20)

    if ply == LocalPlayer() then
        return (ply:Alive() and AliveColor or DeadColor),(ply:Alive() and "Живой" or "Мёртв")
    end
    if ply:Team() == 1002 then
        return SpecColor,"Наблюдает"
    end
    if LocalPlayer():Team() == 1002 or !LocalPlayer():Alive() then
        return (ply:Alive() and AliveColor or DeadColor),(ply:Alive() and "Живой" or "Мёртв")
    else
        return SpecColor,"Неизвестно"
    end
end

hook.Add("HUDPaint","ScoreBoardPage",function()
    if not ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false return end
    if ScoreBoard == 1 and not open then
        local MutedPlayers = (file.Exists("hgr/muted.json","DATA") and file.Read("hgr/muted.json","DATA") or {})
        if file.Exists("hgr/muted.json","DATA") then
            MutedPlayers = util.JSONToTable(file.Read("hgr/muted.json","DATA"))
        end
        open = true
        local MainPanel = vgui.Create("DFrame", ScoreBoardPanel)
        MainPanel:SetSize(ScrW() / 1.15, ScrH() / 1.05)
        MainPanel:Center()
        MainPanel:SetDraggable(false)
        MainPanel:SetTitle(" ")
        MainPanel:ShowCloseButton(false)
        --MainPanel:SetPos(0, MainPanel:GetY()) --для фуллскрина,а нам надо по другому..

        function MainPanel:Paint(w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        local ScrollablePlayerList = vgui.Create("DScrollPanel", MainPanel)
        ScrollablePlayerList:SetSize(MainPanel:GetWide(), MainPanel:GetTall())
        ScrollablePlayerList:Dock(FILL)

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
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        for _, ply in ipairs(player.GetAll()) do
            if not MutedPlayers[ply:SteamID()] and ply != LocalPlayer() then
                MutedPlayers[ply:SteamID()] = false
                file.Write("hgr/muted.json", util.TableToJSON(MutedPlayers))
            end
            local PlayerButton = vgui.Create("DButton", ScrollablePlayerList)
            PlayerButton:Dock(TOP)
            PlayerButton:DockMargin(90, 0, 0, 5)
            PlayerButton:SetText(" ")
            PlayerButton:SetTall(64)
            PlayerButton:SetWide(ScrollablePlayerList:GetWide() / 1.03)
            PlayerButton.Player = ply
            --PlayerButton:SetPos(0,68 * (_ - 1))

            local PlayerAvatar = vgui.Create("AvatarImage",ScrollablePlayerList)
            PlayerAvatar:SetPlayer(ply,64)
            PlayerAvatar:SetSize(62,62)
            PlayerAvatar:SetPos(20,70 * (_ - 1) + (_ == 1 and 1 or 0))

            local PlyColor,PlySText = CheckPlyStatus(ply)

            local DefaultSizeX,DefaultSizeY = 412,64

            local StatusGradient = vgui.Create("DImage",PlayerButton)
            StatusGradient:SetPos(0,0)
            StatusGradient:SetSize(412,64)
            StatusGradient:SetImage("vgui/gradient-l")
            StatusGradient:SetImageColor(PlyColor)

            local MuteButton = vgui.Create("DImageButton",PlayerButton)
            MuteButton:SetMaterial(MutedPlayers[ply:SteamID()] == true and mutedicon or unmutedicon)
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
        
            function PlayerButton:Paint(w, h)
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

                draw.RoundedBox(0, 0, 0, w, h, Color(self.CurColor,self.CurColor,self.CurColor))

                StatusGradient:SetSize(DefaultSizeX * 6,DefaultSizeY * self.CurSizeMul)
                self:SetSize(DefaultSizeX,DefaultSizeY * self.CurSizeMul)

                DefaultSizeX,DefaultSizeY = 64,64

                if ply != LocalPlayer() then
                self.MuteButton:SetSize(DefaultSizeX * self.CurSizeMul,DefaultSizeY * self.CurSizeMul)
                self.MuteButton:SetPos(w - 80 - self.CurPosMul / 1.9,0)

                self.MuteButton:SetMaterial(MutedPlayers[ply:SteamID()] == true and mutedicon or unmutedicon)
                end

                PlayerAvatar:SetSize(DefaultSizeX * self.CurSizeMul,DefaultSizeY * self.CurSizeMul)
                PlayerAvatar:SetPos(20 - self.CurPosMul,70 * (_ - 1) + (_ == 1 and 1 or 0))
                PlayerAvatar:SetY(self:GetY())
            
                draw.SimpleText(ply:Name(), "H.18", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                
                draw.SimpleText(PlySText, "H.18", w / 19, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                if Developers[self.Player:SteamID()] and not ply:GetNWBool("HideTag") then
                    local time = CurTime()
    
                    local r = math.abs(math.sin(time * 1.7)) * 200
                    local g = math.abs(math.sin(time * 1.7 + 2)) * 200
                    local b = math.abs(math.sin(time * 1.7 + 4)) * 200
                    
                    draw.SimpleText("Разработчик","HOS.25", w / 1.4, h / 2, Color(r,g,b,self.CurAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end

                surface.SetDrawColor(0,0,0,50)

                surface.DrawOutlinedRect(0,0,w,h,1)
            end
        
            function PlayerButton:DoRightClick()
                local DM = vgui.Create("DMenu")
                DM:AddOption("Скопировать STEAMID", function() if ply:IsBot() then chat.AddText(Color(255,0,0),"Невозможно скопировать STEAMID бота.") surface.PlaySound("homigrad/vgui/menu_invalid.wav") return end chat.AddText(Color(107,255,186),"SteamID был скопирован! ("..ply:SteamID()..")") SetClipboardText(ply:SteamID()) surface.PlaySound("homigrad/vgui/lobby_notification_chat.wav") end)
                DM:SetPos(input.GetCursorPos())
                DM:MakePopup()

                surface.PlaySound("homigrad/vgui/csgo_ui_page_scroll.wav")
            
                DM:AddOption("Открыть профиль", function() if ply:IsBot() then chat.AddText(Color(255,0,0),"Невозможно открыть профиль бота.") surface.PlaySound("homigrad/vgui/menu_invalid.wav") return end ply:ShowProfile() surface.PlaySound("homigrad/vgui/csgo_ui_crate_open.wav") end)
            end
        end

        panelka = MainPanel

    elseif ScoreBoard != 1 then
        open = false
        if IsValid(panelka) then
            panelka:Remove()
        end
    end
end)