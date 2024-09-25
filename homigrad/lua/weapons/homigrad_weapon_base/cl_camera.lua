local SWEP = oop.Get("hg_wep")
if not SWEP then return end

function SWEP:GetCameraTransform()
	if IsValid(self:GetNWEntity("Fake")) then return end

	local pos,ang = self:GetMuzzlePos()
    if not pos then return end
    
	return pos:Add(self.CameraPos:Clone():Rotate(ang)),ang
end

ScopeLerp = ScopeLerp or 0
FightLerp = FightLerp or 0

local angZero = Angle()

local oldAng = Angle()

local hg_camera_smooth = GetConVar("hg_camera_smooth")
local immersive3 = 0

local oldScope = 0

local function canFight(self)
	local owner = self:GetOwner()

	if owner:GetNWBool("fake") or self:IsHolstered() then return false end
	if owner:IsSprinting() or self.isClose then return false end
	
	return true
end

SWEP:Event_Add("Post CalcView","HandUp",function(self,owner)
    owner:AddBoneAng("rhand",self:GetAngleHand())
    owner:SetupBones()
end)

event.Add("PreCalcView","Weapons",function(ply,view)
    if not ply:Alive() then return end
    
    local wep = ply:GetActiveWeapon()
    wep = IsValid(wep) and wep

    local vec,ang = view.vec,view.ang
    local vecWep,angWep = vec:Clone(),ang:Clone()
    local isPistol

	if wep and wep.GetCameraTransform then
        wep:Event_Call("Pre CalcView",ply)

        wep:DrawWorldModel()--чтоб не дёргался

        vecWep,angWep = wep:GetCameraTransform()
        if not vecWep then return end--lol?

        wep:Event_Call("Post CalcView",ply)
	else
        ScopeLerp = LerpFT(0.5,ScopeLerp,0)

        return
    end

    local scope = wep:IsScope()

    local recoil = wep.recoil
    
    FightLerp = LerpFT(0.15,FightLerp,canFight(wep) and 1 or 0)
    ScopeLerp = LerpFT(scope and wep.ScopeLerp or wep.ScopeLerpOut or wep.ScopeLerp,ScopeLerp,scope and 1 or 0)

    local CImersiveSetL = wep.CImersiveSetL
    if CImersiveSetL then view.imersiveSetL = Lerp(ScopeLerp,CImersiveSetL,wep.CImersiveSetL_Scope or CImersiveSetL) end

    local CImersiveL = wep.CImersiveL
    if CImersiveL then view.imersiveL = Lerp(ScopeLerp,CImersiveL,wep.CImersiveL_Scope or CImersiveL) end

    local diff = oldAng - ang
    diff:Normalize()

    oldAng = ang:Clone()

    if angWep then
        if true then
            immersive3 = immersive3 - diff[2] / 2

            local vel = ply:GetVelocity()
            local diff = (vel:Angle() - ang)
            diff:Normalize()
            diff:Mul(math.Clamp(vel:Length(),0,1))

            immersive3 = immersive3 + CalcSideK(diff[2])
            immersive3 = math.Clamp(LerpFT(0.01,immersive3,0),-5,5)

            angWep[3] = angWep[3] + immersive3
        end

        if ScopeLerp > oldScope  then
            angWep[1] = angWep[1] - 5 * (1 - math.Clamp(ScopeLerp * 2,0,1))
            angWep[2] = angWep[2] - 5 * (1 - ScopeLerp)
            angWep[3] = angWep[3] + 5 * (1 - ScopeLerp)
        end
    end
    
    oldScope = ScopeLerp

    vec:Lerp(ScopeLerp,vecWep or vec)
    ang:Lerp(ScopeLerp,angWep or ang)

    if not BodyCamMode then
	    view.fov = view.fov + recoil * 0.5
        view.fov = Lerp(ScopeLerp,view.fov,CameraSetFOV - 25)
    end
    
    local anim_pos = recoil
    ang[3] = ang[3] + anim_pos * wep.randAbs * wep.CR3

    view.znear = Lerp(ScopeLerp,1,0.5)

    local posRecoil = Vector(Lerp(ScopeLerp,wep.CR,wep.CR_Scope) * recoil,0,0):Rotate((angWep or ang))
    vec:Add(posRecoil)

    ang:Lerp(FightLerp - ScopeLerp,ang + wep.CFightAng)
    vec:Lerp(FightLerp - ScopeLerp,vec + wep.CFightVec:Clone():Rotate(ang))

    if wep.ChangeCalcView then wep:ChangeCalcView(ply,view) end
end)