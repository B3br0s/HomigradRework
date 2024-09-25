local SWEP = oop.Get("hg_wep")
if not SWEP then return end

function SWEP:CanFight(ignoreClose)--cring
	local owner = self:GetOwner()

	if owner:IsNPC() then return true end
	
	if self:IsHolstered() or not self:IsDeployed() or self.reloadedStart or self.fightDelay > CurTime() then return false end
	if not owner:GetNWBool("fake") and (owner:IsSprinting() or (not ignoreClose and self.isClose)) then return false end

	return true
end

SWEP.MuzzlePos = Vector(0,0,0)
SWEP.MuzzleAng = Angle(0,0,0)

function SWEP:GetMuzzlePos(gun)
	gun = gun or self:GetGun()
	
	local pos,ang
    local att = gun:GetAttachment(gun:LookupBone("muzzle") or 1)

	if att then
		pos,ang = att.Pos,att.Ang
	else
		pos,ang = gun:GetPos(),gun:GetAngles()
	end

	ang:Rotate(self.MuzzleAng)

    return pos:Add(self.MuzzlePos:Clone():Rotate(ang)),ang
end

function SWEP:HasFake()
	local fake = self:GetNWEntity("Fake")
    if not IsValid(fake) then return end

    fake.fake = true
    
	return fake
end

function SWEP:GetGun()
	local fake = self:HasFake()
    if fake then return fake,true end

	local wm = self.wm

	return (IsValid(wm) and wm) or self
end

function SWEP:OnEntityCopyTableFinish(tbl)
	tbl.Clip1 = self:Clip1()
end

function SWEP:CanFootKick() return self:GetOwner():IsSprinting() end

function SWEP:ShouldDropOnDie() return false end
function SWEP:OnDrop() self:GetPhysicsObject():SetMaterial("weapon") end

function SWEP:SoundEmit(path,level,volume,pitch)
	if SERVER then
		sound.EmitNET(self:EntIndex(),path,level,volume,pitch,self:GetPos())
		if self:GetOwner():IsNPC() then net.Broadcast() else net.SendOmit(self:GetOwner()) end
	else
		sound.Emit(self:EntIndex(),path,level,volume,pitch,self:GetPos())
	end
end

function SWEP:SoundEmitSERVER(path,level,volume,pitch)
	if CLIENT then return end

	sound.Emit(self:EntIndex(),path,level,volume,pitch,self:GetPos())
end


if CLIENT then return end