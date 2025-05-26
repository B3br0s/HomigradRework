table.insert(ROUND_LIST,"criresp")

criresp = criresp or {}

criresp.untilswat = 90

criresp.name = "Crisis Response"
criresp.TeamBased = true

criresp.Teams = {
    [1] = {Name = "criresp_swat",
           Color = Color(68, 10, 255),
           Desc = "criresp_swat_desc"
        },
    [2] = {Name = "criresp_suspect",
       Color = Color(228, 49, 49),
       Desc = "criresp_suspect_desc"
    }
}

hg.Points = hg.Points or {}

hg.Points.criresp_suspect = hg.Points.criresp_suspect or {}
hg.Points.criresp_suspect.Color = Color(150,0,0)
hg.Points.criresp_suspect.Name = "criresp_suspect"

hg.Points.criresp_swat = hg.Points.criresp_swat or {}
hg.Points.criresp_swat.Color = Color(0,0,150)
hg.Points.criresp_swat.Name = "criresp_swat"