hook.Add("EntityTakeDamage", "PlayerDamageParticleEffect", function(target, dmginfo)
    if target:IsPlayer() then
        local effectData = EffectData()
        
        -- Set the position of the effect to where the player got hit
        effectData:SetOrigin(dmginfo:GetDamagePosition())
        
        -- Alternatively, if the damage position isn't working properly, use the player's current position
        if effectData:GetOrigin() == vector_origin then
            effectData:SetOrigin(target:GetPos() + Vector(0, 0, 50))  -- Offset it a little bit above the ground
        end
        
        -- Set the entity so that the effect attaches to the player
        effectData:SetEntity(target)
        
        -- Use the 'exit_blood_large' particle effect
        util.Effect("exit_blood_large", effectData)
    end
end)
