table.insert(LevelList,"deathrun")
deathrun = {}
deathrun.Name = "Death Run"

deathrun.red = {"Смерть",Color(255,55,55),
    weapons = {"weapon_hands","weaponn_crowbar"},
    models = tdm.models
}

deathrun.green = {"Раннеры",Color(55,255,55),
    weapons = {"weapon_hands"},
    models = tdm.models
}

deathrun.teamEncoder = {
    [1] = "red",
    [2] = "green"
}

function deathrun.StartRound(data)
	team.SetColor(1,deathrun.red[2])
	team.SetColor(2,deathrun.green[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return deathrun.StartRoundSV()
end

deathrun.SupportCenter = true
