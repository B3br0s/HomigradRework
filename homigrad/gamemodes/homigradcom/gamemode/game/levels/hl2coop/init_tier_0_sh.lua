table.insert(LevelList,"hl2")
hl2 = {}
hl2.Name = "Half Life"

hl2.red = {"Повстанцы",Color(255,123,0),
    weapons = {"weapon_radio","weapon_sog","weapon_hands","med_band_big","med_band_small","medkit","painkiller"},
    main_weapon = {"weapon_akm_bw","weapon_aks74u"},
    secondary_weapon = {"weapon_glockp80"},
    models = {"models/player/group03/male_02.mdl","models/player/group03/male_04.mdl","models/player/group03/male_05.mdl","models/player/group03/male_06.mdl"}
}

hl2.teamEncoder = {
    [1] = "red"
}

function hl2.StartRound(data)
	team.SetColor(1,hl2.red[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return hl2.StartRoundSV()
end

hl2.SupportCenter = true
