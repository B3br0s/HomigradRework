hmcd = hmcd or {}

local sound_played = false

hmcd.StartSounds = {
    ["standard"] = {"snd_jack_hmcd_psycho.mp3","snd_jack_hmcd_shining.mp3"},
	["soe"] = "snd_jack_hmcd_disaster.mp3",
	["gfz"] = "snd_jack_hmcd_panic.mp3" ,
}

function hmcd.GetTeamName(ply)
    if !ply then
        ply = LocalPlayer()
    end
    if !hmcd.Type then
        hmcd.Type = "soe"
    end
    if ply.IsTraitor then
        return "hmcd_traitor",Color(230,0,0),hg.GetPhrase("hmcd_traitor_"..hmcd.Type)
    elseif ply.IsGunman then
        return "hmcd_gunman",Color(132,0,255),hg.GetPhrase("hmcd_gunman_"..hmcd.Type)
    else
        return "hmcd_bystander",Color(0,153,255),hg.GetPhrase("hmcd_bystander_"..hmcd.Type)
    end
end

function hmcd.HUDPaint()
    if !hg.ROUND_START then
        hg.ROUND_START = CurTime()
    end

    local StartTime = ((hg.ROUND_START + 7) - CurTime())

    if StartTime < 0 then
        return
    end

    if !sound_played then
        sound_played = true
        local shit = hmcd.StartSounds[hmcd.Type]
        surface.PlaySound(istable(shit) and table.Random(shit) or shit)
    end

    local DarkMul = math.Clamp(StartTime,0,1)

    local Name,color,Desc = hmcd.GetTeamName()

    color.a = (255 * DarkMul)

    local PrintName = hg.GetPhrase(Name)

    local w,h = ScrW(),ScrH()

    surface.SetDrawColor(0,0,0,220 * DarkMul)
    surface.DrawRect(0,0,w,h)

    draw.DrawText(string.format(hg.GetPhrase("you_are"),PrintName),"H.25",w / 2,h / 2,color,TEXT_ALIGN_CENTER)
    draw.DrawText(hmcd.name .. " | ".. hg.GetPhrase("hmcd_"..hmcd.Type),"H.45",w / 2,h / 8,Color(0,140,255,255 * DarkMul),TEXT_ALIGN_CENTER)
    draw.DrawText(hg.GetPhrase(Desc),"H.25",w / 2,h / 1.2,color,TEXT_ALIGN_CENTER)
end

function hmcd.RenderScreenspaceEffects()

end

function hmcd.RoundStart()
    hg.ROUND_START = CurTime()
    sound_played = false
end

net.Receive("hmcd_start",function()
    hmcd.Type = net.ReadString()
    local ist = net.ReadBool()
    local isg = net.ReadBool()

    LocalPlayer().IsTraitor = ist
    LocalPlayer().IsGunman = isg
end)