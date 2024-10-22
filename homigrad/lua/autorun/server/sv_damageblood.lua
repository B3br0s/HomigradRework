hook.Add("EntityTakeDamage", "PlayerDamageParticleEffect", function(target, dmginfo)
    if target:IsPlayer() then
        local effectData = EffectData()
        
        effectData:SetOrigin(dmginfo:GetDamagePosition())
        
        if effectData:GetOrigin() == vector_origin then
            effectData:SetOrigin(target:GetPos() + Vector(0, 0, 50))  -- Offset it a little bit above the ground
        end
        
        effectData:SetEntity(target)
        
        util.Effect("exit_blood_large", effectData)
    end
end)
