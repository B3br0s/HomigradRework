table.insert(ROUND_LIST,"gw")

gw = gw or {}

gw.name = "Gang Wars"
gw.TeamBased = true

gw.Teams = {
    [1] = {Name = "gw_blue",
           Color = Color(21,184,0),
           Desc = "gw_blue_desc"
        },
    [2] = {Name = "gw_red",
       Color = Color(184,21,0),
       Desc = "gw_red_desc"
    }
}