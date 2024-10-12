AddCSLuaFile()

-- gDisasters compatibility

if file.Exists("autorun/gdisasters_load.lua","LUA") then -- check if mounted
			
	local function AddgWeatherPrecipitation(self,int)
				
		local resolution = self.Display.resolution 
		local scale = 128/FetchConVarResolution() 

		for k, _ in pairs(self.Pixels) do 
			local x, y = (k%resolution[1]) * scale, math.floor(k/resolution[2]) * scale
								
			local i1 = (Noise.perlin3D( x * 0.05, y * 0.05, CurTime() * 0.05)  * int) 
					
			if i1 <= math.Clamp(int / 2,0,0.1) then i1 = 0 end
				
			self.Pixels[k].intensity = math.Clamp(BlendValues(self.Pixels[k].intensity,i1 , "Add") ,0,1)
		end
				
	end				
				
		hook.Add( "OnEntityCreated", "gw_wRadarFunctionality", function( ent )
			local class = "gd_equip_wradar"
			if ent:GetClass()!=class then return end

			timer.Simple(.1,function()
				function ent:ClearScreen()
					ent:SetScreenwideIntensity(0)
					ent:AddGlobalClouds() 
					
					if gWeatherInstalled then
						if gWeather:IsRaining() or gWeather:IsSnowing() then --table.Count(LocalPlayer().gWeather.Sounds)>1
							AddgWeatherPrecipitation(ent,gWeather:GetPrecipitation())
						end
					end
					
				end
			end)

		end )	
		
end