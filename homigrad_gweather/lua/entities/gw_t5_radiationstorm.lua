AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Radiation Storm"
ENT.Author = "Jimmywells"

function ENT:Initialize()	
	BaseClass.Initialize(self)		

	if (CLIENT) then
	
		LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
		LocalPlayer().gWeather.Sounds["OutsideRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/acid_rain_loop.wav")
		LocalPlayer().gWeather.Sounds["IndoorRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_acid_rain_loop.wav")
		
		
		gWeather.CreateCloud("RainClouds",Material("atmosphere/skybox/clouds_1"),Color(75,125,75,255))
		
	end

	if (SERVER) then
	
		gWeather:SetAtmosphere({
			Temperature=math.random(10,26),
			Humidity=100,
			Precipitation=0.6,
			Wind={
				Speed=math.random(130,155),
				Angle=35
			},
		})
		
		local tbl = {
			
			TopColor=Vector(0.05,0.26,0.10),
			BottomColor=Vector(0.05,0.20,0.05),
			DuskScale=0,
			DuskIntensity=0,
			SunSize=0
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(0.24*255,0.39*255,0.18*255),FogStart=0,FogEnd={Outside=400,Inside=1200},FogDensity={Outside=0.8,Inside=0.5} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("d")
		
		self.NextLightningTime=CurTime()+math.random(2,5)
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()
	
	local dir=gWeather:GetWindDirection()
	local ang=dir:Angle()
	
	local effect,impact="gw_radiation_storm","gw_acid_storm_impact"
	local col = Color(155,255,155)

	for k,ply in ipairs(player.GetAll()) do
		if !IsValid(ply) then return end
	
		gWeather.Particles(ply,effect,ang,1,600)

		for i=1,2 do
			gWeather.ImpactEffects(ply,impact,500)
		end		

		if math.random(1,2)==1 then
			if !gWeather.IsOutside(ply,true) then continue end
			
			if gWeather.IsFacingWind(ply) then 
				net.Start("gw_screeneffects")
					net.WriteString("hud/rain") -- texture
					net.WriteFloat(math.random(64,128)) -- size
					net.WriteFloat(math.random(0.2,0.4)) -- lifetime (in seconds)
					net.WriteFloat(4) -- movement speed
					net.WriteColor(col,false) -- color
				net.Send(ply)
			end
			
			if ply:Alive() then
				if ply.gWeather.Rad_Hurt==nil then ply.gWeather.Rad_Hurt=CurTime()+math.random(0,2) end
				if ply.gWeather.Rad_Hurt<=CurTime() then
					gWeather.DamageEntity(ply,"acid",1)
					ply.gWeather.Rad_Hurt=CurTime()+math.random(0,1)
				end
			end
			
		end
		
	end

end


function ENT:LightningSpawn()
	if self.NextLightningTime>CurTime() then return end

	if SERVER then

		local startpos = gWeather:GetRandomBounds(true)

		local bolt = ents.Create("gw_lightningbolt")
		bolt:SetPos(startpos)
		bolt:Spawn()
		bolt:Activate()

	end
	
	self.NextLightningTime=CurTime()+math.random(3,5)
end

function ENT:Think()
	if (CLIENT) then
	
		local vol = (gWeather:GetOutsideFactor()/100)
		local fdt=0.15
	
		if LocalPlayer().gWeather.Sounds["OutsideRain"] then
			LocalPlayer().gWeather.Sounds["OutsideRain"]:ChangeVolume((vol^3)*0.4,fdt)
		end
		
		if LocalPlayer().gWeather.Sounds["IndoorRain"] then
			LocalPlayer().gWeather.Sounds["IndoorRain"]:ChangeVolume( (1-vol) * (4*vol) *0.8,fdt) 
		end
	
	end

	if (SERVER) then

		self:LightningSpawn()

		self:ScreenParticleEffects()
	
		local i = ( FrameTime() / 0.015 ) * .01
		
		self:NextThink(CurTime()+i)
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







