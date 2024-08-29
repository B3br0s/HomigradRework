table.insert(LevelList,"stopitslender")
stopitslender = {}
stopitslender.Name = "Stop it, Slender!"

stopitslender.red = {"Слендер",Color(255,55,55),
    weapons = {"weapon_hands"},
    models = {"models/slendereightpages/SlenderMan SMTEP.mdl"}
}

stopitslender.green = {"Выжившие",Color(55,55,255),
    weapons = {"weapon_hands"},
    models = tdm.models
}

stopitslender.blue = {"Выжившие",Color(55,55,255),
    weapons = {"weapon_radio","weapon_hands","weapon_kabar","med_band_big","med_band_small","medkit","painkiller","weapon_hg_f1","weapon_handcuffs","weapon_taser","weapon_hg_flashbang"},
    main_weapon = {"weapon_mk18","weapon_m4a1","weapon_m3super","weapon_mp7","weapon_xm1014","weapon_fal","weapon_galilsar","weapon_m249","weapon_mp5","weapon_mp40"},
    secondary_weapon = {"weapon_beretta","weapon_fiveseven","weapon_hk_usp"},
    models = tdm.models
}

stopitslender.teamEncoder = {
    [1] = "red",
    [2] = "green",
    [3] = "blue"
}

function stopitslender.StartRound(data)
	team.SetColor(1,stopitslender.red[2])
	team.SetColor(2,stopitslender.green[2])
	team.SetColor(3,stopitslender.blue[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return stopitslender.StartRoundSV()
end

stopitslender.SupportCenter = true
