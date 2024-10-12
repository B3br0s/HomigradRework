AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Light Snow"
ENT.Author = "Jimmywells"

function ENT:Initialize()			
	BaseClass.Initialize(self)		
		
	if (CLIENT) then
	
		gWeather.CreateCloud("SnowClouds",Material("atmosphere/skybox/clouds_2"),Color(220,220,220,200))
	
	end
	
	if (SERVER) then

		gWeather:SetAtmosphere({
			Temperature=math.random(-10,0),
			Humidity=math.random(85,95),
			Precipitation=0.4,
			Wind={
				Speed=math.random(5,10)
			},
		})
		
		local vec=Vector(160/255,160/255,160/255)
		
		local tbl = {
			
			TopColor=vec,
			BottomColor=vec,
			DuskScale=0,
			DuskIntensity=0,
			SunSize=0
			
				
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(160,160,160),FogStart=0,FogEnd={Outside=3500,Inside=4500},FogDensity={Outside=0.5,Inside=0.4} }
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

	local effect="gw_light_snow"
	
	for k,ply in ipairs(player.GetAll()) do
		gWeather.Particles(ply,effect,ang)

		if math.random(1,20)==1 then
			if !gWeather.IsOutside(ply,true) or !gWeather.IsFacingWind(ply) then continue end
		
			net.Start("gw_screeneffects")
				net.WriteString("hud/snow") -- texture
				net.WriteFloat(math.random(128,164)) -- size
				net.WriteFloat(math.random(0.2,0.8)) -- lifetime (in seconds)
				net.WriteFloat(1) -- movement speed
				net.WriteColor(color_white,false) -- color
			net.Send(ply)
		end
	
	end
		
end

function ENT:Think()
	if (SERVER) then

		self:ScreenParticleEffects()
	
		local i = ( FrameTime() / 0.015 ) * .01
	
		self:NextThink(CurTime() + i)
		return true
	end
end

function ENT:OnRemove()

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
	
	if (CLIENT) then
		
		gWeather.RemoveCloud("SnowClouds")
		
	end
	
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







