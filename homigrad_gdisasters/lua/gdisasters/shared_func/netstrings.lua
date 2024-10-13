if (SERVER) then
	util.AddNetworkString( "gd_isOutdoor" )
	util.AddNetworkString( "gd_sendsound"	)
	util.AddNetworkString( "gd_shakescreen"	)
	util.AddNetworkString( "gd_soundwave" )
	util.AddNetworkString( "gd_screen_particles" )	
	util.AddNetworkString( "gd_seteyeangles_cl")
	util.AddNetworkString( "gd_clParticles" )	

end
	
if (CLIENT) then


net.Receive("gd_clParticles", function()
	
	local effect = net.ReadString()
	local angle  = net.ReadAngle()
	ParticleEffect( effect, LocalPlayer():GetPos(), angle, nil )
	
 
end)

net.Receive("gd_seteyeangles_cl", function()
	
	local offset = net.ReadAngle()
	local angle  = LocalPlayer():EyeAngles()
	x, y, z = offset.x, offset.y, offset.z 
	x2, y2, z2 = angle.x, angle.y, angle.z 
	
	
	LocalPlayer():SetEyeAngles( Angle(x+x2, y+y2, z+z2) )
	
	
 
end)
net.Receive("gd_screen_particles", function()

	if not(LocalPlayer().ScreenParticles) then LocalPlayer().ScreenParticles = {} end
	local texture  = net.ReadString()
	local size     = net.ReadFloat()
	local life     = net.ReadFloat() + CurTime()
	local number   = net.ReadFloat()
	local vel      = net.ReadVector()
	

	if HitChance(0.01 ) then return end 
	
	for i=0, number do
	
	
		local pos      = Vector( math.random(0,ScrW()), math.random(0,ScrH()), 0) 
		local center   = pos - Vector(size/2,size/2,0)
		
		LocalPlayer().ScreenParticles[#LocalPlayer().ScreenParticles+1] = {["Texture"]=surface.GetTextureID(texture),
																		   ["Material"]=Material(texture),
																	       ["Size"]   = size, 
																	       ["Life"]   = life,
																	       ["Pos"]    = center,
																		   ["Velocity"] = vel
																	        }
		hook.Add( "RenderScreenspaceEffects", "Draw Particles", gfx_screenParticles)
	end	
	
end)

net.Receive("gd_soundwave", function()

	local s 	 = net.ReadString()
	local stype 	 = net.ReadString() -- "mono or stereo or 3d"
	local pos  		 = net.ReadVector() or LocalPlayer():GetPos() -- epicenter
	local pitchrange = net.ReadTable() or {100,100}
	
	if stype == "mono" then
		
		surface.PlaySound( s )
	
	elseif stype == "stereo" then
	
		LocalPlayer():EmitSound( s, 100, math.random(pitchrange[1], pitchrange[2]), 1 )

	elseif stype == "3d" then
		sound.Play( s,  pos, 150, math.random(pitchrange[1], pitchrange[2]), 1 )
	else
		print("WHAT THE FUCK ARE WE DOING HERE???? GO AND REPORT THIS TO THE CREATOR!")
	end
	
	
 
end)




net.Receive("gd_shakescreen", function()
	
	local duration = net.ReadFloat()
	local a        = net.ReadFloat() or 25
	local f        = net.ReadFloat() or 25
	
	util.ScreenShake( LocalPlayer():GetPos(), a, f, duration, 10000 )

	
 
end)


net.Receive("gd_sendsound", function()
	
	local sound  = net.ReadString()
	local pitch  = net.ReadFloat() or 100
	local volume = net.ReadFloat() or 1
	LocalPlayer():EmitSound(sound, 100, pitch, volume)

	
 
end)





net.Receive("gd_seteyeangles_cl", function()
	
	local offset = net.ReadAngle()
	local angle  = LocalPlayer():EyeAngles()
	x, y, z = offset.x, offset.y, offset.z 
	x2, y2, z2 = angle.x, angle.y, angle.z 
	
	
	LocalPlayer():SetEyeAngles( Angle(x+x2, y+y2, z+z2) )
	
	
 
end)




end




-- shared





























