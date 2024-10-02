if SERVER then
local function CheckIfPlayersStuck()
    for _, ply1 in pairs(player.GetAll()) do
        if ply1:Alive() then
            for _, ply2 in pairs(player.GetAll()) do
                if ply2 ~= ply1 and ply2:Alive() and !ply2.fake and !ply1.fake then
                    if ply1:GetPos():DistToSqr(ply2:GetPos()) < 100 then
                        local victim = math.random(2) == 1 and ply1 or ply2
                        local dmg = DamageInfo()
                        dmg:SetDamage(9999)
                        dmg:SetDamageType(DMG_CRUSH)
                        dmg:SetAttacker(victim)
                        dmg:SetInflictor(victim)
                        victim:TakeDamageInfo(dmg)
                    end
                end
            end
        end
    end
end

hook.Add("Think", "CheckPlayersStuckDamage", CheckIfPlayersStuck)
end
