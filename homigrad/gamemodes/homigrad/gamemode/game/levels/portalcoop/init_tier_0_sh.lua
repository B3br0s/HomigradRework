table.insert(LevelList,"pcoop")
pcoop = {}
pcoop.Name = "Portal Coop"

pcoop.red = {"Испытуемые",Color(186,117,0),
    weapons = {"weapon_hands"},
    models = tdm.models
}

pcoop.teamEncoder = {
    [1] = "red"
}

function pcoop.StartRound(data)
	team.SetColor(1,pcoop.red[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return pcoop.StartRoundSV()
end

pcoop.SupportCenter = true
