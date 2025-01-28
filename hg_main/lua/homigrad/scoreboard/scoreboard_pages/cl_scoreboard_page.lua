local open = false
local panelka

local unmutedicon = Material( "icon32/unmuted.png", "noclamp smooth" )
local mutedicon = Material( "icon32/muted.png", "noclamp smooth" )

function CheckPlyStatus(ply)
    local AliveColor = Color(0,255,0,70)
    local DeadColor = Color(255,15,15,70)
    local SpecColor = Color(255,255,255,70)

    if ply == LocalPlayer() then
        return (ply:Alive() and AliveColor or DeadColor)
    end
    if ply:Team() == 1002 then
        return SpecColor
    end
    if LocalPlayer():Team() == 1002 or !LocalPlayer():Alive() then
        return (ply:Alive() and AliveColor or DeadColor)
    else
        return SpecColor
    end
end

hook.Add("HUDPaint","ScoreBoardPage",function()
    if not ScoreBoard then return end
    if not IsValid(ScoreBoardPanel) then open = false return end
    if ScoreBoard == 1 and not open then
        open = true
        local MainPanel = vgui.Create("DFrame", ScoreBoardPanel)
        MainPanel:SetSize(ScrW() / 1.5, ScrH() / 1.2)
        MainPanel:Center()
        MainPanel:SetDraggable(false)
        MainPanel:SetTitle(" ")
        MainPanel:ShowCloseButton(false)
        --MainPanel:SetPos(0, MainPanel:GetY()) --для фуллскрина,а нам надо по другому..

        function MainPanel:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        local ScrollablePlayerList = vgui.Create("DScrollPanel", MainPanel)
        ScrollablePlayerList:SetSize(MainPanel:GetWide(), MainPanel:GetTall())
        ScrollablePlayerList:Dock(FILL)

        for _, ply in ipairs(player.GetAll()) do
            local PlayerButton = vgui.Create("DButton", ScrollablePlayerList)
            PlayerButton:Dock(TOP)
            PlayerButton:DockMargin(0, 0, 0, 10)
            PlayerButton:SetText(" ")
            PlayerButton:SetTall(64)

            --local PlayerAvatar = vgui.Create("AvatarImage",PlayerButton)
            --PlayerAvatar:SetPlayer(ply,128)
            --PlayerAvatar:SetSize(60,60)
            --PlayerAvatar:SetPos(2,2)

            local StatusGradient = vgui.Create("DImage",PlayerButton)
            StatusGradient:SetPos(0,0)
            StatusGradient:SetSize(412,64)
            StatusGradient:SetImage("vgui/gradient-l")
            StatusGradient:SetImageColor(CheckPlyStatus(ply))

            local OtherGradient = vgui.Create("DImage",PlayerButton)
            OtherGradient:SetPos(PlayerButton:GetWide() * 14,0)
            OtherGradient:SetSize(412,64)
            OtherGradient:SetImage("vgui/gradient-r")
            OtherGradient:SetImageColor(Color(255,255,255,70))
        
            function PlayerButton:Paint(w, h)
                if !self:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(32, 32, 32,220))
                else
                    draw.RoundedBox(0, 0, 0, w, h, Color(38, 38, 38,220))
                end
            
                draw.SimpleText(ply:Name(), "H.18", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                surface.SetDrawColor(255,255,255,20)

                surface.DrawOutlinedRect(0,0,w,h,1)
            end
        
            function PlayerButton:DoRightClick()
                local DM = vgui.Create("DMenu")
                DM:AddOption("Скопировать STEAMID", function() SetClipboardText(ply:SteamID()) end)
                DM:SetPos(input.GetCursorPos())
                DM:MakePopup()
            
                DM:AddOption("Открыть профиль", function() ply:ShowProfile() end)
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