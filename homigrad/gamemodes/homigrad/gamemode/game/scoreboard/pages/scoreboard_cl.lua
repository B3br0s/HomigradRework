local Panel = {}
ScoreboardPages[1] = Panel

Panel.Name = "scoreboard"

local SetDrawColor,DrawRect = surface.SetDrawColor,surface.DrawRect

local delaySend = 0

local specColor = Color(155,155,155)
local white = Color(255,255,255,255)
local colorSpec = Color(155,155,155)
local colorRed = Color(205,55,55)
local colorGreen = Color(55,205,55)

ScoreboardRed = colorRed
ScoreboardSpec = colorSpec
ScoreboardGreen = colorGreen
ScoreboardBlack = Color(0,0,0,200)

local function timeSort(a,b)
	return a:GetNWFloat("Time") > b:GetNWFloat("Time",-1)
end


local unmutedicon = Material( "icon32/unmuted.png", "noclamp smooth" )
local mutedicon = Material( "icon32/muted.png", "noclamp smooth" )

local function ReadMuteStatusPlayers()
	return util.JSONToTable(file.Read("homigrad_mute.txt","DATA") or "") or {}
end

MutePlayers = ReadMuteStatusPlayers()

local function SaveMuteStatusPlayer(ply,value)
	if value == false then value = nil end
	MutePlayers[ply:SteamID()] = value
	file.Write("homigrad_mute.txt",util.TableToJSON(MutePlayers))
end

local green = Color(75,255,75)

local mat_loading = Material("homigrad/vgui/loading.png")

local history = {}

function Panel.Open(panelPage)
    local panel = oop.CreatePanel("v_panel",panelPage):setSize(panelPage:W() * 0.85,panelPage:H() * 0.85)
    panel:setPos(panelPage:W() / 2 - panel:W() / 2,panelPage:H() / 2 - panel:H() / 2)

    ScroreboardPlayersPanel = panel
    
    function panel:Draw(w,h)
        SetDrawColor(0,0,0,100 * ScoreboardClose)
        DrawRect(0,0,w,h)

        local tick = math.Round(1 / engine.ServerFrameTime())

        local W = 1

        history[#history + 1] = tick

        surface.SetDrawColor(0,255,0,5)

        for i = 1,#history do
            local v = history[i] / h * 100

            surface.DrawRect(W * i,h - v + 1,W,v)
        end

        if #history > w / W then table.remove(history,1) end

        draw.SimpleText(L("scoreboard_status"),"H.18",125,15,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(L("scoreboard_name"),"H.18",w / 2,15,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        draw.SimpleText(L("scoreboard_played"),"H.18",w - 350,15,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        --draw.SimpleText("Дни Часы Минуты","H.18",w - 300,20,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        --draw.SimpleText("M","H.18",w - 300 + 15,15,white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(L("scoreboard_ping"),"H.18",w - 250,15,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(L("scoreboard_team"),"H.18",w - 125,15,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(L("scoreboard_players",table.Count(player.GetAll())),"H.18",15,h - 25,green,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText(L("scoreboard_tickrate",tick),"H.18",w - 15,h - 25,tick <= 35 and red or green,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        --shittttt
    end

    function panel:Sort()
        local teams = {}
        local lives,deads = {},{}

        for i,ply in pairs(player.GetAll()) do
            ply.last = nil

            local teamID = ply:Team()
            teams[teamID] = teams[teamID] or {{},{}}
            teamID = teams[teamID]

            local func = TableRound().Scoreboard_Status
            if func then alive,alivecol,colorAdd = func(ply) end

            if ply:Alive() then
                teamID[1][#teamID[1] + 1] = ply
            else
                teamID[2][#teamID[2] + 1] = ply
            end
        end

        for teamID,list in pairs(teams) do
            table.sort(list[1],timeSort)
            table.sort(list[2],timeSort)
        end

        local sort = {}

        local func = TableRound().ScoreboardSort
        if func then
            func(sort)
        else
            for teamID,team in pairs(teams) do
                for i,ply in pairs(team[1]) do sort[#sort + 1] = ply end
                for i,ply in pairs(team[2]) do sort[#sort + 1] = ply end

                local last = team[1][#team[1]]
                if last then
                    local func = TableRound().Scoreboard_DrawLast
                    if func and func(last) ~= nil then continue end

                    last.last = #team[1]
                end

                last = team[2][#team[2]]
                if last then
                    local func = TableRound().Scoreboard_DrawLast
                    if func and func(last) ~= nil then continue end

                    last.last = #team[2]
                end
            end
        end

        self.sort = sort
    end

    local scroll = oop.CreatePanel("v_scrollpanel",panel):ad(function(self) self:setPos(0,30):setSize(panel:W(),panel:H() - 100) end)
    scroll.scrollMul = 3

    function panel:Update()
        scroll:Clear()
        self:Sort()

        for i,ply in pairs(self.sort) do
            i = i - 1

            local panel = oop.CreatePanel("v_panel",scroll):ad(function(self)
                self:setSize(panel:W(),50 * ScreenSize):setPos(0,self:H() * i)
            end)


            panel = oop.CreatePanel("v_panel",panel):setDSize(1,1)

			local alive
			local alivecol
			local colorAdd

            function panel:Draw(w,h)
                if not IsValid(ply) then return end

                SetDrawColor(0,0,0,100)
                DrawRect(0,0,w,h)

                if self:IsHovered() then
                    SetDrawColor(125,125,125,5)
                    DrawRect(0,0,w,h)
                end

                local func = TableRound().Scoreboard_Status
                
                if func then
                    alive,alivecol,colorAdd = func(ply)
                end
    
                if not func or (not alive) then
                    if ply:Alive() then
                        alive = "scoreboard_live"
                        alivecol = colorGreen
                    elseif ply:Team() == 1002 then
                        alive = "scoreboard_spectate"
                        alivecol = colorSpec
                    else
                        alive = "scoreboard_dead"
                        alivecol = colorRed
                        colorAdd = colorRed
                    end
                end

                if colorAdd then
					SetDrawColor(colorAdd.r,colorAdd.g,colorAdd.b,5)
					DrawRect(0,0,w,h)
				end

				if ply == LocalPlayer() then
					SetDrawColor(255,255,255,1)
					DrawRect(0,0,w,h)
				end

                local color,mat = ply:GetNameColor()

				if mat then
					surface.SetDrawColor(255,255,255)
					surface.SetMaterial(mat)
					surface.DrawTexturedRectRotated(w  / 2 / 2,h / 2,16,16,0)
				end

				draw.SimpleText(L(alive),"H.18",125,h / 2,alivecol,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText(ply:Name(),"H.18",w / 2,h / 2,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				
                local time = (ply:IsBot() and 0) or ply:GetNWInt("Time",-1)

				if time == -1 then
                    surface.SetMaterial(mat_loading)
                    surface.SetDrawColor(255,255,255,125)
                    surface.DrawTexturedRectRotated(w - 350,h / 2,h * 0.5,h * 0.5,CurTime() * 360)
				else
					time = math.floor(time + (CurTime() - ply:GetNWFloat("TimeStart",0)))
					local dTime,hTime,mTime = math.floor(time / 60 / 60 / 24),tostring(math.floor(time / 60 / 60) % 24),tostring(math.floor(time / 60) % 60)

					draw.SimpleText(dTime .. "d","H.18",w - 350 - 25,h / 2,white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
					draw.SimpleText(hTime .. "h","H.18",w - 350,h / 2,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
					draw.SimpleText(mTime .. "m","H.18",w - 350 + 25,h / 2,white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				end
				
				draw.SimpleText(ply:Ping(),"H.18",w - 250,h / 2,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

				local name,color = ply:PlayerClassEvent("TeamName")

				if not name then
					name,color = TableRound().GetTeamName(ply)
					name = name or "spectate"
					color = color or ScoreboardSpec
				end

				draw.SimpleText(L(name),"H.18",w - 125,h / 2,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end

            local avatar = vgui.Create("AvatarImage",panel)
            avatar:SetPlayer(ply,128)--govno fuuu

            function avatar:PaintOver(w,h) draw.Frame(0,0,w,h,cframe1,cframe2) end

            panel:ad(function(self) avatar:SetSize(panel:H(),panel:H()) end)

            if ply ~= LocalPlayer() then
				local butt = oop.CreatePanel("v_button",panel):ad(function(self) self:setSize(panel:H() * 0.75,panel:H() * 0.75):setPos(panel:W() - self:H() * 1.25,panel:H() / 2 - self:H() / 2) end)

				function butt:Draw(w,h)
					surface.SetMaterial(ply:IsMuted() and mutedicon or unmutedicon)
					surface.SetDrawColor(255,255,255,255)

                    DisableClipping(true)
                    local s = (self:IsHovered() and h + 8) or (self:IsDown() and h - 8) or h
					surface.DrawTexturedRectRotated(w / 2,h / 2,s,s,0)
                    DisableClipping(false)
				end

				function butt:OnMouse(key,value)
                    if not value then return end

					ply:SetMuted(not ply:IsMuted())
					SaveMuteStatusPlayer(ply,ply:IsMuted())
				end
			end

            function panel:OnMouse(key,value)
                if not value or key ~= MOUSE_RIGHT then return end

                local menu = DermaMenu() 
                menu:AddOption(L("copy_steamid"),function()
                    SetClipboardText(ply:SteamID())
                    LocalPlayer():ChatPrint(ply:SteamID())
                end)
                
                menu:AddOption(L("open_profile"),function() ply:ShowProfile() end)
                menu:Open()
            end
        end
    end

    panel:Update()

    local butt = oop.CreatePanel("v_button",panel):ad(function(self) self:setSize(125 * ScreenSize,25 * ScreenSize):setPos(panel:W() / 2 - self:W() - 16,panel:H() - self:H() - 16) end)
    butt.text = L("scoreboard_muteall")

    function butt:OnMouse(key,value)
        if not value then return end

        MuteAll = not MuteAll
        butt.textColor = MuteAll and green or white

        UpdateVoiceVolumeScale()
    end
    butt.textColor = MuteAll and green or white

    local butt = oop.CreatePanel("v_button",panel):ad(function(self) self:setSize(125 * ScreenSize,25 * ScreenSize):setPos(panel:W() / 2 + 16,panel:H() - self:H() - 16) end)
    butt.text = L("scoreboard_mutedead")

    function butt:OnMouse(key,value)
        if not value then return end

        MuteAllDeath = not MuteAllDeath
        butt.textColor = MuteAllDeath and green or white

        UpdateVoiceVolumeScale()
    end
    butt.textColor = MuteAllDeath and green or white
end

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect","Scoreboard Players",function()
    if IsValid(ScroreboardPlayersPanel) then ScroreboardPlayersPanel:Update() end
end)

gameevent.Listen("player_spawn")
hook.Add("player_spawn","Scoreboard Players",function()
    if IsValid(ScroreboardPlayersPanel) then ScroreboardPlayersPanel:Update() end
end)

event.Add("Voice Volume","MuteAll",function(ply,value)
    if MuteAll then value[1] = 0 return false end
end)

event.Add("Voice Volume","MuteAllDeath",function(ply,value)
    if MuteAllDeath and not ply:Alive() then value[1] = 0 return false end
end)

if Initialize and LocalPlayer():SteamID() == "STEAM_0:1:215196702" then OpenTab() end