AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Lightning Bolt"
ENT.Author = "Jimmywells"

function ENT:Initialize()		

	if (CLIENT) then
		local pos = self:GetPos().z
		if pos==nil then return end
		local h = (gWeather:GetCeilingVector(true)-pos) / 62000 + 0.2 -- quick approximation because I don't feel like networking the exact time

		timer.Simple(h,function()
			if IsValid(gWeather:GetSky()) then gWeather:SkyFlash() end
		end)
	end

	if (SERVER) then

		self:SetModel("models/props_junk/watermelon01.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE  )
		self:SetUseType( ONOFF_USE )
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		
		self:SetNoDraw(true)
		
		--gWeather.CreateLightningBolt(type,startpos(x,y,top),endpos(x,y,bottom),size)
		local selfpos=self:GetPos()
		local offset=Vector(math.random(-500,500),math.random(-500,500))
		
		local str = "negative"
		if gWeather.PChance(5) then str = "positive" end
		
		local StartPos = (Vector(selfpos.x+offset.x,selfpos.y+offset.y,gWeather:GetCeilingVector(true)) or gWeather:GetCeilingVector())
		local EndPos = util.TraceLine( { start = StartPos, endpos = selfpos, mask = MASK_SOLID + CONTENTS_WATER, filter = function( ent ) return !ent:IsPlayer() end  } ).HitPos
		local r=math.random(40,55)
		if str == "positive" then r = 60 end

		local li_time = gWeather.CreateLightningBolt(str,StartPos,EndPos,r) -- create lightning

		timer.Simple(li_time,function() -- effects on impact of lightning

			if gWeather.PChance(5) then
				ParticleEffect( "gw_lightning_sprite_0"..tostring(math.random(1,3)), StartPos, Angle(0,0,0) )
			end
		
			for k,v in ipairs(ents.FindInBox(EndPos+Vector(-(r*10),-(r*10)), EndPos+Vector((r*10),(r*10),(r*10)) )) do
				if !IsValid(v) then continue end
				if !v:IsSolid() then continue end
	
				if v:IsPlayer() or v:IsNPC() then
					local radius = (r*r)*100
					local dist = 1 - (v:GetPos():DistToSqr(selfpos)/radius)
					gWeather.DamageEntity(v,"lightning",40*dist)
					
					local effectdata = EffectData()
					effectdata:SetEntity( v )
					effectdata:SetMagnitude( 2 )
					util.Effect( "TeslaHitboxes", effectdata )
				end
								
			end
			
		end)
	
		if IsValid(self) then self:Remove() end

	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	if #ents.FindByClass(ClassName)>1 then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( ( tr.HitPos + tr.HitNormal ) + Vector(0,0,-5) )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end

