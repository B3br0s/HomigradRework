local PANEL = oop.Reg("v_switch","v_panel")
if not PANEL then return end

PANEL:Event_Add("Init","Main",function(self)
    self:SetMouseInputEnabled(true)

    self.on = false
    self.onLerp = 0
end)

local SetDrawColor,DrawRect = surface.SetDrawColor,surface.DrawRect

function PANEL:Draw(w,h)
    SetDrawColor(15,15,15)
    DrawRect(0,0,w,h)
    draw.Frame(0,0,w,h,cframe2,cframe1)

    local set = self.on and 1 or 0
    if math.abs(set - self.onLerp) <= 0.1 then self.onLerp = set end

    self.onLerp = LerpFT(0.15,self.onLerp,set)

    SetDrawColor(Lerp(self.onLerp,255,0),Lerp(self.onLerp,0,255),0)

    local x,y,s = self.onLerp * w / 2,0,w / 2,h
    DrawRect(x,y,s,h)
    draw.Frame(x,y,s,h,cframe1,cframe2)
end

PANEL:Event_Add("Down","Sound",function(self,value)
    LocalPlayer():EmitSound("buttons/button15.wav",75,value and 110 or 90,value and 0.25 or 0.1)

    if value then
        self.on = not self.on

        if self.OnValue then self:OnValue(self.on) end
    end
end)

function PANEL:SetValue(value)
    self.on = value
    self.onLerp = value and 1 or 0
end