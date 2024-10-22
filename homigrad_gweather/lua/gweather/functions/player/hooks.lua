if (SERVER) then

	local load_queue = {}  -- thanks wiki

	hook.Add( "PlayerInitialSpawn", "gWeather.PlayerLoad.IS", function( ply ) -- sometimes this doesn't recieve well
		load_queue[ply] = true
	end )

	hook.Add( "StartCommand", "gWeather.PlayerLoad.TempAtmosphere", function( ply, cmd )
		if load_queue[ply] and not cmd:IsForced() then
			load_queue[ply] = nil

			ply.gWeather=ply.gWeather or {}
			ply.gWeather.Temperature=ply.gWeather.Temperature or 37		

			net.Start("gw_atmosphere")	
				net.WriteString(tostring(gWeather.Atmosphere.Wind.Direction))	
				net.WriteFloat(gWeather.Atmosphere.Wind.Speed)
				net.WriteFloat(gWeather.Atmosphere.Wind.Angle)
				net.WriteFloat(gWeather.Atmosphere.Temperature)
				net.WriteFloat(gWeather.Atmosphere.Humidity)
				net.WriteFloat(gWeather.Atmosphere.Precipitation)
			net.Send(ply)
			
		end
	end )

	hook.Add( "PostPlayerDeath", "gWeather.Temperature.PostPlayerDeath", function(ply)
		if !ply.gWeather then return end
		ply.gWeather.Temperature=37
	end)
	
end

if (CLIENT) then

	local cvar = CreateClientConVar("hg_gwinfo","0",true,false,"Обэмэ",0,1)

	local color_red = Color(255,0,0)
	local color_blue = Color(100,100,255)

	hook.Add( "HUDPaint", "gWeather.DebugAtmosphere", function()
		if not LocalPlayer():IsSuperAdmin() then return end
		if gWeather.Atmosphere==nil then return end
		if not cvar:GetBool() then return end

		local temp,localtemp,tempunit=gWeather:GetTemperature(),LocalPlayer():GetNWFloat("gWeatherLocalTemperature")," °C"
		local wind,localwind,windunit=gWeather:GetWindSpeed(),LocalPlayer():GetNWFloat("gWeatherLocalWind")," km/h"

		if GetConVar("gw_hud_temp"):GetString()!="celsius" then temp=gWeather.cTo("f",temp) localtemp=gWeather.cTo("f",localtemp) tempunit=" °F" end
		if GetConVar("gw_hud_wind"):GetString()!="km/h" then wind=gWeather.kmhTo("mph",wind) localwind=gWeather.kmhTo("mph",localwind) windunit=" mph" end
		
		surface.SetDrawColor( 0, 0, 0, 128 )
		surface.DrawRect( 20, 10, 400, 100 )
		
		local actual_wind = gWeather:GetWindSpeed()
		
		local windcol = color_white
		if actual_wind > 150 then windcol = windcol:Lerp( color_red, math.min(1,(actual_wind-150)/156) ) end
		
		local function bigwind(str)
			if actual_wind > 256 then 
				str = table.Random({str,"ERROR","ERROR"}) -- homage
			end
			return str
		end
		
		draw.SimpleText( "Wind Direction: "..util.TypeToString( gWeather:GetWindDirection()), "HomigradFontInv", 50, 25, color_white )
		draw.SimpleText( "Wind Speed: "..bigwind(util.TypeToString(math.Round(wind,2))).. windunit, "HomigradFontInv", 50, 50, windcol )
		draw.SimpleText( "Local Wind: "..bigwind(math.Round(localwind,2)).. windunit, "HomigradFontInv", 50, 75, windcol )

		local tempcol = color_white
		local actual_temp = LocalPlayer():GetNWFloat("gWeatherLocalTemperature")
		if actual_temp < 35 then tempcol = tempcol:Lerp( color_blue, math.min(1,(35-actual_temp)/2) ) end
		if actual_temp > 41 then tempcol = tempcol:Lerp( color_red, math.min(1,(actual_temp-41)/2) ) end


		draw.SimpleText( "Temperature: "..util.TypeToString(math.Round(temp,2)).. tempunit, "HomigradFontInv", 250, 25, color_white )
		draw.SimpleText( "Local Temperature: "..util.TypeToString(math.Round(localtemp,2)).. tempunit, "HomigradFontInv", 250, 50, tempcol )
		draw.SimpleText( "Humidity: "..util.TypeToString( math.Round(gWeather:GetHumidity(),2) ).."%", "HomigradFontInv", 250, 75, color_white )
		
	end )
	
	--timer.Create( "gWeather.LocalPlayer.Tick.OutsideFactor", 0.05, 0, function()
	hook.Add("Think","gWeather.LocalPlayer.Tick.OutsideFactor",function()
		if gWeather.Atmosphere==nil then return end
		if LocalPlayer().gWeather==nil then return end

		local bounds = gWeather:GetWindLocalBounds()
		if istable(bounds) and LocalPlayer():EyePos():WithinAABox( bounds[1], bounds[2] )==false then 
			local pos,b2 = LocalPlayer():GetPos(),bounds[2]
			local wind_dir = gWeather:GetWindDirection()
		
			if (pos*wind_dir).x<(b2*wind_dir).x or (pos*wind_dir).y<(b2*wind_dir).y then LocalPlayer().gWeather.OutsideFactor= 100 - (pos.z-b2.z)/50 return end -- must be above

			local dist = (((pos-b2)*wind_dir):Length()/10000)
			if pos.z>b2.z then dist=dist+(pos.z-b2.z)/5000 end

			LocalPlayer().gWeather.OutsideFactor = math.max( 1 - math.max(math.abs(dist),0), 0) * 100
			return 
		end
	
		if gWeather.IsOutside(LocalPlayer(),true) then
			if LocalPlayer():InVehicle() then
				local veh=LocalPlayer():GetVehicle()
				if !veh:GetThirdPersonMode() and veh:GetClass()!="prop_vehicle_prisoner_pod" then LocalPlayer().gWeather.OutsideFactor = Lerp( 0.01, LocalPlayer().gWeather.OutsideFactor, 50) return end
			end	
			LocalPlayer().gWeather.OutsideFactor = Lerp( 0.01, LocalPlayer().gWeather.OutsideFactor, 100)	
		elseif util.IsSkyboxVisibleFromPoint(LocalPlayer():EyePos()) then	
			local skyhit = util.TraceLine( { start = LocalPlayer():EyePos(), endpos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 1000^2, filter = LocalPlayer() } ).HitSky
			if skyhit then 
				LocalPlayer().gWeather.OutsideFactor = Lerp( 0.01, LocalPlayer().gWeather.OutsideFactor, 75) else LocalPlayer().gWeather.OutsideFactor = Lerp( 0.01, LocalPlayer().gWeather.OutsideFactor, 50)
			end
		else
			LocalPlayer().gWeather.OutsideFactor = Lerp( 0.01, LocalPlayer().gWeather.OutsideFactor, 0)
		end
	end)
	
	hook.Add("RenderScreenspaceEffects", "gWeather.LocalPlayer.Hook.ScreenEFX", function()
		if render.GetDXLevel() <= 90 then return end
		if LocalPlayer().gWeather==nil then return end	
		if GetConVar("gw_screeneffects"):GetInt() == 0 then return end
		
		local scalefactor = (ScrH() + ScrW()) / 3000
		
		local eye_ang = LocalPlayer():EyeAngles():Forward()
		local dir = Vector(-gWeather:GetWindDirection().y,gWeather:GetWindDirection().x,0):Dot(eye_ang)
		local dir2 = gWeather:GetWindDirection():Dot(eye_ang)

		for k,v in pairs(LocalPlayer().gWeather.ScreenEFX) do
			if (LocalPlayer():InVehicle() and !LocalPlayer():GetVehicle():GetThirdPersonMode()) or LocalPlayer():WaterLevel() >= 3 then LocalPlayer().gWeather.ScreenEFX[k]=nil return end
			if v.Life<=CurTime() then LocalPlayer().gWeather.ScreenEFX[k]=nil continue end

			local speed=v.MoveSpeed * (gWeather:GetWindSpeed()/50/2)
			
			if v.Pos==nil then v.Pos = Vector( math.random( 0,ScrW() ), math.random( ScrH()/4,ScrH() ) + (speed*-50*scalefactor), 0) end		
			
			render.UpdateRefractTexture()
			
			local colr,colg,colb= v.Color:Unpack()
			
			surface.SetDrawColor( colr,colg,colb, math.Clamp( v.Life - CurTime(), 0, 1 )*255 )
			surface.SetTexture(surface.GetTextureID(v.Texture))
			surface.DrawTexturedRectRotated( v.Pos.x, v.Pos.y, v.Size, v.Size, dir*90 )
			
			v.Pos = v.Pos + (Vector( dir,(1-dir2)/2,0  ) ) * speed
		end
	end )
	
	hook.Add( "gWeather.LocalPlayer.Hook.FogOutside", "gWeather.LocalPlayer.Hook.FogOutside", function(fogspeed)
		if LocalPlayer().gWeather==nil then return end

		if gWeather.IsOutside(LocalPlayer(),true) then
			LocalPlayer().gWeather.Fog.CurrentDensity =  Lerp( fogspeed, LocalPlayer().gWeather.Fog.CurrentDensity, LocalPlayer().gWeather.Fog.DensityOutside ) -- fog density should be more dense
			LocalPlayer().gWeather.Fog.CurrentDistance =  Lerp( fogspeed, LocalPlayer().gWeather.Fog.CurrentDistance, LocalPlayer().gWeather.Fog.DistanceOutside ) -- the fog distance should also be the closest
		elseif util.IsSkyboxVisibleFromPoint(LocalPlayer():EyePos()) then
			LocalPlayer().gWeather.Fog.CurrentDensity =  Lerp( fogspeed, LocalPlayer().gWeather.Fog.CurrentDensity, LocalPlayer().gWeather.Fog.DensityInside ) -- fog density should be less dense	
			LocalPlayer().gWeather.Fog.CurrentDistance =  Lerp( fogspeed, LocalPlayer().gWeather.Fog.CurrentDistance, LocalPlayer().gWeather.Fog.DistanceInside ) -- the fog distance should also be the furthest 
		else
			LocalPlayer().gWeather.Fog.CurrentDensity =  Lerp( fogspeed, LocalPlayer().gWeather.Fog.CurrentDensity, 0 ) 
			LocalPlayer().gWeather.Fog.CurrentDistance =  Lerp( fogspeed, LocalPlayer().gWeather.Fog.CurrentDistance, 10000 ) 
		end		
		
	end)
	
end