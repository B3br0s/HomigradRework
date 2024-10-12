AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Ash Storm"
ENT.Author = "Jimmywells"

function ENT:Initialize()	
	BaseClass.Initialize(self)		

	if (CLIENT) then
		
		gWeather.CreateCloud("AshClouds",Material("atmosphere/skybox/clouds_2"),Color(70,70,70,255))
		
	end

	if (SERVER) then
	
		gWeather:SetAtmosphere({
			Temperature=math.random(32,40),
			Humidity=math.random(35,45),
			Precipitation=0.2,
			Wind={
				Speed=math.random(55,65),
				Angle=5
			},
		})
		
		local vec=Vector(20/255,20/255,20/255)
		
		local tbl = {
			
			TopColor=vec,
			BottomColor=vec,
			DuskScale=0,
			DuskIntensity=0,
			SunSize=0,
			DrawStars=false,
				
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(60,60,60),FogStart=-100,FogEnd={Outside=200,Inside=1200},FogDensity={Outside=1,Inside=0.9} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("d")
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()
	
	local dir= gWeather:GetWindDirection()
	local ang = dir:Angle()
	
	local effect="gw_ash_storm"

	for k,ply in ipairs(player.GetAll()) do
	
		gWeather.Particles(ply,effect,ang,0.5)	
		
		if gWeather.IsOutside(ply,true) then
			if ply:Alive() then
				if ply.gWeather.AshChoke==nil then ply.gWeather.AshChoke=CurTime()+math.random(2,5) end
				if ply.gWeather.AshChoke<=CurTime() then
					gWeather.DamageEntity(ply,"ash",math.random(2,4))
					ply.gWeather.AshChoke=CurTime()+math.random(4,6)
				end
			end
		
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
	
		gWeather.RemoveCloud("AshClouds")
		
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







