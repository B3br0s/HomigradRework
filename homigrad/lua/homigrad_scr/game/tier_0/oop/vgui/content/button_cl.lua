local PANEL = oop.Reg("v_button","v_panel")
if not PANEL then return end

PANEL:Event_Add("Init","Main",function(self)
    self:SetMouseInputEnabled(true)

    self:SetCursor("hand")

    self.hovered = 0
    self.font = "H.12"
end)

local SetDrawColor,DrawRect = surface.SetDrawColor,surface.DrawRect

function PANEL:Draw(w,h)
    SetDrawColor(25,25,25)
    DrawRect(0,0,w,h)

    if self:IsDown() then
        SetDrawColor(0,0,0,255)
        DrawRect(0,0,w,h)
    elseif self:IsHovered() then
        SetDrawColor(255,255,255,5)
        DrawRect(0,0,w,h)
    end

    self:DrawText(w,h)

    draw.Frame(0,0,w,h,cframe1,cframe2)
end

function PANEL:DrawText(w,h)
    if self.text then draw.SimpleText(self.text,self.font,w / 2,h / 2,self.textColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) end
end

PANEL:Event_Add("Down","Sound",function(self,value)
    LocalPlayer():EmitSound("buttons/button15.wav",75,value and 110 or 90,value and 0.25 or 0.1)
end)

PANEL:Event_Add("Mouse","Click",function(self,key,value)
    if value == false then return end

    if self.OnClick then self:OnClick(key) end
end)

PANEL:Event_Add("Think","Hovered",function(self)
    self.hovered = LerpFT(0.56,self.hovered,self:IsDown() and -1 or self:IsHovered() and 1 or 0)
end)