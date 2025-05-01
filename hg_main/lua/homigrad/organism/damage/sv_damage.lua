util.AddNetworkString("LobotomySFX")
util.AddNetworkString("DeathScreen")

DamageMultipliers = {
    [DMG_CLUB] = 1,--ее
    [DMG_BULLET] = 1.5,
    [DMG_SLASH] = 0.4,
    [DMG_BLAST] = 9,
    [DMG_CRUSH] = 1 / 128,--а почему бы и нет?
}

PainMultipliers = {
    [DMG_CLUB] = 0.5,--ее
    [DMG_BULLET] = 3.2,
    [DMG_SLASH] = 0.3,
    [DMG_BLAST] = 6,
    [DMG_CRUSH] = 15,
}

local Reasons = {
    --[DMG_CRUSH] = "dead_world",
    --[DMG_FALL] = "dead_world",
    [DMG_BULLET] = "died_by",
    [DMG_BUCKSHOT] = "died_by",
    [DMG_BLAST] = "dead_blast",
    [DMG_CLUB] = "died_by",
    [DMG_SLASH] = "died_by",
    [DMG_BURN] = "dead_burn",
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
		ply:SetNWString("LastHitBone",bonename)
	end

	if BoneIntoHG[bonename] == HITGROUP_HEAD and dmginfo:GetDamageType() == DMG_CRUSH then
		local ply = (ent:IsPlayer() and ent or RagdollOwner(ent))
		local rag = ent

		if rag:GetVelocity():Length() > 400
		and (dmginfo:GetDamage() * 30) > 7 then
			ply.KillReason = "dead_neck"
			ply:SetNWString("KillReason",ply.KillReason)
            if ply:Alive() then
			ply:Kill()
            end
			sound.Play("homigrad/player/neck_snap_01.wav",rag:GetPos(),75,100,1,0)
		end
	end
	
end)

hook.Add("PlayerDeath","Homigrad_DeathScreen",function(ply,attacker,killedby)
	ply:SetNWString("KillReason",ply.KillReason)
	ply:SetNWEntity("LastInflictor",ply.LastDMGInfo:GetInflictor())
	ply:SetNWEntity("LastAttacker",killedby)
	ply.AppearanceOverride = false
	ply.PLYSPAWN_OVERRIDE = false
	timer.Simple(0,function()
		if IsValid(ply.FakeRagdoll) then
			ply.FakeRagdoll:GetPhysicsObject():SetMass(20)
		end
	end)
	timer.Simple(0.1,function()
		net.Start("DeathScreen")
		net.Send(ply)
	end)
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

function GetPhysicsBoneDamageInfo(ent,dmgInfo)
    local pos = dmgInfo:GetDamagePosition()
    local dir = dmgInfo:GetDamageForce():GetNormalized()

    dir:Mul(1024 * 8)

    local tr = {}
    tr.start = pos
    tr.endpos = pos + dir
    tr.filter = filter
    filterEnt = ent
    tr.ignoreworld = true

    local result = util.TraceLine(tr)
    if result.Entity ~= ent then
        tr.endpos = pos - dir

        return util.TraceLine(tr).PhysicsBone
    else
        return result.PhysicsBone
    end
end

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

	if dmginfo:GetDamage() > 25 and math.random(1,3) == 2 then
		if not ply.Fake then
			hg.Faking(ply,(IsValid(dmginfo:GetAttacker() and (ply:GetPos() - dmginfo:GetAttacker():GetPos()):Angle():Forward() * 5000 or dmginfo:GetDamageForce() * 10)))
		end
	end

	local physics_bone = GetPhysicsBoneDamageInfo(ent,dmginfo)

	local hitgroup
	local isfall

	local bonename = ent:GetBoneName(ent:TranslatePhysBoneToBone(physics_bone))
	ply.LastHitBoneName = bonename
    ply:SetNWString("LastHitBone",bonename)

	if BoneIntoHG[bonename] then hitgroup = BoneIntoHG[bonename] end

	local mul = RagdollDamageBoneMul[hitgroup]

	if rag and mul then dmginfo:ScaleDamage(mul) end

	local entAtt = dmginfo:GetAttacker()
	local att =
		(entAtt:IsPlayer() and entAtt:Alive() and entAtt) or
		(entAtt:GetClass() == "wep" and entAtt:GetOwner())
	att = dmginfo:GetDamageType() ~= DMG_CRUSH and att or ply.LastAttacker

	if !dmginfo:IsDamageType(DMG_FALL + DMG_CRUSH) then
		ply.LastAttacker = att
   		//ply:SetNWEntity("LastAttacker",att or NULL)
	end
	ply.LastHitGroup = hitgroup

    ply.KillReason = Reasons[dmginfo:GetDamageType()]
    ply:SetNWString("KillReason",ply.KillReason)

	local LastDMGINFO = DamageInfo()
	LastDMGINFO:SetAttacker(dmginfo:GetAttacker())
	LastDMGINFO:SetDamage(dmginfo:GetDamage())
	LastDMGINFO:SetInflictor(dmginfo:GetInflictor())
	LastDMGINFO:SetDamageType(dmginfo:GetDamageType())
	LastDMGINFO:SetDamagePosition(dmginfo:GetDamagePosition())
	LastDMGINFO:SetDamageForce(dmginfo:GetDamageForce())

	ply.LastDMGInfo = LastDMGINFO

	ply:SetNWEntity("LastInflictor",LastDMGINFO:GetInflictor())

	dmginfo:ScaleDamage((DamageMultipliers[dmginfo:GetDamageType()] and DamageMultipliers[dmginfo:GetDamageType()] or 0.7))

    ply.pain = math.Clamp(ply.pain + dmginfo:GetDamage() * (PainMultipliers[dmginfo:GetDamageType()] and PainMultipliers[dmginfo:GetDamageType()] or 1.7),0,400)

	if rag then
		ply:SetHealth(ply:Health() - (dmginfo:IsDamageType(DMG_CRUSH) and dmginfo:GetDamage() * (rag:GetVelocity():Length() / 100) or dmginfo:GetDamage()))	
	end

	if dmginfo:IsDamageType(DMG_SLASH + DMG_BULLET + DMG_BUCKSHOT) then
		if not ply.bleed then
			ply.bleed = 0
		end
		ply.bleed = ply.bleed + dmginfo:GetDamage() * 2
	end

	hook.Run("Homigrad_Organs",ent,dmginfo,GetPhysicsBoneDamageInfo(ent,dmginfo),ent:GetBoneName(ent:TranslatePhysBoneToBone(GetPhysicsBoneDamageInfo(ent,dmginfo))))
end)