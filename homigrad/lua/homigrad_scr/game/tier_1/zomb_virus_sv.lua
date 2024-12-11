if not engine.ActiveGamemode() == "homigradcom" then return end
COMMANDS = COMMANDS or {}


local zombies = {
    ["npc_zombie"] = true,
    ["npc_zombie_torso"] = true,
    ["npc_poisonzombie"] = true
}

local blevotasfx = {
    "hg_blevota1.wav",
    "hg_blevota2.wav",
    "hg_blevota3.wav"
}
--functions

local function CanSee(ply,ent)
    local Tr = util.TraceLine({
        start = ply:GetPos(),
        endpos = ent:GetPos(),
        filter = {self, ent},
        mask = MASK_SHOT
    })

    return not Tr.Hit
end

local function ZsVirusCough(ply)
    local r = math.random(0,25)
    if r > 15 and !ply.Otrub then
        --ply:EmitSound("ambient/voices/cough" .. math.random(1, 4) .. ".wav", 75, math.random(90, 110))
        if r > 22 then
            local snd = table.Random(blevotasfx)
            ply:EmitSound(snd)
            timer.Create("Blevota"..ply:EntIndex(),0.1,14,function()
                BloodParticle(ply:EyePos(),ply:EyeAngles():Forward()*150+Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))*30)
            end)
        else
            ply:EmitSound("ambient/voices/cough" .. math.random(1, 4) .. ".wav", 75, math.random(90, 110))
        end
        for key, obj in pairs(ents.FindInSphere(ply:GetPos(), 130)) do
			if not (obj == ply) and obj:IsPlayer() and CanSee(ply,obj) then
                obj.virus = obj.virus + math.random(0,3)
            end
        end
    end
end

hook.Add("HomigradDamage","PlayerZombVirus",function(ply,hitGroup,dmginfo,rag,armorMul)
    --print(dmginfo:GetAttacker():GetClass())
    if zombies[dmginfo:GetAttacker():GetClass()] then
        ply.virus = ply.virus + math.random(1,7)
        --print("zombbeeee")
    end
end)

util.AddNetworkString("info_virus")

hook.Add("Player Think","homigrad-virus",function(ply,time)
    if not ply:Alive() or ply:HasGodMode() then return end

	if (ply.virusNext or time) > time then return end
    ply.virus = ply.virus or 0
	ply.virusNext = time + 6
    ply.virusNextNet = ply.virusNextNet or 0

    if ply.informedaboutneuro then
        local Dmg = DamageInfo()

        Dmg:SetDamageType(DMG_NERVEGAS)
		Dmg:SetDamage(math.random(5, 10))
								
		Dmg:SetInflictor(ply)
		--Dmg:SetAttacker(ply)

        ply:TakeDamageInfo(Dmg)

        ply.KillReason = "ntoxin"

        local phrase = math.random(1,5)

        if phrase == 1 then
            ply:ChatPrint("Нейротоксин уничтожает твои ионные каналы.")
        elseif phrase == 2 then
            ply:ChatPrint("Нейротоксин уничтожает твои нервные клетки.")
            ply.pain = ply.pain + 30
            ply:SetNWBool("neurotoxinpripadok",true)
            ply:SetNWBool("neurotoxinshake",false)
            timer.Simple(0.1,function ()
                ply:SetNWBool("neurotoxinpripadok",false)
                ply:SetNWBool("neurotoxinshake",true)
            end)
        elseif phrase == 3 then
            ply:ChatPrint("Нейротоксин уничтожает твои лёгкие.")
            ply.Organs["lungs"]=ply.Organs["lungs"]-ply.Organs["lungs"]/4
            ply.stamina = ply.stamina - ply.stamina / 1.5
        elseif phrase == 4 then
            ply:ChatPrint("Тебя трясёт.")
            ply:SetNWBool("neurotoxinshake",true)
        elseif phrase == 5 then
            ply:ChatPrint("Тебя тошнит.")
            timer.Simple(1,function ()
                if not ply.fake then
                Faking(ply)
                end
                timer.Simple(0.2,function ()
                    ply:ConCommand("hg_blevota")   
                end)
            end)
        end
        
        JMod.TryCough(ply)
    end

    if ply.virus > 5 then
        ply.virus = ply.virus + 1

        if ply.virusNextNet <= time then
            ply.virusNextNet = time + 2
            net.Start("info_virus")
            net.WriteFloat(ply.virus)
            net.Send(ply)
        end
        ZsVirusCough(ply)
    end

    if ply.virus > 90 then
        ply.pain = 1000
    end

    if ply.virus > 100 then
		ply:Kill()
        ply.KillReason = "virus"
    end

end)

hook.Add("PlayerSpawn","homigrad-virus",function(ply)
	if PLYSPAWN_OVERRIDE then return end
    ply.virus = 0
    net.Start("info_virus")
    net.WriteFloat(ply.virus)
    net.Send(ply)
end)

hook.Add("PostPlayerDeath","RefreshPain",function(ply)
    ply.virus = 0
    ply:SetNWBool("neurotoxinshake",false)
    ply:SetNWBool("neurotoxinpripadok",false)
    net.Start("info_virus")
    net.WriteFloat(ply.virus)
    net.Send(ply)
end)

COMMANDS.virus = {function(ply,args)
	if not ply:IsAdmin() then return end

	for i,fply in pairs(player.GetListByName(args[1]) or {ply}) do
		fply.virus = fply.virus + 15
        ply:ChatPrint("DIE BITCH")
	end
end,1}

--[[COMMANDS.blevota = {function(ply,args)
	if not ply:IsAdmin() then return end

	for i,fply in pairs(player.GetListByName(args[1]) or {ply}) do
        local snd = table.Random(blevotasfx)
        fply:EmitSound(snd)
		timer.Create("Blevota"..fply:EntIndex(),0.1,15,function()
            --fply.Blood = fply.Blood - 25
            BloodParticle(fply:EyePos(),fply:EyeAngles():Forward()*150+Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))*30)
        end)
	end
end,1}]]--

concommand.Add( "hg_blevota", function( ply, cmd, args )
    if !ply:Alive() or ply.Otrub then return end
    local r = math.random(1,30)
    if r > 14 then
        local snd = table.Random(blevotasfx)
        if ply:GetNWBool("fake") then
            ply:GetNWEntity("Ragdoll"):EmitSound(snd)
        else
            ply:EmitSound(snd)
        end
        timer.Create("Blevota"..ply:EntIndex(),0.01,15,function()
            local ent = RagdollOwner(ply) or ply
            local att = ent:GetAttachment(ent:LookupAttachment("eyes"))
           --[[ if math.random(1,15) == 3 then
                ply["Organs"].artery = 0
                ply:ChatPrint("Ты не можешь остановиться блевать.")
            end]]
            ply.Blood = math.Clamp(ply.Blood - 0.5,0,5000)
            BloodParticle(att.Pos - att.Ang:Up() * 2,ply:EyeAngles():Forward()*150+VectorRand(-15,15)+ply:GetVelocity())
            BloodParticle(att.Pos - att.Ang:Up() * 2,ply:EyeAngles():Forward()*150+VectorRand(-15,15)+ply:GetVelocity())    
        end)
    else
        ply:ChatPrint("Ты не смог выблеваться.")
    end
end )

