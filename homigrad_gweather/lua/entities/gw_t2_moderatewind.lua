AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Gale-Force Wind"
ENT.Author = "Jimmywells"

function ENT:Initialize()			
BaseClass.Initialize(self)

	if (CLIENT) then

	end

	if (SERVER) then
	
		gWeather:SetWind(math.random(30,60),nil,20) -- 30-60 kmh

	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

--[[

function ENT:Think()
	if (CLIENT) then
	
	end

	if (SERVER) then

		local i = ( FrameTime() / 0.015 ) * .01
	
		self:NextThink(CurTime() + i)
		return true
	end
end

--]]

function ENT:OnRemove()

	if (CLIENT) then
	
	end

	if (SERVER) then	
	
		gWeather:WindReset()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







