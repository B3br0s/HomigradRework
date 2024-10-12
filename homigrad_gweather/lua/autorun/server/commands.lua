AddCSLuaFile()

game.AddDecal( "snow", "decals/snow" )

--[[
concommand.Add("setposme", function(ply, cmd, args)
	ply:SetPos(ply:GetEyeTrace().HitPos)
end)

concommand.Add("eyetrace", function(ply, cmd, args)
	local vecx = math.ceil(ply:GetEyeTrace().HitPos.x)
	local vecy = math.ceil(ply:GetEyeTrace().HitPos.y)
	local vecz = math.ceil(ply:GetEyeTrace().HitPos.z)
	ply:ChatPrint( "Vector("..vecx..","..vecy..","..vecz.."),")
end)

concommand.Add("ent_getinfo", function(ply)

	local ent = ply:GetEyeTrace().Entity
	PrintTable(ent:GetTable())
end)


concommand.Add("getent", function(ply)

	local ent = ply:GetEyeTrace().Entity
	local entpos = ply:GetEyeTrace().Entity:GetPos()
	print(ent, entpos)
end)

concommand.Add("getentmodel", function(ply)

	local ent = ply:GetEyeTrace().Entity
	local entm = ent:GetModel()
	print(entm)
end)

concommand.Add("getenthealth", function(ply)

	local ent = ply:GetEyeTrace().Entity
	local enth = ent:Health()
	print(enth)
end)

concommand.Add("getentangle", function(ply)

	local ent = ply:GetEyeTrace().Entity
	local enta = ent:GetAngles()
	print(enta)
end)

concommand.Add("getentcap", function(ply)

	local ent = ply:GetEyeTrace().Entity
	local entc = ent:GetChildren()
	local entp = ent:GetParent()
	print("children:")
	PrintTable(entc)
	print("parent:\n",entp)
end)

concommand.Add("getentlocation", function(ply, cmd, args)

	if args[1] ==nil then return end

	for k,v in pairs(ents.FindByClass(args[1])) do
	
		print(v,v:GetPos(),v:GetModel())
	
	end

end)

concommand.Add("getentproperties", function(ply, cmd, args)

	if args[1] ==nil then return end

	for k,v in pairs(ents.FindByClass(args[1])) do
	
		print(v,table.ToString(v:GetSaveTable()))
	
	end

end)

concommand.Add("gw_light", function(ply, cmd, args)
	gWeather.SetMapLight(tostring(args[1]))
end)

concommand.Add("gw_ang", function(ply, cmd, args)
	if gWeather.Atmosphere==nil then return end
	gWeather:SetWind(nil,nil,tonumber(args[1]))
end)

concommand.Add("gw_getver", function(ply, cmd, args)
	print("gWeather Version: "..tostring(gWeatherVersion))
end)

concommand.Add("getmap", function(ply, cmd, args)
	print(game.GetMap())
end)

concommand.Add("getmapmaterials", function(ply, cmd, args)
	PrintTable(Entity(0):GetMaterials())
end)

concommand.Add("gw_windtest", function(ply,cmd,args)
	local vec=Vector()
	vec.x=args[2] or 1
	vec.y=args[3] or 0
	vec.z=args[4] or 0

	--print(args[1])

	gWeather:SetWind(args[1],vec)
end)

concommand.Add("gw_windreset", function(ply,cmd,args)
	gWeather:WindReset()
end)

concommand.Add("gw_lightningtest", function(ply,cmd,args)
	if tostring(game.GetMap())!="gm_flatgrass" then return end
	timer.Create("gw_litest",2,50,function()
		local pos1=Vector(0,0,gWeather:GetCeilingVector(true))
		local pos2=Vector(0,0,-12799)
		local r=math.random(40,55)
		gWeather.CreateLightningBolt("negative",pos1,pos2,r)
	end)
end)


timer.Simple(1,function()
	local sky=ents.FindByClass("sky_camera")[1]
	if IsValid(sky) then
		ParticleEffect( "gw_mammatus", sky:GetPos()+Vector(0,0,400), Angle(0,0,0) )
	end	
end)
   
--]]










