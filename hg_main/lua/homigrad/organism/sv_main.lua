hook.Add("Player Think","Main_Handler",function(ply)
    ply:SetNWFloat("hunger",ply.hunger)
    ply:SetNWFloat("adrenaline",ply.adrenaline)
    ply:SetNWFloat("pulse",ply.pulse)
    ply:SetNWFloat("pain",ply.pain)
    ply:SetNWFloat("painlosing",ply.painlosing)
    ply:SetNWBool("otrub",ply.otrub)
    ply:SetNWBool("bleeding",ply.bleeding)
    ply:SetNWBool("blood",ply.blood)

    ply:SetNWFloat("rleg",ply.rleg)
    ply:SetNWFloat("lleg",ply.lleg)

    ply:SetNWFloat("rarm",ply.rarm)
    ply:SetNWFloat("larm",ply.larm)

    if !ply:HasWeapon("weapon_hands") then
        ply:Give("weapon_hands")
    end
end)

hook.Add("PlayerSpawn","Homigrad_Main_Handle",function(ply)
    if ply.PLYSPAWN_OVERRIDE then
        return
    end

    ply:SetNWBool("Cuffed",false)

    if ply:Team() == 1002 then
        ply.AppearanceOverride = true

        timer.Simple(0,function()
            ply:SetModel("models/player/gman_high.mdl")
            ply:SetPlayerColor(Color(100,100,100):ToVector())
        end)
    end

	ply.painNext = 0
    ply.bloodNext = 0
    ply.hungerNext = 0
    ply.adrenaNext = 0
    ply.hunger = 100
    ply.lerp_rh = 0
	ply.lerp_lh = 0
	ply.larm = 1
	ply.rarm = 1
    ply.lleg = 1
	ply.rleg = 1
	ply.painlosing = 1
	ply.pain = 0
	ply.pulse = 80
	ply.blood = 5000
	ply.bleed = 0
	ply.adrenaline = 0
	ply.removespeed = 0
	ply.stamina = 100
	ply.otrub = false
	ply.suiciding = false
	ply:SetNWBool("suiciding",false)
	ply.CanMove = true

    hg.Gibbed[ply] = nil
end)

hook.Add("PlayerInitialSpawn","Homigrad_shit",function(ply)
    ply:SetTeam(1)
end)   