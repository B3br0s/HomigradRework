local SWEP = oop.Get("hg_wep")
if not SWEP then return end

SWEP.ReloadTime = 2

SWEP.Reload1 = "weapons/ak47/handling/ak47_magout.wav"
SWEP.Reload2 = "weapons/ak47/handling/ak47_magin.wav"
SWEP.Reload3 = "weapons/ak47/handling/ak47_boltback.wav"
SWEP.Reload4 = "weapons/ak47/handling/ak47_boltrelease.wav"

SWEP.ReloadMatrix = {
	[0] = function(self)
		local owner = self:GetOwner()

		local anim = owner:IsFlagSet(FL_ANIMDUCKING) and ACT_MP_RELOAD_CROUCH or ACT_MP_RELOAD_STAND

		if SERVER then
			if owner:IsNPC() then
				owner:RestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD,anim,true)
			else
				net.Start("wep reload gesture")//отправляем анимку
				net.WriteEntity(owner)
				net.WriteFloat(GESTURE_SLOT_ATTACK_AND_RELOAD)
				net.WriteFloat(anim)
				net.SendPVS(owner:GetPos())

				owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD,anim,true)
			end
		end
	end,
	[0.1] = function(self)//убираем магаз
		if CLIENT then
			if self.ClipBone then
				local gun = self:GetGun()
				gun:ManipulateBoneScale(gun:LookupBone(self.ClipBone),Vector(0.01,0.01,0.01))
			end
		else
			sound.Emit(self:EntIndex(),self.Reload1,75,0.75)
		end
	end,
	[0.4] = function(self)//ставим магаз
		if CLIENT then
			if self.ClipBone then
				local gun = self:GetGun()
				gun:ManipulateBoneScale(gun:LookupBone(self.ClipBone),Vector(1,1,1))
			end
		else
			sound.Emit(self:EntIndex(),self.Reload2,75,0.75)
		end
	end,
	[0.6] = function(self)//отводим затвор назад
		if self:GetNWInt("Chamber") == 0 then
			if SERVER then
				sound.Emit(self:EntIndex(),self.Reload3,75,0.75)
			else
				self:SetClipPos(1)
			end
		else
			self:SetNWFloat("GESTURE_RELOAD",CurTime() + 0.5)
			self:ReloadEnd()
			self.fightDelay = CurTime() + 0.35
		end
	end,
	[0.8] = function(self)//отводим затвор вперёд
		if SERVER then
			if self.Reload4 then sound.Emit(self:EntIndex(),self.Reload4,75,0.75) end
			self:SetClipPos(0)
			self.fightDelay = CurTime() + 0.1
		end
	end
}

function SWEP:DoAnimationEvent() return false end

SWEP:Event_Add("Step","Kill Reload Anim",function(self,owner,time)//сбрасывает анимацию перезарядки
	if owner:IsNPC() then return end

	local anim_pos = self:GetNWFloat("GESTURE_RELOAD",0) - time

	if anim_pos > 0 then owner:AnimSetGestureWeight(GESTURE_SLOT_ATTACK_AND_RELOAD,anim_pos,true) end
end)

if SERVER then
	util.AddNetworkString("wep reload gesture")
else
	net.Receive("wep reload gesture",function()
		local owner = net.ReadEntity()
		if not IsValid(owner) then return end
		
		owner:AnimRestartGesture(net.ReadFloat(),net.ReadFloat(),true)
	end)
end

SWEP.reloadAnim = 0
SWEP.reloadAnimSet = 0
SWEP.reloadAnimDelay = 0

function SWEP:ReloadFunc()
	local clip,maxClip = self:Clip1(),self:GetMaxClip1()
	local ammoType = self:GetPrimaryAmmoType()
	local owner = self:GetOwner()
	local ammo = (owner:IsNPC() and maxClip) or owner:GetAmmoCount(ammoType)

	self:SetClip1(math.min(clip + ammo,maxClip))

	if not owner:IsNPC() then
		owner:SetAmmo(ammo - (self:Clip1() - clip),ammoType)
	end
end

function SWEP:ReloadSet(reloadFunc)
	if self.HoldTypeReload then self:SetStandType(self.HoldTypeReload) self:SetupStandType() end

	self:GetOwner():SetAnimation(PLAYER_RELOAD)

	self.reloadedStart = CurTime()
	self.reloadedDelay = self.reloadedStart + self.ReloadTime
	self.reloadedBlad = -1

	if SERVER then
		self:SetNWFloat("ReloadStart",self.reloadedStart)
		self:SetNWBool("Reload",true)

		self.dwr_reverbDisable = true

		self.reloadFunc = reloadFunc//вызывется при завершении перезарядки
	end
end

function SWEP:ReloadCan()
	return self:CanFight() and not self.reloadedDelay and (self.attackDelay or 0) < CurTime()
end

function SWEP:Reload()
	local owner = self:GetOwner()

	if self.reloadAnimSet == 1 then//для удержания затвора на дробовике
		self.reloadAnimDelay = CurTime() + 0.025
	end
	
	if owner:IsNPC() then
		if self:ReloadCan() then self:ReloadStart() return end

		return
	end

	if self:Clip1() > 0 then
		if not self.ChamberAuto then
			if owner:KeyDown(IN_WALK) then
				
			else
				if self:ReloadCan() and self:InsertChamber() then
					if self.Reload3 then self:SoundEmit(self.Reload3) end
			
					self:SetClipPos(1)
					self.reloadAnimSet = 1
					self.reloadAnimDelay = CurTime() + 0.1

					self.holdPieMenu = nil
				end
			end
		end
	end
end

function SWEP:ReloadStart()
	local owner = self:GetOwner()

	local clip,maxClip = self:Clip1(),self:GetMaxClip1()
	local ammo = (owner:IsNPC() and maxClip) or owner:GetAmmoCount(self:GetPrimaryAmmoType())

	if clip >= maxClip or ammo == 0 then return end

	self:ReloadSet(self.ReloadFunc)
end

function SWEP:ReloadEnd()
	local func = self.ReloadMatrix[1]
	if func then func(self) end
	
	if self.HoldTypeReload then self:SetStandType(self.HoldType) self:SetupStandType() end

	if SERVER then
		local func = self.reloadFunc
		self.reloadFunc = nil

		if func then func(self) end
	end

	self:SetNWBool("Reload",false)

	self.reloadedDelay = nil
	self.reloadedStart = nil

	if self.ChamberAuto then self:InsertChamber(true) end
end

SWEP:Event_Add("Step Local","Reload",function(self,owner,time)
	if owner:IsNPC() then
		local name = owner:GetSequenceName(owner:GetSequence())

		if name == "reload_low" then self:Reload() end//костыли
	end

	if self.reloadAnimSet == 1 and self.reloadAnimDelay < time then
		if self.Reload4 then self:SoundEmit(self.Reload4) end

		self:SetClipPos(0)

		self.reloadAnimSet = 0
	end

	self.reloadAnim = LerpFT(self.reloadAnimSet == 1 and 0.5 or 0.95,self.reloadAnim,self.reloadAnimSet)
	self:SetNWFloat("ReloadAnim",self.reloadAnim)
end)

SWEP:Event_Add("Can Primary Attack","ReloadAnim",function(self)
	if self.reloadAnimSet > 0.05 or self:GetNWFloat("ReloadAnim",0) > 0.05 then return false end
end)

SWEP:Event_Add("Step Local","Reload Magazune",function(self,owner,time)
	local start = self.reloadedStart
	if not start then return end

	local gun = self:GetGun()

	local anim_pos = time - start
	local mul = self.ReloadTime
	local owner = self:GetOwner()

	for t,func in pairs(self.ReloadMatrix) do
		if anim_pos >= t * mul and self.reloadedBlad < t then
			self.reloadedBlad = t

			func(self)
		end
	end

	if self.HoldTypeReload then self:SetStandType(self.HoldTypeReload) self:SetupStandType() end

	if self.reloadedDelay and self.reloadedDelay < time then
		self:ReloadEnd()
    end
end,1)

SWEP.reloadAnimAng = Angle()

if CLIENT then
	SWEP:Event_Add("Pre CalcView","Reload",function(self,owner)//перед захватом позиции отводим все изменения
		owner:AddBoneAng("rhand",-self.reloadAnimAng)
		owner:SetupBones()
	end)

	SWEP:Event_Add("Post CalcView","Reload",function(self,owner)//возвращаем на место для рендера, перед рендором все кости изменяются.
		owner:AddBoneAng("rhand",self.reloadAnimAng)
	end)
end

SWEP:Event_Add("Step","Reload",function(self,owner,time)
    local anim = self:GetNWFloat("ReloadAnim",0)

	self.reloadAnimAng = Angle(0,-25 * anim,-25 * anim)
	if owner.rhand then owner.rhand:Add(self.reloadAnimAng) end
end,1)

if SERVER then
	util.AddNetworkString("weapon reload")

	net.Receive("weapon reload",function(len,ply)
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or not wep.ReloadCan or not wep:ReloadCan() then return end

		wep:ReloadStart()
	end)
end

local abs = math.abs

SWEP:Event_Add("Step Local","Reload Menu",function(self,owner,time)
	if CLIENT then
		if input.IsKeyDown(KEY_R) then
			if not self.reloadedDelay and not PieMenu:IsOpen() and abs(self:GetNWFloat("ReloadAnim") or 0) <= 0.01 and (self.reloadAnimDelay or 0) < time and (self.delayReload or 0) < time then
				self.AmmoChek = 3

				if not self.holdPieMenu then self.holdPieMenu = time + 0.35 end

				if self.holdPieMenu <= time then
					self.holdPieMenu = nil
					
					PieMenu:Init()

					local option = PieMenu:CreateOption()
					option.title = "Разрядить"
					option.footer = "Добавляет патроны в инвентарь"
					option.icon = Material("ez_resource_icons/ammo.png")
					option.callback = function()
						RunConsoleCommand("hg_wep_unload",tostring(self:EntIndex()))
					end

					option:SetCondition(function() return self:Clip1() > 0 end)

					local option = PieMenu:CreateOption()

					option.title = "Выкинуть оружие"
					option.icon = Material("icon16/arrow_redo.png")
					option.callback = function()
						RunConsoleCommand("drop")
					end

					PieMenu:Open()
				end
			end
		else
			if PieMenu:IsOpen() then
				PieMenu:Close()
			else
				if self.holdPieMenu then
					if self:ReloadCan() then//ну х3 мож чтоб серв присылал надо х3х3х3х3х
						net.Start("weapon reload")
						net.SendToServer()
						
						self:ReloadStart()
					end
				end
			end

			self.holdPieMenu = nil
		end
	end
end,-1)

if CLIENT then
	SWEP:Event_Add("Off","Reload",function() PieMenu:Close() end)
end

local blacklist = {
	["Weapon_357.RemoveLoader"] = true,
	["Weapon_357.OpenLoader"] = true,
	["Weapon_357.ReplaceLoader"] = true,
}

hook.Add("EntityEmitSound","RemoveShit",function(data)
	if blacklist[data.OriginalSoundName] then return false end
end)

SWEP:Event_Add("Holster","ReloadEnd",function(self,owner)
	self.reloadedDelay = nil
	self.reloadedStart = nil
	self:SetNWBool("Reload",false)

	if not owner:IsNPC() then owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD,0,true) end
end)

if SERVER then
	local reloadFunc = function(self)
		local ammoid = self:GetPrimaryAmmoType()
		
		local owner = self:GetOwner()
		owner:SetAmmo(owner:GetAmmoCount(ammoid) + self:Clip1(),ammoid)

		self:SetClip1(0)
	end

	util.AddNetworkString("wep unload")

    concommand.Add("hg_wep_unload",function(ply,cmd,args)
        local wep = Entity(tonumber(args[1] or 0))

        if ply:GetActiveWeapon() ~= wep then return end--BAAAAAAAAAAAAAN!!!11111

        local ammo = wep:Clip1()
		if ammo <= 0 then return end

		wep:SetNWInt("Chamber",0)
		wep:ReloadSet(reloadFunc)

		net.Start("wep unload")
		net.Send(ply)
    end)
else
	net.Receive("wep unload",function()
		local wep = LocalPlayer():GetActiveWeapon()
		wep:SetNWInt("Chamber",0)
		wep:ReloadSet()
	end)
end