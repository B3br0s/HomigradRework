event = event or {}

function event.StartRoundSV()
    game.CleanUpMap(false)

    for _, ply in ipairs(player.GetAll()) do
            if ply:Team() != 1002 then
                ply:SetTeam(2)
            end
        end

    timer.Simple(0,function()
        for _, ply in ipairs(player.GetAll()) do
            if ply:Team() != 1002 then
                ply:SetTeam(2)
            end
        end
    end)

    game.CleanUpMap(false)
end

function event.RoundThink()
    
end

function event.LootSpawn()
    return false
end