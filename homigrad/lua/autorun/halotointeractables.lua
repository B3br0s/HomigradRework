local usableEntities = {
    ["func_button"] = true,
    ["weapon_crate"] = true,
    ["explosive_crate"] = true,
    ["ent_ammo_.45rubber"] = true,
    ["ent_ammo_.44magnum"] = true,
    ["ent_ammo_12/70beanbag"] = true,
    ["ent_ammo_12/70gauge"] = true,
    ["ent_ammo_46×30mm"] = true,
    ["ent_ammo_545×39mm"] = true,
    ["ent_ammo_556x45mm"] = true,
    ["ent_ammo_57×28mm"] = true,
    ["ent_ammo_762x33mm"] = true,
    ["ent_ammo_762x39mm"] = true,
    ["ent_ammo_762x54mm"] = true,
    ["ent_ammo_9x18mmrubber"] = true,
    ["ent_ammo_9x39mm"] = true,
    ["ent_ammo_9х19mm"] = true,
    ["ent_ammo_airsoftballs"] = true,
    ["ent_ammo_tasercartridge"] = true,
    ["melee_crate"] = true
}

local entityNames = {
    ["func_button"] = "Кнопка",
    ["weapon_crate"] = "Оружейный Ящик",
    ["explosive_crate"] = "Ящик Со Взрывчаткой",
    ["ent_ammo_.45rubber"] = "Патроны .45 Резиновые",
    ["ent_ammo_.44magnum"] = "Патроны .44 Магнум",
    ["ent_ammo_12/70beanbag"] = "Патроны 12/70 Фасоль",
    ["ent_ammo_12/70gauge"] = "Патроны 12/70 Дробь",
    ["ent_ammo_46×30mm"] = "Патроны 4.6x30мм",
    ["ent_ammo_545×39mm"] = "Патроны 5.45x39мм",
    ["ent_ammo_556x45mm"] = "Патроны 5.56x45мм",
    ["ent_ammo_57×28mm"] = "Патроны 5.7x28мм",
    ["ent_ammo_762x33mm"] = "Патроны 7.62x33мм",
    ["ent_ammo_762x39mm"] = "Патроны 7.62x39мм",
    ["ent_ammo_762x54mm"] = "Патроны 7.62x54мм",
    ["ent_ammo_9x18mmrubber"] = "Патроны 9x18мм",
    ["ent_ammo_9x39mm"] = "Патроны 9x39мм",
    ["ent_ammo_9х19mm"] = "Патроны 9x19мм",
    ["ent_ammo_airsoftballs"] = "Шары от страйкбола",
    ["ent_ammo_tasercartridge"] = "Заряды Для Электрошокера",
    ["melee_crate"] = "Ящик с холодным оружием"
}

local haloDistance = 113
local fadeSpeed = 5


local textAlpha = 0


local currentEntity = nil


hook.Add("PreDrawHalos", "DrawUsableEntityHalos", function()

    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    

    local trace = ply:GetEyeTrace()
    local hitEntity = trace.Entity


    if IsValid(hitEntity) and usableEntities[hitEntity:GetClass()] and ply:GetPos():DistToSqr(hitEntity:GetPos()) <= (haloDistance * haloDistance) then

        halo.Add({hitEntity}, Color(255, 255, 255), 1, 1, 5, true, true)
    end
end)


hook.Add("HUDPaint", "DrawUsableEntityName", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end


    local trace = ply:GetEyeTrace()
    local hitEntity = trace.Entity

    if IsValid(hitEntity) and entityNames[hitEntity:GetClass()] and ply:GetPos():DistToSqr(hitEntity:GetPos()) <= (haloDistance * haloDistance) then
        currentEntity = hitEntity
        textAlpha = math.Clamp(textAlpha + fadeSpeed * FrameTime() * 255, 0, 255)
    else
        textAlpha = math.Clamp(textAlpha - fadeSpeed * FrameTime() * 255, 0, 255)
    end


    if textAlpha > 0 and currentEntity and IsValid(currentEntity) then

        local entityName = entityNames[currentEntity:GetClass()]


        draw.SimpleText(entityName, "HomigradFont", ScrW() / 2, ScrH() / 2 + 50, Color(255, 255, 255, textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)
