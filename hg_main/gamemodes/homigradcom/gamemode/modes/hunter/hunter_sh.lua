table.insert(ROUND_LIST,"hunter")

hunter = hunter or {}

hunter.name = "Hunter"
hunter.TeamBased = true

hunter.Teams = {
    [1] = {Name = "hunter_victim",
           Color = Color(85,255,85),
           Desc = "hunter_victim_desc"
        },
    [2] = {Name = "hunter_hunter",
       Color = Color(255,0,0),
       Desc = "hunter_hunter_desc"
    },
    [3] = {Name = "hunter_swat",
       Color = Color(29,33,255),
       Desc = "hunter_swat_desc"
    },
}

hg.Points = hg.Points or {}

hg.Points.hunt_hunter = hg.Points.hunt_hunter or {}
hg.Points.hunt_hunter.Color = Color(150,0,0)
hg.Points.hunt_hunter.Name = "hunt_hunter"

hg.Points.hunt_victim = hg.Points.hunt_victim or {}
hg.Points.hunt_victim.Color = Color(0,150,0)
hg.Points.hunt_victim.Name = "hunt_victim"

hg.Points.hunt_law = hg.Points.hunt_law or {}
hg.Points.hunt_law.Color = Color(0,27,150)
hg.Points.hunt_law.Name = "hunt_law"