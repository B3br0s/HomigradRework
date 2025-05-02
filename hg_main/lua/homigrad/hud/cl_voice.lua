hg.voicepanel = hg.voicepanel or nil

function CreateVoice(ply,istalking)
    if !IsValid(hg.voicepanel) or IsValid(hg.voicepanel[ply:SteamID()]) and istalking then
        return
    end
    local VoicePanel = hg.voicepanel:Add("DFrame")
    hg.voicepanel[ply:SteamID()] = VoicePanel
    VoicePanel:Dock(BOTTOM)
    VoicePanel:DockMargin(0,10,0,0)
    VoicePanel:SetWide(hg.voicepanel:GetWide())
    VoicePanel:SetHeight(35)
    VoicePanel:ShowCloseButton(false)
    VoicePanel:SetDraggable(false)
    VoicePanel:SetTitle(" ")
    VoicePanel.TalkAmt = (istalking and 0.1 or 1)

    local VoiceAvatar = VoicePanel:Add("AvatarImage")
    VoiceAvatar:SetPlayer(ply)
    VoiceAvatar:SetWide(VoicePanel:GetTall())
    VoiceAvatar:SetHeight(VoicePanel:GetTall())

    function VoicePanel:Paint(w,h)
        if !IsValid(ply) then
            self:Remove()
        end
        local clr_mul = ply:VoiceVolume() * (ply:Alive() and 1 or 0.2)

        self.TalkAmt = LerpFT(0.2,self.TalkAmt,(istalking and 1 or 0))

        if self.TalkAmt <= 0.1 then
            hg.voicepanel[ply:SteamID()] = nil
            self:Remove()
        end

        VoiceAvatar:SetAlpha(255 * self.TalkAmt)

        draw.RoundedBox(0,w - w / 1.18,0,w / 1.22,h,Color(110 + 255 * clr_mul,110 + 255 * clr_mul,110 + 255 * clr_mul,(200 + 230 * clr_mul) * self.TalkAmt))

        if TableRound and TableRound().TeamBased and ply:Alive() then
            if !ply:Team() == 1002 then
            local clr = TableRound().Teams[ply:Team()].Color
            surface.SetDrawColor(clr.r,clr.g,clr.b,100 * self.TalkAmt)
            surface.SetMaterial(Material("vgui/gradient-r"))
            surface.DrawTexturedRect(w-w/1.18,0,w/1.22,h)
            end
        end

        draw.SimpleText(ply:Name(),"HO.18",w/1.96,h/1.9,Color(0,0,0,255 * self.TalkAmt),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(ply:Name(),"HO.18",w/1.97,h/2,Color(255,255,255,255 * self.TalkAmt),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        /*surface.SetDrawColor(155,155,155,100 * self.TalkAmt)
        surface.DrawOutlinedRect(w - w / 1.18,-1,w/1.22-1,h,1)
        surface.SetDrawColor(155,155,155,200 * self.TalkAmt)
        surface.DrawOutlinedRect(w - w / 1.18,0,w/1.22,h,1)*/

        surface.SetDrawColor(155,155,155,200 * self.TalkAmt)
        surface.DrawOutlinedRect((w - w / 1.18),0.5,w/1.22,h - 1,1)
    end
end 

function CreateVoicePanels()
    if IsValid(hg.voicepanel) then
        hg.voicepanel:Remove()
    end

    hg.voicepanel = vgui.Create("DFrame")
    local voice = hg.voicepanel
    //voice:MakePopup()
    voice:SetWide(ScrW() / 7)
    voice:SetTall(ScrH() / 1.1)
    voice:SetPos(ScrW() / 1.2,50)
    voice:ShowCloseButton(false)
    voice:SetDraggable(false)
    voice:SetTitle(" ")

    function voice:Paint(w,h)
        //draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
    end
end

hook.Add("PlayerStartVoice", "HUD_Indicator", function(ply)
    //if ply == LocalPlayer() then return end
    CreateVoice(ply,true)
    return
end)

hook.Add("PlayerEndVoice", "HUD_Indicator", function(ply)
    if IsValid(hg.voicepanel[ply:SteamID()]) then
        hg.voicepanel[ply:SteamID()]:Remove()
        CreateVoice(ply,false)
    end
    return
end)

GM = GM or GAMEMODE

function GM:PlayerStartVoice()
    return
end

hook.Add("InitPostEntity","HUD_Voice",function()
    CreateVoicePanels()
end)