table.insert(ROUND_LIST,"hl2dm")

hl2dm = hl2dm or {}

hl2dm.name = "Half-Life Deathmatch"
hl2dm.TeamBased = true

hl2dm.Teams = {
    [1] = {Name = "hl2dm_cmb",
            PrintName = "hl2dm_cmb_name",
           Color = Color(0,0,255),
           Desc = "hl2dm_cmb_desc"
        },
    [2] = {Name = "hl2dm_rebel",
       Color = Color(255,145,0),
       Desc = "hl2dm_rebel_desc"
    }
}