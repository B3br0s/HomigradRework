AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Sunny"
ENT.Author = "Jimmywells"

function ENT:Initialize()	
	BaseClass.Initialize(self)		

	if (CLIENT) then
	
		local tab = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 1.1,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}
		
		hook.Add("RenderScreenspaceEffects", "gWeather.SunnyEffect", function()
			DrawColorModify( tab ) 

			if ( !render.SupportsPixelShaders_2_0() ) then return end

			local sun = util.GetSunInfo()

			if ( !sun ) then return end
			if ( sun.obstruction == 0 ) then return end

			local sunpos = EyePos() + sun.direction * 4096
			local scrpos = sunpos:ToScreen()

			local dot = ( sun.direction:Dot( EyeVector() ) - 0.8 ) * 5
			if ( dot <= 0 ) then return end

			DrawSunbeams( 0.85, 0.1 * dot * sun.obstruction, 2, scrpos.x / ScrW(), scrpos.y / ScrH() )
			
		end )
	
	end

	if (SERVER) then
		
		gWeather:SetAtmosphere({
			Temperature=math.random(25,35),
			Humidity=math.random(20,60),
			Precipitation=0,
			Wind={
				Speed=math.random(0,1),
				Direction=vector_origin
			},
		})
		
		local tbl = {
			
			TopColor=Vector(0,128/255,255/255),
			BottomColor=Vector(102/255,178/255,255/255),
			DuskScale=1,
			DuskIntensity=1,
			DuskColor=Vector(0.81,0.76,0.45),

		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
	
		local fog = { FogColor=Color(120,120,130),FogStart=0,FogEnd={Outside=40000,Inside=45000},FogDensity={Outside=0.5,Inside=0.4} }
		gWeather:CreateFog(fog)
	
		gWeather.SetMapLight("Brightest")
		
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
	
		hook.Remove("RenderScreenspaceEffects", "gWeather.SunnyEffect")
	
	end

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







