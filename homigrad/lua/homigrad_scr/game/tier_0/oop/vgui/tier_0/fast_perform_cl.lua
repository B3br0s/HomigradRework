local PANEL = oop.Get("v_panel")
if not PANEL then return end

PANEL:Event_Add("Init","Fast Perform",function(self)
    self.adlist = {}
end,-1)

function PANEL:ad(func)
    self.adlist[#self.adlist + 1] = func

    local parent = self:GetParent()
    local w,h = parent:GetWide(),parent:GetTall()

    func(self,w,h)

    return self
end

PANEL:Event_Add("Perform","ad",function(self,w,h)
    local parent = self:GetParent()
    w,h = parent:GetWide(),parent:GetTall()

    for i,func in pairs(self.adlist) do func(self,w,h) end
end,1)

hook.Add("Screen Size","Perform Layout",function(new)
    for panel in pairs(vgui.CreatePanels) do
        if not IsValid(panel) then vgui.CreatePanels[panel] = nil continue end
        
        panel:InvalidateLayout()
    end
end)

function VGUIScreenSize()
    local panel = vgui.GetWorldPanel()

    return panel:GetWide(),panel:GetTall()
end