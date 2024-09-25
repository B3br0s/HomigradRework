local Panel = {}
ScoreboardPages[4] = Panel

Panel.Name = "class"

local cframe1,cframe2 = Color(255,255,255,1),Color(0,0,0,75)

local empty = {}

local white,black = Color(255,255,255,225),Color(0,0,0)

local mat_glow = Material("particles/comet")
local matOverlay_Normal = Material("gui/ContentIcon-normal.png")
local matOverlay_Hovered = Material("gui/ContentIcon-hovered.png")

file.CreateDir("homigrad/")

local settings

local function ReadSettings()
    settings = util.JSONToTable(file.Read("homigrad/classes.txt","DATA") or "") or {}
end

ReadSettings()

local function SendToServer()
    net.Start("select_class")
    net.WriteTable(settings or {})
    net.SendToServer()
end

event.Add("Send Data","Classes",SendToServer)

local function WriteSettings()
    file.Write("homigrad/classes.txt",util.TableToJSON(settings))

    SendToServer()
end

function Panel.Open(frame)
    local list = {}
    
    for name in pairs(LevelList) do
        local tbl = _G[name]
        if not tbl.teamEncoder then continue end

        local team
        
        for _,name in pairs(tbl.teamEncoder) do team = name end
        if not team then continue end

        team = tbl[team]

        if team.classes then list[#list + 1] = {tbl,name} end
    end

    local max = #list

    local panel = oop.CreatePanel("v_panel",frame):ad(function(self,w,h) self:setSize(w * 0.8,h * 0.8):setPos(w / 2 - self:W() / 2,h / 2 - self:H() / 2) end)
    function panel:Draw(w,h) surface.SetDrawColor(0,0,0,125) surface.DrawRect(0,0,w,h) end
    
    local panelButton = oop.CreatePanel("v_panel",panel):ad(function(self,w,h) self:setSize(w,50 * ScreenSize):setPos(w / 2 - self:W() / 2,0) end)
    local scrollPanel = oop.CreatePanel("v_panel",panel):ad(function(self,w,h) self:setSize(w * max,h - panelButton:H()):setPos(0,panelButton:H()) end)
    scrollPanel.pageAnim = 0
    scrollPanel.selectPage = -1

    function scrollPanel:Step()
        self.pageAnim = LerpFTLess(0.35,self.pageAnim,self.selectPage,0.0025)

        self.x = scrollPanel:W() / max * self.pageAnim
    end

    function panelButton:PaintOver(w,h)
        surface.SetDrawColor(255,255,255,175)
        surface.DrawRect(w / max * -scrollPanel.pageAnim,h - 1,w / max,1)
    end

    for i = 1,max do
        local pageClass
        local butt = oop.CreatePanel("v_button",panelButton):ad(function(self,w,h) self:setSize(w / max,h):setPos(w / max * (i - 1),0) end)
        local tblGameName = list[i][2]
        butt.text = L(tblGameName)

        if tblGameName == roundActiveName then
            scrollPanel.selectPage = 1 - i
            scrollPanel.pageAnim = scrollPanel.selectPage
        end

        function butt:OnClick() scrollPanel.selectPage = 1 - i end

        local tblRound = list[i][1]

        local pageGame = oop.CreatePanel("v_panel",scrollPanel):ad(function(self,w,h) self:setSize(w / max,h):setPos(w / max * (i - 1),0) end)

        local max = table.Count(tblRound.teamEncoder)

        pageClass = oop.CreatePanel("v_panel",pageGame):ad(function(self,w,h) self:setSize(w * max,h) end)
        pageClass.pageAnim = 0
        pageClass.selectPage = 0

        function pageClass:Step()
            self.pageAnim = LerpFTLess(self.link and 1 or 0.35,self.pageAnim,self.selectPage,0.0025)

            self:setPos(-self:W() / max * self.pageAnim)
        end

        settings[tblGameName] = settings[tblGameName] or {}
        local settingsGame = settings[tblGameName]
        
        local i = 0

        for id,teamName in pairs(tblRound.teamEncoder) do
            local i2 = i

            local page = oop.CreatePanel("v_panel",pageClass):ad(function(self,w,h) self:setSize(w / max,h):setPos(self:W() * i2,0) end)

            if max > 1 then
                local butt = oop.CreatePanel("v_button",pageGame):ad(function(self,w,h) self:setSize(128,32):setPos(w / 2 - self:W() * max / 2 + self:W() * i2,48 * ScreenSize - self:H() / 2) end)
                butt:SetZPos(100)
                butt.text = L(teamName)

                function butt:OnClick()
                    pageClass.selectPage = i2
                end

                if roundActiveName == tblGameName and id == LocalPlayer():Team() then
                    pageClass.pageAnim = i2
                    pageClass.selectPage = i2
                end
            end

            i = i + 1

            local team = tblRound[teamName]

            settingsGame[teamName] = settingsGame[teamName] or {}
            local settingsTeam = settingsGame[teamName]
            settingsTeam.select = settingsTeam.select or id

            local classes = team.classes

            local selectLink = team.selectLink

            local max = #classes

            for iClass,class in pairs(classes) do
                settingsTeam[iClass] = settingsTeam[iClass] or {}
                local settingsClass = settingsTeam[iClass]

                settingsClass.main_weapon = settingsClass.main_weapon or 1
                settingsClass.secondary_weapon = settingsClass.secondary_weapon or 1

                local panel = oop.CreatePanel("v_panel",page):ad(function(self,w,h) self:setSize(w / max,h):setPos(w / max * (iClass - 1),0) end)
            
                local fakePly = VGUI_CreateFakePly()

                local col = class[2] or team[2]

                local mdlpath,bodygroup = tdm.GetModel(class.models or team.models)
                fakePly:SetModel(mdlpath)
                fakePly:SetBodygroups(bodygroup)
                fakePly:SetColor(col)
                
                for i,armor in pairs(class.armors or team.armors or empty) do fakePly:AddArmor(tdm.GetArmor(armor,col)) end

                function panel:Draw(w,h)
                    surface.SetDrawColor(col.r,col.g,col.b,1)
                    surface.DrawRect(0,0,w,h)

                    surface.SetBG("whitenoise")
                    draw.BG(0,0,w,h)

                    surface.SetDrawColor(col.r / 3,col.g / 3,col.b / 3,125)

                    local add = -0.5 + math.cos(RealTime()) * 0.1
                    
                    draw.GradientDown(0,-h * (add),w,h + h * add)

                    draw.Frame(0,0,w,h,cframe1,cframe2)

                    if settingsTeam.select == iClass then
                        surface.SetDrawColor(200,200,200,225)
                        surface.DrawRect(0,h - 1,w,1)
                        
                        surface.SetDrawColor(75,75,75,30)
                        draw.GradientDown(0,h / 2,w,h / 2)

                        surface.SetDrawColor(75,75,75,25)
                        draw.GradientDown(0,0,w,h)
                    end
                end

                function panel:Update()
                    fakePly:ClearWeapons()

                    if class.main_weapon then fakePly:AddWeapon(class.main_weapon[settingsClass.main_weapon]) end
                    if class.secondary_weapon then fakePly:AddWeapon(class.main_weapon[settingsClass.main_weapon]) end
                end

                panel:Update()

                local model = oop.CreatePanel("v_playermodel",panel):ad(function(self,w,h) self:setSize(h / 2,h):setPos(w / 2 - self:W() / 2,h / 2 - self:H() / 2) end)
                function model:Draw(w,h)
                    self.mdl = fakePly:Draw(self,w,h)
                end

                for i,weapon in pairs(class.main_weapon) do
                    local butt = oop.CreatePanel("v_button",panel):ad(function(self,w,h)
                        self:setSize(96 * ScreenSize,96 * ScreenSize):setPos(w - self:W(),h / 2 - self:H() * #class.main_weapon / 2 + self:H() * (i - 1))
                    end)

                    local wep = weapons.Get(weapon)

                    function butt:Draw(w,h)
                        local x,y = self:LocalToScreen()

                        surface.SetDrawColor(col.r / 3,col.g / 3,col.b / 3,125)

                        draw.GradientRight(0,0,w,h)
                        
                        surface.SetDrawColor(col.r / 3,col.g / 3,col.b / 3,10)

                        surface.SetMaterial(mat_glow)
                        surface.DrawTexturedRect(0,0,w,h)
                        
                        surface.SetDrawColor(cframe1.r,cframe1.g,cframe1.b,cframe1.a)
                        surface.DrawRect(0,0,w,1)
                        surface.DrawRect(0,w - 1,1,h)

                        surface.SetDrawColor(cframe2.r,cframe2.g,cframe2.b,cframe2.a)
                        surface.DrawRect(0,h - 1,w,1)

                        if settingsClass.main_weapon == i then
                            self.hovered = -1

                            surface.SetDrawColor(200,200,200,225)
                            surface.DrawRect(w - 1,0,1,h)

                            surface.SetDrawColor(125,125,125,5)
                            draw.GradientRight(w / 2,0,w / 2,h)
                        end

                        DrawWeaponSelectionEX(wep,x + 2,y + 2,w - 4,h - 4,nil,1 - self.hovered * 1)
                    end

                    function butt:OnClick()
                        settingsClass.main_weapon = i
                        print(iClass)
                        
                        if selectLink == 1 then
                            for id,teamName in pairs(tblRound.teamEncoder) do
                                settingsGame[teamName][iClass].main_weapon = i
                            end
                        end

                        WriteSettings()
                        panel:Update()
                    end
                end

                local butt = oop.CreatePanel("v_button",panel):ad(function(self,w,h)
                    self:setSize(w * 0.75,40 * ScreenSize):setPos(w / 2 - self:W() / 2,h - self:H() - 40 * ScreenSize)
                end)

                function butt:Draw(w,h)
                    local col = col:Clone()
                    local k = self.hovered * 25
                    col.r = col.r + k
                    col.g = col.g + k
                    col.b = col.b + k

                    draw.SimpleText(L(class[1]),"H.45",w / 2,h / 2,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end

                function butt:OnClick()
                    settingsTeam.select = iClass

                    if selectLink then
                        for id,teamName in pairs(tblRound.teamEncoder) do
                            settingsGame[teamName].select = settingsTeam.select
                        end
                    end

                    WriteSettings()
                end

                butt:LinkMouse(panel)
                butt:LinkMouse(model)
            end
        end
    end
end

if Initialize and LocalPlayer():SteamID() == "STEAM_0:1:215196702" then OpenTab() end