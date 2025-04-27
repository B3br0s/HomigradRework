table.insert(ROUND_LIST,"riot")

riot = riot or {}

riot.name = "Riot"

riot.Teams = {
    [1] = {Name = "riot_blue",
           Color = Color(0,0,255),
           Desc = "riot_blue_desc"
        },
    [2] = {Name = "riot_red",
       Color = Color(255,0,0),
       Desc = "riot_red_desc"
    }
}

hg.Points = hg.Points or {}

hg.Points.tdm_red = hg.Points.tdm_red or {}
hg.Points.tdm_red.Color = Color(150,0,0)
hg.Points.tdm_red.Name = "tdm_red"

hg.Points.tdm_blue = hg.Points.tdm_blue or {}
hg.Points.tdm_blue.Color = Color(0,0,150)
hg.Points.tdm_blue.Name = "tdm_blue"