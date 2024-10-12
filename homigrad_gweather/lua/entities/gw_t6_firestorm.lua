AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Firestorm"
ENT.Author = "Jimmywells"

function ENT:Initialize()		
	BaseClass.Initialize(self)

	if (CLIENT) then
	
		LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
		LocalPlayer().gWeather.Sounds["OutsideFire"] = gWeather.LoopSfx(LocalPlayer(),"weather/fire/firestorm_loop.wav")
		LocalPlayer().gWeather.Sounds["IndoorFire"] = gWeather.LoopSfx(LocalPlayer(),"weather/fire/interior_firestorm_loop.wav")
		
		hook.Add( "RenderScreenspaceEffects", "gWeather.FSColorModify", function()
			local tab = {
				[ "$pp_colour_addr" ] = 0.15*(gWeather:GetOutsideFactor()/100),
				[ "$pp_colour_addg" ] = 0.0,
				[ "$pp_colour_addb" ] = 0.0,
				[ "$pp_colour_brightness" ] = 0,
				[ "$pp_colour_contrast" ] = 1,
				[ "$pp_colour_colour" ] = 0.9,
				[ "$pp_colour_mulr" ] = 0,
				[ "$pp_colour_mulg" ] = 0,
				[ "$pp_colour_mulb" ] = 0
					}
				
			DrawColorModify( tab )
		end )
		
	end

	if (SERVER) then
	
		gWeather:SetAtmosphere({
			Temperature=math.random(75,95),
			Humidity=0,
			Precipitation=0,
			Wind={
				Speed=math.random(85,110),
				Angle=50
			},
		})

		local tbl = {
			
			TopColor=Vector(.38,0,0),
			BottomColor=Vector(.68,0,0),
			DuskScale=0,
			DuskIntensity=0,
			SunSize=0
				
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=Color(156,20,20),FogStart=0,FogEnd={Outside=600,Inside=1500},FogDensity={Outside=0.9,Inside=0.85} }
		gWeather:CreateFog(fog)
		
		gWeather.SetMapLight("b")
		
		self.NextLightningTime=CurTime()+math.random(15,30)
		
		self.FireTime = CurTime()
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()
	
	local dir=gWeather:GetWindDirection()
	local ang=dir:Angle()
	
	local effect,impact="gw_firestorm"
	local col = Color(255,80,80)

	for k,ply in ipairs(player.GetAll()) do
	
		gWeather.Particles(ply,effect,ang,.9,600)

		if math.random(1,32)==1 then
			if !gWeather.IsOutside(ply,true) then continue end
			gWeather.DamageEntity(ply,"fire",1)
			if !gWeather.IsFacingWind(ply) then continue end
			
		
			net.Start("gw_screeneffects")
				net.WriteString("effects/fas_glow_debris") -- texture
				net.WriteFloat(math.random(200,256)) -- size
				net.WriteFloat(math.random(0.5,1)) -- lifetime (in seconds)
				net.WriteFloat(4) -- movement speed
				net.WriteColor(col,false) -- color
			net.Send(ply)		
		end
		
	end

end

function ENT:IgniteProps(t)

	for k,ent in RandomPairs(ents.FindByClass("prop_physics")) do
		if self.FireTime+t>CurTime() then return end
		if !IsValid(ent) then continue end
		if ent:IsOnFire() then continue end
		
		ent:Ignite(math.random(2,3))
		self.FireTime=CurTime()+t
	end

end

function ENT:Think()
	if (CLIENT) then
		
		local vol = (gWeather:GetOutsideFactor()/100)
		local fdt=0.15
	
		if LocalPlayer().gWeather.Sounds["OutsideFire"] then
			LocalPlayer().gWeather.Sounds["OutsideFire"]:ChangeVolume((vol^3),fdt)
		end
		
		if LocalPlayer().gWeather.Sounds["IndoorFire"] then
			LocalPlayer().gWeather.Sounds["IndoorFire"]:ChangeVolume( (1-vol) * (4*vol),fdt) 
		end

	end

	if (SERVER) then
	
		self:IgniteProps(1)

		self:ScreenParticleEffects()
	
		local i = ( FrameTime() / 0.015 ) * .01
		
		self:NextThink(CurTime()+i)
		return true
	end
end

function ENT:OnRemove()

	if (CLIENT) then
	
		hook.Remove("RenderScreenspaceEffects", "gWeather.FSColorModify")
	
		if LocalPlayer().gWeather then
	
			if LocalPlayer().gWeather.Sounds["OutsideFire"] then
				LocalPlayer().gWeather.Sounds["OutsideFire"]:Stop()
				LocalPlayer().gWeather.Sounds["OutsideFire"]=nil	
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorFire"] then
				LocalPlayer().gWeather.Sounds["IndoorFire"]:Stop()
				LocalPlayer().gWeather.Sounds["IndoorFire"]=nil	
			end
		
		end
		
	--	gWeather.RemoveCloud("RainClouds")
		
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







