local PANEL = oop.Get("v_panel")
if not PANEL then return end

function PANEL:setPos(x,y)
    self.x = x
    self.y = y

    return self
end

function PANEL:setSize(w,h)
    self:SetSize(w,h)

    return self
end

function PANEL:W() return self:GetWide() end
function PANEL:H() return self:GetTall() end

function PANEL:setPosD(x,y)
    local parent = self:GetParent()

    self.dx = x
    self.dy = y

    self.x = parent:GetWide() * x
    self.y = parent:GetTall() * y

    return self
end

PANEL.setDPos = PANEL.setPosD

function PANEL:setSizeD(w,h)
    local parent = self:GetParent()

    self.dw = w
    self.dh = h

    self:SetSize(parent:GetWide() * w,parent:GetTall() * h)
    
    return self
end

PANEL.setDSize = PANEL.setSizeD

function PANEL:PerformLayout(w,h)
    self:Event_Call("Perform",w,h)
end

function PANEL:MulSize(value)
    self:SetSize(self:W() * value,self:H() * value)
end

PANEL:Event_Add("Perform","Transform",function(self,w,h)
    local parent = self:GetParent()

    if self.dx then
        self.x = parent:GetWide() * self.dx
        self.y = parent:GetTall() * self.dy
    end

    if self.dw then
        self:SetSize(parent:GetWide() * self.dw,parent:GetTall() * self.dh)
    end
end,-1)