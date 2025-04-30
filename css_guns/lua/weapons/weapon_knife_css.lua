if (SERVER) then

	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if ( CLIENT ) then
	SWEP.PrintName			= "Knife"	
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	SWEP.ViewModelFOV		= 77
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= true
	
	SWEP.Slot				= 0
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "j"

	killicon.AddFont("weapon_knife", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
	surface.CreateFont("CSKillIcons", {font = "csd", size = ScreenScale(30), weight = 500, antialias = true, additive = true})
	surface.CreateFont("CSSelectIcons", {font = "csd", size = ScreenScale(60), weight = 500, antialias = true, additive = true})
end

SWEP.Category				= "Counter-Strike"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel 				= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel 			= "models/weapons/w_knife_t.mdl" 

SWEP.DrawWeaponInfoBox  	= false

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.ClipSize			= -1
SWEP.Primary.Damage				= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= "none"


SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Damage			= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo				= "none"

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end
end

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize() 
	self:SetWeaponHoldType( "knife" ) 	 
end 

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:EmitSound( "Weapon_Knife.Deploy" )
	return true
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 80 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.4)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then

	local DamageMath = math.random(0,5)

	if DamageMath == 3 then

		dmg = 20
	else

		dmg = 15
	end

		if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = dmg
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( "Weapon_Knife.Hit" )
		else
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = dmg
			self.Owner:FireBullets(bullet)
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.Weapon:EmitSound( "Weapon_Knife.HitWall" )

		end
	else
		self.Weapon:EmitSound("Weapon_Knife.Slash")
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
end

function SWEP:EntityFaceBack(ent)
	local angle = self.Owner:GetAngles().y -ent:GetAngles().y
	if angle < -180 then angle = 360 +angle end
	if angle <= 90 and angle >= -90 then return true end
	return false
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 60 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.4)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then

	local damage

	if self:EntityFaceBack(trace.Entity) then

		damage = 195
	else
		damage = 65

	end

		if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = damage
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( "Weapon_Knife.Stab" )
		else
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 65
			self.Owner:FireBullets(bullet)

			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.Weapon:EmitSound("Weapon_Knife.HitWall")

		end
	else
		self.Weapon:EmitSound("Weapon_Knife.Slash")
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	return false
end

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()

return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()

	return true
end

/*---------------------------------------------------------
DrawWeaponSelection
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)

	draw.SimpleText(self.IconLetter, "CSSelectIcons", x + wide / 2, y + tall * 0.3, Color(255, 210, 0, 255), TEXT_ALIGN_CENTER)
	-- Draw a CS:S select icon

	self:PrintWeaponInfo(x + wide + 20, y + tall * 0.95, alpha)
	-- Print weapon information
end

/*---------------------------------------------------------
	DrawHUD
	
	Just a rough mock up showing how to draw your own crosshair.
	
---------------------------------------------------------*/

function SWEP:DrawHUD()


	local x, y

	// If we're drawing the local player, draw the crosshair where they're aiming,
	// instead of in the center of the screen.
	if ( self.Owner == LocalPlayer() && self.Owner:ShouldDrawLocalPlayer() ) then

		local tr = util.GetPlayerTrace( self.Owner )
		tr.mask = bit.bor( CONTENTS_SOLID,CONTENTS_MOVEABLE,CONTENTS_MONSTER,CONTENTS_WINDOW,CONTENTS_DEBRIS,CONTENTS_GRATE,CONTENTS_AUX )
		local trace = util.TraceLine( tr )
		
		local coords = trace.HitPos:ToScreen()
		x, y = coords.x, coords.y

	else
		x, y = ScrW() / 2.0, ScrH() / 2.0
	end
	
	local scale = 1 
	
	// Scale the size of the crosshair according to how long ago we fired our weapon
	local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
	scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))

	surface.SetDrawColor( 0, 255, 0, 255 )
	
	
	// Draw an awesome crosshair
	local gap = scale + 5
	local length = gap + 8 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )

end

function SWEP:DoImpactEffect( tr, nDamageType )
	util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)	
	return true;
	
end