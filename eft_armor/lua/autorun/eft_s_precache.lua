if ( SERVER ) then 

	game.AddParticles("particles/hs_impact_fx.pcf")
	PrecacheParticleSystem("impact_helmet_headshot_csgo")
	
end

if ( CLIENT ) then 

	game.AddParticles("particles/hs_impact_fx.pcf")
	PrecacheParticleSystem("impact_helmet_headshot_csgo")
	
end