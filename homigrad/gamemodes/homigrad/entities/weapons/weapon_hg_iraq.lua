SWEP.Base = "weapon_hg_granade_base"

SWEP.PrintName = "Иракская Кола"
SWEP.Author = "Homigrad"
SWEP.Instructions = "babah"
SWEP.Category = "Вкусности"
SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true
SWEP.RequiresPin = true
SWEP.PinOut = false
SWEP.PinSound = "weapons/tfa_csgo/flashbang/pinpull.wav"
SWEP.Leveractivatedonce = false
SWEP.AdminOnly = true
SWEP.a = 1
SWEP.LeverProebal = false

SWEP.ViewModel = "models/foodnhouseholditems/sodacan01.mdl"
SWEP.WorldModel = "models/foodnhouseholditems/sodacan01.mdl"

SWEP.Granade = "ent_jack_gmod_ezimpactnadeiraq"

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
				local offsetVec = Vector(4,-2.7,0)
				local offsetAng = Angle(180, -45, 0)
				
				local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
				if !boneid then return end
	
				local matrix = _Owner:GetBoneMatrix(boneid)
				if !matrix then return end
	
				local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
	
				WorldModel:SetPos(newPos)
				WorldModel:SetAngles(newAng)
	
				WorldModel:SetupBones()
			else
				WorldModel:SetPos(self:GetPos())
				WorldModel:SetAngles(self:GetAngles())
			end
	
			WorldModel:DrawModel()
		end
	end
end