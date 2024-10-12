AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Night"
ENT.Author = "Jimmywells"

function ENT:Initialize()			
	BaseClass.Initialize(self)

	if (CLIENT) then
	
		local start = CurTime()
		
		local Moon = Material( "atmosphere/moon" )
		local Glow = Material( "effects/glow" )
		local vec = (util.GetSunInfo() and util.GetSunInfo().direction or Vector(0.414,0.280,0.866))
		local size = 48
		local col = Color(255,255,255,0)
		
		hook.Add("PostDraw2DSkyBox", "gWeather.Night.Moon", function()
				
			local t = math.min((CurTime()-start)/2,1)	
			col.a = math.min(255*t,255)
				
			render.OverrideDepthEnable( true, false ) 

			cam.Start3D( Vector( 0, 0, 0 ), EyeAngles() )
				render.SetMaterial( Glow )
				render.DrawQuadEasy( vec * 350, -vec, size, size, col, 0 )
					
				render.SetMaterial( Moon )
				render.DrawQuadEasy( vec * 500, -vec, size, size, col, 0 )
			cam.End3D()

			render.OverrideDepthEnable( false, false )

		end)
	
		hook.Add( "RenderScreenspaceEffects", "gWeather.NightColorModify", function()
			local tab = {
				[ "$pp_colour_addr" ] = 0.0,
				[ "$pp_colour_addg" ] = 0.0,
				[ "$pp_colour_addb" ] = 0.0,
				[ "$pp_colour_brightness" ] = -(gWeather:GetOutsideFactor()/5000),
				[ "$pp_colour_contrast" ] = 1-(gWeather:GetOutsideFactor()/400),
				[ "$pp_colour_colour" ] = 1,
				[ "$pp_colour_mulr" ] = 0,
				[ "$pp_colour_mulg" ] = 0,
				[ "$pp_colour_mulb" ] = 0
			}
				
			DrawColorModify( tab )
		end )
	
	end

	if (SERVER) then
	
		gWeather:SetAtmosphere({
			Temperature=math.random(15,20),
			Humidity=math.random(30,70),
			Precipitation=0
		})
		
		local tbl = {
			
			TopColor=vector_origin,
			BottomColor=Vector(0,0,0.001),
			DuskScale=0,
			DuskIntensity=0,
			SunSize=0,
			DrawStars=true,
			StarTexture="skybox/starfield",
			StarSpeed=0.01,
			StarFade=0.7,
			StarScale=0.45
			
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
	
		local fog = { FogColor=color_black,FogStart=0,FogEnd={Outside=10000,Inside=15000},FogDensity={Outside=0.98,Inside=0.8} }
		gWeather:CreateFog(fog)
	
		gWeather.SetMapLight("Darkest")
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:Think()
	if (CLIENT) then
	
	end

	if (SERVER) then
	
		local i = ( FrameTime() / 0.015 ) * .01
	
		self:NextThink(CurTime() + i)
		return true
	end
end

function ENT:OnRemove()

	if (CLIENT) then
		hook.Remove("RenderScreenspaceEffects", "gWeather.NightColorModify")
		hook.Remove("PostDraw2DSkyBox", "gWeather.Night.Moon")
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







