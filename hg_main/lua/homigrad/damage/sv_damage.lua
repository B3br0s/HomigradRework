util.AddNetworkString("LobotomySFX")

DamageMultipliers = {
    [DMG_CLUB] = 0.5,--ее
    [DMG_BULLET] = 0.8,
    [DMG_SLASH] = 0.3,
    [DMG_BLAST] = 3,
    [DMG_CRUSH] = 1 / 32,--а почему бы и нет?
}

PainMultipliers = {
    [DMG_CLUB] = 2,--ее
    [DMG_BULLET] = 0.2,
    [DMG_SLASH] = 0.3,
    [DMG_BLAST] = 3,
    [DMG_CRUSH] = 1.5,--а почему бы и нет?
}

hook.Add("Player Think","Player_Health",function(ply,time)
    if ply:Health() < 1 and ply:Alive() then
        ply:Kill()-- из за дамага меньше 1 хп остается и чел жив
    end
end)

hook.Add("Homigrad_Organs","Organs_Damage",function(ent,dmginfo,physbone,hitgroup,bone)
	if dmginfo:IsDamageType(DMG_SLASH + DMG_BULLET + DMG_BLAST) then
        local bonePos, boneAng = ent:GetBonePosition(physbone)

        if dmginfo:IsDamageType(DMG_SLASH + DMG_BULLET + DMG_BLAST) then
            net.Start("bp hit")
            net.WriteVector(bonePos)
            net.WriteVector(Vector(0, 0, 0) + (IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():EyeAngles():Forward() * -10 or boneAng:Forward() * 10))
            net.Broadcast()
            net.Start("blood particle")
            net.WriteVector(bonePos)
            net.WriteVector(Vector(0, 0, 0) + (IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():EyeAngles():Forward() * -10 or boneAng:Forward() * 10))
            net.Broadcast()
        end
    end


	
end)

RagdollDamageBoneMul={
	[HITGROUP_LEFTLEG]=0.5,
	[HITGROUP_RIGHTLEG]=0.5,

	[HITGROUP_GENERIC]=1,

	[HITGROUP_LEFTARM]=0.5,
	[HITGROUP_RIGHTARM]=0.5,

	[HITGROUP_CHEST]=1,
	[HITGROUP_STOMACH]=1,

	[HITGROUP_HEAD]=2,
}


hook.Add("EntityTakeDamage", "Homigrad_damage", function(ent, dmginfo)
    if IsValid(ent:GetPhysicsObject()) and dmginfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT+DMG_CLUB+DMG_GENERIC+DMG_BLAST) then ent:GetPhysicsObject():ApplyForceOffset(dmginfo:GetDamageForce():GetNormalized() * math.min(dmginfo:GetDamage() * 10,3000),dmginfo:GetDamagePosition()) end
	local ply = RagdollOwner(ent) or ent
	if ent.IsArmor then
		ply = ent.Owner
		ent = ply:GetNWEntity("FakeRagdoll") or ply
	end

	if not ply or not ply:IsPlayer() or not ply:Alive() or ply:HasGodMode() then
		return
	end

	local rag = ply ~= ent and ent
	
	if rag and dmginfo:IsDamageType(DMG_CRUSH) and att and att:IsRagdoll() then
		dmginfo:SetDamage(0)

		return true
	end

	local physics_bone = GetPhysicsBoneDamageInfo(ent,dmginfo)

	local hitgroup
	local isfall

	local bonename = ent:GetBoneName(ent:TranslatePhysBoneToBone(physics_bone))
	ply.LastHitBoneName = bonename

	if BoneIntoHG[bonename] then hitgroup = BoneIntoHG[bonename] end

	local mul = RagdollDamageBoneMul[hitgroup]

	if rag and mul then dmginfo:ScaleDamage(mul) end

	local entAtt = dmginfo:GetAttacker()
	local att =
		(entAtt:IsPlayer() and entAtt:Alive() and entAtt) or
		(entAtt:GetClass() == "wep" and entAtt:GetOwner())
	att = dmginfo:GetDamageType() ~= DMG_CRUSH and att or ply.LastAttacker

	ply.LastAttacker = att
	ply.LastHitGroup = hitgroup

	local LastDMGINFO = DamageInfo()
	LastDMGINFO:SetAttacker(dmginfo:GetAttacker())
	LastDMGINFO:SetDamage(dmginfo:GetDamage())
	LastDMGINFO:SetDamageType(dmginfo:GetDamageType())
	LastDMGINFO:SetDamagePosition(dmginfo:GetDamagePosition())
	LastDMGINFO:SetDamageForce(dmginfo:GetDamageForce())

	ply.LastDMGInfo = LastDMGINFO

	dmginfo:ScaleDamage((DamageMultipliers[dmginfo:GetDamageType()] and DamageMultipliers[dmginfo:GetDamageType()] or 0.7))

    ply.pain = math.Clamp(ply.pain + dmginfo:GetDamage() * (PainMultipliers[dmginfo:GetDamageType()] and PainMultipliers[dmginfo:GetDamageType()] or 1.3),0,400)

	ply:SetHealth(ply:Health() - dmginfo:GetDamage() / (ply.Fake and 1 or 8))

	if dmginfo:IsDamageType(DMG_SLASH + DMG_BULLET + DMG_BUCKSHOT) then
		if not ply.bleed then
			ply.bleed = 0
		end
		ply.bleed = ply.bleed + dmginfo:GetDamage() * 2
	end

	hook.Run("Homigrad_Organs",ent,dmginfo,GetPhysicsBoneDamageInfo(ent,dmginfo),ent:GetBoneName(ent:TranslatePhysBoneToBone(GetPhysicsBoneDamageInfo(ent,dmginfo))))
end)