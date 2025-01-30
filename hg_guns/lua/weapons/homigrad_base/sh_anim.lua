-- sh_anim.lua"

AddCSLuaFile()
--
function SWEP:Initialize_Anim()
	self.Anim_RecoilCameraZoom = Vector(0, 0, 0)
	self.Anim_RecoilCameraZoomSet = Vector(0, 0, 0)
	self.Anim_RecoilLerp = 0
end

function SWEP:SetHold(value)
	self.holdtype = value
	self:SetWeaponHoldType(value)
end

hook.Add("Bones", "homigrad-weapons-bone", function(ply)
	local wep = ply:GetActiveWeapon()
	local func = wep.Animation
	if func then func(wep, ply) end
end)

local vecZero = Vector(0, 0, 0)
local vecZero2 = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local CurTime = CurTime
function SWEP:Animation()
	local owner = self:GetOwner()
	if (not IsValid(owner)) or (owner:GetActiveWeapon() ~= self) then return end
	if owner.suiciding then
		self:SuicideAnim()
		return
	end
	
	self:DeployAnim()
	self:HolsterAnim()
	if self.holster or self.deploy then self:AnimSprint() end
	--owner:SetFlexWeight(7,self:IsZoom() and 1 or 0)

	--self:SetHold(self.HoldType)
	if not false then --owner:IsSprinting() then
		self:AnimApply_ShootRecoil(self:LastShootTime())
		self:AnimApply_ShootRecoil(self.LastPrimaryDryFire, 50)
		self:AnimLeanLeft()
		self:AnimLeanRight()
		self:CloseAnim()
		if owner:EyeAngles()[1] < -53 then self:AnimLookUp() end
		if owner:EyeAngles()[1] > 46 then self:AnimLookDown() end
		self:AnimHold()
		if self:IsZoom() then self:AnimZoom() end
	end

	if self:IsSprinting() and not self.reload then self:AnimSprint() end
	self:AnimationPost()
end

function SWEP:AnimationPost()
end

--local hg.bone = hg.bone
local bone, name
function SWEP:BoneSetAdd(layerID, lookup_name, vec, ang)
	hg.bone.SetAdd(self:GetOwner(), layerID, lookup_name, vec, ang)
end

function SWEP:BoneAdd(layerID, lookup_name, vec, ang)
	hg.bone.Add(self:GetOwner(), layerID, lookup_name, vec, ang)
end

function SWEP:BoneApply(layerID, lookup_name, lerp)
	hg.bone.Apply(self:GetOwner(), layerID, lookup_name, lerp)
end

function SWEP:BoneGet(lookup_name)
	return hg.bone.Get(self:GetOwner(), lookup_name)
end

--но это бред
local math_cos, math_sin = math.cos, math.sin
function SWEP:AnimHoldPost()
end

if CLIENT then
	local function changePosture()
		RunConsoleCommand("hg_change_posture", -1)
	end

	local function resetPosture()
		RunConsoleCommand("hg_change_posture", 0)
	end

	hook.Add("radialOptions", "hg-change-posture", function()
		local wep = LocalPlayer():GetActiveWeapon()
		if wep and hg.weapons[wep] and not LocalPlayer().otrub then
			local tbl = {changePosture, "Change Posture"}
			hg.radialOptions[#hg.radialOptions + 1] = tbl
			local tbl = {resetPosture, "Reset Posture"}
			hg.radialOptions[#hg.radialOptions + 1] = tbl
		end
	end)

	concommand.Add("hg_change_posture", function(ply, cmd, args)
		if not args[1] then print([["Change your gun posture:
0 - regular hold
1 - hipfire
2 - left clavicle pose
3 - high ready
4 - low ready
5 - point shooting"
]]) end
		local pos = math.Round(args[1] or -1)
		net.Start("change_posture")
		net.WriteEntity(ply)
		net.WriteInt(pos, 8)
		net.SendToServer()
	end)

	net.Receive("change_posture", function()
		local ply = net.ReadEntity()
		local pos = net.ReadInt(8)
		ply.posture = ply.posture or 0
		ply.posture = (ply.posture + 1) >= 6 and 0 or ply.posture + 1
		if pos ~= -1 then ply.posture = pos end
	end)
else
	util.AddNetworkString("change_posture")
	net.Receive("change_posture", function()
		local ply = net.ReadEntity()
		local pos = net.ReadInt(8)
		ply.posture = ply.posture or 0
		ply.posture = (ply.posture + 1) >= 6 and 0 or ply.posture + 1
		if pos ~= -1 then ply.posture = pos end
		net.Start("change_posture")
		net.WriteEntity(ply)
		net.WriteInt(pos, 8)
		net.Broadcast()
	end)
end

local angHold1 = Angle(-10, -5, 0)
local angHold2 = Angle(-10, 5, 0)
SWEP.handsAng = Angle(0, 0, 0)
local plyAng, handAng, handPos, addAng, _ = Angle(0, 0, 0), Angle(0, 0, 0), Vector(0, 0, 0), Angle(0, 0, 0), Vector(0, 0, 0)
--function SWEP:DrawHUDAdd()
--cam.Start3D()
--render.DrawLine(handPos,handPos + (handAng - addAng):Forward() * 10,color_white)
--cam.End3D()
--end

function SWEP:BoltAnim(TypeOfAnim)
	if self.BoltBone == false then return end
    if TypeOfAnim == "shoot" then
        local hookName = "bolt_anim_" .. self:EntIndex() .. math.random(-1e8,1e8)
        hook.Remove("Think", hookName)
        hook.Add("Think", hookName, function()
            if not IsValid(self) then
                hook.Remove("Think", hookName)
                return
            end

            local model = self.worldModel
            local bone = self.BoltBone
            local amt = self.BoltMul
			self.back = self.back or false

            self.prog = self.prog or 0
			if not self.back then
            self.prog = LerpFT(0.5	, self.prog, 1)
			else
			self.prog = LerpFT(0.55, self.prog, 0.0001)
			if self.prog < 0.01 then
			self.back = false
			hook.Remove("Think", hookName)
			end
			end

			model:ManipulateBonePosition(model:LookupBone(bone),amt * self.prog)

            if self.prog >= 0.8 then
				self.back = true
			elseif self.prog == 0 then
				self.back = false
            end
        end)
	elseif TypeOfAnim == "cock" then
        local hookName = "bolt_anim_" .. self:EntIndex()
        hook.Remove("Think", hookName)
        hook.Add("Think", hookName, function()
            if not IsValid(self) then
                hook.Remove("Think", hookName)
                return
            end

            local model = self.worldModel
            local bone = self.BoltBone
            local amt = self.BoltMul
			self.back = self.back or false

            self.prog = self.prog or 0
			if not self.back then
            self.prog = LerpFT(0.1, self.prog, 1)
			else
			self.prog = LerpFT(0.1, self.prog, 0.0001)
			if self.prog < 0.01 then
			self.back = false
			hook.Remove("Think", hookName)
			end
			end

			model:ManipulateBonePosition(model:LookupBone(bone),amt * self.prog)

            if self.prog >= 0.8 then
				self.back = true
			elseif self.prog == 0 then
				self.back = false
            end
        end)
    end
end

function SWEP:SuicideAnim()
	local owner = self:GetOwner()
	if self.HoldType == "ar2" or self.HoldType == "smg" then
		self:SetHold("normal")
		local crouching = self:KeyDown(IN_DUCK)
		self:BoneSetAdd(1, "r_forearm", Vector(0, 0, 0), (crouching and Angle(-35, 70, 25 ) ) or Angle(-5, -35, -15))
		self:BoneSetAdd(1, "r_upperarm", Vector(0, 0, 0), (crouching and Angle( 0, -25, 0 ) ) or Angle(0, -15, 0))
		self:BoneSetAdd(1, "r_hand", Vector(0, 0, 0), (crouching and Angle( -30, -45, -55 ) ) or Angle( 0, -20, -12))

		self:BoneSetAdd(1, "l_forearm", Vector(0, 0, 0), (crouching and Angle( 45, 15, -25 ) ) or Angle(0, -100, 15))
		self:BoneSetAdd(1, "l_upperarm", Vector(0, 0, 0), (crouching and Angle( 10, -45, 0 ) ) or Angle(-10, -5, 0))
		self:BoneSetAdd(1, "l_hand", Vector(1, 1, 0), (crouching and Angle( 0, 25, 0 ) ) or Angle(-15, -15, -15))
	else
		self:SetHold("normal")
		local crouching = self:KeyDown(IN_DUCK)
		self:BoneSetAdd(1, "r_forearm", Vector(0, 0, 0), Angle(0, crouching and -25 or -120, 0))
		self:BoneSetAdd(1, "r_upperarm", Vector(0, 0, 0), Angle(10, 0, 0))
		self:BoneSetAdd(1, "r_hand", Vector(0, 0, 0), Angle(crouching and 40 or 40, crouching and 0 or -30, crouching and 15 or 30))

		self:BoneSetAdd(1, "l_forearm", Vector(0, 0, 0), Angle(0, 0, 0))
		self:BoneSetAdd(1, "l_upperarm", Vector(0, 0, 0),Angle(0, 0, 0))
		self:BoneSetAdd(1, "l_hand", Vector(1, 1, 0), Angle(0, 0, 0))
	end
end

function SWEP:AnimHold()
	local _
	local ply = self:GetOwner()
	if not self.attachments then return end
	self:SetHold(self.attachments.grip and not table.IsEmpty(self.attachments.grip) and hg.attachments.grip[self.attachments.grip[1]].holdtype or self.HoldType)
	if self.HoldType == "ar2" then
		self:BoneSetAdd(1, "r_upperarm", vecZero, angHold1, 0.1)
		self:BoneSetAdd(1, "r_hand", vecZero, angHold2, 0.1)
	end

	local bon = ply:LookupBone("ValveBiped.Bip01_R_Hand")
	if not bon then return end
	local hand = ply:GetBoneMatrix(bon)
	if not hand then return end
	handAng = hand:GetAngles()
	handPos = hand:GetTranslation()
	local gun = self:GetWeaponEntity()
	if not IsValid(gun) then return end
	plyAng = self:IsLocal() and gun:GetAngles() or gun:GetAngles() --(ply:GetEyeTrace().HitPos - ply:EyePos()):Angle()
	plyAng:Normalize()
	plyAng[3] = plyAng[3] + 180
	local c = ply:GetManipulateBoneAngles(bon)
	c:Normalize()
	plyAng:RotateAroundAxis(plyAng:Up(), self.WorldAng[2])
	_, addAng = WorldToLocal(vecZero, plyAng, vecZero, handAng)
	addAng:Add(c)
	addAng[2] = addAng[2] - 6
	addAng[1] = addAng[1]
	addAng:Add(self.handsAng)
	addAng:Normalize()
	self:BoneSetAdd(3, "r_hand", vecZero, addAng)
	ply.posture = ply.posture or 0
	local crouchingPistol = self:KeyDown(IN_DUCK) and self.holdtype == "revolver"
	self:BoneSetAdd(1, "r_forearm", vecZero, crouchingPistol and Angle(0, 30, 0) or self.holdtype != "revolver" and Angle(15, -10, 0) or Angle(38, -30, 0))
	self:BoneSetAdd(1, "r_upperarm", vecZero, crouchingPistol and Angle(20, -20, 0) or self.holdtype != "revolver" and Angle(-15, 15, 0) or Angle(-25, 15, 0))
	local walking = (ply:GetVelocity():Length() > 20) and ply:OnGround()
	local walkingMul = (ply:GetVelocity():Length() - 20) / 200
	self:BoneSetAdd(1, "r_forearm", vecZero, walking and Angle(0, 10, 0) * walkingMul / (crouchingPistol and 2 or 1) or Angle(0, 0, 0))
	self:BoneSetAdd(1, "r_upperarm", vecZero, walking and Angle(10, -10, 0) * walkingMul / (crouchingPistol and 2 or 1) or Angle(0, 0, 0))
	if ply.posture == 1 then
		if self.holdtype == "revolver" then ply.posture = ply.posture + 1 end
		self:BoneSetAdd(1, "r_upperarm", vecZero, Angle(-20, 30, 0))
	end

	if ply.posture == 2 then
		if self.holdtype == "revolver" then ply.posture = ply.posture + 1 end
		self:BoneSetAdd(1, "r_upperarm", vecZero, Angle(-10, -20, 0))
		self:BoneSetAdd(1, "r_forearm", vecZero, Angle(-10, 20, 0))
	end

	if ply.posture == 3 then
		self:BoneSetAdd(1, "r_upperarm", vecZero, Angle(-0, 20, 30))
		self:BoneSetAdd(1, "r_forearm", vecZero, Angle(-20, 10, 0))
		if self.holdtype == "revolver" then self:BoneSetAdd(1, "r_forearm", vecZero, Angle(-10, -40, 0)) end
	end

	if self.bipodPlacement then
		self:SetHold("slam")
		--local bon = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
		--local matrix = ply:GetBoneMatrix(bon)
		--local ang = (matrix:GetTranslation() - self.bipodPlacement):Angle()
		--self:BoneSetAdd(1,"r_upperarm",vecZero,-ang)--Angle(45,-90,0))
	end

	self:AnimHoldPost()
	--[[
	
	local bone = ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_L_ForeArm"))
	local bone2 = ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_R_Hand"))

	if CLIENT then
		ply:SetIK(false)
	end

	local pos,ang = WorldToLocal(bone:GetTranslation() + bone:GetAngles():Forward() * 3 + bone:GetAngles():Up() * 3,Angle(0,0,0),bone:GetTranslation(),bone:GetAngles())
	self:BoneSetAdd(1,"l_hand",pos,Angle(0,0,0))

	--homemade ik maybe???
	--https://en.m.wikipedia.org/wiki/Inverse_kinematics
	--useful

	]]
end

local vecZoom1 = Vector(1, -1, 0)
local angZoom1 = Angle(0, 0, 0)
function SWEP:AnimZoom()
	local owner = self:GetOwner()
	--self:SetHold(self.ZoomHold or self.HoldType)
	local att = owner:LookupAttachment("eyes")
	if not att then return end
	att = owner:GetAttachment(att)
	self:BoneSetAdd(1, "r_clavicle", vecZoom1, angZero)
	angZoom1[1] = (self:GetWeaponEntity():GetPos() - att.Pos):GetNormalized():Dot(owner:EyeAngles():Right())
	angZoom1[1] = -angZoom1[1] * 100
	self:BoneSetAdd(1, "head", vecZero, angZoom1)
end

local angSprint1 = Angle(-30, 20, 0)
local angSprint2 = Angle(-10, -10, -30)
function SWEP:AnimSprint()
	if self.HoldType == "revolver" then self:BoneSetAdd(1, "r_upperarm", vecZero, angSprint1) end
	--self:BoneSetAdd(1,"r_hand",vecZero,angSprint2,0.1)
end

local angLookUp1 = Angle(0, 0, 0)
function SWEP:AnimLookUp()
	local owner = self:GetOwner()
	if owner.suiciding then return end
	local eyeAng = owner:EyeAngles()
	if self:IsLocal() then
		angLookUp1[1] = -eyeAng[1] - 53
		--self:BoneSetAdd(4,"r_hand",vecZero,angLookUp1)
	end
end

function SWEP:AnimLookDown()
	local owner = self:GetOwner()
	if owner.suiciding then return end
	local eyeAng = owner:EyeAngles()
	if self:IsLocal() then
		if self.HoldType == "ar2" or self.HoldType == "smg" then
			--self:BoneSetAdd(1,"r_hand",vecZero,Angle(-eyeAng[1]+46,0,0))
		end
	end
end

local math_max, math_Clamp = math.max, math.Clamp
SWEP.AnimShootMul = 1
SWEP.AnimShootHandMul = 1
function SWEP:GetAnimPos_Shoot(time, timeSpan)
	local timeSpan = timeSpan or 0.2
	return timeSpan - math_Clamp(CurTime() - time, 0, timeSpan)
end

function SWEP:AnimApply_ShootRecoil(time, div)
	local owner = self:GetOwner()
	local animpos = self:GetAnimPos_Shoot(time)
	if animpos > 0 then
		animpos = animpos * ((self:IsZoom() and self.SpreadMulZoom or self.SpreadMul) + math_max(self.Primary.Force / 110 - 1, 0)) * (owner:Crouching() and self.CrouchMul or 1) * 0.75
		animpos = animpos * self.AnimShootMul
		animpos = animpos / (div or 1) --* (1 + math.Rand(-0.1,0.1))
		--self:BoneSetAdd(1,"r_hand",Vector(0,0,0),Angle(0 * animpos * 5 * self.AnimShootHandMul,0,0))
		--self:BoneApply(1,"r_hand",0.5)
		if self.holdtype == "ar2" or self.holdtype == "smg" then
			self:BoneSetAdd(4, "r_upperarm", Vector(4 * animpos, -7 * animpos, 7 * animpos) / 4, angZero)
			self:BoneSetAdd(4, "spine", vecZero, Angle(0, 0, -5 * animpos))
			--self:BoneSetAdd(4,"r_upperarm",Vector(0,0,0),Angle(0,60 * animpos,0) / 4)
			--self:BoneSetAdd(4,"r_forearm",Vector(0,0,0),Angle(-20 * animpos,-60 * animpos,0) / 4)
			--self:BoneSetAdd(4,"r_hand",Vector(0,0,0),Angle(0,20 * animpos,0))
			--self:BoneApply(1,"r_clavicle",1)
		else
			self:BoneSetAdd(4, "r_upperarm", Vector(-2 * animpos, 0, 7 * animpos) / 4, angZero)
			--self:BoneSetAdd(4,"r_upperarm",Vector(0,0,0),Angle(-10 * animpos,10 * animpos,-8 * animpos))
			--self:BoneSetAdd(4,"r_forearm",Vector(0,0,0),Angle(20 * animpos,-25 * animpos,0))
			--self:BoneApply(1,"r_upperarm",1)
		end
	end
end

local hullVec = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local vecAsd2 = Vector(-45, 4, 1)
SWEP.lengthSub = 0
function SWEP:CloseAnim(dontapply)
	local owner = self:GetOwner()
	local att = self:GetMuzzleAtt(nil, true)
	if not att then return end
	local pos = att.Pos
	local ang = owner:EyeAngles() --att.Ang
	if not self.attachments then return end
	local lengthAdd = self.attachments.barrel[1] and string.find(self.attachments.barrel[1], "supressor") and 10 or 0
	local dis,point = util.DistanceToLine(att.Pos - ang:Forward() * 50,ang:Forward(),owner:EyePos())
	local tr = util.TraceHull({
		start = point,
		endpos = pos + ang:Forward() * 10 + ang:Forward() * lengthAdd,
		filter = {self, self:GetOwner()},
		mins = -hullVec,
		maxs = hullVec,
		mask = MASK_SHOT
	})

	--local ang2 = tr.Normal:Angle()
	--ang2:RotateAroundAxis(tr.HitNormal,180)
	local frac = tr.Fraction
	local dist = math.min((1 - frac) * 10, 1)
	if not dontapply then
		if self.HoldType == "ar2" or self.HoldType == "smg" then
			self:BoneSetAdd(1, "r_upperarm", vecZero, Angle(0, dist * 90, 0))
			self:BoneSetAdd(1, "r_forearm", vecZero, Angle(-20 * dist, dist * -40, 0))
			--self:BoneSetAdd(1,"r_hand",vecZero,Angle(dist * 50,dist * -20,dist * -0))
		else
			self:BoneSetAdd(1, "r_upperarm", vecZero, Angle(0, 30 * dist, 0))
			self:BoneSetAdd(1, "r_forearm", vecZero, Angle(0, -80 * dist, -10 * dist))
			--self:BoneSetAdd(1,"r_hand",vecZero,Angle(-40 * dist,50 * dist,-15 * dist))
		end
	end
	return dist
end

function SWEP:AnimApply_RecoilCameraZoom()
	local vecrand = VectorRand(-0.1, 0.1)
	vecrand[3] = 0
	--vecrand[1] = vecrand[1] - 0.3
	self.Anim_RecoilCameraZoomSet = Vector(0, 0, 3) + vecrand
	self.Anim_RecoilCameraZoom = LerpVector(0.2, self.Anim_RecoilCameraZoom, self.Anim_RecoilCameraZoomSet)
end

function SWEP:DeployAnim()
	local animpos = self.deploy
	if true then return end
	if animpos then
		animpos = math.min((self.deploy - CurTime()) / (self.CooldownDeploy / self.Ergonomics), 1)
		--self:SetHold("pistol")
		if self.HoldType == "ar2" then
			self:BoneSetAdd(3, "r_upperarm", vecZero, Angle(30 * animpos, -60 * animpos, 30 * animpos))
			self:BoneSetAdd(3, "r_forearm", vecZero, Angle(0, -90 * animpos, -10 * animpos))
			self:BoneSetAdd(3, "r_hand", vecZero, Angle(70 * animpos, 0, 30 * animpos))
			--self:BoneSetAdd(3,"r_upperarm",Vector(0,0,0),Angle(-10 * animpos,90 * animpos,0))
			--self:BoneSetAdd(3,"r_forearm",Vector(0,0,0),Angle(-40 * animpos,0,-20 * animpos))
			--self:BoneSetAdd(3,"r_hand",Vector(0,0,0),Angle(0,-20 * animpos,0))
		else
			self:BoneSetAdd(3, "r_upperarm", vecZero, Angle(-10 * animpos, 40 * animpos, 0))
			self:BoneSetAdd(3, "r_forearm", vecZero, Angle(-100 * animpos, 0, -60 * animpos))
			self:BoneSetAdd(3, "r_hand", vecZero, Angle(-30 * animpos, -50 * animpos, 0))
		end
	end
end

function SWEP:HolsterAnim()
	local animpos = self.holster
	if true then return end
	if animpos then
		animpos = 1 - (self.holster - CurTime()) / (self.CooldownHolster / self.Ergonomics)
		--self:SetHold("pistol")
		if self.HoldType == "ar2" then
			self:BoneSetAdd(3, "r_upperarm", vecZero, Angle(30 * animpos, -60 * animpos, 30 * animpos))
			self:BoneSetAdd(3, "r_forearm", vecZero, Angle(0, -90 * animpos, -10 * animpos))
			self:BoneSetAdd(3, "r_hand", vecZero, Angle(70 * animpos, 0, 30 * animpos))
			--self:BoneSetAdd(3,"r_upperarm",Vector(0,0,0),Angle(-10 * animpos,90 * animpos,0))
			--self:BoneSetAdd(3,"r_forearm",Vector(0,0,0),Angle(-40 * animpos,0,-20 * animpos))
			--self:BoneSetAdd(3,"r_hand",Vector(0,0,0),Angle(0,-20 * animpos,0))
		else
			self:BoneSetAdd(3, "r_upperarm", vecZero, Angle(-10 * animpos, 40 * animpos, 0))
			self:BoneSetAdd(3, "r_forearm", vecZero, Angle(-100 * animpos, 0, -60 * animpos))
			self:BoneSetAdd(3, "r_hand", vecZero, Angle(-30 * animpos, -50 * animpos, 0))
		end
	end
end

local function isMoving(ply)
	return ply:GetVelocity():Length() > 30 and ply:OnGround()
end

local function isCrouching(ply)
	return ply:KeyDown(IN_DUCK) and ply:OnGround()
end

local function keyDown(owner, key)
	owner.keydown = owner.keydown or {}
	local localKey
	if CLIENT then
		if owner == LocalPlayer() then
			localKey = owner:KeyDown(key)
		else
			localKey = owner.keydown[key]
		end
	end
	return SERVER and owner:KeyDown(key) or CLIENT and localKey
end

hook.Add("Bones", "homigrad-lean-bone", function(ply)
	if IsValid(ply.FakeRagdoll) then
		ply.lean = 0
		return
	end
	if not keyDown(ply, IN_ALT1) and not keyDown(ply, IN_ALT2) and not keyDown(ply, IN_ZOOM) or (keyDown(ply, IN_ALT1) and keyDown(ply, IN_ALT2) and keyDown(ply, IN_ZOOM)) then ply.lean = math.Round(LerpFT(0.4, ply.lean or 0, 0), 3) end
	if keyDown(ply, IN_ALT1) and not keyDown(ply, IN_ALT2) and not keyDown(ply, IN_ZOOM) then
		ply.lean = math.Round(LerpFT(0.4, ply.lean or 0, -1), 3)
		local self = ply:GetActiveWeapon()
		if self.holdtype == "ar2" or self.holdtype == "smg" then
			hg.bone.SetAdd(ply, 1, "r_upperarm", vecZero, Angle(0, -10, -20))
			hg.bone.SetAdd(ply, 1, "spine1", vecZero, Angle(isCrouching(ply) and -45 or -33, -30, isCrouching(ply) and 0 or -10))
			--elseif self.HoldType == "smg" then
			--hg.bone.SetAdd(ply,1,"spine1",vecZero,Angle(isCrouching(ply) and -50 or -32,-30,isCrouching(ply) and -3 or -10))
		else
			hg.bone.SetAdd(ply, 1, "spine1", vecZero, Angle(isCrouching(ply) and -35 or -30, 10, isCrouching(ply) and -2 or -5))
		end
	end
	if keyDown(ply, IN_ALT2) and not keyDown(ply, IN_ALT1) and not keyDown(ply, IN_ZOOM) then
		ply.lean = math.Round(LerpFT(0.4, ply.lean or 0, 1), 3)
		local self = ply:GetActiveWeapon()
		if self.holdtype == "ar2" or self.holdtype == "smg" then
			hg.bone.SetAdd(ply, 1, "r_upperarm", vecZero, Angle(10, 0, 10))
			hg.bone.SetAdd(ply, 1, "spine1", vecZero, Angle(isCrouching(ply) and 35 or 20, 25, isCrouching(ply) and 18 or 18))
			hg.bone.SetAdd(ply, 1, "r_forearm", vecZero, Angle(-10, -10, -10))
			hg.bone.SetAdd(ply, 1, "head", vecZero, Angle(30, 0, 0))
			--elseif self.HoldType == "smg" then
			--hg.bone.SetAdd(ply,1,"spine1",vecZero,Angle(isCrouching(ply) and 32 or 20,30,22))
			--hg.bone.SetAdd(ply,1,"head",vecZero,Angle(30,0,0))
		else
			hg.bone.SetAdd(ply, 1, "spine1", vecZero, Angle(35, -10, isCrouching(ply) and -5 or 0))
		end
	end
end)

function SWEP:AnimLeanLeft()
	--[[local ply = self:GetOwner()

	if not self:KeyDown(IN_ALT1) and not self:KeyDown(IN_ALT2) or (self:KeyDown(IN_ALT1) and self:KeyDown(IN_ALT2)) then
		self.lean = math.Round(LerpFT(0.1,self.lean or 0,0),3)
	end

	if self:KeyDown(IN_ALT1) and not self:KeyDown(IN_ALT2) then
		self.lean = math.Round(LerpFT(0.1,self.lean or 0,-1),3)
		
		if self.HoldType == "ar2" then
			self:BoneSetAdd(1,"spine1",vecZero,Angle(isCrouching(ply) and -45 or -33,-30,isCrouching(ply) and 0 or -10))
			self:BoneSetAdd(1,"r_upperarm",vecZero,Angle(0,-10,-20))
		elseif self.HoldType == "smg" then
			self:BoneSetAdd(1,"spine1",vecZero,Angle(isCrouching(ply) and -50 or -32,-30,isCrouching(ply) and -3 or -10))
		else
			self:BoneSetAdd(1,"spine1",vecZero,Angle(isCrouching(ply) and -35 or -30,10,isCrouching(ply) and -2 or -5))
		end
	end--]]
end

function SWEP:AnimLeanRight()
	--[[local ply = self:GetOwner()

	if self:KeyDown(IN_ALT2) and not self:KeyDown(IN_ALT1) then
		self.lean = math.Round(LerpFT(0.1,self.lean or 0,1),3)
		if self.HoldType == "ar2" then
			self:BoneSetAdd(1,"spine1",vecZero,Angle(isCrouching(ply) and 35 or 20,25,isCrouching(ply) and 18 or 18))
			self:BoneSetAdd(1,"r_upperarm",vecZero,Angle(10,0,10))
			self:BoneSetAdd(1,"r_forearm",vecZero,Angle(-10,-10,-10))
			self:BoneSetAdd(1,"head",vecZero,Angle(30,0,0))
		elseif self.HoldType == "smg" then
			self:BoneSetAdd(1,"spine1",vecZero,Angle(isCrouching(ply) and 32 or 20,30,22))
			self:BoneSetAdd(1,"head",vecZero,Angle(30,0,0))
		else
			self:BoneSetAdd(1,"spine1",vecZero,Angle(35,-10,isCrouching(ply) and -5 or 0))
		end
	end--]]
end

function SWEP:InFreemove()
	--
end

function SWEP:ResetFreemove()
	--
end
--[[
	"head",
	"spine",
	"spine1",
	"spine2",
	"spine4",
	"pelvis",

	"r_clavicle",
	"r_upperarm",
	"r_forearm",
	"r_hand",

	"l_clavicle",
	"l_upperarm",
	"l_forearm",
	"l_hand",

	"r_thigh",
	"r_calf",
	"r_foot",
	"r_toe0",

	"l_thigh",
	"l_calf",
	"l_foot",
	"l_toe0"
]]
--
