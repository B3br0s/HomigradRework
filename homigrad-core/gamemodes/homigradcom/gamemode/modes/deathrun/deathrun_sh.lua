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

hg.Points.dr_spawn_killer = hg.Points.dr_spawn_killer or {}
hg.Points.dr_spawn_killer.Color = Color(150,0,0)
hg.Points.dr_spawn_killer.Name = "dr_spawn_killer"

hg.Points.dr_spawn_runner = hg.Points.dr_spawn_runner or {}
hg.Points.dr_spawn_runner.Color = Color(0,150,0)
hg.Points.dr_spawn_runner.Name = "dr_spawn_runner"