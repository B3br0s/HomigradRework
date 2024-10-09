if engine.ActiveGamemode() == "homigrad" then
    local validUserGroup = {
        meagsponsor = true,
        megapenis = true,
        ZvezdaTiktoka = false,
    }

    if SERVER then
        local dangerlyoha = {
            "models/props_c17/oildrum001_explosive.mdl",
            "models/props_c17/oildrum001.mdl",
            "models/props_junk/wood_crate001a.mdl",
            "models/props_c17/canister02a.mdl",
            "models/props_junk/gascan001a.mdl",
            "models/props_junk/metalgascan.mdl",
            "models/props_junk/propane_tank001a.mdl",
            "models/props_junk/PropaneCanister001a.mdl",
            "models/props_junk/wood_crate001a.mdl",
            "models/props_junk/wood_crate001a_damaged.mdl",
            "models/props_junk/wood_pallet001a.mdl",
            "models/props_junk/wood_crate002a.mdl",
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
	--"models/props_wasteland/controlroom_chair001a.mdl",
	"models/props_junk/gascan001a.mdl",
	"models/props_wasteland/cafeteria_bench001a.mdl",
	"models/props_c17/furnituredrawer002a.mdl",
	"models/props_interiors/furniture_cabinetdrawer02a.mdl",
	"models/props_c17/furniturecupboard001a.mdl",
	"models/props_interiors/furniture_desk01a.mdl",
	"models/props_c17/bench01a.mdl",
	"models/props_interiors/furniture_vanity01a.mdl",
    "models/props_phx/mk-82.mdl",
    "models/props_phx/ww2bomb.mdl",
    "models/props_phx/misc/flakshell_big.mdl",
    "models/props_phx/rocket1.mdl",
    "models/props_phx/torpedo.mdl",
    "models/props_phx/amraam.mdl",
    "models/props_phx/oildrum001_explosive.mdl",
    "models/props_phx/ball.mdl",
    "models/props_phx/misc/potato_launcher_explosive.mdl",
    "models/props_phx/cannonball_solid.mdl",
    "models/props_phx/misc/smallcannonball.mdl",
    "models/props_phx/cannonball.mdl",
    "models/props_phx/huge/tower.mdl",
    "models/props_phx/huge/evildisc_corp.mdl",
    "models/props_canal/canal_bridge01.mdl",
    "models/props_canal/canal_bridge02.mdl",
    "models/props_canal/canal_bridge03a.mdl",
    "models/props_canal/canal_bridge03b.mdl",
    "models/props_canal/canal_bridge04.mdl",
    "models/props_canal/canal_cap001.mdl",
    "models/props_combine/combine_bridge_b.mdl",
    "models/props_combine/combine_window001.mdl",
    "models/props_combine/weaponstripper.mdl",
    "models/props_trainstation/Column_Arch001a.mdl",
    "models/props_trainstation/mount_connection001a.mdl",
    "models/props_trainstation/Ceiling_Arch001a.mdl",
    "models/props_trainstation/pole_448Connection001a.mdl",
    "models/props_trainstation/pole_448Connection002b.mdl",
    "models/props_trainstation/trainstation_arch001.mdl",
    "models/props_wasteland/cargo_container01.mdl",
    "models/props_wasteland/cargo_container01c.mdl",
    "models/props_wasteland/cargo_container01b.mdl",
    "models/props_wasteland/coolingtank02.mdl",
    "models/props_phx/games/chess/board.mdl"
        }

        COMMANDS.accessspawn = {function(ply, args)
            SetGlobalBool("AccessSpawn", tonumber(args[1]) > 0)
            PrintMessage(3, "Разрешение на взаимодействие Q меню : " .. tostring(GetGlobalBool("AccessSpawn")))
        end}

        local function CanUseSpawnMenu(ply, class,model)
            if table.HasValue(dangerlyoha,model) and not ply:IsAdmin() then ply:ChatPrint("Ммм,разраб лично послал вас нахуй") return false end
            if roundActiveName != "construct" and not ply:IsAdmin() then
                return false
            end

            if roundActiveName == "construct" and not ply:IsAdmin() and ply:Alive() then
                if class != "prop" then
                    ply:ChatPrint("sorry,but go pososat chlen")
                    return false
                end
            elseif roundActiveName == "construct" and not ply:IsAdmin() and not ply:Alive() then
                    ply:ChatPrint("no")
                    return false 
            end

            if validUserGroup[ply:GetUserGroup()] or GetGlobalBool("AccessSpawn") then
                return true
            end

            local func = TableRound().CanUseSpawnMenu
            func = func and func(ply, class)
            if func != nil then return func end

            if not ply:IsAdmin() then
                ply:Kick("no")
                return false
            end
        end

        local blockedtools = {
            "dynamite",
            "remover",
            "nocollide",
            "balloon",
            "physprop",
            "weight_improved",
            "light",
            "lamp",
            "hoverball",
            "emitter",
            "advdupe2",
            "pulley",
            "muscle",
            "motor",
            "hydraulic",
            "elastic",
            "ballsocket",
            "axis",
            "Headcrab Canister",
            "item_charger_spawner",
            "Ammo Crate",
            "Item Crate",
            "Thumper",
            "permaprops",
            "material",
            "paint",
            "trails",
            "lvsaienabler",
            "lvshealthshieldeditor",
            "lvsturret",
            "inflator",
            "eyeposer",
            "faceposer",
            "colour",
            "wire_explosive",
            "wire_simple_explosive",
            "duplicator",
            "rope"
    }

        hook.Add("PlayerSpawnVehicle", "Cantspawnbullshit", function(ply,model) return CanUseSpawnMenu(ply, "vehicle",model) end)
        hook.Add("PlayerSpawnRagdoll", "Cantspawnbullshit", function(ply,model) return CanUseSpawnMenu(ply, "ragdoll",model) end)
        hook.Add("PlayerSpawnEffect", "Cantspawnbullshit", function(ply,model) return CanUseSpawnMenu(ply, "effect",model) end)
        hook.Add("PlayerSpawnProp", "Cantspawnbullshit", function(ply,model) return CanUseSpawnMenu(ply, "prop",model) end)
        hook.Add("PlayerSpawnSENT", "Cantspawnbullshit", function(ply,model) return CanUseSpawnMenu(ply, "sent",model) end)
        hook.Add("PlayerSpawnNPC", "Cantspawnbullshit", function(ply,model) return CanUseSpawnMenu(ply, "npc",model) end)
        hook.Add("PlayerSpawnSWEP", "SpawnBlockSWEP", function(ply,model) return CanUseSpawnMenu(ply, "swep",model) end)
        hook.Add("PlayerGiveSWEP", "SpawnBlockSWEP", function(ply,model) return CanUseSpawnMenu(ply, "swep",model) end)
        hook.Add("CanTool", "BlockToolGun", function(ply, tr, tool) if table.HasValue(blockedtools,tool) and not ply:IsAdmin() then ply:ChatPrint("Ммм,разраб лично послал вас нахуй") return false end end)
        

        local function spawn(ply, class, ent)
            local func = TableRound().CanUseSpawnMenu
            func = func and func(ply, class, ent)
        end

        hook.Add("PlayerSpawnedVehicle", "sv_round", function(ply, model, ent) spawn(ply, "vehicle", ent) end)
        hook.Add("PlayerSpawnedRagdoll", "sv_round", function(ply, model, ent) spawn(ply, "ragdoll", ent) end)
        hook.Add("PlayerSpawnedEffect", "sv_round", function(ply, model, ent) spawn(ply, "effect", ent) end)
        hook.Add("PlayerSpawnedProp", "sv_round", function(ply, model, ent) spawn(ply, "prop", ent) end)
        hook.Add("PlayerSpawnedSENT", "sv_round", function(ply, model, ent) spawn(ply, "sent", ent) end)
        hook.Add("PlayerSpawnedNPC", "sv_round", function(ply, model, ent) spawn(ply, "npc", ent) end)

    else
        local admin_menu = CreateClientConVar("hg_admin_menu", "1", true, false, "Enable admin menu", 0, 1)

        local function CanUseSpawnMenu()
            local ply = LocalPlayer()
            
            if not ply:Alive() and not ply:IsAdmin() then return false end

            if roundActiveName != "construct" and not ply:IsAdmin() then
                return false
            end

            if validUserGroup[ply:GetUserGroup()] or GetGlobalBool("AccessSpawn") then
                return true
            end

            local func = TableRound().CanUseSpawnMenu
            func = func and func(LocalPlayer())
            if func != nil then return func end

            if not ply:IsAdmin() then return false end
            if not admin_menu:GetBool() then return false end
        end

        local function CanUseCMenu()
            local ply = LocalPlayer()

            if not ply:IsAdmin() then
                return false
            end

            if validUserGroup[ply:GetUserGroup()] or GetGlobalBool("AccessSpawn") then
                return true
            end

            local func = TableRound().CanUseSpawnMenu
            func = func and func(LocalPlayer())
            if func != nil then return func end

            if not ply:IsAdmin() then return false end
            if not admin_menu:GetBool() then return false end
        end

        hook.Add("ContextMenuOpen", "hide_spawnmenu", CanUseCMenu)
        hook.Add("SpawnMenuOpen", "hide_spawnmenu", CanUseSpawnMenu)
    end
end
