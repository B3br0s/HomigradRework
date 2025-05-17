event = event or {}

function event.StartRoundSV()
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 and not ply:Alive() then
            ply:SetTeam(1)
        end
    end
end

function event.RoundThink()
    
end