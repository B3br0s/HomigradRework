util.AddNetworkString("LobotomySFX")
util.AddNetworkString("DeathScreen")

DamageMultipliers = {
    [DMG_CLUB] = 0.5,--ее
    [DMG_BULLET] = 1.4,
    [DMG_SLASH] = 0.3,
    [DMG_BLAST] = 9,
    [DMG_CRUSH] = 1 / 128,--а почему бы и нет?
}

PainMultipliers = {
    [DMG_CLUB] = 2,--ее
    [DMG_BULLET] = 0.2,
    [DMG_SLASH] = 0.3,
    [DMG_BLAST] = 6,
    [DMG_CRUSH] = 10,--а почему бы и нет?
}

local BoneNames = {
    ["ValveBiped.Bip01_Pelvis"] = "Таз",
    ["ValveBiped.Bip01_Spine"] = "Нижнюю часть позвоночника",
    ["ValveBiped.Bip01_Spine1"] = "Среднюю часть позвоночника",
    ["ValveBiped.Bip01_Spine2"] = "Верхнюю часть позвоночника",
    ["ValveBiped.Bip01_Spine4"] = "Верхнюю часть позвоночника",
    ["ValveBiped.Bip01_L_Clavicle"] = "Левую ключицу",
    ["ValveBiped.Bip01_L_UpperArm"] = "Левое плечо",
    ["ValveBiped.Bip01_L_Forearm"] = "Левое предплечье",
    ["ValveBiped.Bip01_L_Hand"] = "Левую кисть",
    ["ValveBiped.Bip01_L_Finger0"] = "Левый большой палец",
    ["ValveBiped.Bip01_L_Finger01"] = "Левую фалангу большого пальца",
    ["ValveBiped.Bip01_L_Finger02"] = "Левую фалангу большого пальца",
    ["ValveBiped.Bip01_L_Finger1"] = "Левый указательный палец",
    ["ValveBiped.Bip01_L_Finger11"] = "Левую фалангу указательного пальца",
    ["ValveBiped.Bip01_L_Finger12"] = "Левую фалангу указательного пальца",
    ["ValveBiped.Bip01_L_Finger2"] = "Левый средний палец",
    ["ValveBiped.Bip01_L_Finger21"] = "Левую фалангу среднего пальца",
    ["ValveBiped.Bip01_L_Finger22"] = "Левую фалангу среднего пальца",
    ["ValveBiped.Bip01_L_Finger3"] = "Левый безымянный палец",
    ["ValveBiped.Bip01_L_Finger31"] = "Левую фалангу безымянного пальца",
    ["ValveBiped.Bip01_L_Finger32"] = "Левую фалангу безымянного пальца",
    ["ValveBiped.Bip01_L_Finger4"] = "Левый мизинец",
    ["ValveBiped.Bip01_L_Finger41"] = "Левую фалангу мизинца",
    ["ValveBiped.Bip01_L_Finger42"] = "Левую фалангу мизинца",
    ["ValveBiped.Bip01_R_Clavicle"] = "Правую ключицу",
    ["ValveBiped.Bip01_R_UpperArm"] = "Правое плечо",
    ["ValveBiped.Bip01_R_Forearm"] = "Правое предплечье",
    ["ValveBiped.Bip01_R_Hand"] = "Правую кисть",
    ["ValveBiped.Bip01_R_Finger0"] = "Правый большой палец",
    ["ValveBiped.Bip01_R_Finger01"] = "Правую фалангу большого пальца",
    ["ValveBiped.Bip01_R_Finger02"] = "Правую фалангу большого пальца",
    ["ValveBiped.Bip01_R_Finger1"] = "Правый указательный палец",
    ["ValveBiped.Bip01_R_Finger11"] = "Правую фалангу указательного пальца",
    ["ValveBiped.Bip01_R_Finger12"] = "Правую фалангу указательного пальца",
    ["ValveBiped.Bip01_R_Finger2"] = "Правый средний палец",
    ["ValveBiped.Bip01_R_Finger21"] = "Правую фалангу среднего пальца",
    ["ValveBiped.Bip01_R_Finger22"] = "Правую фалангу среднего пальца",
    ["ValveBiped.Bip01_R_Finger3"] = "Правый безымянный палец",
    ["ValveBiped.Bip01_R_Finger31"] = "Правую фалангу безымянного пальца",
    ["ValveBiped.Bip01_R_Finger32"] = "Правую фалангу безымянного пальца",
    ["ValveBiped.Bip01_R_Finger4"] = "Правый мизинец",
    ["ValveBiped.Bip01_R_Finger41"] = "Правую фалангу мизинца",
    ["ValveBiped.Bip01_R_Finger42"] = "Правую фалангу мизинца",
    ["ValveBiped.Bip01_Neck1"] = "Шею",
    ["ValveBiped.Bip01_Head1"] = "Голову",
    ["ValveBiped.Bip01_L_Thigh"] = "Левое бедро",
    ["ValveBiped.Bip01_L_Calf"] = "Левую голень",
    ["ValveBiped.Bip01_L_Foot"] = "Левую стопу",
    ["ValveBiped.Bip01_L_Toe0"] = "Левый палец ноги",
    ["ValveBiped.Bip01_R_Thigh"] = "Правое бедро",
    ["ValveBiped.Bip01_R_Calf"] = "Правую голень",
    ["ValveBiped.Bip01_R_Foot"] = "Правую стопу",
    ["ValveBiped.Bip01_R_Toe0"] = "Правый палец ноги"
}

hook.Add("Player Think","Player_Health",function(ply,time)
    if ply:Health() < 1 and ply:Alive() then
        ply:Kill()-- из за дамага меньше 1 хп остается и чел жив
    end
end)

hook.Add("Homigrad_Organs","Organs_Damage",function(ent,dmginfo,physbone,bonename)
	local ply = (ent:IsPlayer() and ent or RagdollOwner(ent))
	if IsValid(ply) then
		ply.LastHitBone = bonename
	end
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

	if BoneIntoHG[bonename] == HITGROUP_HEAD and dmginfo:GetDamageType() == DMG_CRUSH then
		local ply = (ent:IsPlayer() and ent or RagdollOwner(ent))
		local rag = ent

		if rag:GetVelocity():Length() > 150
		and (dmginfo:GetDamage() * 13) > 7 then
			ply.KillReason = "Neck"
            if ply:Alive() then
			ply:Kill()
            end
			sound.Play("homigrad/player/neck_snap_01.wav",rag:GetPos(),75,100,1,0)
		end
	end
	
end)

hook.Add("PlayerDeath","Homigrad_DeathScreen",function(ply,killedby,attacker)
	net.Start("DeathScreen")
	net.WriteString(ply.KillReason)
	net.WriteEntity(killedby)
	net.WriteEntity(attacker)
	net.WriteString(BoneNames[ply.LastHitBone] != nil and BoneNames[ply.LastHitBone] or "?")
	net.Send(ply)
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

	if dmginfo:IsDamageType(DMG_CRUSH+DMG_FALL) then
		ply.KillReason = "Crush"
	end

	ply:SetHealth(ply:Health() - dmginfo:GetDamage() / (ply.Fake and 1 or 8))

	if dmginfo:IsDamageType(DMG_SLASH + DMG_BULLET + DMG_BUCKSHOT) then
		if not ply.bleed then
			ply.bleed = 0
		end
		ply.bleed = ply.bleed + dmginfo:GetDamage() * 2
	end

	hook.Run("Homigrad_Organs",ent,dmginfo,GetPhysicsBoneDamageInfo(ent,dmginfo),ent:GetBoneName(ent:TranslatePhysBoneToBone(GetPhysicsBoneDamageInfo(ent,dmginfo))))
end)