if SERVER then
	include("bloodmod_extensionsubtm.lua")
	 

	PrecacheParticleSystem("blood_fluid_UBTM_bleeding")

	hook.Add("EntityTakeDamage", "BloodStream_TakeDamage", function(ent, dmginfo)
		if (!ent:IsPlayer() and !ent:IsNPC()) then return end

		local dmgpos = dmginfo:GetDamagePosition()
		local dmgdir = dmginfo:GetDamageForce()
		
		local phys_bone = dmginfo:GetHitPhysBone(ent)
		
		if phys_bone then
			local bone = ent:TranslatePhysBoneToBone(phys_bone)

			local lpos, lang = WorldToLocal(dmgpos, dmgdir:Angle(), ent:GetBonePosition(bone))

			ent.bloodstream_lastdmgbone = bone
			ent.bloodstream_lastdmglpos = lpos
			ent.bloodstream_lastdmglang = lang
		end
	end)

	hook.Add("CreateEntityRagdoll", "BloodStream_ApplyEffect", function(ent, rag)
		if !ent.bloodstream_lastdmglpos then return end

		local bone = ent.bloodstream_lastdmgbone

		local lpos = ent.bloodstream_lastdmglpos
		local lang = ent.bloodstream_lastdmglang	
						
		--theres proably a better way to do this D:
		local meme = ents.Create("prop_dynamic")
		meme:SetModel("models/error.mdl")				
		meme:Spawn()
		meme:SetModelScale(0)
		meme:SetNotSolid(true)
		meme:DrawShadow(false)

		SafeRemoveEntityDelayed(meme, 15)

		meme:FollowBone(rag, bone)

		meme:SetLocalPos(lpos)
		meme:SetLocalAngles(lang)

		ParticleEffectAttach("blood_fluid_UBTM_bleeding1", PATTACH_ABSORIGIN_FOLLOW, meme, 0)
	 
		 --ParticleEffect("blood_fluid_UBTM_bleeding", dmgpos, dmgdir:Angle())
	end)
end