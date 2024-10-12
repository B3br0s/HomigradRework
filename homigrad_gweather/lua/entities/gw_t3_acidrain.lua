AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Acid Rain"
ENT.Author = "Jimmywells"

function ENT:Initialize()	
	BaseClass.Initialize(self)		

	if (CLIENT) then
	
		LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
		LocalPlayer().gWeather.Sounds["OutsideRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/light_rain_loop.wav")
		LocalPlayer().gWeather.Sounds["IndoorRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_light_rain_loop.wav")
		
		
		gWeather.CreateCloud("AcidRainClouds",Material("atmosphere/skybox/clouds_1"),Color(100,145,100,255))
		
	end

	if (SERVER) then
	
		gWeather:SetAtmosphere({
			Temperature=math.random(10,26),
			Humidity=math.random(90,100),
			Precipitation = 0.3,
			Wind={
				Speed=math.random(32,48),
				Angle=5
			},
		})
		
		local vec=Vector(40/255,80/255,40/255)
		
		local tbl = {
			
			TopColor=vec,
			BottomColor=vec,
			DuskScale=0,
			DuskIntensity=0,
			SunSize=0
				
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(90,160,90),FogStart=0,FogEnd={Outside=400,Inside=1200},FogDensity={Outside=0.6,Inside=0.6} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("g")

		self.NextAcidTime=CurTime()+math.random(0.2,0.5)
	
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()
	
	local dir=gWeather:GetWindDirection()
	local ang=dir:Angle()
	
	local effect,impact="gw_acid_rain","gw_acid_rain_impact"
	local col = Color(185,255,185)

	for k,ply in ipairs(player.GetAll()) do
	
		gWeather.Particles(ply,effect,ang,0.75,600)

		gWeather.ImpactEffects(ply,impact,500)

		if math.random(1,4)==1 then
			if !gWeather.IsOutside(ply,true) then continue end
				if ply.gWeather.AcidHurt==nil then ply.gWeather.AcidHurt=CurTime()+math.random(0,3) end
				if ply.gWeather.AcidHurt<=CurTime() then
					gWeather.DamageEntity(ply,"acid",1)
					ply.gWeather.AcidHurt=CurTime()+math.random(2,3)
				end
			if !gWeather.IsFacingWind(ply) then continue end
		
			net.Start("gw_screeneffects")
				net.WriteString("hud/rain") -- texture
				net.WriteFloat(math.random(64,128)) -- size
				net.WriteFloat(math.random(0.2,0.4)) -- lifetime (in seconds)
				net.WriteFloat(2) -- movement speed
				net.WriteColor(col,false) -- color
			net.Send(ply)		
		end
		
	end

end

function ENT:DestroyProps()
	if self.NextAcidTime>CurTime() then return end

	for k,ent in RandomPairs(ents.FindByClass("prop_physics")) do
		if !IsValid(ent) then continue end
	--	if tostring(ent:GetMaterialType())!="77" then continue end
		if !gWeather.IsOutside(ent,true) then continue end
		
		local col = ent:GetColor()
		col.r=math.max(0,col.r-0.01) col.g=math.max(0,col.g-0.01) col.b=math.max(0,col.b-0.01)
		ent:SetColor(col)
		if col==Color(0,0,0) then SafeRemoveEntity(ent) end
		
		self.NextAcidTime=CurTime()+math.random(0.2,0.5)
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

		self:DestroyProps()

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
		
		gWeather.RemoveCloud("AcidRainClouds")
		
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







