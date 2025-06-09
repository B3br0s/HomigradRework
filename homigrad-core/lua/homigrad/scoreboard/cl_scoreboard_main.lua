if not open then
    open = false
end

open_fade = 0

local toggle_tab = (ConVarExists("hg_toggle_score") and GetConVar("hg_toggle_score") or CreateClientConVar("hg_toggle_score","1",true,false,"Toggle tab",0,1))

function AddPanel(Parent,Text,NeedTo,ChangeTo,SizeXY,DockTo,CustomFunc)
    local ButtonShit = Parent:Add("hg_button")
    ButtonShit:SetSize(SizeXY.x,SizeXY.y)
    ButtonShit:SetText(" ")
    ButtonShit:Center()
    ButtonShit:Dock(DockTo)
    ButtonShit:DockMargin(0,0,0,0)
    ButtonShit:SetPos(0,0)
    ButtonShit.Text = Text
    Parent[ChangeTo] = ButtonShit
    if CustomFunc then
        ButtonShit.Shit = CustomFunc
    end
    function ButtonShit:DoClick()
        surface.PlaySound("homigrad/vgui/panorama/sidemenu_click_01.wav")
        if hg[NeedTo] != ChangeTo then
            open_target = 1
        end
        hg[NeedTo] = ChangeTo
    end
end

function show_scoreboard()
    if hg.ScoreBoard == 2 and !LocalPlayer():Alive() then
        hg.ScoreBoard = 1 
    end
    if not hg.ScoreBoard then
        hg.ScoreBoard = 1 -- 1 - Скорборд, 2 - персонаж
    end
    ScoreBoardPanel = vgui.Create("DFrame")
    open_target = 0
    
    ScoreBoardPanel:SetSize(SW,SH)
    ScoreBoardPanel:Center()
    ScoreBoardPanel:ShowCloseButton(false)
    ScoreBoardPanel:SetTitle(" ")
    ScoreBoardPanel:MakePopup()
    ScoreBoardPanel:SetDraggable(false)
    ScoreBoardPanel:SetKeyBoardInputEnabled(false)
    local cx,cy = ScoreBoardPanel:GetX(),ScoreBoardPanel:GetY()
    function ScoreBoardPanel:Paint(w,h)
        //self:SetPos(cx-(w*open_shit),cy)
        draw.RoundedBox(0,self:GetX(),self:GetY(),w,h,Color(0,0,0,129 * open_fade))
        //Derma_DrawBackgroundBlur(self)
        draw.SimpleText("HOMIGRAD REWORK","H.70",ScrW()/2,ScrH()/2,Color(255,255,255,30 * open_fade),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    
    ItemsPanel = vgui.Create("DScrollPanel",ScoreBoardPanel)
    ItemsPanel:SetSize(ScrW()/18,ScrH())
    local x,y = ItemsPanel:GetSize()
    ItemsPanel:SetPos(ScrW() - x,-ScrH())
    //ItemsPanel:ShowCloseButton(false)
    //ItemsPanel:SetTitle(" ")
    //ItemsPanel:MakePopup() //Не обязательно делать поп-апом!!!!
    //ItemsPanel:SetDraggable(false)
    ItemsPanel:SetKeyBoardInputEnabled(false)
    ItemsPanel:SetHeight(ScrH() / 2)
    ItemsPanel:SetY(ScrH() / 4)
    ItemsPanel:SetZPos(1000)

    ItemsPanelPaint = vgui.Create("DFrame",ScoreBoardPanel)
    ItemsPanelPaint:SetSize(ScrW()/256,ScrH())
    local x,y = ItemsPanel:GetSize()
    ItemsPanelPaint:SetPos(ScrW() - x - 10,-ScrH())
    ItemsPanelPaint:SetKeyBoardInputEnabled(false)
    ItemsPanelPaint:SetHeight(ScrH() / 2)
    ItemsPanelPaint:SetY(ScrH() / 4)
    ItemsPanelPaint:ShowCloseButton(false)
    ItemsPanelPaint:SetTitle(" ")
    ItemsPanelPaint:SetDraggable(false)
    ItemsPanelPaint.PosShit = (ItemsPanel:GetWide() * hg.ScoreBoard)

    function ItemsPanelPaint:Paint(w,h)
        cam.Start2D()
            local w = ScrW()
            local h = ScrH()
            surface.SetFont("hg_HomicideSmalles")
            local sizex,sizey = surface.GetTextSize(tostring(string.format(hg.GetPhrase("sc_curround"),(TableRound and TableRound().name or "N/A"))))
            local sizex2,sizey2 = surface.GetTextSize(tostring(string.format(hg.GetPhrase("sc_nextround"),(TableRound and TableRound(ROUND_NEXT).name or "N/A"))))
            surface.SetDrawColor(0,0,0,255 * open_fade)
            surface.SetMaterial(Material("homigrad/vgui/gradient_right.png"))
            surface.DrawTexturedRect(ScrW()-sizex*2,0,sizex * 2,(sizey*2) * 1.3)
            draw.SimpleText(string.format(hg.GetPhrase("sc_curround"),TableRound().name), "hg_HomicideSmalles", ScrW() - sizex * 1.3 - sizex2 * 0.1, 8, Color(255, 255, 255, 255 * open_fade), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)          
            draw.SimpleText(string.format(hg.GetPhrase("sc_nextround"),TableRound(ROUND_NEXT).name), "hg_HomicideSmalles", ScrW() - sizex * 1.3 - sizex2 * 0.1, 8 + sizey, Color(255, 247, 173, 255 * open_fade), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        cam.End2D()
    end

    local mm_zalupa = vgui.Create("DFrame",ItemsPanelPaint)
    mm_zalupa:ShowCloseButton(false)
    mm_zalupa:SetTitle(" ")
    mm_zalupa:SetDraggable(false)
    mm_zalupa:SetSize(3,ItemsPanel:GetWide())
    mm_zalupa.ypos = 0

    function mm_zalupa:Paint(w,h)
        draw.RoundedBox(16,0,0,w,h,Color(255,255,255,100))

        self.ypos = LerpFT(0.2,self.ypos,ItemsPanel[hg.ScoreBoard]:GetY())

        self:SetY(self.ypos)
    end

    AddPanel(ItemsPanel,hg.GetPhrase("sc_players"),"ScoreBoard",1,{x = ItemsPanel:GetWide(),y = ItemsPanel:GetWide()},TOP,function(self) self.Amt = #player.GetAll() end)
    AddPanel(ItemsPanel,hg.GetPhrase("sc_teams"),"ScoreBoard",2,{x = ItemsPanel:GetWide(),y = ItemsPanel:GetWide()},TOP)
    if LocalPlayer():Alive() then
        AddPanel(ItemsPanel,hg.GetPhrase("sc_invento"),"ScoreBoard",3,{x = ItemsPanel:GetWide(),y = ItemsPanel:GetWide()},TOP)
    end
    //AddPanel(ItemsPanel,hg.GetPhrase("sc_settings"),"ScoreBoard",4,{x = ItemsPanel:GetWide(),y = ItemsPanel:GetWide()},TOP)

    /*if LocalPlayer():Alive() then
        local Inventory = vgui.Create("DButton",ItemsPanel)
        Inventory:SetSize(ItemsPanel:GetWide(),ItemsPanel:GetWide())
        Inventory:SetText(" ")
        Inventory:Center()
        Inventory:SetPos(0,0)
        function Inventory:DoClick()
            hg.ScoreBoard = 2
        end
    
        function Inventory:Paint(w,h)
            draw.RoundedBox(0, 0, 0, w, h, Color(56, 56, 56, 148))
            draw.SimpleText("Инвентарь", "hg_HomicideSmalles", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end*/
    
end

hook.Add("ScoreboardShow","Homigrad_ScoreBoard",function()
    hg.score_closing = false
    if toggle_tab:GetBool() then
        return false
    end
    if IsValid(ScoreBoardPanel) then
        if hg.islooting then
            surface.PlaySound("homigrad/vgui/item_drop.wav")
            hg.islooting = false
            if !hg.score_closing then
                hg.score_closing = true
                timer.Simple(0.2,function()
                    ScoreBoardPanel:Remove()
                end)
            end
            hg.lootent = NULL
        else
            ScoreBoardPanel:Remove()
        end
    else
        show_scoreboard()
    end
    return false
end)

hook.Add("ScoreboardHide","Homigrad_ScoreBoard",function()
    if toggle_tab:GetBool() then
        return
    end
    if IsValid(ScoreBoardPanel) then
        hg.score_closing = true
        timer.Simple(0.2,function()
            ScoreBoardPanel:Remove()
        end)
        hg.islooting = false
        hg.lootent = NULL
    end
end)



local tabPressed = false
fastloot = false
local nextUpdateTime = RealTime() - 1
hook.Add("HUDPaint", "HomigradScoreboardToggle", function()
    if !TableRound then
        return
    end
    if !IsValid(ScoreBoardPanel) then
        cam.Start2D()
            local w = ScrW()
            local h = ScrH()
            surface.SetFont("hg_HomicideSmalles")
            local sizex,sizey = surface.GetTextSize(tostring(string.format(hg.GetPhrase("sc_curround"),(TableRound and TableRound().name or "N/A"))))
            local sizex2,sizey2 = surface.GetTextSize(tostring(string.format(hg.GetPhrase("sc_nextround"),(TableRound and TableRound(ROUND_NEXT).name or "N/A"))))
            surface.SetDrawColor(0,0,0,255 * open_fade)
            surface.SetMaterial(Material("homigrad/vgui/gradient_right.png"))
            surface.DrawTexturedRect(ScrW()-sizex*2,0,sizex * 2,(sizey*2) * 1.3)
            draw.SimpleText(string.format(hg.GetPhrase("sc_curround"),TableRound().name), "hg_HomicideSmalles", ScrW() - sizex * 1.3 - sizex2 * 0.1, 8, Color(255, 255, 255, 255 * open_fade), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)          
            draw.SimpleText(string.format(hg.GetPhrase("sc_nextround"),TableRound(ROUND_NEXT).name), "hg_HomicideSmalles", ScrW() - sizex * 1.3 - sizex2 * 0.1, 8 + sizey, Color(255, 247, 173, 255 * open_fade), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        cam.End2D()
    end
    if !hg.score_closing then
        open_fade = LerpFT(0.25,open_fade,1)
    else
        open_fade = LerpFT(0.25,open_fade,0)
    end
    if hg.islooting and IsValid(hg.lootent) and hg.lootent:GetPos():Distance(LocalPlayer():GetPos()) > 95 or !IsValid(hg.lootent) and hg.islooting or hg.islooting and !LocalPlayer():Alive() then
        if hg.islooting then
            surface.PlaySound("homigrad/vgui/item_drop.wav")
            hg.islooting = false
            hg.lootent = NULL
            if !hg.score_closing then
                hg.score_closing = true
                timer.Simple(0.2,function()
                    ScoreBoardPanel:Remove()
                end)
            end
        else
            if IsValid(ScoreBoardPanel) then
                hg.islooting = false
                hg.score_closing = true
                timer.Simple(0.2,function()
                    ScoreBoardPanel:Remove()
                end)
            end
        end
    end
    if input.IsKeyDown(KEY_H) and !fastloot then
        fastloot = true
    elseif !input.IsKeyDown(KEY_H) then
        fastloot = false
    end

    if !toggle_tab:GetBool() then
        return
    end
    if input.IsKeyDown(KEY_TAB) and !tabPressed then
        if IsValid(ScoreBoardPanel) then
            if hg.islooting then
                surface.PlaySound("homigrad/vgui/item_drop.wav")
                hg.islooting = false
                hg.lootent = NULL
                if !hg.score_closing then
                    hg.score_closing = true
                    timer.Simple(0.2,function()
                        ScoreBoardPanel:Remove()
                    end)
                end
            else
                hg.score_closing = true
                timer.Simple(0.2,function()
                    ScoreBoardPanel:Remove()
                end)
                hg.islooting = false
                hg.lootent = NULL
            end
        else
            show_scoreboard()
            hg.score_closing = false
        end
        tabPressed = true
    elseif !input.IsKeyDown(KEY_TAB) then
        tabPressed = false
    end
end)