-- sh_worldmodel.lua"

AddCSLuaFile()
--
hook.Add("PhysgunPickup", "homigrad-weapons", function(ply, ent) if ent:GetNWBool("nophys") then return false end end)
SWEP.WorldPos = Vector(13, -0.3, 3.4)
SWEP.WorldAng = Angle(5, 0, 180)
SWEP.UseCustomWorldModel = false
local ValidWeaponBases = {
    ["weapon_m4super"] = true,
    ["weapon_870"] = true,
    ["homigrad_base"] = true,
}
if SERVER then
	util.AddNetworkString("give-me-guns")

	--[[local entityMeta = FindMetaTable("Entity")
	function entityMeta:SyncArmor()
		if self.armors then
			self:SetNetVar("Armor", self.armors)
		end
	end]]-- ОНО В ИНИТЕ БРОНИ

	hook.Add("PlayerSync", "sync_weapons", function(ply)
		--hg.SyncWeapons(ply)

		timer.Simple(1, function()
			if ply.SyncVars then ply:SyncVars() end
		end)
	end)
end

if CLIENT then
	concommand.Add("wm_getbones",function(ply)
		local self = ply:GetActiveWeapon()
		if !ValidWeaponBases[self.Base] then return end
		if self.worldModel then
			for boneID = 0, self.worldModel:GetBoneCount() - 1 do
				local boneName = self.worldModel:GetBoneName(boneID)
				print(boneName)
			end
		end
	end)
end

SWEP.weaponAng = Angle(0, 0, 0)
local angZero = Angle(0, 0, 0)
local math_max, math_Clamp = math.max, math.Clamp
function SWEP:GetAnimPos_Shoot2(time, timeSpan, timeAddEnd)
	local timeSpan = timeSpan or 0.2
	local timeAddEnd = timeAddEnd or 0
	local shootAnim = (timeSpan / 2 - math_Clamp(math.abs(CurTime() - (time + timeAddEnd)), 0, timeSpan / 2))
	return shootAnim
end

function SWEP:GetAnimShoot2()
	local animpos = self:GetAnimPos_Shoot2(self:LastShootTime(), 0.3, 0)
	--if animpos > 0 and CLIENT then print(animpos) end
	animpos = math.ease.OutQuart(animpos)
	if animpos > 0 then
		self.weaponAng = Angle(0, ((self.RecoilAnim and self.RecoilAnim * 2 or 0) * animpos or 0),0)
		animpos = animpos * math.max(self.Primary.Force / 100, 0)
		animpos = animpos * self.AnimShootMul or 1
		animpos = animpos / 4 * self:GetPrimaryMul()
		animpos = animpos * self.AnimShootHandMul or 1
		animpos = animpos * (self.LHandPos and 1 or 4)
	end
	return animpos
end

local angZero, vecZero = Angle(0, 0, 0), Vector(0, 0, 0) -- а неиспользуется потому что глуалин подчеркнул это
local angPosture3 = Angle(-30, 10, -20)
local angPosture4 = Angle(30, 20, 0)
local angSuicide = Angle(-30, 120, 0)
local angReload = Angle(-30, 20, 0)
if SERVER then
	util.AddNetworkString("hg_viewgun")
	concommand.Add("hg_inspect", function(ply, cmd, args)
		ply.viewingGun = CurTime() + 3
		net.Start("hg_viewgun")
		net.WriteEntity(ply)
		net.WriteFloat(ply.viewingGun)
		net.Broadcast()
	end)
else
	net.Receive("hg_viewgun", function() net.ReadEntity().viewingGun = net.ReadFloat() end)
end

local mul = 1
local tickInterval = engine.TickInterval -- gde
local hook_Run = hook.Run
function SWEP:ChangeGunPos()
	local ply = self:GetOwner()
	if ply != LocalPlayer() then return end
	mul = FrameTime() / tickInterval()
	if (self.frameTime or 0) > CurTime() then return end
	self.frameTime = CurTime() + 0.014
	local fakeRagdoll = IsValid(ply.FakeRagdoll)
	hook_Run("WeaponAnglesChange", self)
	self.weaponAng[1] = 0
	self.weaponAng[2] = 0
	self.weaponAng[3] = 0
	local animpos = self:GetAnimShoot2()
	animpos = animpos * (self.bipodPlacement and 0.25 or 1)
	animpos = animpos * ((self:IsLocal() or SERVER) and math.Clamp(self.SprayI / self:GetMaxClip1() * 2, not self.Primary.Automatic and (self.RecoilAnim and self.RecoilAnim * 1.5 or 0.1) or 0.1, not self.Primary.Automatic and (self.RecoilAnim and self.RecoilAnim * 1.5 or 0.1) or 1) or 1)
	self.weaponAng[1] = self.weaponAng[1] + animpos * -20 --* (self.holdtype == "revolver" and -20 or -20)
	if ply.viewingGun and ply.viewingGun > CurTime() then
		self.weaponAng:Add(Angle(math.sin(ply.viewingGun - CurTime()) * -40, math.sin(ply.viewingGun - CurTime()) * 50, 0))
		ply.viewingGun = not (self:KeyDown(IN_ATTACK2) or self:KeyDown(IN_ATTACK)) and ply.viewingGun or nil
	end

	if IsValid(ply.FakeRagdoll) then ply.lean = 0 end
	self.weaponAng[3] = self.weaponAng[3] + (ply.lean or 0) * 20
	if self.GetAnimPos_Draw then
		self.weaponAng[1] = self.weaponAng[1] - self:GetAnimPos_Draw(CurTime()) * 30
		self.weaponAng[2] = self.weaponAng[2] + self:GetAnimPos_Draw(CurTime()) * 20
	end

	if not fakeRagdoll then
		self.weaponAng:Add(ply.posture == 3 and angPosture3 or angZero)
		angPosture4[1] = 30 * (ply:EyeAngles()[1] > 60 and (90 - ply:EyeAngles()[1]) / 30 or 1)
		angPosture4[2] = 20 * (ply:EyeAngles()[1] > 60 and (90 - ply:EyeAngles()[1]) / 30 or 1)
		self.weaponAng:Add(ply.posture ~= 3 and self:IsSprinting() and angPosture4 or angZero)
		--if ply.suiciding then self.weaponAng:Add(ply.suiciding and angSuicide or angZero) end
	end

	if ply.posture == 4 or ply.posture == 3 or ply.posture == 1 then ply.posture = (self:KeyDown(IN_ATTACK2) or (ply.posture ~= 1 and self:KeyDown(IN_ATTACK))) and 0 or ply.posture end
	if ply.posture == 5 then self.weaponAng[3] = self.weaponAng[3] - 20 end
	local closeanim = self:CloseAnim(true)
	closeanim = fakeRagdoll and 0 or closeanim or 0
	local trace = self:GetTrace()
	local way = trace.HitNormal:Dot(self:GetWeaponEntity():GetAngles():Up())
	self.weaponAng[1] = self.weaponAng[1] - 60 * (closeanim > 0.5 and (closeanim - 0.5) * (way > 0 and 1 or -1) or 0)
	local brokenArm = SERVER and ((ply.larm or 0) + (ply.rarm or 0)) or CLIENT and ((ply.larm or 0) + (ply.rarm or 0))
	self.weaponAng[1] = self.weaponAng[1] + (brokenArm >= 1 and (math.sin(CurTime()) + 1) * brokenArm or 0)
	if CLIENT and self:IsLocal() then
		self.weaponAng[3] = self.weaponAng[3] + diffang2[2] * -4
		self.weaponAng[3] = self.weaponAng[3] - diffvec2:Dot(self:GetOwner():EyeAngles():Right()) * 10
	end

	self.weaponAng[3] = self.weaponAng[3] + (self.checkingammo and 30 or 0)
	self.weaponAng:Add((self.reload and self.reload - 0.25 > CurTime()) and not fakeRagdoll and angReload or angZero)
	self.weaponAngLerp = Lerp(0.3 * self.Ergonomics ^ 3, self.weaponAngLerp or Angle(0, 0, 0), self.weaponAng)
end

if SERVER then return end
local function remove(self, model)
	model:Remove()
end

function SWEP:CreateWorldModel()
	local model = ClientsideModel(self.WorldModel)
	model:SetNoDraw(true)
	for i = 0, 6 do
		model:SetBodygroup(i, self:GetBodygroup(i))
	end

	self:CallOnRemove("clientsidemodel", function() model:Remove() end)
	model:CallOnRemove("removeAtts", function() hg.ClearAttModels(model) end)
	self.worldModel = model
	return model
end

function hg.CreateWorldModel_Ex(class, owner, self)
	local model = ClientsideModel(self.WorldModel)
	model:SetNoDraw(true)
	
	--owner:CallOnRemove("clientsidemodel", function() model:Remove() end)
	model:CallOnRemove("removeAtts", function() hg.ClearAttModels(model) end)
	owner.worldModel[class] = model
	return model
end

local vecZero = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local math_max = math.max
hook.Add("NotifyShouldTransmit", "PvsThingy", function(ent, shouldTransmit) ent.shouldTransmit = shouldTransmit end)
function SWEP:WorldModel_Transform()
	local model, owner = self.worldModel, self:GetOwner()
	if not IsValid(model) then model = self:CreateWorldModel() end
	if IsValid(owner) then
		local matrix = owner:GetBoneMatrix(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if not matrix then return end
		local ang = (!owner.suiciding and owner:EyeAngles() or owner:GetAttachment(owner:LookupAttachment("anim_attachment_RH")).Ang)
		ang[3] = ang[3] + 180
		local pos = vecZero
		pos:Set(self.WorldPos)
		pos[3] = pos[3] + 1
		local angles = matrix:GetAngles()
		self:ChangeGunPos()
		ang:Add(self.weaponAngLerp or angZero)
		if self.HoldType != "revolver" then
			angles:RotateAroundAxis(angles:Forward(), 180)
			angles:RotateAroundAxis(angles:Right(), 100)
			angles:RotateAroundAxis(angles:Forward(), -105)
			angles:RotateAroundAxis(angles:Up(), -35)
		end
		local newPos, newAng = LocalToWorld(pos, angZero, matrix:GetTranslation(), owner.suiciding and angles or ang)
		if self.bipodPlacement then newPos = self.bipodPlacement end
		ang[3] = ang[3] - 180
		model:SetAngles(ang)
		local ang = model:LocalToWorldAngles(self.WorldAng)
		if owner.suiciding then
			newAng:RotateAroundAxis(newAng:Forward(), 180)
			ang = newAng
			if self.HoldType == "revolver" then
			else
				newPos:Add(ang:Forward() * -7)
				newPos:Add(ang:Up() * -3)
				newPos:Add(ang:Right() * 5)
				model:SetAngles(ang)
			
				ang = model:LocalToWorldAngles(self.WorldAng)
			end
			
		end
		model:SetRenderOrigin(newPos)
		model:SetRenderAngles(newerAng)
		model:SetupBones()
		self:Setmuzzlepos(self:GetMuzzleAtt(model, true).Pos)
		self:Setmuzzleang(self:GetMuzzleAtt(model, true).Ang)
		net.Start("muzzlenormalizator")
			net.WriteVector(self:GetMuzzleAtt(model, true).Pos)
			net.WriteEntity(self)
			net.WriteAngle(self:GetMuzzleAtt(model, true).Ang)
		net.SendToServer()
	else
		model:SetRenderOrigin(self:GetPos())
		model:SetRenderAngles(self:GetAngles())
	end
end

SWEP.holsteredBone = "ValveBiped.Bip01_Spine2"
SWEP.holsteredPos = Vector(-8, -3.8, -3)
SWEP.holsteredAng = Angle(0, 0, 0)
function SWEP:WorldModel_Transform_Holstered()
	local model, owner = self.worldModel, self:GetOwner()
	if not IsValid(model) then model = self:CreateWorldModel() end
	local owner = IsValid(owner.FakeRagdoll) and owner.FakeRagdoll or owner
	if not owner then
		model:SetNoDraw(true)
		return
	end

	if IsValid(owner) then
		local matrix = owner:GetBoneMatrix(owner:LookupBone(self.holsteredBone))
		if not matrix then return end
		local localPos, localAng = self.holsteredPos + self.WorldPos, self.holsteredAng
		local newPos, newAng = LocalToWorld(localPos, localAng, matrix:GetTranslation(), matrix:GetAngles())
		model:SetAngles(newAng)
		local newAng = model:LocalToWorldAngles(self.WorldAng)
		model:SetRenderOrigin(newPos)
		model:SetRenderAngles(newAng)
		model:SetupBones()
	else
		model:SetRenderOrigin(self:GetPos())
		model:SetRenderAngles(self:GetAngles())
	end
end

--what the fuck is that function name...
function hg.WorldModel_Transform_Holstered_Ex(class, model, owner, self)
	if IsValid(owner) then
		local matrix = owner:GetBoneMatrix(owner:LookupBone(self.holsteredBone))
		if not matrix then return end
		local localPos, localAng = self.holsteredPos + self.WorldPos, self.holsteredAng
		local newPos, newAng = LocalToWorld(localPos, localAng, matrix:GetTranslation(), matrix:GetAngles())
		model:SetAngles(newAng)
		local newAng = model:LocalToWorldAngles(self.WorldAng)
		model:SetRenderOrigin(newPos)
		model:SetRenderAngles(newAng)
		model:SetupBones()
	end
end

function SWEP:ClearAttModels()
	if self.modelAtt then
		for atta, model in pairs(self.modelAtt) do
			if not atta or not IsValid(self.modelAtt[atta]) then continue end
			if IsValid(model) then model:Remove() end
			self.modelAtt[atta] = nil
		end
	end
end

function hg.ClearAttModels(model)
	if model.modelAtt then
		for atta, model in pairs(model.modelAtt) do
			if not (model or model.modelAtt) then return end
			if not atta or not IsValid(model.modelAtt[atta]) then continue end
			if IsValid(model) then model:Remove() end
			model.modelAtt[atta] = nil
		end
	end
end

function SWEP:DrawWorldModel()
end

local function removeFlashlights(self)
	if self.flashlight and self.flashlight:IsValid() then
		self.flashlight:Remove()
		self.flashlight = nil
	end
end

local function DrawWorldModel(self)
	if not IsValid(self) then return end
	local owner = self:GetOwner()
	if not IsValid(self.worldModel) then self.worldModel = self:CreateWorldModel() end
	if ((not self.shouldTransmit) or (not owner.shouldTransmit)) and owner == nil then
		self.worldModel:SetNoDraw(true)
		self:ClearAttModels()
		removeFlashlights(self)
		return
	else
		self.worldModel:SetNoDraw(false)
	end
	
	if not IsValid(owner) and self:GetVelocity():Length() < 1 then --self.worldModel:SetNoDraw(false)
		return
	end
	
	if self.UseCustomWorldModel then
		if not IsValid(self.worldModel) then self.worldModel = self:CreateWorldModel() end
		if IsValid(owner) and (owner:GetActiveWeapon() ~= self) then
			if not owner:HasWeapon(self:GetClass()) then
				self.worldModel:SetNoDraw(true)
				self:ClearAttModels()
				removeFlashlights(self)
				return
			end

			if self.shouldDrawHolstered then
				self.worldModel:SetNoDraw(false)
				self:WorldModel_Transform_Holstered()
				self.worldModel:DrawModel()
				self:DrawAttachments()
			else
				self.worldModel:SetNoDraw(true)
				self:WorldModel_Transform_Holstered()
				self:DrawAttachments()
			end
			return
		end

		if IsValid(owner) and IsValid(owner.FakeRagdoll) then
			self.worldModel:SetNoDraw(true)
			self:DrawAttachments()
			removeFlashlights(self)
			return
		end

		self.worldModel:SetNoDraw(false)
		self:WorldModel_Transform()
		self.worldModel:DrawModel()
		self:DrawAttachments()
	else
		if IsValid(self:GetNWEntity("fakeGun")) then return end
		if self.DrawAttachments then
			self:DrawAttachments()
			self:DrawModel()
		end
	end
end

local function removeModels(owner)
	if not IsValid(owner) or not owner.worldModel then return end
	for i, model in pairs(owner.worldModel) do
		if IsValid(model) then
			model:Remove()
			model = nil
		end
	end
end

local function DrawWorldModel_Ex(class, atts, owner)
	local self = weapons.Get(class)

	if not IsValid(owner) then return end

	owner.worldModel = owner.worldModel or {}
	if not IsValid(owner.worldModel[class]) then
		owner.worldModel[class] = hg.CreateWorldModel_Ex(class, owner, self)
		owner:CallOnRemove("removehuys",function() removeModels(owner) end)
	end
	local model = owner.worldModel[class]
	if not owner.shouldTransmit then
		model:SetNoDraw(true)
		hg.DrawAttachments_Ex(class, model, owner, atts, self)
		return
	else
		model:SetNoDraw(false)
	end

	if not hook_Run("PreventDrawing", owner) then
		model:SetNoDraw(false)
		hg.WorldModel_Transform_Holstered_Ex(class, model, owner, self)
		model:DrawModel()
		hg.DrawAttachments_Ex(class, model, owner, atts, self)
	else
		model:SetNoDraw(true)
		hg.WorldModel_Transform_Holstered_Ex(class, model, owner, self)
		model:DrawModel()
		hg.DrawAttachments_Ex(class, model, owner, atts, self)
	end
end

hook.Add("PreDrawOpaqueRenderables", "huyCock", function()
	hg.weapons = hg.weapons or {}
	for self in pairs(hg.weapons) do
		if not IsValid(self) then continue end
		DrawWorldModel(self)
	end

	hg.weaponsDead = hg.weaponsDead or {}
	for i, tbl in pairs(hg.weaponsDead) do
		if not IsValid(tbl[3]) or not tbl[3].inventory or not tbl[3].inventory.Weapons or not tbl[3].inventory.Weapons[tbl[1]] then
			removeModels(tbl[3])
			hg.weaponsDead[i] = nil
			continue
		end

		DrawWorldModel_Ex(unpack(tbl))
	end
end)

hook.Add("PostDrawOpaqueRenderables", "huyCock333", function()
	hg.weapons = hg.weapons or {}
	for self in pairs(hg.weapons) do
		if not self.attachments then continue end
		if not self.lasertoggle then removeFlashlights(self) end
		if not table.IsEmpty(self.attachments.underbarrel) and string.find(self.attachments.underbarrel[1], "laser") or self.laser then self:DrawLaser() end
	end
end)

function SWEP:ShouldDrawViewModel()
	return false
end