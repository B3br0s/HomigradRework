KOROBKA_HUYNYI = {
	"models/props_c17/FurnitureDrawer002a.mdl",
    "models/props_c17/FurnitureDrawer003a.mdl",
    "models/props_c17/FurnitureShelf001a.mdl",
    "models/props_interiors/Furniture_shelf01a.mdl",
    "models/props_interiors/Furniture_Desk01a.mdl",
    "models/props_junk/cardboard_box001a.mdl",
	"models/props_junk/cardboard_box001b.mdl",
	"models/props_junk/cardboard_box002a.mdl",
	"models/props_junk/cardboard_box002b.mdl",
	"models/props_junk/cardboard_box003a.mdl",
	"models/props_junk/cardboard_box003b.mdl",
	"models/props_junk/cardboard_box004a.mdl",
	"models/props_junk/wood_crate001a.mdl",
	"models/props_junk/wood_crate001a_damaged.mdl",
	"models/props_junk/wood_crate001a_damagedmax.mdl",
	"models/props_c17/furnituredrawer001a.mdl",
	"models/props_c17/shelfunit01a.mdl",
	"models/props_c17/FurnitureDrawer001a_Chunk01.mdl",
	"models/props_c17/FurnitureDrawer001a_Chunk02.mdl",
	"models/props_docks/channelmarker_gib01.mdl",
	"models/props_c17/furnituredrawer003a.mdl",
	"models/props_c17/FurnitureTable001a.mdl",
	"models/props_c17/furnituredresser001a.mdl",
	"models/props_c17/Frame002a.mdl",
	"models/props_c17/playground_swingset_seat01a.mdl",
	"models/props_c17/playground_teetertoter_seat.mdl",
	"models/props_c17/woodbarrel001.mdl",
	"models/nova/chair_wood01.mdl",
	"models/props/cs_office/computer_caseB.mdl",
	"models/props/cs_office/computer_keyboard.mdl",
	"models/props/cs_office/computer_monitor.mdl",
	"models/props/cs_office/plant01.mdl",
	"models/props/cs_office/Table_coffee.mdl",
	"models/props_lab/dogobject_wood_crate001a_damagedmax.mdl",
	"models/items/item_item_crate.mdl",
	"models/props/de_inferno/claypot02.mdl",
	"models/props_interiors/Furniture_shelf01a.mdl",
	"models/props/de_inferno/claypot01.mdl",
	"models/props_c17/FurnitureTable002a.mdl",
	"models/props_c17/FurnitureTable003a.mdl",
	"models/props_wasteland/barricade001a.mdl",
	"models/props_wasteland/cafeteria_table001a.mdl",
	"models/props_wasteland/prison_shelf002a.mdl",
	"models/props_wasteland/dockplank01b.mdl",
	"models/props_wasteland/barricade002a.mdl",
	"models/props_junk/terracotta01.mdl",
	"models/props_junk/wood_crate002a.mdl",
	"models/props_junk/wood_crate001a_damagedmax.mdl",
	"models/props_combine/breenbust.mdl",
	"models/props_interiors/Furniture_chair01a.mdl",
	"models/props_c17/FurnitureShelf001a.mdl",
	"models/props_c17/FurnitureShelf001b.mdl",
	"models/props_junk/cardboard_box004a.mdl",
	"models/props_junk/wood_pallet001a.mdl",
	"models/props_junk/gascan001a.mdl",
	"models/props_wasteland/cafeteria_bench001a.mdl",
	"models/props_c17/furnituredrawer002a.mdl",
	"models/props_interiors/furniture_cabinetdrawer02a.mdl",
	"models/props_c17/furniturecupboard001a.mdl",
	"models/props_interiors/furniture_desk01a.mdl",
	"models/props_c17/bench01a.mdl",
	"models/props_interiors/furniture_vanity01a.mdl"
}

local newTbl = {}
for i, mdl in pairs(KOROBKA_HUYNYI) do newTbl[mdl] = true end

weaponscommon = { "weapon_binokle", "weapon_molotok", "ent_drop_flashlight", "weapon_knife", "weapon_pipe", "med_band_small", "med_band_big", "blood_bag" }
weaponsuncommon = { "weapon_glock18", "weapon_per4ik", "weapon_hg_crowbar", "weapon_hg_fubar", "weapon_bat", "weapon_hg_metalbat", "weapon_hg_hatchet", "*ammo*", "ent_jack_gmod_ezarmor_respirator", "ent_jack_gmod_ezarmor_lhead", "medkit" }
weaponsrare = { "weapon_beretta", "weapon_remington870", "weapon_glock", "weapon_t", "weapon_hg_molotov", "*ammo*", "weapon_hg_sleagehammer", "weapon_hg_fireaxe", "ent_jack_gmod_ezarmor_gasmask", "ent_jack_gmod_ezarmor_mltorso" }
weaponsveryrare = { "weapon_m3super", "ent_jack_gmod_ezarmor_mtorso", "ent_jack_gmod_ezarmor_mhead" }
weaponslegendary = { "weapon_xm1014", "weapon_ar15", "weapon_civil_famas" }

local sndsDrop = {
	common = "homigrad/vgui/item_drop1_common.wav",
	uncommon = "homigrad/vgui/item_drop2_uncommon.wav",
	rare = "homigrad/vgui/item_drop3_rare.wav",
	veryrare = "homigrad/vgui/item_drop4_mythical.wav",
	legend = "homigrad/vgui/item_drop6_ancient.wav"
}

local ammos = {
	"ent_ammo_.44magnum",
	"ent_ammo_12/70gauge",
	"ent_ammo_762x39mm",
	"ent_ammo_556x45mm",
	"ent_ammo_9х19mm"
}

local spawns = {}

local crateTypes = { 
"base_crate", 
"base_crate",
"base_crate",
"base_crate",
"base_crate",
"ent_drop_flashlight",
"ent_jack_gmod_ezarmor_balmask",
"ent_jack_gmod_ezarmor_mltorso",
"ent_jack_gmod_ezarmor_headset"
}

local function PopulateSpawns()
	spawns = {}
	if ReadDataMap("boxspawn") then
		table.insert(spawns, ReadDataMap("boxspawn")[math.random(1,#ReadDataMap("boxspawn"))][1])
	else
		for _, ent in pairs(ents.FindByClass("info_*")) do
			table.insert(spawns, ent:GetPos())
		end
	end
end

hook.Add("PostCleanupMap", "addboxs", function()
	PopulateSpawns()
	
	if timer.Exists("SpawnTheBoxes") then
		timer.Remove("SpawnTheBoxes")
	end

	timer.Create("SpawnTheBoxes", 15, 0, function()
		hook.Run("Boxes Think")
	end)
end)

PopulateSpawns()

local function randomLoot()
	local gunchance = math.random(1, 100)
	local entName = false
	
	if gunchance < 2 then
		entName = table.Random(weaponslegendary)
	elseif gunchance < 5 then
		entName = table.Random(weaponsveryrare)
	elseif gunchance < 15 then
		entName = table.Random(weaponsrare)
	elseif gunchance < 35 then
		entName = table.Random(weaponsuncommon)
	elseif gunchance < 55 then
		entName = table.Random(weaponscommon)
	end

	local func = TableRound().ShouldSpawnLoot
	local shouldSpawn, entNamer = false, nil
	if func then
		shouldSpawn, entNamer = func()
	end

	return shouldSpawn and entNamer or entName
end

hook.Add("Boxes Think", "SpawnBoxes", function()

	if #player.GetAll() == 0 or not roundActive then return end

	local randomWep = randomLoot()
	local entName = randomWep or "prop_physics"

	if math.random(1, 100) <= 50 then
		entName = table.Random(crateTypes)
		print(entName)
	end
	

	local ent = ents.Create(entName)
	if not randomWep and not table.HasValue(crateTypes, entName) then
        ent:SetModel(KOROBKA_HUYNYI[math.random(#KOROBKA_HUYNYI)])
    else
        ent.Spawned = true
    end
    
	if IsValid(ent) then
		ent:SetPos(spawns[math.random(#spawns)] + Vector(0, 0, 32))
		ent:Spawn()
	end
end)


if timer.Exists("SpawnTheBoxes") then
	timer.Remove("SpawnTheBoxes")
end


timer.Create("SpawnTheBoxes", 15, 0, function()
	hook.Run("Boxes Think")
end)
