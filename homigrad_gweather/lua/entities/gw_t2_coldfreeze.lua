AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Cold Freeze"
ENT.Author = "Jimmywells"

function ENT:Initialize()			
	BaseClass.Initialize(self)	
		
	if (CLIENT) then
	
		local cloud = gWeather.CreateCloud("SnowClouds",Material("atmosphere/skybox/clouds_2"),Color(255,255,255,35))
	
	end
	
	if (SERVER) then

		gWeather:SetAtmosphere({
			Temperature=math.random(-35,-25),
			Humidity=math.random(20,40),
			Precipitation=0.05,
			Wind={
				Speed=math.random(2,5)
			},
		})
		
		local tbl = {
			
			TopColor=Vector(.2,.5,1),
			BottomColor=Vector(.8,1,1),
			DuskScale=0.5,
			DuskIntensity=1,
			DuskColor=Vector(1.00,0.20,0.00)
				
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(200,200,220),FogStart=0,FogEnd={Outside=3500,Inside=4500},FogDensity={Outside=0.2,Inside=0.2} }
		gWeather:CreateFog(fog)

		gWeather.SetMapLight("f")
		
		self.IceCount=0
		self.NextSpawnTime=CurTime()+math.random(5,10)
		
	--	physenv.SetAirDensity(2.8)
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

local function SpawnIce(self)
	if file.Exists("autorun/gdisasters_load.lua","LUA") then -- check if mounted
		local ice = ents.Create( "gd_d1_ice" )
		ice:SetPos(gWeather:GetRandomBounds(true))
		ice:Spawn()
		ice:Activate()	
		self:DeleteOnRemove(ice)
	end
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
		
		if CurTime()>=self.NextSpawnTime and self.IceCount<20 then
			SpawnIce(self)
			self.IceCount=self.IceCount+1
			self.NextSpawnTime=CurTime()+math.random(10,20)
		end
	
		local i = ( FrameTime() / 0.015 ) * .01
	
		self:NextThink(CurTime() + i*50)
		return true
	end
end

function ENT:OnRemove()

	if (SERVER) then	
	
	--	physenv.SetAirDensity(2)
	
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







