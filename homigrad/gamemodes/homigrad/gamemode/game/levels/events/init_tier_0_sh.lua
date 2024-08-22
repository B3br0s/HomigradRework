table.insert(LevelList,"events")
events = {}
events.Name = "events"

events.red = {"Игрок",Color(255,255,255),
    weapons = {"weapon_hands","weapon_physgun","gmod_tool"},
    models = tdm.models
}

events.green = {"Игрок",Color(255,255,255),
    weapons = {"weapon_hands","weapon_physgun","gmod_tool"},
    models = tdm.models
}

events.blue = {"Спецназовцы",Color(55,55,55),
    weapons = {"weapon_radio","weapon_hands","weapon_kabar","med_band_big","med_band_small","medkit","painkiller","weapon_hg_f1","weapon_handcuffs","weapon_taser","weapon_hg_flashbang"},
    main_weapon = {"weapon_mk18","weapon_m4a1","weapon_m3super","weapon_mp7","weapon_xm1014","weapon_fal","weapon_galilsar","weapon_m249","weapon_mp5","weapon_mp40"},
    secondary_weapon = {"weapon_beretta","weapon_fiveseven","weapon_hk_usp"},
    models = tdm.models
}

events.teamEncoder = {
    [1] = "red",
    [2] = "green",
    [3] = "blue"
}

function events.StartRound(data)
	team.SetColor(1,events.red[2])
	team.SetColor(2,events.green[2])
	team.SetColor(3,events.blue[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return events.StartRoundSV()
end

events.SupportCenter = true
