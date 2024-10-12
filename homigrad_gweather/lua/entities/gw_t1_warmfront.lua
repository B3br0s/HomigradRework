AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Warm Front"
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

function ENT:Initialize()			
	BaseClass.Initialize(self)

	self.SpawnTime=CurTime()
	self.TimeMult=math.max(70,GetConVar("gw_weather_lifetime"):GetInt())/70

	if (CLIENT) then

		self.InitialCloud = gWeather.CreateCloud( "InitialClouds",Material("atmosphere/skybox/clouds_1"),Color(255,255,255,20) )

	end

	local fogcol = Color(227,227,227)

	if (SERVER) then
	
		-- starts with cold front

		gWeather:SetAtmosphere({
			Temperature=math.random(5,10),
			Humidity=math.random(35,50),
			Precipitation=0,
			Wind={
				Speed=math.random(5,10)
			},
		})
		
		local tbl = {
			
			TopColor=Vector(0.12,0.46,0.96),
			BottomColor=Vector(0.41,0.77,1.0),
			DuskScale=1,
			DuskIntensity=0.5,
				
		}
		
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		local fog = { FogColor=fogcol,FogStart=0,FogEnd={Outside=6500,Inside=7000},FogDensity={Outside=0.25,Inside=0.25} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("k")
		
	end
	
	self:CloudTimer( 10*self.TimeMult, function() 
			
		-- clouds start to roll in	
			
		if CLIENT then
		
			self.ColdCloud = gWeather.CreateCloud( "ColdClouds",Material("atmosphere/skybox/clouds_1"),Color(180,180,180,200) )
				
			if self.InitialCloud!=nil then	
				self.InitialCloud.SetColor(color_transparent)	
			end
				
		elseif SERVER then
			
			self.WindVec = gWeather:GetWindDirection()
			
			gWeather:SetWind(math.random(10,15),self.WindVec)
			
			local tbl = {
					
				TopColor=Vector(0.42,0.64,1.00),
				BottomColor=Vector(0.68,0.82,0.82),
				DuskIntensity=0.2,

						
			}
			gWeather:SetSkyParameters(tbl)
			
			gWeather.SetMapLight("k")
			
		end
		
	end )	
	
	self:CloudTimer( 15*self.TimeMult, function() 
			
		-- slightly more intense	
			
		if CLIENT then
		
			if self.ColdCloud!=nil then
				self.ColdCloud:SetColor(Color(160,160,160))
			end			
			
		if self.InitialCloud!=nil then		
			self.InitialCloud.Remove()
			self.InitialCloud=nil
		end
				
				
		elseif SERVER then
			
			gWeather:SetWind(math.random(15,20),self.WindVec)
			
			local vec=Vector(110/255,110/255,110/255)
		
			local tbl = {
				
				TopColor=vec,
				BottomColor=vec,
				DuskScale=0,
				DuskIntensity=0,
				SunSize=0,
						
			}
			gWeather:SetSkyParameters(tbl)
			
			gWeather.SetMapLight("i")
			
		end
		
	end )	
	
	self:CloudTimer( 20*self.TimeMult, function() 
			
		-- slightly more intense		
			
		if CLIENT then
		
			LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
			LocalPlayer().gWeather.Sounds["OutsideRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/light_rain_loop.wav")
			LocalPlayer().gWeather.Sounds["IndoorRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_light_rain_loop.wav")
		
			if self.ColdCloud!=nil then
				self.ColdCloud.SetColor(Color(145,145,145))
			end			
		
		elseif SERVER then

			gWeather:SetAtmosphere({
				Humidity=math.random(90,100),
				Precipitation=0.4,
				Wind={
					Speed=math.random(15,24),
					Direction=self.WindVec
				},
			})
			
		local vec=Vector(80/255,80/255,85/255)
		
			local tbl = {
			
				TopColor=vec,
				BottomColor=vec,
				DuskScale=0,
				DuskIntensity=0,
				SunSize=0
						
			}
			gWeather:SetSkyParameters(tbl)
			
			gWeather.SetMapLight("h")
			
			local fog = { FogColor=Color(140,140,155),FogStart=0,FogEnd={Outside=1600,Inside=2000},FogDensity={Outside=0.5,Inside=0.4} }
			gWeather:CreateFog(fog)
			
		end
		
	end )	
	
	self:CloudTimer( 60*self.TimeMult, function() 
			
		-- warm air finally passes cool air		
			
		if CLIENT then
		
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
			
			if self.ColdCloud!=nil then
				self.ColdCloud.SetColor(Color(255,255,255,math.random(80,100)))
			end			
				
		elseif SERVER then
			
			gWeather:SetAtmosphere({
			Temperature=math.random(21,27),
			Humidity=math.random(50,70),
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
				DuskIntensity=0.5,
				SunSize=16,
						
			}
			gWeather:SetSkyParameters(tbl)
			
			gWeather.SetMapLight("p")
			
			local fog = { FogColor=fogcol,FogStart=0,FogEnd={Outside=12000,Inside=14000},FogDensity={Outside=0.3,Inside=0.2} }
			gWeather:CreateFog(fog)
			
		end
		
	end )	
	
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()
	
	local dir=gWeather:GetWindDirection()
	local ang=dir:Angle()
	
	local effect,impact="gw_light_rain","gw_light_rain_impact"

	for k,ply in ipairs(player.GetAll()) do
	
		gWeather.Particles(ply,effect,ang)
		
		gWeather.ImpactEffects(ply,impact,500)

		if math.random(1,6)==1 then
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
			LocalPlayer().gWeather.Sounds["OutsideRain"]:ChangeVolume((vol^3),fdt)
		end
		
		if LocalPlayer().gWeather.Sounds and LocalPlayer().gWeather.Sounds["IndoorRain"] then
			LocalPlayer().gWeather.Sounds["IndoorRain"]:ChangeVolume( (1-vol) * (4*vol),fdt) 
		end
		
	end

	if (SERVER) then

		if self:TimeElapsed()>=20 and self:TimeElapsed()<=60 then
			self:ScreenParticleEffects()
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
		
		gWeather.RemoveAllClouds()
		
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







