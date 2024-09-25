local Panel = ScoreboardPages[3] or {}
ScoreboardPages[3] = Panel

Panel.Name = "team"

local empty = {}

local example = {}

function example:AddArmor(armor,col)
    local tbl = self.EZarmor.items

    tbl[#tbl + 1] = {
        name = JMod.ArmorValidName(armor),
        col = col
    }

    self.EZarmorRender = JMod_ArmorSetupRender(tbl)
end

function example:ClearArmors()
    self.EZarmor.items = {}

    self.EZarmorRender = {}
end

local example_wep = {}

function example_wep:GetNWString(key,fallback) return fallback end
function example_wep:GetNWFloat(key,fallback) return fallback end

function example:AddWeapon(wep)
    local tbl = weapons.Get(wep)
    if not tbl then return end
    
    for k,v in pairs(example_wep) do tbl[k] = v end
    
    self.list[#self.list + 1] = tbl
end

function example:ClearWeapons() self.list = {} end

function example:SetColor(color) self.color = color:ToVector() end

function example:SetBodygroups(list)
    self.bodygroups = list

    local mdl = self.mdl

    if not IsValid(mdl) then return end

    for i,value in pairs(self.bodygroups) do mdl:SetBodygroup(i,value) end
end

function example:DrawModel(mdl)
    mdl:DrawModel()
end

function example:Draw(panel,w,h,fov)
    local x,y = panel:LocalToScreen()
    
    local mdl

    CreateScrene(x,y,w,h,27 + (fov or 0),Vector(110,0,35),Angle(0,180,0),1,512)
        mdl,isCreate = GetClientSideModelID(self.mdlpath,tostring(self))

        if isCreate then
            mdl.id = tostring(self)
            mdl.GetPlayerColor = function() return self.color end
            mdl:SetIK(false)

            self.mdl = mdl

            self:SetBodygroups(self.bodygroups)
        end

        mdl:ResetSequence(mdl:LookupSequence("walk_all"))

        self:DrawModel(mdl)

        JMod.ArmorPlayerModelDraw(self,mdl)
        render.SetColorModulation(1,1,1)
        DrawPlayerBackWeapons(self,mdl)
    CloseScene()

    return mdl
end

function example:SetModel(mdlpath) self.mdlpath = mdlpath end

function VGUI_CreateFakePly()
    local fakePly

    fakePly = {
        list = {},
        GetActiveWeapon = function() end,
        GetWeapons = function() return fakePly.list end,
        EZarmor = {items = {}}
    }

    for k,v in pairs(example) do fakePly[k] = v end

    return fakePly
end

function Panel.Open(frame)
    function frame:Draw(w,h)
        draw.SimpleText(L("select_team"),"H.25",w / 2,h * 0.125,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    local tbl = TableRound()
    local max = table.Count(tbl.teamEncoder)

    local w,h = ScrW(),ScrH()
    local panel = oop.CreatePanel("v_panel",frame):ad(function(self,w,h) self:setSize(325 * max * ScreenSize,655 * ScreenSize):setPos(w / 2 - self:W() / 2,h / 2 - self:H() / 2) end)

    function panel:Draw(w,h)
        surface.SetDrawColor(15,15,15,200)
        surface.DrawRect(0,0,w,h)

        draw.Frame(0,0,w,h,cframe1,cframe2)
    end
    
    local num = 0

    for i,name in pairs(tbl.teamEncoder) do
        local team = tbl[name]
        local col = team[2]

        num = num + 1
        local numm = num

        local butt = oop.CreatePanel("v_panel",panel):ad(function(self,w,h)
            local x = 10

            for i,child in pairs(panel:GetChildren()) do
                child:setSize(w / max - (i == 1 and 20 or 0),h - 20):setPos(x,10)
                x = x + child:W()
            end
        end)
        
        local copy = {}
        for k,v in pairs(team) do copy[k] = v end
        team = copy
        
        local func = TableRound().TeamTab_Team
        if func then func(team) end

        butt.hovered = 0
        butt.down = 0

        local list = {}

        local fakePly = VGUI_CreateFakePly()

        local wepMain = team.main_weapon and team.main_weapon[math.random(1,#team.main_weapon)]
        if wepMain then fakePly:AddWeapon(wepMain) end

        local wepSecondary = team.secondary_weapon and team.secondary_weapon[math.random(1,#team.secondary_weapon)]
        if wepSecondary then fakePly:AddWeapon(wepSecondary) end

        for i,class in pairs(team.weapons or empty) do fakePly:AddWeapon(class) end
        for i,armor in pairs(team.armors or empty) do fakePly:AddArmor(tdm.GetArmor(armor,col)) end

        local mdlpath,bodygroups = tdm.GetModel(team.models)

        fakePly:SetModel(mdlpath)
        fakePly:SetBodygroups(bodygroups)
        fakePly:SetColor(col)

        function butt:Draw(w,h)
            surface.SetDrawColor(15,15,15,200)
            surface.DrawRect(0,0,w,h)
    
            draw.Frame(0,0,w,h,cframe2,cframe2)

            local isMyTeam = i == LocalPlayer():Team()

            self.hovered = LerpFT(0.25,self.hovered,not isMyTeam and self:IsHovered() and 1 or 0)
            self.down = LerpFT(0.5,self.down,not isMyTeam and self:IsDown() and 1 or 0)

            surface.SetDrawColor(col.r,col.g,col.b,25 + self.hovered * 55)
            
            local size = h / 1.25 + h / 3 * math.cos(CurTime())
            draw.GradientDown(0,h - size,w,size)

            surface.SetDrawColor(255,255,255,self.down * 2)
            surface.DrawRect(0,0,w,h)

            if isMyTeam then
                surface.SetDrawColor(0,0,0,175)
                surface.DrawRect(0,0,w,h)
                
                surface.SetDrawColor(255,255,255,175)
                surface.DrawRect(0,h - 1,w,1)
            end

            fakePly.DrawModel = function(self,mdl)
                if max == 2 then
                    mdl:SetRenderAngles(Angle(0,i == 2 and 2 or -2,0))
                else
                    mdl:SetRenderAngles(Angle(0,0,0))
                end

                mdl:DrawModel()
            end

            fakePly:Draw(self,w,h,-self.hovered)

            draw.SimpleText(L(team[1]),"H.18",w / 2,h - 25,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        function butt:OnMouse(key,value)
            if not value then return end

            net.Start("want change team")
            net.WriteString(tostring(i))
            net.SendToServer()
        end
    end

    local butt = oop.CreatePanel("v_button",frame):ad(function(self,w,h) self:setSize(325* ScreenSize,50 * ScreenSize):setPos(w / 2 - self:W() / 2,panel.y + panel:H() + 5) end)
    butt.text = L("spectator")

    function butt:OnMouse(key,value)
        if not value then return end

        net.Start("want change team")
        net.WriteString("1002")
        net.SendToServer()
    end
end

net.Receive("want change team",function()
    CloseTab()

    surface.PlaySound("buttons/blip1.wav")

    timer.Simple(0.1,function()
        local ply = LocalPlayer()

        ply:ChatPrint(L("you_select_team",L(TableRound().GetTeamName(ply)) or L("spectators")))
    end)--pizsed
end)

if Initialize and LocalPlayer():SteamID() == "STEAM_0:1:215196702" then OpenTab() end

concommand.Add("hg_showteam",function()
    if not ScoreboardStatus then OpenTab() end
    
    ScoreboardFrame:SelectPage(3)
end)