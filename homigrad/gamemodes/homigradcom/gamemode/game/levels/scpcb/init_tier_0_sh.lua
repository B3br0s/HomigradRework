table.insert(LevelList,"scpcb")
scpcb = {}
scpcb.Name = "Breach"

scpcb.red = {"SCP",Color(255,55,55),
    weapons = {"weapon_hands"},
    models = {"models/player/Group02/male_08.mdl"}
}

scpcb.green = {"Д-Класс",Color(255,115,0),
    weapons = {"weapon_hands"},
    models = tdm.models
}

scpcb.blue = {"Персонал Фонда",Color(251,255,0),
    weapons = {"weapon_hands"},
    models = tdm.models
}

scpcb.teamEncoder = {
    [1] = "red",
    [2] = "green",
    [3] = "blue"
}

function scpcb.StartRound(data)
	team.SetColor(1,scpcb.red[2])
	team.SetColor(2,scpcb.green[2])
	team.SetColor(3,scpcb.blue[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		scpcb.StartRoundCL()
		return
	end

    return scpcb.StartRoundSV()
end

scpcb.SupportCenter = true

if SERVER then return end

function scpcb.GetTeamName(ply)
	local game = TableRound()
	local team = game.teamEncoder[ply:Team()]

	if team then
		team = game[team]

		return (ply:GetNWString("Role") or nil),ply.RoleColor
	end
end