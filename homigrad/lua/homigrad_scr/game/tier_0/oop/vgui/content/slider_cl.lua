local PANEL = oop.Reg("v_slider","v_panel")
if not PANEL then return end

PANEL:Event_Add("Init","Main",function(self)
    self.value = 0
    self.oldValue = 0

    self.maxValue = 1
    self.minValue = 0
    self.round = 10

    local Normal = GWEN.CreateTextureNormal( 416, 32,	15, 15 )
    local Hover	= GWEN.CreateTextureNormal( 416, 32+16, 15, 15 )
    local Down = GWEN.CreateTextureNormal( 416, 32+32, 15, 15 )
    local Disabled = GWEN.CreateTextureNormal( 416, 32+48, 15, 15 )
    
    local butt = oop.CreatePanel("v_button",self)
    self.knob = butt
    function butt:Paint(w,h)
        local hover = (self:IsDown() and -2) or (self:IsHovered() and 2) or 0
        
        local x,y,s = 0,0,h + hover

        x = w / 2 - s / 2
        y = h / 2 - s / 2

        if self:IsDown() then
            Disabled(x,y,s,s)
        elseif self:IsHovered() then
            Hover(x,y,s,s)
        else
            Normal(x,y,w,s)
        end
    end

    butt:ad(function(self,w,h)
        self:setSize(15 * ScreenSize,15 * ScreenSize)
    end)

    function butt.Update()
        local value = self:GetKValue(self:GetValue())
        
        self.knob:setPos(self:GetCorner() - self.knob:W() / 2 + (self:GetSlideW()) * value,self:H() / 2 - self.knob:H() / 2)
    end

    function butt:GetDisabled() return false end

    function butt.OnMouse(_,key,value)
        self.grab = value
    end

    function self:OnMouse(key,value)
        self.grab = value
    end

    local textEntry = oop.CreatePanel("v_textentry",self):ad(function(textEntry,w,h)
        textEntry:setSize(50,h / 2):setPos(w - textEntry:W() - self:GetCorner(),h / 2 - textEntry:H() / 2)
    end)
    self.textEntry = textEntry

    function textEntry.OnValueChange(_,value)
        if self.override then return end

        self:SetValue(self:GetKValue(tonumber(value or 0) or 0))
    end

    butt:Update()
end)

function PANEL:GetCorner()
    return self:H() / 1.5 * ScreenSize
end

function PANEL:GetSlideW()
    return self:W() - self:GetCorner() * 2 - self.textEntry:W() - self:GetCorner()
end

local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect

function PANEL:Paint(w,h)
    SetDrawColor(255,255,255,30)
    DrawRect(self:GetCorner(),h / 2,self:GetSlideW(),1)
end

PANEL:Event_Add("Think","Main",function(self)
    if self.grab then
        local x,y = self:LocalToScreen(self:GetCorner(),0)
        self:SetValue(math.Clamp((mousex - x) / self:GetSlideW(),0,1))
    end

    self.knob:Update()
end)

function PANEL:SetMax(value)
    self.maxValue = value
end

function PANEL:SetMin(value)
    self.minValue = value
end

function PANEL:GetValue()
    local value = Lerp(self.value,self.minValue,self.maxValue)
    
    if self.round then value = math.Round(value * self.round) / self.round end

    return value
end

function PANEL:GetKValue(value) return math.Clamp((value - self.minValue) / (self.maxValue - self.minValue),0,1) end

function PANEL:SetValue(value)
    self.value = value

    if self.value ~= self.oldValue then
        self.oldValue = self.value

        if self.OnValue then self:OnValue(self.value) end
    end

    self.knob:Update()

    self.override = true
    self.textEntry:SetValue(self:GetValue())
    self.override = nil

    self.oldValue = value
end

if Initialize and LocalPlayer():SteamID() == "STEAM_0:1:215196702" then OpenTab() end
