hg.Localizations = hg.Localizations or {}

hg.Localizations.en = {}

table.Empty(hg.Localizations.en)

local l = {}

// Текст Смерти
l.Dead = "DEAD"
l.dead_blood = "You died from blood loss."
l.dead_pain = "You died in unbearable pain."
l.dead_painlosing = "You fell asleep."
l.dead_adrenaline = "You died of an overdose."
l.dead_kys = "You killed yourself." //rule 1488: no funny images with text kys!!!!
l.dead_hungry = "You starved to death."
l.dead_neck = "Your neck was broken."
l.dead_necksnap = "Your neck was snapped."
l.dead_world = "%s bid farewell, cruel world!"
l.dead_head = "Boom, headshot."
l.dead_headExplode = "Your head has exploded."
l.dead_fullgib = "You got ripped apart."
l.dead_blast = "You've got exploded."
l.dead_water = "You're drowned."
l.dead_poison = "You died from the poison."
l.dead_burn = "You burnt to death."
l.dead_unknown = "I don't even know how did you died."

l["kill_ValveBiped.Bip01_Head1"] = "head"
l["kill_ValveBiped.Bip01_Spine"] = "back"

l["kill_ValveBiped.Bip01_R_Hand"] = "right hand"
l["kill_ValveBiped.Bip01_R_Forearm"] = "right hand"
l["kill_ValveBiped.Bip01_R_UpperArm"] = "right forearm"

l["kill_ValveBiped.Bip01_R_Foot"] = "right foot"
l["kill_ValveBiped.Bip01_R_Thigh"] = "right thigh"
l["kill_ValveBiped.Bip01_R_Calf"] = "right shin"

l["kill_ValveBiped.Bip01_R_Shoulder"] = "right shoulder"
l["kill_ValveBiped.Bip01_R_Elbow"] = "right elbow"

l["kill_ValveBiped.Bip01_L_Hand"] = "left hand"
l["kill_ValveBiped.Bip01_L_Forearm"] = "left arm"
l["kill_ValveBiped.Bip01_L_UpperArm"] = "left forearm"

l["kill_ValveBiped.Bip01_L_Foot"] = "left foot"
l["kill_ValveBiped.Bip01_L_Thigh"] = "left thigh"
l["kill_ValveBiped.Bip01_L_Calf"] = "left shin"

l["kill_ValveBiped.Bip01_L_Shoulder"] = "left shoulder"
l["kill_ValveBiped.Bip01_L_Elbow"] = "left elbow"

l["in"] = "in"
l.kill_by_wep = "with"

l.died_by = "You got killed by"
l.died = "You got killed"
l.died_killed = "You got killed by"
l.died_by_npc = "Killed by NPC"
l.died_by_object = "Killed by object"

// Оружие
l.gun_revolver = "%s Rounds Chambered"
l.gun_revolvermags = "%s Bullets left"

l.gun_shotgun = "%s"
l.gun_shotgunmags = "%s Shells left"

l.gun_default = "%s"
l.gun_defaultmags = "%s Mags Left"

// Спект
l.SpectALT = "Disable / Enable display of nicknames on ALT"
l.SpectHP = "Health: %s"
l.SpectCur = "Spectators: %s"
l.SpectMode = "Spectating Mode: %s"

// Уровни

l.level_wins = "%s wins."

l.swat_arrived = "SWAT Arrived."
l.swat_arrivein = "SWAT will arrive in: %s"

l.police_arrived = "Police Arrived."
l.police_arrivein = "Police will arrive in: %s"

l.ng_arrived = "National Guard Arrived."
l.ng_arrivein = "National Guard will arrive in: %s"

l.you_are = "You are %s"

l.hunter_victim = "Hunter Target"
l.hunter_victim_desc = "You need to survive. \n Escape when the SWAT arrives."

l.hunter_swat = "SWAT"
l.hunter_swat_desc = "You need to neutralize hunter. \n Help survivors escape."

l.hunter_hunter = "Hunter"
l.hunter_hunter_desc = "Your task is to kill everyone before SWAT arrives."

l.tdm_red = "Red"
l.tdm_red_desc = "Kill opposite team"

l.tdm_blue = "Blue"
l.tdm_blue_desc = "Kill opposite team"

l.riot_red = "Rioters"
l.riot_red_desc = "Keep your rights! Destroy all those who would slow you down!"

l.riot_blue = "Police"
l.riot_blue_desc = "Neutralize rioters, try not to kill them"

// Скорборд

l.sc_players = "Players"
l.sc_invento = "Inventory"

// Остальное
l.open_alpha = "OPEN-ALPHA VERSION"
l.report_bugs = "PLEASE REPORT ALL BUGS TO OUR DISCORD."
l.youre_hungry = "You're hungry."

hg.Localizations.en = l