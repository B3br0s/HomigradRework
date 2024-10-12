AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Category 2 Hurricane"
ENT.Author = "Jimmywells"

-- for tropical systems, we use 10-minute sustained winds. NOT 1-minute sustained winds (pretty much 1-min winds * 0.75)
-- so 115-133 km/h

function ENT:CloudTimer(t,callback)
	timer.Simple(t,function() 
		if !IsValid(self) then return end
		if isfunction(callback) then callback() end
	end)
end

function ENT:TimeElapsed()
	if self.SpawnTime==nil then return 0 end
	return (CurTime()-self.SpawnTime)/self.TimeMult
end

function ENT:Initialize()			
	BaseClass.Initialize(self)

	self.SpawnTime=CurTime()
	self.TimeMult=math.max(90,GetConVar("gw_weather_lifetime"):GetInt())/90

	if (CLIENT) then
	
		LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}

		LocalPlayer().gWeather.Sounds["OutsideRainL"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/light_rain_loop.wav")
		LocalPlayer().gWeather.Sounds["IndoorRainL"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_light_rain_loop.wav")
		
		self.Cloud = gWeather.CreateCloud("TCClouds",Material("atmosphere/skybox/clouds_2"),Color(150,150,152,255))
		
	end

	if (SERVER) then

		-- starts in outer rainbands

		gWeather:SetAtmosphere({
			Temperature=math.random(26,31),
			Humidity=math.random(75,80),
			Precipitation=0.3,
			Wind={
				Speed=math.random(5,10)
			},
		})
		
		local vec=Vector(85/255,90/255,95/255)
		
		local tbl = {
			
			TopColor=vec,
			BottomColor=vec,
			DuskScale=.5,
			DuskIntensity=.2,
			SunSize=0
				
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(90,90,95),FogStart=0,FogEnd={Outside=2500,Inside=3500},FogDensity={Outside=0.3,Inside=0.2} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("i")

		timer.Simple(90*self.TimeMult,function() 
			if !IsValid(self) then return end
			self:Remove()
		end)

	end
	
	self:CloudTimer( 15*self.TimeMult, function() 
	
	-- more intense rainbands hit
			
		if CLIENT then
			
		LocalPlayer().gWeather.Sounds["OutsideRainH"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/rain_loop.wav")
		LocalPlayer().gWeather.Sounds["IndoorRainH"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_rain_loop.wav")	
			
		self.Cloud.SetColor(Color(130,130,135,255)) 
				
		elseif SERVER then
		
			self.WindVec = gWeather:GetWindDirection()
		
			gWeather:SetAtmosphere({
				Humidity=math.random(95,100),
				Precipitation=0.4,
			Wind={
				Speed=math.random(40,55),
				Direction=self.WindVec,
				},
			})

			local vec=Vector(65/255,65/255,70/255)

			local tbl = {
					
			TopColor=vec,
			BottomColor=vec,
			DuskScale=0,
			DuskIntensity=0,
			
			}
			gWeather:SetSkyParameters(tbl)
			
			
			local fog = { FogColor=Color(90,90,90),FogStart=0,FogEnd={Outside=1500,Inside=2000},FogDensity={Outside=0.7,Inside=0.5} }
			gWeather:CreateFog(fog)
			
			gWeather.SetMapLight("h")
			
		end
		
	end )	
	
	self:CloudTimer( 30*self.TimeMult, function() 
	
	-- main "eyewall" hits 
			
		if CLIENT then
		
		(self.Cloud).SetColor(Color(120,120,125,255)) 
				
		elseif SERVER then
			
			gWeather:SetAtmosphere({
				Precipitation=0.75,
			Wind={
				Speed=math.random(115,133),
				Direction=self.WindVec,
				},
			})
			
			local vec=Vector(0.25,0.25,0.3)

			local tbl = {
					
			TopColor=vec,
			BottomColor=vec,
			DuskScale=0,
			DuskIntensity=0,
			
			}
			gWeather:SetSkyParameters(tbl)
			
			local fog = { FogColor=Color(80,80,82),FogStart=0,FogEnd={Outside=1500,Inside=2000},FogDensity={Outside=0.7,Inside=0.5} }
			gWeather:CreateFog(fog)
			
			gWeather.SetMapLight("g")
			
			self.Surge = self:CreateStormSurge(math.random(60,80))
			
		end
		
	end )	
	
	self:CloudTimer( 60*self.TimeMult, function() 
	
	-- core passes, less intense rainbands
			
		if CLIENT then
				
			self.Cloud.SetColor(Color(130,130,135,255)) 	
				
		elseif SERVER then
			
			gWeather:SetAtmosphere({
				Precipitation=0.4,
			Wind={
				Speed=math.random(40,55),
				Direction=self.WindVec,
				},
			})

			local vec=Vector(65/255,65/255,70/255)

			local tbl = {
					
			TopColor=vec,
			BottomColor=vec,
			DuskScale=0,
			DuskIntensity=0,
			
			}
			gWeather:SetSkyParameters(tbl)
			
			local fog = { FogColor=Color(90,90,92),FogStart=0,FogEnd={Outside=1500,Inside=2000},FogDensity={Outside=0.7,Inside=0.5} }
			gWeather:CreateFog(fog)
			
			gWeather.SetMapLight("h")
			
		end
		
	end )	
	
	self:CloudTimer( 75*self.TimeMult, function() 
	
	-- main rainbands pass, precipitation is almost past
			
		if CLIENT then
				
		(self.Cloud).SetColor(Color(150,150,152,255)) 		
				
		elseif SERVER then
			
		gWeather:SetAtmosphere({
			Humidity=math.random(75,80),
			Precipitation=0.3,
			Wind={
				Speed=math.random(5,10),
				Direction=self.WindVec,
			},
		})
		
		local vec=Vector(85/255,90/255,95/255)
		
		local tbl = {
			
			TopColor=vec,
			BottomColor=vec,
			DuskScale=.5,
			DuskIntensity=.2,
			SunSize=0
				
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(90,90,93),FogStart=0,FogEnd={Outside=2500,Inside=3500},FogDensity={Outside=0.3,Inside=0.2} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("i")
		
		end
		
	end )	
	
	
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:WeatherState()
	if self:TimeElapsed()<=15 or (self:TimeElapsed()>75 and self:TimeElapsed()<=90) then
	
		if CLIENT then 
			local vol = (gWeather:GetOutsideFactor()/100)
			local fdt=0.15
	
			if LocalPlayer().gWeather.Sounds["OutsideRainL"] then
				LocalPlayer().gWeather.Sounds["OutsideRainL"]:ChangeVolume((vol^3),fdt)
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorRainL"] then
				LocalPlayer().gWeather.Sounds["IndoorRainL"]:ChangeVolume( (1-vol) * (4*vol),fdt) 
			end
			
			if LocalPlayer().gWeather.Sounds["OutsideRainH"] and LocalPlayer().gWeather.Sounds["OutsideRainH"]:GetVolume()!=0 then
				LocalPlayer().gWeather.Sounds["OutsideRainH"]:ChangeVolume(0,fdt) 
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorRainH"] and LocalPlayer().gWeather.Sounds["IndoorRainH"]:GetVolume()!=0 then
				LocalPlayer().gWeather.Sounds["IndoorRainH"]:ChangeVolume(0,fdt) 
			end
		end
	
		if SERVER then 
			if IsValid(self.Surge) then 
				self.Surge:EFire("Height", (self.Surge).FloodHeight-0.3) 
				if (self.Surge).FloodHeight <= 0 then self.Surge:Remove() end
			end
			
			self:ScreenParticleEffectsLight() 
		end
		
	elseif (self:TimeElapsed()>15 and self:TimeElapsed()<=30) or (self:TimeElapsed()>60 and self:TimeElapsed()<=75) then
	
		local fade = (self:TimeElapsed()<=30 and (self:TimeElapsed()-15)/15 or (75-self:TimeElapsed())/15)

		if CLIENT then 
			local vol = (gWeather:GetOutsideFactor()/100)
			local Lvol = math.Clamp( vol*(1-fade), 0, 1)
			local Hvol = math.Clamp( vol*fade, 0, 1)
			local fdt=0.15
			
			if LocalPlayer().gWeather.Sounds["OutsideRainL"] then
				LocalPlayer().gWeather.Sounds["OutsideRainL"]:ChangeVolume(Lvol*vol*vol,fdt)
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorRainL"] then
				LocalPlayer().gWeather.Sounds["IndoorRainL"]:ChangeVolume( (1-Lvol) * (4*Lvol),fdt) 
			end
			
			if LocalPlayer().gWeather.Sounds["OutsideRainH"] then
				LocalPlayer().gWeather.Sounds["OutsideRainH"]:ChangeVolume(Hvol*vol*vol,fdt)
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorRainH"] then
				LocalPlayer().gWeather.Sounds["IndoorRainH"]:ChangeVolume( (1-Hvol) * (4*Hvol),fdt) 
			end
		end

		if SERVER then
			if gWeather.PChance(fade*50) then self:ScreenParticleEffectsHeavy() else self:ScreenParticleEffectsLight() end	
		end
		
	elseif (self:TimeElapsed()>30 and self:TimeElapsed()<=60) then
	
		if CLIENT then 
			local vol = (gWeather:GetOutsideFactor()/100)
			local fdt=0.15
	
			if LocalPlayer().gWeather.Sounds["OutsideRainH"] then
				LocalPlayer().gWeather.Sounds["OutsideRainH"]:ChangeVolume((vol^3),fdt)
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorRainH"] then
				LocalPlayer().gWeather.Sounds["IndoorRainH"]:ChangeVolume( (1-vol) * (4*vol),fdt) 
			end
			
			if LocalPlayer().gWeather.Sounds["OutsideRainL"] and LocalPlayer().gWeather.Sounds["OutsideRainL"]:GetVolume()!=0 then
				LocalPlayer().gWeather.Sounds["OutsideRainL"]:ChangeVolume(0,fdt) 
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorRainL"] and LocalPlayer().gWeather.Sounds["IndoorRainL"]:GetVolume()!=0 then
				LocalPlayer().gWeather.Sounds["IndoorRainL"]:ChangeVolume(0,fdt) 
			end
		end
	
		if SERVER then self:ScreenParticleEffectsHeavy() end
		
	end
end

function ENT:ScreenParticleEffectsLight()
	
	local dir=gWeather:GetWindDirection()
	local ang=dir:Angle()
	
	local effect1,effect2,impact="gw_light_rain","gw_heavy_rain","gw_light_rain_impact"

	for k,ply in ipairs(player.GetAll()) do
		gWeather.ImpactEffects(ply,impact,500,1)
		
		if gWeather.PChance(75) then 
			gWeather.Particles(ply,effect1,ang)
		else
			gWeather.Particles(ply,effect2,ang,nil,600)
		end
		
		if gWeather.PChance(15) then
			if !gWeather.IsOutside(ply,true) or !gWeather.IsFacingWind(ply) then continue end
		
			net.Start("gw_screeneffects")
				net.WriteString("hud/rain") -- texture
				net.WriteFloat(math.random(64,128)) -- size
				net.WriteFloat(math.random(0.2,0.4)) -- lifetime (in seconds)
				net.WriteFloat(2) -- movement speed
				net.WriteColor(color_white,false) -- color
			net.Send(ply)		
		end
		
	end

end

function ENT:ScreenParticleEffectsHeavy()
	
	local dir=gWeather:GetWindDirection()
	local ang=dir:Angle()
	
	local effect1,effect2,impact="gw_heavy_rain","gw_extreme_rain","gw_heavy_rain_impact"

	for k,ply in ipairs(player.GetAll()) do
		gWeather.Particles(ply,effect2,ang,0.85,600)
		
		gWeather.ImpactEffects(ply,impact,500,1)	

		if gWeather.PChance(25) then
			if !gWeather.IsOutside(ply,true) or !gWeather.IsFacingWind(ply) then continue end
		
			net.Start("gw_screeneffects")
				net.WriteString("hud/rain") -- texture
				net.WriteFloat(math.random(64,128)) -- size
				net.WriteFloat(math.random(0.2,0.4)) -- lifetime (in seconds)
				net.WriteFloat(3) -- movement speed
				net.WriteColor(color_white,false) -- color
			net.Send(ply)		
		end
		
	end

end

function ENT:CreateStormSurge(size)
	if !file.Exists("autorun/gdisasters_load.lua","LUA") then return end
	if GetConVar("gw_weather_shouldflood"):GetInt()==0 then return end
	if IsMapRegistered()==false then return end
	
	local flood = createFlood(size, self)
	if !IsValid(flood) then return end
	
	self:DeleteOnRemove(flood)
	return flood
end

function ENT:Think()

	self:WeatherState()

	if (CLIENT) then
	--	print(self:TimeElapsed(),self.TimeMult)
	end

	if (SERVER) then
		--print(self:TimeElapsed(),self.TimeMult)
	
		local i = ( FrameTime() / 0.015 ) * .01
		
		self:NextThink(CurTime()+i)
		return true
	end
end

function ENT:OnRemove()

	if (CLIENT) then
	
		if LocalPlayer().gWeather then
	
			if LocalPlayer().gWeather.Sounds["OutsideRainL"] then
				LocalPlayer().gWeather.Sounds["OutsideRainL"]:Stop()
				LocalPlayer().gWeather.Sounds["OutsideRainL"]=nil	
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorRainL"] then
				LocalPlayer().gWeather.Sounds["IndoorRainL"]:Stop()
				LocalPlayer().gWeather.Sounds["IndoorRainL"]=nil	
			end
			
			if LocalPlayer().gWeather.Sounds["OutsideRainH"] then
				LocalPlayer().gWeather.Sounds["OutsideRainH"]:Stop()
				LocalPlayer().gWeather.Sounds["OutsideRainH"]=nil	
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorRainH"] then
				LocalPlayer().gWeather.Sounds["IndoorRainH"]:Stop()
				LocalPlayer().gWeather.Sounds["IndoorRainH"]=nil	
			end
		
		end
		
		gWeather.RemoveCloud("TCClouds")
		
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







