table.insert(LevelList,"hideandseek")
hideandseek = {}
hideandseek.Name = "Hide And Seek"

hideandseek.red = {"Искатель",Color(255,55,55),
    weapons = {"weapon_radio","weapon_gurkha","weapon_hands","med_band_big","med_band_small","medkit","painkiller"},
    main_weapon = {"weapon_m3super","weapon_saiga12","weapon_xm1014","weapon_sks"},
    secondary_weapon = {"weapon_makarov","weapon_fiveseven","weapon_glock"},
    models = {"models/players/an_generic_terrorist.mdl"}
}

hideandseek.green = {"Прячущийся",Color(55,55,255),
    weapons = {"weapon_hands"},
    models = tdm.models
}

hideandseek.blue = {"Спецназовцы",Color(55,55,55),
    weapons = {"weapon_radio","weapon_hands","weapon_kabar","med_band_big","med_band_small","medkit","painkiller","weapon_hg_f1","weapon_handcuffs","weapon_taser","weapon_hg_flashbang"},
    main_weapon = {"weapon_mk18","weapon_m4a1","weapon_m3super","weapon_mp7","weapon_xm1014","weapon_fal","weapon_galilsar","weapon_m249","weapon_mp5","weapon_mp40"},
    secondary_weapon = {"weapon_beretta","weapon_fiveseven","weapon_hk_usp"},
    models = tdm.models
}

hideandseek.teamEncoder = {
    [1] = "red",
    [2] = "green",
    [3] = "blue"
}

function hideandseek.StartRound(data)
	team.SetColor(1,hideandseek.red[2])
	team.SetColor(2,hideandseek.green[2])
	team.SetColor(3,hideandseek.blue[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return hideandseek.StartRoundSV()
end

hideandseek.SupportCenter = true
