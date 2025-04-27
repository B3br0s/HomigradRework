table.insert(ROUND_LIST,"tdm")

tdm = tdm or {}

tdm.name = "Team Deathmatch"

tdm.Teams = {
    [1] = {Name = "tdm_blue",
           Color = Color(0,0,255),
           Desc = "tdm_blue_desc"
        },
    [2] = {Name = "tdm_red",
       Color = Color(255,0,0),
       Desc = "tdm_red_desc"
    }
}

hg.Points = hg.Points or {}

hg.Points.tdm_red = hg.Points.tdm_red or {}
hg.Points.tdm_red.Color = Color(150,0,0)
hg.Points.tdm_red.Name = "tdm_red"

hg.Points.tdm_blue = hg.Points.tdm_blue or {}
hg.Points.tdm_blue.Color = Color(0,0,150)
hg.Points.tdm_blue.Name = "tdm_blue"