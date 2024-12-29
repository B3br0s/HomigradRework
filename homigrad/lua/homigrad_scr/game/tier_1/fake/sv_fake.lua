if engine.ActiveGamemode() == "homigradcom" then
	local PlayerMeta = FindMetaTable("Player")
	local EntityMeta = FindMetaTable("Entity")

	local handsarrivetime = 0.3
	local forwardarrivetime = 3
	local backarrivetime = 1.6
	local velocititouebat = 185
	local maxweightpidaras = 100

	util.AddNetworkString("SyncAttsFake")

	local handsangup = 0

	util.AddNetworkString("KubegRubeg")

	local mul = 1
	local FrameTime,TickInterval = FrameTime,engine.TickInterval

	hook.Add("Think","Mul lerp",function()
		mul = FrameTime() / TickInterval()
	end)

	local Lerp,LerpVector,LerpAngle = Lerp,LerpVector,LerpAngle
	local math_min = math.min

	function LerpFT(lerp,source,set)
		return Lerp(math_min(lerp * mul,1),source,set)
	end

	function LerpVectorFT(lerp,source,set)
		return LerpVector(math_min(lerp * mul,1),source,set)
	end

	function LerpAngleFT(lerp,source,set)
		return LerpAngle(math_min(lerp * mul,1),source,set)
	end

	Organs = {
		['brain']=5,
        ['lungs']=40,
        ['liver']=10,
        ['stomach']=30,
        ['intestines']=30,
        ['heart']=20,
        ['carotidartery']=1,
        ['spine']=5,
        ['kidney'] = 2,
        ['spleen'] = 4,
        ['rartery'] = 1,
        ['lartery'] = 1
	}

	RagdollDamageBoneMul={		--Умножения урона при попадании по регдоллу
		[HITGROUP_LEFTLEG]=1,
		[HITGROUP_RIGHTLEG]=1,

		[HITGROUP_GENERIC]=1,

		[HITGROUP_LEFTARM]=1,
		[HITGROUP_RIGHTARM]=1,

		[HITGROUP_CHEST]=1.5,
		[HITGROUP_STOMACH]=1.5,

		[HITGROUP_HEAD]=3,
	}

	bonetohitgroup={ --Хитгруппы костей
		["ValveBiped.Bip01_Head1"]=HITGROUP_HEAD,
		["ValveBiped.Bip01_R_UpperArm"]=HITGROUP_RIGHTARM,
		["ValveBiped.Bip01_R_Forearm"]=HITGROUP_RIGHTARM,
		["ValveBiped.Bip01_R_Hand"]=HITGROUP_RIGHTARM,
		["ValveBiped.Bip01_L_UpperArm"]=HITGROUP_LEFTARM,
		["ValveBiped.Bip01_L_Forearm"]=HITGROUP_LEFTARM,
		["ValveBiped.Bip01_L_Hand"]=HITGROUP_LEFTARM,
		["ValveBiped.Bip01_Pelvis"]=HITGROUP_STOMACH,
		["ValveBiped.Bip01_Spine2"]=HITGROUP_CHEST,
		["ValveBiped.Bip01_L_Thigh"]=HITGROUP_LEFTLEG,
		["ValveBiped.Bip01_L_Calf"]=HITGROUP_LEFTLEG,
		["ValveBiped.Bip01_L_Foot"]=HITGROUP_LEFTLEG,
		["ValveBiped.Bip01_R_Thigh"]=HITGROUP_RIGHTLEG,
		["ValveBiped.Bip01_R_Calf"]=HITGROUP_RIGHTLEG,
		["ValveBiped.Bip01_R_Foot"]=HITGROUP_RIGHTLEG
	}

	if SERVER then
		net.Receive("KubegRubeg",function(l,ply)

			ply.KillReason = "tooloud"
			local dmgInfo = DamageInfo()
			dmgInfo:SetAttacker(ply)
			dmgInfo:SetInflictor(ply)
			dmgInfo:SetDamage(50022)
			dmgInfo:SetDamageType(DMG_BUCKSHOT)
			dmgInfo:SetDamagePosition(ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1")))
			ply:TakeDamageInfo(dmgInfo)

			ply.LastDMGInfo = dmgInfo
			ply.LastHitBoneName = "ValveBiped.Bip01_Head1"
		end)
	end


	function GetFakeWeapon(ply)
		ply.curweapon = ply.Info.ActiveWeapon
	end

	function SavePlyInfo(ply) -- Сохранение игрока перед его падением в фейк
		ply.Info = {}
		
		local info = ply.Info
		info.HasSuit = ply:IsSuitEquipped()
		info.SuitPower = ply:GetSuitPower()
		info.Ammo = ply:GetAmmo()
 		info.ActiveWeapon = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() or nil
		info.ActiveWeapon2 = ply:GetActiveWeapon()
		GetFakeWeapon(ply)
		info.Weapons={}
		for i,wep in pairs(ply:GetWeapons())do
			info.Weapons[wep:GetClass()]={
				Clip1=wep:Clip1(),
				Clip2=wep:Clip2(),
				AmmoType=wep:GetPrimaryAmmoType(),
				Atts = wep.CurrentAtt or nil
			}
		end
		info.Weapons2={}
		for i,wep in ipairs(ply:GetWeapons())do
			info.Weapons2[i-1]=wep:GetClass()
		end
		info.AllAmmo={}
		local i
		for ammo, amt in pairs(ply:GetAmmo())do
			i = i or 0
			i = i + 1
			info.AllAmmo[ammo]={i,amt}
		end
		--PrintTable(info.AllAmmo)
		return info
	end

	function GetFakeWeapon(ply)
		ply.curweapon = ply.Info.ActiveWeapon
	end

	function ClearFakeWeapon(ply)
		if ply.FakeShooting then DespawnWeapon(ply) end
	end

	function SavePlyInfoPreSpawn(ply) -- Сохранение игрока перед вставанием
		ply.Info = ply.Info or {}
		ply.AllowSpawn = true
		local info = ply.Info
		info.Hp = ply:Health()
		info.Armor = ply:Armor()
		ply:SetNWBool("LeftArmm",false)
		ply:SetNWBool("RightArmm",false)
		ply.AllowSpawn = false	
		return info
	end

	function ReturnPlyInfo(ply) -- возвращение информации игроку по его вставанию
		ClearFakeWeapon(ply)
		ply:SetSuppressPickupNotices(true)
		local info = ply.Info
		if(!info)then return end

		ply.AllowSpawn = true

		ply:StripWeapons()
		ply:StripAmmo()
		
		ply.slots = {}

		for name, wepinfo in pairs(info.Weapons or {}) do
			local weapon = ply:Give(name, true)
			if IsValid(weapon) and wepinfo.Clip1!=nil and wepinfo.Clip2!=nil then
				weapon:SetClip1(wepinfo.Clip1)
				weapon:SetClip2(wepinfo.Clip2)
				if weapon.PossibleAtt and wepinfo.Atts != nil then
					weapon.CurrentAtt = wepinfo.Atts	
					timer.Simple(0.05,function()
						net.Start("SyncAttsFake")
						net.WriteTable(wepinfo.Atts)
						net.WriteEntity(weapon)
						net.Broadcast()
					end)
				end
			end
		end
		for ammo, amt in pairs(info.Ammo or {}) do
			ply:GiveAmmo(amt,ammo)
		end
		if info.ActiveWeapon then
			ply:SelectWeapon(info.ActiveWeapon)
		end
		if info.HasSuit then
			ply:EquipSuit()
			ply:SetSuitPower(info.SuitPower or 0)
		else
			ply:RemoveSuit()
		end
		ply:SetHealth(info.Hp)
		ply:SetArmor(info.Armor)


		ply.AllowSpawn = false
	end

	function UnFaking(ply,force)
		if not ply:Alive() then return end
		local rag = ply:GetNWEntity("Ragdoll")
		if IsValid(rag) then
			if IsValid(rag.bull) then
				rag.bull:Remove()
			end
			ply.GotUp = CurTime()
			if hook.Run("Fake Up",ply,rag) ~= nil then return end

			ply.fake = false
			ply:SetNWBool("fake",ply.fake)

			ply.fakeragdoll=nil
			SavePlyInfoPreSpawn(ply)
			local pos=rag:GetPos()
			local vel=rag:GetVelocity()
			--ply:UnSpectate()
			PLYSPAWN_OVERRIDE = true
			ply:SetNWBool("unfaked",PLYSPAWN_OVERRIDE)
			local eyepos=ply:EyeAngles()
			local health = ply:Health()
			JMod.Иди_Нахуй = true
			ply:Spawn()
			JMod.Иди_Нахуй = nil
			ReturnPlyInfo(ply)
			ply:SetHealth(health)
			ply.FakeShooting=false
			ply:SetNWInt("FakeShooting",false)
			ply:SetVelocity(vel)
			ply:SetEyeAngles(eyepos)
			PLYSPAWN_OVERRIDE = nil
			ply:SetNWBool("unfaked",PLYSPAWN_OVERRIDE)


			local trace = {start = pos,endpos = pos - Vector(0,0,64),filter = {ply,rag}}
			local tracea = util.TraceLine(trace)
			if tracea.Hit then
				pos:Add(Vector(0,0,64) * (tracea.Fraction))
			end

			local trace = {start = pos,endpos = pos + Vector(0,0,64),filter = {ply,rag}}
			local tracea = util.TraceLine(trace)
			if tracea.Hit then
				pos:Add(-Vector(0,0,64) * (1 - tracea.Fraction))
			end
			
			local targetPos = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_Spine4"))):GetPos()

			local forwardOffset = ply:EyeAngles():Forward() * -10

			ply:SetPos(targetPos + forwardOffset - Vector(0, 0, 60))


			ply:DrawViewModel(true)
			ply:DrawWorldModel(true)
			ply:SetModel(ply:GetNWEntity("Ragdoll"):GetModel())
			ply:GetNWEntity("Ragdoll").huychlen = true
			ply:GetNWEntity("Ragdoll"):Remove()
			ply:SetNWEntity("Ragdoll",nil)
		end
	end

	function Faking(ply,force) -- функция падения
		if not GetGlobalBool("NoFake") then
		if not ply:Alive() then return end
		if ply.isSCP then return end

		if not ply.fake then
			if hook.Run("Fake",ply) ~= nil then return end
			
			ply.fake = true
			ply:SetNWBool("fake",ply.fake)

			SavePlyInfo(ply)
			ply:DrawViewModel(false)
			if (SERVER) then
			ply:DrawWorldModel(false)
			end
			local veh
			if ply:InVehicle() then
				veh = ply:GetVehicle()
				ply:ExitVehicle()
			end

			local rag = ply:CreateRagdoll(nil,nil,force)

			if IsValid(veh) then
				rag:GetPhysicsObject():SetVelocity(veh:GetPhysicsObject():GetVelocity() * 5)
			end

			if IsValid(ply:GetNWEntity("Ragdoll")) then
				ply.fakeragdoll=ply:GetNWEntity("Ragdoll")
				ply.fake = true
				local wep = ply:GetActiveWeapon()

				if IsValid(wep) and wep.Base == 'b3bros_base' then
					SpawnWeapon(ply)
				end

				ply.walktime = CurTime()
				
				rag.bull = ents.Create("npc_bullseye")
				rag:SetNWEntity("RagdollController",ply)
				local bull = rag.bull
				local bodyphy = rag:GetPhysicsObjectNum(10)
				bull:SetPos(bodyphy:GetPos()+bodyphy:GetAngles():Right()*7)
				bull:SetMoveType( MOVETYPE_OBSERVER )
				bull:SetParent(rag,rag:LookupAttachment("eyes"))
				bull:SetHealth(1000)
				bull:Spawn()
				bull:Activate()
				bull:SetNotSolid(true)
				FakeBullseyeTrigger(rag,ply)
				ply:HuySpectate(OBS_MODE_CHASE)
				ply:SpectateEntity(ply:GetNWEntity("Ragdoll"))

				ply:SetActiveWeapon(nil)
				ply:DropObject()

				timer.Create("faketimer"..ply:EntIndex(), 2, 1, function() end)
			end
		else
    local rag = ply:GetNWEntity("Ragdoll")
    if not IsValid(rag) then return end
	local eyeangs = ply:EyeAngles()
	local penis = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Pelvis" )) )
	local noska3 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Calf" )) )
	local noska4 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Calf" )) )
    local targetPos = penis:GetPos()+Vector(0,0,90)+eyeangs:Right()*10+vector_up*(20/math.Clamp(rag:GetVelocity():Length()/300,1,12)) + Vector(0,0,40)
    local targetPos2 = rag:GetPos() - Vector(0, 0, 40)
    local spine = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_Spine4")))
    local n1 = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_L_Toe0")))
    local n2 = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone("ValveBiped.Bip01_R_Toe0")))
	local head = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Head1" )) )

    if ply.LeftLeg < 0.65 and ply.RightLeg < 0.65 then
        net.Start("TextOnScreen")
        net.WriteString("Вы не можете встать, если у вас сломаны две ноги.")
        net.Send(ply)
        return
    end

    local transitionTime = 0
    local startTime = CurTime()

	    hook.Add("Think", "GetUpRagdoll" .. ply:SteamID(), function()
    	local elapsedTime = CurTime() - startTime
    	local progress = math.Clamp(elapsedTime / transitionTime, 0, 1)
    	local easedProgress = math.ease.InOutQuad(progress)

    	local shadowparams1 = {
    	    secondstoarrive = 2.4,
    	    pos = targetPos + Vector(0, 0, 20),
    	    angle = Angle(0,ply:EyeAngles()[2],ply:EyeAngles()[3]),
    	    maxangulardamp = 30,
    	    maxspeeddamp = 30,
    	    maxangular = 90,
    	    maxspeed = 130,
    	    teleportdistance = 0,
    	    deltatime = FrameTime(),
    	}
		local shadowparams4 = {
    	    secondstoarrive = 2.4,
    	    pos = head:GetPos(),
    	    angle = Angle(0,ply:EyeAngles()[2],ply:EyeAngles()[3]),
    	    maxangulardamp = 30,
    	    maxspeeddamp = 30,
    	    maxangular = 90,
    	    maxspeed = 130,
    	    teleportdistance = 0,
    	    deltatime = FrameTime(),
    	}
    	local shadowparams2 = {
    	    secondstoarrive = 0.4,
    	    pos = targetPos - Vector(0,0,200) + ply:EyeAngles():Forward()*-20,
    	    angle = spine:GetAngles(),
    	    maxangulardamp = 30,
    	    maxspeeddamp = 30,
    	    maxangular = 90,
    	    maxspeed = 400,
    	    teleportdistance = 0,
    	    deltatime = FrameTime(),
    	}
    	local shadowparams3 = {
    	    secondstoarrive = 0.5,
    	    pos = targetPos - Vector(0,0,200) + ply:EyeAngles():Forward()*20,
    	    angle = spine:GetAngles(),
    	    maxangulardamp = 30,
    	    maxspeeddamp = 30,
    	    maxangular = 90,
    	    maxspeed = 250,
    	    teleportdistance = 0,
    	    deltatime = FrameTime(),
    	}

    	spine:Wake()
    	spine:ComputeShadowControl(shadowparams1)
		head:Wake()
    	head:ComputeShadowControl(shadowparams4)
		penis:Wake()
    	penis:ComputeShadowControl(shadowparams1)
    	n1:Wake()
    	n2:Wake()
    	n1:ComputeShadowControl(shadowparams2)
    	n2:ComputeShadowControl(shadowparams2)
    	noska3:Wake()
    	noska3:ComputeShadowControl(shadowparams3)
    	noska4:Wake()
    	noska4:ComputeShadowControl(shadowparams3)

    	if progress >= 1 then
    	    hook.Remove("Think", "GetUpRagdoll" .. ply:SteamID())
    	end
	end)

	    timer.Simple(transitionTime, function()
	        if IsValid(ply) then
	            UnFaking(ply)
	            hook.Remove("Think", "GetUpRagdoll" .. ply:SteamID())
	        end
	    end)
	end
	end
	end

	hook.Add("CanExitVehicle","fakefastcar",function(veh,ply)
		if veh:GetPhysicsObject():GetVelocity():Length() > 10 then Faking(ply) return false end
	end)

	function FakeBullseyeTrigger(rag,owner)
		if not IsValid(rag.bull) then return end
	end

	hook.Add("OnEntityCreated","hg-bullseye",function(ent)
		ent:SetShouldPlayPickupSound(false)
		if ent:IsNPC() then
			for i,rag in pairs(ents.FindByClass("prop_ragdoll"))do
				if IsValid(rag.bull) then
					ent:AddEntityRelationship(rag.bull,D_HT,0)
				end
			end
		end
			if not IsValid(ent) then return end

			local pos,ang = ent:GetPos(),ent:GetAngles()
			local exchangeEnt = changeClass[ent:GetClass()]
			if exchangeEnt then
				local entr = type(exchangeEnt) == "table" and table.Random(exchangeEnt) or exchangeEnt
				local ent2 = ents.Create(entr)

				if not pos then return end
				if not ent2 then return end
				if ent2 == NULL then return end
				ent2:SetPos(pos)
				ent2:SetAngles(ang)
				ent2:Spawn()

				ent:Remove()
			end
	end)

	hook.Add("Think","FakedShoot",function() --функция стрельбы лежа
	for i,ply in pairs(player.GetAll()) do
		if IsValid(ply:GetNWEntity("Ragdoll")) and ply.FakeShooting and ply:Alive() then
			SpawnWeapon(ply)
		else
			if IsValid(ply.wep) then
				DespawnWeapon(ply)
			end
		end
	end
	end)

	hook.Add("PlayerSay","huyasds",function(ply,text)
		if ply:IsAdmin() and string.lower(text)=="1" then
			local ent = ply:GetEyeTrace().Entity
			if ent:IsPlayer() then
				ply:ChatPrint(ent:Nick(),ent:EntIndex())
			elseif ent:IsRagdoll() then
				ply:ChatPrint(IsValid(RagdollOwner(ent)) and RagdollOwner(ent):Name())
			end
			return ""
		end
	end)

	function RagdollOwner(rag) --функция, определяет хозяина регдолла
		if not IsValid(rag) then return end

		local ent = rag:GetNWEntity("RagdollController")
		return IsValid(ent) and ent
	end

	function PlayerMeta:DropWeapon1(wep)
		local ply = self
		wep = wep or ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		if wep:GetClass() == "weapon_hands" or wep:GetClass() == "weapon_handsinfected" or wep:GetClass() == "weapon_049"  or wep:GetClass() == "weapon_096" or wep:GetClass() == "weapon_173" then return end
		if wep.Base == "b3bros_base" then
			if wep.TwoHands then
				ply.slots[3] = nil
			else
				ply.slots[2] = nil
			end
		end
		ply:DropWeapon(wep)
		wep.Spawned = true
		ply:SelectWeapon("weapon_hands")
	end

	util.AddNetworkString("pophead")

	function PlayerMeta:PickupEnt()
	local ply = self
	local rag = ply:GetNWEntity("Ragdoll")
	local phys = rag:GetPhysicsObjectNum(7)
	local offset = phys:GetAngles():Right()*5
	local traceinfo={
	start=phys:GetPos(),
	endpos=phys:GetPos()+offset,
	filter=rag,
	output=trace,
	}
	local trace = util.TraceLine(traceinfo)
	if trace.Entity == Entity(0) or trace.Entity == NULL or !trace.Entity.canpickup then return end
	if trace.Entity:GetClass()=="wep" then
		ply:Give(trace.Entity.curweapon,true):SetClip1(trace.Entity.Clip)
		--SavePlyInfo(ply)
		ply.wep.Clip=trace.Entity.Clip
		trace.Entity:Remove()
	end
	end

	util.AddNetworkString("send_deadbodies")
	hook.Add("DoPlayerDeath","blad",function(ply,att,dmginfo)
		SavePlyInfo(ply)

		local rag = ply:GetNWEntity("Ragdoll")
		
		if not IsValid(rag) then
			rag = ply:CreateRagdoll(att,dmginfo)
			ply:SetNWEntity("Ragdoll",rag)
		end

		rag:SetEyeTarget(Vector(0,0,0))
		local phys = rag:GetPhysicsObject()

		net.Start("pophead")
		net.WriteEntity(rag)
		net.Send(ply)

		if IsValid(rag.bull) then rag.bull:Remove() end
		
		rag:SetNWEntity("RagdollController",Entity(-1))

		if ply.IsBleeding or ply.Bloodlosing > 0 or ply.LastDMGInfo and ply.LastDMGInfo:IsDamageType(DMG_BULLET+DMG_SLASH+DMG_BLAST+DMG_ENERGYBEAM+DMG_NEVERGIB+DMG_ALWAYSGIB+DMG_PLASMA+DMG_AIRBOAT+DMG_SNIPER+DMG_BUCKSHOT) then
			rag.IsBleeding=true
			rag.bloodNext = 0
			rag.Blood = ply.Blood
			table.insert(BleedingEntities,rag)
		end

		rag.Info = ply.Info
		rag.deadbody = true
		deadBodies = deadBodies or {}
		deadBodies[rag:EntIndex()] = {rag,rag.Info}
		net.Start("send_deadbodies")
		net.WriteTable(deadBodies)
		net.Broadcast()
		rag.curweapon=ply.curweapon

		if(IsValid(rag.ZacConsLH))then
			rag.ZacConsLH:Remove()
			rag.ZacConsLH=nil
		end

		if(IsValid(rag.ZacConsRH))then
			rag.ZacConsRH:Remove()
			rag.ZacConsRH=nil
		end

		local ent = ply:GetNWEntity("Ragdoll")
		if IsValid(ent) then ent:SetNWEntity("RagdollOwner",nil) end

		ply:SetDSP(0)
		ply.fakeragdoll = nil
		ply.fake = nil
	end)

	hook.Add("PostPlayerDeath","fuckyou",function(ply)
		ply:SetNWBool("LeftArmm",false)
		ply:SetNWBool("RightArmm",false)
	end)

	hook.Add("PhysgunDrop", "DropPlayer", function(ply,ent)
		ent.isheld=false
	end)

	hook.Add("PlayerDisconnected","saveplyinfo",function(ply)
		if ply:Alive() then
			SavePlyInfo(ply)
			ply:Kill()
		end
	end)

	hook.Add("PhysgunPickup", "DropPlayer2", function(ply,ent)

		if ply:GetUserGroup()=="superadmin" then

			if ent:IsPlayer() and !ent.fake then
				if hook.Run("Should Fake Physgun",ply,ent) ~= nil then return false end

				ent.isheld=true

				Faking(ent)
				return false
			end
		end
	end)

	util.AddNetworkString("fuckfake")
	hook.Add("PlayerSpawn","resetfakebody",function(ply) --обнуление регдолла после вставания
		if not GetGlobalBool("NoFake") then
		ply.fake = false
		ply:AddEFlags(EFL_NO_DAMAGE_FORCES)

		net.Start("fuckfake")
		net.Send(ply)

		ply:SetNWBool("fake",false)

		if PLYSPAWN_OVERRIDE then return end

		ply:SetDuckSpeed(0.3)
		ply:SetUnDuckSpeed(0.3)
		
		ply.slots = {}
		if ply.UsersInventory ~= nil then
			for plys,bool in pairs(ply.UsersInventory) do
				ply.UsersInventory[plys] = nil
				send(plys,lootEnt,true)
			end
		end
		ply:SetNWEntity("Ragdoll",nil)
		end
	end)

	util.AddNetworkString("Unload")
	net.Receive("Unload",function(len,ply)
		local wep = net.ReadEntity()
		if wep:GetOwner() != ply then
			logToDiscord("Обнаружен Эксплойтер попытавшийся разрядить оружие другим - "..ply:SteamID(),"Error"," ","https://discord.com/api/webhooks/1318195645047111762/FjRrrG9DX7eQsv1ZRw1WwsIb-oWWr3uFPtPUPNrggEwkQyV7GfDbNa6SwiykbUyZAqym")
			ply:Kick("ХУЕСОС НЕ ИГРАЙ С ЧИТАМИ)))000)))")
		end
		if not wep then return end
		if not wep.Clip1 then return end
		local oldclip = wep:Clip1()
		local ammo = wep:GetPrimaryAmmoType()
		if not ammo then return end
		if not oldclip then return end
		wep:EmitSound("snd_jack_hmcd_ammotake.wav")
		wep:SetClip1(0)
		ply:GiveAmmo(oldclip,ammo)
	end)

	function Stun(Entity)
		if not GetGlobalBool("NoFake") then
		if Entity:IsPlayer() then
			Faking(Entity)
			timer.Create("StunTime"..Entity:EntIndex(), 6, 1, function() end)
			local fake = Entity:GetNWEntity("Ragdoll")
			timer.Create( "StunEffect"..Entity:EntIndex(), 0.1, 80, function()
				local rand = math.random(1,20)
				if rand == 20 then
				RagdollOwner(fake):Say("*drop")
				end
				RagdollOwner(fake).pain = RagdollOwner(fake).pain + 1
				fake:GetPhysicsObjectNum(1):SetVelocity(fake:GetPhysicsObjectNum(1):GetVelocity()+Vector(math.random(-55,55),math.random(-55,55),0))
				fake:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")
			end)
		elseif Entity:IsRagdoll() then
			if RagdollOwner(Entity) then
				RagdollOwner(Entity):Say("*drop")
				timer.Create("StunTime"..RagdollOwner(Entity):EntIndex(), 6, 1, function() end)
				local fake = Entity
				timer.Create( "StunEffect"..RagdollOwner(Entity):EntIndex(), 0.1, 80, function()
					if rand == 50 then
						RagdollOwner(fake):Say("*drop")
					end
					RagdollOwner(fake).pain = RagdollOwner(fake).pain + 3
					fake:GetPhysicsObjectNum(1):SetVelocity(fake:GetPhysicsObjectNum(1):GetVelocity()+Vector(math.random(-55,55),math.random(-55,55),0))
					fake:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")
				end)
			else
				local fake = Entity
				timer.Create( "StunEffect"..Entity:EntIndex(), 0.1, 80, function()
					fake:GetPhysicsObjectNum(1):SetVelocity(fake:GetPhysicsObjectNum(1):GetVelocity()+Vector(math.random(-55,55),math.random(-55,55),0))
					fake:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")
					end)
				end
			end
		end
	end


	concommand.Add("fake",function(ply)	
		if ply.ISEXPLOITERHAHA then ply:ChatPrint("ЛОХ))))00000))00)") return end
		if ply:GetActiveWeapon().Somethingidk then
			if SERVER then
				AddCSLuaFile("weapons/b3bros_base/cl_drawworld.lua")
			end
			
			if CLIENT then
				include("weapons/b3bros_base/cl_drawworld.lua")
			ply:GetActiveWeapon():RemoveClientsideModel()
			end
		end
		if ply.Dushat then return end
		if ply.SuffocatingFiber then return nil end
		if ply.isSCP then return end
		if ply["Organs"].spine == 0 then return nil end
		if timer.Exists("faketimer"..ply:EntIndex()) then return nil end
		if timer.Exists("StunTime"..ply:EntIndex()) then return nil end
		if ply.Paralizovan then return nil end
		if ply:GetNWEntity("Ragdoll").isheld==true then return nil end
		if ply.Seizure then return end

		ply:SetNWBool("LeftArmm",false)
		ply:SetNWBool("RightArmm",false)

		if ply.brokenspine then return nil end
		if IsValid(ply:GetNWEntity("Ragdoll")) and ply:GetNWEntity("Ragdoll"):GetVelocity():Length()>200 then return nil end
		if IsValid(ply:GetNWEntity("Ragdoll")) and table.Count(constraint.FindConstraints( ply:GetNWEntity("Ragdoll"), 'Rope' ))>0 then return nil end

		--if IsValid(ply:GetNWEntity("Ragdoll")) and table.Count(constraint.FindConstraints( ply:GetNWEntity("Ragdoll"), 'Weld' ))>0 then return nil end

		if ply.pain>(250*(ply.Blood/5000))+(ply:GetNWInt("SharpenAMT")*5) or ply.Blood<3000 then return end
		ply.AllowSpawn = true
		timer.Create("faketimer"..ply:EntIndex(), 2, 1, function() ply.AllowSpawn = false end)

		if ply:Alive() then
			if not GetGlobalBool("NoFake") then
			ply:SetNWBool("LeftArmm",false)
			ply:SetNWBool("RightArmm",false)
			Faking(ply)
			ply.fakeragdoll=ply:GetNWEntity("Ragdoll")
			end
		end
	end)

	hook.Add("PreCleanupMap","cleannoobs",function() --все игроки встают после очистки карты
		for i, v in pairs(player.GetAll()) do
			if v.fake then UnFaking(v) end
		end

		BleedingEntities = {}

	end)

	util.AddNetworkString("nodraw_helmet")

	local function CreateArmor(ragdoll,info)
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
		end

		timer.Simple(0.1,function()
			local ply = RagdollOwner(ragdoll)
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

	local function Remove(self,ply)
		if self.override then return end

		self.ragdoll.armors[self.armorID] = nil
		JMod.RemoveArmorByID(ply,self.armorID,true)
	end

	local function RemoveRag(self)
		for id,ent in pairs(self.armors) do
			if not IsValid(ent) then continue end

			ent.override = true
			ent:Remove()
		end
	end


	util.AddNetworkString("custom name")

	net.Receive("custom name",function(len,ply)
		if not ply:IsAdmin() then return end
		
		local name = net.ReadString()
		if name == "" then return end

		ply:SetNWString("CustomName",name)
	end)

	function PlayerMeta:CreateRagdoll(attacker,dmginfo,force) --изменение функции регдолла
		local rag=self:GetNWEntity("Ragdoll")
		rag.ExplProof = true
		if IsValid(rag) then
			if(IsValid(rag.ZacConsLH))then
				rag.ZacConsLH:Remove()
				rag.ZacConsLH=nil
			end
			if(IsValid(rag.ZacConsRH))then
				rag.ZacConsRH:Remove()
				rag.ZacConsRH=nil
			end
			return
		end

		local Data = duplicator.CopyEntTable( self )
		local rag = ents.Create( "prop_ragdoll" )
		duplicator.DoGeneric( rag, Data )
		rag:SetModel(self:GetModel())
		rag:SetNWVector("plycolor",self:GetPlayerColor())
		rag:SetSkin(self:GetSkin())
		rag:Spawn()

		rag:CallOnRemove("huyhjuy",function() self.firstrag = false end)
		rag:CallOnRemove("huy2ss",function()
			if not rag.huychlen and RagdollOwner(rag) then
				rag.huychlen = false
				RagdollOwner(rag):KillSilent()
			end
		end)
		
		rag:AddEFlags(EFL_NO_DAMAGE_FORCES)
		CustomWeight = {}

		NoAffect = {
				["models/chs_community/asix.mdl"] = true,
                ["models/chs_community/blinked.mdl"] = true,
                ["models/chs_community/cyborg_alex.mdl"] = true,
                ["models/chs_community/deka_zcity.mdl"] = true,
                ["models/chs_community/dick_jones.mdl"] = true,
                ["models/chs_community/doctorkeks.mdl"] = true,
                ["models/chs_community/emil_kms.mdl"] = true,
                ["models/chs_community/f_dutchman.mdl"] = true,
                ["models/chs_community/down.mdl"] = true,
                ["models/chs_community/dozen_zcity.mdl"] = true,
                ["models/chs_community/ghost_acceleron.mdl"] = true,
                ["models/chs_community/gleb.mdl"] = true,
                ["models/chs_community/golyb.mdl"] = true,
                ["models/chs_community/griggs.mdl"] = true,
                ["models/chs_community/hank_md.mdl"] = true,
                ["models/chs_community/justik.mdl"] = true,
                ["models/chs_community/mannytko.mdl"] = true,
                ["models/chs_community/narik_zcity.mdl"] = true,
                ["models/chs_community/necollins.mdl"] = true,
                ["models/chs_community/patrick_kane.mdl"] = true,
                ["models/chs_community/propka.mdl"] = true,
                ["models/chs_community/sadsalat.mdl"] = true,
                ["models/chs_community/tea.mdl"] = true,
                ["models/chs_community/yahet.mdl"] = true,
                ["models/chs_community/zac90.mdl"] = true,
                ["models/chs_community/soda.mdl"] = true,
                ["models/chs_community/soler.mdl"] = true,
                ["models/chs_community/stanley.mdl"] = true,
				["models/chs_community/cat.mdl"] = true,
				["models/chs_community/distac_zcity.mdl"] = true
		}
	
		for modelName, modelPath in pairs(list.Get("PlayerOptionsModel")) do
			if not CustomWeight[modelPath] and not NoAffect[modelPath] then
				CustomWeight[modelPath] = true
			end
		end

		for i = 1, 6 do
			CustomWeight["models/monolithservers/mpd/male_0"..i.."_2.mdl"] = true
			CustomWeight["models/monolithservers/mpd/female_0"..i..".mdl"] = true
		end

		for i = 1, 9 do
			CustomWeight["models/monolithservers/mpd/male_0"..i..".mdl"] = true
			CustomWeight["models/monolithservers/mpd/female_0"..i.."_2.mdl"] = true
		end

		for i = 2, 9 do
			if i != 3 then
			CustomWeight["models/scp_mtf_russian/mtf_rus_0"..i..".mdl"] = true
			end
		end
	
		if rag and IsValid(rag) then
			rag:GetPhysicsObject():SetMass(25)
		
			local model = rag:GetModel()

			if CustomWeight[model] == true and not NoAffect[model] then
				self:SetNWFloat("BackArrive", backarrivetime * 24)
				self:SetNWFloat("ForwardArrive", forwardarrivetime * 24)
				self:SetNWFloat("HandsArrive", handsarrivetime * 1.2)
			else
				self:SetNWFloat("BackArrive", backarrivetime)
				self:SetNWFloat("ForwardArrive", forwardarrivetime)
				self:SetNWFloat("HandsArrive", handsarrivetime)
			end
		end
		
		rag:Activate()
		rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		rag:SetNWEntity("RagdollOwner", self)
		local vel = self:GetVelocity()/1 + (force or Vector(0,0,0))
		for i = 0, rag:GetPhysicsObjectCount() - 1 do
			local physobj = rag:GetPhysicsObjectNum( i )
			local ragbonename = rag:GetBoneName(rag:TranslatePhysBoneToBone(i))
			local bone = self:LookupBone(ragbonename)
			if(bone)then
				local bonemat = self:GetBoneMatrix(bone)
				if(bonemat)then
					local bonepos = bonemat:GetTranslation()
					local boneang = bonemat:GetAngles()
					physobj:SetPos( bonepos,true )
					physobj:SetAngles( boneang )
					if !self:Alive() then vel=vel end
					physobj:AddVelocity( vel )
				end
			end
		end

		rag:SetNWString("Nickname",self:GetNWString("CustomName",false) or self:Name())

		local armors = {}

		for id,info in pairs(self.EZarmor.items) do
			local ent = CreateArmor(rag,info)
			ent.armorID = id
			ent.ragdoll = rag
			ent.Owner = self
			armors[id] = ent

			ent:CallOnRemove("Fake",Remove,self)
		end

		if IsValid(self.wep) then
			self.wep.rag = rag
		end

		rag.armors = armors
		rag:CallOnRemove("Armors",RemoveRag)

		self.fakeragdoll = rag
		self:SetNWEntity("Ragdoll", rag )

		if not self:Alive() then
			self:DropWeapon1()
			--net.Start("pophead")
			--net.WriteEntity(rag)
			--net.Send(self)
			--rag.Info=self.Info
			--if IsValid(self:GetActiveWeapon()) then
			--	self.curweapon=nil
			--	if self:GetActiveWeapon().Base == 'b3bros_base' then
			--		self.curweapon=self:GetActiveWeapon():GetClass()
			--		SpawnWeapon(self,self:GetActiveWeapon():Clip1()).rag = rag
			--	end
			--	rag.curweapon = self.curweapon
			--end
			--SavePlyInfo(self)
			--rag.Info=self.Info
			--rag.curweapon=self.curweapon
			--rag:SetEyeTarget(Vector(0,0,0))
			--rag:SetFlexWeight(9,0)
			--if self.IsBleeding or (self.BloodLosing or 0) > 0 then
			--	rag.IsBleeding=true
			--	rag.bloodNext = CurTime()
			--	rag.Blood = self.Blood
			--	table.insert(BleedingEntities,rag)
			--end
			--if IsValid(rag.bull) then
			--	rag.bull:Remove()
			--end
			--rag.deadbody = true
			--self.fakeragdoll = nil
			net.Start("ebal_chellele")
			net.WriteEntity(rag)
			net.WriteString(rag.curweapon or " ")
			net.Broadcast()
		else
			net.Start("ebal_chellele")
			net.WriteEntity(self)
			net.WriteString(self.curweapon or " ")
			net.Broadcast()
		end

		return rag
	end

	hook.Add("JMod Armor Remove","Fake",function(ply,slot,item,drop)
		local fake = ply:GetNWEntity("Ragdoll")
		if not IsValid(fake) then return end

		local ent = fake.armors[slot.id]
		if not IsValid(ent) then return end

		ent:Remove()
	end)

	hook.Add("JMod Armor Equip","Fake",function(ply,slot,item,drop)
		local fake = ply:GetNWEntity("Ragdoll")
		if not IsValid(fake) then return end

		local ent = CreateArmor(fake,item)
		ent.armorID = slot.id
		ent.Owner = ply
		fake.armors[slot.id] = ent
		ent:CallOnRemove("Fake",Remove,ent,ply)
	end,2)--lol4ik

	local gg = CreateConVar("hg_oldcollidefake","0")
	COMMANDS.oldcollidefake = {function(ply,args)
		GetConVar("hg_oldcollidefake"):SetBool(tonumber(args[1]) > 0)
		PrintMessage(3,"Старая система collide fake - " .. tostring(gg:GetBool()))
	end}

	hook.Add("Player Collide","homigrad-fake",function(ply,hitEnt,data)
		--if not ply:HasGodMode() and data.Speed >= 250 / hitEnt:GetPhysicsObject():GetMass() * 20 and not ply.fake and not hitEnt:IsPlayerHolding() and hitEnt:GetVelocity():Length() > 80 then
		if
			(gg:GetBool() and not ply:HasGodMode()) or
			(not gg:GetBool() and not ply:HasGodMode() and data.Speed >= 5 / hitEnt:GetPhysicsObject():GetMass() * 10 and not ply.fake and not hitEnt:IsPlayerHolding() and hitEnt:GetVelocity():Length() > velocititouebat)  --сбитие с ног
		then 
			if hitEnt:GetClass() == "prop_physics" or hitEnt:GetClass() == "prop_physics_multiplayer" then
				if hitEnt:GetVelocity():Length() > velocititouebat then
					timer.Simple(0,function()
						if not IsValid(ply) or ply.fake then return end
		
						--if hook.Run("Should Fake Collide",ply,hitEnt,data) == false then return end
		
						Faking(ply)
					end)	
				end
			elseif hitEnt:GetClass() == "prop_ragdoll" then
				timer.Simple(0,function()
					if not IsValid(ply) or ply.fake then return end
	
					--if hook.Run("Should Fake Collide",ply,hitEnt,data) == false then return end
	
					Faking(ply)
				end)
			end
		end
	end)

	hook.Add("OnPlayerHitGround","GovnoJopa",function(ply,a,b,speed)
		if speed > 10 then
			if hook.Run("Should Fake Ground",ply) ~= nil then return end

			local tr = {}
			tr.start = ply:GetPos()
			tr.endpos = ply:GetPos() - Vector(0,0,10)
			tr.mins = ply:OBBMins()
			tr.maxs = ply:OBBMaxs()
			tr.filter = ply
			local traceResult = util.TraceHull(tr)
			if traceResult.Entity:IsPlayer() and not traceResult.Entity.fake then
				Faking(traceResult.Entity)
			end
		end
	end)

	deadBodies = deadBodies or {}

	hook.Add("Think","VelocityFakeHitPlyCheck",function() --проверка на скорость в фейке (для сбивания с ног других игроков)
		for i,rag in pairs(ents.FindByClass("prop_ragdoll")) do
			if IsValid(rag) then
				if rag:GetVelocity():Length() > velocititouebat + 5 then
					if not IsValid(rag:GetNWEntity("RagdollOwner")) then
						rag:SetCollisionGroup(COLLISION_GROUP_NONE)	
					else
						if rag:GetNWEntity("RagdollOwner"):Alive() then
							rag:SetCollisionGroup(COLLISION_GROUP_NONE)	
						end
					end
				else
					rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)	
				end
			end
		end
		for i = 1,#deadBodies do
			local ent = deadBodies[i]
			if not IsValid(ent) or not ent:IsPlayer() or not ent:IsRagdoll() then deadBodies[i] = nil continue end
		end
	end)
	local CurTime = CurTime
	hook.Add("StartCommand","asdfgghh",function(ply,cmd)
		local rag = ply:GetNWEntity("Ragdoll")
		if (ply.GotUp or 0) - CurTime() > -0.1 and not IsValid(rag) then cmd:AddKey(IN_DUCK) end
		if IsValid(rag) then cmd:RemoveKey(IN_DUCK) end
	end)

	hook.Add( "KeyPress", "Shooting", function( ply, key )
		if !ply:Alive() or ply.Otrub then ply:SetNWBool("LeftArmm",false) ply:SetNWBool("RightArmm",false) return end
		
		if key == IN_RELOAD then
			Reload(ply.wep)
		end
	end )

	local dvec = Vector(0,0,-64)

	hook.Add("Player Think","FakeCheckArms",function(ply)
		if CLIENT then return end
		if ply:GetNWBool("fake") and ply:Alive() then
			local rag = ply:GetNWEntity("Ragdoll")
			if not IsValid(rag) then return end
			if not rag:LookupBone("ValveBiped.Bip01_R_Finger0") then return end
			if IsValid(rag.ZacConsLH) then
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(0,10,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger01"),Angle(0,20,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger1"),Angle(0,-10,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger11"),Angle(0,-40,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger2"),Angle(0,-10,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger21"),Angle(0,-40,0))
			else
				ply:SetNWBool("LeftArmm",false)
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(0,0,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger01"),Angle(0,0,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger1"),Angle(0,0,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger11"),Angle(0,0,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger2"),Angle(0,0,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_L_Finger21"),Angle(0,0,0))
			end
			if IsValid(rag.ZacConsRH) then
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger0"),Angle(0,10,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger01"),Angle(0,20,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger1"),Angle(0,-10,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger11"),Angle(0,-40,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger2"),Angle(0,-10,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger21"),Angle(0,-40,0))
			else
				ply:SetNWBool("RightArmm",false)
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger0"),Angle(0,0,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger01"),Angle(0,0,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger1"),Angle(0,0,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger11"),Angle(0,0,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger2"),Angle(0,0,0))
				rag:ManipulateBoneAngles(rag:LookupBone("ValveBiped.Bip01_R_Finger21"),Angle(0,0,0))
			end
		end
	end)

	hook.Add("Player Think","FakeSuffocation",function(ply,time)
		local amounttodecrease = 0.05
		local amounttopain = math.random(1,6)
			if ply:Alive() then
			if CurTime() > ply:GetNWFloat("NextThinkGay") then -- троллед
			if !ply.Suffocating == true then
			ply:SetNWFloat("NextThinkGay",CurTime() + 0.1)
			else
			ply:SetNWFloat("NextThinkGay",CurTime() + 5)
			end
			if ply.Suffocating == true then
				ply:GetNWEntity("Ragdoll"):EmitSound("homigrad/suffocation_rope.wav")
				--ply:GetNWEntity("Ragdoll"):EmitSound("homigrad/suffocation.wav")
			end
			if table.Count(constraint.FindConstraints(ply:GetNWEntity("Ragdoll"), 'Rope')) > 0 then
				--print(table.Count(constraint.FindConstraints(ply:GetNWEntity("Ragdoll"), 'Rope')))
				local RopesFoNi = constraint.FindConstraints(ply:GetNWEntity("Ragdoll"), 'Rope')
				for _, rope in ipairs(RopesFoNi) do
					if rope.Ent1:GetClass() == "prop_ragdoll" then

						local renderBone1 = rope.Ent1:TranslatePhysBoneToBone(rope.Bone1)
						local boneName1 = rope.Ent1:GetBoneName(renderBone1)

						--print(ply:Nick())

							if boneName1 == "ValveBiped.Bip01_Head1" then
								if ply.o2 > 0.999 then
									ply.Suffocating = true
									ply:ChatPrint("Ты задыхаешься.")	
									--ply:GetNWEntity("Ragdoll"):EmitSound("homigrad/suffocation.wav")
									--ply:GetNWEntity("Ragdoll"):EmitSound("homigrad/suffocation_rope.wav")
								end
								ply.o2 = ply.o2 - amounttodecrease
								ply.stamina = ply.stamina - 20
								ply.pain = ply.pain + amounttopain
								ply.painlosing = 0
								ply:SetHealth(ply:Health() - 1)	
								if ply.o2 < 0.2 and ply.o2 > 0.19 then
									--ply:ChatPrint("У тебя нехватка воздуха.")	
									ply:ChatPrint("You're short of breath.")	
									ply:GetNWEntity("Ragdoll"):EmitSound("npc/zombie/zombie_voice_idle"..math.random(1,12)..".wav")
								end
								--ply:ChatPrint(ply.stamina)
							end

						--ply:ChatPrint("Bone1 attached: " .. (boneName1 or "Unknown Bone"))
						
					elseif rope.Ent2:GetClass() == "prop_ragdoll" then

						local renderBone2 = rope.Ent2:TranslatePhysBoneToBone(rope.Bone2)
						local boneName2 = rope.Ent2:GetBoneName(renderBone2)

						--print(ply:Nick())

							if boneName2 == "ValveBiped.Bip01_Head1" then
								if ply.o2 > 0.999 then
									ply:ChatPrint("Ты задыхаешься.")	
									--ply:GetNWEntity("Ragdoll"):EmitSound("homigrad/suffocation.wav")
									--ply:GetNWEntity("Ragdoll"):EmitSound("homigrad/suffocation_rope.wav")
								end
								ply.o2 = ply.o2 - amounttodecrease
								ply.stamina = ply.stamina - 20
								ply.pain = ply.pain + amounttopain
								ply.painlosing = 0
								ply:SetHealth(ply:Health() - 1)	
								if ply.o2 < 0.2 and ply.o2 > 0.19 then
									--ply:ChatPrint("У тебя нехватка воздуха.")	
									ply:ChatPrint("You're short of breath.")	
									ply:GetNWEntity("Ragdoll"):EmitSound("npc/zombie/zombie_voice_idle"..math.random(1,12)..".wav")
								end
								--ply:ChatPrint(ply.stamina)
							end

						--ply:ChatPrint("Bone2 attached: " .. (boneName2 or "Unknown Bone"))
					end
				end
			elseif table.Count(constraint.FindConstraints(ply:GetNWEntity("Ragdoll"), 'Rope')) == 0 then
				if ply.Suffocating == true then
					ply.Suffocating = false
					ply:GetNWEntity("Ragdoll"):StopSound("homigrad/suffocation_rope.wav")
					ply:GetNWEntity("Ragdoll"):StopSound("homigrad/suffocation.wav")
					ply:GetNWEntity("Ragdoll"):EmitSound("homigrad/suffocation_free.wav")
					ply:GetNWEntity("Ragdoll"):EmitSound("homigrad/suffocation_rope_break.wav")
				end
			end
		end
	end
		end)

	hook.Add("Player Think","FakeControl",function(ply,time) --управление в фейке
		if ply.Dushat and !ply.PenisDushilin.fake then return end
		if ply.ISEXPLOITERHAHA then return end
		if !ply.Paralizovan then
		ply.holdingartery = false
		if not ply:Alive() then return end
		local rag = ply:GetNWEntity("Ragdoll")

		if not IsValid(rag) or not ply:Alive() then return end
		if timer.Exists("StunEffect"..rag:EntIndex()) then return end
		local bone = rag:LookupBone("ValveBiped.Bip01_Head1")
		if not bone then return end
		if rag.Blood then
			ply.Blood = rag.Blood
		end
		if IsValid(ply.bull) then
			ply.bull:SetPos(rag:GetPos())
		end
		local head1 = rag:GetBonePosition(bone) + dvec
		ply:SetPos(head1)
		ply:SetNWBool("fake",ply.fake)
		local deltatime = CurTime()-(rag.ZacLastCallTime or CurTime())
		rag.ZacLastCallTime=CurTime()
		local eyeangs = ply:EyeAngles()
		local head = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Head1" )) )
		local penis = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Pelvis" )) )
		local ohhspina = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine" )) )
		local noska1 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Thigh" )) )
		local noska2 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Thigh" )) )
		local noska3 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Calf" )) )
		local noska4 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Calf" )) )
		local spinenan = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine1" )) )
		local spine2 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine2" )) )
		local spinemain = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine4" )) )
		rag:SetFlexWeight(9,0)
		local dist = (rag:GetAttachment(rag:LookupAttachment( "eyes" )).Ang:Forward()*10000):Distance(ply:GetAimVector()*10000)
		local distmod = math.Clamp(1-(dist/20000),0.1,1)
		local lookat = LerpVector(distmod,rag:GetAttachment(rag:LookupAttachment( "eyes" )).Ang:Forward()*100000,ply:GetAimVector()*100000)
		local attachment = rag:GetAttachment( rag:LookupAttachment( "eyes" ) )
		local LocalPos, LocalAng = WorldToLocal( lookat, Angle( 0, 0, 0 ), attachment.Pos, attachment.Ang )
		if !ply.Otrub then rag:SetEyeTarget( LocalPos ) else rag:SetEyeTarget( Vector(0,0,0) ) end
		if ply:Alive() then
			if !ply.Otrub then
				if ply:KeyDown(IN_JUMP) and not ply.Suffocating and (table.Count(constraint.FindConstraints(ply:GetNWEntity("Ragdoll"), 'Rope')) > 0 or ((rag.IsWeld or 0) > 0)) and ply.stamina > 45 and (ply.lastuntietry or 0) < CurTime() then
					ply.lastuntietry = CurTime() + 1
				
					rag.IsWeld = math.max((rag.IsWeld or 0) - 0.1, 0)
				
					local RopeCount = table.Count(constraint.FindConstraints(ply:GetNWEntity("Ragdoll"), 'Rope'))
					local Ropes = constraint.FindConstraints(ply:GetNWEntity("Ragdoll"), 'Rope')
					local Try = math.random(1, 10 * RopeCount)
					ply.stamina = ply.stamina - 7
									
					local phys = rag:GetPhysicsObjectNum(1)
					local speed = 1500
					local shadowparams = {
						secondstoarrive = 0.05,
						pos = phys:GetPos() + phys:GetAngles():Forward() * 20,
						angle = phys:GetAngles(),
						maxangulardamp = 30,
						maxspeeddamp = 30,
						maxangular = 90,
						maxspeed = speed,
						teleportdistance = 0,
						deltatime = 0.01,
					}
					phys:Wake()
					phys:ComputeShadowControl(shadowparams)
					
					if Try > (6 * RopeCount) or ((rag.IsWeld or 0) > 0) then
						if RopeCount > 1 or (rag.IsWeld or 0 > 0) then
							if RopeCount > 1 then
								ply:ChatPrint("Осталось: " .. RopeCount - 1)
							end
							if (rag.IsWeld or 0) > 0 then
								ply:ChatPrint("Осталось отбить гвоздей: " .. tostring(math.ceil(rag.IsWeld)))
								ply.Bloodlosing = ply.Bloodlosing + 10
								ply.pain = ply.pain + 20
							end
						else
							ply:ChatPrint("Ты развязался")
							rag.Cuffed = false
							rag:GetNWBool("Cuffed")
						end
						
						Ropes[1].Constraint:Remove()
						rag:EmitSound("rust/handcuffs/handcuffs-admire-0"..math.random(1,4)..".ogg", 90, 50, 0.5, CHAN_AUTO)
					else
						--ply:ChatPrint("Неудачная попытка.")
						ply:ChatPrint("Failed attempt.")
					end
				end				

				if(ply:KeyDown(IN_ATTACK))then
					local pos = ply:EyePos()
					pos[3] = head:GetPos()[3]
					if !ply.FakeShooting and ply.Organs["carotidartery"]!=0 then
						local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" )) )
						local phys2 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Forearm" )) )
						local ang=ply:EyeAngles()
						ang:RotateAroundAxis(eyeangs:Forward(),90)
						ang:RotateAroundAxis(eyeangs:Right(),75)
						ang:RotateAroundAxis(ang:Up(),100)

						local shadowparams = {
							secondstoarrive=ply:GetNWFloat("HandsArrive"),
							pos=head:GetPos()+eyeangs:Forward()*45+eyeangs:Right()*-12,
							angle=ang,
							maxangular=670,
							maxangulardamp=600,
							maxspeeddamp=50,
							maxspeed=3000,
							teleportdistance=0,
							deltatime=0.01,
						}
						local shadowparams2 = {
							secondstoarrive=0.01,
							pos=head:GetPos()+eyeangs:Forward()*25+eyeangs:Right()*-12+eyeangs:Up()*5,
							angle=ang,
							maxangular=670,
							maxangulardamp=600,
							maxspeeddamp=50,
							maxspeed=3000,
							teleportdistance=0,
							deltatime=0.01,
						}
						phys:Wake()
						phys:ComputeShadowControl(shadowparams2)
						phys2:Wake()
						phys2:ComputeShadowControl(shadowparams)
					end
				end

				if ply.curweapon and weapons.Get(ply.curweapon) and weapons.Get(ply.curweapon).Primary.Automatic then
					if ply:KeyDown(IN_ATTACK) then
						if ply.FakeShooting then FireShot(ply.wep) end
					end
				else
					if ply:KeyPressed(IN_ATTACK) then
						if ply.FakeShooting then FireShot(ply.wep) end
					end
				end

				if(ply:KeyDown(IN_ATTACK2))then
					local physa = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )) )
					local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Forearm" )) ) --rhand
					local ang=ply:EyeAngles()
					ang:RotateAroundAxis(eyeangs:Forward(),90)
					ang:RotateAroundAxis(eyeangs:Right(),75)
					ang:RotateAroundAxis(ang:Up(),90)
					local pos = ply:EyePos()
					pos[3] = head:GetPos()[3]
					local shadowparams = {
						secondstoarrive=ply:GetNWEntity("HandsArrive"),
						pos=head:GetPos()+eyeangs:Forward()*45+eyeangs:Right()*15,
						angle=ang,
						maxangular=670,
						maxangulardamp=100,
						maxspeeddamp=50,
						maxspeed=600,
						teleportdistance=0,
						deltatime=0.01,
					}
					local shadowparams2 = {
						secondstoarrive=0.01,
						pos=head:GetPos()+eyeangs:Forward()*25+eyeangs:Right()*19+eyeangs:Up()*1,
						angle=ang,
						maxangular=670,
						maxangulardamp=600,
						maxspeeddamp=50,
						maxspeed=3000,
						teleportdistance=0,
						deltatime=0.01,
					}
					physa:Wake()
					phys:Wake()
					phys:ComputeShadowControl(shadowparams)
					if (!ply.suiciding or ply.curweapon and weapons.Get(ply.curweapon).TwoHands) then
						if IsValid(ply.wep) and weapons.Get(ply.curweapon).TwoHands  then
							local ang = ply:EyeAngles()
							ang:RotateAroundAxis(ang:Forward(),90)
							ang:RotateAroundAxis(ang:Up(),20)
							ang:RotateAroundAxis(ang:Right(),10)
							shadowparams2.angle = ang

							ply.wep:GetPhysicsObject():ComputeShadowControl(shadowparams2)
	
							shadowparams2.pos=shadowparams2.pos
							phys:ComputeShadowControl(shadowparams)
							shadowparams2.pos=shadowparams2.pos+eyeangs:Forward()*-22+eyeangs:Right()*-22
							physa:ComputeShadowControl(shadowparams2)
	
						elseif IsValid(ply.wep) and IsValid(ply.wep:GetPhysicsObject())then
	
							ang:RotateAroundAxis(ply:EyeAngles():Forward(),60)
							ang:RotateAroundAxis(ply:EyeAngles():Up(),155)
							ang:RotateAroundAxis(eyeangs:Right(),-20)
	
							shadowparams2.angle=ang
							shadowparams2.pos=shadowparams2.pos+eyeangs:Right()*-15
	
							ply.wep:GetPhysicsObject():ComputeShadowControl(shadowparams2)
							physa:ComputeShadowControl(shadowparams2)
						else
							physa:ComputeShadowControl(shadowparams2)
						end
					else
						if ply.FakeShooting and IsValid(ply.wep) then
							shadowparams2.maxspeed=500
							shadowparams2.maxangular=500
							shadowparams2.pos=head:GetPos()-ply.wep:GetAngles():Forward()*12
							shadowparams2.angle=ply.wep:GetPhysicsObject():GetAngles()
							ply.wep:GetPhysicsObject():ComputeShadowControl(shadowparams2)
							physa:ComputeShadowControl(shadowparams2)
						end
					end
				end
				
				if(ply:KeyDown(IN_USE))then
					local phys = head
					local phys2 = spinemain
					local angs = ply:EyeAngles()
					local angs2 = ply:EyeAngles()
					local angs3 = ply:EyeAngles()
					if not firstnigger then
						firstnigger = 0
					end
					if angs[1] > -85 and angs[1] < 85 then
					firstnigger = Lerp(0.0025,firstnigger,100)
					angs:RotateAroundAxis(angs:Right(),firstnigger)
					elseif angs[1] < -85 then
					firstnigger = Lerp(0.0025,firstnigger,180)
					angs:RotateAroundAxis(angs:Right(),firstnigger)
					elseif angs[1] > 85 then
					firstnigger = Lerp(0.0025,firstnigger,0)
					angs:RotateAroundAxis(angs:Right(),firstnigger)
					end
					--ply:ChatPrint(firstnigger)
					angs:RotateAroundAxis(angs:Forward(),-90)
					angs2:RotateAroundAxis(angs:Forward(),-90)
					angs2:RotateAroundAxis(angs:Right(),120)
					angs2:RotateAroundAxis(angs:Up(),-150)
					--ply:ChatPrint(ply:EyeAngles()[1])
					local shadowparams3	 = { --зажать е и крутица
						secondstoarrive=0.0001,
						pos=spinemain:GetPos() - eyeangs:Forward()*(0.01*rag:GetVelocity():Length()),
						angle=angs,
						maxangulardamp=2.5,
						maxspeeddamp=10,
						maxangular=370,
						maxspeed=120,
						teleportdistance=0,
						deltatime=deltatime,
					}
					local shadowparams322 = {
						secondstoarrive=0.0001,
						pos=spine2:GetPos() - eyeangs:Forward()*(0.0035*rag:GetVelocity():Length()),
						angle=angs,
						maxangulardamp=2.5,
						maxspeeddamp=10,
						maxangular=370,
						maxspeed=120,
						teleportdistance=0,
						deltatime=deltatime,
					}
					local shadowparams4	 = {
						secondstoarrive=0.25,
						pos=spinemain:GetPos() - eyeangs:Forward()*(0.0035*rag:GetVelocity():Length()),
						angle=angs,
						maxangulardamp=2.5,
						maxspeeddamp=10,
						maxangular=370,
						maxspeed=40,
						teleportdistance=0,
						deltatime=deltatime,
					}
					local shadowparams42	 = {
						secondstoarrive=0.25,
						pos=spine2:GetPos() - eyeangs:Forward()*(0.0035*rag:GetVelocity():Length()),
						angle=angs,
						maxangulardamp=2.5,
						maxspeeddamp=10,
						maxangular=370,
						maxspeed=40,
						teleportdistance=0,
						deltatime=deltatime,
					}
					local shadowparams = {
						secondstoarrive=0.25,
						pos=head:GetPos()+ply:EyeAngles():Forward()*-5+ply:EyeAngles():Up()*5+vector_up*(400/math.Clamp(rag:GetVelocity():Length()/300,1,12)) + ply:EyeAngles():Up() * 4,
						angle=angs2,
						maxangulardamp=2.5,
						maxspeeddamp=10,
						maxangular=370,
						maxspeed=80,
						teleportdistance=0,
						deltatime=deltatime,
					}
					head:Wake()
					head:ComputeShadowControl(shadowparams)
				if rag:GetVelocity():Length() < 750 then
					if ply:GetNWBool("LeftArmm") or ply:GetNWBool("RightArmm") then
					spinemain:Wake()
					spinemain:ComputeShadowControl(shadowparams4)
					spine2:Wake()
					spine2:ComputeShadowControl(shadowparams42)
					else
					spinemain:Wake()
					spinemain:ComputeShadowControl(shadowparams3)	
					spine2:Wake()
					spine2:ComputeShadowControl(shadowparams322)		
					end
				end
				end
			end
			if(ply:KeyDown(IN_SPEED)) and (RagdollOwner(rag) and !RagdollOwner(rag).Otrub) and !timer.Exists("StunTime"..ply:EntIndex()) and not rag.Cuffed then
				local bone = rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" ))
				local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" )) )
				if ply.Organs["carotidartery"] == 0 and !weapons.Get(ply.curweapon).TwoHands then
					local shadowparams = {
					secondstoarrive=0.01,
					pos=head:GetPos(),
					angle=angs,
					maxangulardamp=10,
					maxspeeddamp=10,
					maxangular=370,
					maxspeed=1120,
					teleportdistance=0,
					deltatime=deltatime,
					}
					phys:Wake()
					phys:ComputeShadowControl(shadowparams)
					ply.holdingartery=true
					if(IsValid(rag.ZacConsLH))then
						rag.ZacConsLH:Remove()
						rag.ZacConsLH=nil
					end
				end
				if(!IsValid(rag.ZacConsLH) and (!rag.ZacNextGrLH || rag.ZacNextGrLH<=CurTime()))then
					
					rag.ZacNextGrLH=CurTime()+0.1
					for i=1,3 do
						local offset = phys:GetAngles():Up()*-5
						if(i==2)then
							offset = phys:GetAngles():Right()*5
						end
						if(i==3)then
							offset = phys:GetAngles():Right()*-5
						end
						local traceinfo={
							start=phys:GetPos(),
							endpos=phys:GetPos()+offset,
							filter=rag,
							output=trace,
						}
						local trace = util.TraceLine(traceinfo)
						if(trace.Hit and !trace.HitSky and not ply.holdingartery)then
							local cons = constraint.Weld(rag,trace.Entity,bone,trace.PhysicsBone,0,false,false)
							if(IsValid(cons))then
								ply:SetNWBool("LeftArmm",true)
								rag:EmitSound("grabhand.wav",500,100,0.3,CHAN_AUTO)
								rag.ZacConsLH=cons
							end
							break
						elseif(trace.Hit and trace.HitSky)then
							ply:SetNWBool("LeftArmm",false)
						end
					end
				end
			else
				if ply.arterybleeding then ply.holdingartery=false end
				if(IsValid(rag.ZacConsLH))then
					rag.ZacConsLH:Remove()
					rag.ZacConsLH=nil
					ply:SetNWBool("LeftArmm",false)
				end
			end
			if(ply:KeyDown(IN_WALK)) and !RagdollOwner(rag).Otrub and !timer.Exists("StunTime"..ply:EntIndex()) and not rag.Cuffed then
				local bone = rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" ))
				local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )) )
				if(!IsValid(rag.ZacConsRH) and (!rag.ZacNextGrRH || rag.ZacNextGrRH<=CurTime()))then
					if ply.Organs["carotidartery"] == 0 then
						local shadowparams = {
						secondstoarrive=0.01,
						pos=head:GetPos(),
						angle=angs,
						maxangulardamp=10,
						maxspeeddamp=10,
						maxangular=370,
						maxspeed=1120,
						teleportdistance=0,
						deltatime=deltatime,
						}
						phys:Wake()
						phys:ComputeShadowControl(shadowparams)
						ply.holdingartery=true
						if(IsValid(rag.ZacConsLH))then
							rag.ZacConsRH:Remove()
							rag.ZacConsRH=nil
						end
					end
					rag.ZacNextGrRH=CurTime()+0.1
					for i=1,3 do
						local offset = phys:GetAngles():Up()*5
						if(i==2)then
							offset = phys:GetAngles():Right()*5
						end
						if(i==3)then
							offset = phys:GetAngles():Right()*-5
						end
						local traceinfo={
							start=phys:GetPos(),
							endpos=phys:GetPos()+offset,
							filter=rag,
							output=trace,
						}
						local trace = util.TraceLine(traceinfo)
						if(trace.Hit and !trace.HitSky and ply.Organs["carotidartery"] != 0 )then
							local cons = constraint.Weld(rag,trace.Entity,bone,trace.PhysicsBone,0,false,false)
							if(IsValid(cons))then
								ply:SetNWBool("RightArmm",true)
								rag.ZacConsRH=cons
								rag:EmitSound("grabhand.wav",500,100,0.3,CHAN_AUTO)
							end
							break
						elseif(trace.Hit and trace.HitSky)then
							ply:SetNWBool("RightArmm",false)
						end
					end
				end
			else
				if(IsValid(rag.ZacConsRH))then
					rag.ZacConsRH:Remove()
					rag.ZacConsRH=nil
					ply:SetNWBool("RightArmm",false)
				end
			end
			if(ply:KeyDown(IN_FORWARD) and IsValid(rag.ZacConsLH))then
				local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine" )) )
				local lh = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" )) )
				local angs = ply:EyeAngles()
				angs:RotateAroundAxis(angs:Forward(),-90)
				local speed = 70

				if(rag.ZacConsLH.Ent2:GetVelocity():LengthSqr()<1000) then
					local shadowparams1 = {
						secondstoarrive=ply:GetNWFloat("ForwardArrive") / 1.1,
						pos=lh:GetPos() + ply:EyeAngles():Forward() * 130 + ply:EyeAngles():Up() * 60,
						angle=angs,
						maxangulardamp=10,
						maxspeeddamp=10,
						maxangular=50,
						maxspeed=speed,
						teleportdistance=0,
						deltatime=deltatime,
					}
					local shadowparams1fix = {
						secondstoarrive=ply:GetNWFloat("ForwardArrive"),
						pos=lh:GetPos() + ply:EyeAngles():Forward() * 50 + ply:EyeAngles():Up() * 60,
						angle=angs,
						maxangulardamp=10,
						maxspeeddamp=10,
						maxangular=50,
						maxspeed=speed / 2,
						teleportdistance=0,
						deltatime=deltatime,
					}
					phys:Wake()
					phys:ComputeShadowControl(shadowparams1)
				end
			end
			if(ply:KeyDown(IN_FORWARD) and IsValid(rag.ZacConsRH))then
				local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine" )) )
				local lh = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )) )
				local angs = ply:EyeAngles()

				angs:RotateAroundAxis(angs:Forward(),-90)
				local speed = 70

				if(rag.ZacConsRH.Ent2:GetVelocity():LengthSqr()<1000) then
					local shadowparams1 = {
						secondstoarrive=ply:GetNWFloat("ForwardArrive") / 1.1,
						pos=lh:GetPos() + ply:EyeAngles():Forward() * 130 + ply:EyeAngles():Up() * 60,
						angle=angs,
						maxangulardamp=10,
						maxspeeddamp=10,
						maxangular=50,
						maxspeed=speed,
						teleportdistance=0,
						deltatime=deltatime,
					}
					local shadowparams1fix = {
						secondstoarrive=ply:GetNWFloat("ForwardArrive"),
						pos=lh:GetPos() + ply:EyeAngles():Forward() * 50 + ply:EyeAngles():Up() * 60,
						angle=angs,
						maxangulardamp=10,
						maxspeeddamp=10,
						maxangular=50,
						maxspeed=speed / 2,
						teleportdistance=0,
						deltatime=deltatime,
					}
					phys:Wake()
					phys:ComputeShadowControl(shadowparams1)	
				end
			end
			if(ply:KeyDown(IN_BACK) and IsValid(rag.ZacConsLH))then
				local phys = rag:GetPhysicsObjectNum( 1 )
				local chst = rag:GetPhysicsObjectNum( 0 )
				local angs = ply:EyeAngles()
				angs:RotateAroundAxis(angs:Forward(),90)
				angs:RotateAroundAxis(angs:Up(),90)
				local speed = 60
				
				if(rag.ZacConsLH.Ent2:GetVelocity():LengthSqr()<1000)then
					local shadowparams = {
						secondstoarrive=ply:GetNWFloat("BackArrive"),
						pos=chst:GetPos() + ply:EyeAngles():Forward() * -180 + ply:EyeAngles():Up() * 60,
						angle=phys:GetAngles(),
						maxangulardamp=10,
						maxspeeddamp=10,
						maxangular=50,
						maxspeed=speed,
						teleportdistance=0,
						deltatime=deltatime,
					}
					phys:Wake()
					phys:ComputeShadowControl(shadowparams)
				end
			end
			if(ply:KeyDown(IN_BACK) and IsValid(rag.ZacConsRH))then
				local phys = rag:GetPhysicsObjectNum( 1 )
				local chst = rag:GetPhysicsObjectNum( 0 )
				local angs = ply:EyeAngles()
				angs:RotateAroundAxis(angs:Forward(),90)
				angs:RotateAroundAxis(angs:Up(),90)
				local speed = 60
				
				if(rag.ZacConsRH.Ent2:GetVelocity():LengthSqr()<1000)then
					local shadowparams = {
						secondstoarrive=ply:GetNWFloat("BackArrive"),
						pos=chst:GetPos() + ply:EyeAngles():Forward() * -180  + ply:EyeAngles():Up() * 60,
						angle=phys:GetAngles(),
						maxangulardamp=10,
						maxspeeddamp=10,
						maxangular=50,
						maxspeed=speed,
						teleportdistance=0,
						deltatime=deltatime,
					}
					phys:Wake()
					phys:ComputeShadowControl(shadowparams)
				end
			end
		end
	end
	end)

	hook.Add("Player Think","VelocityPlayerFallOnPlayerCheck",function(ply,time)
		local speed = ply:GetVelocity():Length()
		if ply:GetMoveType() ~= MOVETYPE_NOCLIP and not ply.fake and not ply:HasGodMode() and ply:Alive() then
			if speed < 400 then return end
			if hook.Run("Should Fake Velocity",ply,speed) ~= nil then return end
			if ply.isSCP then return end
				Faking(ply)
		end
	end)
	util.AddNetworkString("ebal_chellele")
	hook.Add("PlayerSwitchWeapon","fakewep",function(ply,oldwep,newwep)
		if ply.Otrub then return true end

		if ply.fake then
			if IsValid(ply.Info.ActiveWeapon2) and IsValid(ply.wep) and ply.wep.Clip!=nil and ply.wep.Amt!=nil and ply.wep.AmmoType!=nil then
				ply.Info.ActiveWeapon2:SetClip1((ply.wep.Clip or 0))
				ply:SetAmmo((ply.wep.Amt or 0), (ply.wep.AmmoType or 0))
			end

			if newwep.Base == 'b3bros_base' then
				if IsValid(ply.wep) then DespawnWeapon(ply) end
				ply:SetActiveWeapon(newwep)
				ply.Info.ActiveWeapon=newwep
				ply.curweapon=newwep:GetClass()
				SavePlyInfo(ply)
				ply:SetActiveWeapon(nil)
				SpawnWeapon(ply)
				ply.FakeShooting=true
			else
				if IsValid(ply.wep) then DespawnWeapon(ply) end
				ply:SetActiveWeapon(nil)
				ply.curweapon=nil
				ply.FakeShooting=false
			end
			net.Start("ebal_chellele")
			net.WriteEntity(ply)
			net.WriteString(ply.curweapon or "")
			net.Broadcast()
			return true
		end
	end)

	function PlayerMeta:HuySpectate()
		local ply = self
		ply:Spectate(OBS_MODE_CHASE)
		ply:UnSpectate()

		ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		ply:SetMoveType(MOVETYPE_OBSERVER)
	end

	OrgansNextThink = 0
	InternalBleeding = 20
	local player_GetAll = player.GetAll

	hook.Add("Player Think","InternalBleeding",function(ply,time)
		for i,ply in pairs(player_GetAll()) do
			ply.OrgansNextThink = ply.OrgansNextThink or OrgansNextThink
			if not(ply.OrgansNextThink>CurTime())then
				ply.OrgansNextThink=CurTime() + 0.2
				if ply.Organs and ply:Alive() then
					if ply.Organs["brain"]==0 then
						ply.KillReason = "braindeath"
						ply:Kill()
					end
					if ply.Organs["liver"]==0 then
						ply.InternalBleeding=ply.InternalBleeding or InternalBleeding
						ply.InternalBleeding=math.max(ply.InternalBleeding-0.1,0)
						ply.Blood=ply.Blood-ply.InternalBleeding / 10
					end
					if ply.Organs["stomach"]==0 then
						ply.InternalBleeding2=ply.InternalBleeding2 or InternalBleeding
						ply.InternalBleeding2=math.max(ply.InternalBleeding2-0.1,0)
						ply.Blood=ply.Blood-ply.InternalBleeding2 / 10
					end
					if ply.Organs["intestines"]==0 then
						ply.InternalBleeding3=ply.InternalBleeding3 or InternalBleeding
						ply.InternalBleeding3=math.max(ply.InternalBleeding3-0.1,0)
						ply.Blood=ply.Blood-ply.InternalBleeding3 / 10
					end
					if ply.Organs["heart"]==0 then
						ply.InternalBleeding4=ply.InternalBleeding4 or InternalBleeding
						ply.InternalBleeding4=math.max(ply.InternalBleeding4*10-0.1,0)
						ply.Blood=ply.Blood-ply.InternalBleeding4*3 / 10
					end
					if ply.Organs["lungs"]==0 then
						ply.InternalBleeding5=ply.InternalBleeding5 or InternalBleeding
						ply.InternalBleeding5=math.max(ply.InternalBleeding5-0.1,0)
						ply.Blood=ply.Blood-ply.InternalBleeding5 / 10
					end
					ply.InternalBleeding6 = ply.InternalBleeding6 or 0
					ply.InternalBleeding6 = math.max(ply.InternalBleeding6-0.1,0)
					ply.Blood = ply.Blood - ply.InternalBleeding6 / 10

					if ply.Organs["spine"]==0 then
						ply.brokenspine=true
						if !ply.fake then Faking(ply) end
					end
					if ply.Paralizovan == true then
						ply.brokenspine=true
						if !ply.fake then Faking(ply) end
					else
						ply.brokenspine=false
					end
				end
			end
		end
	end)

	hook.Add("PlayerUse","nouseinfake",function(ply,ent)
		if not ply.fake then return end
		local class = ent:GetClass()

		if class == "prop_physics" or class=="prop_physics_multiplayer" or class == "func_physbox" then
			local PhysObj = ent:GetPhysicsObject()
			if PhysObj and PhysObj.GetMass and PhysObj:GetMass() > 14 then return false end
		end

		if ply.fake then return false end
		--if ent.IsJModArmor then return false end
	end)

	hook.Add("PlayerSay", "unconsay", function(ply,text)
		if not roundActive then return end
		if ply.Otrub and ply:Alive() then return false end
	end)

	hook.Add("PlayerSay","dropweaponhuy",function(ply,text)
		if string.lower(text)=="*drop" then
			if !ply.fake then
				ply:DropWeapon1()
				return ""
			else
				if IsValid(ply.wep) then
					if IsValid(ply.WepCons) then
						ply.WepCons:Remove()
						ply.WepCons=nil
					end
					if IsValid(ply.WepCons2) then
						ply.WepCons2:Remove()
						ply.WepCons2=nil
					end
					ply.wep.canpickup=true
					ply.wep:SetOwner()
					ply.wep.curweapon=ply.curweapon
					ply.Info.Weapons[ply.Info.ActiveWeapon].Clip1 = ply.wep.Clip
					ply:StripWeapon(ply.Info.ActiveWeapon)
					ply.Info.Weapons[ply.Info.ActiveWeapon]=nil
					ply.wep=nil
					ply.Info.ActiveWeapon=nil
					ply.Info.ActiveWeapon2=nil
					ply:SetActiveWeapon(nil)
					ply.FakeShooting=false
				else
					ply:PickupEnt()
				end
				return ""
			end
		end
	end)

	hook.Add("UpdateAnimation","huy",function(ply,event,data)
		ply:RemoveGesture(ACT_GMOD_NOCLIP_LAYER)
	end)

	end