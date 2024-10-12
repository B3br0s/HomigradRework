AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Derecho"
ENT.Author = "Jimmywells"

function ENT:Initialize()	
	BaseClass.Initialize(self)			
			
	self.StartTime = CurTime()
			
	if (CLIENT) then

		gWeather.CreateCloud("TestClouds",Material("atmosphere/skybox/clouds_1"),Color(90,90,90,255))

		LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
		LocalPlayer().gWeather.Sounds["OutsideRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/rain_loop.wav")
		LocalPlayer().gWeather.Sounds["IndoorRain"] = gWeather.LoopSfx(LocalPlayer(),"weather/rain/interior_rain_loop.wav")

		hook.Add( "RenderScreenspaceEffects", "gWeather.DColorModify", function()
			local tab = {
				[ "$pp_colour_addr" ] = 0.0,
				[ "$pp_colour_addg" ] = 0.0,
				[ "$pp_colour_addb" ] = 0,
				[ "$pp_colour_brightness" ] = -(gWeather:GetOutsideFactor()/1800),
				[ "$pp_colour_contrast" ] = 1-(gWeather:GetOutsideFactor()/1000),
				[ "$pp_colour_colour" ] = 1,
				[ "$pp_colour_mulr" ] = 0,
				[ "$pp_colour_mulg" ] = 0,
				[ "$pp_colour_mulb" ] = 0
			}
				
			DrawColorModify( tab )
		end )
				

	end
	
	if (SERVER) then
		
		local floorvec=gWeather:GetFloorVector(true)
			
		local opt = {
				Vector(0,gWeather:GetWorldBounds()[math.random(1,2)].y,floorvec),
				Vector(gWeather:GetWorldBounds()[math.random(1,2)].x,0,floorvec),
			}	

		self.ParticleBounds = opt[math.random(#opt)]
		self.Angle = (Vector(0,0,floorvec) - self.ParticleBounds):Angle()

		local inv = Vector(self.ParticleBounds.y,self.ParticleBounds.x,0)
		
			gWeather:SetAtmosphere({
				Temperature=math.random(18,20),
				Humidity=math.random(95,100),
				Precipitation=0.7,
				Wind={
					Speed=math.random(120,180),
					Angle=60,
					Direction=self.Angle:Forward(),
					Bounds = {self.ParticleBounds-inv,self.ParticleBounds-inv}
				},
			})
			
			local vec = Vector(30/255,30/255,30/255)

			local tbl = {
				
				TopColor=vec,
				BottomColor=vec,
				DuskScale=0,
				DuskIntensity=0,
				DuskColor=Vector(1,50/255,0),
				SunSize=0
					
			}
			gWeather:CreateSky()
			gWeather:SetSkyParameters(tbl)
			
			local fog = { FogColor=Color(50,50,50),FogStart=0,FogEnd={Outside=2000,Inside=2200},FogDensity={Outside=0.5,Inside=0.5} }
			gWeather:CreateFog(fog)

			gWeather.SetMapLight("f")		
			
		--	ParticleEffect("gw_derecho",self.ParticleBounds*.99,self.Angle,self)
		
		timer.Simple(0.5,function() -- have to put a timer on this or else ent doesn't exist on client yet
			if !IsValid(self) then return end
			net.Start( "gw_particle_fix" ) 
				net.WriteString("gw_derecho")
				net.WriteVector(self.ParticleBounds)
				net.WriteAngle(self.Angle)
				net.WriteUInt(tonumber(self:EntIndex()),8)
			net.Broadcast()
		end)

		timer.Simple(20,function()
			if !IsValid(self) then return end
			gWeather:SetWind(nil,self.Angle:Forward(),60,nil)
		end)
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if (gWeather:GetCeilingVector(true)-gWeather:GetFloorVector(true)) < 12000 then ply:ChatPrint( "This skybox is too short! Try spawning this on a map with a taller skybox." ) return end

	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:GetTimeElapsed()
	return CurTime() - self.StartTime
end

function ENT:ScreenParticleEffects()

	local dir=gWeather:GetWindDirection()
	local ang=dir:Angle()
	
	local effect1,effect2,impact="gw_heavy_rain","gw_extreme_rain","gw_heavy_rain_impact"

	if self:GetTimeElapsed()<=20 then 
		local bounds = gWeather:GetWindLocalBounds()

		for k,ply in ipairs(player.GetAll()) do
		
			if !ply:GetPos():WithinAABox( bounds[1], bounds[2] ) then continue end
				
			local pos = ply:GetPos()
			local dist = (((pos-bounds[2])*dir):Length()/6000)
			
			if math.random(1,2)==1 then
				if !gWeather.IsFacingWind(ply) then continue end
					net.Start("gw_screeneffects")
					net.WriteString("hud/rain") -- texture
					net.WriteFloat(math.random(64,128)) -- size
					net.WriteFloat(math.random(0.2,0.4)) -- lifetime (in seconds)
					net.WriteFloat(4) -- movement speed
					net.WriteColor(color_white,false) -- color
				net.Send(ply)		
			end

			if math.random(1,math.max(1,dist))==1 then 	-- light
				gWeather.Particles(ply,effect1,ang,0.85,600)
				gWeather.ImpactEffects(ply,impact,500,1)
			else	-- heavy
				gWeather.Particles(ply,effect2,ang,1,600)
				gWeather.ImpactEffects(ply,impact,300,1)

			end
				
		end	
		
	else

		for k,ply in ipairs(player.GetAll()) do
		
			gWeather.Particles(ply,effect2,ang,1,600)
			gWeather.ImpactEffects(ply,impact,200,1)

			if !gWeather.IsOutside(ply,true) then continue end

			if math.random(1,2)==1 then
				if !gWeather.IsFacingWind(ply) then continue end
				net.Start("gw_screeneffects")
					net.WriteString("hud/rain") -- texture
					net.WriteFloat(math.random(64,128)) -- size
					net.WriteFloat(math.random(0.2,0.4)) -- lifetime (in seconds)
					net.WriteFloat(4) -- movement speed
					net.WriteColor(color_white,false) -- color
				net.Send(ply)		
			end

		end	
		
	end
	
	
	
end

function ENT:Push(i_time)
	local t = (math.max(0,(self:GetTimeElapsed()-i_time-0.5))*1500)
	local b, f = self.ParticleBounds, self.Angle:Forward()

	local inv = Vector(b.y,b.x,0)
	local b1, b2 = b-inv, b+inv+(f*t)+Vector(0,0,6800)
	
	gWeather:SetWindLocalBounds(b2)
end

function ENT:Think()
	if CLIENT then
	
		if GetConVar("gw_screenshake"):GetInt()==1 then util.ScreenShake( Vector(0,0,0), 1*(gWeather:GetOutsideFactor()/100), 10, 0.25, 0 ) end 
		
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

		if self:GetTimeElapsed()<20 then self:Push(0) end
	
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
	
		hook.Remove("RenderScreenspaceEffects", "gWeather.DColorModify")

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

		gWeather.RemoveCloud("TestClouds")

	end
	
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







