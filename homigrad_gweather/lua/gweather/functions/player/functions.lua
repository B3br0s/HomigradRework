if (SERVER) then

	local dmgtypes={ -- particle effect
		["fire"]={8},
		["acid"]={1048576},
		["heat"]={2097152},
		["cold"]={},
		["space"]={},
		["ash"]={65536},
		["lightning"]={256},
	}

	function gWeather.DamageEntity(ent,dtype,amt)
		if GetConVar("gw_weather_entitydamage"):GetInt()==0 then return end
		if !IsValid(ent) then return end
		if ent:Health()<=0 then return end

		local dmg = DamageInfo()
		dtype = string.lower(dtype)
		
		dmg:SetDamage(amt)
		dmg:SetAttacker(game.GetWorld())
		dmg:SetInflictor(game.GetWorld())
		dmg:SetDamageType(dmgtypes[dtype][1] or 0)
		ent:TakeDamageInfo(dmg)
		
		if dmgtypes[dtype][2]!=nil then
			ParticleEffectAttach(dmgtypes[dtype][2], 1, ent, 0) 
		end	
		
	end
	
end

if (CLIENT) then

	local function gWeatherPlayerInitalize()

		LocalPlayer().gWeather={}
			LocalPlayer().gWeather.OutsideFactor=0
			LocalPlayer().gWeather.ScreenEFX={}
			LocalPlayer().gWeather.Lightning={}
		
		LocalPlayer().gWeather.Fog={}
			LocalPlayer().gWeather.Fog.CurrentDensity=0
			LocalPlayer().gWeather.Fog.CurrentDistance=10000      		
			LocalPlayer().gWeather.Fog.DensityOutside=0
			LocalPlayer().gWeather.Fog.DensityInside=0
			LocalPlayer().gWeather.Fog.DistanceOutside=0
			LocalPlayer().gWeather.Fog.DistanceInside=0
    		LocalPlayer().gWeather.Fog.Color=Color(255,255,255) 
			LocalPlayer().gWeather.Fog.Start=0
				
		LocalPlayer().gWeather.Sounds={}
			local l_winddir,h_winddir = "atmosphere/light_wind_gusts_loop.wav","atmosphere/heavy_wind_loop.wav"
			LocalPlayer().gWeather.Sounds["LightWind"] = gWeather.LoopSfx(LocalPlayer(),l_winddir)
			LocalPlayer().gWeather.Sounds["HeavyWind"] = gWeather.LoopSfx(LocalPlayer(),h_winddir)	
			
	end		
	hook.Add( "InitPostEntity", "gWeather.LocalPlayer.InitPostEntity", gWeatherPlayerInitalize )
	
end