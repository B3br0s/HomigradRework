local PANEL = oop.Reg("v_scrollpanel","v_panel")
if not PANEL then return end

PANEL:Event_Add("Init","Main",function(self)
    self.canvasPanel = oop.CreatePanel("v_panel",self)
    self.canvasPanel.PerformLayout = function(self)
        self:SetSize(self:ChildrenSize())//canvas не принимает размеры v_scrollpanel, вроде это нужно было для чего-то
        //поэтому в af(function(self,w,h) end) мы не берём w или h, а исплозьуем v_scrollpanel:W()
    end

    self:SetMouseInputEnabled(true)

    self.scrollY = 0
    self.scrollX = 0

    self.setScrollX = 0
    self.setScrollY = 0

    self.scrollMul = 1
end)

function PANEL:OnChildAdded(panel)
    if self.canvasPanel then panel:SetParent(self.canvasPanel) end
end

function PANEL:SetScrollY(value,fast)
    self.setScrollY = math.Clamp(value,0,math.max(self.canvasPanel:H() - self:H(),0))
    if fast then self.scrollY = self.setScrollY end
end

function PANEL:SetScrollX(value,fast)
    self.setScrollX = math.Clamp(value,0,math.max(self.canvasPanel:W() - self:W(),0))
    if fast then self.scrollX = self.setScrollX end
end

PANEL:Event_Add("Think","Main",function(self)
    self.scrollY = LerpFT(0.25,self.scrollY or 0,self.setScrollY)
    self.scrollX = LerpFT(0.25,self.scrollX or 0,self.setScrollX)

    self.canvasPanel.y = -self.scrollY
    self.canvasPanel.x = -self.scrollX
end)

function PANEL:OnMouseWheeled(value)
    value = -value * 50 * self.scrollMul

    if self.canvasPanel:H() <= self:H() or input.IsButtonDown(KEY_LSHIFT) then
        self:SetScrollX(self.scrollX + value)
    else
        self:SetScrollY(self.scrollY + value)
    end
end

function PANEL:Clear()
    for i,child in pairs(self.canvasPanel:GetChildren()) do
        child:Remove()
    end
end