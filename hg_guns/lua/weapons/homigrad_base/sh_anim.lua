SWEP.SpeedAnim = 0
SWEP.animmul = 0
SWEP.animmult = 0
SWEP.saim = 0
SWEP.BoltLock = true
SWEP.SprayI = 0

local angZero = Angle(0,0,0)
local vecZero = Vector(0,0,0)


function SWEP:IsPistolHoldType()
    if self.HoldType == "revolver" then
        return true 
    else
        return false
    end
end

local animpos = 0

function SWEP:IsSighted()
	local ply = self:GetOwner()
	if ply:IsNPC() then return end

	if (self:IsLocal() or SERVER) and ply:IsPlayer() then
		local is = not self:IsSprinting() and ply:KeyDown(IN_ATTACK2) and !self.reload and !ply:KeyDown(IN_RELOAD)
		self:SetNWBool("IsSighted",is)
		return is
	else
		return self:GetNWBool("IsSighted")
	end
end

function SWEP:IsClose()
	local ply = self:GetOwner()

	local tf = util.TraceLine({
		start = ply:GetPos() + vector_up * 13,
		endpos = ply:GetPos() + vector_up * 13 + ply:GetAngles():Forward() * 32.5,
		filter = {ply}
	})

	local dist = tf.HitPos:Distance(ply:GetPos())

	if SERVER then
		if dist < 30 then
			self.isClose = true
		else
			self.isClose = false
		end

		self:SetNWBool("IsClose",self.isClose)

		return self.isClose
	else
		return self:GetNWBool("IsClose")
	end
end

function SWEP:IsSprinting()
	local ply = self:GetOwner() 

	if !IsValid(ply) then
		return false
	end

	if ply.Fake then
		return false
	end

	if ply:IsSprinting() then
		return true
	end

	return false
end

local vec3 = Vector(0, 0, 0)
function SWEP:AnimApply_RecoilCameraZoom()
	local vecrand = VectorRand(-0.1, 0.1)
	vecrand[3] = vec3[3]
	--vecrand[1] = vecrand[1] - 0.3
	self.Anim_RecoilCameraZoomSet = vec3
	--self.Anim_RecoilCameraZoom = LerpVector(FrameTime() * 15, self.Anim_RecoilCameraZoom, self.Anim_RecoilCameraZoomSet)
end

local function easedLerp(fraction, from, to)
	return LerpFT(math.ease.InSine(fraction), from, to)
end

function SWEP:PostAnim()
	if self.BoltBone != nil and IsValid(self.worldModel) then
		local bone = self.worldModel:LookupBone(self.BoltBone)

		if self:Clip1() <= 0 and self.BoltLock then
			self.animmul = 1.5
		else
			self.animmul = easedLerp(0.45,self.animmul,0)
		end

		self.worldModel:ManipulateBonePosition(bone,self.BoltVec * self.animmul)
	end
end

function SWEP:Step_Anim()
    local ply = self:GetOwner()
	self:PostAnim()
	self.SprayI = LerpFT(0.15,self.SprayI,0.25)
	if self.reload then
		return
	end
    if self:IsSprinting() or self:IsClose() then
        self.SpeedAnim = LerpFT(0.25,self.SpeedAnim,1)
    else
        self.SpeedAnim = LerpFT(0.25,self.SpeedAnim,0)
    end	

	if self:IsSighted() then
        self.saim = LerpFT(0.2,self.saim,1)
    else
        self.saim = LerpFT(0.2,self.saim,0)
    end	

	self:SetHoldType(self.HoldType)

	if !self.CustomAnim then
		--	hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(0,0,0),1,0.1)
	else
		self:CustomAnim()
	end

	if CLIENT and (ply != LocalPlayer() or GetViewEntity() != LocalPlayer()) then
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Head1"),Angle(-20 * self.saim,-5 * self.saim,0))
	else
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Head1"),Angle(0,0,0))
	end

	if !self.CustomAnim then
		if self:IsPistolHoldType() then
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),Angle(-7,-20 * (1 - self.SpeedAnim),-55 * self.SpeedAnim))
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(5 * (1 - self.SpeedAnim),-20 * (1 - self.SpeedAnim),0))
		else
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"),Angle(-13 - (40 * self.SpeedAnim),-10,0))
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Upperarm"),Angle(0,0,10))
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),Angle(5,-10,-15))
		end
	else
		self:CustomAnim()
	end

    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),Angle(0,0,0))

    if not ply:LookupBone("ValveBiped.Bip01_R_Forearm") then return end--;c
	
	local hand_index = ply:LookupBone("ValveBiped.Bip01_R_Hand")
	local forearm_index = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
	local clavicle_index = ply:LookupBone("ValveBiped.Bip01_R_Clavicle")
	
	local attPos, attAng = self:GetTrace()
	local matrix = ply:GetBoneMatrix(hand_index)
	if not matrix then return end
	local plyang = ply:EyeAngles()
	plyang:RotateAroundAxis(plyang:Forward(),0)

	local _,newAng = LocalToWorld(vector_origin,self.localAng or angle_zero,vector_origin,plyang)
	local ang = newAng
	if CLIENT and self:GetOwner() == LocalPlayer() then
		ang:Add(Angle(-(self.Primary.Force / math.random(32,64)) * RecoilS,0,0))
	end
	ang:RotateAroundAxis(ang:Forward(),180)
	if not self:IsSprinting() and !self.Pump and !self:IsClose() then
	matrix:SetAngles(ang)
	end
	
	local lpos, lang = ply:SetBoneMatrix2(hand_index, matrix, false)
end

function SWEP:Holster( wep )
	local ply = self:GetOwner()

	if not IsValid(ply) or not ply:LookupBone("ValveBiped.Bip01_R_Forearm") then return end

	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Hand" ), Angle( 0,0,0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Forearm" ), Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Upperarm" ), Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Clavicle" ),Angle( 0,0,0 ))

	return true
end

function SWEP:OnDrop(owner)
	local ply = owner

	if not IsValid(ply) or not ply:LookupBone("ValveBiped.Bip01_R_Forearm") then return end

	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Hand" ), Angle( 0,0,0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Upperarm" ), Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Forearm" ), Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Clavicle" ),Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Clavicle" ),Angle( 0,0,0 ))

	return true
end

hook.Add("Player Death","weapons",function(ply)
	if not ply:LookupBone("ValveBiped.Bip01_R_Forearm") then return end
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Hand" ), Angle( 0,0,0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Upperarm" ), Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Forearm" ), Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Clavicle" ),Angle( 0,0,0 ))
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Clavicle" ),Angle( 0,0,0 ))
end)