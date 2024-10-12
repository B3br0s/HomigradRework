AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Cloudy"
ENT.Author = "Jimmywells"

function ENT:Initialize()			
	BaseClass.Initialize(self)

	if (CLIENT) then
		
		self.CloudRand = math.random(1,2)
		local cloud = gWeather.CreateCloud("CloudyClouds",Material("atmosphere/skybox/clouds_"..self.CloudRand),Color(110,110,110),180,180*(.8))
	
	end

	if (SERVER) then

		gWeather:SetAtmosphere({
			Temperature=math.random(10,21),
			Humidity=60,
			Precipitation=0.1,
			Wind={
				Speed=math.random(0,5)
			},
		})
		
		local tbl = {
			
			TopColor=gWeather.ColorVector(Color(50,55,60)),
			BottomColor=gWeather.ColorVector(Color(70,70,70)),
			DuskScale=1,
			DuskIntensity=1,
			SunSize=0,
			DuskColor = Vector(0.01,0.01,0.01)
			
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(110,110,112),FogStart=0,FogEnd={Outside=10000,Inside=12000},FogDensity={Outside=0.5,Inside=0.4} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("i")

	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()

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
	
		gWeather.RemoveCloud("CloudyClouds")
	
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







