AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Aurora Borealis"
ENT.Author = "Jimmywells"

function ENT:Initialize()			
	BaseClass.Initialize(self)

	if (CLIENT) then
	
	end

	if (SERVER) then
		
		gWeather:SetAtmosphere({
			Temperature=math.random(5,10),
			Humidity=math.random(30,70),
			Precipitation=0
		})
		
		local tbl = {
			
			TopColor=Vector(0.02,0.06,0.06),
			BottomColor=Vector(0.05,0.11,0.03),
			FadeBias=0.43,
			DuskScale=0,
			DuskIntensity=0.44,
			DuskColor=Vector(0,0,0),
			SunSize=0,
			DrawStars=true,
			StarTexture="skybox/starfield",
			StarSpeed=0.01,
			StarFade=1.42,
			StarScale=1.5
			
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
	
		local fog = { FogColor=Color(0,0,0),FogStart=0,FogEnd={Outside=10000,Inside=15000},FogDensity={Outside=0.55,Inside=0.4} }
		gWeather:CreateFog(fog)
	
		gWeather.SetMapLight("d")
		
		timer.Simple(0.5,function()
			if !IsValid(self) then return end

			if IsValid(ents.FindByClass("sky_camera")[1]) then
				local cam = ents.FindByClass("sky_camera")[1]
				local height = math.min((util.QuickTrace(cam:GetPos(),Vector(0,0,10000)).HitPos.z)-(cam:GetPos().z),2500)	
				local radius = ((util.QuickTrace(cam:GetPos()+Vector(0,0,height-10),Vector(10000,0,0)).HitPos.x)-(cam:GetPos().x)) /8160
				local skyscale = (tonumber(cam:GetInternalVariable("scale")) or 1) * radius

				local num = math.random(2,3)
				local a_scale = 100*skyscale*num
			
				if height<500 or a_scale<1100 then (self.Spawner):ChatPrint( "This skybox is too small! Try spawning this on a map with a larger skybox." ) self:Remove() return end
				
				for i=0, num do
				
					local offset = Vector(math.random(-a_scale,a_scale)*.5,-a_scale+(a_scale*((i*2)/num)),height/1.5)
					
					if height>1500 then
						net.Start( "gw_particle_fix" ) -- particles don't render outside the world on the server so I have to network it for multiplayer :)))))
							net.WriteString("gw_aurora_"..table.Random({"blue","green"}))
							net.WriteVector(cam:GetPos()+offset)
							net.WriteAngle(Angle(0,math.random(-5,5),0))
							net.WriteUInt(tonumber(self:EntIndex()),8)
						net.Broadcast()
					else
						net.Start( "gw_particle_fix" )
							net.WriteString("gw_aurora_"..table.Random({"blue","green"}).."_small")
							net.WriteVector(cam:GetPos()+offset+Vector(0,0,50))
							net.WriteAngle(Angle(0,math.random(-5,5),0))
							net.WriteUInt(tonumber(self:EntIndex()),8)
						net.Broadcast()
					end
					
				end
			end
		
		end)
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if !IsValid(ents.FindByClass("sky_camera")[1]) then ply:ChatPrint( "There is no 3D skybox! Try spawning this on a map with a 3D skybox." ) return end
	
	self.Spawner = ply

	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

function ENT:Think()
	if (SERVER) then
		self:NextThink(CurTime() + 1)
		return true
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
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end

