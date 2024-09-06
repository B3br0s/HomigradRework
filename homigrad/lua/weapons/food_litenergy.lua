if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'weapon_base'
AddCSLuaFile()

SWEP.PrintName = "LIT-ENERGY"
SWEP.Author = "Homigrad"
SWEP.Purpose = "Ебать кондиций в моменте набрал"
SWEP.Category = "Вкусности"

SWEP.Slot = 3
SWEP.SlotPos = 3
SWEP.Spawnable = true

SWEP.ViewModel = "models/jorddrink/mongcan1a.mdl"
SWEP.WorldModel = "models/jorddrink/mongcan1a.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.OstalosVipit = 3
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = false

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	if !IsValid(DrawModel) then
		DrawModel = ClientsideModel( self.WorldModel, RENDER_GROUP_OPAQUE_ENTITY );
		DrawModel:SetNoDraw( true );
	else
		DrawModel:SetModel( self.WorldModel )

		local vec = Vector(55,55,55)
		local ang = Vector(-48,-48,-48):Angle()

		cam.Start3D( vec, ang, 20, x, y+35, wide, tall, 5, 4096 )
			cam.IgnoreZ( true )
			render.SuppressEngineLighting( true )

			render.SetLightingOrigin( self:GetPos() )
			render.ResetModelLighting( 50/255, 50/255, 50/255 )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 255 )

			render.SetModelLighting( 4, 1, 1, 1 )

			DrawModel:SetRenderAngles( Angle( 0, RealTime() * 30 % 360, 0 ) )
			DrawModel:DrawModel()
			DrawModel:SetRenderAngles()

			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
		cam.End3D()
	end

	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )

end

function SWEP:Initialize()
	self:SetHoldType( "slam" )
	if ( CLIENT ) then return end
end

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
function SWEP:PrimaryAttack()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	if(SERVER)then
		if self.OstalosVipit > 0 then
		local healsound = Sound("snd_jack_hmcd_drink"..math.random(1,3)..".wav")
		self:GetOwner():SetVelocity( Vector(0,0,450) )
		self:SetNextPrimaryFire(CurTime() + 1)
		self.OstalosVipit = self.OstalosVipit - 1
		sound.Play(healsound, self:GetPos(),75,100,0.5)
		elseif self.OstalosVipit <= 0 then
    local trace = self:GetOwner():GetEyeTrace()

    local prop = ents.Create("prop_physics")
    if not IsValid(prop) then return end

    prop:SetModel(self.WorldModel)

    prop:SetPos(self:GetOwner():GetPos())

	local randomAngle = Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360))

    prop:Spawn()
	
	prop:SetAngles(randomAngle)

    local phys = prop:GetPhysicsObject()
    if IsValid(phys) then
        local throwForce = 1000
        local forceDirection = (trace.HitPos - self:GetOwner():GetShootPos()):GetNormalized()
        phys:ApplyForceCenter(forceDirection * throwForce)
    end
			self:GetOwner():SelectWeapon("weapon_hands")
			self:Remove()
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
	local trace = self:GetOwner():GetEyeTrace()

    local prop = ents.Create("prop_physics")
    if not IsValid(prop) then return end

    prop:SetModel(self.WorldModel)

    prop:SetPos(self:GetOwner():GetPos())

	local randomAngle = Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360))

    prop:Spawn()
	
	prop:SetAngles(randomAngle)

    local phys = prop:GetPhysicsObject()
    if IsValid(phys) then
        local throwForce = 2000
        local forceDirection = (trace.HitPos - self:GetOwner():GetShootPos()):GetNormalized()
        phys:ApplyForceCenter(forceDirection * throwForce)
    end

			self:GetOwner():SelectWeapon("weapon_hands")
			self:Remove()
end
end
end