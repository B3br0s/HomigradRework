local PlayerMeta = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")
util.AddNetworkString("fake")
util.AddNetworkString("RemoveRag")
util.AddNetworkString("DeadBodies")

local BlackListWep = {
	["weapon_hands"] = true
}

hg.ragdollFake = {}
hg.DeadBodies = {}

net.Receive("fake",function(len,ply)
	if !ply:Alive() then return end
    Faking(ply)
	
end)

function PlayerMeta:RagView()
	local ply = self
	ply:Spectate(OBS_MODE_CHASE)
	ply:SpectateEntity(ply:GetNWEntity("FakeRagdoll"))
	ply:UnSpectate()

	ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	ply:SetMoveType(MOVETYPE_OBSERVER)
end

function PlayerMeta:Notify(string)
	self:ChatPrint(tostring(string))
end

function PlayerMeta:CreateFake(force)
	--self:SelectWeapon("weapon_hands")
    local rag = ents.Create("prop_ragdoll")
    rag:SetModel(self:GetModel())
    rag:SetSkin(self:GetSkin())
    rag:SetNWEntity("RagdollOwner", self)
    rag:Spawn()
    rag:AddEFlags(EFL_NO_DAMAGE_FORCES)
    rag:Activate()
	--rag:GetPhysicsObject():SetPos(self:GetPos() - (self:Crouching() and Vector(0,0,-78) or Vector(0,0,64)))
	--rag:SetPos(self:GetPos() - (self:Crouching() and Vector(0,0,-78) or Vector(0,0,64)))
	self:SetPos(self:GetPos() + (self:KeyDown(IN_DUCK) and Vector(0,0,32) or Vector(0,0,0)))

	if not self:IsBot() and self.Appearance then
	ApplyAppearanceEntity(rag,self.Appearance)
	end

	rag:GetPhysicsObject():SetMass(30)

    rag:SetNetVar("Inventory", self.Inventory or self:GetNetVar("Inventory"))

    hg.ragdollFake[self] = rag
    self:RagView()
    self.FakeRagdoll = rag

    rag.IsBleeding = self.IsBleeding or false
    rag.NextBlood = 0

    if self then
        rag.blood = self.blood
    end

	local armors = {}

	if self.EZarmor then
		for id,info in pairs(self.EZarmor.items) do
			local ent = hg.CreateArmor(rag,info)
			ent.armorID = id
			ent.ragdoll = rag
			ent.Owner = self
			armors[id] = ent
	
			ent:CallOnRemove("Fake",Remove,self)
		end
	end

    self:SetNWEntity("FakeRagdoll", rag)

    force = force or Vector(0, 0, 0)
    local vel = self:GetVelocity() + force

    for i = 0, rag:GetPhysicsObjectCount() - 1 do
        local physobj = rag:GetPhysicsObjectNum(i)
        if IsValid(physobj) then
            local ragBoneName = rag:GetBoneName(rag:TranslatePhysBoneToBone(i))
            local bone = self:LookupBone(ragBoneName)

            if bone then
                local boneMat = self:GetBoneMatrix(bone)
                if boneMat then
                    physobj:SetPos(boneMat:GetTranslation() - Vector(0,0,32) or rag:GetPos(), true)
                    physobj:SetAngles(boneMat:GetAngles())
                    physobj:AddVelocity(vel)
                end
            end
        end
    end

    return rag
end

hook.Add("Think","VelocityFakeHitPlyCheck",function()
	for i,rag in pairs(ents.FindByClass("prop_ragdoll")) do
		if IsValid(rag) then
			if rag:GetVelocity():Length() > 300 then
				rag:SetCollisionGroup(COLLISION_GROUP_NONE)
			else
				rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			end
		end
	end
end)

hook.Add("PlayerSpawn","ResetFake",function(ply) --обнуление регдолла после вставания
	ply:Give("weapon_hands")
	ply.Fake = false
	ply:AddEFlags(EFL_NO_DAMAGE_FORCES)

	net.Start("RemoveRag")
	net.Send(ply)

	ply:SetNWBool("Fake",false)

	if PLYSPAWN_OVERRIDE then return end
	
	ply.slots = {}
	ply:SetNWEntity("Ragdoll",nil)
end)

hook.Add("Player Think","VelocityPlayerFallOnPlayerCheck",function(ply,time)
	local speed = ply:GetVelocity():Length()
	if ply:GetMoveType() ~= MOVETYPE_NOCLIP and not ply.Fake and not ply:HasGodMode() and ply:Alive() then
		if speed < 600 then return end

		Faking(ply)
	end
end)

hook.Add("WeaponEquip","Homigrad_Fake",function(wep,ply)
end)

hook.Add("PlayerSwitchWeapon","Homigrad_Fake_Guns",function(ply,wep,oldwep)
	if not IsValid(ply) then return end
	if wep == NULL then return end
	if oldwep == NULL then return end
	if !ply.Fake then
		ply.CurWeapon = wep:GetClass()
	else
		if IsValid(ply.FakeWep) then
			ply.FakeWep:Remove()
			ply.FakeWep = nil
		end
		ply.CurWeapon = oldwep:GetClass()
	end
	if not ply.Fake then return false end
	if ply.Fake then return true end
end)

function Faking(ply,force)
    if not IsValid(ply) then return end

	if ply:Alive() and !ply.CanMove then return end

    if ply.LastRagdollTime and ply.LastRagdollTime > CurTime() then
        return
    end

    ply.LastRagdollTime = CurTime() + 1.5

    if not ply.Fake then
		--ply:SelectWeapon("weapon_hands")
		ply.FakeWeps = ply:GetWeapons()
		ply.CurWeapon = ply:GetActiveWeapon()
		ply.FakeWep = nil
        ply.Fake = true
        ply:CreateFake((force != nil and force or ply:GetVelocity() / 1.5))
		ply:SetNWBool("Fake",ply.Fake)
		ply:SetNWEntity("FakeRagdoll",ply.FakeRagdoll)
		ply:SetActiveWeapon(nil)
        --hg.AppearanceRagdoll(ply.FakeRagdoll, ply)
        hg.ragdollFake[ply] = ply.FakeRagdoll
    else
		if IsValid(ply.FakeWep) then
			ply.FakeWep:Remove()
		end
		ply.FakeWep = nil
		if ply.FakeRagdoll and constraint.FindConstraints(ply.FakeRagdoll,"Weld") and ply.FakeRagdoll.DuctTape then
			return
		end

		if IsValid(ply.FakeRagdoll) and ply.FakeRagdoll:GetVelocity():Length() > 500 then
			return
		end

		if not IsValid(ply) or not ply:Alive() or (ply and ply.brokenspine) then
		    return
		end

		if ply.pain>(50*(ply.blood/5000))+(ply:GetNWInt("SharpenAMT")*5) or ply.blood<3000 then return end

        local health = ply:Health()
        local eyeAngles = ply:EyeAngles()
        ply:UnSpectate()
        ply:SetVelocity(Vector(0, 0, 0))

        local spawnPos = IsValid(ply.FakeRagdoll) and ply.FakeRagdoll:GetPos() or (ply:GetPos() + Vector(0, 0, 64))

		if JMod then
        JMod.Иди_Нахуй = true
		end
        PLYSPAWN_OVERRIDE = true
        ply:Spawn()
        ply.CanMove = false
        ply:SetHealth(health)
        ply:SetEyeAngles(eyeAngles)
        if JMod then
		JMod.Иди_Нахуй = nil
		end
        ply:SetPos(spawnPos)
		ply.CurWeapon = nil
		ply.FakeShooting = false
        PLYSPAWN_OVERRIDE = false

		ply.FakeRagdoll:Remove()

        ply.Fake = false
		ply.CanMove = true
        hg.ragdollFake[ply] = NULL
    end
end

hook.Add("PlayerSay","DroppingFunction",function(ply,text)
	if ply:GetActiveWeapon() == NULL and !ply.Fake then return "" end
    if text == "*drop" then
        if not ply.Fake and not BlackListWep[ply:GetActiveWeapon():GetClass()] == true then
            ply:DropWeapon()
            ply:SelectWeapon("weapon_hands")
		elseif ply.Fake and not BlackListWep[ply.CurWeapon] == true then
			ply:StripWeapon(ply.CurWeapon)
			constraint.RemoveAll(ply.FakeWep)
			ply.FakeWep:GetPhysicsObject():EnableCollisions(true)
			ply.FakeWep = nil
        end
        return ""
    end
end)

hook.Add("PreCleanupMap","CleanUpFake",function()
	for i, v in pairs(player.GetAll()) do
		v.LastRagdollTime = 0
		if v.Fake then Faking(v) end
	end
	BleedingEntities = {}
end)

util.AddNetworkString("nodraw_helmet")

hook.Add("PlayerUse","UsingInFake",function(ply,ent)
	if ply.Fake then return false end
end)

function RagdollOwner(ent)
	return ent:GetNWEntity("RagdollOwner").FakeRagdoll == ent and ent:GetNWEntity("RagdollOwner") 
end

function hg.CreateArmor(ragdoll,info)
	local item = JMod.ArmorTable[info.name]
	if not item then return end

	local Index = ragdoll:LookupBone(item.bon)
	if not Index then return end

	local Pos,Ang = (ply or ragdoll):GetBonePosition(Index)
	if not Pos then return end

	local ent = ents.Create(item.ent)

	local Right,Forward,Up = Ang:Right(),Ang:Forward(),Ang:Up()
	Pos = Pos + Right * item.pos.x + Forward * item.pos.y + Up * item.pos.z

	Ang:RotateAroundAxis(Right,item.ang.p)
	Ang:RotateAroundAxis(Up,item.ang.y)
	Ang:RotateAroundAxis(Forward,item.ang.r)

	ent.IsArmor = true
	ent:SetPos(Pos)
	ent:SetAngles(Ang)

	local color = info.col

	ent:SetColor(Color(color.r,color.g,color.b,color.a))

	ent:Spawn()
	ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	if IsValid(ent:GetPhysicsObject()) then
		ent:GetPhysicsObject():SetMaterial("plastic")
		ent:GetPhysicsObject():EnableCollisions(false)
		ent:GetPhysicsObject():SetMass(0)
	end

	timer.Simple(0.1,function()
		local ply = hg.RagdollOwner(ragdoll)
		if item.bon == "ValveBiped.Bip01_Head1" and ply and IsValid(ply) and  ply:IsPlayer() then
			net.Start("nodraw_helmet")
			net.WriteEntity(ent)
			net.Send(ply)
		end
	end)

	constraint.Weld(ent,ragdoll,0,ragdoll:TranslateBoneToPhysBone(Index),0,true,false)

	ragdoll:DeleteOnRemove(ent)

	return ent
end

function hg.Remove(self,ply)
	if self.override then return end

	self.ragdoll.armors[self.armorID] = nil
	JMod.RemoveArmorByID(ply,self.armorID,true)
end

function hg.Faking(ply)
	Faking(ply)
end

hook.Add("DoPlayerDeath", "DeathRagdoll", function(ply, att, dmginfo)
	if hg.Gibbed[ply] then return end
	if IsValid(ply.FakeRagdoll) then
	local rag = ply.FakeRagdoll
	rag = ply

	rag.Items = {}

	rag.CantCheckPulse = false
	rag.alive = false
	rag.o2 = 0
	rag.pulse = 0
	rag.heartstop = true

	constraint.RemoveAll(rag)
	return
	end
	ply.LastRagdollTime = 0
	Faking(ply)

	local rag = ply.FakeRagdoll

	rag = ply or {}

    rag.Items = {}

	rag.CantCheckPulse = false
	rag.alive = false
	rag.o2 = 0
	rag.pulse = 0
	rag.heartstop = true

	--Выдавание оружия рагдоллу
    for _, wep in ipairs(ply:GetWeapons()) do
        if not BlackListWep[wep:GetClass()] then
            table.insert(rag.Items, wep)
        end
    end

	table.insert(hg.DeadBodies,rag)

	net.Start("DeadBodies")
	net.WriteTable(hg.DeadBodies)
	net.Broadcast()
end)

hook.Add("PlayerUse","KysUseInFake",function(ply)
	if ply.Fake then return false end
end)

hook.Add("PhysgunPickup", "DropPlayer2", function(ply,ent)
		if ent:IsPlayer() and !ent.Fake and ply:IsSuperAdmin() then

			ent.isheld=true

			Faking(ent)
			return false
		end
end)

hook.Add("Player Think","FakeControl",function(ply,time)
	ply:SetNWBool("Fake",ply.Fake)
	ply:SetNWEntity("FakeRagdoll",ply.FakeRagdoll)
    if not ply.Fake or not ply:Alive() then ply:SetNWBool("RightArm",false) ply:SetNWBool("LeftArm",false) return end
    local rag = ply.FakeRagdoll
	if rag == NULL then return end
	rag:SetNWVector("PlayerColor",ply:GetPlayerColor())
	if not IsValid(rag) then ply:Kill() ply.Fake = false ply.FakeRagdoll = NULL return end
	if ply.otrub then return end
	rag = ply.FakeRagdoll
	
	ply:SetActiveWeapon(NULL)

	if ply:InVehicle() then
		ply:ExitVehicle()
	end
	local AddVecRag = Vector(0,0,-64)
    local Head = rag:LookupBone("ValveBiped.Bip01_Head1")
	if not Head then return end
    local HeadPos = rag:GetBonePosition(Head) + AddVecRag
	ply:SetNWBool("Fake",ply.Fake)
	ply:SetPos(HeadPos)
	rag:SetNetVar("Inventory",ply:GetNetVar("Inventory"))
    rag:SetFlexWeight(9,0)
	local dist = (rag:GetAttachment(rag:LookupAttachment( "eyes" )).Ang:Forward()*10000):Distance(ply:GetAimVector()*10000)
	local distmod = math.Clamp(1-(dist/20000),0.1,1)
	local lookat = LerpVector(distmod,rag:GetAttachment(rag:LookupAttachment( "eyes" )).Ang:Forward()*100000,ply:GetAimVector()*100000)
	local attachment = rag:GetAttachment( rag:LookupAttachment( "eyes" ) )
	local LocalPos, LocalAng = WorldToLocal( lookat, Angle( 0, 0, 0 ), attachment.Pos, attachment.Ang )
	local Head = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Head1" )) )
	local Neck = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Neck1" )) )
	local Spine4 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine4" )) )
	local Spine2 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine2" )) )
	local Spine1 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine1" )) )
	local Spine = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine" )) )
	local CalfR = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Calf" )) )
	local CalfL = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Calf" )) )
	local FArmL = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Forearm" )) )
	local FArmR = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Forearm" )) )
	--print(rag:WorldToLocalAngles(Head:GetAngles()))
	--print(Head:GetAngles())
    local eyeangs = ply:EyeAngles()
	if !ply.otrub then rag:SetEyeTarget( LocalPos ) else rag:SetEyeTarget( Vector(0,0,0) ) end


    local HeadAngles, HeadPosition = WorldToLocal(Spine2:GetPos(), Spine2:GetAngles(),Head:GetPos(), Head:GetAngles() )


    local yaw = HeadAngles[2] % 360
    if yaw > 180 then
        yaw = yaw - 360
    end

	yaw = yaw / 1.1

	--PrintMessage(3,yaw)

    if ply.LastRagdollTime < CurTime() then
        if yaw > 6 or yaw < -6 then
			ply.KillReason = "NeckSnap"
            if ply:Alive() then
			ply:Kill()
            end
            sound.Play("homigrad/player/neck_snap_01.wav", rag:GetPos() + Vector(0, 0, 20), 75, 100, 1, 0)
        end
    end

	if ply.otrub then return end
	if IsValid(rag.ZacConsLH) then
		ply:SetNWBool("LeftArm",true)
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(0,10,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger01"),Angle(0,20,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger1"),Angle(0,-10,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger11"),Angle(0,-40,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger2"),Angle(0,-10,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger21"),Angle(0,-40,0))
	else
		ply:SetNWBool("LeftArm",false)
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger01"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger1"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger11"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger2"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger21"),Angle(0,0,0))
	end
	if not ply.FakeShooting then
	if IsValid(rag.ZacConsRH) then
		ply:SetNWBool("RightArm",true)
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger0"),Angle(0,10,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger01"),Angle(0,20,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger1"),Angle(0,-10,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger11"),Angle(0,-40,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger2"),Angle(0,-10,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger21"),Angle(0,-40,0))
	else
		ply:SetNWBool("RightArm",false)
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger0"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger01"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger1"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger11"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger2"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger21"),Angle(0,0,0))
	end
		else
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger0"),Angle(0,10,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger01"),Angle(0,20,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger1"),Angle(10,20,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger11"),Angle(0,0,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger2"),Angle(0,-10,0))
		rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger21"),Angle(0,-40,0))
	end

	local HeadAng = ply:EyeAngles()
	HeadAng:RotateAroundAxis(HeadAng:Forward(),90)
	HeadAng:RotateAroundAxis(HeadAng:Up(),90)

	if ply:KeyDown(IN_ATTACK) and not ply.FakeShooting then
		local pos = ply:EyePos()
		pos[3] = Head:GetPos()[3]
		local phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_L_Hand")))
		local ang = ply:EyeAngles()
		ang:RotateAroundAxis(eyeangs:Forward(), 50)
		ang:RotateAroundAxis(eyeangs:Right(), 155)
		local shadowparams = {
			secondstoarrive = 0.125,
			pos = Head:GetPos() + eyeangs:Forward() * 35 + eyeangs:Right() * -12,
			angle = ang,
			maxangular = 670,
			maxangulardamp = 600,
			maxspeeddamp = 50,
			maxspeed = 500,
			teleportdistance = 0,
			deltatime = 0.01,
		}

		phys:Wake()
		phys:ComputeShadowControl(shadowparams)
	end

	if ply:KeyDown(IN_ATTACK2) then
		local pos = ply:EyePos()
		pos[3] = Head:GetPos()[3]
		local phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Hand")))
		if not ply.FakeShooting then
		local ang = ply:EyeAngles()
		ang:RotateAroundAxis(eyeangs:Forward(), 100)
		ang:RotateAroundAxis(eyeangs:Right(), 155)
		local shadowparams = {
			secondstoarrive = 0.125,
			pos = Head:GetPos() + eyeangs:Forward() * 35 + eyeangs:Right() * 12,
			angle = ang,
			maxangular = 670,
			maxangulardamp = 600,
			maxspeeddamp = 50,
			maxspeed = 500,
			teleportdistance = 0,
			deltatime = 0.01,
		}

		phys:Wake()
		phys:ComputeShadowControl(shadowparams)
		else
		local phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Hand")))
		local phys2 = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_L_Hand")))
		local ang = ply:EyeAngles()
		ang:RotateAroundAxis(eyeangs:Forward(), 162)
		ang:RotateAroundAxis(eyeangs:Up(), -10)
		ang:RotateAroundAxis(eyeangs:Right(), -30)
		local shadowparams = {
			secondstoarrive = 0.001,
			pos = Head:GetPos() + eyeangs:Forward() * 22 + eyeangs:Right() * 5,
			angle = ang,
			maxangular = 670,
			maxangulardamp = 600,
			maxspeeddamp = 50,
			maxspeed = 1500,
			teleportdistance = 0,
			deltatime = 0.01,
		}

		phys:Wake()
		phys:ComputeShadowControl(shadowparams)
		end
	end

	if ply:KeyDown(IN_USE) then
		local phys = Spine4
		local phys2 = Spine2
		local phys3 = Head
		local angs = ply:EyeAngles()
		angs:RotateAroundAxis(angs:Forward(),-90)
		local ang2 = ply:EyeAngles()
		--ang2:RotateAroundAxis(angs:Forward(),-90)

		local shadowparams2 = {
			secondstoarrive=(IsValid(rag.ZacConsLH) or IsValid(rag.ZacConsRH)) and 1.5 or 0.3,
			pos=phys2:GetPos() + (IsValid(rag.ZacConsLH) and Vector(0,0,5) or IsValid(rag.ZacConsRH) and Vector(0,0,5) or Vector(0,0,0)),
			angle=ang2 + Angle(50,0,0),
			maxangulardamp=10,
			maxspeeddamp=10,
			maxangular=370,
			maxspeed=30,
			teleportdistance=0,
			deltatime=deltatime,
		}

		local shadowparams = {
			secondstoarrive=(IsValid(rag.ZacConsLH) or IsValid(rag.ZacConsRH)) and 1.5 or 0.3,
			pos=phys:GetPos(),
			angle=angs - Angle(100,0,0),
			maxangulardamp=10,
			maxspeeddamp=10,
			maxangular=370,
			maxspeed=30,
			teleportdistance=0,
			deltatime=deltatime,
		}

		phys2:Wake()
		phys2:ComputeShadowControl(shadowparams)
		phys:Wake()
		phys:ComputeShadowControl(shadowparams)
	end

	local HeadShadow = {
		secondstoarrive=0.0000000001 / 1e8,
		pos=Head:GetPos(),
		angle=HeadAng,
		maxangulardamp=10,
		maxspeeddamp=10,
		maxangular=370,
		maxspeed=30,
		teleportdistance=0,
		deltatime=deltatime,
	}

	Head:Wake()
	Head:ComputeShadowControl(HeadShadow)

	if ply:KeyDown(IN_SPEED) then
		local bone = rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_L_Hand"))
		local phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_L_Hand")))
		if not IsValid(rag.ZacConsLH) and (not rag.ZacNextGrLH or rag.ZacNextGrLH <= CurTime()) then
			rag.ZacNextGrLH = CurTime() + 0.1
			for i = 1, 3 do
				local offset = phys:GetAngles():Up() * 5
				if i == 2 then
					offset = phys:GetAngles():Right() * 5
				end

				if i == 3 then
					offset = phys:GetAngles():Right() * -5
				end

				local traceinfo = {
					start = phys:GetPos(),
					endpos = phys:GetPos() + offset,
					filter = rag,
					output = trace,
				}

				local trace = util.TraceLine(traceinfo)
				if trace.Hit and not trace.HitSky then
					local cons = constraint.Weld(rag, trace.Entity, bone, trace.PhysicsBone, 0, false, false)
					if IsValid(cons) then
						rag.ZacConsLH = cons
					end

					break
				end
			end
		end
	else
		if IsValid(rag.ZacConsLH) then
			rag.ZacConsLH:Remove()
			rag.ZacConsLH = nil
		end
	end

	if ply:KeyDown(IN_WALK) and not ply.FakeShooting then
		local bone = rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Hand"))
		local phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Hand")))
		if not IsValid(rag.ZacConsRH) and (not rag.ZacNextGrRH or rag.ZacNextGrRH <= CurTime()) then
			rag.ZacNextGrRH = CurTime() + 0.1
			for i = 1, 3 do
				local offset = phys:GetAngles():Up() * 5
				if i == 2 then
					offset = phys:GetAngles():Right() * 5
				end

				if i == 3 then
					offset = phys:GetAngles():Right() * -5
				end

				local traceinfo = {
					start = phys:GetPos(),
					endpos = phys:GetPos() + offset,
					filter = rag,
					output = trace,
				}

				local trace = util.TraceLine(traceinfo)
				if trace.Hit and not trace.HitSky then
					local cons = constraint.Weld(rag, trace.Entity, bone, trace.PhysicsBone, 0, false, false)
					if IsValid(cons) then
						rag.ZacConsRH = cons
					end

					break
				end
			end
		end
	else
		if IsValid(rag.ZacConsRH) then
			rag.ZacConsRH:Remove()
			rag.ZacConsRH = nil
		end
	end

	if ply:KeyDown(IN_FORWARD) and IsValid(rag.ZacConsLH) then
		local phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_Spine4")))
		local lh = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_L_Hand")))
		local angs = ply:EyeAngles()
		angs:RotateAroundAxis(angs:Forward(), 90)
		angs:RotateAroundAxis(angs:Up(), 90)
		local speed = 70
		if rag.ZacConsLH.Ent2:GetVelocity():LengthSqr() < 1000 then
			local shadowparams = {
				secondstoarrive = 0.35,
				pos = lh:GetPos() + (ply:EyeAngles() - Angle(60,0,0)):Up() * -95 + (ply:EyeAngles() - Angle(60,0,0)):Forward() * (ply:KeyDown(IN_USE) and 155 or 10),
				angle = phys:GetAngles(),
				maxangulardamp = 10,
				maxspeeddamp = 10,
				maxangular = 30,
				maxspeed = speed,
				teleportdistance = 0,
				deltatime = deltatime,
			}

			phys:Wake()
			phys:ComputeShadowControl(shadowparams)
		end
	end

	if ply:KeyDown(IN_FORWARD) and IsValid(rag.ZacConsRH) then
		local phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_Spine4")))
		local rh = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Hand")))
		local angs = ply:EyeAngles()
		angs:RotateAroundAxis(angs:Forward(), 90)
		angs:RotateAroundAxis(angs:Up(), 90)
		local speed = 70
		if rag.ZacConsRH.Ent2:GetVelocity():LengthSqr() < 1000 then
			local shadowparams = {
				secondstoarrive = 0.35,
				pos = rh:GetPos() + (ply:EyeAngles() - Angle(60,0,0)):Up() * -95 + (ply:EyeAngles() - Angle(60,0,0)):Forward() * (ply:KeyDown(IN_USE) and 155 or 10),
				angle = phys:GetAngles(),
				maxangulardamp = 10,
				maxspeeddamp = 10,
				maxangular = 30,
				maxspeed = speed,
				teleportdistance = 0,
				deltatime = deltatime,
			}

			phys:Wake()
			phys:ComputeShadowControl(shadowparams)
		end
	end

	if ply:KeyDown(IN_BACK) and IsValid(rag.ZacConsLH) then
		local phys = rag:GetPhysicsObjectNum(1)
		local chst = rag:GetPhysicsObjectNum(0)
		local angs = ply:EyeAngles()
		angs:RotateAroundAxis(angs:Forward(), 90)
		angs:RotateAroundAxis(angs:Up(), 90)
		local speed = 50
		if rag.ZacConsLH.Ent2:GetVelocity():LengthSqr() < 1000 then
			local shadowparams = {
				secondstoarrive = 0.7,
				pos = chst:GetPos() + (ply:EyeAngles() - Angle(60,0,0)):Up() * 95 + (ply:EyeAngles()):Forward() * -(ply:KeyDown(IN_USE) and 155 or 10),
				angle = phys:GetAngles(),
				maxangulardamp = 10,
				maxspeeddamp = 10,
				maxangular = 30,
				maxspeed = speed,
				teleportdistance = 0,
				deltatime = deltatime,
			}

			phys:Wake()
			phys:ComputeShadowControl(shadowparams)
		end
	end

	if ply:KeyDown(IN_BACK) and IsValid(rag.ZacConsRH) then
		local phys = rag:GetPhysicsObjectNum(1)
		local chst = rag:GetPhysicsObjectNum(0)
		local angs = ply:EyeAngles()
		angs:RotateAroundAxis(angs:Forward(), 90)
		angs:RotateAroundAxis(angs:Up(), 90)
		local speed = 50
		if rag.ZacConsRH.Ent2:GetVelocity():LengthSqr() < 1000 then
			local shadowparams = {
				secondstoarrive = 0.7,
				pos = chst:GetPos() + (ply:EyeAngles() - Angle(60,0,0)):Up() * 95 + (ply:EyeAngles()):Forward() * -(ply:KeyDown(IN_USE) and 155 or 10),
				angle = phys:GetAngles(),
				maxangulardamp = 10,
				maxspeeddamp = 10,
				maxangular = 30,
				maxspeed = speed,
				teleportdistance = 0,
				deltatime = deltatime,
			}

			phys:Wake()
			phys:ComputeShadowControl(shadowparams)
		end
	end
end)

hook.Add("Player Collide","Ragdolling-Collide",function(ply,ent,data)
	local LIMIT_MASS = 100
	local LIMIT_SPEED = 200
	if ent:GetVelocity():Length() > LIMIT_SPEED or ent:GetPhysicsObject():GetMass() > LIMIT_MASS and ent:GetVelocity():Length() > LIMIT_SPEED / 2 then
		timer.Simple(0,function()
			if not IsValid(ply) or ply.Fake then return end
			Faking(ply)
		end)
	end
end)