local PlayerMeta = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")
util.AddNetworkString("fake")
util.AddNetworkString("RemoveRag")
util.AddNetworkString("DeadBodies")

local BlackListWep = {
	["weapon_hands"] = true
}

hg.ragdollFake = {}

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
    local rag = ents.Create("prop_ragdoll")
    rag:SetModel(self:GetModel())
    rag:SetSkin(self:GetSkin())
    rag:SetNWEntity("RagdollOwner", self)
    rag:Spawn()
    rag:AddEFlags(EFL_NO_DAMAGE_FORCES)
	rag:SetNWVector("PlayerColor",self:GetPlayerColor())
    rag:Activate()

	if ROUND_NAME == "dr" then
		self.TimeToDeath = CurTime() + 6
		self:SetNWFloat("TimeToDeath",CurTime() + 6)
	end

	//print(self.AppearanceOverride)
	if not self:IsBot() and self.Appearance and !self.AppearanceOverride then
	ApplyAppearanceEntity(rag,self.Appearance)
	end
	
	rag.Appearance = self.Appearance

	rag:SetNWString("PlayerName",self:Name())
	rag:GetPhysicsObject():SetMass(30)

    self.FakeRagdoll = rag

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
                    physobj:SetPos(boneMat:GetTranslation(), true)
                    physobj:SetAngles(boneMat:GetAngles())
                    physobj:AddVelocity(vel)
                end
            end
        end
    end

    self:RagView()

    return rag
end

hook.Add("Think","VelocityFakeHitPlyCheck",function()
	for i,rag in pairs(ents.FindByClass("prop_ragdoll")) do
		if IsValid(rag) then
			if rag:GetVelocity():Length() > 200 then
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

	if ply.PLYSPAWN_OVERRIDE then return end
	
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

	if force then
		force = force / 3
	end

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
        ply:CreateFake((force or ply:GetVelocity() / 3))
		ply:SetNWBool("Fake",ply.Fake)
		ply:SetNWEntity("FakeRagdoll",ply.FakeRagdoll)
		ply:SetActiveWeapon(nil)
        ply.Fake = true
    else
		if ply:GetNWBool("Cuffed") or IsValid(ply.FakeRagdoll) and ply.FakeRagdoll:GetNWBool("Cuffed") then
			return
		end
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
        ply.PLYSPAWN_OVERRIDE = true
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
        ply.PLYSPAWN_OVERRIDE = false

		ply.FakeRagdoll:Remove()

        ply.Fake = false
		ply.CanMove = true
        hg.ragdollFake[ply] = NULL
    end
end

function PlayerMeta:DropWep(wep,pos,vel,suicide)
	local ply = self
	if not vel then
		vel = self:EyeAngles():Forward() * 120
	end
	if IsValid(ply:GetActiveWeapon()) and not BlackListWep[ply:GetActiveWeapon():GetClass()] == true then
		if wep == nil then
			wep = ply:GetActiveWeapon()
		end
		wep.IsSpawned = true
		ply:DropWeapon(wep,pos,vel)
		if suicide then
			local angs = ply:GetAngles()
			angs.pitch = 0
			angs:RotateAroundAxis(angs:Up(),90)
			angs:RotateAroundAxis(angs:Right(),90)
			local angs2 = ply:GetAngles()
			angs2.pitch = 0
			wep:GetPhysicsObject():SetAngles(angs)
			wep:GetPhysicsObject():SetPos(ply:EyePos() - angs2:Up() * 40 + angs2:Forward() * 10 + angs2:Right() * 0)
			wep:GetPhysicsObject():SetAngleVelocity(Vector(0,128,0))
			wep:GetPhysicsObject():SetVelocity(vel * (3 * (wep.NumBullet != nil and wep.NumBullet or 1)))

			timer.Simple(0,function()
				local rag = ply.FakeRagdoll
				if !IsValid(rag) then
					return
				end
				local angs = ply:GetAngles()
				angs.pitch = 0

				local head = rag:GetBoneMatrix(6)
				local head_phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(6))

				head_phys:ApplyForceCenter(angs:Forward() * -2500 + angs:Up() * 5000 + angs:Right() * (wep:IsPistolHoldType() and -2500 or 0))
				head_phys:SetAngleVelocity(Vector(180,0,90))
			end)
		end
		if ply.Fake and ply:Alive() then
			local Mat = ply.FakeRagdoll:GetBoneMatrix(6)
			wep:SetPos(Mat:GetTranslation() + ply:EyeAngles():Forward() * 30)
			wep:SetVelocity(ply:EyeAngles():Forward() * 100)
		end
		timer.Simple(0,function()
			if !ply:Alive() and !suicide and math.random(1,250) != 25 then
				timer.Simple(0,function()
					local rag = ply.FakeRagdoll
	
					local lh = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_L_Hand")))
					local rh = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Hand")))
					if not IsValid(rh) then return end

					local pos = rh:GetPos()
	
					local rhandpos = (!wep.ismelee and wep.RHandPos or (wep.weaponPos != nil and wep.weaponPos or Vector(0,0,0)))

					local aim = wep.AimHands

					local angles = rh:GetAngles()
        
        			local forward,right,up =  rhandpos[1], -rhandpos[2],rhandpos[3]
        			pos:Add(angles:Forward() * forward + angles:Right() * right + angles:Up() * up)

					angles:RotateAroundAxis(angles:Right() ,180)
					angles:RotateAroundAxis(angles:Up() ,180)
					
					local phys = wep:GetPhysicsObject()

					wep:SetPos(pos)
					wep:SetAngles(angles)

					rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger0"),Angle(0,10,0))
					rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger01"),Angle(0,20,0))
					rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger1"),Angle(0,10,0))
					rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger11"),Angle(0,-40,0))
					rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger2"),Angle(0,-30,0))
					rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger21"),Angle(0,-40,0))
					
					local cons = constraint.Weld(wep, rag, 0, rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Hand")), 0, true)
					if IsValid(cons) then ply.WepCons = cons end

					timer.Simple(1,function()
						if math.random(1,4) == 2 then
							if rh:GetVelocity():Length() > 200 then
								cons:Remove()
								wep:GetPhysicsObject():ApplyForceCenter(wep:GetAngles():Forward() * 150)

								wep:FireBullet()

								rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger0"),Angle(0,0,0))
								rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger01"),Angle(0,0,0))
								rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger1"),Angle(0,0,0))
								rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger11"),Angle(0,0,0))
								rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger2"),Angle(0,0,0))
								rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger21"),Angle(0,0,0))
							end
						end
					end)
					-- rh:EnableMotion(false)
				end)
			end
		end)
		return wep
	end
end

hook.Add("PlayerSay","DroppingFunction",function(ply,text)
	if ply:GetActiveWeapon() == NULL then return "" end
    if text == "*drop" then
		ply:DropWep(nil,nil,ply:EyeAngles():Forward() * 160)
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

hg.Faking = Faking

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

	if IsValid(rag.ZacConsRH) then
		rag.ZacConsRH:Remove()
	end

	if IsValid(rag.ZacConsLH) then
		rag.ZacConsLH:Remove()
	end

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
	if !IsValid(ply:GetActiveWeapon()) and !ply.Fake and ply:Alive() then
		ply:SelectWeapon("weapon_hands")
	end
	ply:SetNWBool("Fake",ply.Fake)
	ply:SetNWEntity("FakeRagdoll",ply.FakeRagdoll)
    if not ply.Fake or not ply:Alive() then ply:SetNWBool("RightArm",false) ply:SetNWBool("LeftArm",false) return end
    local rag = ply.FakeRagdoll
	if not IsValid(rag) then ply:Kill() return end
	if rag == NULL then return end
	if ROUND_NAME == "dr" then
		if ply.TimeToDeath and ply.TimeToDeath < CurTime() then
			ply:Kill()
			rag:Dissolve(2,0,rag:GetPos())
			/*net.Start("blood particle explode")
            net.WriteVector(rag:GetPos())
            net.WriteVector(rag:GetPos() + vector_up:Angle():Up() * 10)
            net.Broadcast()
            net.Start("bp fall")
            net.WriteVector(rag:GetPos())
            net.WriteVector(rag:GetPos() + vector_up:Angle():Up() * 10)
            net.Broadcast()
			rag:Remove()*/
		end
	end
	ply:SetNWBool("RightArm",IsValid(rag.ZacConsRH))
	ply:SetNWBool("LeftArm",IsValid(rag.ZacConsLH))
	local dist = (rag:GetAttachment(rag:LookupAttachment( "eyes" )).Ang:Forward()*10000):Distance(ply:GetAimVector()*10000)
	local distmod = math.Clamp(1-(dist/20000),0.1,1)
	local lookat = LerpVector(distmod,rag:GetAttachment(rag:LookupAttachment( "eyes" )).Ang:Forward()*100000,ply:GetAimVector()*100000)
	local attachment = rag:GetAttachment( rag:LookupAttachment( "eyes" ) )
	local LocalPos, LocalAng = WorldToLocal( lookat, Angle( 0, 0, 0 ), attachment.Pos, attachment.Ang )
	local AddVecRag = Vector(0,0,-64)
    local Head = rag:LookupBone("ValveBiped.Bip01_Head1")
	if not Head then return end
    local HeadPos = rag:GetBonePosition(Head) + AddVecRag
	ply:SetPos(HeadPos)
	if !ply.otrub then rag:SetEyeTarget( LocalPos ) else rag:SetEyeTarget( Vector(0,0,0) ) end
	if ply.otrub then
		if IsValid(rag.ZacConsRH) then
			rag.ZacConsRH:Remove()
		end
	
		if IsValid(rag.ZacConsLH) then
			rag.ZacConsLH:Remove()
		end
	return
	end
	rag = ply.FakeRagdoll
	
	ply:SetActiveWeapon(NULL)

	if ply:InVehicle() then
		ply:ExitVehicle()
	end
	ply:SetNWBool("Fake",ply.Fake)
	rag:SetNetVar("Inventory",ply:GetNetVar("Inventory"))
    rag:SetFlexWeight(9,0)
	local Head = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Head1" )) )
	local Neck = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Neck1" )) )
	local Spine4 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine4" )) )
	local Spine2 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine2" )) )
	local Spine1 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine1" )) )
	local Spine = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine" )) )
	local Penis = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Pelvis" )) )
	local CalfR = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Calf" )) )
	local CalfL = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Calf" )) )
	local FArmL = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Forearm" )) )
	local FArmR = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Forearm" )) )
    local eyeangs = ply:EyeAngles()

    local HeadAngles, HeadPosition = WorldToLocal(Spine2:GetPos(), Spine2:GetAngles(),Head:GetPos(), Head:GetAngles() )

	if ply.otrub then return end

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
			secondstoarrive = 0.05,
			pos = Head:GetPos() + eyeangs:Forward() * 35 + eyeangs:Right() * -12,
			angle = ang,
			maxangular = 670,
			maxangulardamp = 600,
			maxspeeddamp = 150,
			maxspeed = 800,
			teleportdistance = 0,
			deltatime = 0.01,
		}

		phys:Wake()
		phys:ComputeShadowControl(shadowparams)
		//FArmL:Wake()
		//FArmL:ComputeShadowControl(shadowparams)
	end

	if ply:KeyDown(IN_ATTACK2) then
		local pos = ply:EyePos()
		pos[3] = Head:GetPos()[3]
		local phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Hand")))
		local ang = ply:EyeAngles()
		ang:RotateAroundAxis(eyeangs:Forward(), 50)
		ang:RotateAroundAxis(eyeangs:Right(), 155)
		local shadowparams = {
			secondstoarrive = 0.05,
			pos = Head:GetPos() + eyeangs:Forward() * 35 + eyeangs:Right() * 12,
			angle = ang,
			maxangular = 670,
			maxangulardamp = 600,
			maxspeeddamp = 150,
			maxspeed = 800,
			teleportdistance = 0,
			deltatime = 0.01,
		}

		phys:Wake()
		phys:ComputeShadowControl(shadowparams)
		//FArmR:Wake()
		//FArmR:ComputeShadowControl(shadowparams)
	end

	if ply:KeyDown(IN_USE) then
		local phys = Spine4
		local phys2 = Spine2
		local phys3 = Spine1
		local phys4 = Penis
		local angs = ply:EyeAngles()
		angs:RotateAroundAxis(angs:Forward(),-85)
		angs:RotateAroundAxis(angs:Up(),-100)
		angs:RotateAroundAxis(angs:Right(),0)

		local velo = rag:GetVelocity():Length() / 7

		if velo < 1 then
			velo = 1
		end

		//print(velo)

		local shadowparams2 = {
			secondstoarrive=0.7,
			pos=phys2:GetPos() + (IsValid(rag.ZacConsLH) and Vector(0,0,7) or IsValid(rag.ZacConsRH) and Vector(0,0,7) or Vector(0,0,0)),
			angle=angs,
			maxangulardamp=0.01/1e8,
			maxspeeddamp=0.01/1e8,
			maxangular=1e8,
			maxspeed=40 / velo,
			teleportdistance=0,
			deltatime=deltatime,
		}

		local shadowparams = {
			secondstoarrive=0.25,
			pos=phys:GetPos(),
			angle=angs,
			maxangulardamp=0.01/1e8,
			maxspeeddamp=0.01/1e8,
			maxangular=1e8,
			maxspeed=30 / velo,
			teleportdistance=0,
			deltatime=deltatime,
		}

		phys2:Wake()
		phys2:ComputeShadowControl(shadowparams2)
		phys:Wake()
		phys:ComputeShadowControl(shadowparams)
		angs:RotateAroundAxis(angs:Right(),90)
		angs:RotateAroundAxis(angs:Forward(),-100)
		//angs:RotateAroundAxis(angs:Up(),-60)
		shadowparams.maxspeed = 20 / velo
		shadowparams.secondstoarrive=0.15
		shadowparams.pos = phys3:GetPos()
		phys3:Wake()
		phys3:ComputeShadowControl(shadowparams)
		shadowparams.secondstoarrive=0.25
		shadowparams.pos = phys4:GetPos()
		shadowparams.maxspeed = 15 / velo
		phys4:Wake()
		phys4:ComputeShadowControl(shadowparams)
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
					//if trace.Entity:IsPlayer() and !trace.Entity.Fake then
					//	Faking(trace.Entity)
					//end
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
					//if trace.Entity:IsPlayer() and !trace.Entity.Fake then
					//	Faking(trace.Entity)
					//end
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
		local phys = Spine
		local phys2 = Spine2
		local lh = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_L_Hand")))
		local angs = ply:EyeAngles()
		angs:RotateAroundAxis(angs:Forward(), 90)
		angs:RotateAroundAxis(angs:Up(), 90)
		local speed = 60
		if rag.ZacConsLH.Ent2:GetVelocity():LengthSqr() < 1000 then
			local shadowparams = {
				secondstoarrive = 0.8,
				pos = lh:GetPos() + ply:EyeAngles():Forward() * 25 + ply:EyeAngles():Up() * 5,
				angle = ply:EyeAngles(),
				maxangulardamp = 10,
				maxspeeddamp = 10,
				maxangular = 30,
				maxspeed = speed,
				teleportdistance = 0,
				deltatime = deltatime,
			}

			phys:Wake()
			phys:ComputeShadowControl(shadowparams)
			shadowparams.maxspeed = speed / 2
			phys2:Wake()
			phys2:ComputeShadowControl(shadowparams)
		end
	end

	if ply:KeyDown(IN_FORWARD) and IsValid(rag.ZacConsRH) then
		local phys = Spine
		local phys2 = Spine2
		local rh = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Hand")))
		local angs = ply:EyeAngles()
		angs:RotateAroundAxis(angs:Forward(), 90)
		angs:RotateAroundAxis(angs:Up(), 90)
		local speed = 60
		if rag.ZacConsRH.Ent2:GetVelocity():LengthSqr() < 1000 then
			local shadowparams = {
				secondstoarrive = 0.8,
				pos = rh:GetPos() + ply:EyeAngles():Forward() * 25 + ply:EyeAngles():Up() * 5,
				angle = ply:EyeAngles(),
				maxangulardamp = 10,
				maxspeeddamp = 10,
				maxangular = 30,
				maxspeed = speed,
				teleportdistance = 0,
				deltatime = deltatime,
			}

			phys:Wake()
			phys:ComputeShadowControl(shadowparams)
			shadowparams.maxspeed = speed / 2
			phys2:Wake()
			phys2:ComputeShadowControl(shadowparams)
		end
	end

	if ply:KeyDown(IN_BACK) and IsValid(rag.ZacConsLH) then
		local phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_Spine2")))
		local chst = rag:GetPhysicsObjectNum(0)
		local angs = ply:EyeAngles()
		angs:RotateAroundAxis(angs:Forward(), 90)
		angs:RotateAroundAxis(angs:Up(), 90)
		local speed = 40
		if rag.ZacConsLH.Ent2:GetVelocity():LengthSqr() < 1000 then
			local shadowparams = {
				secondstoarrive = 0.65,
				pos = chst:GetPos() + ply:EyeAngles():Forward() * -25 + ply:EyeAngles():Up() * -5,
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
		local phys = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_Spine2")))
		local chst = rag:GetPhysicsObjectNum(0)
		local angs = ply:EyeAngles()
		angs:RotateAroundAxis(angs:Forward(), 90)
		angs:RotateAroundAxis(angs:Up(), 90)
		local speed = 40
		if rag.ZacConsRH.Ent2:GetVelocity():LengthSqr() < 1000 then
			local shadowparams = {
				secondstoarrive = 0.65,
				pos = chst:GetPos() + ply:EyeAngles():Forward() * -25 + ply:EyeAngles():Up() * -5,
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
	local LIMIT_MASS = 80
	local LIMIT_SPEED = 120
	if ent:GetVelocity():Length() > LIMIT_SPEED or ent:GetPhysicsObject():GetMass() > LIMIT_MASS and ent:GetVelocity():Length() > LIMIT_SPEED / 2 then
		timer.Simple(0,function()
			if not IsValid(ply) or ply.Fake then return end
			Faking(ply)
		end)
	end
end)