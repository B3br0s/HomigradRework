local ENT = FindMetaTable("Entity")

function ENT:RealisticBlood_BulletDamage( pos, normal, dmginfo )
    local dmg = dmginfo:GetDamage()

    -- Generic bleed effect:
    if math.random(1, 2) == 1 then self:RealisticBlood_DropletEffect( pos, normal, true ) end

    -- Exit wound:
    self:RealisticBlood_ExitWound( pos, -dmginfo:GetDamageForce():GetNormalized(), dmg )

    -- Wound that scaled with damage and stuff:
    local effectdata = EffectData()
    effectdata:SetStart( pos )
    effectdata:SetNormal( normal )
    effectdata:SetRadius( 1.5 )
    effectdata:SetMagnitude( dmg )
    effectdata:SetFlags( 1 )
    RealisticBlood_DoEffect("realisticblood_dynamicwound", effectdata, self)

    -- Blood stream:
    if math.random(1, 4) == 1 then
        self:RealisticBlood_BloodStream( pos, normal )
    end

    self:RealisticBlood_Soak( pos, normal )

    -- Blood pool (only works for ragdolls):d
    self:RealisticBlood_BloodPool( pos, dmg )
end

local non_bleed_dmgtypes = {
    DMG_BURN,
    DMG_DROWN,
    DMG_DROWNRECOVER,
    DMG_RADIATION,
    DMG_NERVEGAS,
    DMG_DISSOLVE,
    DMG_SLOWBURN,
    DMG_SHOCK,
}

local function is_non_bleed_damage( dmginfo )
    local dmg_type = dmginfo:GetDamageType()

    for _,v in ipairs(non_bleed_dmgtypes) do
        if v == bit.band(dmg_type, v) then return true end
    end
end

function ENT:RealisticBlood_OtherDamage( dmginfo )
    if dmginfo:IsExplosionDamage() then
        self:RealisticBlood_ShrapnelDamage( dmginfo )
    elseif !is_non_bleed_damage( dmginfo ) then
        if self:IsPlayer() && dmginfo:IsDamageType(DMG_FALL) then
            -- Fall damage splatter:
            local effectdata = EffectData()
            effectdata:SetStart( self:GetPos() )
            effectdata:SetNormal( ( -self:GetUp() + VectorRand() ):GetNormalized() )
            effectdata:SetMagnitude(dmginfo:GetDamage())
            effectdata:SetFlags( 2 )
            RealisticBlood_DoEffect("realisticblood_splatter", effectdata, self)
        else
            -- Splatter:
            local effectdata = EffectData()
            effectdata:SetStart( dmginfo:GetDamagePosition() )
            effectdata:SetNormal( ( dmginfo:GetDamageForce() ):GetNormalized() )
            effectdata:SetMagnitude(dmginfo:GetDamage())
            effectdata:SetFlags( 1 )
            RealisticBlood_DoEffect("realisticblood_splatter", effectdata, self)
        end

        -- Pool:
        self:RealisticBlood_BloodPool( dmginfo:GetDamagePosition(), dmginfo:GetDamage() )
        -- Droplets:
        if math.random(1, 4) == 1 then self:RealisticBlood_DropletEffect(  dmginfo:GetDamagePosition(), -( dmginfo:GetDamageForce() ):GetNormalized() ) end
    end
end

function ENT:RealisticBlood_PhysDamage( dmginfo )
    if math.random(1, 3)==1 or dmginfo:GetDamage() >= 100 then
        local effectdata = EffectData()
        effectdata:SetStart(dmginfo:GetDamagePosition())
        effectdata:SetNormal(-dmginfo:GetDamageForce():GetNormalized())
        effectdata:SetMagnitude(dmginfo:GetDamage())
        effectdata:SetFlags( dmginfo:GetDamage() >= 100 && 3 or 2 )
        RealisticBlood_DoEffect("realisticblood_splatter", effectdata, self)
    end

    if dmginfo:GetDamage() >= 500 or (dmginfo:IsDamageType(DMG_VEHICLE) && dmginfo:GetDamage() >= 100) then
        self:RealisticBlood_BloodPool( dmginfo:GetDamagePosition(), dmginfo:GetDamage() )
        self:RealisticBlood_DropletEffect( dmginfo:GetDamagePosition(), dmginfo:GetDamageForce():GetNormalized(), true )
    end
end