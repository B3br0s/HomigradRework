local LatestShow = 0
local LatestEntity
local ply = LocalPlayer()

local shit = {
    ["prop_door_rotating"] = "use_door",
    ["func_door_rotating"] = "use_door",
    ["func_door"] = "use_door",
    ["class C_BaseEntity"] = "use_button",
    ["class C_BaseToggle"] = "use_button",
    ["ent_small_crate"] = "ent_small_crate",
    ["ent_medium_crate"] = "ent_medium_crate",
    ["ent_large_crate"] = "ent_large_crate",
    ["ent_medkit_crate"] = "ent_medkit_crate",
    ["ent_grenade_crate"] = "ent_grenade_crate",
    ["ent_explosives_crate"] = "ent_explosives_crate",
    ["ent_weapon_crate"] = "ent_weapon_crate",
    ["ent_melee_crate"] = "ent_melee_crate",
    ["ent_jack_gmod_ezdetpack"] = "use_detpack",
	["ent_jack_gmod_ezsticknadebundle"] = "use_buket",
	["ent_jack_gmod_eztnt"] = "use_tnt",
	["ent_jack_gmod_eztimebomb"] = "use_time_bomb",
	["ent_jack_gmod_ezfragnade"] = "use_fragnade",
	["ent_jack_gmod_ezfirenade"] = "use_firenade",
	["ent_jack_gmod_ezsticknade"] = "use_sticknade",
	["ent_jack_gmod_ezdynamite"] = "use_dynam",
    ["ent_jack_gmod_ezsmokenade"] = "use_smokenade",
	["ent_jack_gmod_ezsignalnade"] = "use_signalnade",
	["ent_jack_gmod_ezgasnade"] = "use_gasnade",
	["ent_jack_gmod_ezcsnade"] = "use_teargasnade",
    ["ent_jack_gmod_ezammo"] = "use_ezammo",
}

local bases = {
    ["armor_base"] = true,
    ["ammo_base"] = true
}

hook.Add("Think","Interact-Glow",function()
    local ply = LocalPlayer()
    if !ply:Alive() then
        return
    end
    local tr = hg.eyeTrace(ply,100)
    //print(tr.Entity:GetClass())
    if IsValid(tr.Entity) and (tr.Entity:IsWeapon() or shit[tr.Entity:GetClass()]) and !tr.Entity:GetNoDraw() or IsValid(tr.Entity) and scripted_ents.Get(tr.Entity:GetClass()) and scripted_ents.Get(tr.Entity:GetClass()).Base and bases[scripted_ents.Get(tr.Entity:GetClass()).Base] then
        LatestShow = LerpFT(0.25,LatestShow,1)
        LatestEntity = tr.Entity
    else
        LatestShow = LerpFT(0.25,LatestShow,0)
    end
    if LatestShow > 0.05 then
        halo.Add({LatestEntity},Color(255,255,255,255 * LatestShow),1,1,5)
    else
        LatestEntity = NULL
    end
end)

hook.Add("HUDPaint","Interact-Shit",function()
    local ply = LocalPlayer()
    if !ply:Alive() then
        return
    end
    if IsValid(LatestEntity) then
        local printt = (LatestEntity:IsWeapon() and LatestEntity:GetPrintName() or hg.GetPhrase(shit[LatestEntity:GetClass()])) or (hg.GetPhrase(LatestEntity:GetClass()) != LatestEntity:GetClass() and hg.GetPhrase(LatestEntity:GetClass())) or LatestEntity.PrintName
        draw.SimpleText((printt != nil and printt or LatestEntity.PrintName),"HS.18",ScrW()/2,ScrH()/1.85 - 10 * (1 - LatestShow),Color(255,255,255,255 * LatestShow),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end)