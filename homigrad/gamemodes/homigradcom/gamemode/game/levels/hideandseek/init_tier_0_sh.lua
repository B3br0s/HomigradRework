table.insert(LevelList,"hideandseek")
hideandseek = {}
hideandseek.Name = "Hide And Seek"

hideandseek.red = {"Искатель",Color(255,55,55),
    weapons = {"weapon_radio","weapon_sog","weapon_hands"},
    main_weapon = {"weapon_xm1014","weapon_saiga12","weapon_doublebarrel"},
    secondary_weapon = {"weapon_fiveseven","weapon_glockp80"},
    models = {"models/player/Group02/male_08.mdl"}
}

hideandseek.green = {"Прячущийся",Color(62,255,55),
    weapons = {"weapon_hands"},
    models = tdm.models
}

hideandseek.blue = {"Спецназовцы",Color(55,55,55),
    weapons = {"weapon_radio","weapon_hands","weapon_sog","med_bandagebig","med_bandagesmall","med_ifak","med_ibuprofen","weapon_rgd5","weapon_handcuffs","weapon_taser","weapon_m7920"},
    main_weapon = {"weapon_hk416","weapon_m4a1","weapon_xm1014","weapon_mp7"},
    secondary_weapon = {"weapon_m9","weapon_fiveseven","weapon_hk_usps"},
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
