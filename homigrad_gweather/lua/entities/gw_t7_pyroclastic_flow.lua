AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Pyroclastic Flow"
ENT.Author = "Jimmywells"

function ENT:GetTimeElapsed()
	if self.SpawnTime==nil then return 0 end
	return (CurTime()-self.SpawnTime)/self.TimeMult
end

function ENT:Initialize()				
	BaseClass.Initialize(self)		
			
	self.SpawnTime=CurTime()
	self.TimeMult=math.max(15,GetConVar("gw_weather_lifetime"):GetInt())/15
			
	if (CLIENT) then
		
			gWeather.CreateCloud("AshClouds",Material("atmosphere/skybox/clouds_2"),Color(90,90,90,255))
			
			timer.Simple(10.5*self.TimeMult,function()
				if !IsValid(self) then return end
				--gWeather.SetCloudColor("AshClouds",Color(60,60,60))	
				
				hook.Add( "RenderScreenspaceEffects", "gWeather.PFColorModify", function()
					local tab = {
						[ "$pp_colour_addr" ] = 0.0,
						[ "$pp_colour_addg" ] = 0.0,
						[ "$pp_colour_addb" ] = 0.0,
						[ "$pp_colour_brightness" ] = -(gWeather:GetOutsideFactor()/1500),
						[ "$pp_colour_contrast" ] = 1-(gWeather:GetOutsideFactor()/200),
						[ "$pp_colour_colour" ] = 1,
						[ "$pp_colour_mulr" ] = 0,
						[ "$pp_colour_mulg" ] = 0,
						[ "$pp_colour_mulb" ] = 0
					}
				
					DrawColorModify( tab )
				end )
				
				
			end)
			
		
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

		self:EmitSound("atmosphere/distant_rumble.mp3", 0)
			
			gWeather:SetAtmosphere({
				Temperature=math.random(32,35),
				Humidity=math.random(35,45),
				Precipitation=0,
				Wind={
					Speed=math.random(5,10),
					Angle=0,
					Direction=self.Angle:Forward()
				},
			})
			
			local tbl = {
				
				TopColor=Vector(20/255,20/255,20/255),
				BottomColor=Vector(40/255,40/255,40/255),
				DuskScale=0,
				DuskIntensity=0,
				SunSize=0
					
			}
			gWeather:CreateSky()
			gWeather:SetSkyParameters(tbl)
			
			local fog = { FogColor=Color(60,60,60),FogStart=0,FogEnd={Outside=2000,Inside=2200},FogDensity={Outside=0.5,Inside=0.3} }
			gWeather:CreateFog(fog)

			gWeather.SetMapLight("f")		

		timer.Simple(10*self.TimeMult,function()
			if !IsValid(self) then return end
		
			gWeather:SetAtmosphere({
				Temperature=math.random(100,200),
				Humidity=0,
				Precipitation=0,
				Wind={
					Speed=math.random(400,700),	--math.random(105,125),
					Angle=90,
					Direction=self.Angle:Forward(),
					Bounds = {self.ParticleBounds-inv,self.ParticleBounds-inv}
				},
			})
		
			local fog = { FogColor=Color(30,30,30),FogStart=0,FogEnd={Outside=200,Inside=1500},FogDensity={Outside=.7,Inside=0.6},FogSpeed=0.25 }
			gWeather:CreateFog(fog)

		
		--	ParticleEffect("gw_pyroclastic_flow",self.ParticleBounds*.99,self.Angle,self)
			
			net.Start( "gw_particle_fix" ) 
				net.WriteString("gw_pyroclastic_flow")
				net.WriteVector(self.ParticleBounds)
				net.WriteAngle(self.Angle)
				net.WriteUInt(tonumber(self:EntIndex()),8)
			net.Broadcast()
			

			timer.Simple(15*self.TimeMult,function()
				if !IsValid(self) then return end
				self:Remove()
			end)
			
		end)
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()
	
	local dir= gWeather:GetWindDirection()
	local ang = dir:Angle()
	
	local effect="gw_ash_storm_debrie"
	local col = Color(35,35,35)

	for k,ply in ipairs(player.GetAll()) do
	
		if self:GetTimeElapsed()<10 then 
			gWeather.Particles(ply,effect,ang,0.5)	
		elseif gWeather.IsOutside(ply,true) then
			
			if math.random(1,5)==1 then gWeather.DamageEntity(ply,"ash",1) end

			if gWeather.IsFacingWind(ply) then
				net.Start("gw_screeneffects")
					net.WriteString("particle/snow") -- texture
					net.WriteFloat(math.random(32,64)) -- size
					net.WriteFloat(math.random(0.15,0.25)) -- lifetime (in seconds)
					net.WriteFloat(0) -- movement speed
					net.WriteColor(col,false) -- color
				net.Send(ply)	
			end	
		end

	end
	
end

function ENT:Push(i_time)
	local t = ((self:GetTimeElapsed()-i_time)*4800)
	local b, f = self.ParticleBounds, self.Angle:Forward()

	local inv = Vector(b.y,b.x,0)
	local b1, b2 = b-inv, b+inv+(f*t)+Vector(0,0,5000)
	
	if ((b2*f):Length())>(gWeather.Vector2D(self.ParticleBounds):Length()) then return end
	
	gWeather:SetWindLocalBounds(b2)
end

function ENT:Think()
	if CLIENT then
	
		
		if self:GetTimeElapsed()>11 then 
			if GetConVar("gw_screenshake"):GetInt()==1 then util.ScreenShake( Vector(0,0,0), 2*(gWeather:GetOutsideFactor()/100), 10, 0.25, 0 ) end 
		else
			util.ScreenShake( Vector(0,0,0), -0.004*((self:GetTimeElapsed()-2)^2) + 0.25, 5, 0.25, 0 )
		end
		
	end

	if (SERVER) then
	
		self:ScreenParticleEffects()

		if self:GetTimeElapsed()>=10 and self:GetTimeElapsed()<=30 then self:Push(10) end
	
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
	
		hook.Remove("RenderScreenspaceEffects", "gWeather.PFColorModify")

		gWeather.RemoveCloud("AshClouds")

	end
	
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







