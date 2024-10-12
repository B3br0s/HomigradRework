AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Heavy Snow"
ENT.Author = "Jimmywells"

function ENT:Initialize()		
	BaseClass.Initialize(self)
		
	local function SnowSteps()
		hook.Add( "PlayerFootstep", "gWeather-SnowSteps", function( ply, pos, foot, sound, volume, rf )
			local tr = util.TraceLine( { start = ply:GetPos(), endpos = ply:GetPos()-Vector(0,0,50), filter=ply } )
			if !tr.Hit then return false end
			if tr.HitNonWorld then return false end
		
			local groundtex=Material(tr.HitTexture):GetTexture("$basetexture"):GetName()
			local g_type = util.GetSurfacePropName(tr.SurfaceProps) 
			
			local g_satisfy = (g_type == "grass" or g_type == "dirt" or g_type == "snow" or g_type == "default") and true or false -- or g_type == "sand"
		
			if groundtex =="nature/snowfloor002a" or (groundtex=="error" and g_satisfy ) then
				ply:EmitSound("footsteps/gw_snow"..tostring(math.random(1,6))..".wav")
				return true
			end	
		end )
	end	
		
	if game.SinglePlayer() then
		if SERVER then
			SnowSteps()
		end
	else
		if CLIENT then
			SnowSteps()
		end
	end		
		
	if (CLIENT) then
		gWeather.Terrain.SetColor(Vector(0.6,0.6,0.6))
		gWeather.Terrain.SetBaseTexture("nature/snowfloor002a")
		
		gWeather.CreateCloud("SnowClouds",Material("atmosphere/skybox/clouds_2"),Color(220,220,220,0))
		
	end
	
	if (SERVER) then
		
		gWeather:SetAtmosphere({
			Temperature=math.random(-2,-30),
			Humidity=math.random(80,100),
			Precipitation=0.5,
			Wind={
				Speed=math.random(25,30),
				Angle=15
			},
		})
		
		local vec = Vector(200/255,200/255,200/255)
		local col = vec:ToColor()

		local tbl = {
			
			TopColor=vec,
			BottomColor=vec,
			DuskScale=0,
			DuskIntensity=0,
			SunSize=0,
			DrawStars=true,
			StarTexture="skybox/clouds",
			StarScale=2,	
			StarSpeed=0.04,
				
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=col,FogStart=0,FogEnd={Outside=1000,Inside=2000},FogDensity={Outside=0.8,Inside=0.6} }
		gWeather:CreateFog(fog)

		gWeather.SetMapLight("h")
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()
	
	local dir= gWeather:GetWindDirection()
	local ang = dir:Angle()

	local effect="gw_heavy_snow"
	
	for k,ply in ipairs(player.GetAll()) do
	--	print(ang)
	
		gWeather.Particles(ply,effect,ang,1,600)

		if math.random(1,10)==1 then
			if !gWeather.IsOutside(ply,true) or !gWeather.IsFacingWind(ply) then continue end
		
			net.Start("gw_screeneffects")
				net.WriteString("hud/snow") -- texture
				net.WriteFloat(math.random(128,164)) -- size
				net.WriteFloat(math.random(0.2,0.8)) -- lifetime (in seconds)
				net.WriteFloat(2) -- movement speed
				net.WriteColor(color_white,false) -- color
			net.Send(ply)
		end
	
	end
		
end

function ENT:Think()
	if (SERVER) then

		self:ScreenParticleEffects()
	
		local i = ( FrameTime() / 0.015 ) * .01
	
		self:NextThink(CurTime() + i)
		return true
	end
end

function ENT:OnRemove()

	hook.Remove( "PlayerFootstep", "gWeather-SnowSteps" )

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()

	end
	
	if (CLIENT) then
		gWeather.Terrain.ReloadAllOldTextures()
		
		gWeather.RemoveCloud("SnowClouds")
		
	end
	
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







