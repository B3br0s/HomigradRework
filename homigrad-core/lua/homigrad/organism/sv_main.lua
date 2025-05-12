hook.Add("Player Think","Main_Handler",function(ply)
    ply:SetNWFloat("hunger",ply.hunger)
    ply:SetNWFloat("stamina",ply.stamina)
    ply:SetNWFloat("adrenaline",ply.adrenaline)
    ply:SetNWFloat("pulse",ply.pulse)
    ply:SetNWFloat("pain",ply.pain)
    ply:SetNWFloat("painlosing",ply.painlosing)
    ply:SetNWBool("otrub",ply.otrub)
    ply:SetNWBool("bleeding",ply.bleeding)
    ply:SetNWBool("blood",ply.blood)
    ply:SetNWString("ClassName",ply.PlayerClassName or "")

    ply:SetNWBool("MistrGondon",ply.isGordon or false)
    ply:SetNWBool("IsCombine",ply.isCombine or false)
    ply:SetNWBool("IsCombineSuper",ply.isCombineSuper or false)
    ply:SetNWFloat("rleg",ply.rleg)
    ply:SetNWFloat("lleg",ply.lleg)

    ply:SetNWFloat("rarm",ply.rarm)
    ply:SetNWFloat("larm",ply.larm)

    if istable(ply.JModEntInv) then
        ply.JModEntInv = NULL
    end

    ply:SetNWEntity("JModEntInv",ply.JModEntInv)

    if !ply:HasWeapon("weapon_hands") then
        ply:Give("weapon_hands")
    end
end)

hook.Add("OnPlayerJump","Homigrad_Move",function(ply)
	if !ply:Alive() then
        return
    end

    if ply.Fake then
        return 
    end

    if TableRound and ROUND_NAME == "dr" then
        return
    end

    ply.stamina = ply.stamina - math.random(3,6)
end)

hook.Add("PlayerSpawn","Homigrad_Main_Handle",function(ply)
    if !ply.PLYSPAWN_OVERRIDE then
        
        ply:SetNWBool("Cuffed",false)
        
        if ply:Team() == 1002 then
            ply.AppearanceOverride = true
        
            timer.Simple(0,function()
                ply:SetModel("models/player/gman_high.mdl")
                ply:SetPlayerColor(Color(100,100,100):ToVector())
            end)
        end
    
        ply:LagCompensation(true)
    
	    ply.painNext = 0
        ply.bloodNext = 0
        ply.hungerNext = 0
        ply.adrenaNext = 0
        ply.hunger = 100
        ply.PlayerClassName = nil
        ply.lerp_rh = 0
	    ply.lerp_lh = 0
	    ply.larm = 1
	    ply.rarm = 1
        ply.lleg = 1
	    ply.rleg = 1
	    ply.painlosing = 1
	    ply.pain = 0
	    ply.pulse = 80
	    ply.pulseadd = 0
	    ply.blood = 5000
	    ply.bleed = 0
	    ply.adrenaline = 0
	    ply.removespeed = 0
	    ply.stamina = 100
	    ply.otrub = false
	    ply.suiciding = false
	    ply:SetNWBool("suiciding",false)
	    ply.CanMove = true
        ply.JModEntInv = NULL
        ply:SetNWEntity("JModEntInv",ply.JModEntInv)
    
        hg.Gibbed[ply] = nil
    
        if TableRound and TableRound().SpawnPlayerHook and ply:Team() != 1002 then
            if hg.LastRoundTime < CurTime() then
                timer.Simple(0,function()
                    TableRound().SpawnPlayerHook(ply)
                end)
            end
        end

        ply.isGordon = false
        ply.isCombine = false
        ply.isCombineSuper = false
    
        ply:LagCompensation(false)
    end
end)

hook.Add("PlayerInitialSpawn","Homigrad_shit",function(ply)
    ply:SetTeam(1)
end)

hook.Add("Player Think","Pulse-Holder",function(ply,time)
    if !ply:Alive() then ply.PLYSPAWN_OVERRIDE = false return end
    ply.pulse = (math.min(395800 / ply.blood,150) + math.min(500 / ply.stamina,5000) + (math.random(-1,1) / 5) + (ply.pain / 128) + ply.pulseadd / 2.5) * (math.Clamp((ply:Health() / ply:GetMaxHealth()),0.5,1))

    //print(ply.pulse)

    if ply.pulse > 160 then
        ply.pain = ply.pain + 0.05
    end
end)