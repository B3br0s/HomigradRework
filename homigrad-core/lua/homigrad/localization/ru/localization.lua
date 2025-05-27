hg.Localizations = hg.Localizations or {}

hg.Localizations.ru = {}

table.Empty(hg.Localizations.ru)

local l = {}

// Текст Смерти
l.Dead = "МЁРТВ"
l.dead_blood = "Ты умер от потери крови."
l.dead_pain = "Ты умер от невыносимой боли."
l.dead_painlosing = "Ты упал спать."
l.dead_adrenaline = "Ты умер от передоза."
l.dead_kys = "Ты самоубился." //rule 1488: no funny images with text kys!!!!
l.dead_hungry = "Ты помер с голоду."
l.dead_neck = "Твоя шея была сломана."
l.dead_necksnap = "Твоя шея была свёрнута."
l.dead_world = "%s прощается с жестоким миром!"
l.dead_head = "Бум, в голову."
l.dead_headExplode = "Твоя голова была взорвана."
l.dead_fullgib = "Тебя разорвало."
l.dead_blast = "Ты взорвался."
l.dead_water = "Ты утонул."
l.dead_poison = "Ты умер от отравления."
l.dead_burn = "Ты сгорел заживо."
l.dead_unknown = "Я даже не знаю как ты умер то."

l["kill_ValveBiped.Bip01_Head1"] = "голову"
l["kill_ValveBiped.Bip01_Spine"] = "спину"
l["kill_ValveBiped.Bip01_Spine1"] = "спину"
l["kill_ValveBiped.Bip01_Spine2"] = "спину"
l["kill_ValveBiped.Bip01_Spine4"] = "спину"

l["kill_ValveBiped.Bip01_R_Hand"] = "правую руку"
l["kill_ValveBiped.Bip01_R_Forearm"] = "правую руку"
l["kill_ValveBiped.Bip01_R_UpperArm"] = "правый локоть"

l["kill_ValveBiped.Bip01_R_Foot"] = "правую ногу"
l["kill_ValveBiped.Bip01_R_Thigh"] = "правую ногу"
l["kill_ValveBiped.Bip01_R_Calf"] = "правую ногу"

l["kill_ValveBiped.Bip01_R_Shoulder"] = "правое плечо"
l["kill_ValveBiped.Bip01_R_Elbow"] = "правый локоть"

l["kill_ValveBiped.Bip01_L_Hand"] = "левую руку"
l["kill_ValveBiped.Bip01_L_Forearm"] = "левую руку"
l["kill_ValveBiped.Bip01_L_UpperArm"] = "левый локоть"

l["kill_ValveBiped.Bip01_L_Foot"] = "левую ногу"
l["kill_ValveBiped.Bip01_L_Thigh"] = "левую ногу"
l["kill_ValveBiped.Bip01_L_Calf"] = "левую"

l["kill_ValveBiped.Bip01_L_Shoulder"] = "левое плечо"
l["kill_ValveBiped.Bip01_L_Elbow"] = "левый локоть"

l["in"] = "в"
l.kill_by_wep = "с помощью"

l.died_by = "Тебя убил"
l.died = "Тебя убило"
l.died_killed = "Тебя убил"
l.died_by_npc = "Убил НИП"
l.died_by_object = "Убил предмет"

// Оружие
l.gun_revolver = "%s Пуль заряжено"
l.gun_revolvermags = "%s Пуль в запасе"

l.gun_shotgun = "%s"
l.gun_shotgunmags = "%s Патрон осталось"

l.gun_default = "%s"
l.gun_defaultmags = "%s Магазинов осталось"

l.gun_empty = "Пусто"
l.gun_nearempty = "Почти Пусто"
l.gun_halfempty = "На половину пуст"
l.gun_nearfull = "Почти полон"
l.gun_r_pump = "Нажми R чтобы передёрнуть затвор."
l.gun_full = "Полон" 

l.cuff = "Связать %s"
l.cuffed = "%s Уже связан."

// Спект
l.SpectALT = "Выключить / Включить отображение никнеймов на ALT"
l.SpectHP = "Здоровье: %s"
l.SpectCur = "Наблюдателей: %s"
l.SpectMode = "Режим наблюдателя: %s"

// Уровни

l.level_wins = "%s выиграли."  
l.levels_endin = "Раунд закончится через: %s"

l.swat_arrived = "Прибыл Спецназ."  
l.swat_arrivein = "Спецназ прибудет через: %s"  

l.police_arrived = "Прибыла полиция."  
l.police_arrivein = "Полиция прибудет через: %s"  

l.ng_arrived = "Прибыла Национальная гвардия."  
l.ng_arrivein = "Национальная гвардия прибудет через: %s"  

l.you_are = "Вы – %s"  
l.lvl_loadingmode = "Загружаем режим %s"

l.hunter_victim = "Жертвы"  
l.hunter_victim_desc = "Вы должны выжить. \n Спасайтесь, когда прибудет спецназ."  

l.hunter_swat = "Спецназовцы"  
l.hunter_swat_desc = "Вы должны нейтрализовать Охотника. \n Помогите выжившим сбежать."  

l.hunter_hunter = "Охотники"  
l.hunter_hunter_desc = "Ваша задача – убить всех до прибытия спецназа."

l.hunter_hunter = "Hunter"
l.hunter_hunter_desc = "Ваша задача убить всех до приезда "

l.dr_runner = "Бегуны"
l.dr_runner_desc = "Вам нужно завершить карту и убить \"Убийцу\""

l.dr_killer = "Убийцы"
l.dr_killer_desc = "Ваша задача убить всех используя ловушки на карте"
l.dr_youwilldiein = "Ты умрешь через: %s"

l.jb_prisoner = "Заключенные"
l.jb_prisoner_desc = "Вам нужно убить надзирателя | сбежать из тюрьмы."

l.jb_warden = "Надзиратели"
l.jb_warden_desc = "Ваша задача закончить вашу смену. \n Не дайте заключенный сбежать | убить вас."

l.tdm_red = "Красные"  
l.tdm_red_desc = "Уничтожьте противоположную команду"  

l.tdm_blue = "Синие"  
l.tdm_blue_desc = "Уничтожьте противоположную команду"  

l.riot_red = "Бунтующие"  
l.riot_red_desc = "Отстаивайте свои права! Уничтожьте всех, кто встанет у вас на пути!"  

l.riot_blue = "Полиция"  
l.riot_blue_desc = "Нейтрализуйте бунтовщиков, старайтесь не убивать их"  

l.hmcd_bystander = "Невиновные"  
l.hmcd_bystander_desc = "Вы невиновны, полагайтесь только на себя, но держитесь в толпе, чтобы усложнить задачу предателю."  

l.hmcd_gunman = "Вооружённый"  
l.hmcd_gunman_desc = "Вы невиновны, полагайтесь только на себя, но держитесь в толпе, чтобы усложнить задачу предателю."  

l.hmcd_traitor = "Предатели"  
l.hmcd_traitor_desc = "У вас есть снаряжение, яды, взрывчатка и оружие, спрятанное в карманах. Убейте всех здесь."  

l.hmcd_gfz = "Зона без оружия"  
l.hmcd_soe = "Чрезвычайное положение"  
l.hmcd_standard = "Стандартный режим"  

l.hmcd_traitor_soe = "У вас есть снаряжение, яды, взрывчатка и оружие, спрятанное в карманах. Убейте всех здесь."  
l.hmcd_traitor_gfz = "У вас есть нож, спрятанный в кармане. Убейте всех здесь."  
l.hmcd_traitor_standard = "У вас есть снаряжение, яды, взрывчатка и оружие, спрятанное в карманах. Убейте всех здесь."  

l.hmcd_gunman_soe = "Вы невиновны, но у вас есть охотничье оружие. Найдите и нейтрализуйте предателя, пока не стало слишком поздно."  
l.hmcd_gunman_gfz = "Вы свидетель убийства, хотя вас это не коснулось, лучше быть осторожным."  
l.hmcd_gunman_standard = "Вы свидетель с табельным оружием. Вы решили помочь полиции быстрее найти преступника."  

l.hmcd_bystander_soe = "Вы невиновны, полагайтесь только на себя, но держитесь в толпе, чтобы усложнить задачу предателю."  
l.hmcd_bystander_gfz = "Вы свидетель убийства, хотя вас это не коснулось, лучше быть осторожным."  
l.hmcd_bystander_standard = "Вы свидетель убийства, хотя вас это не коснулось, лучше быть осторожным."

l.hl2dm_cmb_name = "UNIT %s"
l.hl2dm_cmb = "Комбайны"
l.hl2dm_cmb_desc = "Уничтожьте любое сопротивление."

l.hl2dm_rebel = "Повстанцы"
l.hl2dm_rebel_desc = "Уничтожьте всех комбайнов!"

l.criresp_suspect = "Подозреваемые"
l.criresp_suspect_desc = "Это мой ёбанный дом, суки, я могу делать все, что захочу."

l.criresp_swat = "Оперативники SWAT"
l.criresp_swat_desc = "Переговоры не удались, устранить цель. 10-4"

l.zs_surv = "Люди"
l.zs_surv_desc = "Выживи."

l.zs_zombie = "Зомби"
l.zs_zombie_desc = "УБЕЙ ВСЕХ"
l.zs_wavein = "Следующая волна через: %s"
l.zs_waveendin = "Волна закончиться через: %s"
l.zs_peopleleft = "Осталось людей: %s"
l.zs_buymenu_open = "Press F2 to open buymenu"

l.coop_endsin = "Карта сменится через: %s"
l.coop_rebel = "Повстанцы"
l.coop_gondon = "Гордон Фримен"
l.coop_gondon_desc = "Управляйте сопротивлением чтобы победить!"
l.coop_cmb = "Альянс"

l.coop_rebel_desc = "За фрименом!"
l.coop_cmb_desc = "Чего блять? Ты че ахуел за комбайнов заходить?"

l.event_maker = "Ивент-мейкер"
l.event_player = "Игрок"

// Скорборд

l.sc_players = "Игроки"
l.sc_invento = "Инвентарь"
l.sc_teams = "Команды"
l.sc_settings = "Настройки"

l.sc_copysteam = "Скопировать STEAMID"
l.sc_openprofile = "Открыть профиль"

l.sc_unable_prof = "Невозможно открыть профиль."
l.sc_unable_steamid = "Невозможно скопировать STEAMID."
l.sc_success_copy = "Успешно скопирован STEAMID (%s)"

l.sc_curround = "Текущий Раунд: %s"
l.sc_nextround = "Следующий Раунд: %s"
l.sc_team = "Команда"
l.sc_ug = "Юзергруп"
l.sc_status = "Статус"
l.sc_tps = "Тикрейт Сервера: %s"
l.sc_mutedead = "Замутить мёртвых"
l.sc_muteall = "Замутить всех"

// Остальное
l.inv_drop = "Выкинуть"
l.inv_roll = "Прокрутить барабан."
l.pulse_normal = "Нормальный пульс."
l.pulse_high = "Высокий пульс."
l.pulse_low = "Низкий пульс."
l.pulse_lowest = "Невозможно нащупать пульс."
l.pulse_no = "No pulse."
l.open_alpha = "ОТКРЫТАЯ АЛЬФА"
l.report_bugs = "ПОЖАЛУЙСТА, СООБЩАЙТЕ БАГИ В НАШ ДИСКОРД СЕРВЕР."
l.youre_hungry = "Ты голоден."
l.need_2_players = "Необходимо 2 игрока чтобы начать."

l.use_door = "Дверь"
l.ent_small_crate = "Малый ящик"
l.ent_medium_crate = "Средний ящик"
l.ent_large_crate = "Большой ящик"
l.ent_melee_crate = "Ящик с холодным оружием"
l.ent_weapon_crate = "Оружейный ящик"
l.ent_grenade_crate = "Ящик с гранатами"
l.ent_explosives_crate = "Ящик со взрывчаткой"
l.ent_medkit_crate = "Медицинский ящик"
l.use_ezammo = "Ящик с патронами"

l.use_time_bomb = "Бомба с таймером"
l.use_fragnade = "Ручная Граната"
l.use_firenade = "Зажигательная Граната"
l.use_sticknade = "Ручная граната с рукояткой"
l.use_dynam = "Динамит"
l.use_smokenade = "Дымовая граната"
l.use_signalnade = "Сигнальная шашка"
l.use_gasnade = "Газовая граната"
l.use_teargasnade = "Слезоточивая граната"
l.use_detpack = "Взрывной заряд"
l.use_buket = "Букет"
l.use_tnt = "Сатчель"
l.use_button = "Кнопка"

l.alive = "Живой"
l.unalive = "Мёртв"
l.unknown = "Неизвестно"
l.spectating = "Наблюдает"
l.spectator = "Наблюдатель"

l.cant_kick = "Ты не можешь пинать потому что твоя нога сломана."
l.leg_hurt = "Твоя нога болит."
l.uncon = "БЕЗ СОЗНАНИЯ"

l.heal = "Подлечить %s"
l.wep_delay = "Задержка: %s"
l.wep_dmg = "Урон: %s"
l.wep_force = "Сила: %s"

l.item_notexist = "Предмет не существует."

l.hasnt_pulse = "У него нет пульса."
l.otrub_but_he_live = "Он лежит в отключке, но он всё ещё жив."
l.has_pulse = "У него есть пульс."

l.r_close = "Нажми R чтобы закрыть."

//Локализация говна
l.ied_plant = "Заложить IED"
l.ied_metalprop = "в металлический проп"

l.weapon_bandage = "Бинт"
l.weapon_medkit_hg = "Аптечка"
l.weapon_painkillers_hg = "Болеутоляющие"
l.weapon_adrenaline = "Адреналин"

l.weapon_beton = "Съедобная арматура"
l.weapon_burger = "Бургер"
l.weapon_water_bottle = "Бутылка воды"
l.weapon_canned_burger = "Консервированный бургер"
l.weapon_milk = "Молоко"
l.weapon_chips = "Pringles"
l.weapon_energy_drink = "Monster Energy"

l.weapon_ied = "Взрывчатка"
l.ied_plant = "Заложить взрывчатку"
l.ied_metalprop = "в металлический проп"
l.weapon_hands = "Руки"

l.weapon_handcuffs = "Стяжки"

l.weapon_pbat = "Полицейская Дубина"
l.weapon_sog = "SOG SEAL 2000"
l.weapon_crowbar_hg = "Монтировка"
l.weapon_fubar = "Фубар"
l.weapon_hammer = "Молоток"
l.weapon_hatchet = "Топорик"
l.weapon_axe = "Топор"
l.weapon_shovel = "Лопата"
l.weapon_melee = "Боевой Нож"

hg.Localizations.ru = l