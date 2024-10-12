
if (CLIENT) then

local function PlayerTemperatureEffects()
	if GetConVar("gw_temp_effect"):GetInt()==0 then return end

	local temp = LocalPlayer():GetNWFloat("gWeatherLocalTemperature", 37)

	local hypo = { -- cold
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] =  math.min( 0.4, (37-temp)/20 ),
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = 1,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}
	
	local hyper = { -- warm
		[ "$pp_colour_addr" ] = math.min( 0.12, (temp-37)/20 ),
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = 1,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}

	if math.Round(temp,2)>37 then
		DrawColorModify( hyper )
		if temp>40 then
			DrawMotionBlur( 0.4, (temp-40)/4, (temp-40)/80 )
		end
		-- maybe add more heat effects
	elseif math.Round(temp,2)<37 then
		DrawColorModify( hypo )
		util.ScreenShake( LocalPlayer():GetPos(), (37-temp)/8, 1, 0.1, 0 )
	end


end
hook.Add( "RenderScreenspaceEffects", "gWeather.ColdWarmFilters", PlayerTemperatureEffects)

end

if (SERVER) then

local function TemperatureThink()
	for k,ply in ipairs(player.GetAll()) do
				
	if !ply:Alive() then continue end	
	if ply.gWeather==nil then continue end
	
	ply:SetNWFloat("gWeatherLocalTemperature", ply.gWeather.Temperature)
	if GetConVar("gw_tempaffect"):GetInt()!=1 then ply.gWeather.Temperature = 37 return end

		local temp = gWeather:GetTemperature()

		local body_time, heat_cold_time = engine.TickInterval()*4*GetConVar("gw_tempaffect_rate"):GetFloat(), engine.TickInterval()*0.25*GetConVar("gw_tempaffect_rate"):GetFloat()
		local body_factor, heat_factor, weather_factor = 0,0,0
	
		if (temp < 2 or temp > 37) and gWeather.IsOutside(ply,true) then
			weather_factor = math.Clamp( -(21.5-temp)*heat_cold_time, -heat_cold_time, heat_cold_time )
		elseif (temp >= 2 and temp <= 37) or !gWeather.IsOutside(ply,true) then  
			body_factor = (37-ply.gWeather.Temperature)*body_time
		end	

		local fireent, firedist = gWeather.FindClosestEntity(ply:GetPos(),"entityflame")
		
		-- vFire support
		if vFireInstalled==true then 
			fireent, firedist = gWeather.FindClosestEntity(ply:GetPos(),"vfire")
 
			if IsValid(fireent) and fireent!=nil then 
				local ent = fireent:GetClosestBiggerFire()
				if IsValid(ent) and ent!=nil then
					local intensity_old,intensity_new = vFireBaseRadius(fireent:GetFireState()),vFireBaseRadius(ent:GetFireState())
					local dist_new = ent:GetPos():Distance(ply:GetPos())
					if (intensity_new/dist_new) > (intensity_old/firedist) then
						fireent,firedist =  ent,dist_new
					end
				end	
			end
			
		end
	
		if IsValid(fireent) and ply:Visible(fireent) then
			if vFireInstalled==true and firedist<=2000 then
				local intensity = vFireBaseRadius(fireent:GetFireState()) or 50
				heat_factor = math.Clamp( (intensity/(firedist))*heat_cold_time, 0, heat_cold_time )
			elseif firedist<=400 then
				heat_factor = math.Clamp( (1-(firedist/400))*heat_cold_time, 0, heat_cold_time )
			end
		end	
		
		ply.gWeather.Temperature=ply.gWeather.Temperature+body_factor+heat_factor+weather_factor
	
		if ply.gWeather.Temperature<=24 or ply.gWeather.Temperature>=44 then ply:Kill() end
	
	end
end	
timer.Create("gWeather.Temperature.Think",0.5, 0, TemperatureThink)


timer.Create("gWeather.TemperatureBreath",5,0,function()
	if GetConVar("gw_tempaffect"):GetInt()!=1 then return end
	
	if gWeather:GetTemperature()<=0 then
		for k,npc in ipairs(ents.FindByClass("npc_*")) do
			if !IsFriendEntityName(npc:GetClass()) then continue end
			
			if ( !IsValid(npc) or npc:Health()<=0 ) then continue end
			local mouth_attach = npc:LookupAttachment("mouth")
			if mouth_attach == (nil or 0) then continue end
			
			if !gWeather.IsOutside(ply,true) then continue end
			
			timer.Simple(math.Rand(0,1), function()
			if !IsValid(npc) then return end
				ParticleEffectAttach( "gweather_breath", PATTACH_POINT_FOLLOW, npc, mouth_attach )
			end)
			
		end
	
		for k,ply in ipairs(player.GetAll()) do
			if ( !IsValid(ply) or !ply:Alive() ) then continue end
			local mouth_attach = ply:LookupAttachment("mouth")
			if mouth_attach == (nil or 0) then continue end
		
			if !gWeather.IsOutside(ply,true) then continue end
		
			timer.Simple(math.Rand(0,1), function()
			if !IsValid(ply) then return end
				ParticleEffectAttach( "gweather_breath", PATTACH_POINT_FOLLOW, ply, mouth_attach )
			end)

		end
		
	end	
	
end)


end


