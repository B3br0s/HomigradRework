if (SERVER) then	

	local breaksounds={
		["glass"]={"physics/glass/glass_sheet_break1.wav","physics/glass/glass_sheet_break2.wav","physics/glass/glass_sheet_break3.wav"},
		["wood"]={"physics/wood/wood_plank_break1.wav","physics/wood/wood_plank_break2.wav","physics/wood/wood_plank_break3.wav","physics/wood/wood_plank_break4.wav"},
		["metal"]={"physics/metal/metal_box_break1.wav","physics/metal/metal_box_break2.wav"},
		["tile"]={"physics/plaster/ceilingtile_break1.wav","physics/plaster/ceilingtile_break2.wav"},
		["plastic"]={"physics/plastic/plastic_box_break1.wav","physics/plastic/plastic_box_break2.wav"},
		["concrete"]={"physics/concrete/concrete_break2.wav","physics/concrete/concrete_break3.wav"},
		["unknown"]={"physics/plastic/plastic_box_break1.wav"},
	}	
	
	local ignoredclasses = {
		["func_physbox"] = true,
		["func_breakable"] = true,
		["path_track"] = true,
		["path_corner"] = true,
		["prop_effect"] = true,
		["gw_editwind"] = true,
	}
	
	timer.Create("gWeather.WindPhysics.TooManyProps",2, 2, function()
		if #ents.FindByClass("prop_*")>200 then 
			if GetConVar("gw_windphysics_prop"):GetInt()~=0 then 
				PrintMessage( 3, "gWeather Warning: The detected number of props is >200, disabling wind physics for better performance." ) 
				GetConVar("gw_windphysics_prop"):SetInt(0) 
			end
		end
		timer.Remove("gWeather.WindPhysics.TooManyProps")
	end )

	local function WindPhysicsThink()
		if gWeather.Atmosphere==nil then return end

		if gWeather.NextThink==nil then gWeather.NextThink=CurTime() end	
		
		local windspeed = gWeather.Atmosphere.Wind.Speed-- km\h
		local winddirection = gWeather.Atmosphere.Wind.Direction
		
		local su = 39.37*engine.TickInterval()

		local f = math.max( 5000 - (10*windspeed), 1)
		local w_mod = GetConVar("gw_nextwind"):GetFloat()/0.01

		local function Break(ent)
			if GetConVar("gw_windphysics_unweld"):GetInt()==0 then return end
			if !IsValid(ent) then return end
			if ent:Health()>0 then ent:TakeDamage(1,game.GetWorld(),game.GetWorld()) end
			local phys=ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:EnableMotion(true) 
				phys:Wake()
				if constraint.HasConstraints(ent) then 
					constraint.RemoveAll(ent) 	
					local s = breaksounds[phys:GetMaterial()] or breaksounds["unknown"]	
					sound.Play( table.Random(s), ent:GetPos(), 70, math.random(95,105) ) 	
				end
			end
		end

		local function WindForcePlayer(ent,phys)
			local mass=phys:GetMass()
			local sa = (phys:GetSurfaceArea() || 5000)/(39.37^2)

			local wind_ent = (0.48 * sa * ((windspeed/3.6)^2)) * su * (winddirection) / mass
			local max_friction = (-physenv.GetGravity().z/39.37)*winddirection

			if max_friction:LengthSqr()>wind_ent:LengthSqr() then return end
				
			local ff = (wind_ent-max_friction)
							
			ent:SetVelocity(ff)			
			return ff
		end
		
		local function WindForce(ent,phys)
			local mass=phys:GetMass()
			local sa = (phys:GetSurfaceArea() || 5000)/(39.37^2)

			if gWeather.NextThink>CurTime() then return end
				
			local wind_ent = (0.48 * sa * ((windspeed/3.6)^2)) * su * (winddirection)
			local max_friction = math.min(sa,1)*mass*(-physenv.GetGravity().z/39.37)*winddirection
		
			if max_friction:LengthSqr()>wind_ent:LengthSqr() then return end
			if (wind_ent:Length()-max_friction:Length())>1000 and math.random(f/w_mod)==1 then Break(ent) end 
				
			local ff = (wind_ent-max_friction)*w_mod

			if IsValid(phys) then phys:ApplyForceCenter(ff)	end	
			return ff
		end

		local function ShouldNotMove(ent)
			if (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) then return true end
			if ent:GetMoveType()==0 then return true end
			if ignoredclasses[ent:GetClass()] then return true end
			if !ent:IsSolid() then return true end
			local phys = ent:GetPhysicsObject()
			if !IsValid(phys) then return true end
			if string.match( phys:GetName(),"gib" )!=nil then return true end
			if !gWeather.IsOutside(ent,true) then return true end
		
				local b1,b2 = ent:GetCollisionBounds()
				if !util.IsInWorld( ent:GetPos()+(Vector(b2.x*4,b2.y*4,0)*gWeather:GetWindDirection())+Vector(0,0,100) ) then return true end -- no prop spazzing against bounds

				if phys:IsPenetrating() and (ent:GetCollisionGroup() == 0) and (gWeather:GetWindSpeed() > 200) then
					ent:SetCollisionGroup(COLLISION_GROUP_WORLD)	
					if !timer.Exists( tostring(ent:GetCreationID()) ) then
						timer.Create( tostring(ent:GetCreationID()), 1, 1, function() 
							if !IsValid(ent) then return end
							if ent:GetCollisionGroup() == 0 then return end
							ent:SetCollisionGroup(COLLISION_GROUP_NONE)	
							timer.Remove( tostring(ent:GetCreationID()) )
						end )
					end
				end	
			
			return false
		end	

--[[ Player Wind Physics/Effects --]]

		for k,ent in ipairs(player.GetAll()) do
			if !IsValid(ent) then continue end 
				
			if !gWeather.IsOutside(ent,true) then ent:SetNWFloat( "gWeatherLocalWind", 0 ) continue end
			ent:SetNWFloat( "gWeatherLocalWind",windspeed)
			
			if windspeed>60 then
			
				if ent:Health()>0 and IsValid(ent) then
					net.Start("gw_screenshake")
						net.WriteFloat(math.Clamp((ent:GetNWFloat("gWeatherLocalWind",0)-100)*0.01,0,1))
					net.Send(ent)
				end	
				
				local phys = ent:GetPhysicsObject()
					if IsValid(phys) and GetConVar("gw_windphysics_player"):GetInt()>0 then
						local force = WindForcePlayer(ent,phys)
					end
				
			end

		end
		
--[[ NPC Wind Physics --]]

		for k,ent in ipairs(ents.FindByClass("npc_*")) do
			if windspeed<=5 then return end
			if !IsValid(ent) then continue end 
			if !(ent:IsNPC()) then continue end
			
			if !gWeather.IsOutside(ent,true) then continue end
		
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) and GetConVar("gw_windphysics_player"):GetInt()>0 then
				local force = WindForcePlayer(ent,phys)
			--	if ent:IsOnGround() then ent:SetPos(ent:GetPos()+Vector(0,0,1)) end
			end	

		end

--[[ Prop Wind Physics --]]

		local function WindPush()
			for k,ent in ipairs(ents.GetAll()) do -- props_break_max_pieces (0 or 1), gmod_mcore_test 1 for antilag 
				if ent:GetVelocity():Length() > 2500 then continue end
				if ShouldNotMove(ent) then continue end 

				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					local force = WindForce(ent,phys)
				end
				
			end
		end
		
		if windspeed>5 and GetConVar("gw_windphysics_prop"):GetInt()>0 then 
			if gWeather.NextThink>CurTime() then return end
			WindPush() 
			gWeather.NextThink = CurTime()+GetConVar("gw_nextwind"):GetFloat()
		end
		
	end
	hook.Add( "Think", "gWeather.WindPhysics.Think", WindPhysicsThink )
	
end
