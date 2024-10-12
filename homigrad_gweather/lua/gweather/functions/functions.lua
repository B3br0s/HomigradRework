local function LerpColor(t,from,to,alpha)
	if !(IsColor(from) and IsColor(to)) then return end
		
	from.r=Lerp(t,from.r,to.r)
	from.g=Lerp(t,from.g,to.g)
	from.b=Lerp(t,from.b,to.b)
	if alpha then from.a=Lerp(t,from.a,to.a) end
		
	return from
end

if (SERVER) then
	
	function gWeather.SetMapLight(light)
		local li=ents.FindByClass("light_environment")[1]

		if type(light)=="number" then
			light=string.char(light)
		end

		if tostring(light):lower()=="brightest" then
			light="~"
		elseif tostring(light):lower()=="darkest" then
			light="a"
		end

		light=string.char(math.Clamp( math.floor(tonumber(string.byte(light))), 98, 126 ))

		if !IsValid(li) then 
			engine.LightStyle( 0, light ) 
			net.Start("gw_lightmaps") 
			net.Broadcast() 
		return end
	
		li:Fire("SetPattern", "m")
		li:Fire("FadeToPattern", light)
	end
	
	function gWeather.ResetMapLight()
		local li=ents.FindByClass("light_environment")[1]

		if !IsValid(li) then 
			engine.LightStyle( 0, "m" ) 
			net.Start("gw_lightmaps") 
			net.Broadcast() 
		return end
	
		li:Fire("SetPattern", "m")
		li:Fire("FadeToPattern", "m")
	end
	
	local skyvec = Vector(0,0,50000)
	
	local function qtsky(pos,f)
		local qt=util.TraceHull( {start = pos, endpos = pos+Vector(0,0,100000), mask = MASK_WATER + MASK_SOLID, filter = f or {}, mins = Vector( -2, -2, -2 ), maxs = Vector( 2, 2, 2 ) } )
		return qt.HitSky
	end
	
	local function HitSky(pos,f)
		local tr2 = util.TraceLine( {start = pos, endpos = pos + skyvec, mask = MASK_WATER + MASK_SOLID, filter = f or {} } )	
		return tr2.HitSky,tr2.HitPos
	end
		
	local function SkyPos(pos,f)
		local startpos  = Vector( pos.x, pos.y, gWeather:GetCeilingVector(true) )
		local tr3 = util.TraceLine( {start = (pos or startpos), endpos = startpos, mask = MASK_WATER + MASK_SOLID, filter = f or {} } )	
		return tr3.HitPos
	end
			
	local function FixPos(pos,f)	
		local tra = util.TraceLine( {start  = pos, endpos = pos - skyvec, mask = MASK_WATER + MASK_SOLID, filter = f or {} } )
		return tra.HitPos,tra.HitNormal
	end

	local function FindOutside(ply,f)	
		local fwd=gWeather.Vector2D(ply:EyeAngles():Forward())
		local pos = ply:EyePos()--+Vector(0,0,10)
		local get_pos
		for i=1,20,1 do
			local tr_1 = util.TraceLine( {start  = pos + fwd, endpos = pos + fwd*(i*250), mask = MASK_SOLID_BRUSHONLY, filter = f or {ply} } )
			local tr_2 = gWeather.IsOutside(tr_1.HitPos,true)
			if tr_2 then get_pos=tr_1.HitPos+(ply:GetViewOffset() or Vector(0,0,50)) break end
		end
		return get_pos
	end
	
	local function ParticleOffset(e,amt)
		local ent = e:GetViewEntity()
		local view_epos=FindOutside(ent,{e,ent}) 
		if view_epos==nil then 
			if ent.LastgWeatherOffset then return ent.LastgWeatherOffset end
		return ent:EyePos()+Vector(0,0,200) end
		local fwd=Vector(ent:EyeAngles():Forward()[1],ent:GetForward()[2],0)

		local endpos
		
		for i=1,100 do
			local dir=i*(amt/25)
			local a_t3pos = view_epos+(fwd*dir)
			local a_dist=view_epos:DistToSqr(a_t3pos)

			if (a_dist>=(amt*amt) and a_dist<=(amt*amt)*1.35) then

				local fwd_left,fwd_right,back_left,back_right = HitSky(a_t3pos+(Vector(amt,-amt,0)),ent), HitSky(a_t3pos+(Vector(amt,amt,0)),ent), HitSky(a_t3pos+(Vector(-amt,-amt,0)),ent), HitSky(a_t3pos+(Vector(-amt,amt,0)),ent)

				if fwd_left and fwd_right and back_left and back_right then
					endpos=a_t3pos
					ent.LastgWeatherOffset=endpos
					break
				end

			end
			
		end
		
		if endpos==nil and ent.LastgWeatherOffset==nil then
			local newpos = view_epos+(fwd*amt)
			if ent.LastgWeatherOffset==nil then ent.LastgWeatherOffset=view_epos end
			if HitSky(newpos,ent) and (newpos):DistToSqr(ent.LastgWeatherOffset)>40000 then -- lets see if this works idk
				ent.LastgWeatherOffset=(newpos+Vector(0,0,50))
				return (newpos+Vector(0,0,50))
			end
		end

		return (endpos or ent.LastgWeatherOffset)
	end
	
	local function gw_attach(particle,vec,ang,ply)
		--debugoverlay.Box( vec, Vector(-4,-4,-4), Vector(4,4,4), 0.1 )
		net.Start("gw_particleattach")
			net.WriteString(particle)
			net.WriteVector(vec)
			net.WriteAngle(ang)
		net.Send(ply)
	end

	function gWeather.Particles(ply,effect,ang,pvel,amt) -- ply is player, effect is effect name, ang is angle offset, pvel is custom velocity multiplier
		if !ply:IsPlayer() or !IsValid(ply) then return end
	--	if ply:WaterLevel()>2 then return end

		if !amt then amt = 800 end
		if !pvel then pvel = 1 end
		if !ang then ang = Angle() end
	
		local viewentity = ply:GetViewEntity()
		local view_epos = viewentity:EyePos()
		local startpos  = Vector( view_epos.x, view_epos.y, gWeather:GetCeilingVector(true) )

		local vel= viewentity:GetVelocity()*pvel 
		
		if (ply:InVehicle() and viewentity==ply) then
			local vehicle = ply:GetVehicle()

			vel = (vehicle:GetVelocity()*pvel)

			if vehicle:GetThirdPersonMode() then
				local p=viewentity:EyePos()+((viewentity:EyeAngles()*1):Forward()*(-vehicle:GetCameraDistance()*300))
				view_epos=p
			else
				if math.abs(vehicle:GetSteering())>=0.4 then vel=vel/4 end
			end

		end
		
		local newplayerhitpos = FixPos(SkyPos(view_epos+vel))

		local max_z = 200 	--500
		local under_prop = util.TraceLine( {start = startpos, endpos = view_epos, mask = MASK_WATER + MASK_SHOT_HULL, filter = ply, ignoreworld = true } ).HitPos.z
		local distance = math.max(0,math.abs(under_prop-newplayerhitpos.z))	

		if viewentity:WaterLevel()>0 then
			gw_attach(effect,newplayerhitpos+Vector(0,0,distance),ang,ply)
		return end

		if gWeather.IsOutside(viewentity,true) then
			gw_attach(effect,(view_epos+vel),ang,ply)
		elseif (gWeather.IsOutside(viewentity,true,true) and distance<=max_z) then
			gw_attach(effect,newplayerhitpos+Vector(0,0,distance),ang,ply)
		else	
			local dtpos=ParticleOffset(ply,amt)	
			gw_attach(effect,dtpos,ang,ply) 
		end	
		
	end
	
	function gWeather.ImpactEffects(ply,effect,spread,size)
		
		if !spread then spread = 400 end
		if !size then size=1 end
		
		local viewentity=ply:GetViewEntity()
		local view_epos=viewentity:EyePos()
		local eyefwd = gWeather.Vector2D(viewentity:EyeAngles():Forward())
		
		local function PtonC()
			local x = math.cos( math.rad( math.random(0,360) ) ) * math.random(0,spread)
			local y = math.sin( math.rad( math.random(0,360) ) ) * math.random(0,spread)
			return Vector( x, y, 0 )
		end
		
		local function SGPos(pos,f)
			local tr = util.TraceLine( {start = Vector( pos.x, pos.y, pos.z+300 ) - (gWeather:GetWindDirection()*gWeather:GetWindAngle()*20), endpos = Vector( pos.x, pos.y, pos.z-5000 ) + (gWeather:GetWindDirection()*gWeather:GetWindAngle()*275), mask = MASK_WATER + MASK_SOLID, filter = {ply,viewentity} } )	
			return tr.HitPos,tr.HitNormal
		end
		
		local skyp,skyn = SGPos(view_epos+(eyefwd*spread*0.5)+PtonC(),viewentity)
		if skyp==nil or skyn==nil then return end
	
		if view_epos:DistToSqr(skyp)>(spread*spread*2) then return end
		if !gWeather.IsOutside(skyp,true) then return end

		net.Start("gw_luaparticleimapct")
			net.WriteString(effect)
			net.WriteFloat(size)
			net.WriteVector(skyp)
			net.WriteAngle(skyn:Angle())
		net.Send(ply)
	
	end
	
	local function soundfunc(sound,origin,level,pitch,ply)
		pitch = (pitch and math.random(pitch[1],pitch[2]) or 100)
		level = (level or 100)
				
		net.Start("gw_sounds")
			net.WriteString(tostring(sound))
			net.WriteVector(origin)
			net.WriteFloat(level)
			net.WriteFloat(pitch)
		if ply and ply:IsPlayer() then
			net.Send(ply)	
		else
			net.Broadcast()
		end
				
	end
	
	function gWeather.Sound(sound,origin,level,pitch)
		origin = (IsEntity(origin) and origin:GetPos() or origin)
		soundfunc(sound,origin,level,pitch)
	end
	
	function gWeather.SoundWave(sound,origin,level,pitch)
		origin = (IsEntity(origin) and origin:GetPos() or origin)
	
		for k,ply in ipairs(player.GetAll()) do
			local pos=ply:GetPos()
			local df = pos:Distance(origin) / gWeather.ToSU("meter",343) -- distance in su / speed of sound in su
			
			timer.Simple(df,function()
				if !IsValid(ply) then return end
				soundfunc(sound,origin,level,pitch,ply)
			end)
			
		end
		
	end	

	local lightningtbl={
		["negative"]="gw_negativelightning",
		["positive"]="gw_positivelightning"
	}

	function gWeather.CreateLightningBolt(type,StartPos,EndPos,Size)
		if StartPos==nil or EndPos==nil then return end
		if Size==nil then Size=math.random(40,55) end
		
		local time_till_impact = math.min((math.Round(StartPos:Distance(EndPos)/200) + 50),180) / 275

		local effectdata = EffectData()
		effectdata:SetStart( StartPos )
		effectdata:SetOrigin( EndPos )
		effectdata:SetRadius( Size )
		util.Effect( lightningtbl[type:lower()], effectdata, true, true )	
		
		return time_till_impact
	end

	function gWeather.CreateShockWave(epicenter, range, power, vel)
		for k, ent in pairs(ents.FindInSphere(epicenter,range)) do	
			if !IsValid(ent) then continue end
			if !ent:IsSolid() then continue end
			
			local distance = ent:GetPos():Distance(epicenter)
			local t = distance / gWeather.ToSU("meter",vel)
			
			timer.Simple(t, function()
				if !IsValid(ent) then return end
				if (ent:VisibleVec(epicenter) or ent:VisibleVec(epicenter+Vector(0,0,range/20))) then
				
					local phys = ent:GetPhysicsObject()
					if !phys:IsValid() then return end 
					
					local dist = (epicenter - ent:GetPos()):Length()
					local relation = math.Clamp( (range - dist) / range, 0, 1)
	
					if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then

					 local force = (ent:GetPos() - epicenter):GetNormalized() * relation * power
					 			 				
						if ent:VisibleVec(epicenter) then 
							ent:TakeDamage( (power*0.2)*relation, game.GetWorld(), game.GetWorld() )
						end
										 
						if ent:IsPlayer() then 
							local ply_force = ( ent:IsOnGround() and ( force + Vector(0,0,(power/4)*relation) ) or force )
							ent:SetVelocity( ply_force ) 
							
							local vec = (epicenter-ent:GetPos()):GetNormalized()*2
							ent:ViewPunch( vec:Angle() )
							
							net.Start("gw_screenshake")
								net.WriteFloat((power*0.1)*relation)
								net.WriteFloat((power*0.1)*relation)
								net.WriteFloat(1)
							net.Send(ent)
						else
							ent:SetVelocity( force )	
						end
						
					else
					
						local mass = phys:GetMass()
						local i_relation = 1/(relation^2)
						local force = (ent:GetPos() - epicenter):GetNormalized() * relation * power * ((50000-mass)/40000) 

						if math.random(1,i_relation*((mass*2)/power)) == 1 then 		-- (mass*2) for 'destruction', might change it to (mass*4) for better performance
							constraint.RemoveAll( ent )
							phys:EnableMotion(true)
							phys:Wake()
						end
						
						if phys:IsMoveable() then
							phys:AddVelocity(force)
						end
					
					end
					
				end
				
			end)
			
		end
		
	end
	
end

if (CLIENT) then 

	function gWeather.LocalSound(s,pitch)
		LocalPlayer():EmitSound(s,100,(math.random(pitch[1],pitch[2]) or 100) )
	end
	
	function gWeather.Sound(s,origin,level,pitch)
		origin = (IsEntity(origin) and origin:GetPos() or origin)
		pitch = (pitch and math.random(pitch[1],pitch[2]) or 100)
		level = (level or 100)
		
		sound.Play( s,origin,level,pitch,1 )		
	end
	
	function gWeather.SoundWave(s,origin,level,pitch)
		origin = (IsEntity(origin) and origin:GetPos() or origin)
		pitch = (pitch and math.random(pitch[1],pitch[2]) or 100)
		level = (level or 100)
	
		local pos=LocalPlayer():GetPos()
		local df = pos:Distance(origin) / gWeather.ToSU("meter",343) -- distance in su / speed of sound in su
			
		timer.Simple(df,function()
			if !IsValid(LocalPlayer()) then return end
			sound.Play( s,origin,level,pitch,1 )		
		end)
		
	end	

	local cloudtbl=cloudtbl or {}
	local skycloud_mats={Material( "atmosphere/skybox/cloudtest4" ),Material( "atmosphere/skybox/cloudtest3" )}

	function gWeather.CreateCloud(id,mat,col,size,spread,amt,skybox)
		if id==nil then ErrorNoHalt( "No Cloud ID!\n" ) return end

		mat = mat or Material("atmosphere/skybox/clouds_2") -- what the cloud looks like
		amt = math.max((amt or 5),5) -- make this greater than 3 or else there isn't enough to make the loop look good
		size = size or 12^2 -- i think 16 is good, i'd say like 12 is minimum
		spread = spread or size*0.8 -- customize based on material, for the default material it looks good at size*0.8
		col = col or Color(255,255,255,255) -- yeah do whatever
		if skybox==nil then skybox = true end
		
		cloudtbl[id]={Material=mat,Amount=amt,Size=size,Distance=spread,Color=col}

		cloudtbl[id].SetColor = function(color)
			if IsColor(color) then cloudtbl[id].Color=color end 
		end
		
		cloudtbl[id].SetSize = function(size,spread)
			if size!=nil then cloudtbl[id].Size=tonumber(size) end
			if spread!=nil then cloudtbl[id].Distance=(tonumber(spread) or size*0.8) end
		end
		
		cloudtbl[id].Remove = function()
			hook.Remove("Think","gWeather.CloudThink_"..id)
			hook.Remove("PostDraw2DSkyBox","gWeather.CloudRender_"..id)
			cloudtbl[id]=nil
		end

		local l,rot,vec={},{},{}
		local rate,falpha = 0.5,col.a
		local ti,randang=CurTime(),Angle(0,math.random(0,359),0)
		
		col.a = 0
		
			local function UpdateClouds(cloud_id)
				if cloudtbl[cloud_id]==nil then return end
				--if mat:GetName()!=cloudtbl[cloud_id].Material:GetName() then mat=cloudtbl[cloud_id].Material end
				--if amt!=cloudtbl[cloud_id].Amount then amt=Lerp(0.01,amt,cloudtbl[cloud_id].Amount) end
				if size!=cloudtbl[cloud_id].Size then size=Lerp(0.01,size,cloudtbl[cloud_id].Size) end
				if spread!=cloudtbl[cloud_id].Distance then spread=Lerp(0.01,spread,cloudtbl[cloud_id].Distance) end
				if col!=cloudtbl[cloud_id].Color then col=LerpColor(0.01,col,cloudtbl[cloud_id].Color,true) end
			end

			hook.Add( "Think", "gWeather.CloudThink_"..id, function()
				UpdateClouds(id)
		
		
				if (col.a<=falpha) and ((CurTime()-ti) <= 4) then  
					col.a = Lerp(rate*3/(1/FrameTime()),col.a,falpha)
				end
				
				local changerate=math.Clamp(gWeather:GetWindSpeed()*(10^-5),0,0.2)*(size/144) -- speed it moves at

				for i=1, amt do
				
					if vec[i]==nil then vec[i] = ( (-amt*(spread/2)) + (i*spread) ) - (size/2) end
					if l[i]==nil then l[i]=0 end
					if rot[i]==nil then rot[i]=math.random(0,359) end
				
					l[i]=l[i]+changerate
					if (l[i]+vec[i]) >= ( ( (amt+2)*(spread/2)) ) - (size/2) then l[i]= 0 vec[i] = ( ( -(amt-2)*(spread/2) ) - (size/2) ) rot[i]=math.random(0,359)  end	
					
				end	
			end )

			hook.Add( "PostDraw2DSkyBox", "gWeather.CloudRender_"..id, function()
				if #l==0 or #vec==0 then return end

				local wd=gWeather:GetWindDirection()
				local winddir=Vector(wd.x,wd.y,0):IsEqualTol(Vector(0,0,0),0.1) and Vector(1,0,0) or Vector(wd.x,wd.y,0)
				local skycloud_dist = 80

				render.OverrideDepthEnable( true, false )
				
				if skybox then
					cam.Start3D( Vector( 0, 0, 0 ), EyeAngles()+randang+Angle(0,(CurTime()-ti)*.2,0) )

						render.SetMaterial( skycloud_mats[1] )
						render.DrawQuadEasy( Vector(1,1,0.32) * skycloud_dist, Vector(-1,-1,0), 118, 64, col, 180 )
						render.DrawQuadEasy( Vector(-1,-1,0.32) * skycloud_dist, Vector(1,1,0), 118, 64, col, 180 )
						render.DrawQuadEasy( Vector(-1,1,0.32) * skycloud_dist, Vector(1,-1,0), 118, 64, col, 180 )
						render.DrawQuadEasy( Vector(1,-1,0.32) * skycloud_dist, Vector(-1,1,0), 118, 64, col, 180 )

						render.SetMaterial( skycloud_mats[2] )
						render.DrawQuadEasy( Vector(1,0,0.28) * skycloud_dist, Vector(-1,0,0), 118, 64, col, 180 )
						render.DrawQuadEasy( Vector(0,1,0.28) * skycloud_dist, Vector(0,-1,0), 118, 64, col, 180 )
						render.DrawQuadEasy( Vector(-1,0,0.28) * skycloud_dist, Vector(1,0,0), 118, 64, col, 180 )
						render.DrawQuadEasy( Vector(0,-1,0.28) * skycloud_dist, Vector(0,1,0), 118, 64, col, 180 )
						
					cam.End3D()
				end
				
				cam.Start3D( Vector(0,0,0), EyeAngles() )
					render.SetMaterial( mat )
				
					for i = 1, amt do
					
						for g=1,5 do
						
							local scalef=(5/2)
							local scaleg=(5/6)

							local off = ( (vec[i]+l[i]) * winddir ) + ( Vector(-(size*scalef)+(g*(size*scaleg)),-(size*scalef)+(g*(size*scaleg)),0)*Vector(winddir.y,winddir.x,0) )
							render.DrawQuadEasy( off + Vector(0,0,10), Vector(0,0,-1), size, size, col, rot[i]*(g/2)) 
							
						end
						
					end
					
				cam.End3D()	
			
				render.OverrideDepthEnable( false, false )
			end )
		
		return cloudtbl[id]
		
	end
		
	function gWeather.SetCloudColor(id,color)
		if id==nil then return nil end
		if IsColor(color) then cloudtbl[id].Color=color end 
	end

	function gWeather.SetCloudSize(id,size,spread)
		if id==nil then return nil end
		
		if size!=nil then cloudtbl[id].Size=tonumber(size) end
		if spread!=nil then cloudtbl[id].Distance=(tonumber(spread) or size*0.8) end
	end	
		
	function gWeather.RemoveAllClouds()
		for k,v in pairs(cloudtbl) do
			if cloudtbl[k]==nil then continue end
			hook.Remove("Think","gWeather.CloudThink_"..k)
			hook.Remove("PostDraw2DSkyBox","gWeather.CloudRender_"..k)
			cloudtbl[k]=nil
		end
	end

		
	function gWeather.RemoveCloud(id)
		if id==nil then return nil end

		hook.Remove("Think","gWeather.CloudThink_"..id)
		hook.Remove("PostDraw2DSkyBox","gWeather.CloudRender_"..id)
		cloudtbl[id]=nil
	end

end

function gWeather.PChance(percent)
	return (math.random()<=(percent/100))
end

function gWeather.Vector2D(vec)
	return Vector(vec.x,vec.y,0)
end

function gWeather.LoopSfx(ent,sound)
	local s = Sound(sound)
	
	local CS = CreateSound(ent,s)
	CS:SetSoundLevel( 0 )
	CS:PlayEx(0,100)
	
	return CS
end

function gWeather.IsFacingWind(ent,p_err)
	if gWeather.Atmosphere==nil then return false end
	if !(ent:IsPlayer() or ent:IsNPC()) then return true end
	if p_err == nil then p_err = 0.7 end
	
	local ent_pos=ent:EyeAngles():Forward() 
	local pos = gWeather:GetWindDirection()
	
	if ent_pos:Dot(Vector(0,0,-1)) > 0.7 then return false end
	
	return -( ent_pos:Dot(pos) ) >= -p_err
end

local outsidevec = Vector(0,0,65536)
function gWeather.IsOutside(vec,inwind,world) -- place, should calculate with wind?, only collide with world?
	if gWeather.Atmosphere==nil then return false end
	if !vec then return end
	
	local pos = (IsEntity(vec) and vec:GetPos()+vec:OBBCenter()) or (isvector(vec) and vec) -- support for vectors and entities
	local fil = IsEntity(vec) and vec or {}
	
	local bounds = gWeather:GetWindLocalBounds()
	if istable(bounds) and pos:WithinAABox( bounds[1], bounds[2] )==false then return false end

	local trace = { start = pos, endpos = pos+outsidevec, collisiongroup = world and COLLISION_GROUP_IN_VEHICLE or COLLISION_GROUP_NONE, filter = fil }

	if IsEntity(vec) and vec:IsPlayer() and vec:InVehicle() then
		trace = { 
		start = vec:GetVehicle():GetPos() + vec:GetVehicle():OBBCenter(), 
		endpos = vec:GetVehicle():GetPos() + vec:GetVehicle():OBBCenter()+outsidevec+(-gWeather:GetWindDirection()*20000), 
		collisiongroup = world and COLLISION_GROUP_IN_VEHICLE or COLLISION_GROUP_NONE, 
		filter = {vec,vec:GetVehicle()} 
		}
	end

	local tr = util.TraceLine( trace )
	if tr.HitSky then return true end
	
	if inwind then
	
		local num= gWeather.Atmosphere.Wind.Angle
		
		local trace = util.TraceLine( { 
		start = pos, 
		endpos = pos+Vector(0,0,65536*math.cos(math.rad(num)))+gWeather.Vector2D((65536*6*(1-math.cos(math.rad(num))))*-gWeather:GetWindDirection()), 
		collisiongroup = world and COLLISION_GROUP_IN_VEHICLE or COLLISION_GROUP_NONE, 
		filter = fil 
		} ) 
		
		if trace.HitSky then return true end

	end	
	
	return false
end

function gWeather.FindClosestEntity(pos,class)
	if ents.FindByClass(class)[1]==nil then return end
	local closest = ents.FindByClass(class)[1]
			
	for _,ent in ipairs(ents.FindByClass(class)) do

		if ent:GetPos():DistToSqr(pos) < closest:GetPos():DistToSqr(pos) then
			closest = ent
		end
					
	end
	
	return closest, closest:GetPos():Distance(pos)
end


function gWeather.ColorVector(vc) 
	if type(vc)=="Vector" then 
		return vc:ToColor()
	elseif IsColor(vc) then
		return vc:ToVector() 
	end
	return vc
end

function gWeather.kmhTo(to,val)
	to=tostring(to):lower()

	if to=="mph" then
		return val/1.609
	elseif to=="knot" then	
		return val/1.852
	elseif to=="m/s" then
		return val/3.6
	end
	
	return val
end
	
function gWeather.mphTo(to,val)
	to=tostring(to):lower()

	if to=="kmh" then
		return val*1.609
	elseif to=="knot" then	
		return val/1.151
	elseif to=="m/s" then
		return val*2.237
	end
	
	return val
end
	
function gWeather.fTo(to,val)
	to=tostring(to):lower()

	if to=="c" then
		return (val-32)*(5/9)
	elseif to=="k" then	
		return ((val-32)*(5/9))+273
	end
	
	return val
end
	
function gWeather.cTo(to,val)
	to=tostring(to):lower()

	if to=="f" then
		return (val*(9/5))+32
	elseif to=="k" then
		return val+273
	end
	
	return val
end

-- https://developer.valvesoftware.com/wiki/Dimensions source units

--[[
Architectural Scale (maps, architecture and certain models)

Map Grid    Imperial    Metric
     1  =   0.75"   ≈      2cm
     2  =   1.5"    ≈      4cm
     4  =   3"      ≈    7.5cm
     8  =   6"      ≈     15cm
    16  =   1'      ≈     30cm
    32  =   2'      ≈     60cm
    52.49 = 3.28'   =       1m
    64  =   4'      ≈    1.25m
   128  =   8'      ≈     2.5m
   160  =  10'      ≈       3m
   256  =  16'      ≈       5m
   512  =  32'      ≈      10m
--]]

function gWeather.ToSU(to,val)
	to=tostring(to):lower()

	if to=="meter" then
		return val*52.49
	elseif to=="foot" then
		return val*16
	end
	
	return val
end

function gWeather.SUTo(to,val)
	to=tostring(to):lower()

	if to=="meter" then
		return val/52.49
	elseif to=="foot" then
		return val/16
	end
	
	return val
end
