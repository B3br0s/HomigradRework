AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Sleet"
ENT.Author = "Jimmywells"

function ENT:Initialize()			
	BaseClass.Initialize(self)

	if (CLIENT) then
	
		LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
		LocalPlayer().gWeather.Sounds["OutsideRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/rain_loop2.wav")
		LocalPlayer().gWeather.Sounds["IndoorRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_rain_loop.wav")
		
		gWeather.CreateCloud("SleetClouds",Material("atmosphere/skybox/clouds_1"),Color(170,170,170,255))
		
	end

	if (SERVER) then

		gWeather:SetAtmosphere({
			Temperature=math.random(1,4),
			Humidity=math.random(98,100),
			Precipitation=0.4,
			Wind={
				Speed=math.random(25,30),
				Angle=20
			},
		})
		
		local vec=Vector(110/255,110/255,110/255)
	
		local tbl = {
		
			TopColor=vec,
			BottomColor=vec,
			DuskScale=0,
			DuskIntensity=0,
			SunSize=0,
		
		
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)

		local fog = { FogColor=Color(180,180,190),FogStart=0,FogEnd={Outside=1000,Inside=2000},FogDensity={Outside=0.6,Inside=0.5} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("h")
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()
	
	local dir= gWeather:GetWindDirection()
	local ang = dir:Angle()
	
	local effect,impact="gw_sleet","gw_light_rain_impact"
	
	for k,ply in ipairs(player.GetAll()) do
		gWeather.Particles(ply,effect,ang,nil,700)
		
		gWeather.ImpactEffects(ply,impact,600)
		
		if math.random(1,6)==1 then
			if !gWeather.IsOutside(ply,true) then continue end
		
			net.Start("gw_screeneffects")
				net.WriteString(table.Random({"hud/rain","hud/snow"})) -- texture
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
		local fdt=0.25
	
		if LocalPlayer().gWeather.Sounds["OutsideRain"] then
			LocalPlayer().gWeather.Sounds["OutsideRain"]:ChangeVolume(vol,fdt)
		end
		
		if LocalPlayer().gWeather.Sounds["IndoorRain"] then
			LocalPlayer().gWeather.Sounds["IndoorRain"]:ChangeVolume( (1-vol) * (2*vol),fdt) -- a little quieter than main rain
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
		
		gWeather.RemoveCloud("SleetClouds")
		
		end
		
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







