AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Vacuum of Space"
ENT.Author = "Jimmywells"

function ENT:Initialize()	
	BaseClass.Initialize(self)		

	if (CLIENT) then
	
	end

	if (SERVER) then
	
		self.StartTime = CurTime()
		self.Gravity = (GetConVar("sv_gravity"):GetFloat() or 600)
		RunConsoleCommand( "sv_gravity", 0 )
		
		for k,ent in pairs(player.GetAll()) do 
			ent.gWeather.NoOxygen=CurTime()+math.random(8,10)
		end
		
		hook.Add( "PlayerSpawn", "gWeather.Player.NoOxygen", function(ply)
			if ply.gWeather.NoOxygen!=nil then ply.gWeather.NoOxygen=CurTime()+math.random(8,10) end
		end)

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

		local fog = { FogColor=color_black,FogStart=0,FogEnd={Outside=10000,Inside=15000},FogDensity={Outside=0.8,Inside=0.8} }
		gWeather:CreateFog(fog)
	
		gWeather.SetMapLight("Darkest")

	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:GetTimeElapsed(ply)
	if ply.gWeather.NoOxygen==nil then return 0 end
	return (CurTime() - ply.gWeather.NoOxygen)
end

function ENT:AffectEntities()
	
	for k,ent in pairs(ents.GetAll()) do 
		if ent:IsPlayer() then 
			if ent.gWeather.NoOxygen==nil then continue end
			if !ent:Alive() then continue end
			local t = self:GetTimeElapsed(ent)

			if ent:InVehicle() and IsValid(ent:GetVehicle()) then ent = ent:GetVehicle() end
			if gWeather.PChance(t) then gWeather.DamageEntity(ent,"space",1) end 
		continue end
		
		if !ent:IsSolid() or ent:GetClass()==self:GetClass() then continue end
	
		local ent_obj = ent:GetPhysicsObject()

		if IsValid(ent_obj) then
			if !ent_obj:IsGravityEnabled() then continue end
			if !ent_obj:IsMotionEnabled() then continue end
			ent_obj:EnableGravity( false )
		
		end
		
	end

end

function ENT:Think()

	if (CLIENT) then
	
		RunConsoleCommand("stopsound")
	
	end

	if (SERVER) then
	
		local i = ( FrameTime() / 0.015 ) * .01
		
		self:AffectEntities()
	
		self:NextThink(CurTime() + i)
		return true
	end
end

function ENT:ResetGravity()

	for k,ent in pairs(ents.GetAll()) do 
		if ent:IsPlayer() then continue end
		if !ent:IsSolid() or ent:GetClass()==self:GetClass() then continue end
	
		local ent_obj = ent:GetPhysicsObject()

		if IsValid(ent_obj) then
			ent_obj:EnableGravity( true )
		end
		
	end

end

function ENT:OnRemove()

	if (CLIENT) then
	
	end

	if (SERVER) then

		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()
		
		self:ResetGravity()
	
		RunConsoleCommand( "sv_gravity", self.Gravity )
	
		hook.Remove( "PlayerSpawn", "gWeather.Player.NoOxygen")
	
	end
	
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







