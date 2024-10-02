	if engine.ActiveGamemode() == "homigrad" then
local vecZero = Vector(0,0,0)

local function removeBone(rag,bone,phys_bone)
	rag:ManipulateBoneScale(bone,vecZero)

	if rag.gibRemove[phys_bone] then return end

	local phys_obj = rag:GetPhysicsObjectNum(phys_bone)
	phys_obj:EnableCollisions(false)
	phys_obj:SetMass(0.1)
	--rag:RemoveInternalConstraint(phys_bone)

	constraint.RemoveAll(phys_obj)
	rag.gibRemove[phys_bone] = phys_obj
end

local function recursive_bone(rag,bone,list)
	for i,bone in pairs(rag:GetChildBones(bone)) do
		if bone == 0 then continue end--wtf

		list[#list + 1] = bone

		recursive_bone(rag,bone,list)
	end

end

function Gib_RemoveBone(rag,bone,phys_bone)
	rag.gibRemove = rag.gibRemove or {}

	removeBone(rag,bone,phys_bone)

	local list = {}
	recursive_bone(rag,bone,list)
	for i,bone in pairs(list) do
		removeBone(rag,bone,rag:TranslateBoneToPhysBone(bone))
	end
end

concommand.Add("removebone",function(ply)
	if ply:IsAdmin() then
	local trace = ply:GetEyeTrace()
	local ent = trace.Entity
	if not IsValid(ent) then return end

	local phys_bone = trace.PhysicsBone
	if not phys_bone or phys_bone == 0 then return end

	Gib_RemoveBone(ent,ent:TranslatePhysBoneToBone(phys_bone),phys_bone)
	end
end)

gib_ragdols = gib_ragdols or {}
local gib_ragdols = gib_ragdols

local validHitGroup = {
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
}

local Rand = math.Rand

local validBone = {
	["ValveBiped.Bip01_R_UpperArm"] = true,
	["ValveBiped.Bip01_R_Forearm"] = true ,
	["ValveBiped.Bip01_R_Hand"] = true,
	["ValveBiped.Bip01_L_UpperArm"] = true,
	["ValveBiped.Bip01_L_Forearm"] = true,
	["ValveBiped.Bip01_L_Hand"] = true,

	["ValveBiped.Bip01_L_Thigh"] = true,
	["ValveBiped.Bip01_L_Calf"] = true,
	["ValveBiped.Bip01_L_Foot"] = true,
	["ValveBiped.Bip01_R_Thigh"] = true,
	["ValveBiped.Bip01_R_Calf"] = true,
	["ValveBiped.Bip01_R_Foot"] = true
}

local function razrivtela(pos)
			local propModels = {
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_scapula.mdl",
	"models/Gibs/HGIBS_scapula.mdl",
	"models/Gibs/HGIBS_scapula.mdl",
	"models/Gibs/HGIBS_scapula.mdl",
	"models/Gibs/HGIBS_spine.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_spine.mdl",
	"models/Gibs/HGIBS.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_spine.mdl",
	"models/Gibs/HGIBS_spine.mdl",
	"models/Gibs/HGIBS_spine.mdl",
}


for i = 1, #propModels do
timer.Simple(0.1, function()
	local prop = ents.Create("prop_physics")
    if not IsValid(prop) then return end

    prop:SetModel(propModels[i])
    prop:SetPos(pos)
    prop:Spawn()

	prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    local randomVelocity = Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
    prop:GetPhysicsObject():SetVelocity(randomVelocity)
--[[	timer.Simple(20,function()
		prop:Remove()
		end)]]
end )
end
end
local function headshotblyat(pos)
local propModels = {
	"models/mosi/fnv/props/gore/gorehead03.mdl",
	"models/mosi/fnv/props/gore/gorehead02.mdl",
	"models/mosi/fnv/props/gore/gorehead06.mdl",
	"models/mosi/fnv/props/gore/gorehead05.mdl",
	"models/mosi/fnv/props/gore/gorehead04.mdl"
}

timer.Simple(0.1, function()
for i = 1, #propModels do
    local prop = ents.Create("prop_physics")
    if not IsValid(prop) then return end

    prop:SetModel(propModels[i])
    prop:SetPos(pos)
	prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    prop:Spawn()

    local randomVelocity = Vector(math.random(-150,150), math.random(-500, 500), math.random(-150, 150))
    prop:GetPhysicsObject():SetVelocity(randomVelocity)

--[[	timer.Simple(20,function()
		prop:Remove()
		end)]]
end
end )
end


function Gib_Input(rag,bone,dmgInfo,player)
	if not IsValid(rag) then return end

	local hitgroup = bonetohitgroup[rag:GetBoneName(bone)]

	local gibRemove = rag.gibRemove
	if not gibRemove then
		rag.gibRemove = {}
		gibRemove = rag.gibRemove

		gib_ragdols[rag] = true

		if not dmgInfo:IsDamageType(DMG_CRUSH) then
			rag.Blood = rag.Blood or 5000
			rag.BloodNext = 0
			rag.BloodGibs = {}
		end
	end

	ParticleEffect("exit_blood_small",rag:GetPhysicsObject(phys_bone):GetPos(),Angle(math.random(-90),math.random(130),math.random(130)))	

	local phys_bone = rag:TranslateBoneToPhysBone(bone)

	local dmgPos = dmgInfo:GetDamagePosition()

	if dmgInfo:IsDamageType(DMG_BLAST) then
			dmgInfo:ScaleDamage(5000)
			sound.Emit(rag,"physics/body/body_medium_break4.wav")
			sound.Emit(rag,"physics/body/body_medium_break2.wav")
			sound.Emit(rag,"physics/body/body_medium_break3.wav")
		--[[if player != nil then
			player:ChatPrint("Тебя разорвало на части.")
			end]]
			
	
			
		--	if GetGlobalBool("GoreEnabled") then
		if dmgInfo:GetDamage() >= 2000 then
				razrivtela(rag:GetPos())
		--	end
		end

		--	if GetGlobalBool("BloodGoreEnabled") then
				BloodParticleExplode(rag:GetPhysicsObject(phys_bone):GetPos(),dmgInfo:GetDamageForce() * 2)
		--	end

			rag:Remove()
	end

	if hitgroup == HITGROUP_HEAD and dmgInfo:GetDamage() >= 300 and not dmgInfo:IsDamageType(DMG_CRUSH) and not gibRemove[phys_bone] then
		sound.Emit(rag,"homigrad/headshoot.wav")
		sound.Emit(rag,"homigrad/player/headshot" .. math.random(1,2) .. ".wav")

		timer.Simple(0.05,function()
			if not IsValid(rag) then return end

		--	rag:EmitSound("physics/flesh/flesh_bloody_break.wav",90,75,2)
		end)

	--	if GetGlobalBool("GoreEnabled") then
	--	end

	--	if GetGlobalBool("BloodGoreEnabled") then
				BloodParticleHeadshoot(rag:GetPhysicsObject(phys_bone):GetPos(),dmgInfo:GetDamageForce() * 2)

				ParticleEffect("exit_blood_small",rag:GetPhysicsObject(phys_bone):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_large",rag:GetPhysicsObject(phys_bone):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_small",rag:GetPhysicsObject(phys_bone):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_large",rag:GetPhysicsObject(phys_bone):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_small",rag:GetPhysicsObject(phys_bone):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_large",rag:GetPhysicsObject(phys_bone):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_small",rag:GetPhysicsObject(phys_bone):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_large",rag:GetPhysicsObject(phys_bone):GetPos(),Angle(-90,0,0))	
	--	end
	if dmgInfo:GetDamage() > 500 then
		headshotblyat(rag:GetPhysicsObject(phys_bone):GetPos())

		Gib_RemoveBone(rag,bone,phys_bone)
end
		
	end
	--крута🎈 когда взрываеца от прикосновения да?
	--да
	if dmgInfo:GetDamage() >= 1200 and dmgInfo:IsDamageType(DMG_CRUSH+DMG_VEHICLE) or rag:GetVelocity():Length() > 740 and dmgInfo:IsDamageType(DMG_CRUSH+DMG_BLAST+DMG_VEHICLE+DMG_FALL) or math.random(1,152) == 52 and dmgInfo:IsDamageType(DMG_CRUSH+DMG_BLAST+DMG_VEHICLE+DMG_FALL) then
			dmgInfo:ScaleDamage(5000)
			--sound.Emit(rag,"physics/body/body_medium_break4.wav")
			--sound.Emit(rag,"physics/body/body_medium_break2.wav")
			sound.Emit(rag,"homigrad/blood_splash.wav")
			sound.Emit(rag,"homigrad/blood_splash.wav")
			sound.Emit(rag,"homigrad/blood_splash.wav")
			sound.Emit(rag,"homigrad/blood_splash.wav")
			sound.Emit(rag,"homigrad/blood_splash.wav")
			sound.Emit(rag,"physics/flesh/flesh_bloody_impact_hard1.wav")
		--[[if player != nil then
			player:ChatPrint("Тебя разорвало на части.")
			end]]
			
		--	if GetGlobalBool("GoreEnabled") then
			razrivtela(rag:GetPhysicsObject(phys_bone):GetPos())
		--	end

		--	if GetGlobalBool("BloodGoreEnabled") then
				local a0oapidor = rag:LookupBone("ValveBiped.Bip01_Pelvis")
				local a0oapidor2 = rag:LookupBone("ValveBiped.Bip01_Spine")

				ParticleEffect("exit_blood_small",rag:GetPhysicsObject(a0oapidor):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_large",rag:GetPhysicsObject(a0oapidor):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_small",rag:GetPhysicsObject(a0oapidor):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_large",rag:GetPhysicsObject(a0oapidor):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_small",rag:GetPhysicsObject(a0oapidor):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_large",rag:GetPhysicsObject(a0oapidor):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_small",rag:GetPhysicsObject(a0oapidor):GetPos(),Angle(-90,0,0))	
				ParticleEffect("exit_blood_large",rag:GetPhysicsObject(a0oapidor):GetPos(),Angle(-90,0,0))	
				ParticleEffect("impact0_smoke",rag:GetPhysicsObject(a0oapidor):GetPos(),Angle(math.random(360),math.random(360),math.random(360)))
				ParticleEffect("impact0_smoke",rag:GetPhysicsObject(a0oapidor):GetPos() * 1.01,Angle(math.random(360),math.random(360),math.random(360)))
				ParticleEffect("impact0_smoke",rag:GetPhysicsObject(a0oapidor):GetPos() / 1.01,Angle(math.random(360),math.random(360),math.random(360)))
				ParticleEffect("impact0_smoke",rag:GetPhysicsObject(a0oapidor2):GetPos(),Angle(math.random(360),math.random(360),math.random(360)))
				ParticleEffect("impact0_smoke",rag:GetPhysicsObject(a0oapidor2):GetPos() * 1.01,Angle(math.random(360),math.random(360),math.random(360)))
				ParticleEffect("impact0_smoke",rag:GetPhysicsObject(a0oapidor2):GetPos() / 1.01,Angle(math.random(360),math.random(360),math.random(360)))

				BloodParticleExplode(rag:GetPhysicsObject(phys_bone):GetPos(),dmgInfo:GetDamageForce() * 2)
		--	end

			rag:Remove()
	end
	rag:GetPhysicsObject():SetMass(20)
end

hook.Add("PlayerDeath","Gib",function(ply)
	dmgInfo = ply.LastDMGInfo
	if not dmgInfo then return end

	--разве это не смешно когда ножом башка взрывается?
	--нет
	
	if dmgInfo:GetDamage() >= 30 then
		timer.Simple(0,function()
			local rag = ply:GetNWEntity("Ragdoll")
			local bone = rag:LookupBone(ply.LastHitBoneName)

			if not IsValid(rag) or not bone then return end--бу

			Gib_Input(rag,bone,dmgInfo,player)
		end)
	end
end)

hook.Add("EntityTakeDamage","Gib",function(ent,dmgInfo)
	if not ent:IsRagdoll() then return end
	
	local ply = RagdollOwner(ent)
	ply = ply and ply:Alive() and ply
	if ply then return end
	
	local phys_bone = GetPhysicsBoneDamageInfo(ent,dmgInfo)
	if phys_bone == 0 then return end--lol

	local hitgroup

	local bonename = ent:GetBoneName(ent:TranslatePhysBoneToBone(phys_bone))

	if bonetohitgroup[bonename] then hitgroup = bonetohitgroup[bonename] end

	local mul = RagdollDamageBoneMul[hitgroup]
	
	if dmgInfo:GetDamage() * mul > 200 then return end
	
	Gib_Input(ent,ent:TranslatePhysBoneToBone(phys_bone),dmgInfo)
end)

local max = math.max
local util_TraceLine = util.TraceLine
local util_Decal = util.Decal

local tr = {}

hook.Add("Think","Gib",function()
	local time = CurTime()

	for ent in pairs(gib_ragdols) do
		if not IsValid(ent) then gib_ragdols[ent] = nil continue end

		if ent.BloodGibs and ent.Blood > 0 then
			local k = ent.Blood / 5000

			if (ent.BloodNext or 0) < time then
				ent.BloodNext = time + Rand(0.25,0.5) / max(k,0.25)
				ent.Blood = max(ent.Blood - 25,0)

				tr.start = ent:GetPos()
				tr.endpos = tr.start + Vector(Rand(-1,1),Rand(-1,1),-Rand(0.25,0.4)) * 125 * Rand(0.8,1.2)
				tr.filter = ent

				local traceResult = util_TraceLine(tr)
				if traceResult.Hit then
					ent:EmitSound("homigrad/player/blooddrip" .. math.random(1,4) .. ".wav", 60,math.random(230,240),0.1,CHAN_AUTO)

					util_Decal("Blood",traceResult.HitPos + traceResult.HitNormal,traceResult.HitPos - traceResult.HitNormal,ply)
				else
					BloodParticle(ent:GetPos() + ent:OBBCenter(),ent:GetVelocity() + Vector(math.Rand(-5,5),math.Rand(-5,5),0))
				end
			end

			local BloodGibs = ent.BloodGibs

			for phys_bone,phys_obj in pairs(ent.gibRemove) do
				if (BloodGibs[phys_bone] or 0) < time then
					ent.Blood = max(ent.Blood - 25,0)

					BloodGibs[phys_bone] = time + Rand(0.07,0.1) / max(k,0.25)

					BloodParticle(phys_obj:GetPos(),phys_obj:GetVelocity() + phys_obj:GetAngles():Forward() * Rand(200,250) * k)
				end
			end
		end
	end
end)
end