AddCSLuaFile()
ENT.Type = "point"

function ENT:Initialize()	

	gWeather.Sky=self

	if (SERVER) then
		self:SetPos(Vector(0,0,0))
		RunConsoleCommand( "sv_skyname", "painted")
		
		self.SunSkySize=nil
		self.GetSunNormalVec=nil
	end
	
	if ( CLIENT ) then
		g_SkyPaint = self
	end
end

function ENT:SetupDataTables()

	local SetupDataTables = scripted_ents.GetMember( "env_skypaint", "SetupDataTables" )
	SetupDataTables( self )
	
end

function ENT:Think()

	if (SERVER) then
		if self.EnvSun == nil then
			self.EnvSun = false
			local list = ents.FindByClass( "env_sun" )
			if ( #list > 0 ) then
				self.EnvSun = list[ 1 ]
			end
		end
		if IsValid( self.EnvSun ) then

			local size = self:GetSunSize()
			if size then
				if size<1 then self.EnvSun:Fire("TurnOff", 0.1, 0) else self.EnvSun:Fire("TurnOn", 0.1, 0) end
			--	print(size)
				self.EnvSun:SetKeyValue( "size", tonumber(size) )
			end	
		
			if #ents.FindByClass("edit_sun")>0 then self:SetSunNormal(self.EnvSun:GetInternalVariable("sun_dir")) return end -- hack to work with edit_sun

			local vec = self:GetSunNormal()
			if ( isvector( vec ) ) then
				self.EnvSun:SetKeyValue( "sun_dir", tostring(vec) )
			end

		end
		self:NextThink( CurTime() )
	end

	if (CLIENT) then
		if g_SkyPaint!=self then
			g_SkyPaint = self
		end
		self:SetNextClientThink( CurTime() )
	end

	return true
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:OnRemove()

	if (SERVER) then
		if IsValid( self.EnvSun ) then
		
			local size = self:GetSunSize()
			if size then
				if size==0 then self.EnvSun:Fire("TurnOff", 0.1, 0) else self.EnvSun:Fire("TurnOn", 0.1, 0) end
				self.EnvSun:SetKeyValue( "size", tonumber(size) )
			end	
	
			local vec = self:GetSunNormal()
			if ( isvector( vec ) ) then
				self.EnvSun:SetKeyValue( "sun_dir", tostring(vec) )
			end

		end
		
	end
	
	if CLIENT then
		local findby=ents.FindByClass("edit_sky")
		local ent=findby[#findby or 1]

		if ent and IsValid(ent) then g_SkyPaint = ent end
	end
	
	gWeather.Sky=nil 
	
end

function ENT:CanEditVariables( ply )
	return ply:IsAdmin()
end
