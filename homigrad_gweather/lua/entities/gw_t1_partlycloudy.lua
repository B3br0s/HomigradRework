AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Partly Cloudy"
ENT.Author = "Jimmywells"

function ENT:Initialize()			
	BaseClass.Initialize(self)

	local function rand(x)
		return (x+math.random(-5,5))
	end

	if (CLIENT) then
		
		self.CloudRand = math.random(1,3)
		local cloud = gWeather.CreateCloud("CloudyClouds",Material("atmosphere/skybox/clouds_"..self.CloudRand),Color(240,240,240,125),180,180*(self.CloudRand==3 and 0.5 or .8),nil,self.CloudRand==1)
		if self.CloudRand == 3 then gWeather.CreateCloud("CloudyClouds2",Material("atmosphere/skybox/clouds_"..self.CloudRand),Color(240,240,240,125),180,180*math.Rand(0.5,0.7),nil,false) end
	
	end

	if (SERVER) then

		gWeather:SetAtmosphere({
			Temperature=math.random(10,21),
			Humidity=30,
			Precipitation=0,
			Wind={
				Speed=math.random(0,5)
			},
		})
		
		local tbl = {
			
			TopColor=Vector(0,rand(100)/255,rand(250)/255),
			BottomColor=Vector(rand(40)/255,rand(120)/255,rand(170)/255),
			DuskColor = Vector(0.8,0.4,0.2),
			DuskScale=1,
			DuskIntensity=0.4,
			SunSize=12,
			
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(rand(110),rand(110),rand(140)),FogStart=0,FogEnd={Outside=24000,Inside=30000},FogDensity={Outside=0.4,Inside=0.3} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("m")

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
		gWeather.RemoveCloud("CloudyClouds2")
	
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







