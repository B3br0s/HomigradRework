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
l["kill_ValveBiped.Bip01_Spine1"] = "back"
l["kill_ValveBiped.Bip01_Spine2"] = "back"
l["kill_ValveBiped.Bip01_Spine4"] = "back"

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

l.gun_empty = "Empty"
l.gun_nearempty = "Near Empty"
l.gun_halfempty = "Half Empty"
l.gun_nearfull = "Near Fully"
l.gun_full = "Full" 

l.cuff = "Cuff %s"
l.cuffed = "%s Is already cuffed."

// Спект
l.SpectALT = "Disable / Enable display of nicknames on ALT"
l.SpectHP = "Health: %s"
l.SpectCur = "Spectators: %s"
l.SpectMode = "Spectating Mode: %s"

// Уровни

l.level_wins = "%s wins."
l.levels_endin = "Round ends in: %s"

l.swat_arrived = "SWAT Arrived."
l.swat_arrivein = "SWAT will arrive in: %s"

l.round_to_end_dr = "Round ended"
l.round_will_end_in_dr = "Round will end in: %s"

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

l.dr_runner = "Runner"
l.dr_runner_desc = "You need to complete the map and eliminate \"Killer\""

l.dr_killer = "Killer" //"Saw51" //чеча инцидент оу ее
l.dr_killer_desc = "Your task is to kill everyone on this map using traps."

l.jb_prisoner = "Inmate"
l.jb_prisoner_desc = "You need to kill warden | escape prison."

l.jb_warden = "Warden"
l.jb_warden_desc = "You need to complete your shift as warden. \n Dont let prisoners escape | kill you."

l.tdm_red = "Red"
l.tdm_red_desc = "Kill opposite team"

l.tdm_blue = "Blue"
l.tdm_blue_desc = "Kill opposite team"

l.riot_red = "Rioters"
l.riot_red_desc = "Keep your rights! Destroy all those who would slow you down!"

l.riot_blue = "Police"
l.riot_blue_desc = "Neutralize rioters, try not to kill them"

l.hmcd_bystander = "Innocent"
l.hmcd_bystander_desc = "You are an innocent, rely only on yourself, but stick around with crowds to make traitor's job harder."

l.hmcd_gunman = "Gunman"
l.hmcd_gunman_desc = "You are an innocent, rely only on yourself, but stick around with crowds to make traitor's job harder."

l.hmcd_traitor = "Traitor"
l.hmcd_traitor_desc = "You're geared up with items, poisons, explosives and weapons hidden in your pockets. Murder everyone here."

l.hmcd_gfz = "Gun-Free Zone"
l.hmcd_soe = "State Of Emergency"
l.hmcd_standard = "Standard"

l.hmcd_traitor_soe = "You're geared up with items, poisons, explosives and weapons hidden in your pockets. Murder everyone here." 
l.hmcd_traitor_gfz = "You're geared up with knife hidden in your pockets. Murder everyone here."
l.hmcd_traitor_standard = "You're geared up with items, poisons, explosives and weapons hidden in your pockets. Murder everyone here."

l.hmcd_gunman_soe = "You are an innocent with a hunting weapon. Find and neutralize the traitor before it's too late." 
l.hmcd_gunman_gfz = "You are a bystander of a murder scene, although it didn't happen to you, you better be cautious."
l.hmcd_gunman_standard = "You are a bystander with a concealed firearm. You've tasked yourself to help police find the criminal faster."

l.hmcd_bystander_soe = "You are an innocent, rely only on yourself, but stick around with crowds to make traitor's job harder."
l.hmcd_bystander_gfz = "You are a bystander of a murder scene, although it didn't happen to you, you better be cautious."
l.hmcd_bystander_standard = "You are a bystander of a murder scene, although it didn't happen to you, you better be cautious."

// Скорборд

l.sc_players = "Players"
l.sc_invento = "Inventory"
l.sc_teams = "Teams"
l.sc_settings = "Settings"

l.sc_copysteam = "Copy STEAMID"
l.sc_openprofile = "Open profile"

l.sc_unable_prof = "Unable to open profile."
l.sc_unable_steamid = "Unable to copy STEAMID."
l.sc_success_copy = "Succesfully copied STEAMID (%s)"

l.sc_curround = "Current Round: %s"
l.sc_nextround = "Next Round: %s"
l.sc_team = "Team"
l.sc_ug = "Usergroup"
l.sc_status = "Status"
l.sc_tps = "Server Tickrate: %s"

// Остальное
l.open_alpha = "OPEN-ALPHA VERSION"
l.report_bugs = "PLEASE REPORT ALL BUGS TO OUR DISCORD."
l.youre_hungry = "You're hungry."
l.need_2_players = "We need 2 players to start."

l.alive = "Alive"
l.unalive = "Dead"
l.unknown = "Unknown"
l.spectating = "Spectating"
l.spectator = "Spectator"

hg.Localizations.en = l