AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Cold Front"
ENT.Author = "Jimmywells"

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

function ENT:LightningSpawn()
	if self.NextLightningTime>CurTime() then return end

	if SERVER then

		local startpos = gWeather:GetRandomBounds(true)

		local bolt = ents.Create("gw_lightningbolt")
		bolt:SetPos(startpos)
		bolt:Spawn()
		bolt:Activate()

	end
	
	self.NextLightningTime=CurTime()+math.random(5,10)
end

function ENT:Initialize()			
	BaseClass.Initialize(self)

	self.SpawnTime=CurTime()
	self.TimeMult=math.max(80,GetConVar("gw_weather_lifetime"):GetInt())/80

	if (CLIENT) then

		self.WarmCloud = gWeather.CreateCloud("WarmClouds",Material("atmosphere/skybox/clouds_1"),Color(250,250,250,100) )
	end

	if (SERVER) then

		-- starts with warm air
		
		gWeather:SetAtmosphere({
			Temperature=math.random(20,30),
			Humidity=math.random(50,70),
			Precipitation=0,
			Wind={
				Speed=math.random(2,5)
			},
		})
		
		local tbl = {
			
			TopColor=Vector(0.12,0.46,0.96),
			BottomColor=Vector(0.80,0.90,1.0),
			DuskScale=.5,
			DuskIntensity=.5,
			DuskColor=Vector(1.00,0.20,0.0)
		--	DrawStars=true,
		--	StarTexture="skybox/clouds"
				
		}
		
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(227,227,227),FogStart=0,FogEnd={Outside=8000,Inside=10000},FogDensity={Outside=0.3,Inside=0.3} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("p")
		
		self.NextLightningTime=CurTime()+math.random(20,25)
		
	end
	
	self:CloudTimer( 10*self.TimeMult, function() 
			
		-- clouds start to roll in	
			
		if CLIENT then
			

			if self.WarmCloud!=nil then
				self.WarmCloud.SetColor(Color(190,190,190))	
			end

		elseif SERVER then
			
			self.WindVec = gWeather:GetWindDirection()
			
			gWeather:SetWind(math.random(10,15),self.WindVec)
			
			local tbl = {
					
				TopColor=Vector(0.22,0.29,0.48),
				BottomColor=Vector(0.48,0.56,0.59),
				DuskIntensity=0.2,
				SunSize=8,

						
			}
			gWeather:SetSkyParameters(tbl)
			
			local fog = { FogColor=Color(200,200,200),FogStart=0,FogEnd={Outside=5000,Inside=6000},FogDensity={Outside=0.4,Inside=0.3} }
			gWeather:CreateFog(fog)
			
			gWeather.SetMapLight("k")
			
		end
		
	end )	

	
	self:CloudTimer( 20*self.TimeMult, function() 
			
		-- intersection of air masses: heavy rain, cumulonimbus
			
		if CLIENT then
		
			LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
			LocalPlayer().gWeather.Sounds["OutsideRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/rain_loop.wav")
			LocalPlayer().gWeather.Sounds["IndoorRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_rain_loop.wav")
		
			if self.WarmCloud!=nil then
				self.WarmCloud.SetColor(Color(120,125,130))	
			end
				
		elseif SERVER then

			gWeather:SetAtmosphere({
				Temperature=math.random(12,15),
				Humidity=math.random(99,100),
				Precipitation=0.6,
				Wind={
					Speed=math.random(45,55),
					Direction=self.WindVec
				},
			})
			
			local vec=Vector(55/255,60/255,70/255)
		
			local tbl = {
			
				TopColor=vec,
				BottomColor=vec,
				DuskIntensity=0,
				DuskScale=0,
				SunSize=0,
						
			}
			gWeather:SetSkyParameters(tbl)
			
			local fog = { FogColor=Color(90,90,95),FogStart=0,FogEnd={Outside=800,Inside=1500},FogDensity={Outside=0.9,Inside=0.6} }
			gWeather:CreateFog(fog)
			
			gWeather.SetMapLight("e")
			
		end
		
	end )	
	
	self:CloudTimer( 60*self.TimeMult, function() 
			
		-- cold air has passed warm air, but some clouds are still in the warm pocket above cold air	
			
		if CLIENT then
			
			if LocalPlayer().gWeather.Sounds and LocalPlayer().gWeather.Sounds["OutsideRain"] then
				LocalPlayer().gWeather.Sounds["OutsideRain"]:ChangeVolume(0,0.25)
				LocalPlayer().gWeather.Sounds["OutsideRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/light_rain_loop.wav")
			end
			if LocalPlayer().gWeather.Sounds and LocalPlayer().gWeather.Sounds["IndoorRain"] then
				LocalPlayer().gWeather.Sounds["IndoorRain"]:ChangeVolume(0,0.25)
				LocalPlayer().gWeather.Sounds["IndoorRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_light_rain_loop.wav")
			end	
			
			if self.WarmCloud!=nil then
				self.WarmCloud.SetColor(Color(210,210,210,math.random(155,255)))
			end
				
		elseif SERVER then
			
			gWeather:SetAtmosphere({
				Humidity=math.random(85,95),
				Precipitation=0.3,
				Wind={
					Speed=math.random(15,25),
					Direction=self.WindVec
				},
			})
			
			local tbl = {
					
				TopColor=Vector(0.22,0.29,0.55),
				BottomColor=Vector(0.48,0.56,0.6),
				DuskScale=0.5,
				DuskIntensity=0.5,
				SunSize=8,
						
			}
			gWeather:SetSkyParameters(tbl)
			
			local fog = { FogColor=Color(150,150,150),FogStart=0,FogEnd={Outside=4000,Inside=6000},FogDensity={Outside=0.4,Inside=0.35} }
			gWeather:CreateFog(fog)
			
			gWeather.SetMapLight("h")
			
		end
		
	end )	
	
	self:CloudTimer( 70*self.TimeMult, function() 
			
		-- cold air and warm air no longer have enough forcing to produce preciptiation
			
		if CLIENT then
		

			if self.WarmCloud!=nil then
				self.WarmCloud.SetColor(Color(255,255,255,math.random(25,50)))
			end
			
				
		elseif SERVER then
			
			gWeather:SetAtmosphere({
			Temperature=math.random(5,10),
			Humidity=math.random(35,50),
			Precipitation=0,
			Wind={
				Speed=math.random(2,5),
				Direction=self.WindVec
				},
			})
			
			local tbl = {
					
				TopColor=Vector(0.20,0.50,1.00),
				BottomColor=Vector(0.60,0.84,1.00),
				DuskScale=1,
				DuskIntensity=1,
				SunSize=16,
						
			}
			gWeather:SetSkyParameters(tbl)
			
			local fog = { FogColor=Color(210,210,210),FogStart=0,FogEnd={Outside=25000,Inside=30000},FogDensity={Outside=0.3,Inside=0.3} }
			gWeather:CreateFog(fog)
			
			gWeather.SetMapLight("l")
			
		end
		
	end )	
	
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()
	
	local dir=gWeather:GetWindDirection()
	local ang=dir:Angle()
	
	local effect1,effect2,impact="gw_heavy_rain","gw_light_rain_drop","gw_light_rain_impact"

	for k,ply in ipairs(player.GetAll()) do
	
		if self:TimeElapsed()<=50 then
			gWeather.Particles(ply,effect1,ang,nil,600)
		else
			if math.random( 1,math.max(61-self:TimeElapsed(),1) )==1 then
				gWeather.Particles(ply,effect2,ang,nil,600)
			else
				gWeather.Particles(ply,effect1,ang,nil,600)
			end
		end

		for i=1,2 do
			gWeather.ImpactEffects(ply,impact,500)
		end		

		if math.random(1,math.max( 4, (self:TimeElapsed()-60) ) )==1 then
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


function ENT:Think()
	if (CLIENT) then
		
		local vol = (gWeather:GetOutsideFactor()/100)
		local fdt=0.15
	
		if LocalPlayer().gWeather.Sounds and LocalPlayer().gWeather.Sounds["OutsideRain"] then
			if self:TimeElapsed()<=70 then
				LocalPlayer().gWeather.Sounds["OutsideRain"]:ChangeVolume((vol^3),fdt)
			else
				LocalPlayer().gWeather.Sounds["OutsideRain"]:ChangeVolume(0,fdt)
			end
		end
		
		if LocalPlayer().gWeather.Sounds and LocalPlayer().gWeather.Sounds["IndoorRain"] then
			if self:TimeElapsed()<=70 then
				LocalPlayer().gWeather.Sounds["IndoorRain"]:ChangeVolume( (1-vol) * (4*vol),fdt) 
			else
				LocalPlayer().gWeather.Sounds["IndoorRain"]:ChangeVolume(0,fdt)
			end
		end
		
	end

	if (SERVER) then

		if self:TimeElapsed()>=20 and self:TimeElapsed()<=70 then
			self:ScreenParticleEffects()
			if self:TimeElapsed()>=30 and self:TimeElapsed()<=60 then
				self:LightningSpawn()
			end
		end
	
		local i = ( FrameTime() / 0.015 ) * .01
		
		self:NextThink(CurTime()+i)
		return true
	end
end

function ENT:OnRemove()

	if (CLIENT) then
	
		if LocalPlayer().gWeather and LocalPlayer().gWeather.Sounds then

			if LocalPlayer().gWeather.Sounds["OutsideRain"] then
				LocalPlayer().gWeather.Sounds["OutsideRain"]:Stop()
				LocalPlayer().gWeather.Sounds["OutsideRain"]=nil	
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorRain"] then
				LocalPlayer().gWeather.Sounds["IndoorRain"]:Stop()
				LocalPlayer().gWeather.Sounds["IndoorRain"]=nil	
			end
	
		end
		
		gWeather.RemoveCloud("WarmClouds")
		
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







