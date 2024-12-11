table.insert(LevelList,"riot")
riot = {}
riot.Name = "RIOT"

--riot.red = {"Полиция",Color(55,55,150),
riot.red = {"Police",Color(55,55,150),
	weapons = {"weapon_hands","weapon_pbat","weapon_taser","weapon_radio"},
	main_weapon = {"weapon_per4ik","medkit","painkiller","weapon_per4ik"},
	secondary_weapon = {"weapon_r870police"," "," ","weapon_r870police"},
	models = {"models/monolithservers/mpd/male_04.mdl","models/monolithservers/mpd/male_03.mdl","models/monolithservers/mpd/male_05.mdl","models/monolithservers/mpd/male_02.mdl"}
}


--riot.blue = {"Бунтующие",Color(75,45,45),
riot.blue = {"Rioters",Color(75,45,45),
	weapons = {"weapon_hands","med_band_small"},
	main_weapon = {"weapon_hammer","med_band_big","med_band_small","weapon_molotov","weapon_per4ik","weapon_hg_beartrap","weapon_hammer","weapon_axe","weapon_per4ik"},
	secondary_weapon = {"weapon_woodenbat","weapon_metalbat","weapon_pan"},
	models = {"models/player/Group01/male_04.mdl","models/player/Group01/male_01.mdl","models/player/Group01/male_02.mdl","models/player/Group01/male_08.mdl"}
}

riot.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function riot.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,riot.red[2])
	team.SetColor(2,riot.blue[2])

	if CLIENT then

		riot.StartRoundCL()
		return
	end

	riot.StartRoundSV()
end

riot.SupportCenter = true

riot.NoSelectRandom = false