hg = hg or {}

hg.Lastbox = 0

hg.boxes = hg.boxes or {}

hook.Add("CheckPoints","Boxes_Shit",function()
    local points = ReadDataMap("box_spawn")
    local points_final = {}

    if #points <= 0 then
        for _, entity in ipairs(ents.FindByClass("info_*")) do
            table.insert(points_final, entity:GetPos())
        end
    else
        for _, point in ipairs(points) do
            table.insert(points_final, point[1])
        end
    end

    return points_final
end)

hook.Add("Think","Boxes-Main",function()
    if hg.Lastbox < CurTime() then
        hg.Lastbox = CurTime() + math.random(15,35)
        hook.Run("BoxesThink")
    end
end)
local spawnOffset = Vector(0, 0, 32)
hook.Add("BoxesThink", "SpawnBoxes", function()
    if TableRound() and TableRound().ShouldSpawnItems then
        if !TableRound().ShouldSpawnItems then
            return
        end
    end

    local points = hook.Run("CheckPoints")

    local drop_chance = math.random(-10,95)

    local cur_box

    if drop_chance <= 5 then
        cur_box = "ent_grenade_crate"
    elseif drop_chance <= 8 then
        cur_box = "ent_medkit_crate"
    elseif drop_chance <= 10 then
        cur_box = "ent_large_crate"
    elseif drop_chance <= 25 then
        cur_box = "ent_medkit_crate"
    elseif drop_chance <= 30 then
        cur_box = "ent_medium_crate"
    elseif drop_chance <= 50 then
        cur_box = "ent_melee_crate"
    elseif drop_chance <= 80 then
        cur_box = "ent_small_crate"
    else
        cur_box = "ent_small_crate"
    end

    //print(cur_box)
    //print(drop_chance)

    local point_shit = table.Random(points)

    for _, ent in ipairs(ents.FindInSphere(point_shit,200)) do
        if ent.IsCrate then
            hg.Lastbox = 0
            return
        end
    end

    local ent = ents.Create(cur_box)
    ent:SetPos(point_shit)
    ent:Spawn()

    /*for name, tbl in pairs(hg.boxes) do
        if drop_chance < 90 then
            
        end
    end*/
end)