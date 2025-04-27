local propModels = {
    "models/props_c17/FurnitureDrawer003a.mdl",
    "models/props_c17/FurnitureDresser001a.mdl",
    "models/props_c17/FurnitureDrawer002a.mdl",
    "models/props_interiors/Furniture_Desk01a.mdl",
    "models/props_interiors/Furniture_Vanity01a.mdl",
    "models/props_junk/wood_crate001a.mdl",
    "models/props_junk/wood_crate001a_damaged.mdl",
    "models/props_junk/wood_crate002a.mdl",
    "models/props_junk/cardboard_box001a.mdl",
    "models/props_junk/cardboard_box001b.mdl",
    "models/props_junk/cardboard_box002a.mdl",
    "models/props_junk/cardboard_box002b.mdl",
    "models/props_junk/cardboard_box003a.mdl",
    "models/props_junk/cardboard_box003b.mdl",
    "models/props_junk/cardboard_box004a.mdl",
    "models/props_junk/TrashDumpster01a.mdl",
    "models/props_lab/filecabinet02.mdl",
    "models/props_wasteland/controlroom_filecabinet001a.mdl",
    "models/props_wasteland/controlroom_filecabinet002a.mdl",
    "models/props_wasteland/controlroom_storagecloset001a.mdl",
    "models/props_wasteland/controlroom_storagecloset001b.mdl",
    "models/props_wasteland/kitchen_stove001a.mdl",
    "models/props_c17/oildrum001_explosive.mdl",
    "models/props_c17/oildrum001_explosive.mdl",
    "models/props_c17/oildrum001_explosive.mdl",
    "models/props_c17/oildrum001_explosive.mdl",
    "models/props_c17/oildrum001_explosive.mdl",
    "models/props_c17/Lockers001a.mdl",
    "models/props_lab/box01a.mdl",
    "models/props_c17/FurnitureCupboard001a.mdl",
    "models/props_c17/FurnitureDrawer001a.mdl",
    "models/props_c17/furnitureStove001a.mdl",
    "models/props_lab/dogobject_wood_crate001a_damagedmax.mdl",
    "models/props_lab/partsbin01.mdl",
    "models/props/cs_assault/dryer_box.mdl",
    "models/props/cs_militia/dryer.mdl",
    "models/props/cs_militia/footlocker01_closed.mdl",
    "models/props/cs_assault/washer_box2.mdl",
    "models/props_wasteland/controlroom_desk001b.mdl",
    "models/props/cs_office/Cardboard_box01.mdl",
    "models/props/cs_office/Cardboard_box03.mdl",
    "models/props/cs_office/Cardboard_box02.mdl",
    "models/props/cs_office/file_cabinet1.mdl",
    "models/props/cs_office/file_cabinet1_group.mdl",
    "models/props/cs_office/file_box.mdl",
    "models/props_wasteland/kitchen_stove002a.mdl",
    "models/props_borealis/bluebarrel001.mdl",
    "models/Items/item_item_crate.mdl",
    "models/props/cs_militia/footlocker01_closed.mdl",
    "models/props/de_nuke/crate_small.mdl",
    "models/props/de_nuke/crate_extrasmall.mdl", 
    "models/props/de_nuke/file_cabinet1_group.mdl",
    "models/props/cs_office/Shelves_metal1.mdl",
    "models/props/cs_office/Shelves_metal2.mdl",
    "models/props/cs_office/Shelves_metal3.mdl",
    "models/props/cs_office/trash_can.mdl"
}

local validPropModels = {}
for _, model in ipairs(propModels) do
    validPropModels[model] = true
end

local spawnPoints = {}

for _, entity in ipairs(ents.FindByClass("info_*")) do
    table.insert(spawnPoints, entity:GetPos())
end

hook.Add("PostCleanupMap", "addBoxes", function()
    spawnPoints = {}
    for _, entity in ipairs(ents.FindByClass("info_*")) do
        table.insert(spawnPoints, entity:GetPos())
    end
end)

hg = hg or {}

hg.Lastbox = 0

hook.Add("Think","Boxes-Main",function()
    if hg.Lastbox < CurTime() then
        hg.Lastbox = CurTime() + math.random(15,30)
        --hook.Run("BoxesThink")
    end
end)
local spawnOffset = Vector(0, 0, 32)
hook.Add("BoxesThink", "SpawnBoxes", function()
    if TableRound() and TableRound().ShouldSpawnItems then
        if !TableRound().ShouldSpawnItems then
            return
        end
    end

    local entity = ents.Create("prop_physics")

    entity:SetModel(propModels[math.random(#propModels)])

    if IsValid(entity) then
        entity:SetPos(spawnPoints[math.random(#spawnPoints)] + spawnOffset)
        entity:Spawn()
        entity.IsSpawned = true
    end
end)