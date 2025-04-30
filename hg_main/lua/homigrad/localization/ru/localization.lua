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

l.hunter_victim = "Цель Охотника"  
l.hunter_victim_desc = "Вы должны выжить. \n Спасайтесь, когда прибудет спецназ."  

l.hunter_swat = "Спецназ"  
l.hunter_swat_desc = "Вы должны нейтрализовать Охотника. \n Помогите выжившим сбежать."  

l.hunter_hunter = "Охотник"  
l.hunter_hunter_desc = "Ваша задача – убить всех до прибытия спецназа."

l.hunter_hunter = "Hunter"
l.hunter_hunter_desc = "Ваша задача убить всех до приезда "

l.dr_runner = "Бегун"
l.dr_runner_desc = "Вам нужно завершить карту и убить \"Убийцу\""

l.dr_killer = "Убийца"
l.dr_killer_desc = "Ваша задача убить всех используя ловушки на карте"

l.jb_prisoner = "Заключенный"
l.jb_prisoner_desc = "Вам нужно убить надзирателя | сбежать из тюрьмы."

l.jb_warden = "Надзиратель"
l.jb_warden_desc = "Ваша задача закончить вашу смену. \n Не дайте заключенный сбежать | убить вас."

l.tdm_red = "Красные"  
l.tdm_red_desc = "Уничтожьте противоположную команду"  

l.tdm_blue = "Синие"  
l.tdm_blue_desc = "Уничтожьте противоположную команду"  

l.riot_red = "Бунтовщики"  
l.riot_red_desc = "Отстаивайте свои права! Уничтожьте всех, кто встанет у вас на пути!"  

l.riot_blue = "Полиция"  
l.riot_blue_desc = "Нейтрализуйте бунтовщиков, старайтесь не убивать их"  

l.hmcd_bystander = "Невиновный"  
l.hmcd_bystander_desc = "Вы невиновны, полагайтесь только на себя, но держитесь в толпе, чтобы усложнить задачу предателю."  

l.hmcd_gunman = "Вооружённый"  
l.hmcd_gunman_desc = "Вы невиновны, полагайтесь только на себя, но держитесь в толпе, чтобы усложнить задачу предателю."  

l.hmcd_traitor = "Предатель"  
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

// Остальное
l.open_alpha = "ОТКРЫТАЯ АЛЬФА"
l.report_bugs = "ПОЖАЛУЙСТА, СООБЩАЙТЕ БАГИ В НАШ ДИСКОРД СЕРВЕР."
l.youre_hungry = "Ты голоден."
l.need_2_players = "Необходимо 2 игрока чтобы начать."

l.alive = "Живой"
l.unalive = "Мёртв"
l.unknown = "Неизвестно"
l.spectating = "Наблюдает"
l.spectator = "Наблюдатель"

hg.Localizations.ru = l