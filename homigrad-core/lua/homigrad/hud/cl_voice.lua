hg.voicepanel = hg.voicepanel or nil

function CreateVoice(ply,istalking)
    if !IsValid(hg.voicepanel) or IsValid(hg.voicepanel[ply:SteamID()]) and istalking then
        return
    end
    local VoicePanel = hg.voicepanel:Add("hg_frame")
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

    VoicePanel.ZalupaAvatar = VoiceAvatar

    function VoiceAvatar:Paint(w, h)
        if !IsValid(ply) or !ply.SteamID then
            self:Remove()
            return
        end
    end

    function VoicePanel:SubPaint(w,h)
        if !IsValid(ply) or !ply.SteamID then
            self:Remove()
        end

        self.ZalupaAvatar = VoiceAvatar

        local clr_mul = ply:VoiceVolume() * (ply:Alive() and 1 or 0.2)

        self.TalkAmt = LerpFT(0.2,self.TalkAmt,(istalking and 1 or 0))

        if self.TalkAmt <= 0.1 then
            hg.voicepanel[ply:SteamID()] = nil
            self:Remove()
        end

        VoiceAvatar:SetAlpha(255 * self.TalkAmt)

        if !ply:Alive() then
            self.DefaultClr = Color(100 + 255 * clr_mul,10 + 255 * clr_mul,10 + 255 * clr_mul,(200 + 230 * clr_mul) * self.TalkAmt)
        else
            self.DefaultClr = Color(110 + 255 * clr_mul,110 + 255 * clr_mul,110 + 255 * clr_mul,(200 + 230 * clr_mul) * self.TalkAmt)
        end

        draw.SimpleText(ply:Name(),"HO.18",w/1.96,h/1.9,Color(0,0,0,255 * self.TalkAmt),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(ply:Name(),"HO.18",w/1.97,h/2,Color(255,255,255,255 * self.TalkAmt),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        if TableRound and TableRound().TeamBased and ply:Alive() then
            if !ply:Team() == 1002 then
            local clr = TableRound().Teams[ply:Team()].Color
            surface.SetDrawColor(clr.r,clr.g,clr.b,100 * self.TalkAmt)
            surface.SetMaterial(Material("vgui/gradient-r"))
            surface.DrawTexturedRect(w-w/1.18,0,w/1.22,h)
            end
        end
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

hook.Add("HUDPaint","zalua",function(ply)
    for _zov, ply in ipairs(player.GetAll()) do
        if IsValid(hg.voicepanel[ply:SteamID()]) then
            local self = hg.voicepanel[ply:SteamID()]
            local w,h = self.ZalupaAvatar:GetSize()

            //print(ply:VoiceVolume() * 50)

            self.SizeZalupki = LerpFT(0.4,self.SizeZalupki or 0,ply:VoiceVolume() * 450)

            local X, Y = self.ZalupaAvatar:LocalToScreen(self.ZalupaAvatar:GetWide() / 2, self.ZalupaAvatar:GetTall() / 2)


            surface.SetMaterial(Material("homigrad/vgui/models/circle.png"))
            surface.SetDrawColor(255 * ply:VoiceVolume() * 2, 255 * ply:VoiceVolume() * 2, 255 * ply:VoiceVolume() * 2,200 * ply:VoiceVolume() * 10)
            surface.DrawTexturedRect(X - self.SizeZalupki/2, Y - self.SizeZalupki/2, self.SizeZalupki, self.SizeZalupki)
            
        end
    end
end)

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

CreateVoicePanels()
