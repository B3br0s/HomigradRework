if (SERVER) then

	util.AddNetworkString( "gw_atmosphere" )
	util.AddNetworkString( "gw_screenshake" )
	util.AddNetworkString( "gw_lightmaps" )
	util.AddNetworkString( "gw_particleattach" )
	util.AddNetworkString( "gw_screeneffects" )
	util.AddNetworkString( "gw_mapboundsync" )
	util.AddNetworkString( "gw_convarsync" )
	util.AddNetworkString( "gw_needbounds" )
	util.AddNetworkString( "gw_sounds" )
	util.AddNetworkString( "gw_lightlevel" )
	util.AddNetworkString( "gw_lightningflash" )
	util.AddNetworkString( "gw_luaparticleimapct" )
	util.AddNetworkString( "gw_atmosphere_bounds" )
	util.AddNetworkString( "gw_particle_fix" )
	
	---

	local cvarlist={
		["gw_windphysics_player"]=true,
		["gw_windphysics_prop"]=true,
		["gw_windphysics_unweld"]=true,
		["gw_nextwind"]=true,
		["gw_tempaffect"]=true,
		["gw_tempaffect_rate"]=true,
		["gw_weather_lifetime"]=true,
		["gw_weather_entitydamage"]=true
	}
	
	---

	net.Receive( "gw_needbounds", function(len,ply)
		if gWeather:BoundsValid() then 
			local map=game.GetMap()
			net.Start( "gw_mapboundsync" )
				net.WriteVector( gWeather.MapBounds[map][1] )
				net.WriteVector( gWeather.MapBounds[map][2] )
			net.Send(ply)
		end
	end)

	net.Receive( "gw_convarsync", function(len,ply)
		if !ply:IsAdmin() then return end
		local cvar = tostring(net.ReadString())
		local val = net.ReadFloat()
	
		if cvarlist[cvar] then
			if GetConVar(cvar) == nil then return end
			RunConsoleCommand(cvar, tostring(val))	
		end
	end)

	net.Receive( "gw_lightlevel", function(len,ply)
		if gWeather.MapLightLevel!=nil then return end
		local val=net.ReadFloat()
		gWeather.MapLightLevel=val
	end)

end

if (CLIENT) then

	net.Receive( "gw_particle_fix", function()
		local effect=net.ReadString()
		local pos=net.ReadVector()
		local ang=net.ReadAngle()
		local ent=net.ReadUInt(8)

		if !string.StartsWith(effect,"gw_") then return end

		ParticleEffect(effect,pos,ang,Entity(ent))
	end )

	net.Receive( "gw_lightningflash", function()
		local sound = net.ReadBool()
		ParticleEffect( "gw_lightningflash", LocalPlayer():EyePos()+LocalPlayer():GetForward()*1000, Angle(0,0,0) )
		if sound then gWeather.SoundWave("weather/thunder/lightning_strike_"..tostring(random(1,4))..".wav",endpos,random(155,160),{97,103}) end
	end )

	net.Receive( "gw_sounds", function()
		local str,origin,level,pitch = net.ReadString(),net.ReadVector(),net.ReadFloat(),net.ReadFloat()

		sound.Play( str,origin,level,pitch,1 )
	end )

	net.Receive( "gw_mapboundsync", function()
		local map = game.GetMap()
		if gWeather.MapBounds[map]!=nil then return end	
		local vec1 = net.ReadVector()
		local vec2 = net.ReadVector()
		
		if gWeather.MapBounds[map]==nil then
		--	if IsValid(LocalPlayer()) then LocalPlayer():ChatPrint("gWeather Warning: The map bounds for ".. tostring(map) .." are automatically generated. Expect possible issues with map-bound dependent weather.\n") end
			gWeather.MapBounds[map]={vec1,vec2}
		end
		
	end )

	net.Receive("gw_atmosphere", function()
		if gWeather.Atmosphere==nil then return end
	
		local winddir = Vector(net.ReadString())
		local windspeed = net.ReadFloat()
		local windangle = net.ReadFloat()
		local temp = net.ReadFloat()
		local humid = net.ReadFloat()
		local precip = net.ReadFloat()
		
		gWeather.Atmosphere.Wind.Direction = winddir
		gWeather.Atmosphere.Wind.Speed = windspeed
		gWeather.Atmosphere.Wind.Angle = windangle 
		gWeather.Atmosphere.Temperature = temp 
		gWeather.Atmosphere.Humidity = humid
		gWeather.Atmosphere.Precipitation = precip
		
	end)
	
	net.Receive("gw_atmosphere_bounds", function()
		if gWeather.Atmosphere==nil then return end
		if gWeather.LocalAtmosphere==nil then return end
	
		local exist = net.ReadBool()
		if exist==false then gWeather.LocalAtmosphere.Wind = nil return end
	
		local windbounds1 = net.ReadString()
		local windbounds2 = net.ReadString()
		
		gWeather.LocalAtmosphere.Wind = {Vector(windbounds1),Vector(windbounds2)} 

	end)
	
	net.Receive("gw_luaparticleimapct", function()
		if !IsValid(LocalPlayer()) then return end
		if !util.IsSkyboxVisibleFromPoint(LocalPlayer():EyePos()) then return end
	
		local particle = net.ReadString()
		local size = net.ReadFloat()
		local pos = net.ReadVector()
		local angle = net.ReadAngle()
		
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetAngles( angle )
		effectdata:SetScale( size )
		util.Effect( particle, effectdata, nil, true )

	end)
	
	net.Receive("gw_particleattach", function()
		if !IsValid(LocalPlayer()) then return end
		if !util.IsSkyboxVisibleFromPoint(LocalPlayer():EyePos()) then return end
	
		local effect=net.ReadString()
		local pos=(net.ReadVector() or LocalPlayer():GetPos())
		local angles=net.ReadAngle()
		
		if GetConVar("gw_particle_level"):GetString()=="low" then
			if math.random(0,1)==1 then return end
		elseif GetConVar("gw_particle_level"):GetString()=="high" then
		
		end

		local particle = CreateParticleSystemNoEntity(effect,pos,angles)
	--	particle:SetControlPointEntity(0,LocalPlayer())
		
		if ( bit.band( util.PointContents( LocalPlayer():GetPos()-Vector(0,0,50) ), CONTENTS_WATER ) == CONTENTS_WATER ) then -- a shitty way to make the particle 'collide' with water (it is too expensive to do all of them)
			particle:SetControlPoint(1,pos)
		else
			particle:SetControlPoint(1,LocalPlayer():GetPos()-Vector(0,0,1000-(LocalPlayer():GetVelocity().z)))
			--particle:SetShouldDraw(false)
		end
		
		--ParticleEffect(effect,pos,angles)

	end)
	
	net.Receive("gw_screenshake", function()
		if !IsValid(LocalPlayer()) then return end
		if GetConVar("gw_screenshake"):GetInt()==0 then return end

		local amp = net.ReadFloat()
		local freq = net.ReadFloat()
		local dur = net.ReadFloat()
		
		if freq==0 then freq=amp end
		if dur==0 then dur=0.1 end

		util.ScreenShake(LocalPlayer():GetPos(), amp, freq, dur, 0 )
	end)
	
	net.Receive("gw_screeneffects", function()
		if !IsValid(LocalPlayer()) then return end
		if GetConVar("gw_screeneffects"):GetInt()==0 then return end
	
		local tex = net.ReadString()
		local size = net.ReadFloat() or 32
		local life = net.ReadFloat() + CurTime()
		local vec = net.ReadFloat() or 1
		local col = (net.ReadColor(false))
		--if col.a == 0 then col = color_white end

		if LocalPlayer().gWeather.ScreenEFX!=nil then
			table.insert(LocalPlayer().gWeather.ScreenEFX,{Texture=tex,Life=life,Size=size,MoveSpeed=vec,Color=col})
		end
	end)
	
	net.Receive("gw_lightmaps", function()
		timer.Simple(0.2,function() -- glitches out without slight delay
			render.RedownloadAllLightmaps(true,false) -- true,true lags a shit ton 
		end)
	end)
	
end