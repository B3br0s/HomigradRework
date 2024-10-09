--table.insert(LevelList,"hl2coop")
hl2coop = {}
hl2coop.Name = "Half Life 2 Coop"

hl2coop.red = {"Повстанцы",Color(186,117,0),
    weapons = {"weapon_radio","weapon_hands","medkit"},
    main_weapon = {"weapon_mag7","weapon_mp7","weapon_mp5","weapon_akm","weapon_ak74u"},
    secondary_weapon = {"weapon_r8","weapon_glock","weapon_p220","weapon_beretta"},
    models = {"models/player/Group03/male_05.mdl","models/player/Group03/male_05.mdl","models/player/Group03m/male_09.mdl"}
}

hl2coop.green = {"Наблюдатель",Color(155,155,155),
    weapons = {"weapon_hands"},
    models = tdm.models
}

hl2coop.blue = {"Комбайны",Color(55,55,255),
    weapons = {"weapon_radio","weapon_hands","weapon_kabar","med_band_big","med_band_small","medkit","painkiller","weapon_hg_f1","weapon_handcuffs","weapon_taser","weapon_hg_flashbang"},
    main_weapon = {"weapon_sar2"},
    secondary_weapon = {"weapon_hk_usp"},
    models = tdm.models
}

hl2coop.teamEncoder = {
    [1] = "red",
    [2] = "green",
    [3] = "blue"
}

function hl2coop.StartRound(data)
	team.SetColor(1,hl2coop.red[2])
	team.SetColor(2,hl2coop.green[2])
	team.SetColor(3,hl2coop.blue[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return hl2coop.StartRoundSV()
end

hl2coop.SupportCenter = true
