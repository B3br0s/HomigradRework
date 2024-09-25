local Panel = {}
ScoreboardPages[10] = Panel

Panel.Name = "settings"

local SetDrawColor,DrawRect = surface.SetDrawColor,surface.DrawRect

SettingsPages = SettingsPages or {}
SettingsPage = SettingsPage or 1

function Panel.Open(frame)
    local panel = oop.CreatePanel("v_panel",frame):setDSize(0.85,0.85)
    panel:setPos(frame:W() / 2 - panel:W() / 2,frame:H() / 2 - panel:H() / 2)

    function panel:Draw(w,h)
        SetDrawColor(0,0,0,100 * ScoreboardClose)
        DrawRect(0,0,w,h)
    end

    for i,page in pairs(SettingsPages) do
        local butt = oop.CreatePanel("v_button",panel)
        butt.text = page.Name
        function butt:OnMouse(key,value)
            if value then panel:SelectPage(i) return end
        end

        page.butt = butt
    end

    panel:ad(function(self,w,h)
        for i,page in pairs(SettingsPages) do
            local butt = page.butt

            butt:setSize(250 * ScreenSize,40 * ScreenSize):setPos(butt:W() * (i - 1),0)
        end
    end)

    panel.lerpX = 0
    
    function panel:PaintOver(w,h)
        SetDrawColor(255,255,255,75)
        DrawRect(self.lerpX,40 * ScreenSize,250 * ScreenSize,2)

        self.lerpX = LerpFT(0.4,self.lerpX,250 * ScreenSize * (SettingsPage - 1))
    end
    
    local panelPage = oop.CreatePanel("v_scrollpanel",panel):ad(function(self,w,h) self:setSize(w,h - 40 * ScreenSize):setPos(0,40 * ScreenSize) end)

    function panelPage:AddCategory(name)
        local panelCat = oop.CreatePanel("v_panel",panelPage)
        panelCat.blocks = {}

        function panelCat:Draw(w,h)
            SetDrawColor(0,0,0,125)
            draw.GradientLeft(0,0,w * 2,40)

            draw.SimpleText(name,"H.25",10,40 / 2,nil,nil,TEXT_ALIGN_CENTER)
        end

        self.categories[#self.categories + 1] = panelCat

        panelCat:ad(function(self,w,h)
            local _,h = self:ChildrenSize()
            self:setSize(panelPage:W(),h)

            local y = 0

            for i,panelCat in pairs(panelPage.categories) do
                if not IsValid(panelCat) then continue end
                
                panelCat.y = y
                y = y + panelCat:H()
            end
        end)--dam.....

        function panelCat:AddBlock(h)
            local panel = oop.CreatePanel("v_panel",panelCat)
            panelCat.blocks[#panelCat.blocks + 1] = panel

            panel:ad(function(self,w)
                self:setSize(w,h * ScreenSize)

                local y = 40

                for i,block in pairs(panelCat.blocks) do
                    if not IsValid(block) then continue end
                    
                    block.y = y
                    y = y + block:H()
                end
            end)

            panel.lerpHover = 0
            
            function panel:Draw(w,h)
                draw.Frame(-1,0,w + 2,h,cframe1,cframe2)
            end

            return panel
        end

        function panelCat:AddSwitch(text,convar,invert,text2)
            local block = self:AddBlock(40)
            local switch = oop.CreatePanel("v_switch",block):ad(function(self,w,h) self:setSize(100 * ScreenSize,h):setPos(w - self:W(),0) end)

            local panel = oop.CreatePanel("v_panel",block):ad(function(self,w,h) self:setSize(w - switch:W(),h) end)
            panel.lerpHover = 0

            function panel:Draw(w,h)
                self.lerpHover = LerpFT(0.45,self.lerpHover,(self:IsHovered() or switch:IsHovered()) and 1 or 0)

                SetDrawColor(125,125,125,25)
                draw.GradientLeft(0,0,w * (0.25 + self.lerpHover * 0.5),h)

                draw.SimpleText(text,"H.18",15,h / 2,nil,nil,TEXT_ALIGN_CENTER)

                if text2 then
                    draw.SimpleText(text2,"H.18",w - 15,h / 2,nil,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                end
            end

            switch:SetValue(GetConVar(convar):GetFloat() > 0)
            if invert then switch:SetValue(not switch.on) end

            function switch:OnValue(value)
                RunConsoleCommand(convar,(value and (invert and 0 or 1) or (invert and 1 or 0)))
            end
        end

        function panelCat:AddText(text,text2)
            local block = self:AddBlock(40)
            local panel = oop.CreatePanel("v_panel",block):ad(function(self,w,h) self:setSize(w,h) end)
            panel.lerpHover = 0

            function panel:Draw(w,h)
                self.lerpHover = LerpFT(0.45,self.lerpHover,self:IsHovered() and 1 or 0)

                SetDrawColor(125,125,125,25)
                draw.GradientLeft(0,0,w * (0.25 + self.lerpHover * 0.5),h)

                draw.SimpleText(text,"H.18",15,h / 2,nil,nil,TEXT_ALIGN_CENTER)

                if text2 then
                    draw.SimpleText(text2,"H.18",w - 15,h / 2,nil,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                end
            end
        end

        function panelCat:AddSlider(text,convar,invert,text2,round,change)
            local block = self:AddBlock(40)
            local slider = oop.CreatePanel("v_slider",block):ad(function(self,w,h) self:setSize(w / 4 * ScreenSize,h):setPos(w - self:W(),0) end)

            local panel = oop.CreatePanel("v_panel",block):ad(function(self,w,h) self:setSize(w - slider:W(),h) end)
            panel.lerpHover = 0

            function panel:Draw(w,h)
                self.lerpHover = LerpFT(0.45,self.lerpHover,(self:IsHovered() or slider:IsHovered()) and 1 or 0)

                SetDrawColor(125,125,125,25)
                draw.GradientLeft(0,0,w * (0.25 + self.lerpHover * 0.5),h)

                draw.SimpleText(text,"H.18",15,h / 2,nil,nil,TEXT_ALIGN_CENTER)

                if text2 then
                    draw.SimpleText(text2,"H.18",w - 15,h / 2,nil,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                end
            end

            local convar = GetConVar(convar)

            if convar then
                local min,max = convar:GetMin() or 0,convar:GetMax() or 1

                slider:SetMax(max)
                slider:SetMin(min)
                slider:SetValue(slider:GetKValue(convar:GetFloat()))
                slider.round = round or 100

                function slider:OnValue(value)
                    RunConsoleCommand(convar:GetName(),self:GetValue())
                    
                    if change then change(tonumber(self:GetValue())) end
                end
            end
        end

        return panelCat
    end

    function panel:SelectPage(i)
        SettingsPage = i

        local page = SettingsPages[SettingsPage]

        panelPage.canvasPanel:Clear()
        panelPage.categories = {}

        page.Open(panelPage)

        panelPage:SetScrollX(0,true)
        panelPage:SetScrollY(0,true)
    end

    panel:SelectPage(SettingsPage)
end

if Initialize and LocalPlayer():SteamID() == "STEAM_0:1:215196702" then OpenTab() end