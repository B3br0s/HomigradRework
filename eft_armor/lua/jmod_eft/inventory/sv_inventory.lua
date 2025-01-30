util.AddNetworkString("JMod_EFT_Inventory")

JMod = JMod or {}

function JMod.EZ_Open_EFT_Inventory(ply)
	net.Start("JMod_EFT_Inventory")
		net.WriteString(ply:GetModel())
	net.Send(ply)
end

net.Receive("JMod_EFT_Inventory", function(ln, ply)
	if not(ply:Alive()) then return end

	local ActionType=net.ReadInt(8)
    
	if (ActionType==1) then
		local ID=net.ReadString()
		JMod.RemoveArmorByID(ply, ID)
	elseif (ActionType==2) then
		local ID=net.ReadString()
		if (ply.EZarmor.items[ID]) then
			ply.EZarmor.items[ID].tgl=not ply.EZarmor.items[ID].tgl
		end
	elseif (ActionType==3) then
		local ID=net.ReadString()
		local ItemData=ply.EZarmor.items[ID]
		local ItemInfo=JMod.ArmorTable[ItemData.name]
		local RepairRecipe, RepairStatus, BuildRecipe={}, 0, nil
		for k, v in pairs(JMod.Config.Recipes) do
			if (v[1]==ItemInfo.ent) then
				if (ItemData.dur<ItemInfo.dur*.9) then
					BuildRecipe=v[2]
				end
				break
			end
		end
		if not(BuildRecipe) then BuildRecipe=JMod.BackupArmorRepairRecipes[ItemData.name] end
		if (BuildRecipe) then
			local DamagedFraction=1-(ItemData.dur/ItemInfo.dur)
			for resourceName, resourceAmt in pairs(BuildRecipe) do
				local RequiredAmt=math.floor(resourceAmt*DamagedFraction*1.2) -- 20% efficiency penalty for not needing a workbench
				if (RequiredAmt>0) then RepairRecipe[resourceName]=RequiredAmt end
			end
			RepairStatus=1
			---
			if (JMod.HaveResourcesToPerformTask(nil, nil, RepairRecipe, ply)) then
				RepairStatus=2
				JMod.ConsumeResourcesInRange(BuildRecipe, nil, nil, ply)
				ItemData.dur=ItemInfo.dur
			end
		end
		if (RepairStatus==0) then
			ply:PrintMessage(HUD_PRINTCENTER, "item can not be repaired")
		elseif (RepairStatus==1) then
			local mats=""
			for k, v in pairs(RepairRecipe) do
				mats=mats..k..",  "
			end
			ply:PrintMessage(HUD_PRINTCENTER, "missing resources for repair,  need "..mats)
		elseif (RepairStatus==2) then
			ply:PrintMessage(HUD_PRINTCENTER, "item repaired")
			for i=1, 10 do
				sound.Play("snds_jack_gmod/ez_tools/"..math.random(1, 27)..".wav", ply:GetPos(), 60, math.random(80, 120))
			end
		end
	elseif (ActionType==4) then
		local ID=net.ReadString()
		local ItemData=ply.EZarmor.items[ID]
		local ItemInfo=JMod.ArmorTable[ItemData.name]
		local RechargeRecipe, RechargeStatus={}, 0
		for resourceName, maxAmt in pairs(ItemInfo.chrg) do
			local missing=maxAmt-ItemData.chrg[resourceName]
			if (missing>0) then
				RechargeRecipe[resourceName]=missing*1.1 -- 10% penalty for doing this in the field
				RechargeStatus=1
			end
		end
		if (RechargeStatus==1) then
			if (JMod.HaveResourcesToPerformTask(nil, nil, RechargeRecipe, ply)) then
				RechargeStatus=2
				JMod.ConsumeResourcesInRange(RechargeRecipe, nil, nil, ply)
				for resourceName, maxAmt in pairs(ItemInfo.chrg) do
					ItemData.chrg[resourceName]=maxAmt
				end
			end
		end
		if (RechargeStatus==0) then
			ply:PrintMessage(HUD_PRINTCENTER, "item can not be recharged")
		elseif (RechargeStatus==1) then
			local mats=""
			for k, v in pairs(RechargeRecipe) do
				mats=mats..k..",  "
			end
			ply:PrintMessage(HUD_PRINTCENTER, "missing resources for recharge,  need "..mats)
		elseif (RechargeStatus==2) then
			ply:PrintMessage(HUD_PRINTCENTER, "item recharged")
			sound.Play("items/ammo_pickup.wav", ply:GetPos(), 60, math.random(100, 140))
		end
	end
	JMod.CalcSpeed(ply)
	JMod.EZarmorSync(ply)
end)
concommand.Add('jmod_eft_inv', JMod.EZ_Open_EFT_Inventory) 
