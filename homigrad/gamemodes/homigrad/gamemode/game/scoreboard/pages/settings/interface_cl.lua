local Page = {}
SettingsPages[4] = Page
Page.Name = "Интерфейс"

function Page.Open(panel)
    local cat = panel:AddCategory(L("settings_main"))

    local block = cat:AddBlock(40)
    local panel2 = oop.CreatePanel("v_panel",block):ad(function(self,w,h) self:setSize(w / 4 * ScreenSize,h):setPos(w - self:W(),0) end)

    local tab = {
        0.25,
        0.5,
        0.75,
        1,
        1.25,
        1.5
    }

    for i,div in pairs(tab) do
        local b = oop.CreatePanel("v_button",panel2):ad(function(self,w,h) self:setSize(w / #tab,h):setPos(w / #tab * (i - 1),0) end)
        b.text = div

        function b:OnMouse(key,value) if value then RunConsoleCommand("hg_screensize",div) end end
    end

    local panel = oop.CreatePanel("v_panel",block):ad(function(self,w,h) self:setSize(w - panel2:W(),h) end)
    panel.lerpHover = 0

    function panel:Draw(w,h)
        self.lerpHover = LerpFT(0.45,self.lerpHover,(self:IsHovered() or panel2:IsHovered()) and 1 or 0)

        surface.SetDrawColor(125,125,125,25)
        draw.GradientLeft(0,0,w * (0.25 + self.lerpHover * 0.5),h)

        draw.SimpleText(L("interface_multiply_screen"),"H.18",15,h / 2,nil,nil,TEXT_ALIGN_CENTER)
        draw.SimpleText(L("interface_multiply_screen2"),"H.18",w - 15,h / 2,nil,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
    end
end

if Initialize and LocalPlayer():SteamID() == "STEAM_0:1:215196702" then OpenTab() end
