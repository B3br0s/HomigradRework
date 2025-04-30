table.insert(ROUND_LIST,"jb")

jb = jb or {}

jb.name = "JailBreak"
jb.TeamBased = true

jb.Teams = {
    [1] = {Name = "jb_prisoner",
           Color = Color(255,123,0),
           Desc = "jb_prisoner_desc"
        },
    [2] = {Name = "jb_warden",
       Color = Color(0,38,255),
       Desc = "jb_warden_desc"
    }
}

hg.Points = hg.Points or {}

hg.Points.jb_warden = hg.Points.jb_warden or {}
hg.Points.jb_warden.Color = Color(0,119,255)
hg.Points.jb_warden.Name = "jb_warden"

hg.Points.jb_prisoner = hg.Pointsjb_prisoner or {}
hg.Points.jb_prisoner.Color = Color(255,115,0)
hg.Points.jb_prisoner.Name = "jb_prisoner"