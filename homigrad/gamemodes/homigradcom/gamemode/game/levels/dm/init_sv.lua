function dm.StartRoundSV()
    tdm.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 120 * (1 + math.min(#player.GetAll() / 8,2))

    local players = PlayersInGame()
    for i,ply in pairs(players) do ply:SetTeam(1) end

    local aviable = ReadDataMap("dm")
    aviable = #aviable ~= 0 and aviable or homicide.Spawns()
    tdm.SpawnCommand(team.GetPlayers(1),aviable,function(ply)
        ply:Freeze(true)
    end)

    freezing = true

    RTV_CountRound = RTV_CountRound - 1

    roundTimeRespawn = CurTime() + 15

    return {roundTimeStart,roundTime}
end

function dm.RoundEndCheck()
    local Alive = 0

    for i,ply in pairs(team.GetPlayers(1)) do
        if ply:Alive() then Alive = Alive + 1 end
    end

    if freezing and roundTimeStart + dm.LoadScreenTime < CurTime() then
        freezing = nil

        for i,ply in pairs(team.GetPlayers(1)) do
            ply:Freeze(false)
        end
    end

    if Alive <= 1 then EndRound() return end

end

function dm.EndRound(winner)
    for i, ply in ipairs( player.GetAll() ) do
	    if ply:Alive() then
            PrintMessage(3,ply:GetName() .. " остался один.")
        end
    end
end

local red = Color(255,0,0)

local function GetRandomPistol()
    local randomGun = {}
    for _, weapon in pairs(weapons.GetList()) do
        if weapon.Category == "Оружие: Пистолеты" then
            table.insert(randomGun,weapon.ClassName)
        end
    end
    return table.Random(randomGun)
end

local function GetRandomGun()
    local randomGun = {}
    for _, weapon in pairs(weapons.GetList()) do
        if weapon.Category == "Оружие: Винтовки" then
            table.insert(randomGun,weapon.ClassName)
        end
    end
    return table.Random(randomGun)
end

function dm.PlayerSpawn(ply,teamID)
    local Skins = {
        "models/chs_community/asix.mdl",
        "models/chs_community/blinked.mdl",
        "models/chs_community/cyborg_alex.mdl",
        "models/chs_community/deka_zcity.mdl",
        "models/chs_community/dick_jones.mdl",
        "models/chs_community/doctorkeks.mdl",
        "models/chs_community/emil_kms.mdl",
        "models/chs_community/f_dutchman.mdl",
        "models/chs_community/down.mdl",
        "models/chs_community/dozen_zcity.mdl",
        "models/chs_community/ghost_acceleron.mdl",
        "models/chs_community/gleb.mdl",
        "models/chs_community/golyb.mdl",
        "models/chs_community/griggs.mdl",
        "models/chs_community/hank_md.mdl",
        "models/chs_community/justik.mdl",
        "models/chs_community/mannytko.mdl",
        "models/chs_community/narik_zcity.mdl",
        "models/chs_community/necollins.mdl",
        "models/chs_community/patrick_kane.mdl",
        "models/chs_community/propka.mdl",
        "models/chs_community/tea.mdl",
        "models/chs_community/yahet.mdl",
        "models/chs_community/zac90.mdl",
        "models/chs_community/soda.mdl",
        "models/chs_community/soler.mdl",
        "models/chs_community/stanley.mdl"        
}
	ply:SetModel(table.Random(Skins))
    ply:SetPlayerColor(Vector(0,0,0.6))


    ply:Give("weapon_hands")
    ply:Give("weapon_sog")

    local RandomPistol = GetRandomPistol()
    local RandomGun = GetRandomGun()

    ply:Give(RandomGun)
    ply:Give(RandomPistol)

    ply:GiveAmmo(weapons.Get(RandomGun).Primary.DefaultClip,weapons.Get(RandomGun).Primary.Ammo)
    ply:GiveAmmo(weapons.Get(RandomPistol).Primary.DefaultClip,weapons.Get(RandomPistol).Primary.Ammo)

    ply:SetLadderClimbSpeed(100)

end

function dm.PlayerInitialSpawn(ply)
    ply:SetTeam(1)
end

function dm.PlayerCanJoinTeam(ply,teamID)
	if teamID == 2 or teamID == 3 then ply:ChatPrint("пашол нахуй") return false end

    return true
end

function dm.GuiltLogic() return false end

util.AddNetworkString("dm die")
function dm.PlayerDeath()
    net.Start("dm die")
    net.Broadcast()
end