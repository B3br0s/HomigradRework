table.insert(ROUND_LIST,"hmcd")

hmcd = hmcd or {}

hmcd.name = "Homicide"
hmcd.TeamBased = false

hmcd.SubTypes = {
    "gfz",
    "standard",
    "ww", -- ВАЙЛДВЕСТ!!!!!!!!
    "soe"
}

hg.Points.hmcd = hg.Points.hmcd or {}
hg.Points.hmcd.Color = Color(150,0,0)
hg.Points.hmcd.Name = "hmcd"

hmcd.Teams = {
    [1] = {Name = "hmcd_bystander",
           Color = Color(87,87,255),
           Desc = "hmcd_bystander_desc"
        },
    [2] = {Name = "hmcd_traitor",
       Color = Color(223,0,0),
       Desc = "hmcd_traitor_desc"
    },
}