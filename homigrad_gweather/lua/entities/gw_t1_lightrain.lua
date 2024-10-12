AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Light Rain"
ENT.Author = "Jimmywells"

function ENT:Initialize()		
	BaseClass.Initialize(self)	

	if (CLIENT) then
	
		LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
		LocalPlayer().gWeather.Sounds["OutsideRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/light_rain_loop.wav")
		LocalPlayer().gWeather.Sounds["IndoorRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_light_rain_loop.wav")
		
		gWeather.CreateCloud("RainClouds",Material("atmosphere/skybox/clouds_1"),Color(145,145,145,255))
		
	end

	if (SERVER) then

		gWeather:SetAtmosphere({
			Temperature=math.random(10,26),
			Humidity=math.random(90,100),
			Precipitation=0.4,
			Wind={
				Speed=math.random(15,24),
				Angle=5
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
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(140,140,155),FogStart=0,FogEnd={Outside=1600,Inside=2000},FogDensity={Outside=0.5,Inside=0.4} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("h")
		
	end
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
		
		gWeather.ImpactEffects(ply,impact,500,1)
		
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
	
			if LocalPlayer().gWeather.Sounds["OutsideRain"] then
			LocalPlayer().gWeather.Sounds["OutsideRain"]:ChangeVolume((vol^3),fdt)
		end
		
		if LocalPlayer().gWeather.Sounds["IndoorRain"] then
			LocalPlayer().gWeather.Sounds["IndoorRain"]:ChangeVolume( (1-vol) * (4*vol),fdt) 
		end
	
	end

	if (SERVER) then

		self:ScreenParticleEffects()
	
		local i = ( FrameTime() / 0.015 ) * .01
	
		self:NextThink(CurTime() + i)
		return true
	end
end

function ENT:OnRemove()

	if (CLIENT) then
	
		if LocalPlayer().gWeather then
	
			if LocalPlayer().gWeather.Sounds["OutsideRain"] then
				LocalPlayer().gWeather.Sounds["OutsideRain"]:Stop()
				LocalPlayer().gWeather.Sounds["OutsideRain"]=nil	
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorRain"] then
				LocalPlayer().gWeather.Sounds["IndoorRain"]:Stop()
				LocalPlayer().gWeather.Sounds["IndoorRain"]=nil	
			end
		
		end
		
		gWeather.RemoveCloud("RainClouds")
		
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







