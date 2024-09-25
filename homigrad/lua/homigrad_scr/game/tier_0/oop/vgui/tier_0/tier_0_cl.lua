local PANEL = oop.Reg("v_panel","lib_event",true)
if not PANEL then return INCLUDE_BREAK end

PANEL.Base = "Panel"

vgui.Panels = vgui.Panels or {}
local Panels = vgui.Panels

vgui.CreatePanels = vgui.CreatePanels or {}
local CreatePanels = vgui.CreatePanels

concommand.Add("hg_vgui_removeall",function()
    for panel in pairs(CreatePanels) do
        if IsValid(panel) then panel:Remove() end

        CreatePanels[panel] = nil
    end
end)

PANEL:Event_Add("Construct","register",function(class)
    local content = class[1]
    if content.NonRegisterGMOD or class.NonRegisterGMOD then return end

    Panels[content.ClassName] = class

    for panel in pairs(CreatePanels) do
        if not IsValid(panel) then CreatePanels[panel] = nil continue end
        if panel.ClassName ~= content.ClassName then continue end

        local tbl = panel:GetTable()
        util.tableLink(tbl,content)

        panel:Event_Call("Construct Object",tbl)
    end
end)

function oop.CreatePanel(class,parent)
    local object = Panels[class]
    if not object then error("invalid object '" .. class .. "'") end

    local content = object[1]
    content = util.tableCopy(content)

    local func = content.FunctionCreate
    local panel

    if func then
        panel = func(content,parent)
    else
        panel = vgui.CreateFromTable(content,parent,class)--wtf?
    end
    
    CreatePanels[panel] = true

    return panel
end

function PANEL:Init()
    self.oldHovered = false
    self.oldDown = false

    self:Event_Call("Init")
end

function PANEL:Think()
    local hovered = self:IsHovered()
    if hovered ~= self.oldHovered then
        self.oldHovered = hovered
        self:Event_Call("Hovered",hovered)
    end

    local down = self:IsDown()
    if down ~= self.oldDown then
        self.oldDown = down
        self:Event_Call("Down",down)
    end

    self:Event_Call("Think")
    if self.Step then self:Step() end
end

function PANEL:OnRemove()
    self:Event_Call("Remove")
end

function PANEL:Paint(w,h)
    self:Event_Call("Draw",w,h)
    if self.Draw then self:Draw(w,h) end
end

PANEL:Event_Add("Draw","Main",function(self,w,h)
    if self.Draw then self:Draw(w,h) end
end)

hook.Add("Think","Remove Stupid Ass Shit wtf is that vase",function()
    local hover = vgui.GetHoveredPanel()
    if not IsValid(hover) then return end

    local parent = hover:GetParent()
    if not IsValid(parent) then return end

    if (hover:GetName() == "DScrollPanel") and parent:GetName() == "GModBase" then
        //ErrorNoHalt("detect pidor")
        hover:Remove()--shut the FUCK UP НАХУЙ ЧТО ЭТО?
    end
end)