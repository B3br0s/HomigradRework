table.insert(LevelList,"tdm")
tdm = {}
tdm.Name = "Team Death Match"

local models = {}

for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end

tdm.models = models
tdm.red = {
	"Красные",Color(255,75,75),
	weapons = {"weapon_radio","weapon_sog","weapon_hands","med_ifak"},
	main_weapon = {"weapon_glockp80"},
	secondary_weapon = {},
	models = models
}


tdm.blue = {
	"Синие",Color(75,75,255),
	weapons = {"weapon_radio","weapon_hands","weapon_sog","med_ifak"},
	main_weapon = {"weapon_hk_usps"},
	secondary_weapon = {},
	models = models
}

tdm.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function tdm.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,red)
	team.SetColor(2,blue)

	if CLIENT then tdm.StartRoundCL() return end

	tdm.StartRoundSV()
end

if SERVER then return end

local colorRed = Color(255,0,0)

function tdm.GetTeamName(ply)
	local game = TableRound()
	local team = game.teamEncoder[ply:Team()]

	if team then
		team = game[team]

		return team[1],team[2]
	end
end

function tdm.ChangeValue(oldName,value)
	local oldValue = tdm[oldName]

	if oldValue ~= value then
		oldValue = value

		return true
	end
end

function tdm.AccurceTime(time)
	return string.FormattedTime(time,"%02i:%02i")
end