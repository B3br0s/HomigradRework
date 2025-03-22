local MusicKitsEnd = {
    ["Default"] = "homigrad/vgui/panorama/case_awarded_4_legendary_01.wav",
    ["HighNoon"] = "homigrad/vgui/music_kits/high_noon/mvp_round.wav",
    ["DashStar"] = "homigrad/vgui/music_kits/dashstar/mvp_round.wav",
}

local MusicKitsStart = {
    ["Default"] = " ",-- а чтобы не втыкали
    ["HighNoon"] = "homigrad/vgui/music_kits/high_noon/start_round1.wav",
    ["DashStar"] = "homigrad/vgui/music_kits/dashstar/start_round1.wav",
}

local MusicKitsHave = {
    ["STEAM_0:1:526713154"] = "HighNoon",
    ["STEAM_0:1:776813961"] = "DashStar",
    ["STEAM_0:1:773957134"] = "DashStar",
    ["STEAM_0:1:236109572"] = "DashStar"
}

local Translations = {
    ["Default"] = "Базовый",
    ["HighNoon"] = "Feed Me - High Noon",
    ["DashStar"] = "Knock2 - Dashstar*",
}

function StartRoundMK()
    if MusicKitsHave[LocalPlayer():SteamID()] then
        surface.PlaySound(MusicKitsStart[MusicKitsHave[LocalPlayer():SteamID()]])
    end
end

function WinRound(color,text1,text2,winply)
    --"homigrad/vgui/panorama/case_awarded_4_legendary_01.wav" - звук при выигрыше

    local StartTime = CurTime()

    local HookAdd = math.random(-1e8,1e8)--чтобы не ломалось при тестах.

    local ContinuingTime = 8

    if !IsValid(winply) then
    surface.PlaySound("homigrad/vgui/panorama/case_awarded_4_legendary_01.wav")
    else
    if MusicKitsHave[winply:SteamID()] then
        surface.PlaySound(MusicKitsEnd[MusicKitsHave[winply:SteamID()]])
    else
        surface.PlaySound(MusicKitsEnd["Default"])    
    end
    end
    
    local WinGui = vgui.Create("DFrame")
    WinGui:SetSize(812,160)
    WinGui:Center()
    local XPos = WinGui:GetX()
    WinGui:SetPos(WinGui:GetX(),ScrH() / 16)
    WinGui:ShowCloseButton(false)
    WinGui:SetTitle(" ")

    function WinGui:Paint(w,h)
        draw.RoundedBox(0,140,0,w - 140,h,Color(24,24,24,255))

        surface.SetDrawColor(255,255,255,15)

        surface.DrawOutlinedRect(139.7,0.3,w,h,1)
    
        if winply != NULL then
        draw.SimpleText(winply:Name(), "HS.45", 156, 5, Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        draw.SimpleText("Набор музыки - "..(MusicKitsHave[winply:SteamID()] and Translations[MusicKitsHave[winply:SteamID()]] or Translations["Default"]), "HS.10", 158, 87, Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        end
        draw.SimpleText(text1, "HS.20", 157, (winply != NULL and 43 or 5), Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        draw.SimpleText(text2, "HS.20", 157, (winply != NULL and 63 or 25), Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

        surface.SetMaterial(Material("vgui/gradient-l"))
    
        surface.SetDrawColor(color.r,color.g,color.b,25)

        surface.DrawTexturedRect(140,0,w - w / 2.5,h)
    end

    local WinAvatar = vgui.Create("AvatarImage",WinGui)
    WinAvatar:SetPos(30,0)
    WinAvatar:SetSize(100,100)
    WinAvatar:SetPlayer(((winply != NULL and winply:IsPlayer()) and winply or table.Random(player.GetAll())),64)

    function WinAvatar:Paint(w,h)
        surface.SetDrawColor(255,255,255,50)

        surface.DrawOutlinedRect(0,0,w,h,4)
    end

    hook.Add("HUDPaint","Homigrad_Win_Round"..HookAdd,function()
        local CurrentTimeAnim = (StartTime + ContinuingTime - CurTime())
        local UpPos = 0
        local HoldPos = 812
        local WinGuiAnim = WinGui
        CurAnimPosY = CurAnimPosY or 0
        WinGuiAnim:Center()
        WinGuiAnim:SetY(ScrH() / 16)
        WinGuiAnim:SetSize(CurAnimPosY,100)
        if CurrentTimeAnim > 5.5 then
            CurAnimPosY = LerpFT(0.1,CurAnimPosY,HoldPos)
        elseif CurrentTimeAnim < 2 then
            CurAnimPosY = LerpFT(0.1,CurAnimPosY,UpPos)
        end

        if CurrentTimeAnim <= 0 then
            WinGuiAnim:Remove()
            hook.Remove("HUDPaint","Homigrad_Win_Round"..HookAdd)
        end
    end)
end

net.Receive("EndRound",function()
    local color = net.ReadColor()
    local text1 = net.ReadString()
    local text2 = net.ReadString()
    local winply = net.ReadEntity()
    WinRound(color,text1,text2,winply)
end)

concommand.Add("hg_win_test",function(ply,len,args)
    if ply:IsSuperAdmin() then
    WinRound(Color(255,0,0),args[1],args[2],ply)
    end
end)

concommand.Add("hg_start_test",function(ply,len,args)
    if ply:IsSuperAdmin() then
    StartRoundMK()
    end
end)