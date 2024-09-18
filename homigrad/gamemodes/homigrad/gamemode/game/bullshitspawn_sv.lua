-- Define the entity list for spawning
local ENTITY_LIST = {
    "explosive_crate",
    "weapon_crate"
}

local spawns = {}

-- Populate spawn positions from entities with class "info_*"
for _, ent in pairs(ents.FindByClass("info_*")) do
    table.insert(spawns, ent:GetPos())
end

local hook_Run = hook.Run

hook.Add("PostCleanupMap", "addboxes", function()
    spawns = {}
    for _, ent in pairs(ents.FindByClass("info_*")) do
        table.insert(spawns, ent:GetPos())
    end

    if timer.Exists("SpawnTheBoxes") then 
        timer.Remove("SpawnTheBoxes") 
    end

    timer.Create("SpawnTheBoxes", 35, 0, function()
        hook_Run("Boxes Think")
    end)
end)

if timer.Exists("SpawnTheBoxes") then 
    timer.Remove("SpawnTheBoxes") 
end

timer.Create("SpawnTheBoxes", 35, 0, function()
    hook_Run("Boxes Think")
end)

local vec = Vector(0, 0, 32)

hook.Add("Boxes Think", "SpawnEntities", function()
    if #player.GetAll() == 0 or not roundActive then return end

    local func = TableRound().ShouldSpawnLoot
    if func and func() == false then return end

    
    -- Choose to spawn either a weapon crate or an explosive crate based on loot chance
    local entName = ENTITY_LIST[math.random(1,#ENTITY_LIST)]
    
    -- Create the entity
    local ent = ents.Create(entName)

    if IsValid(ent) then
		print("Crate Spawned,Crate Type Is: "..entName)
        ent:SetPos(spawns[math.random(#spawns)] + vec)
        ent:Spawn()
        ent:Activate() -- Activate the entity if needed
    end
end)	