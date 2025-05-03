local LatestShow = 0
local LatestEntity
local ply = LocalPlayer()

local shit = {
    ["prop_door_rotating"] = "use_door",
    ["func_door_rotating"] = "use_door",
    ["func_door"] = "use_door",
    ["class C_BaseEntity"] = "use_button",
    ["class C_BaseToggle"] = "use_button",
    ["ent_small_crate"] = "use_crate_small",
    ["ent_medium_crate"] = "use_crate_medium",
    ["ent_large_crate"] = "use_crate_large",
    ["ent_medkit_crate"] = "use_crate_medkit",
    ["ent_grenade_crate"] = "use_crate_grenade",
    ["ent_weapon_crate"] = "use_crate_weapon",
    ["ent_melee_crate"] = "use_crate_melee",
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
}

hook.Add("Think","Interact-Glow",function()
    local tr = hg.eyeTrace(ply,100)
    //print(tr.Entity:GetClass())
    if IsValid(tr.Entity) and (tr.Entity:IsWeapon() or shit[tr.Entity:GetClass()]) and !tr.Entity:GetNoDraw() then
        LatestShow = LerpFT(0.25,LatestShow,1)
        LatestEntity = tr.Entity
    else
        LatestShow = LerpFT(0.5,LatestShow,0)
    end
    if LatestShow > 0.05 then
        halo.Add({LatestEntity},Color(255,255,255,255 * LatestShow),1,1,5)
    else
        LatestEntity = NULL
    end
end)

hook.Add("HUDPaint","Interact-Shit",function()
    if IsValid(LatestEntity) then
        draw.SimpleText((LatestEntity:IsWeapon() and LatestEntity:GetPrintName() or hg.GetPhrase(shit[LatestEntity:GetClass()])),"HS.18",ScrW()/2,ScrH()/1.85 - 10 * (1 - LatestShow),Color(255,255,255,255 * LatestShow),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end)