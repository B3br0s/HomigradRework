AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Permian Extinction"
ENT.Author = "Jimmywells"

function ENT:Initialize()	
	BaseClass.Initialize(self)		

	if (CLIENT) then
	--gWeather.Terrain.SetColor(Vector(0.6,0.6,0.6))
		gWeather.Terrain.SetBaseTexture("models/lavabomb/lavabomb_texture")
		
		gWeather.CreateCloud("AssClouds",Material("atmosphere/skybox/clouds_1"),Color(5,5,5,255))
		gWeather.CreateCloud("AssClouds2",Material("atmosphere/skybox/clouds_2"),Color(30,30,30,255))
		
		hook.Add( "RenderScreenspaceEffects", "gWeather.PEColorModify", function()
			local tab = {
				[ "$pp_colour_addr" ] = 0.0,
				[ "$pp_colour_addg" ] = 0.0,
				[ "$pp_colour_addb" ] = 0.0,
				[ "$pp_colour_brightness" ] = 0.06,
				[ "$pp_colour_contrast" ] = 0.61,
				[ "$pp_colour_colour" ] = 1.53,
				[ "$pp_colour_mulr" ] = 0,
				[ "$pp_colour_mulg" ] = 0,
				[ "$pp_colour_mulb" ] = 0
					}
				
			DrawColorModify( tab )
		end )
		
	end
	
	if (SERVER) then
	
		gWeather:SetAtmosphere({
			Temperature=math.random(180,210),
			Humidity=0,
			Precipitation=0,
			Wind={
				Speed=math.random(25,30),
				Angle=15
			},
		})
		
		local tbl = {
			
			TopColor=Vector(1.00,0.28,0.28),
			BottomColor=Vector(1.00,0.00,0.00),
			DuskScale=1,
			DuskIntensity=8,
			DuskColor=vector_origin,
			SunSize=0
				
		}
		gWeather:CreateSky()
		gWeather:SetSkyParameters(tbl)
		
		local fog = { FogColor=color_black,FogStart=0,FogEnd={Outside=10000,Inside=14000},FogDensity={Outside=0.99,Inside=0.9} }
		gWeather:CreateFog(fog)

		gWeather.SetMapLight("c")
		
		self.NextSpawnTime=CurTime()+5
		
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

local function SpawnFirenadoes(self)
	if file.Exists("autorun/gdisasters_load.lua","LUA") then -- check if mounted
		local nado = ents.Create( "gd_d2_mfirenado" )
		nado:SetPos(gWeather:GetRandomBounds(true))
		nado.Data.Life = {Min=25,Max=30}
		nado:Spawn()
		nado:Activate()	
		self:DeleteOnRemove(nado)
	end
end

function ENT:SpawnLavaBomb(pos)
	if pos==nil then pos = gWeather:GetRandomBounds() end

	local lavab = ents.Create( "gw_lavabomb" )
	lavab:SetPos(pos)
	lavab:Spawn()
	lavab:Activate()
	self:DeleteOnRemove(lavab)
	
	local phys = lavab:GetPhysicsObject()
	
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(1000)
		phys:EnableDrag( false )
		phys:EnableMotion(true)
		phys:SetVelocity( Vector(0,0,-12000)  )
		phys:AddAngleVelocity( VectorRand() * 100 )
	end
end

function ENT:LavaBombShower()
--	if self.NextSpawnTime>CurTime() then return end

	local chance = 15+math.min((3*player.GetCount()),35)

	if gWeather.PChance(chance) then
		local top = Vector(0,0,gWeather:GetCeilingVector(true)-100)

		local ply = player.GetAll()[math.random(1,player.GetCount())]
		local ply_bounds = gWeather.Vector2D(ply:GetPos()+ply:GetVelocity()+VectorRand()*math.random(50,2000))+top
		
		--ply:ChatPrint("bomb spawned for me! Distance:"..tostring((ply_bounds-top):Distance(ply:GetPos())))
		
		self:SpawnLavaBomb(ply_bounds)
	else
		self:SpawnLavaBomb()
	end

--	self.NextSpawnTime=CurTime()+math.random(0,2)
end


function ENT:Think()
	if (SERVER) then

		for k,ply in ipairs(player.GetAll()) do
			if !IsValid(ply) or ply:Health()<=0 then return end
			if ply:IsOnGround() and ply:GetGroundEntity()==game.GetWorld() and GetConVar("gw_weather_entitydamage"):GetInt()!=0 then ply:Ignite(0.2) end
		end
		
		self:LavaBombShower()
		
		if CurTime()>=self.NextSpawnTime then
			SpawnFirenadoes(self)
			self.NextSpawnTime=CurTime()+math.random(10,20)
		end
	
		self:NextThink(CurTime()+math.random(0,2))
		return true
	end
end

function ENT:OnRemove()

	if (SERVER) then	
	
		gWeather:AtmosphereReset()
		gWeather:RemoveSky()
		gWeather:RemoveFog()
		gWeather.ResetMapLight()

	end
	
	if (CLIENT) then
		gWeather.Terrain.ReloadAllOldTextures()
		
		hook.Remove("RenderScreenspaceEffects", "gWeather.PEColorModify")
		
		gWeather.RemoveCloud("AssClouds")
		gWeather.RemoveCloud("AssClouds2")
		
	end
	
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end







