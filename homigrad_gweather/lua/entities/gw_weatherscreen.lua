AddCSLuaFile()

DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Weather Screen"
ENT.Author = "Jimmywells"

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

function ENT:Initialize()	

	if (SERVER) then

		self:SetNWBool( "IsOn", true )

		self:SetModel( "models/props_phx/rt_screen.mdl" )
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType( SIMPLE_USE )
		
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end   
		
	end
	
end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	
	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos+tr.HitNormal )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:OnRemove()

end

function ENT:Use()
	self:SetNWBool( "IsOn", !self:GetNWBool( "IsOn" )  )
	self:EmitSound( "buttons/button4.wav" )
end

local mat = {["windy"]=Material("icons/windy"),["cloudy"]=Material("icons/cloudy"),["sunny"]=Material("icons/sunny"),["rainy"]=Material("icons/rainy"),["snowy"]=Material("icons/snowy")}
local htype = {["gw_t1"] = "None",["gw_t2"] = "Marginal",["gw_t3"] = "Moderate",["gw_t4"] = "Enhanced",["gw_t5"] = "High",["gw_t6"] = "Very High",["gw_t7"] = "Apocalyptic"}

function ENT:Draw()

	self:DrawModel()
	
	if self:GetPos():Distance(LocalPlayer():GetPos()) >= 1000 then return end
	if self:GetNWBool( "IsOn" )==false then return end

	local position = self:LocalToWorld( Vector( 6.5, -28, 36 ) )
	local angle = self:LocalToWorldAngles( Angle(0,90,90) )

	cam.Start3D2D(position, angle, 0.1)
	
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(0, 0, 560, 340)
		
		local ent = gWeather:GetCurrentWeather()
		
		if IsValid(ent) then
			
			local temp,localtemp,tempunit=gWeather:GetTemperature(),LocalPlayer():GetNWFloat("gWeatherLocalTemperature")," °C"
			local wind,localwind,windunit=gWeather:GetWindSpeed(),LocalPlayer():GetNWFloat("gWeatherLocalWind")," km/h"
				
			local str = "sunny"
			if gWeather:IsRaining() then 
				if gWeather:GetPrecipitation()>0.1 then str = "rainy" else str = "cloudy" end
			elseif gWeather:IsSnowing() then 
				str = "snowy" 
			elseif wind>20 then
				str = "windy"
			end
					
			surface.SetMaterial( mat[str] )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( 25, 25, 200, 200 )
			
			draw.SimpleText(ent.PrintName, "gWeatherFont", 250, 50, color_white )

			if GetConVar("gw_hud_temp"):GetString()!="celsius" then temp=gWeather.cTo("f",temp) localtemp=gWeather.cTo("f",localtemp) tempunit=" °F" end
			if GetConVar("gw_hud_wind"):GetString()!="km/h" then wind=gWeather.kmhTo("mph",wind) localwind=gWeather.kmhTo("mph",localwind) windunit=" mph" end
			
			draw.SimpleText( "Wind Speed: "..util.TypeToString(math.Round(wind,2)).. windunit, "Trebuchet24", 275, 130, color_white )
			draw.SimpleText( "Wind Direction: "..util.TypeToString( gWeather:GetWindDirection()), "Trebuchet24", 275, 170, color_white )

			draw.SimpleText( "Temperature: "..util.TypeToString(math.Round(temp,2)).. tempunit, "Trebuchet24", 275, 210, color_white )
			draw.SimpleText( "Humidity: "..util.TypeToString( math.Round(gWeather:GetHumidity(),2) ).."%", "Trebuchet24", 275, 250, color_white )
			
			draw.SimpleText( "Hazard: "..(htype[string.Left(ent:GetClass(),5)] or "N/A"), "Trebuchet24", 25, 280, color_white )
			
			else
			
			draw.SimpleText( "Scanning for Weather...", "Trebuchet24", 275, 150, color_white, 1, 3)
			draw.SimpleText( "(None Spawned)", "Trebuchet24", 275, 175, color_white, 1, 3)
		
		end
		
	cam.End3D2D()
	
end

