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
l.gun_nearempty = "Nearly Empty"
l.gun_halfempty = "Half Empty"
l.gun_nearfull = "Nearly Full"
l.gun_r_pump = "Press R to pump."
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
l.lvl_loadingmode = "Loading mode %s"

l.hunter_victim = "Victim"
l.hunter_victim_desc = "You need to survive. \n Escape when the SWAT arrives."

l.hunter_swat = "SWAT"
l.hunter_swat_desc = "You need to neutralize hunter. \n Help survivors escape."

l.hunter_hunter = "Hunter"
l.hunter_hunter_desc = "Your task is to kill everyone before SWAT arrives."

l.dr_runner = "Runner"
l.dr_runner_desc = "You need to complete the map and eliminate \"Killer\""

l.dr_killer = "Killer" //"Saw51" //чеча инцидент оу ее
l.dr_killer_desc = "Your task is to kill everyone on this map using traps."
l.dr_youwilldiein = "You will die in: %s"

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
l.hmcd_ww = "Wild West"

l.hmcd_traitor_soe = "You're geared up with items, poisons, explosives and weapons hidden in your pockets. Murder everyone here." 
l.hmcd_traitor_gfz = "You're geared up with knife hidden in your pockets. Murder everyone here."
l.hmcd_traitor_standard = "You're geared up with items, poisons, explosives and weapons hidden in your pockets. Murder everyone here."
l.hmcd_traitor_ww = "This town ain't that big for all of us."

l.hmcd_gunman_soe = "You are an innocent with a hunting weapon. Find and neutralize the traitor before it's too late." 
l.hmcd_gunman_gfz = "You are a bystander of a murder scene, although it didn't happen to you, you better be cautious."
l.hmcd_gunman_standard = "You are a bystander with a concealed firearm. You've tasked yourself to help police find the criminal faster."
l.hmcd_gunman_ww = "You're the sheriff of this town. You gotta find and kill the lawless bastard."

l.hmcd_bystander_soe = "You are an innocent, rely only on yourself, but stick around with crowds to make traitor's job harder."
l.hmcd_bystander_gfz = "You are a bystander of a murder scene, although it didn't happen to you, you better be cautious."
l.hmcd_bystander_standard = "You are a bystander of a murder scene, although it didn't happen to you, you better be cautious."
l.hmcd_bystander_ww = "We gotta get justice served over here, there's a lawless prick murdering men."

l.hl2dm_cmb_name = "UNIT %s"
l.hl2dm_cmb = "Combine"
l.hl2dm_cmb_desc = "Eliminate any resistance."

l.hl2dm_rebel = "Rebel"
l.hl2dm_rebel_desc = "Eliminate every Combine unit!"

l.criresp_suspect = "Suspect"
l.criresp_suspect_desc = "This is my fucking house, bitches, I can do what I want."

l.criresp_swat = "SWAT Operator"
l.criresp_swat_desc = "Negotiations failed, eliminate the threat. 10-4"

l.zs_surv = "Human"
l.zs_surv_desc = "Survive."

l.zs_zombie = "Zombie"
l.zs_zombie_desc = "KILL EVERYONE"
l.zs_wavein = "Next wave in: %s"
l.zs_waveendin = "Wave will end in: %s"
l.zs_peopleleft = "Humans left: %s"
l.zs_buymenu_open = "Press F2 to open buymenu"

l.coop_endsin = "Map will change in: %s"
l.coop_rebel = "Rebels"
l.coop_gondon = "Gordon Freeman"
l.coop_gondon_desc = "Lead the resistance to win!"
l.coop_cmb = "Combine"

l.coop_rebel_desc = "Follow the freeman!"
l.coop_cmb_desc = "what the fuck?"

l.event_maker = "Eventmaster"
l.event_player = "Player"

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
l.sc_mutedead = "Mute dead"
l.sc_muteall = "Mute all"

//Радиалка
l.hg_posture = "Change Posture"
l.hg_resetposture = "Reset Posture"
l.hg_suicide = "Commit suicide."
l.hg_unload = "Unload"

// Остальное
l.inv_drop = "Drop"
l.inv_roll = "Roll drum"
l.pulse_normal = "Normal pulse."
l.pulse_high = "High pulse."
l.pulse_low = "Low pulse."
l.pulse_lowest = "You can't feel a pulse"
l.pulse_no = "You can't feel a pulse"
l.open_alpha = "OPEN-ALPHA VERSION"
l.report_bugs = "PLEASE REPORT ALL BUGS TO OUR DISCORD."
l.youre_hungry = "You're hungry."
l.need_2_players = "We need 2 players to start."

l.use_door = "Door"
l.ent_small_crate = "Small Container"
l.ent_medium_crate = "Medium Container"
l.ent_large_crate = "Large Container"
l.ent_melee_crate = "Melee Container"
l.ent_weapon_crate = "Weapon Container"
l.ent_grenade_crate = "Grenade Container"
l.ent_explosives_crate = "Explosives Container"
l.ent_medkit_crate = "Medicines Container"
l.use_ezammo = "Ammo Crate"

l.use_time_bomb = "Time Bomb"
l.use_fragnade = "Frag Nade"
l.use_firenade = "Incendiary Nade"
l.use_sticknade = "Stick Nade"
l.use_dynam = "Dynamite"
l.use_smokenade = "Smoke Nade"
l.use_signalnade = "Signal Nade"
l.use_gasnade = "Poison Gas Nade"
l.use_teargasnade = "Tear Gas Nade"
l.use_detpack = "Detonation Pack"
l.use_buket = "Grenade Satchel Charge"
l.use_tnt = "Satchel Charge"
l.use_button = "Button"

l.alive = "Alive"
l.unalive = "Dead"
l.unknown = "Unknown"
l.spectating = "Spectating"
l.spectator = "Spectator"

l.cant_kick = "You cant kick because your leg is broken."
l.leg_hurt = "Your leg hurts."
l.uncon = "UNCONSCIOUS"

l.heal = "Heal %s"
l.wep_delay = "Delay: %s"
l.wep_dmg = "Damage: %s"
l.wep_force = "Force: %s"

l.item_notexist = "Item is not exist."

l.hasnt_pulse = "He has no pulse."
l.otrub_but_he_live = "He's unconscious, but he's still alive."
l.has_pulse = "He has pulse."

l.r_close = "Press R to close."

//Локализация названий

l.weapon_bandage = "Bandage"
l.weapon_medkit_hg = "Medkit"
l.weapon_painkillers_hg = "Painkillers"
l.weapon_adrenaline = "Adrenaline"

l.weapon_beton = "Eatable armature"
l.weapon_burger = "Burger"
l.weapon_water_bottle = "Water Bottle"
l.weapon_canned_burger = "Canned Burger"
l.weapon_milk = "Milk"
l.weapon_chips = "Pringles"
l.weapon_energy_drink = "Monster Energy"

l.weapon_ied = "Improved Explosive Device"
l.ied_plant = "Plant IED"
l.ied_metalprop = "in metallic prop"
l.weapon_hands = "Hands"

l.weapon_radio = "Radio"

l.weapon_handcuffs = "Cuffs"

l.weapon_pbat = "Police Tonfa"
l.weapon_sog = "SOG SEAL 2000"
l.weapon_crowbar_hg = "Crowbwar"
l.weapon_fubar = "Fubar"
l.weapon_hammer = "Hammer"
l.weapon_hatchet = "Hatchet"
l.weapon_axe = "Wooden Axe"
l.weapon_shovel = "Shovel"
l.weapon_melee = "Combat Knife"

hg.Localizations.en = l