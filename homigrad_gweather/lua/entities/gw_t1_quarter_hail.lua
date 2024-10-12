AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Quarter-Sized Hail"
ENT.Author = "Jimmywells"

function ENT:Initialize()
	BaseClass.Initialize(self)			

	if (CLIENT) then
		
		LocalPlayer().gWeather.Sounds=LocalPlayer().gWeather.Sounds or {}
		LocalPlayer().gWeather.Sounds["OutsideHail"] = gWeather.LoopSfx(LocalPlayer(),"weather/hail/hail_loop.wav")
		LocalPlayer().gWeather.Sounds["IndoorHail"] = gWeather.LoopSfx(LocalPlayer(),"weather/hail/interior_hail_loop.wav")
		
	end

	if (SERVER) then
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if #ents.FindByClass("gw_t*_hail")>0 then return end
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:ScreenParticleEffects()

	local effect="gw_quarter-sized_hail"
	local dir=gWeather:GetWindDirection()
	local ang= (dir==vector_origin and Angle(15-gWeather:GetWindSpeed(),dir:Angle()[2],0)) or dir:Angle()
	
	for k,ply in ipairs(player.GetAll()) do
	
		gWeather.Particles(ply,effect,Angle(15-math.min(gWeather:GetWindSpeed(),50),ang[2],0),0.8,600)

		if math.random(1,4)==1 then
			if !gWeather.IsOutside(ply,true) or !gWeather.IsFacingWind(ply) then continue end
		
			net.Start("gw_screeneffects")
				net.WriteString("hud/snow") -- texture
				net.WriteFloat(math.random(128,164)) -- size
				net.WriteFloat(0.1) -- lifetime (in seconds)
				net.WriteFloat(0) -- movement speed
				net.WriteColor(color_white,false) -- color
			net.Send(ply)
		end
	
	end

end


function ENT:Think()
	if (CLIENT) then
		
		local vol = (gWeather:GetOutsideFactor()/100)
		local fdt=0.15
	
		if LocalPlayer().gWeather.Sounds["OutsideHail"] then
			LocalPlayer().gWeather.Sounds["OutsideHail"]:ChangeVolume((vol^3),fdt)
		end
		
		if LocalPlayer().gWeather.Sounds["IndoorHail"] then
			LocalPlayer().gWeather.Sounds["IndoorHail"]:ChangeVolume( (1-vol) * (4*vol) * 0.15,fdt) 
		end

	end

	if (SERVER) then

		self:ScreenParticleEffects()
		
		local i = ( FrameTime() / 0.015 ) * .01
	
		self:NextThink(CurTime()+i)
		return true
	end
end

function ENT:OnRemove()

	if (CLIENT) then
	
		if LocalPlayer().gWeather then
	
			if LocalPlayer().gWeather.Sounds["OutsideHail"] then
				LocalPlayer().gWeather.Sounds["OutsideHail"]:Stop()
				LocalPlayer().gWeather.Sounds["OutsideHail"]=nil	
			end
			
			if LocalPlayer().gWeather.Sounds["IndoorHail"] then
				LocalPlayer().gWeather.Sounds["IndoorHail"]:Stop()
				LocalPlayer().gWeather.Sounds["IndoorHail"]=nil	
			end
		
		end
		
	end

	if (SERVER) then	
	
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







