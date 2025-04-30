table.insert(ROUND_LIST,"dr")

dr = dr or {}
dr.TimeRoundEnds = 600

dr.name = "Death Run"
dr.TeamBased = true

dr.Teams = {
    [1] = {Name = "dr_runner",
           Color = Color(30,255,0),
           Desc = "dr_runner_desc"
        },
    [2] = {Name = "dr_killer",
       Color = Color(255,29,29),
       Desc = "dr_killer_desc"
    },
}

hg.Points = hg.Points or {}

hg.Points.hunt_dr = hg.Points.hunt_dr or {}
hg.Points.hunt_dr.Color = Color(150,0,0)
hg.Points.hunt_dr.Name = "dr_spawn_killer"

hg.Points.hunt_victim = hg.Points.hunt_victim or {}
hg.Points.hunt_victim.Color = Color(0,150,0)
hg.Points.hunt_victim.Name = "dr_spawn_victim"