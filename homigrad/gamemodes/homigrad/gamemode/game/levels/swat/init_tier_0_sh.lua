table.insert(LevelList,"swat")
swat = {}
swat.Name = "SWAT"

swat.red = {"SWAT",Color(55,55,150),
	weapons = {"weapon_hands","weapon_police_bat","med_band_big","med_band_small","weapon_taser","weapon_handcuffs","weapon_radio","weapon_hg_flashbang","weapon_glock"},
	main_weapon = {"weapon_ar15","weapon_m4a1"},
	secondary_weapon = {"darkrp_doom_ram"},
	models = {"models/monolithservers/mpd/male_04.mdl","models/monolithservers/mpd/male_03.mdl","models/monolithservers/mpd/male_05.mdl","models/monolithservers/mpd/male_02.mdl"}
}


swat.blue = {"Боевики",Color(200,35,35),
	weapons = {"weapon_hands","med_band_small","weapon_molotok"},
	main_weapon = {"weapon_hands","weapon_ar15","weapon_mp7","weapon_mag7"},
	secondary_weapon = {"weapon_glock","weapon_hk_usp","weapon_glock18","weapon_p220","weapon_beretta","weapon_r8"},
	models = tdm.models
}

swat.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function swat.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,swat.red[2])
	team.SetColor(2,swat.blue[2])

	if CLIENT then

		swat.StartRoundCL()
		return
	end

	swat.StartRoundSV()
end

swat.SupportCenter = true

swat.NoSelectRandom = false