table.insert(LevelList,"SandBox")
SandBox = {}
SandBox.Name = "SandBox"

SandBox.red = {"Игрок",Color(255,255,255),
    weapons = {"weapon_hands","weapon_physgun","gmod_tool"},
    models = tdm.models
}

SandBox.green = {"Игрок",Color(255,255,255),
    weapons = {"weapon_hands","weapon_physgun","gmod_tool"},
    models = tdm.models
}

SandBox.blue = {"Спецназовцы",Color(55,55,55),
    weapons = {"weapon_radio","weapon_hands","weapon_kabar","med_band_big","med_band_small","medkit","painkiller","weapon_hg_f1","weapon_handcuffs","weapon_taser","weapon_hg_flashbang"},
    main_weapon = {"weapon_mk18","weapon_m4a1","weapon_m3super","weapon_mp7","weapon_xm1014","weapon_fal","weapon_galilsar","weapon_m249","weapon_mp5","weapon_mp40"},
    secondary_weapon = {"weapon_beretta","weapon_fiveseven","weapon_hk_usp"},
    models = tdm.models
}

SandBox.teamEncoder = {
    [1] = "red",
    [2] = "green",
    [3] = "blue"
}

function SandBox.StartRound(data)
	team.SetColor(1,SandBox.red[2])
	team.SetColor(2,SandBox.green[2])
	team.SetColor(3,SandBox.blue[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return SandBox.StartRoundSV()
end

SandBox.SupportCenter = true
