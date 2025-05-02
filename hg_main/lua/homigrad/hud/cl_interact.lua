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
}

hook.Add("Think","Interact-Glow",function()
    local tr = hg.eyeTrace(ply,100)
    //print(tr.Entity:GetClass())
    if IsValid(tr.Entity) and (tr.Entity:IsWeapon() or shit[tr.Entity:GetClass()]) then
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