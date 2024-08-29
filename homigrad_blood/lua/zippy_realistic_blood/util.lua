
local ENT = FindMetaTable("Entity")


function ENT:RealisticBlood_ClosestBone( pos, exclude_root_bone, count )
    local used_bones = {}
    local bone_distances = {}

    for i = 0, self:GetBoneCount()-1 do
        local boneToPhys = self:TranslateBoneToPhysBone(i)
        local bone = self:TranslatePhysBoneToBone ( boneToPhys )

        if used_bones[ bone ] then continue end
        used_bones[ bone ] = true

        if exclude_root_bone && bone == 0 then continue end

        local bone_pos = self:GetBonePosition( bone )

        if !bone_pos then continue end

        bone_distances[ bone ] = bone_pos:DistToSqr( pos )
    end

    local bones_sorted = {}
    local bone_amt = table.Count(bone_distances)

    for i = 1, (count && count <= bone_amt && count) or (count && bone_amt) or 1 do
        local mindist
        local bone

        for k, dist in pairs(bone_distances) do
            if !mindist or dist < mindist then
                mindist = dist
                bone = k
            end
        end

        if bone then
            table.insert(bones_sorted, 1, bone)
            bone_distances[bone] = nil
        end
    end

    if !table.IsEmpty(bones_sorted) then return ( (!count or count == 1) && bones_sorted[1] ) or bones_sorted end
end



function ENT:RealisticBlood_MakeBoneFollower( pos, normal, offset, ang_offset, lifetime, visible )
    local bone = self.RealisticBlood_HitBone
    if !bone then return end

    local bone_pos, bone_ang = self:GetBonePosition(bone)

    local _, localang2 = WorldToLocal( pos, normal:Angle(), bone_pos, bone_ang )

    normal = ( ang_offset && (normal:Angle()+ang_offset):Forward() ) or normal
    local localpos, localang = WorldToLocal( pos, normal:Angle(), bone_pos, bone_ang )

    local bone_follower = ents.Create("base_gmodentity")
    bone_follower:SetModel("models/hunter/plates/plate.mdl")
    if !visible then bone_follower:SetModelScale(0) end
    bone_follower:DrawShadow(false)
    bone_follower:FollowBone(self, bone)
    bone_follower:SetLocalPos( (offset && (localpos - (localang2:Forward()*offset) ) ) or localpos )
    bone_follower:SetLocalAngles(-localang)
    bone_follower:SetOwner(self)
    bone_follower:AddEFlags(EFL_DONTBLOCKLOS)
    bone_follower:Spawn()
    SafeRemoveEntityDelayed(bone_follower, lifetime)

    local dist = bone_pos:DistToSqr(bone_follower:GetPos())

    if dist > 144 then
        --print("bone follower too far away! ("..dist..")")
        bone_follower:SetPos( bone_pos )
    end

    if !self.RealisticBlood_BoneFollowers then self.RealisticBlood_BoneFollowers = {} end
    table.insert(self.RealisticBlood_BoneFollowers, bone_follower)

    return bone_follower
end