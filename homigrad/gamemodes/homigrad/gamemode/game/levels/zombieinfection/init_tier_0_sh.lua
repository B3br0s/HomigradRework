table.insert(LevelList,"zombieinfection")
zombieinfection = {}
zombieinfection.Name = "Зомби Инфекция"

zombieinfection.red = {"Инфицированные",Color(255,55,55),
    weapons = {"weapon_handsinfected"},
    models = {"models/player/corpse1.mdl","models/player/skeleton.mdl"}
}

zombieinfection.green = {"Люди",Color(55,55,255),
    weapons = {"weapon_radio","weapon_hands","weapon_kabar","medkit","painkiller","weapon_hg_f1"},
    main_weapon = {"weapon_spas12","weapon_mp7","weapon_hands","weapon_hands"},
    secondary_weapon = {"weapon_beretta","weapon_fiveseven","weapon_hk_usp","weapon_p220"},
    models = tdm.models
}

zombieinfection.blue = {"Люди",Color(55,55,55),
    weapons = {"weapon_radio","weapon_hands","weapon_kabar","med_band_big","med_band_small","medkit","painkiller","weapon_hg_f1","weapon_handcuffs","weapon_taser","weapon_hg_flashbang"},
    main_weapon = {"weapon_mk18","weapon_m4a1","weapon_m3super","weapon_mp7","weapon_xm1014","weapon_fal","weapon_galilsar","weapon_m249","weapon_mp5","weapon_mp40"},
    secondary_weapon = {"weapon_beretta","weapon_fiveseven","weapon_hk_usp"},
    models = tdm.models
}

zombieinfection.teamEncoder = {
    [1] = "red",
    [2] = "green",
    [3] = "blue"
}

function zombieinfection.StartRound(data)
	team.SetColor(1,zombieinfection.red[2])
	team.SetColor(2,zombieinfection.green[2])
	team.SetColor(3,zombieinfection.blue[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return zombieinfection.StartRoundSV()
end

zombieinfection.SupportCenter = true
