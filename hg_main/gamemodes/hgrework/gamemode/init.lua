include("shared.lua")
include("autorun/loader.lua")

function GM:PlayerLoadout() end--нахуя?

function GM:DoPlayerDeath(ply) return end

function GM:PlayerDeathThink(ply)
    ply:Spectate(OBS_MODE_ROAMING)
end

function GM:PlayerSpawn(ply)
    ply:UnSpectate()
    ply:Give("weapon_hands")
    hg.Gibbed[ply] = false
    if ply.KSILENT then
        ply:KillSilent()
        ply.KSILENT = false
    end
end

function GM:DoPlayerDeath(ply,attacker,dmginfo)
    ply.Fake = false
    ply.FakeRagdoll = NULL
end