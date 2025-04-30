table.insert(ROUND_LIST,"hmcd")

hmcd = hmcd or {}

hmcd.name = "Homicide"
hmcd.TeamBased = false

hmcd.SubTypes = {
    "gfz",
    "standard",
    //"wildwest",
    "soe"
}

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