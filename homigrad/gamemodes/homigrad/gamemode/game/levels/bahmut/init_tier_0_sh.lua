table.insert(LevelList,"bahmut")
bahmut = {}
bahmut.Name = "Конфликт Хомиграда"

bahmut.red = {"ВСРФ",Color(60,75,60),
	weapons = {"weapon_radio","weapon_hands","weapon_hg_rgd5","medkit","weapon_binokle"},
	main_weapon = {"weapon_ak74u","weapon_akm","weapon_m1garand"},
	secondary_weapon = {"weapon_makarov"},
	models = {"models/arty/squad/faction/vdv/squadleader/leader_2 - arc9_pm.mdl"}
}

bahmut.blue = {"ВСУ",Color(125,125,60),
	weapons = {"weapon_radio","weapon_hands","weapon_hg_f1","medkit","weapon_binokle"},
	main_weapon = {"weapon_m4a1","weapon_mk18","weapon_m1garand"},
	secondary_weapon = {"weapon_beretta","weapon_hk_usp"},
	models = {"models/ukrainearm/ukraine_sold.mdl"}
}

bahmut.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function bahmut.StartRound()
	game.CleanUpMap(false)
	bahmut.points = {}
    if !file.Read( "homigrad/maps/controlpoint/"..game.GetMap()..".txt", "DATA" ) and SERVER then
        print("Скажите админу чтоб тот создал !point control_point или хуярьтесь без Точек Захвата.") 
        PrintMessage(HUD_PRINTCENTER, "Скажите админу чтоб тот создал !point control_point или хуярьтесь без Точек Захвата.")
    end

	bahmut.LastWave = CurTime()

    bahmut.WinPoints = {}
    bahmut.WinPoints[1] = 0
    bahmut.WinPoints[2] = 0

	team.SetColor(1,bahmut.red[2])
	team.SetColor(2,bahmut.blue[2])

	for i, point in pairs(SpawnPointsList.controlpoint[3]) do
        SetGlobalInt(i .. "PointProgress", 0)
        SetGlobalInt(i .. "PointCapture", 0)
        bahmut.points[i] = {}
    end

    SetGlobalInt("Bahmut_respawntime", CurTime())

	if CLIENT then return end
		timer.Create("Bahmut_ThinkAboutPoints", 1, 0, function() --подумай о точках... засунул в таймер для оптимизации, ибо там каждый тик игроки в сфере подглядываются, ну и в целом для удобства
        	bahmut.PointsThink()
    	end)

	if CLIENT then

		bahmut.StartRoundCL()
		return
	end

	bahmut.StartRoundSV()
end
bahmut.RoundRandomDefalut = 1
bahmut.SupportCenter = true
