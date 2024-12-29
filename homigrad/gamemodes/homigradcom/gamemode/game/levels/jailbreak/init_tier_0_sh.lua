table.insert(LevelList,"jailbreak")
jailbreak = {}
jailbreak.Name = "JailBreak"

jailbreak.red = {"Охранники",Color(0,0,255),
    weapons = {"weapon_radio","weapon_police_bat","weapon_hands","weapon_taser","weapon_handcuffs"},
    main_weapon = {"css_m249"},
    secondary_weapon = {"css_57"},
    models = tdm.models
}

jailbreak.blue = {"Заключенные",Color(255,0,0),
    weapons = {"weapon_hands","css_knife"},
	main_weapon = {"weapon_hands"},
    models  = tdm.models
}

jailbreak.teamEncoder = {
    [1] = "blue",
    [2] = "red",
}

function jailbreak.StartRound(data)
	team.SetColor(1,jailbreak.red[1])
	team.SetColor(2,jailbreak.blue[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return jailbreak.StartRoundSV()
end

jailbreak.SupportCenter = false
