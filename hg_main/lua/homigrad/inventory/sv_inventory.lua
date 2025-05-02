util.AddNetworkString("inventory")
util.AddNetworkString("hg loot")
util.AddNetworkString("ply_take_item")
util.AddNetworkString("ply_take_ammo")
util.AddNetworkString("DropItemInv")

local BlackListWep = {
	["weapon_hands"] = true,
	["weapon_physgun"] = true,
	["gmod_tool"] = true,
	["gmod_camera"] = true,
}

hg.loots = hg.loots or {}

hg.loots.small_crate = {
	"weapon_knife",
	"weapon_hatchet",
	"weapon_kknife",
	"weapon_burger",
	"weapon_water_bottle",
	"weapon_chips",
	"weapon_energy_drink",
}

hg.loots.medium_crate = {
	"weapon_glock17",
	"weapon_handcuffs",
	"weapon_knife",
	"weapon_tomahawk",
	"weapon_shovel",
	"weapon_fiveseven",
	"weapon_pbat",
	"weapon_hatchet",
	"weapon_chips",
	"weapon_energy_drink",
	"weapon_painkillers_hg",
}

hg.loots.large_crate = {
	"weapon_mp7",
	"weapon_knife",
	"weapon_shammer",
	"weapon_shovel",
	"weapon_painkillers_hg",
	"weapon_bandage",
	"weapon_medkit_hg",
	"weapon_adrenaline",
	"weapon_faxe",
	"weapon_pbat",
	"weapon_hatchet",
	"weapon_mp9",
	"weapon_r8",
}

hg.loots.melee_crate = {
	"weapon_bat",
	"weapon_kknife",
	"weapon_shovel",
	"weapon_faxe",
	"weapon_faxe",
	"weapon_knife",
	"weapon_tomahawk",
	"weapon_hatchet",
	"weapon_pipe",
	"weapon_shammer",
	"weapon_shammer",
	"weapon_pipe",
}

hg.loots.weapon_crate = {
	"weapon_mp5",
	"weapon_mag7",
	"weapon_mp7",
	"weapon_r8",
	"weapon_ak47",
	"weapon_mp9",
	"weapon_deagle",
	"weapon_glock17",
	"weapon_m4a1",
	"weapon_m9",
	"weapon_pipe",
}

hg.loots.medkit_crate = {
	"weapon_medkit_hg",
	"weapon_bandage",
	"weapon_bandage",
	"weapon_bandage",
	"weapon_painkillers_hg",
	"weapon_adrenaline",
}


hook.Add("Player Think","Homigrad_Loot_Inventory",function(ply)
	if !ply:Alive() then
		return
	end

	if ply.Fake then
		return
	end
	if ply:KeyDown(IN_ATTACK2) and ply:KeyPressed(IN_USE) then
		local tr = hg.eyeTrace(ply)

		if tr.Entity then
			local ent = tr.Entity

			if ent:IsRagdoll() and hg.RagdollOwner(ent) != NULL and ent.Inventory then
				net.Start("hg inventory")
				net.WriteEntity(ent)
				net.WriteTable(ent.Inventory)
				net.WriteFloat(8)
				net.Send(ply)
			end
		end
	end
end)

net.Receive("hg loot",function(len,ply)
	if !ply:Alive() then
		return
	end
	local ent = net.ReadEntity()
	local taked = net.ReadString()

	if !ent.Inventory then
		return
	end

	if table.HasValue(ent.Inventory,taked) then
		table.RemoveByValue(ent.Inventory,taked)

		if weapons.Get(taked) then
			if ply:HasWeapon(taked) then
				local ent_wep = ents.Create(taked)
				ent_wep:Spawn()
				ent_wep:SetPos(ent:GetPos() + vector_up * 32)
				ent_wep.IsSpawned = true

				if ent:IsRagdoll() and hg.RagdollOwner(ent):Alive() and hg.RagdollOwner(ent).FakeRagdoll == ent then
					hg.RagdollOwner(ent):StripWeapon(taked)
				end

				if ent_wep.ishgwep then
					ent_wep:EmitSound("snd_jack_hmcd_ammotake.wav")
					ent_wep:SetClip1(0)
					ply:GiveAmmo(ent_wep:GetMaxClip1(),ent_wep:GetPrimaryAmmoType(),true)
				end
			else
				local wep = ply:Give(taked)
				if ent:IsRagdoll() and hg.RagdollOwner(ent):Alive() and hg.RagdollOwner(ent).FakeRagdoll == ent then

					local wep2 = hg.RagdollOwner(ent):GetWeapon(taked)

					wep:SetClip1(wep2:Clip1())
				end
			end


			if ent:IsRagdoll() and hg.RagdollOwner(ent):Alive() and hg.RagdollOwner(ent).FakeRagdoll == ent then
				hg.RagdollOwner(ent):StripWeapon(taked)
			end
		end

		if weapons.Get(taked).isMelee then
			for _, wep in ipairs(ply:GetWeapons()) do
				if wep.isMelee and wep:GetClass() != taked then
					ply:DropWep(wep)
				end
			end
		end

		if weapons.Get(taked).TwoHands then
			for _, wep in ipairs(ply:GetWeapons()) do
				if wep.TwoHands and wep:GetClass() != taked then
					ply:DropWep(wep)
				end
			end
		end

		if weapons.Get(taked).TwoHands != nil then
			for _, wep in ipairs(ply:GetWeapons()) do
				if wep.TwoHands == false and weapons.Get(taked).TwoHands == false and wep:GetClass() != taked then
					ply:DropWep(wep)
				end
			end
		end
	else
		net.Start("localized_chat")
        net.WriteString('item_notexist')
        net.Send(ply)
	end
end)

local function send(ply,lootEnt,remove)
	if ply then
		net.Start("inventory")
		net.WriteEntity(not remove and lootEnt or nil)
		net.WriteTable(lootEnt.Info.Weapons)
		net.WriteTable(lootEnt.Info.Ammo)
		net.Send(ply)
	else
		if lootEnt.UsersInventory and istable(lootEnt.UsersInventory) then
			for ply in pairs(lootEnt.UsersInventory) do
				if not IsValid(ply) or not ply:Alive() or remove then lootEnt.UsersInventory[ply] = nil end

				send(ply,lootEnt,remove)
			end
		end
	end
end

hg.send = send

net.Receive("DropItemInv",function(l,ply)
    local wepdrop = net.ReadString()
    if !ply:HasWeapon(wepdrop) then
        return
    end
    
    ply:DropWep(ply:GetWeapon(wepdrop))

end)

hook.Add("PlayerCanPickupWeapon","Homigrad_Shit",function(ply,ent)
	local tr = hg.eyeTrace(ply)
	if ply:HasWeapon(ent:GetClass()) and hg.Weapons[ent] then
		ply:GiveAmmo(ent:Clip1(),ent:GetPrimaryAmmoType(),true)
		ent:SetClip1(0)
		return false
	end
	if ply:HasWeapon(ent:GetClass()) then
		return false
	end
	if hg.eyeTrace(ply).Entity == ent and ply:KeyDown(IN_USE) or (ent:GetPos():Distance(ply:GetPos()) < 45) and ply:KeyDown(IN_USE) then
		if ent.isMelee then
				for _, wep in ipairs(ply:GetWeapons()) do
					if wep.isMelee then
						ply:DropWep(wep)
					end
				end
			end
		
			if ent.TwoHands then
				for _, wep in ipairs(ply:GetWeapons()) do
					if wep.TwoHands then
						ply:DropWep(wep)
					end
				end
			end
		
			if ent.TwoHands != nil then
				for _, wep in ipairs(ply:GetWeapons()) do
					if wep.TwoHands == false and ent.TwoHands == false then
						ply:DropWep(wep)
					end
				end
			end
			return true
		end
		if !ent.IsSpawned then
			if ent.isMelee then
				for _, wep in ipairs(ply:GetWeapons()) do
					if wep.isMelee then
						ply:DropWep(wep)
					end
				end
			end
		
			if ent.TwoHands then
				for _, wep in ipairs(ply:GetWeapons()) do
					if wep.TwoHands then
						ply:DropWep(wep)
					end
				end
			end
		
			if ent.TwoHands != nil then
				for _, wep in ipairs(ply:GetWeapons()) do
					if wep.TwoHands == false and ent.TwoHands == false then
						ply:DropWep(wep)
					end
				end
			end

		return true
	else
		return false
	end
end)

hook.Add("Player Think","Homigrad_Limit",function(ply)
	local inv = {}

	for _, wep in ipairs(ply:GetWeapons()) do
		if BlackListWep[wep:GetClass()] then
			continue 
		end
		table.insert(inv,wep)
	end

	local invs = {}

	for _, wep in ipairs(ply:GetWeapons()) do
		if BlackListWep[wep:GetClass()] then
			continue 
		end
		table.insert(invs,wep:GetClass())
	end


	ply.Inventory = invs

	if #inv > 8 then
		local a,b = table.Random(inv)
		if a != ply:GetActiveWeapon() then
			ply:DropWep(a)
		end
	end
end)