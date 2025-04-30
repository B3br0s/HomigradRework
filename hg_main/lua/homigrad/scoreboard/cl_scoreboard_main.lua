local shit = 0
local shit_t = 0

if not open then
    open = false
end
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
        hg[NeedTo] = ChangeTo
    end
end

function show_scoreboard(looting)
    if !looting then
        lootEnt = nil
    end
    if hg.ScoreBoard == 2 and !LocalPlayer():Alive() then
        hg.ScoreBoard = 1 
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
    //ItemsPanel:MakePopup() //Не обязательно делать поп-апом!!!!
    //ItemsPanel:SetDraggable(false)
    ItemsPanel:SetKeyBoardInputEnabled(false)
    ItemsPanel:SetHeight(ScrH() / 2)
    ItemsPanel:SetY(ScrH() / 4)

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
    shit_t = 1
    if IsValid(ScoreBoardPanel) then
        ScoreBoardPanel:Remove()
    end
    show_scoreboard()
    return false
end)

hook.Add("ScoreboardHide","Homigrad_ScoreBoard",function()
    shit_t = 0
    if IsValid(ScoreBoardPanel) then
        ScoreBoardPanel:Remove()
    end
end)


local tabPressed = false
local nextUpdateTime = RealTime() - 1
hook.Add("Think", "HomigradScoreboardToggle", function()
    shit = LerpFT(0.1,shit,shit_t)
end)


net.Receive("close_tab",function(len)
	if ScoreBoardPanel then
		ScoreBoardPanel:Remove()
	end
end)