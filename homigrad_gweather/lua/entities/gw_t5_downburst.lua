AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Downburst"
ENT.Author = "Jimmywells"

function ENT:CloudTimer(t,callback)
	timer.Simple(t,function() 
		if !IsValid(self) then return end
		if isfunction(callback) then callback() end
	end)
end

function ENT:TimeElapsed()
	if self.SpawnTime==nil then return 0 end
	return CurTime()-self.SpawnTime
end

function ENT:Initialize()		
	BaseClass.Initialize(self)

	self.SpawnTime=CurTime()

	if (CLIENT) then
	
		LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
		LocalPlayer().gWeather.Sounds["OutsideRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/rain_loop.wav")
		LocalPlayer().gWeather.Sounds["IndoorRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_rain_loop.wav")

	end

	if (SERVER) then
			gWeather:SetAtmosphere({
				Temperature=math.random(12,15),
				Humidity=math.random(99,100),
				Precipitation=0.4,
				Wind={
					Speed=math.random(45,55),
					Angle = 20
				},
			})
			
			local vec1=Vector(55/255,60/255,70/255)
		
			local tbl = {
			
				TopColor=vec1,
				BottomColor=vec1,
				DuskIntensity=0,
				DuskScale=0,
				SunSize=0,
						
			}
			gWeather:CreateSky()
			gWeather:SetSkyParameters(tbl)
			
			local fog = { FogColor=Color(90,90,95),FogStart=0,FogEnd={Outside=800,Inside=1500},FogDensity={Outside=0.9,Inside=0.6} }
			gWeather:CreateFog(fog)
			
			gWeather.SetMapLight("e")
			
		--	self:SpawnHail()
			
	end
	
	self:CloudTimer( 20, function() 

		if CLIENT then
			
		
		elseif SERVER then
			
			self.WindVec = gWeather:GetWindDirection()
			
			gWeather:SetAtmosphere({
				Temperature=math.random(10,26),
				Humidity=100,
				Precipitation=0.8,
				Wind={
					Speed=math.random(140,180),
					Angle = 75,
					Direction = self.WindVec
				},
			})
			
			local vec2=Vector(50/255,50/255,50/255)
			
			local tbl = {
				
				TopColor=vec2,
				BottomColor=vec2,
				DuskScale=0,
				DuskIntensity=0,
				SunSize=0
					
			}
			gWeather:SetSkyParameters(tbl)
			
			local fog = { FogColor=Color(85,90,95),FogStart=0,FogEnd={Outside=600,Inside=1200},FogDensity={Outside=1,Inside=0.9} }
			gWeather:CreateFog(fog)
			
			gWeather.SetMapLight("d")
			
		end
		
	end )
	
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:SpawnHail()
	local hail=ents.Create("gw_t2_golfball_hail")
	hail:SetPos(self:GetPos())
	hail:Spawn()
	hail:Activate()
	self:DeleteOnRemove(hail)
end

function ENT:ScreenParticleEffects()
	
	local dir=gWeather:GetWindDirection()
	local ang=dir:Angle()
	
	local effect1,effect2,impact="gw_heavy_rain","gw_downburst","gw_heavy_rain_impact"
	
	for k,ply in ipairs(player.GetAll()) do
	
		if self:TimeElapsed()<=18 then
			gWeather.Particles(ply,effect1,ang,nil,600)
			gWeather.ImpactEffects(ply,impact,500)
		else
			if math.random( 1,math.max(22-self:TimeElapsed(),1) )==1 then
				gWeather.Particles(ply,effect2,ang,nil,600)
			else
				gWeather.Particles(ply,effect1,ang,nil,600)
			end
			for i=1,2 do
				gWeather.ImpactEffects(ply,impact,500)
			end		
		end	

		if math.random(1,math.max( 4, (self:TimeElapsed()-20) ) )==1 then
			if !gWeather.IsOutside(ply,true) or !gWeather.IsFacingWind(ply) then continue end
		
			net.Start("gw_screeneffects")
				net.WriteString("hud/rain") -- texture
				net.WriteFloat(math.random(64,128)) -- size
				net.WriteFloat(math.random(0.2,0.4)) -- lifetime (in seconds)
				net.WriteFloat(2) -- movement speed
				net.WriteColor(color_white,false)
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

		self:ScreenParticleEffects()
	
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







