if SERVER then AddCSLuaFile() end

rtcam.maxCamsPerPlayer = 10
rtcam.maxMonitorsPerPlayer = 10
rtcam.cameraHealth = 0 -- set this to be nonzero to enable cameras having health

------------------------------------------------------
--- RT SCREEN MODELS  -  THIS CAN BE EDITED INGAME ---
------------------------------------------------------

--- HL2 Screens
list.Set("RTMonitorModels", "models/props_wasteland/controlroom_monitor001b.mdl", {
	offset = Vector(7, 0, -6.5),
	ang = Angle(0, 90, 90),
	scale = 0.034,
	ratio = 1.24,
})

list.Set("RTMonitorModels", "models/props_lab/monitor01a.mdl", {
	offset = Vector(12.3, 0, 4),
	ang = Angle(0, 90, 85),
	scale = 0.033,
	ratio = 1.2,
})

list.Set("RTMonitorModels", "models/props_lab/monitor02.mdl", {
	offset = Vector(11.15, 0, 14.3),
	ang = Angle(0, 90, 83),
	scale = 0.033,
	ratio = 1.2,
})

list.Set("RTMonitorModels", "models/props/cs_assault/billboard.mdl", {
	offset = Vector(1, 0, 0),
	ang = Angle(0, 90, 90),
	scale = 0.25,
	ratio = 1.73,
})

list.Set("RTMonitorModels", "models/props_combine/combine_monitorbay.mdl", {
	offset = Vector(-4, 3.5, 5),
	ang = Angle(180, 90, 90),
	scale = 0.132 * 0.9,
	ratio = 1.15,
})

list.Set("RTMonitorModels", "models/props_combine/combine_intmonitor003.mdl", {
	offset = Vector(23, 0, 26),
	ang = Angle(0, 90, 90),
	scale = 0.09,
	ratio = 0.75,
})




-- EP2
list.Set("RTMonitorModels", "models/props_combine/combine_interface001a.mdl", {
	offset = Vector(1, -2, 45),
	ang = Angle(0, 90, 42),
	scale = 0.017,
	ratio = 1.8,
})






-- CS:S
list.Set("RTMonitorModels", "models/props/cs_office/computer_monitor.mdl", {
	offset = Vector(3.3, 0, 16.7),
	ang = Angle(0, 90, 90),
	scale = 0.031,
	ratio = 1.4,
})

list.Set("RTMonitorModels", "models/props/cs_office/tv_plasma.mdl", {
	offset = Vector(6.5, 0, 18.5),
	ang = Angle(0, 90, 90),
	scale = 0.132 * 0.5,
	ratio = 1.7,
})

list.Set("RTMonitorModels", "models/props_c17/tv_monitor01.mdl", {
	offset = Vector(5, -2, 0.5),
	ang = Angle(0, 90, 90),
	scale = 0.023,
	ratio = 1.2,
})




-- Wiremod 
list.Set("RTMonitorModels", "models/blacknecro/tv_plasma_4_3.mdl", {
	offset = Vector(0.05, 0, 0),
	ang = Angle(0, 90, 90),
	scale = 0.132 * 0.63,
	ratio = 1.31,
})

list.Set("RTMonitorModels", "models//expression 2/cpu_interface.mdl", {
	offset = Vector(0, 0, 0.8),
	ang = Angle(0, 90, 0),
	scale = 0.0075,
	ratio = 1,
})

list.Set("RTMonitorModels", "models/kobilica/wiremonitorsmall.mdl", {
	offset = Vector(0.2, 0, 5),
	ang = Angle(0, 90, 90),
	scale = 0.017,
	ratio = 1,
})

list.Set("RTMonitorModels", "models/kobilica/wiremonitorrtbig.mdl", {
	offset = Vector(0.2, 0, 5),
	ang = Angle(0, 90, 90),
	scale = 0.038,
	ratio = 1,
})

list.Set("RTMonitorModels", "models/kobilica/wiremonitorbig.mdl", {
	offset = Vector(0.2, 0, 13),
	ang = Angle(0, 90, 90),
	scale = 0.045,
	ratio = 1,
})




list.Set("RTMonitorModels", "models//cheeze/pcb/pcb4.mdl", {
	offset = Vector(0, 0, 0.35),
	ang = Angle(0, 90, 0),
	scale = 0.0625,
	ratio = 1,
})

list.Set("RTMonitorModels", "models//cheeze/pcb/pcb7.mdl", {
	offset = Vector(0, 0, 0.35),
	ang = Angle(0, 90, 0),
	scale = 0.125,
	ratio = 1,
})

list.Set("RTMonitorModels", "models/cheeze/pcb2/pcb8.mdl", {
	offset = Vector(0, 0, 0.35),
	ang = Angle(0, 90, 0),
	scale = 0.251,
	ratio = 0.99,
})






---Sprops
list.Set("RTMonitorModels", "models/sprops/trans/lights/light_c2.mdl", {
	offset = Vector(0.95, 0, 0),
	ang = Angle(0, 90, 90),
	scale = 0.0054,
	ratio = 2,
})

list.Set("RTMonitorModels", "models/sprops/trans/lights/light_c4.mdl", {
	offset = Vector(1.9, 0, 0),
	ang = Angle(0, 90, 90),
	scale = 0.0109,
	ratio = 2,
})