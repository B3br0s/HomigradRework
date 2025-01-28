-- sh_ammo.lua"

AddCSLuaFile()
hg.ammotypes = hg.ammotypes or {}
--[type_] = {1 = name,2 = spread,3 = dmg,4 = pen,5 = numbullet,6 = isrubber,7 = shockmul},
function SWEP:ApplyAmmoChanges(type_)
	local ammo = self.AmmoTypes[type_]
	self.Primary.Ammo = ammo[1]
	self.Primary.Spread = ammo[2]
	self.Primary.Damage = ammo[3]
	self.Penetration = ammo[4]
	self.NumBullet = ammo[5]
	self.RubberBullets = ammo[6]
	self.ShockMultiplier = ammo[7]
	if SERVER then
		net.Start("syncAmmoChanges")
		net.WriteEntity(self)
		net.WriteInt(type_, 4)
		net.Broadcast()
	end
end

if SERVER then
	util.AddNetworkString("syncAmmoChanges")
else
	net.Receive("syncAmmoChanges", function()
		local self = net.ReadEntity()
		local type_ = net.ReadInt(4)
		self:ApplyAmmoChanges(type_)
	end)
end

if CLIENT then
	local lply = LocalPlayer()
	hg.weapons = hg.weapons or {}
	concommand.Add("hg_unload_ammo", function(ply, cmd, args)
		local wep = ply:GetActiveWeapon()
		if wep and hg.weapons[wep] and wep:Clip1() > 0 and wep:CanUse() then
			net.Start("unload_ammo")
			net.WriteEntity(wep)
			net.SendToServer()
			wep:SetClip1(0)
			wep.drawBullet = false
		end
	end)

	concommand.Add("hg_change_ammotype", function(ply, cmd, args)
		local wep = ply:GetActiveWeapon()
		local type_ = math.Round(args[1])
		if wep and hg.weapons[wep] and wep:Clip1() == 0 and wep:CanUse() and wep.AmmoTypes and wep.AmmoTypes[type_] then
			--wep:ApplyAmmoChanges(type_)
			ply:ChatPrint("Changed ammotype to: " .. wep.AmmoTypes[type_][1])
			net.Start("changeAmmoType")
			net.WriteEntity(wep)
			net.WriteInt(type_, 4)
			net.SendToServer()
		end
	end)

	local function unloadAmmo()
		RunConsoleCommand("hg_unload_ammo")
	end

	local function changeAmmoType(chosen)
		RunConsoleCommand("hg_change_ammotype", chosen)
	end

	hook.Add("radialOptions", "hg-ammo-manipulations", function()
		local wep = LocalPlayer():GetActiveWeapon()
		if IsValid(wep) and hg.weapons[wep] then
			if wep:Clip1() == 0 and wep.AmmoTypes then
				local tbl = {
					changeAmmoType,
					"Change Ammo Type",
					true,
					{
						[1] = wep.AmmoTypes[1][1],
						[2] = wep.AmmoTypes[2][1]
					}
				}

				hg.radialOptions[#hg.radialOptions + 1] = tbl
			elseif wep:Clip1() > 0 then
				local tbl = {unloadAmmo, "Unload Ammo"}
				hg.radialOptions[#hg.radialOptions + 1] = tbl
			end
		end
	end)
else
	util.AddNetworkString("unload_ammo")
	util.AddNetworkString("changeAmmoType")
	net.Receive("unload_ammo", function(len, ply)
		local wep = net.ReadEntity()
		wep.drawBullet = false
		if wep and hg.weapons[wep] and wep:Clip1() > 0 and wep:CanUse() then
			ply:GiveAmmo(wep:Clip1(), wep:GetPrimaryAmmoType(), true)
			wep:SetClip1(0)
			hg.GetCurrentCharacter(ply):EmitSound("snd_jack_hmcd_ammotake.wav")
		end
	end)

	net.Receive("changeAmmoType", function(len, ply)
		local wep = net.ReadEntity()
		local type_ = net.ReadInt(4)
		if wep and hg.weapons[wep] and wep:Clip1() == 0 and wep:CanUse() and wep.AmmoTypes and wep.AmmoTypes[type_] then wep:ApplyAmmoChanges(type_) end
	end)
	--bruh probably need to broadcast this bullshit after
end