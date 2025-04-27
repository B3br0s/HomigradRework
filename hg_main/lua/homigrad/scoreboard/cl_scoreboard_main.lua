CreateClientConVar("hg_tab_setting", "1", true, false, "Переключить меню настроек", 0, 1)

local shit = 0
local shit_t = 0

if not open then
    open = false
end
function AddPanel(Parent,Text,NeedTo,ChangeTo)
    local ButtonShit = ItemsPanel:Add("DButton")
    ButtonShit:SetSize(ItemsPanel:GetWide(),ItemsPanel:GetWide())
    ButtonShit:SetText(" ")
    ButtonShit:Center()
    ButtonShit:Dock(TOP)
    ButtonShit:DockMargin(0,0,0,0)
    ButtonShit:SetPos(0,0)
    function ButtonShit:DoClick()
        surface.PlaySound("homigrad/vgui/panorama/sidemenu_click_01.wav")
        hg[NeedTo] = ChangeTo
    end

    function ButtonShit:Paint(w,h)
        if !self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, (hg[NeedTo] == ChangeTo and Color(42, 42, 42) or Color(32,32,32)))
        else
            draw.RoundedBox(0, 0, 0, w, h, Color(38, 38, 38, 255))
        end

        draw.SimpleText(Text, "HS.18", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255,255,255,20)

        surface.DrawOutlinedRect(0,0,w,h,1)
    end
end

function show_scoreboard(looting)
    if !looting then
        lootEnt = nil
    end
    if hg.ScoreBoard == 2 and !LocalPlayer():Alive() then
        hg.ScoreBoard = 1 
    end
    if GetConVar("hg_tab_setting"):GetBool() then 
        if ScoreBoardPanel then
            ScoreBoardPanel:Remove()
        end
    end
    if not hg.ScoreBoard then
        hg.ScoreBoard = 1 -- 1 - Скорборд, 2 - персонаж
    end
    ScoreBoardPanel = vgui.Create("DFrame")
    
    ScoreBoardPanel:SetSize(ScrW(),ScrH())
    ScoreBoardPanel:Center()
    ScoreBoardPanel:ShowCloseButton(false)
    ScoreBoardPanel:SetTitle(" ")
    ScoreBoardPanel:MakePopup()
    ScoreBoardPanel:SetDraggable(false)
    ScoreBoardPanel:SetKeyBoardInputEnabled(false)
    function ScoreBoardPanel:Paint(w,h)
        draw.RoundedBox(0,self:GetX(),self:GetY(),w,h,Color(0,0,0,129 * shit))
    end
    
    ItemsPanel = vgui.Create("DScrollPanel",ScoreBoardPanel)
    ItemsPanel:SetSize(ScrW()/18,ScrH())
    local x,y = ItemsPanel:GetSize()
    ItemsPanel:SetPos(ScrW() - x,-ScrH())
    //ItemsPanel:ShowCloseButton(false)
    //ItemsPanel:SetTitle(" ")
    ItemsPanel:MakePopup()
    //ItemsPanel:SetDraggable(false)
    ItemsPanel:SetKeyBoardInputEnabled(false)
    ItemsPanel:SetHeight(ScrH() / 2)
    ItemsPanel:SetY(ScrH() / 4)
    
    function ItemsPanel:Paint(w,h)

        /*draw.RoundedBox(0, 0, 0, w, h, Color(38, 38, 38, 255))

        surface.SetDrawColor(255,255,255,20)

        surface.DrawOutlinedRect(0,0,w,h,1)
        */

        //draw.SimpleText("Текущий режим: " .. name, "hg_HomicideSmalles", w - 15, h - 40, Color(255,255,255), TEXT_ALIGN_RIGHT)

        //draw.SimpleText("Следующий режим: " .. nextName, "hg_HomicideSmalles", w - 15, h - 22, Color(255,255,255), TEXT_ALIGN_RIGHT)
    end

    AddPanel(ItemsPanel,hg.GetPhrase("sc_players"),"ScoreBoard",1)
  //AddPanel(ItemsPanel,hg.GetPhrase("sc_invento"),"ScoreBoard",2)

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
    shit_t = 1
    if GetConVar("hg_tab_setting"):GetBool() then
        if IsValid(ScoreBoardPanel) then
            ScoreBoardPanel:Remove()
        end
    end
    show_scoreboard()
    return false
end)

hook.Add("ScoreboardHide","Homigrad_ScoreBoard",function()
    shit_t = 0
    if GetConVar("hg_tab_setting"):GetBool() then
        if IsValid(ScoreBoardPanel) then
            ScoreBoardPanel:Remove()
        end
    end
end)


local tabPressed = false
local nextUpdateTime = RealTime() - 1
hook.Add("Think", "HomigradScoreboardToggle", function()
    shit = LerpFT(0.1,shit,shit_t)
    if nextUpdateTime and nextUpdateTime > RealTime() then return end
    nextUpdateTime = RealTime() + 0.25
  
    if !GetConVar("hg_tab_setting"):GetBool() then
        local isTabDown = input.IsKeyDown(KEY_TAB)
        
        if isTabDown and not tabPressed then
            tabPressed = true
            if not hg.ScoreBoardPanel then
                show_scoreboard()
            else
                ScoreBoardPanel:Remove()
                if lootEnt then
                    net.Start("inventory")
                    net.WriteEntity(lootEnt)
                    net.SendToServer()
                end
            end
        elseif not isTabDown then
            tabPressed = false
        end
    end
end)


net.Receive("close_tab",function(len)
	if ScoreBoardPanel then
		ScoreBoardPanel:Remove()
	end
end)