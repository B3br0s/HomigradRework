event = event or {}

function event.StartRoundSV()
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() != 1002 then
            ply:SetTeam(2)
        end
    end
end

function event.RoundThink()
    
end