if (SERVER) then
	util.AddNetworkString( "gw_fog" )
	
	function gWeather:CreateFog(tbl) --gWeather.CreateFog( { Color=Color(155,155,155),FogStart=0,FogEnd={Min=200,Max=2000},Density={Min=0.8,Max=1} } )
		net.Start("gw_fog")
			net.WriteBool(true)
			net.WriteTable(tbl)
		net.Broadcast()
	end

	function gWeather:CreateLocalFog(ply,tbl)
		net.Start("gw_fog")
			net.WriteBool(true)
			net.WriteTable(tbl)
		net.Send(ply)
	end
	
	function gWeather:RemoveFog()
		net.Start("gw_fog")
			net.WriteBool(false)
		net.Broadcast()
	end
end

if (CLIENT) then

	local function LerpColor(amount,col,col2)
		if !(IsColor(col) and IsColor(col2)) then return end
		
		col.r=Lerp(amount,col.r,col2.r)
		col.g=Lerp(amount,col.g,col2.g)
		col.b=Lerp(amount,col.b,col2.b)
		
		return col
	end

	local function LerpFogTables(speed,tbl)
		local scale=100
		speed=(speed/0.01)
		
		local fogtbl=LocalPlayer().gWeather.Fog
		
		for i=1,scale do
			local lerpscale=i*(1/scale)
		
			if !hook.GetTable().SetupWorldFog then break end
		
			timer.Simple((i*speed)/scale,function()
				if !hook.GetTable().SetupWorldFog then return end
			
				if tbl.FogStart then fogtbl.Start = Lerp(lerpscale,fogtbl.Start,tbl.FogStart) end	
				if tbl.FogColor then fogtbl.Color = LerpColor(lerpscale,fogtbl.Color,tbl.FogColor) end		
				if tbl.FogDensity and tbl.FogDensity.Outside then fogtbl.DensityOutside = Lerp(lerpscale,fogtbl.DensityOutside,tbl.FogDensity.Outside) end		
				if tbl.FogDensity and tbl.FogDensity.Inside then fogtbl.DensityInside = Lerp(lerpscale,fogtbl.DensityInside,tbl.FogDensity.Inside) end		
				if tbl.FogEnd and tbl.FogEnd.Outside then fogtbl.DistanceOutside = Lerp(lerpscale,fogtbl.DistanceOutside,tbl.FogEnd.Outside)  end 		
				if tbl.FogEnd and tbl.FogEnd.Inside then fogtbl.DistanceInside = Lerp(lerpscale,fogtbl.DistanceInside,tbl.FogEnd.Inside) end
				
			end)
			
		end
		
	end	

	net.Receive("gw_fog", function()
		local bool=net.ReadBool()
		if LocalPlayer().gWeather==nil then return end

		if bool then
			local tbl=net.ReadTable()
			
			if !tbl.FogStart then tbl.FogStart=0 end
			if !tbl.FogSpeed then tbl.FogSpeed=0.01 end
			
			if hook.GetTable().SetupWorldFog and hook.GetTable().SetupWorldFog["gWeather.Fog.WorldFog"] then LerpFogTables(tbl.FogSpeed,tbl) return end 

			LocalPlayer().gWeather.Fog.Start = tbl.FogStart
			LocalPlayer().gWeather.Fog.Color = tbl.FogColor
			LocalPlayer().gWeather.Fog.DensityOutside = tbl.FogDensity.Outside
			LocalPlayer().gWeather.Fog.DensityInside = tbl.FogDensity.Inside
			LocalPlayer().gWeather.Fog.DistanceOutside = tbl.FogEnd.Outside
			LocalPlayer().gWeather.Fog.DistanceInside = tbl.FogEnd.Inside

			hook.Add( "SetupWorldFog", "gWeather.Fog.WorldFog", function()
			
				hook.Run( "gWeather.LocalPlayer.Hook.FogOutside",tbl.FogSpeed)
			
				render.FogMode( 1 )
				render.FogColor( LocalPlayer().gWeather.Fog.Color:Unpack() )
				render.FogStart( LocalPlayer().gWeather.Fog.Start )
				render.FogEnd( LocalPlayer().gWeather.Fog.CurrentDistance )
				render.FogMaxDensity( LocalPlayer().gWeather.Fog.CurrentDensity )
				
				if GetConVar("gw_enablefog"):GetInt()==0 then return false end
				
				return true
			end)
		
			hook.Add( "SetupSkyboxFog", "gWeather.Fog.SkyboxFog", function(scale) -- skybox scale
			
				render.FogMode( 1 )
				render.FogColor( LocalPlayer().gWeather.Fog.Color:Unpack() )
				render.FogStart( (LocalPlayer().gWeather.Fog.Start)*scale )
				render.FogEnd( (LocalPlayer().gWeather.Fog.CurrentDistance)*scale )
				render.FogMaxDensity( LocalPlayer().gWeather.Fog.CurrentDensity )
				
				if GetConVar("gw_enablefog"):GetInt()==0 then return false end
				
				return true
			end)

		else
		
			if LocalPlayer().gWeather!=nil then 
				LocalPlayer().gWeather.Fog.CurrentDensity = 0
				LocalPlayer().gWeather.Fog.CurrentDistance = 10000
			end
			
			hook.Remove("SetupWorldFog","gWeather.Fog.WorldFog")
			hook.Remove("SetupSkyboxFog","gWeather.Fog.SkyboxFog")

		end
		
	end)
	
end