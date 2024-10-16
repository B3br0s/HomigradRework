if engine.ActiveGamemode() == "homigrad" then
AddCSLuaFile()

SWEP.Base = "medkit"

SWEP.PrintName = "Антидот xTG-12"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Снимает большую часть известных ядов и токсинов, используемых в боевой промышленности."

SWEP.Spawnable = true
SWEP.OpenCapSound = "arc9_eft_shared/shells/12cal_shell_concrete1.ogg"
SWEP.Category = "Медицина"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.ViewModel = "models/weapons/w_arc_vm_medshot.mdl"
SWEP.WorldModel = "models/weapons/w_arc_vm_medshot.mdl"
SWEP.Skin = 5

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
				local offsetAng = Angle(-90, -45, 0)
				
				local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
				if !boneid then return end
	
				local matrix = _Owner:GetBoneMatrix(boneid)
				if !matrix then return end
	
				local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
	
				WorldModel:SetPos(newPos)
				WorldModel:SetAngles(newAng)
	
				WorldModel:SetupBones()

                WorldModel:SetSkin(self.Skin)
			else
				WorldModel:SetPos(self:GetPos())
				WorldModel:SetAngles(self:GetAngles())
			end
	
			WorldModel:DrawModel()
		end
	end
end


function SWEP:vbwFunc(ply)
    local ent = ply:GetWeapon("medkit")
    if ent and ent.vbwActive then return self.vbwPos,self.vbwAng end
    return self.vbwPos2,self.vbwAng2
end
end