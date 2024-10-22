--table.insert(LevelList,"construct")
construct = {}
construct.Name = "Construct"

construct.red = {"Игрок",Color(255,255,255),
    weapons = {"weapon_hands","gmod_tool"},
    models = tdm.models
}

construct.teamEncoder = {
    [1] = "red"
}

function construct.StartRound(data)
	team.SetColor(1,construct.red[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return construct.StartRoundSV()
end

construct.SupportCenter = true
