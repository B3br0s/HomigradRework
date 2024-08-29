if SERVER then
    util.AddNetworkString("SlenderDamage")

    -- Function to deal damage to a player
    local function DealSlenderDamage(ply)
        if not ply:IsValid() or not ply:Alive() then return end

        local dmg = DamageInfo()
        dmg:SetDamage(10)
        dmg:SetAttacker(ply)
        dmg:SetInflictor(ply)
        dmg:SetDamageType(DMG_GENERIC)

        ply:TakeDamageInfo(dmg)
    end

    -- Receiving message from client to deal damage
    net.Receive("SlenderDamage", function(len, ply)
        DealSlenderDamage(ply)
    end)
end
