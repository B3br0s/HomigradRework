local ENT = FindMetaTable("Entity")


function ENT:RealisticBlood_Soak( pos, normal )
    if self:GetClass() != "prop_ragdoll" then return end

    local effectdata = EffectData()
    effectdata:SetStart( pos )
    effectdata:SetNormal( normal )
    RealisticBlood_DoEffect("realisticblood_soak", effectdata, self)
end


function ENT:RealisticBlood_BloodPool( pos, damage )
    if self:GetClass() != "prop_ragdoll" then return end

    local retry_time = 14
    local retry_cooldown = 1

    local bone_follower = self:RealisticBlood_MakeBoneFollower( pos, Vector(0,0,0), false, false, retry_time+retry_cooldown )

    if bone_follower then
        local timer_name = "RealisticBlood_BloodPoolTimer"..bone_follower:EntIndex()

        timer.Create(timer_name, retry_cooldown, retry_time, function()
            if !IsValid(self) or !IsValid(bone_follower) then
                timer.Remove(timer_name)
                return
            end

            local tr = util.TraceLine({
                start = bone_follower:GetPos(),
                endpos = bone_follower:GetPos() - Vector(0,0,32),
                mask = MASK_NPCWORLDSTATIC,
            })

            if tr.Hit && self:GetVelocity():LengthSqr() < 40 then
                local effectdata = EffectData()
                effectdata:SetStart(tr.HitPos)
                effectdata:SetNormal(tr.HitNormal)
                effectdata:SetMagnitude( damage )
                effectdata:SetFlags( tr.DispFlags )
                RealisticBlood_DoEffect("realisticblood_pool", effectdata, self)

                timer.Remove(timer_name)
                bone_follower:Remove()
            end
        end)
    end
end


function ENT:RealisticBlood_DropletEffect( pos, normal, default_cooldown, duration )
    if default_cooldown then
        if self.RealisticBlood_NextDropletEffect && self.RealisticBlood_NextDropletEffect > CurTime() then return end
        self.RealisticBlood_NextDropletEffect = CurTime() + math.Rand(0.85, 1.35)
    end

    local bone_follower = self:RealisticBlood_MakeBoneFollower( pos, normal, 2, false, 6 )

    if bone_follower then
        local effectdata = EffectData()
        effectdata:SetMagnitude( duration or math.Rand(3, 5) )
        effectdata:SetStart( pos )
        RealisticBlood_DoEffect("realisticblood_droplets", effectdata, bone_follower)
    end
end


function ENT:RealisticBlood_BloodStream( pos, normal )
    if self.RealisticBlood_NextBloodStream && self.RealisticBlood_NextBloodStream > CurTime() then return end
    self.RealisticBlood_NextBloodStream = CurTime() + math.Rand(2.5, 3.8)

    local bone_follower = self:RealisticBlood_MakeBoneFollower( pos, normal, 3.5, false, 9 )

    if bone_follower then
        local effectdata = EffectData()
        effectdata:SetStart( pos )
        RealisticBlood_DoEffect("realisticblood_stream", effectdata, bone_follower)
    end
end


function ENT:RealisticBlood_ExitWound( pos, normal, damage )
    local ents_avoid = {}
    for _,v in ipairs(ents.FindInSphere(pos, 40)) do
        if v != self then table.insert(ents_avoid, v) end
    end

    local tr = util.TraceLine({
        start = pos-normal*40,
        endpos = pos,
        ignoreworld = true,
        filter = ents_avoid,
    })

    if tr.Hit && tr.Entity == self then
        local effect_cooldown_done = ( !self.RealisticBlood_NextExitWoundEffects or self.RealisticBlood_NextExitWoundEffects < CurTime() )
        local bone_follower = effect_cooldown_done && self:RealisticBlood_MakeBoneFollower( tr.HitPos, tr.HitNormal, 3.5, false, 9 )

        local effectdata = EffectData()
        effectdata:SetStart( tr.HitPos) 
        effectdata:SetNormal( tr.HitNormal )
        effectdata:SetRadius( 3 )
        effectdata:SetMagnitude( damage )
        effectdata:SetFlags( 2 )
        RealisticBlood_DoEffect("realisticblood_dynamicwound", effectdata, bone_follower or self)

        if effect_cooldown_done then
            self:RealisticBlood_Soak( tr.HitPos, tr.HitNormal )
            self.RealisticBlood_NextExitWoundEffects = CurTime()+math.random(2, 3)
        end
    end
end


function ENT:RealisticBlood_ShrapnelDamage( dmginfo )
    local closest_bones = self:RealisticBlood_ClosestBone( dmginfo:GetDamagePosition(), self:GetSolid() == SOLID_BBOX, 9 )
    if !closest_bones or !istable(closest_bones) then return end

    for i, bone in ipairs( closest_bones ) do
        local bone_pos = self:GetBonePosition(bone)

        local tr = util.TraceLine({
            start = dmginfo:GetDamagePosition(),
            endpos = bone_pos,
            filter = dmginfo:GetInflictor(),
        })

        if tr.Hit && tr.Entity == self then
            local effectdata = EffectData()
            effectdata:SetStart( tr.HitPos )
            effectdata:SetNormal( tr.HitNormal )
            effectdata:SetRadius( 3 )
            effectdata:SetMagnitude( dmginfo:GetDamage() )
            RealisticBlood_DoEffect("realisticblood_dynamicwound", effectdata, self)

            if ( !self.RealisticBlood_NextShrapnelBlood or self.RealisticBlood_NextShrapnelBlood < CurTime() ) then
                self:RealisticBlood_Soak( tr.HitPos, tr.HitNormal )
                self:RealisticBlood_DropletEffect( tr.HitPos, tr.HitNormal, false, i==1 && 5 or math.Rand(1.5, 3) )
                self:RealisticBlood_BloodPool( tr.HitPos, dmginfo:GetDamage() )
            end
        end
    end

    self.RealisticBlood_NextShrapnelBlood = CurTime()+math.random(2, 3)
end