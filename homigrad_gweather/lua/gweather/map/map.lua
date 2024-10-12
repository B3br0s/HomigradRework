gWeather.MapBounds = {
["gm_flatgrass"]={Vector(15360,15360,-12800),Vector(-15360,-15360,15359)},
["gm_construct"]={Vector(2168,6464,-960),Vector(-5640,-4576,9983)},
}

function gWeather:BoundsValid()
	local map=game.GetMap()
	
	if gWeather.MapBounds[map]==nil then return false end
	return true
end

function gWeather:GetWorldBounds()
	local map = game.GetMap()
	
	if gWeather:BoundsValid()==false then 
		if (SERVER) then
		
			local min = game.GetWorld():GetInternalVariable( "m_WorldMins" ) or Vector(0,0,0)
			local max = game.GetWorld():GetInternalVariable( "m_WorldMaxs" ) or Vector(0,0,0)
			
			local function SkyHitPos(num) 
		
			local old_highest_val = -10000
			local highest_val=old_highest_val
				
			for i=1,num do
					
					local startpos = Vector(math.random( (min[1]+1), (max[1]-1) ),math.random( (min[2]+1), (max[2]-1) ),0)

					local tr = util.TraceLine( {
						start = startpos,
						endpos = startpos+Vector(0,0,100000),
						mask = MASK_SOLID_BRUSHONLY
					} )	
						
					if util.IsInWorld(tr.HitPos) then
						highest_val = tr.HitPos.z
					end
					
					if highest_val >= old_highest_val then
						old_highest_val = highest_val
					end
					
				end

				return math.floor(old_highest_val)	
			end
				
			local skypos = SkyHitPos(32)

			local newsetbounds = {Vector(max[1],max[2],min[3]),Vector(min[1],min[2],skypos)} 
					
			gWeather.MapBounds[map]=newsetbounds
				
			net.Start( "gw_mapboundsync" )
				net.WriteVector( newsetbounds[1] )
				net.WriteVector( newsetbounds[2] )
			net.Broadcast()	
			
			return newsetbounds
		end	
	else	
		return {gWeather.MapBounds[map][1],gWeather.MapBounds[map][2]}	
	end 
	
end

function gWeather:GetCeilingVector(zvec)
	if gWeather:BoundsValid()==false then return end

	local b2 = gWeather:GetWorldBounds()[2]
	if zvec then return b2.z end
	return b2
end

function gWeather:GetFloorVector(zvec)
	if gWeather:BoundsValid()==false then return end

	local b1 = gWeather:GetWorldBounds()[1]
	if zvec then return b1.z end
	return b1
end

if (SERVER) then
	function gWeather:GetRandomBounds(tofloor)
		if gWeather:BoundsValid()==false then return end

		local vec=Vector()
		local wb1,wb2 = gWeather:GetWorldBounds()[1],gWeather:GetWorldBounds()[2]

		for i=1,5 do
			local randvec = Vector(math.random(wb1.x,wb2.x),math.random(wb1.y,wb2.y),wb2.z)
			local getz = tofloor and util.QuickTrace(randvec,Vector(0,0,-100000)).HitPos.z or wb2.z --math.random(wb1.z,wb2.z)
			randvec.z = getz
			if util.IsInWorld(randvec) then vec=randvec break end
		end
		
		return vec
	end

	hook.Add( "InitPostEntity", "gw_server_mapboundscheck", function()
		if gWeather:BoundsValid()==false then gWeather:GetWorldBounds() end
	end)
	
elseif (CLIENT) then

	hook.Add( "InitPostEntity", "gw_client_mapboundscheck", function() -- garry moment
		net.Start("gw_needbounds")
		net.SendToServer()
	end )

end
