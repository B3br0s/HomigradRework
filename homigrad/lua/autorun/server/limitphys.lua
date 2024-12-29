hook.Add("InitPostEntity","RemoveShittyHooks",function()
	local phys_settings = physenv.GetPerformanceSettings()

	phys_settings.LookAheadTimeObjectsVsObject = 0.3 -- 0.5
	phys_settings.LookAheadTimeObjectsVsWorld = 1 -- 1
	phys_settings.MaxAngularVelocity = 2600 -- 7272.7275390625
	phys_settings.MaxCollisionChecksPerTimestep = 50 -- 50000
	phys_settings.MaxCollisionsPerObjectPerTimestep = 1 -- 10
	phys_settings.MaxFrictionMass = 2500 -- 2500
	phys_settings.MaxVelocity = 1568 -- 4000
	phys_settings.MinFrictionMass = 50 -- 10

	physenv.SetPerformanceSettings(phys_settings)
end)