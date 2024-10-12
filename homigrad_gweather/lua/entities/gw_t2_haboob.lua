AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Haboob"
ENT.Author = "Jimmywells"

function ENT:Initialize()		
	BaseClass.Initialize(self)	

	self.StartTime = CurTime()

	if (CLIENT) then
	
		LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
		LocalPlayer().gWeather.Sounds["OutsideDust"] = gWeather.LoopSfx(LocalPlayer(),"weather/haboob/haboob_loop.wav")
		LocalPlayer().gWeather.Sounds["InsideDust"] = gWeather.LoopSfx(LocalPlayer(),"weather/haboob/interior_haboob_loop.wav")
		
		hook.Add( "RenderScreenspaceEffects", "gWeather.HColorModify", function()
			local tab = {
				[ "$pp_colour_addr" ] = 0.0,
				[ "$pp_colour_addg" ] = 0.0,
				[ "$pp_colour_addb" ] = 0,
				[ "$pp_colour_brightness" ] = -(gWeather:GetOutsideFactor()/1400),
				[ "$pp_colour_contrast" ] = 1,
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
				Temperature=math.random(26,30),
				Humidity=math.random(8,15),
				Precipitation=0,
				Wind={
					Speed=math.random(35,60),
					Angle=60,
					Direction=self.Angle:Forward(),
					Bounds = {self.ParticleBounds-inv,self.ParticleBounds-inv}
				},
			})
		
	--	ParticleEffect("gw_haboob_cloud",self.ParticleBounds*.99,self.Angle,self)

		timer.Simple(0.5,function() -- have to put a timer on this or else ent doesn't exist on client yet
			if !IsValid(self) then return end
			net.Start( "gw_particle_fix" ) 
				net.WriteString("gw_haboob_cloud")
				net.WriteVector(self.ParticleBounds)
				net.WriteAngle(self.Angle)
				net.WriteUInt(tonumber(self:EntIndex()),8)
			net.Broadcast()
		end)

		timer.Simple(20,function()
			if !IsValid(self) then return end
			gWeather:SetWind(nil,self.Angle:Forward(),60,nil)
		end)	

		local vec=Vector(110/255,52/255,25/255)
		
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
		
		local fog = { FogColor=Color(180,120,75),FogStart=0,FogEnd={Outside=10,Inside=1000},FogDensity={Outside=0.9,Inside=0.4} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("f")
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:GetTimeElapsed()
	return CurTime() - self.StartTime
end

function ENT:ScreenParticleEffects()

	local dir= gWeather:GetWindDirection()
	local ang = dir:Angle()
	
	local effect="gw_haboob"

	local bounds = gWeather:GetWindLocalBounds()
	for k,ply in ipairs(player.GetAll()) do
		if self:GetTimeElapsed()<20 and !ply:GetPos():WithinAABox( bounds[1], bounds[2] ) then continue end
		gWeather.Particles(ply,effect,ang)
	end

end

function ENT:Push(i_time)
	local t = (math.max(0,(self:GetTimeElapsed()-i_time-0.5))*1800)
	local b, f = self.ParticleBounds, self.Angle:Forward()

	local inv = Vector(b.y,b.x,0)
	local b1, b2 = b-inv, b+inv+(f*t)+Vector(0,0,6800)
	
	if ((b2*f):Length())>(gWeather.Vector2D(self.ParticleBounds):Length()) then return end
	
	gWeather:SetWindLocalBounds(b2)
end

function ENT:Think()
	if (CLIENT) then
		
		local vol = (gWeather:GetOutsideFactor()/100)
		local fdt=0.25
	
		if LocalPlayer().gWeather.Sounds["OutsideDust"] then
			LocalPlayer().gWeather.Sounds["OutsideDust"]:ChangeVolume(vol*.75,fdt)
		end
		
		if LocalPlayer().gWeather.Sounds["InsideDust"] then
			LocalPlayer().gWeather.Sounds["InsideDust"]:ChangeVolume( (1-vol) * (4*vol),fdt)
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

	if (CLIENT) then
	
		hook.Remove("RenderScreenspaceEffects", "gWeather.HColorModify")
	
		if LocalPlayer().gWeather then
	
			if LocalPlayer().gWeather.Sounds["OutsideDust"] then
				LocalPlayer().gWeather.Sounds["OutsideDust"]:Stop()
				LocalPlayer().gWeather.Sounds["OutsideDust"]=nil	
			end
			
			if LocalPlayer().gWeather.Sounds["InsideDust"] then
				LocalPlayer().gWeather.Sounds["InsideDust"]:Stop()
				LocalPlayer().gWeather.Sounds["InsideDust"]=nil	
			end
		
		end
		
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end
