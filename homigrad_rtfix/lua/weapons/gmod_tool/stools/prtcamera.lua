TOOL.Category = "Render"
TOOL.Name = "#tool.prtcamera.name"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

TOOL.ClientConVar[ "locked" ] = "0"
TOOL.ClientConVar[ "showId" ] = "0"
TOOL.ClientConVar[ "id" ] = "none"
TOOL.ClientConVar[ "model" ] = "models/props_c17/tv_monitor01.mdl"
TOOL.ClientConVar[ "drawScreens" ] = "1" -- Hides all screens                                                                TODO: Hide other players screens
--TOOL.ClientConVar[ "drawSelfScreens" ] = "1" --                                                                            TODO: Hide your own screens
TOOL.ClientConVar[ "scrollLines" ] = "0" --                                                                                  TODO: Refreshes when reloading renderTargets, make it refresh instantly, add wire input to screens
TOOL.ClientConVar[ "pvs" ] = "1" -- add the camera belonging to the nearest display to the player's PVS.
--This allows cameras to render the scenes around them properly but can have a performance impact for VERY large servers.
TOOL.ClientConVar[ "fov" ] = "80"
TOOL.ClientConVar[ "refreshRate" ] = "10" -- curTime() + ( 1 / RefreshRate) = Hz rate of screens
TOOL.ClientConVar[ "drawRange" ] = "500" -- Tied to PVS Range
TOOL.ClientConVar[ "resolution" ] = "512" -- Requires restart,                                                               TODO: make it refresh instantly, add wire input to screens


cleanup.Register( "rtcameras" )
cleanup.Register( "rtmonitors" )

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	--Preset Box
	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "adv_rt_cameras", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "textbox", { Label = "#tool.prtcamera.id", Command = "prtcamera_id" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.prtcamera.showId", Command = "prtcamera_showId", Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.camera.static", Command = "prtcamera_locked", Help = true } )

		--Scroll Lines effect
		CPanel:AddControl( "CheckBox", { Label = "#tool.prtcamera.scrollLines", Command = "prtcamera_scrollLines", Help = true } )

		----Performance Settings Category
		--[[
		local Category1 = vgui.Create("DCollapsibleCategory")
		CPanel:AddItem(Category1)
		Category1:SetLabel("Performance Settings")
		Category1:SetExpanded(0)

		local CategoryContent1 = vgui.Create( "DPanelList" )
		CategoryContent1:SetAutoSize( true )
		CategoryContent1:SetDrawBackground( false )
		CategoryContent1:SetSpacing( 3 )
		CategoryContent1:SetPadding( 2 )
		Category1:SetContents( CategoryContent1 )
		CategoryContent1.OnMouseWheeled = function(self, dlta) parent:OnMouseWheeled(dlta) end
		]]--


		--Hide screens
		CPanel:AddControl( "CheckBox", { Label = "#tool.prtcamera.drawScreens", Command = "prtcamera_drawScreens", Help = true } )
		

		--Camera PVS
		CPanel:AddControl( "CheckBox", { Label = "#tool.prtcamera.pvs", Command = "prtcamera_pvs", Help = true } )

		--FOV Slider
		CPanel:AddControl( "Slider", { Type = "integer", Label = "#tool.prtcamera.fov", Command = "prtcamera_fov", min = 10, max = 120, Help = true } )

		--RefreshRate Slider
		  CPanel:AddControl( "slider", { Type = "integer", Label = "#tool.prtcamera.refreshRate", Command = "prtcamera_refreshRate", Min = 10, Max = 80, Help = true } )

		--Draw Range Slider
		CPanel:AddControl( "Slider", { Type = "integer", Label = "#tool.prtcamera.drawRange", Command = "prtcamera_drawRange", min = 200, max = 10000, Help = true } )

		--Resolution Slider
		CPanel:AddControl( "slider", { Type = "Integer", Label = "#tool.prtcamera.resolution", Command = "prtcamera_resolution",  Min = 256, Max = 1024, Help = true } )
	
	
	CPanel:AddControl( "PropSelect", { Label = "#tool.prtcamera.model", ConVar = "prtcamera_model", Height = 5, Models = list.Get( "RTMonitorModels" ) } )
end

if CLIENT then
	language.Add('tool.prtcamera.name', 'Advanced RT Camera')
	language.Add('tool.prtcamera.model', 'RT Display Model')
	language.Add('tool.prtcamera.id', 'RT Camera ID')
	language.Add('tool.prtcamera.showId', 'Show Camera ID')
	language.Add('tool.prtcamera.showId.help', 'Display the camera\'s id on screens')

		--Scroll Lines effect
		language.Add('tool.prtcamera.scrollLines', 'Scan Line Effect')
		language.Add('tool.prtcamera.scrollLines.help', 'Displays a scan line effect on monitors')

		--Hide screens
		language.Add('tool.prtcamera.drawScreens', 'Render Screens')
		language.Add('tool.prtcamera.drawScreens.help', 'Disable for performance')

		--Camera PVS
		language.Add('tool.prtcamera.pvs', 'Camera PVS')
		language.Add('tool.prtcamera.pvs.help', 'This allows cameras to render scenes around them properly\n(Highly recommended to keep this on!)')

		--FOV Slider
		language.Add('tool.prtcamera.fov', 'Field of View')
		language.Add('tool.prtcamera.fov.help', 'Sets the Field Of View of new cameras')

		--RefreshRate Slider
		language.Add('tool.prtcamera.refreshRate', 'Refresh Rate')
		language.Add('tool.prtcamera.refreshRate.help', 'Sets the Hz rate of screens\n(Performance Heavy!)')

		--Draw Range Slider
		language.Add('tool.prtcamera.drawRange', 'Draw Range')
		language.Add('tool.prtcamera.drawRange.help', 'Sets the range that screens will render\n(Performance Heavy!)')

		--Resolution Slider
		language.Add('tool.prtcamera.resolution', 'Monitor Resolution')
		language.Add('tool.prtcamera.resolution.help', 'Sets the display resolution of screens\n(Requires restart!)')

	--Help display
	language.Add('tool.prtcamera.desc', 'Allows you to place RT Cameras and their displays')
	language.Add( "tool.prtcamera.left", "Create a RT Camera")
	language.Add( "tool.prtcamera.right", "Place a Monitor")
end

local SendNotification
if SERVER then
	util.AddNetworkString('rtcamera.alert')
	function SendNotification(player, message)
		net.Start('rtcamera.alert')
		net.WriteString(message)
		net.Send(player)
	end
else
	function SendNotification() end
	net.Receive('rtcamera.alert', function()
		local message = net.ReadString()
		Derma_Message(message, 'RT Camera', 'Ok')
	end)
end

local function CheckLimits(player, class)
	local count = 0
	for k,v in ipairs(ents.FindByClass(class)) do
		if v:GetPlayer() == player then
			count = count + 1
		end
	end
	return count
end


local function IsCameraIDAcceptable(player, id)
	if id:len() > 20 then
		SendNotification(player, "Camera ID is too long, please provide a shorter id. (less than 20 letters).")
		return false
	end
	if id:len() < 3 then
		SendNotification(player, "Camera ID is too short, please provide a longer id. (at least 3 letters).")
		return false
	end
	for k,v in ipairs(ents.FindByClass('gmod_rtcameraprop')) do
		if v:GetID() == id then
			if v:GetPlayer() then
				SendNotification(player, "Sorry, but this Camera ID is already in use! You'll need to use a different one.")
				return false
			end
		end
	end
	return true
end

local function MakeCamera( ply, locked, id, fov, Data )
	local ent = ents.Create( "gmod_rtcameraprop" )

	if ( not IsValid( ent ) ) then return end

	duplicator.DoGeneric( ent, Data )

	if id then
		ent:SetID(id)
	end
	if fov then
        	ent:SetFOV( math.Clamp( fov, 10, 120 ) )
    end
	ent:SetPlayer( ply )


	ent.locked = locked

	ent:Spawn()

	ent:SetTracking( NULL, Vector( 0 ) )
	ent:SetLocked( locked )

	if ( IsValid( ply ) ) then
		undo.Create( "RT Camera" )
			undo.AddEntity( ent )
			undo.SetPlayer( ply )
		undo.Finish()

		ply:AddCleanup( "rtcameras", ent )
	end

	return ent
end
duplicator.RegisterEntityClass( "gmod_rtcameraprop", MakeCamera, "locked", "ID", "FOV", "Data" )

local function MakeMonitor( ply, trace, model, id, Data )
    local ent = ents.Create( "gmod_rttv" )

    if (not IsValid( ent ) ) then return end

    if id then
        ent:SetID(id)
    end
    if model then
        ent:SetModel(model)
    end
    if trace then
        Data.Pos = trace.HitPos + trace.HitNormal * math.abs(ent:OBBMins().x)
        Data.Angle = trace.HitNormal:Angle()
        Data.Angle:RotateAroundAxis(Data.Angle:Forward(), 180)
        Data.Angle:RotateAroundAxis(Data.Angle:Right(), 180)
        Data.Angle:RotateAroundAxis(Data.Angle:Up(), 180)
    end

    duplicator.DoGeneric( ent, Data )
    ent:SetPlayer( ply )
    ent:Spawn()

    if ( IsValid( ply ) ) then
        undo.Create( "RT Monitor" )
            undo.AddEntity( ent )
            undo.SetPlayer( ply )
        undo.Finish()

        ply:AddCleanup( "rtmonitors", ent )
    end

    return ent
end
duplicator.RegisterEntityClass( "gmod_rttv", MakeMonitor, "trace", "Model", "ID", "Data" )

function TOOL:LeftClick( trace )
	if not IsFirstTimePredicted() then return end

	local id = self:GetClientInfo("id")
	local fov = self:GetClientNumber("fov")
	if ( CLIENT ) then return IsCameraIDAcceptable(self:GetOwner(), id) end

	local ply = self:GetOwner()
	local locked = self:GetClientNumber( "locked" )

	if not IsCameraIDAcceptable(self:GetOwner(), id) then return false end
	if CheckLimits(ply, 'gmod_rtcameraprop') >= rtcam.maxCamsPerPlayer then SendNotification(ply, "Exceeded maximum number of cameras (" .. rtcam.maxCamsPerPlayer .. ")") return false end

	local ent = MakeCamera( ply, locked, id, fov, { Pos = trace.StartPos, Angle = ply:EyeAngles() } )

	return true, ent
end

function TOOL:RightClick( trace )
	if CLIENT then return true end
	if not IsFirstTimePredicted() then return end

	local ply = self:GetOwner()
	local id = self:GetClientInfo('id')

	if CheckLimits(ply, 'gmod_rttv') >= rtcam.maxMonitorsPerPlayer then SendNotification(ply, "Exceeded maximum number of monitors (" .. rtcam.maxMonitorsPerPlayer .. ")") return false end

	local model = self:GetClientInfo("model")
	if not list.Get("RTMonitorModels")[model] then return false end
	local ent = MakeMonitor( ply, trace, model, id, {} )
	ent:SetModel(self:GetClientInfo("model"))

	if tonumber(self:GetClientNumber("showId")) > 0 then
		ent:SetShowID(true)
	end

	return true, ent
end



 -- Ghost monitor placement
if (SERVER) then

	function MakePrtMonitor( pl, Pos, Model, Ang )
		if ( !pl:CheckLimit( "prt_monitor" ) ) then return false end
	
		local prt_monitor = ents.Create( "gmod_prt_monitor" )
		if (!prt_monitor:IsValid()) then return false end

		prt_monitor:SetAngles( Ang )
		prt_monitor:SetPos( Pos )
		prt_monitor:SetModel( Model )
		prt_monitor:Spawn()

		prt_monitor:SetPlayer( pl )

		local ttable = {
		    pl = pl
		}
		table.Merge(prt_monitor:GetTable(), ttable )
		
		pl:AddCount( "prt_monitor", prt_monitor )

		return prt_monitor
	end
	
	duplicator.RegisterEntityClass("gmod_prt_monitor", MakePrtMonitor, "Pos","Model", "Ang", "Vel", "aVel", "frozen")

end

function TOOL:UpdateGhostPrtMonitor( ent, player )
	if ( !ent || !ent:IsValid() ) then return end

	local tr 	= util.GetPlayerTrace( player, player:GetAimVector() )
	local trace 	= util.TraceLine( tr )

	if (!trace.Hit || trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_prt_monitor" ) then
		ent:SetNoDraw( true )
		return
	end

	local Ang = trace.HitNormal:Angle()
	-- TODO: add createflat function
	--Ang.pitch = Ang.pitch + 90 -- fixes some props but breaks the rest
	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles( Ang )

	ent:SetNoDraw( false )
end

function TOOL:Think()
	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self:GetClientInfo("Model") ) then
		self:MakeGhostEntity( self:GetClientInfo("Model"), Vector(0,0,0), Angle(0,0,0) )
	end

	self:UpdateGhostPrtMonitor( self.GhostEntity, self:GetOwner() )
end