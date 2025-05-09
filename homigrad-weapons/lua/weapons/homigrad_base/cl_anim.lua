SWEP.SpeedAnim = 0  
SWEP.animmul = 0

function SWEP:PostAnim()
	if self.BoltBone and IsValid(self.worldModel) and self.BoltVec != nil and isvector(self.BoltVec) then
		local bone = self.worldModel:LookupBone(self.BoltBone)

		if self:Clip1() <= 0 and self.BoltLock then
			self.animmul = 1.5
		else
			self.animmul = LerpFT(0.2,self.animmul,0)
		end

		self.worldModel:ManipulateBonePosition(bone,self.BoltVec * self.animmul)
	end
end

function SWEP:Step_Anim()
    local ply = self:GetOwner()
	self:PostAnim()
	self.SprayI = LerpFT(0.15,self.SprayI,0.25)
	if ply:GetNWBool("suiciding") then
		self:SetHoldType("normal")
			if self:IsPistolHoldType() then
			hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(50,-10,-30),1,0.1)
			hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(-5,-110,0),1,0.1)
			hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-20,0),1,0.1)
			hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(0,0,0),1,0.1)
		else
			hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(90,30,0),1,0.1)
			hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(-20,-70,0),1,0.1)
			hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-20,0),1,0.1)
			hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(0,0,0),1,0.1)

			hg.bone.Set(ply,"l_hand",Vector(0,0,0),Angle(-80,0,-90),1,0.1)
			hg.bone.Set(ply,"l_forearm",Vector(0,0,0),Angle(50,-110,0),1,0.1)
			hg.bone.Set(ply,"l_upperarm",Vector(0,0,0),Angle(-20,-90,0),1,0.1)
			hg.bone.Set(ply,"l_clavicle",Vector(0,0,0),Angle(30,0,0),1,0.1)
		end
		return
	else
		hg.bone.Set(ply,"l_hand",Vector(0,0,0),Angle(0,0,0),1,0.1)
		hg.bone.Set(ply,"l_forearm",Vector(0,0,0),Angle(0,0,0),1,0.1)
		hg.bone.Set(ply,"l_upperarm",Vector(0,0,0),Angle(0,0,0),1,0.1)
		hg.bone.Set(ply,"l_clavicle",Vector(0,0,0),Angle(0,0,0),1,0.1)
	end
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

	if CLIENT and (ply != LocalPlayer() or GetViewEntity() != LocalPlayer()) then
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Head1"),Angle(-20 * self.saim,-5 * self.saim,0))
	else
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Head1"),Angle(0,0,0))
	end

	if !self.CustomAnim then
		if self:IsPistolHoldType() then
			if self:IsSprinting() and !self:IsSighted() or self:IsClose() then
				hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(0,0,0),1,0.25)
				hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,0),1,0.25)
				hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(-5,0,-60),1,0.25)
			else
				hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(0,0,0),1,0.25)
				hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,0),1,0.25)
				hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(0,0,0),1,0.25)
			end
		else
			if self:IsSprinting() and !self:IsSighted() or self:IsClose() then
				hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(0,0,0),1,0.25)
				hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,-30),1,0.25)
				hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(-5,0,-30),1,0.25)
			else
				hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(0,0,0),1,0.25)
				hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,0),1,0.25)
				hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(0,0,0),1,0.25)
			end
		end
	else
		self:CustomAnim()
	end
end