//table.insert(ROUND_LIST,"bahmut")

bahmut = bahmut or {}

bahmut.name = "Team Deathmatch"
bahmut.TeamBased = true

bahmut.Teams = {
    [1] = {Name = "bahmut_blue",
           Color = Color(0,0,255),
           Desc = "bahmut_blue_desc"
        },
    [2] = {Name = "bahmut_red",
       Color = Color(255,0,0),
       Desc = "bahmut_red_desc"
    }
}

hg.Points = hg.Points or {}

hg.Points.bahmut_red = hg.Points.bahmut_red or {}
hg.Points.bahmut_red.Color = Color(150,0,0)
hg.Points.bahmut_red.Name = "bahmut_red"

hg.Points.bahmut_blue = hg.Points.bahmut_blue or {}
hg.Points.bahmut_blue.Color = Color(0,0,150)
hg.Points.bahmut_blue.Name = "bahmut_blue"