table.insert(ROUND_LIST,"zs")

zs = zs or {}

zs.name = "Zombie Survival"
zs.TeamBased = true

zs.Teams = {
    [1] = {Name = "zs_zombie",
       Color = Color(255, 0, 0),
       Desc = "zs_zombie_desc"
    },
    [2] = {Name = "zs_surv",
           Color = Color(60, 255, 0),
           Desc = "zs_surv_desc"
    }
}

hg.Points = hg.Points or {}

hg.Points.zs_zombie = hg.Points.zs_zombie or {}
hg.Points.zs_zombie.Color = Color(150,0,0)
hg.Points.zs_zombie.Name = "zs_zombie"

hg.Points.zs_surv = hg.Points.zs_surv or {}
hg.Points.zs_surv.Color = Color(0,0,150)
hg.Points.zs_surv.Name = "zs_surv"