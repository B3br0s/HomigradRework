table.insert(ROUND_LIST,"homicide")

homicide = {} or homicide

homicide.Name = "Homicide"

homicide.NoGuilt = false

homicide.red = {
    Color(25,171,255),
    main_weapons = {""}
}

if CLIENT then
    function homicide.RoleGetName()
    	if LocalPlayer().RoleT then
    		return "Предатель",Color(200,0,10)
    	else
    		return "Невиновный",Color(75,75,255)
    	end
    end
end

function homicide.CheckRoundEndCondition()
    if SERVER then
        local CTAlive = 0
        local TAlive = 0
        for _, ply in ipairs(player.GetAll()) do
            if ply:Team() != 1002 and ply:Team() != 1 then
                ply:SetTeam(1)
            end
            if ply:Alive() and !ply.RoleT then
                CTAlive = CTAlive + 1
            elseif ply:Alive() and ply.RoleT then
                TAlive = TAlive + 1
            end
        end

        if CTAlive == 0 and not ROUND_ENDED then
            ROUND_ENDED = true
            homicide.EndRound(1)
            timer.Simple(10,function()
            ROUND_ACTIVE = false
            end)
        end

        if TAlive == 0 and not ROUND_ENDED then
            ROUND_ENDED = true
            homicide.EndRound(2)
            timer.Simple(10,function()
            ROUND_ACTIVE = false
            end)
        end

        if not ROUND_ACTIVE then
            ROUND_ACTIVE = true
            StartRound()
        end
    end
end

function homicide.StartRound()
	StartTime = CurTime()
    if SERVER then
    game.CleanUpMap(false)
    ROUND_ENDED = false
    homicide.TRAITOR = nil
    homicide.GUNMAN = nil
    for _, ply in ipairs(player.GetAll()) do
        ply:KillSilent()
    end
    for _, ply in ipairs(player.GetAll()) do
        ply:Spawn()
        ply.RoleT = false
        ply.RoleCT = false
    end

    homicide.SetTraitor()
    homicide.SetGunMan()
    if ROUND_STATE == ROUND_STATE_WAITING then
        ROUND_STATE = ROUND_STATE_ACTIVE
        StartTime = CurTime()
        SetRoundTimer()
    end
    for _, ply in ipairs(player.GetAll()) do
        if ply.RoleT or ply.RoleCT then continue end
        net.Start("hmcd_role")
        net.WriteFloat(0)
        net.Send(ply)
    end
    homicide.StartRoundSV()
    end
    if SERVER then return end
    homicide.StartRoundCL()
    PlaySound = false
end

if SERVER then return end

homicide.RoleObjective = {
    [0] = "Найдите предателя, свяжите или убейте его для победы. Не доверяйте никому...",
    [1] = "Ваша задача убить всех до прибытия полиции",
    [2] = "У вас есть скрытое огнестрельное оружие, постарайтесь нейтрализовать предателя"
}

net.Receive("hmcd_role",function()
	local role = net.ReadFloat()

	if role == 1 then
		LocalPlayer().RoleT = true
		LocalPlayer().RoleCT = false
	elseif role == 2 then
		LocalPlayer().RoleCT = true
		LocalPlayer().RoleT = false
    elseif role == 3 then
		LocalPlayer().RoleCT = false
		LocalPlayer().RoleT = true
	else
		LocalPlayer().RoleCT = false
		LocalPlayer().RoleT = false
	end
end)

homicide.TypeSounds = {
	["standard"] = "snd_jack_hmcd_shining.mp3",--Ну какой дебил по названию не поймет???
	["soe"] = "snd_jack_hmcd_disaster.mp3",--State Of Emergency
	["gfz"] = "snd_jack_hmcd_panic.mp3" ,--Gun Free Zone
	["ww"] = "snd_jack_hmcd_wildwest.mp3" --Wild West
}

function homicide.StartRoundCL()
    StartTime = CurTime()
end

function homicide.HUDPaint()
	if not StartTime then
		StartTime = CurTime()
	end
    if not PlaySound then
        PlaySound = true
        --surface.PlaySound(homicide.TypeSounds[homicide.Type])
    end
	local lply = LocalPlayer()
    local round_startidk = StartTime + 7 - CurTime()
	if lply:Team() == 1002 then return end
	if StartTime + 7 < CurTime() then return end

    local h,w = ScrH(),ScrW()

    local name,color = homicide.RoleGetName()

	draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(0,0,0,math.Clamp(round_startidk - 0.5,0,1) * 230))

    draw.SimpleText("Вы " .. name,"H.25",w / 2,h / 2,Color(color.r,color.g,color.b,math.Clamp(round_startidk - 0.5,0,1) * 255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

    draw.SimpleText(homicide.RoleObjective[(lply.RoleT and 1 or lply.RoleCT and 2 or 0)],"H.25",w / 2,h / 1.2,Color(color.r,color.g,color.b,math.Clamp(round_startidk - 0.5,0,1) * 255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end