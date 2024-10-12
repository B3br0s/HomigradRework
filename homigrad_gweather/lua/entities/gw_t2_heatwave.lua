AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Heat Wave"
ENT.Author = "Jimmywells"

function ENT:Initialize()	
	BaseClass.Initialize(self)		

	if (CLIENT) then

		gWeather.CreateCloud("HeatCloud",Material("atmosphere/skybox/clouds_3"),Color(220,220,220,255))

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
		end )
	
	end

	if (SERVER) then
		
		gWeather:SetAtmosphere({
			Temperature=math.random(35,40),
			Humidity=math.random(60,70),
			Precipitation=0,
			Wind={
				Speed=math.random(0,5),
				Direction=Vector(0,0,0)	
			},
		})
		
		local tbl = {
			
			TopColor=Vector(0,128/255,1),
			BottomColor=Vector(102/255,178/255,1),
			DuskScale=1,
			DuskIntensity=1,
			DuskColor=Vector(0.81,0.76,0.45),

		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
	
		local fog = { FogColor=Color(180,180,185),FogStart=0,FogEnd={Outside=7000,Inside=10000},FogDensity={Outside=0.5,Inside=0.4} }
		gWeather:CreateFog(fog)
	
		gWeather.SetMapLight("x")
		
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
	
		gWeather.RemoveCloud("HeatCloud")
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







