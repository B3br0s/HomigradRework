local PANEL = oop.Get("v_panel")
if not PANEL then return end

PanelInputMouse = PanelInputMouse or {}
PanelInputKeyboard = PanelInputKeyboard or {}

PANEL:Event_Add("Init","Input",function(self)
    self.mouse = {}
    self.keyboard = {}
end,-1)

function PANEL:OnMousePressed(key)
    self.mouse[key] = true
    PanelInputMouse[self] = true

    if self.OnMouse then self:OnMouse(key,true) end
    self:Event_Call("Mouse",key,true)
end

function PANEL:OnMouseReleased(key,outside)
    local value = self.mouse[key]

    if self.OnMouseOut then self:OnMouseOut(key,outside) end
    self:Event_Call("MouseOut",key,outside)

    if not value then return end

    self.mouse[key] = nil

    if self.OnMouse then self:OnMouse(key,false) end
    self:Event_Call("Mouse",key,false)
end

--

function PANEL:OnKeyCodePressed(key)
    self.keyboard[key] = true
    PanelInputKeyboard[self] = true

    if self.OnKey then self:OnKey(key,true) end
    self:Event_Call("Key",key,true)
end

function PANEL:OnKeyCodeReleased(key,outside)
    if not self.keyboard[key] then return end
    self.keyboard[key] = nil
    
    if self.OnKey then self:OnKey(key,false) end
    self:Event_Call("Key",key,false)
end

function PANEL:OnMouseWheeled(wheel)
    if self.OnWheel then self:OnWheel(wheel) end
    self:Event_Call("Wheel",wheel)
end

hook.Add("Think","Panel Input",function()
    for panel in pairs(PanelInputMouse) do
        if not IsValid(panel) then PanelInputMouse[panel] = nil continue end

        for key in pairs(panel.mouse) do
            if not input.IsMouseDown(key) then panel:OnMouseReleased(key,true) end
        end
    end

    for panel in pairs(PanelInputKeyboard) do
        if not IsValid(panel) then PanelInputKeyboard[panel] = nil continue end

        for key in pairs(panel.keyboard) do
            if not input.IsKeyDown(key) then panel:OnKeyCodeReleased(key,true) end
        end
    end
end)

function PANEL:IsDown()
    for key in pairs(self.mouse) do return true end

    return false
end

function PANEL:GetMousePos()
    local x,y = self:LocalToScreen(0,0)

    return mousex - x,mousey - y
end

function PANEL:LinkMouse(panel)
    panel.OnMousePressed = function(_,key,value) self:OnMousePressed(key,value) end
    panel.OnMouseReleased = function(_,key,value) self:OnMouseReleased(key,value) end
end