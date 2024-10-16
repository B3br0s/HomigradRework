if engine.ActiveGamemode() == "homigrad" then
AddCSLuaFile()

SWEP.Base = "medkit"

SWEP.PrintName = "Жгут"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Лечит кровотечение из артерии."

SWEP.Spawnable = true
SWEP.Category = "Медицина"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.ViewModel = "models/freeman/flexcuffs.mdl"
SWEP.WorldModel = "models/freeman/flexcuffs.mdl"

function SWEP:vbwFunc(ply)
    local ent = ply:GetWeapon("medkit")
    if ent and ent.vbwActive then return self.vbwPos,self.vbwAng end
    return self.vbwPos2,self.vbwAng2
end

SWEP.dwsPos = Vector(15,15,5)
SWEP.dwsItemPos = Vector(0,0,2)

SWEP.vbwPos = Vector(0,0,0)
SWEP.vbwAng = Angle(0,0,0)
SWEP.vbwModelScale = 0.8

SWEP.vbwPos2 = Vector(0,0,0)
SWEP.vbwAng2 = Angle(0,0,0)
if(CLIENT)then
	function SWEP:PreDrawViewModel(vm,wep,ply)
	end
	function SWEP:GetViewModelPosition(pos,ang)
		pos=pos-ang:Up()*10+ang:Forward()*30+ang:Right()*7
		ang:RotateAroundAxis(ang:Up(),90)
		ang:RotateAroundAxis(ang:Right(),-10)
		ang:RotateAroundAxis(ang:Forward(),-10)
		return pos,ang
	end
	if CLIENT then
		local WorldModel = ClientsideModel(SWEP.WorldModel)

		WorldModel:SetNoDraw(true)
	
		function SWEP:DrawWorldModel()
			local _Owner = self:GetOwner()
	
			if (IsValid(_Owner)) then
				-- Specify a good position
				local offsetVec = Vector(3,-2,-2)
				local offsetAng = Angle(0, -45, 90)
				
				local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
				if !boneid then return end
	
				local matrix = _Owner:GetBoneMatrix(boneid)
				if !matrix then return end
	
				local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
	
				WorldModel:SetPos(newPos)
				WorldModel:SetAngles(newAng)
	
				WorldModel:SetupBones()

                WorldModel:SetBodygroup(1,1)
			else
				WorldModel:SetPos(self:GetPos())
				WorldModel:SetAngles(self:GetAngles())
			end
	
			WorldModel:DrawModel()
		end
	end
end


SWEP.dwmModeScale = 1.2
SWEP.dwmForward = 3.5
SWEP.dwmRight = 1
SWEP.dwmUp = -1

SWEP.dwmAUp = 90
SWEP.dwmARight = 90
SWEP.dwmAForward = 0
end