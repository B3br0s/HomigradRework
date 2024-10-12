gWeather.Atmosphere = { Temperature = 21.5, Humidity = 60, Precipitation = 0, Wind ={ Speed = 0, Direction = Vector(0,0,0), Angle = 0 } } 
gWeather.LocalAtmosphere = { Wind = nil }

function gWeather:GetAtmosphere() -- tbl of atmosphere
	if gWeather.Atmosphere==nil then return end
	
	return gWeather.Atmosphere
end
	
function gWeather:GetWindSpeed() -- km/h
	if gWeather.Atmosphere==nil then return end
	
	return gWeather.Atmosphere.Wind.Speed
end
	
function gWeather:GetWindDirection() -- vec
	if gWeather.Atmosphere==nil then return end
	
	return gWeather.Atmosphere.Wind.Direction
end

function gWeather:GetWindLocalBounds() -- tbl of vectors
	if gWeather.Atmosphere==nil then return end
	
	return gWeather.LocalAtmosphere.Wind
end

function gWeather:GetWindAngle() -- float
	if gWeather.Atmosphere==nil then return end
	
	return gWeather.Atmosphere.Wind.Angle
end

function gWeather:GetTemperature() -- celcius
	if gWeather.Atmosphere==nil then return end
	
	return gWeather.Atmosphere.Temperature
end

function gWeather:GetHumidity() -- (0-100)%
	if gWeather.Atmosphere==nil then return end
	
	return gWeather.Atmosphere.Humidity
end

function gWeather:GetDewPoint() -- celcius
	if gWeather.Atmosphere==nil then return end
	
	local sf = gWeather:GetTemperature() - ((100-gWeather:GetHumidity())/5) -- easy but rough calculation
	
	return sf
end

function gWeather:GetPrecipitation() -- float (between 0-1)
	if gWeather.Atmosphere==nil then return end
	
	return gWeather.Atmosphere.Precipitation
end

function gWeather:GetCurrentWeather() -- returns current spawned weather entity
	return gWeather.CurrentWeather
end

-- ================================

function gWeather:IsRaining()
	if gWeather.Atmosphere==nil then return end
	
	if gWeather.Atmosphere.Precipitation>0.01 and gWeather.Atmosphere.Temperature>=0 then return true end
	
	return false
end

function gWeather:IsSnowing() 
	if gWeather.Atmosphere==nil then return end
	
	if gWeather.Atmosphere.Precipitation>0.01 and gWeather.Atmosphere.Temperature<0 then return true end
	
	return false
end

-- ================================

if (SERVER) then

local MaxLerpTime = 0

local gWeatherLerpNew = { Temperature = 21.5, Humidity = 60, Precipitation = 0, Wind ={ Speed = 0, Direction = Vector(0,0,0), Angle = 0 } } 

local function LerpColor(amount,col,col2)
	col.r = Lerp(amount,col.r,col2.r)
	col.g = Lerp(amount,col.g,col2.g)
	col.b = Lerp(amount,col.b,col2.b)
	col.a = Lerp(amount,col.a,col2.a)
	--col:Lerp(col2,amount)
end

local function LerpTables(amount,tbl,tbl2)
	for k,v in pairs(tbl) do
	if tbl[k]==nil then continue end
		for l,b in pairs(tbl2) do	
		if tbl2[l]==nil then continue end
			if k==l then 
				if (isvector(b) and isvector(v)) then -- only value vector-wise is the direction which gets funky when its not set instantly
					tbl[k]=tbl2[l]--LerpVector(amount*25,tbl[k],tbl2[l]) 
				elseif (IsColor(b) and IsColor(v)) then 
					v=LerpColor(amount,v,b) 	 	
				elseif (istable(v) and istable(b)) then
					LerpTables(amount,v,b)
				else
					tbl[k]=Lerp(amount,tbl[k],tbl2[l]) 
				end
			end
		end
	end
end

function gWeather:SetAtmosphere(tbl)
	if gWeather.Atmosphere==nil then return end
	if tbl==nil then return end
	
	gWeatherLerpNew.Temperature = ( tbl.Temperature or gWeather:GetTemperature() ) 
	gWeatherLerpNew.Humidity = ( tbl.Humidity or gWeather:GetHumidity() )
	gWeatherLerpNew.Precipitation = ( tbl.Precipitation or gWeather:GetPrecipitation() )
	if tbl.Wind then gWeather:SetWind(tbl.Wind.Speed,tbl.Wind.Direction,tbl.Wind.Angle,tbl.Wind.Bounds) end
	
	MaxLerpTime = CurTime() + 10
	
end

function gWeather:SetWindLocalBounds(bounds2,bounds1)
	if gWeather.Atmosphere==nil then return end
	if gWeather.LocalAtmosphere.Wind==nil then return end
	
	if bounds2!=nil then gWeather.LocalAtmosphere.Wind[2] = bounds2 end
	if bounds1!=nil then gWeather.LocalAtmosphere.Wind[1] = bounds1 end		
	
	if istable(gWeather.LocalAtmosphere.Wind) then 
		net.Start("gw_atmosphere_bounds")	
			net.WriteBool(true)
			net.WriteString(tostring(gWeather.LocalAtmosphere.Wind[1]))	
			net.WriteString(tostring(gWeather.LocalAtmosphere.Wind[2]))	
		net.Broadcast()	
	end
	
end

function gWeather:AtmosphereReset()
	if gWeather.Atmosphere==nil then return end
	
	gWeatherLerpNew = { Temperature = 21.5, Humidity = 60, Precipitation = 0 }
	gWeather:WindReset()
	
end

function gWeather:SetWind(s,dir,ang,tbl)
	if gWeather.Atmosphere==nil then return end

	local dirtbl={ 
			Vector(1,0,0),
			Vector(-1,0,0),
			Vector(0,1,0),
			Vector(0,-1,0),
		}
		
	gWeather.LocalAtmosphere.Wind = istable(tbl) and tbl or nil
	
	net.Start("gw_atmosphere_bounds")	
		net.WriteBool(false)
	net.Broadcast()	

	gWeatherLerpNew.Wind={
		Speed = isnumber(tonumber(s)) and s or gWeather:GetWindSpeed(),
		Direction = isvector(dir) and dir or dirtbl[math.random(#dirtbl)],
		Angle = isnumber(tonumber(ang)) and ang or gWeather:GetWindAngle()
	}
	
	MaxLerpTime = CurTime() + 10
	
end

function gWeather:WindReset()
	if gWeather.Atmosphere==nil then return end
	
	gWeather.LocalAtmosphere.Wind = nil

	net.Start("gw_atmosphere_bounds")	
		net.WriteBool(false)
	net.Broadcast()	
	
	gWeatherLerpNew.Wind={ Speed = 0, Direction = Vector(0,0,0), Angle = 0 }
	MaxLerpTime = CurTime() + 10
	
end

local function AtmosphereLerp()
	if gWeather.Atmosphere==nil then return end
	if (MaxLerpTime-CurTime())<=0 then return end
	
	LerpTables(0.02,gWeather.Atmosphere,gWeatherLerpNew)

		net.Start("gw_atmosphere")	
			net.WriteString(tostring(gWeather.Atmosphere.Wind.Direction))	
			net.WriteFloat(gWeather.Atmosphere.Wind.Speed)
			net.WriteFloat(gWeather.Atmosphere.Wind.Angle)
			net.WriteFloat(gWeather.Atmosphere.Temperature)
			net.WriteFloat(gWeather.Atmosphere.Humidity)
			net.WriteFloat(gWeather.Atmosphere.Precipitation)
		net.Broadcast()	
	
end
hook.Add( "Think", "gWeather.AtmosphereLerp.Think",AtmosphereLerp)

end

if (CLIENT) then 

	function gWeather:GetOutsideFactor()
		if LocalPlayer().gWeather then
			return LocalPlayer().gWeather.OutsideFactor
		end
	end	
	
--[[
Wind Sounds 
--]]
	
	local l_wind,h_wind = 0,0

	local function WindSoundEffects()
		if !IsValid(LocalPlayer()) then return end
		if gWeather.Atmosphere==nil then return end
		if LocalPlayer().gWeather==nil then return end
		
		local wconvar = GetConVar("gw_windvolume"):GetFloat()
		
		l_wind = math.Clamp( Lerp(0.05,l_wind,( 1-(gWeather:GetWindSpeed()-100)^2 * 0.0001 ) * (gWeather:GetOutsideFactor()/100) ), 0, wconvar)
		h_wind = math.Clamp( Lerp(0.05,h_wind,( (gWeather:GetWindSpeed()-100) * 0.01 ) * (gWeather:GetOutsideFactor()/100) ), 0, wconvar)

		if LocalPlayer().gWeather.Sounds["LightWind"]!=nil then 
			LocalPlayer().gWeather.Sounds["LightWind"]:ChangeVolume(l_wind,0) 
			if !LocalPlayer().gWeather.Sounds["LightWind"]:IsPlaying() then LocalPlayer().gWeather.Sounds["LightWind"]:PlayEx(LocalPlayer().gWeather.Sounds["LightWind"]:GetVolume(), 100) end
		end
		if LocalPlayer().gWeather.Sounds["HeavyWind"]!=nil then 
			LocalPlayer().gWeather.Sounds["HeavyWind"]:ChangeVolume(h_wind,0) 
			if !LocalPlayer().gWeather.Sounds["HeavyWind"]:IsPlaying() then LocalPlayer().gWeather.Sounds["HeavyWind"]:PlayEx(LocalPlayer().gWeather.Sounds["HeavyWind"]:GetVolume(), 100) end 
		end	
			
	end
	timer.Create( "gWeather.SoundFunc.Think", 0.04, 0, WindSoundEffects)

--[[
Basic Tree Sway 
--]]


	local lastwind = -1
	
	timer.Create("gWeather.TreeSwayController",2,0,function()
				
		local wind = gWeather:GetWindSpeed()
		if wind<5 || (math.Round(lastwind) == math.Round(wind)) then return end
		local winddir = gWeather:GetWindDirection()
						
		local clampwind = math.Clamp(wind/5,0,100) -- it goes crazy
						
		RunConsoleCommand("cl_tree_sway_dir",winddir.x*clampwind,winddir.y*clampwind)
		lastwind = wind
		
	end)

end


--[[
Fire section 
--]]


local vFireOutside = {}

-- vFire wind support

if vFireInstalled then
	hook.Add("vFireOnCalculateWind","gWeather.vFireWind",function(ent)
		if #ents.FindByClass("gw_t*")==0 then return end
		
		if IsValid(ent) and gWeather.IsOutside(ent,true) then
			if SERVER then vFireOutside[ent]=true end
			return (gWeather:GetWindDirection()*math.min(gWeather:GetWindSpeed(),100))/150
		end	
	end)
end

if (SERVER) then 
	
	timer.Create( "gWeather.ExtingushFires", 3, 0, function() 
		local chance = (gWeather.Atmosphere.Precipitation)*(gWeather.Atmosphere.Humidity/100)*80
		
		if vFireInstalled then -- vfire fires
			if table.Count(vFireOutside)==0 then return end
			if gWeather:GetWeatherIntensity()==0 then table.Empty(vFireOutside) return end
			for fire,_ in pairs(vFireOutside) do
				if IsValid(fire) then
					fire:SoftExtinguish(chance*2)
					vFireOutside[fire]=nil
				end	
			end
		return end
		
		if (gWeather.Atmosphere.Precipitation)==0 then return end
		
		for k,fire in ipairs(ents.FindByClass("entityflame")) do -- regular fires
			if gWeather.PChance(chance) and IsValid(fire) then
				fire:Remove()	
			end
		end
		
	end )

end
