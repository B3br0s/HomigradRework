-- \lua\\homigrad\\sh_bone_layers.lua"

hg.bone = hg.bone or {} -- пост травматический синдром личности
--local hg.bone = hg.bone
hg.bone.matrixManual = {"ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Spine", "ValveBiped.Bip01_Spine1", "ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Pelvis", "ValveBiped.Bip01_R_Clavicle", "ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Hand", "ValveBiped.Bip01_L_Clavicle", "ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_R_Toe0", "ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot", "ValveBiped.Bip01_L_Toe0"}
local tbl = {"head", "spine", "spine1", "spine2", "spine4", "pelvis", "r_clavicle", "r_upperarm", "r_forearm", "r_hand", "l_clavicle", "l_upperarm", "l_forearm", "l_hand", "r_thigh", "r_calf", "r_foot", "r_toe0", "l_thigh", "l_calf", "l_foot", "l_toe0"}
local newTbl = {}
for i, name in pairs(tbl) do
	newTbl[name] = i
end

hg.bone.matrixManual_Name = newTbl
local matrixManual = hg.bone.matrixManual
local matrix, matrixSet
local layers = {0.1, 0.5, 0.8, 1}
local function create(ply)
	ply.boneLayers = {}
	ply.layersMatrix = {}
	for i = 1, #matrixManual do
		ply.layersMatrix[i] = {Vector(0, 0, 0), Angle(0, 0, 0)}
	end

	for i = 1, #layers do
		local matrix, matrixSet = {}, {}
		for i = 1, #matrixManual do
			matrix[i] = {Vector(0, 0, 0), Angle(0, 0, 0)}
			matrixSet[i] = {Vector(0, 0, 0), Angle(0, 0, 0)}
		end

		ply.boneLayers[i] = {matrix, matrixSet, layers[i]}
	end
end

hook.Add("Player Spawn", "homigrad-bones", function(ply) create(ply) end)
local CurTime, LerpVector, LerpAngle = CurTime, LerpVector, LerpAngle
local m, mSet, mAngle, mPos
local vecZero, angZero = Vector(0, 0, 0), Angle(0, 0, 0)
local tickInterval = engine.TickInterval
local FrameTime = FrameTime
local math_min = math.min
local mul = 1
local timeHuy = CurTime()
local hook_Run = hook.Run
local angle = FindMetaTable("Angle")
function angle:AngIsEqualTo(otherAng, huy)
	if not angle.IsEqualTol then return false end
	return self:IsEqualTol(otherAng, huy)
end

local hg_anims_draw_distance = ConVarExists("hg_anims_draw_distance") and GetConVar("hg_anims_draw_distance") or CreateClientConVar("hg_anims_draw_distance", 1024, true, nil, "distance to draw attachments", 0, 4096)
local tolerance = 0
local player_GetAll = player.GetAll
hook.Add("Think", "homigrad-bones", function()
	--if true then return end
	mul = FrameTime() / tickInterval()
	for i = 1, #player_GetAll() do
		local ply = player_GetAll()[i]
		if CLIENT and LocalPlayer():GetPos():Distance(ply:GetPos()) > hg_anims_draw_distance:GetInt() and hg_anims_draw_distance:GetInt() ~= 0 then continue end
		if CLIENT and not ply.shouldTransmit then continue end
		local layers = ply.boneLayers
		local layersMatrix = ply.layersMatrix
		if (ply.frameTime or 0) > CurTime() then return end
		ply.frameTime = CurTime() + 0.01
		--if CLIENT then ply:SetupBones() end
		--thing above is very expensive
		if not layers or not layersMatrix then
			create(ply)
			continue
		end

		for i = 1, #layers do
			hg.bone.MatrixClear(ply, i)
		end

		for i = 1, #layersMatrix do
			local m = layersMatrix[i]
			if not m[1]:IsEqualTol(vecZero, tolerance) then m[1]:Set(vecZero) end
			if not m[2]:AngIsEqualTo(angZero, tolerance) then m[2]:Set(angZero) end
		end

		hook_Run("Bones", ply)
		for i = 1, #layers do
			local layer = layers[i]
			local matrix, matrixSet = layer[1], layer[2]
			local lerp = math_min(layer[3] * 2, 1)
			for i = 1, #matrixSet do
				m = matrix[i]
				mSet = matrixSet[i]
				mPos = m[1]
				mAngle = m[2]
				if not mPos:IsEqualTol(vecZero, tolerance) then layersMatrix[i][1] = layersMatrix[i][1] + mPos end
				if not mAngle:AngIsEqualTo(angZero, tolerance) then layersMatrix[i][2] = layersMatrix[i][2] + mAngle end
				--ply:ManipulateBonePosition(ply:LookupBone(matrixManual[i]),mPos,false)
				--ply:ManipulateBoneAngles(ply:LookupBone(matrixManual[i]),mAngle,false)
				local bone = ply:LookupBone(matrixManual[i])
				if not bone then continue end
				if layer[3] == 1 then
					if not mSet[1]:IsEqualTol(ply:GetManipulateBonePosition(bone), tolerance) then mPos:Set(mSet[1]) end
					--something still moves for no reason...
					if not mSet[2]:AngIsEqualTo(ply:GetManipulateBoneAngles(bone), tolerance) then mAngle:Set(mSet[2]) end
				else
					if not mSet[1]:IsEqualTol(ply:GetManipulateBonePosition(bone), tolerance) then mPos:Set(LerpVectorFT(lerp, mPos, mSet[1])) end
					if not mSet[2]:AngIsEqualTo(ply:GetManipulateBoneAngles(bone), tolerance) then mAngle:Set(LerpAngleFT(lerp, mAngle, mSet[2])) end
				end
			end
		end

		for i = 1, #layersMatrix do
			local layer = layersMatrix[i]
			local bone = ply:LookupBone(matrixManual[i])
			if not bone then --lol
				continue
			end

			if not layer[1]:IsEqualTol(ply:GetManipulateBonePosition(bone), tolerance) then ply:ManipulateBonePosition(bone, layer[1], false) end
			if not layer[2]:AngIsEqualTo(ply:GetManipulateBoneAngles(bone), tolerance) then ply:ManipulateBoneAngles(bone, layer[2], false) end
		end
	end
end)

local vecZero, angZero = Vector(0, 0, 0), Angle(0, 0, 0)
function hg.bone.MatrixZero(ply, i)
	local layer = ply.boneLayers[i]
	local matrix, matrixSet = layer[1], layer[2]
	for i = 1, #matrixSet do
		m = matrix[i]
		mSet = matrixSet[i]
		m[1]:Set(vecZero)
		m[2]:Set(angZero)
		mSet[1]:Set(vecZero)
		mSet[2]:Set(angZero)
		ply:ManipulateBonePosition(ply:LookupBone(matrixManual[i]), vecZero, false)
		ply:ManipulateBoneAngles(ply:LookupBone(matrixManual[i]), angZero, false)
	end
end

local vecZero, angZero = Vector(0, 0, 0), Angle(0, 0, 0)
function hg.bone.MatrixClear(ply, i)
	local layer = ply.boneLayers[i]
	local matrixSet = layer[2]
	for i = 1, #matrixSet do
		m = matrixSet[i]
		if not m[1]:IsEqualTol(vecZero, tolerance) then m[1]:Set(vecZero) end
		if not m[2]:AngIsEqualTo(angZero, tolerance) then m[2]:Set(angZero) end
	end
end

local vecZero, angZero = Vector(0, 0, 0), Angle(0, 0, 0)
--local hg.bone = hg.bone
local layer, name
function hg.bone.Add(ply, layerID, lookup_name, vec, ang, lerp)
	layer = ply.boneLayers[layerID][1][hg.bone.matrixManual_Name[lookup_name]]
	if not layer then
		error("cant lookup bone '" .. lookup_name .. "'")
		return
	end

	layer[1]:Add(vec or vecZero)
	layer[2]:Add(ang or angZero)
end

function hg.bone.SetAdd(ply, layerID, lookup_name, vec, ang)
	if not ply.boneLayers then
		create(ply)
		return
	end

	layer = ply.boneLayers[layerID][2][hg.bone.matrixManual_Name[lookup_name]]
	if not layer then
		error("cant lookup bone '" .. lookup_name .. "'")
		return
	end

	layer[1]:Add(vec or vecZero)
	layer[2]:Add(ang or angZero)
end

local boneID
function hg.bone.Apply(ply, layerID, lookup_name, lerp)
	boneID = hg.bone.matrixManual_Name[lookup_name]
	if not boneID then
		error("cant lookup bone '" .. lookup_name .. "'")
		return
	end

	layer = ply.boneLayers[layerID]
	matrix, matrixSet = layer[1][boneID], layer[2][boneID]
	matrix[1]:Set(LerpVector(lerp, matrix[1], matrixSet[1]))
	matrix[2]:Set(LerpAngle(lerp, matrix[2], matrixSet[2]))
end

local angZero = Angle(0, 0, 0)
local angZero1 = Angle(0, 0, 0)
local vecZero = Vector(0, 0, 0)
local vecZero1 = Vector(0, 0, 0)
function hg.bone.Get(ply, lookup_name)
	boneID = hg.bone.matrixManual_Name[lookup_name]
	if not boneID then
		error("cant lookup bone '" .. lookup_name .. "'")
		return
	end

	local ang = angZero
	ang:Set(angZero1)
	local vec = vecZero
	vec:Set(vecZero1)
	for i = 1, #ply.boneLayers do
		local layer = ply.boneLayers[i]
		vec:Add(layer[1][boneID][1])
		ang:Add(layer[1][boneID][2])
	end
	return vec, ang
end
--[[
0       ValveBiped.Bip01_Pelvis
1       ValveBiped.Bip01_Spine
2       ValveBiped.Bip01_Spine1
3       ValveBiped.Bip01_Spine2
4       ValveBiped.Bip01_Spine4
5       ValveBiped.Bip01_Neck1
6       ValveBiped.Bip01_Head1
7       ValveBiped.forward
8       ValveBiped.Bip01_R_Clavicle
9       ValveBiped.Bip01_R_UpperArm
10      ValveBiped.Bip01_R_Forearm
11      ValveBiped.Bip01_R_Hand
12      ValveBiped.Anim_Attachment_RH
13      ValveBiped.Bip01_L_Clavicle
14      ValveBiped.Bip01_L_UpperArm
15      ValveBiped.Bip01_L_Forearm
16      ValveBiped.Bip01_L_Hand
17      ValveBiped.Anim_Attachment_LH
18      ValveBiped.Bip01_R_Thigh
19      ValveBiped.Bip01_R_Calf
20      ValveBiped.Bip01_R_Foot
21      ValveBiped.Bip01_R_Toe0
22      ValveBiped.Bip01_L_Thigh
23      ValveBiped.Bip01_L_Calf
24      ValveBiped.Bip01_L_Foot
25      ValveBiped.Bip01_L_Toe0
26      ValveBiped.Bip01_L_Finger4
27      ValveBiped.Bip01_L_Finger41
28      ValveBiped.Bip01_L_Finger42
29      ValveBiped.Bip01_L_Finger3
30      ValveBiped.Bip01_L_Finger31
31      ValveBiped.Bip01_L_Finger32
32      ValveBiped.Bip01_L_Finger2
33      ValveBiped.Bip01_L_Finger21
34      ValveBiped.Bip01_L_Finger22
35      ValveBiped.Bip01_L_Finger1
36      ValveBiped.Bip01_L_Finger11
37      ValveBiped.Bip01_L_Finger12
38      ValveBiped.Bip01_L_Finger0
39      ValveBiped.Bip01_L_Finger01
40      ValveBiped.Bip01_L_Finger02
41      ValveBiped.Bip01_R_Finger4
42      ValveBiped.Bip01_R_Finger41
43      ValveBiped.Bip01_R_Finger42
44      ValveBiped.Bip01_R_Finger3
45      ValveBiped.Bip01_R_Finger31
46      ValveBiped.Bip01_R_Finger32
47      ValveBiped.Bip01_R_Finger2
48      ValveBiped.Bip01_R_Finger21
49      ValveBiped.Bip01_R_Finger22
50      ValveBiped.Bip01_R_Finger1
51      ValveBiped.Bip01_R_Finger11
52      ValveBiped.Bip01_R_Finger12
53      ValveBiped.Bip01_R_Finger0
54      ValveBiped.Bip01_R_Finger01
55      ValveBiped.Bip01_R_Finger02
]]
--

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