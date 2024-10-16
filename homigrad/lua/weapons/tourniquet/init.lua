if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound1 = Sound("snd_jack_hmcd_bandage.wav")
local healsound2 = Sound("snd_jack_hmcd_bandage.wav")

function SWEP:Heal(ent)
	if not ent or not ent:IsPlayer() then 
		if table.HasValue(BleedingEntities,ent) then
			sound.Play(healsound1,ent:GetPos(),75,100,0.5)
			return true
		else
			return
		end
	end
	if ent:GetClass() != "prop_ragdoll"then
	if ent.Organs['artery'] < 0.01 and ent:Alive() then
		ent.Zhgut = true
		ent.stamina = 20
		ent.hungryregen = 0
		ent.o2 = 0.4
		if ent == self:GetOwner() then
			ent:ChatPrint("Ты остановил себе кровотечение из артерии.")
		else
			ent:ChatPrint(self:GetOwner():Name().." Остановил тебе кровотечение из артерии.")
		end
		ent.Organs['artery'] = 1

		return true
	end
else
	if ent:GetNWEntity("RagdollOwner").Organs['artery'] < 0.01 and ent:GetNWEntity("RagdollOwner"):Alive() then
		ent:GetNWEntity("RagdollOwner").Zhgut = true
		ent:GetNWEntity("RagdollOwner").stamina = 20
		ent:GetNWEntity("RagdollOwner").hungryregen = 0
		ent:GetNWEntity("RagdollOwner").o2 = 0.4
			ent:GetNWEntity("RagdollOwner"):ChatPrint(self:GetOwner():Name().." Остановил тебе кровотечение из артерии.")
		ent:GetNWEntity("RagdollOwner").Organs['artery'] = 1

		return true
	end
end
end
end