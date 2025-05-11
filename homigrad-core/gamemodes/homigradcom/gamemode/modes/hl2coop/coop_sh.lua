table.insert(ROUND_LIST,"coop")

coop = coop or {}
coop.TimeRoundEnds = 1300
coop.Exiting = false
coop.ExitsIn = 0

coop.name = "Half-Life"
coop.TeamBased = false

coop.Teams = {
    [1] = {Name = "coop_rebel",
           Color = Color(255,153,0),
           Desc = "coop_rebel_desc"
        },
    [2] = {Name = "coop_cmb",
           Color = Color(0,38,255),
           Desc = "coop_cmb_desc",
           Model = "models/player/combine_soldier.mdl"
        },
}

hg.Points = hg.Points or {}

hg.Points.coop_spawn_rebel = hg.Points.coop_spawn_rebel or {}
hg.Points.coop_spawn_rebel.Color = Color(150,85,0)
hg.Points.coop_spawn_rebel.Name = "coop_spawn_rebel"

hg.Points.coop_spawn_rebel = hg.Points.coop_spawn_rebel or {}
hg.Points.coop_spawn_rebel.Color = Color(150,85,0)
hg.Points.coop_spawn_rebel.Name = "coop_spawn_rebel"

hg.Points.coop_nextlevel = hg.Points.coop_nextlevel or {}
hg.Points.coop_nextlevel.Color = Color(0,255,55)
hg.Points.coop_nextlevel.Name = "coop_nextlevel"

hg.Points.coop_car = hg.Points.coop_car or {}
hg.Points.coop_car.Color = Color(255,0,0)
hg.Points.coop_car.Name = "coop_car"

hg.Points.coop_cater = hg.Points.coop_cater or {}
hg.Points.coop_cater.Color = Color(255,0,0)
hg.Points.coop_cater.Name = "coop_cater"