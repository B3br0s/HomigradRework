AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Heavy Fog"
ENT.Author = "Jimmywells"

function ENT:Initialize()	
	BaseClass.Initialize(self)		

	if (CLIENT) then
	
	end

	if (SERVER) then
	
		gWeather:SetAtmosphere({
			Temperature=math.random(5,15),
			Humidity=math.Rand(99,100),
			Precipitation=0.15,
			Wind={
				Speed=math.random(0,2)
			},
		})
		
		local vec=Vector(100/255,100/255,100/255)
		
		local tbl = {
			
			TopColor=vec,
			BottomColor=vec,
			DuskScale=0,
			DuskIntensity=0,
			SunSize=0,
			
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(150,150,150),FogStart=-150,FogEnd={Outside=500,Inside=850},FogDensity={Outside=0.8,Inside=0.8} }
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
	
	local effect="gw_heavy_fog"

	for k,ply in ipairs(player.GetAll()) do
		gWeather.Particles(ply,effect,ang)

		if math.random(1,24)==1 then
			if !gWeather.IsOutside(ply,true) or !gWeather.IsFacingWind(ply) then continue end
		
			net.Start("gw_screeneffects")
				net.WriteString("hud/rain") -- texture
				net.WriteFloat(math.random(64,128)) -- size
				net.WriteFloat(math.random(0.2,0.4)) -- lifetime (in seconds)
				net.WriteFloat(1) -- movement speed
				net.WriteColor(color_white,false) -- color
			net.Send(ply)		
		end
		
	end

end


function ENT:Think()
	if (CLIENT) then
	
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
	
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







