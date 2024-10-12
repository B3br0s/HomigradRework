AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

function ENT:Initialize()			

	if !string.EndsWith(self:GetClass(),"hail") then 
		gWeather.CurrentWeather = self 

		self:CallOnRemove("gWeather_Weather",function() -- i forgor
			gWeather.CurrentWeather = nil 
		end)
	end

	if (SERVER) then

		local lifetime=GetConVar("gw_weather_lifetime"):GetFloat()

		if lifetime>1 then
			timer.Simple(lifetime,function()
				if IsValid(self) then self:Remove() end
			end)
		end

		self:SetModel("models/props_lab/huladoll.mdl")
		self:PhysicsInit( SOLID_NONE  )
		self:SetSolid( SOLID_NONE  )
		self:SetMoveType( MOVETYPE_NONE  )
		self:SetUseType( ONOFF_USE )
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		
		self:SetNoDraw(true)
		
	end
	
end

local function IsNotSpawnable(ClassName)
	local weather=#ents.FindByClass("gw_t*")
	local hail=#ents.FindByClass("gw_t*_hail")
	
	if (weather-hail)>0 and string.match(tostring(ClassName),"hail")==nil then return true end
	return false
end

function ENT:SpawnFunction( ply, tr, ClassName )

	if IsNotSpawnable(ClassName) then return end
	
	if ( !tr.Hit ) then return end
	
	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos+tr.HitNormal )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:OnRemove()
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end
