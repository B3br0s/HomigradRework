AddCSLuaFile()
DeriveGamemode("sandbox")

GM.Name 		= "Homigrad Rework"
GM.Author 		= "uhh"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased = false

hg = hg or {}

include("hgrework/gamemode/loader.lua")
AddCSLuaFile("hgrework/gamemode/loader.lua")

hg.IncludeDir("homigrad")
GM.includeDir("hgrework/gamemode/game/")
GM.includeDir("hgrework/gamemode/modes/")
GM.includeDir("homigrad/")

function GM:CreateTeams()
	team.SetUp(1,"Terrorists",Color(255,0,0))
	team.SetUp(2,"Counter Terrorists",Color(0,0,255))
	team.SetUp(3,"Other",Color(0,255,0))

	team.MaxTeams = 3
end

function GM:OnReloaded()
	//hg.IncludeDir("hgrework/gamemode/modes/")
end

local spawn = {"PlayerGiveSWEP", "PlayerSpawnEffect", "PlayerSpawnNPC", "PlayerSpawnObject", "PlayerSpawnProp", "PlayerSpawnRagdoll", "PlayerSpawnSENT", "PlayerSpawnSWEP", "PlayerSpawnVehicle"}

local function BlockSpawn(ply)
	//do return true end	
	if game.SinglePlayer() or ply:IsAdmin() then return true end

	return false
end

for _, v in ipairs(spawn) do
	hook.Add(v, "BlockSpawn", BlockSpawn)
end

hook.Add( "PlayerNoClip", "FeelFreeToTurnItOff", function( ply, desiredState )
	if ( desiredState == false ) then
		return true
	elseif ( ply:IsAdmin() ) then
		return true
	end

	return false
end )

if CLIENT then
	hook.Add( "PlayerBindPress", "PlayerBindPressExample", function( ply, bind, pressed )
		if ( string.find( bind, "+menu" ) ) then
		if ( not LocalPlayer():IsAdmin()) then
			return true
		end
		end
	end )

	hook.Add( "SpawnMenuOpen", "SpawnMenuWhitelist", function()
		if ( not LocalPlayer():IsAdmin()) then
			return false
		end
	end )
end

function OpposingTeam(team)
	if team == 1 then return 2 elseif team == 2 then return 1 end
end

function ReadPoint(point)
	if TypeID(point) == TYPE_VECTOR then
		return {point,Angle(0,0,0)}
	elseif type(point) == "table" then
		if type(point[2]) == "number" then
			point[3] = point[2]
			point[2] = Angle(0,0,0)
		end

		return point
	end
end

local team_GetPlayers = team.GetPlayers

function PlayersInGame()
    local newTbl = {}

    for i,ply in pairs(team_GetPlayers(1)) do newTbl[i] = ply end
    for i,ply in pairs(team_GetPlayers(2)) do newTbl[#newTbl + 1] = ply end
    for i,ply in pairs(team_GetPlayers(3)) do newTbl[#newTbl + 1] = ply end

    return newTbl
end