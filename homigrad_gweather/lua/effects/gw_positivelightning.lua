local round,rand,random,max,min=math.Round,math.Rand,math.random,math.max,math.min
local ct = (1/engine.TickInterval()) / (66.666)

local function randvec(val,z,spec)
	local vec
			
	repeat
		vec = Vector(rand(-val,val),rand(-val,val),z or 0) 
		until( vec:Length()>=(val/(spec or 2)) )
			
	return vec
end

local function GenerateLightningBolt(startpos,endpos,dist,fdt,jag,radius,segments)
	if dist<16 then return end

	local spos,epos = startpos,endpos
	local segments = segments or {}
	local segments_child = segments_child or {}	

	if IsEntity(startpos) then spos = startpos:GetPos() end
	if IsEntity(endpos) then epos = endpos:GetPos() end

	local c_spos,c_epos = spos,epos
	local mid1 =  (c_spos+((c_spos+c_epos)*0.5))*0.5
	local mid2 =  (c_spos+c_epos)*0.5										
	local mid3 =  (mid2+c_epos)*0.5						
	
	local var=(dist/12)

	local mid_o_pick=randvec(var*1.25,0,1.5)*jag*dist
	local mid_pick=randvec(var*0.5)*jag*dist

	mid1=mid1+mid_o_pick*random(0.8,1)
	mid2=mid2+mid_pick
	mid3=mid3-mid_o_pick*random(0.8,1)

	local cur,nex = c_spos,mid05
	local npos,lamount
	local nexti=var
	
	local num_branches=0
	local div=dist/4 -- 4 places to goto
	local x,y=random(1,1000),random(1,1000)
	
	local seed={}
	for i=1,6 do
		seed[i]=random(1000,2000)
	end

	for i = 1, dist do
		
		timer.Simple( (i/fdt),function()
			
			if  i <= dist*0.25 then  -- going to 'first' point (1)
				cur = c_spos 
				nex = mid1
				lamount=i/div
			elseif  i > dist*0.25 and i <= dist*0.5 then -- going to 'second' point (2)
				cur = mid1 
				nex = mid2
				lamount=(i-(dist*0.25))/div
			elseif  i > dist*0.5 and i <= dist*0.75 then -- going to 'third' midpoint (3)
				cur = mid2 
				nex = mid3
				lamount=(i-(dist*0.5))/div
			elseif i > dist*0.75 and i <= dist then -- going to end (4)
				cur = mid3 
				nex = c_epos
				lamount=(i-(dist*0.75))/div
			end

			npos=LerpVector(lamount,cur,nex)
			
			x=x+random(95,110)
			y=y+random(95,110)
			
			local p1 = Vector(gWeather.Perlin.Noise( x*15*jag,y*15*jag,nil,seed[1]/2 ),gWeather.Perlin.Noise( x*15*jag,y*15*jag,nil,seed[2]/2 ),0)*(dist) --small
			local p2 = Vector(gWeather.Perlin.Noise( x,y,nil,seed[3] ),gWeather.Perlin.Noise( x,y,nil,seed[4] ),0)*(dist*5*jag)
			local p3 = Vector(gWeather.Perlin.Noise( x/2,y/2,nil,seed[5] ),gWeather.Perlin.Noise( x/2,y/2,nil,seed[6] ),0)*(dist*10*jag) --large

			 -- to help make it fade back to actual position
			if (dist>i) then
			
				if i<math.floor(var) then
					local f=(i/(math.floor(var)-1))
					if i!=1 then p1 = p1*f end
					p2 = p2*f
					p3 = p3*f
				end 
				if (i+math.floor(var))>dist then
					local f=((dist-i)/(math.floor(var)-1)) 
					if i!=dist then p1 = p1*f end
					p2 = p2*f
					p3 = p3*f
				end 
				
				npos=npos+p1+p2+p3
			end	
		
			local nextplace = math.ceil((dist/12))
			local chance = math.max(math.floor(100/(dist/60)),1)

			if i>=nexti and random(1,chance)==1 and num_branches<=6 and dist>15 then -- branches
				local pos=spos
				
				local off_ang = (nex-cur):Angle()
				
				if math.random(0,1)==1 then off_ang = Angle(off_ang.x,-off_ang.y,off_ang.z) end
				
				local x_ang = -(0.7*off_ang:Forward().z)^2 + 1
				off_ang:Mul(x_ang)
				
				local off_pos = off_ang:Forward()*(dist*math.random(20,40))
				pos=pos+off_pos
				
				if pos.z>=(c_epos.z+500) then

					local d = round(spos:Distance(pos)/65)
					
					GenerateLightningBolt(spos,pos,d,(fdt*1.25),jag*0.75,(radius*0.5),segments_child)
					num_branches=num_branches+1
					nexti=i+nextplace

				end
				
			end
		
			table.insert(segments,{spos,npos,radius})	-- [1] (first pos), [2] (second pos), [3] (glow rendering shit)
			spos = npos		
				
		end)
			
	end
	
	return segments, segments_child
	
end

function EFFECT:Init( data )
	local startpos = data:GetStart() -- start
	local endpos = data:GetOrigin() -- end

	if startpos==nil or endpos==nil then return end
	
	if GetConVar("gw_particle_level"):GetString()=="low" then startpos.z=math.min(startpos.z*0.66,endpos.z+8000) end
	
	local coltbl={Color(232,226,244),Color(242,226,244),Color(245,229,237),Color(241,239,248),Color(240,225,210),Color(230,225,215),Color(250,240,240),Color(251,229,228),Color(252,226,254),Color(232,228,244),Color(255,255,255)}
	local color = table.Random(coltbl)
	local dist = min((round(startpos:Distance(endpos)/200) + 50),180)  -- so it works on every map
	local fade = 275
	local jag = 1

	local gettime = (dist/fade)
	local extime = 0.6 	-- 3
	local r_rad = (dist*(1/180))
	local radius = data:GetRadius()*r_rad -- radius of particle
	
	self:SetRenderBoundsWS( startpos, endpos )
	
	if util.QuickTrace( endpos, Vector(0,0,-10),LocalPlayer()).HitWorld then
		timer.Simple( gettime*0.88,function()
			ParticleEffect("gw_lightning_impact_positive",endpos,Angle(0,0,0))
		end)
	end
	
	timer.Simple( gettime,function()
		--ParticleEffect( "gw_lightningflash", LocalPlayer():EyePos()+LocalPlayer():GetForward()*1000, Angle(0,0,0) )
		-- gWeather.SoundWave(s,origin,level,pitch)
	
		gWeather.SoundWave("weather/thunder/thunder"..tostring(random(1,11))..".mp3",endpos,0,{97,103}) -- thunder
		util.ScreenShake( endpos, 2, 10, 0.6, 0 )
		
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			dlight.pos = endpos+Vector(0,0,1)
			dlight.r = color.r
			dlight.g = color.g
			dlight.b = color.b
			dlight.brightness = 5
			dlight.Decay = data:GetRadius()*250
			dlight.Size = data:GetRadius()*120
			dlight.DieTime = CurTime() + extime
		end
		
	end)

	self.Distance = dist

	local bolt, branch = GenerateLightningBolt(startpos,endpos,dist,fade,jag,radius)
	
	self.Lightning={}
	self.Lightning[1] = {Segs = bolt, Time = CurTime() + (gettime+extime), Col = color}
	self.Lightning[2] = {Segs = branch, Time = CurTime() + (gettime+extime), Col = color}

end


function EFFECT:Think()
	if (self.Lightning)==nil then return false end
	if (CurTime() >= self.Lightning[1].Time) then self.Lightning=nil return false end
	return true
end

local ltex,lgtex = Material( "effects/lightning/lightning_bolt_texture" ),Material("effects/lightning/lightning_glow")
function EFFECT:Render()
		local li=self.Lightning[1]
			
		local t,col,rad = li.Time, li.Col, math.max(1-(math.sin(CurTime()*50)*.25),.5) 	
		local li_color_a = Color(col.r,col.g,col.b,1.1)
			
		local w = math.Clamp((t-CurTime())*5,0,1)
		
		render.SetMaterial( ltex )
		
		--- BOLT ---
		
		render.StartBeam((self.Distance*2))
			for k,e in ipairs(li.Segs) do
				local pos1,pos2,radius=e[1],e[2],e[3]*rad*w
				render.AddBeam( pos1, radius, 0, col )
				render.AddBeam( pos2, radius, 0, col )
			end
		render.EndBeam()	
		
			-- BOLT GLOW --
			
			render.SetMaterial( lgtex )
			for k,e in ipairs(li.Segs) do
				if (k%4) != 0 then continue end
				local radius=e[3]*rad*w

				render.DrawSprite( e[1], math.max(radius*65,100), math.max(radius*65,100), li_color_a )
			end

		--- BRANCH ---

		render.SetMaterial( ltex )
		li=self.Lightning[2]

		for k,e in ipairs(li.Segs) do
			local pos1,pos2,radius=e[1],e[2],e[3]*rad*w
			render.DrawBeam( pos1, pos2, radius, 1, 2, col )
		end	

end
