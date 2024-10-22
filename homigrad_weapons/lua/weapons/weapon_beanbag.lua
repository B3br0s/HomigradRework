if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "Remington870 Police"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Дробовик под калибр 12/70 Фасоль"
SWEP.Category 				= "Оружие"
SWEP.IconkaInv = "vgui/weapon_pwb2_remington870police.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12/70 beanbag"
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/remington_870' )
SWEP.BounceWeaponIcon = false
end
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 50
SWEP.RubberBullets = true
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "toz_shotgun/toz_fp.wav"
SWEP.Primary.SoundFar = "toz_shotgun/toz_dist.wav"
SWEP.Primary.PumpSound = "csgo/weapons/sawedoff/sawedoff_pump.wav"
SWEP.Primary.PumpBack = "weapons/ak47/handling/ak47_boltback.wav"
SWEP.Primary.PumpForward = "weapons/ak47/handling/ak47_boltrelease.wav"
SWEP.Primary.Force = 0.5
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.7
SWEP.NumBullet = 1
SWEP.LoadSound = "csgo/weapons/sawedoff/sawedoff_insertshell_01"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"
SWEP.PumpDB = true
SWEP.Pumped = true
SWEP.Type = "Pump"
SWEP.shotgun = true

function SWEP:Reload()
    if !self.Pumped and self.PumpDB and not self:GetOwner():KeyDown(IN_ATTACK) then
        if CLIENT then
			local ply = self:GetOwner()
			net.Start("PumpVFX")
            net.WriteEntity(ply)
            net.SendToServer()
            if self.CanManipulatorKuklovod then
                    self:ManipulateSlideBoneFor()
                    timer.Simple(0.15, function()
                        self:ManipulateSlideBoneBac()
                    end)
            end
        end        
        self.PumpDB = false
        self:EmitSound(self.Primary.PumpBack)
        self.Pumping = true
        timer.Simple(0.15,function ()
        self:EmitSound(self.Primary.PumpForward)
        self.Pumping = false
        timer.Simple(0.2,function ()
        self.Pumped = true
        self.PumpDB = true
        end)
        end)
    return
    end
	if !self:GetOwner():KeyDown(IN_WALK) and self.Pumped then
		self.AmmoChek = 3
		if timer.Exists("reload"..self:EntIndex())  or self:Clip1()>=self:GetMaxClip1() or self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )<=0 then return nil end
		if self:GetOwner():IsSprinting() then return nil end
		if ( self.NextShot > CurTime() ) then return end
		self:GetOwner():SetAnimation(PLAYER_RELOAD)
		self:EmitSound(self.ReloadSound,60,100,0.8,CHAN_AUTO)
		self:GetOwner():SetNWFloat("PosaVistrela",1)
		timer.Create( "reload"..self:EntIndex(), self.ReloadTime, 1, function()
			if IsValid(self) and IsValid(self:GetOwner()) and self:GetOwner():GetActiveWeapon()==self then --and not self.LoadSound then
				local oldclip = self:Clip1()
				self:SetClip1(math.Clamp(self:Clip1()+self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() ),0,self:GetMaxClip1()))
				local needed = self:Clip1()-oldclip
				self:GetOwner():SetAmmo(self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )-needed, self:GetPrimaryAmmoType())
				self.AmmoChek = 5
			end
		end)
	else
		self.AmmoChek = 5
	end
end

function SWEP:PrimaryAttack()
    if self.shotgun and self.Type == "Pump" and !self.Pumped then return end
	if self.CanManipulatorKuklovodAngle then
		if CLIENT then
		self:ManipulateSlideBoneForAng()
		timer.Simple(0.2,function ()
			self:ManipulateSlideBoneBacAng()
		end)
		end
	end

	self.ShootNext = self.NextShot or NextShot


	if not IsFirstTimePredicted() then return end

	if self.NextShot > CurTime() then return end
	if timer.Exists("reload"..self:EntIndex()) then return end

	local canfire = self:CanFireBullet()
	--self:GetOwner():ChatPrint(tostring(canfire)..(CLIENT and " client" or " server"))
	if self:Clip1() <= 0 or not canfire and self.NextShot < CurTime() then
		if SERVER then
			sound.Play("snd_jack_hmcd_click.wav",self:GetPos(),65,100)
		end
		self.NextShot = CurTime() + self.ShootWait
		self.AmmoChek = 3
		return
	end

	self:PrePrimaryAttack()

	if self.isClose or not self:GetOwner():IsNPC() and self:GetOwner():IsSprinting() then return end

	local ply = self:GetOwner() -- а ну да
	self.NextShot = CurTime() + self.ShootWait
    self.Pumped = false
	
	if SERVER then
		net.Start("huysound")
		net.WriteVector(self:GetPos())
		net.WriteString(self.Primary.Sound)
		net.WriteString(self.Primary.SoundFar)
		net.WriteEntity(self:GetOwner())
		net.Broadcast()
	else
		self:EmitSound(self.Primary.Sound, 511, math.random(100, 120), 1, CHAN_VOICE_BASE, 0, 0)
	end
	
	local dmg = self.Primary.Damage
    self:FireBullet(dmg, 1, 5)
	self:SetNWFloat("VisualRecoil", self:GetNWFloat("VisualRecoil") + self.Primary.Force/90)

	if SERVER and not ply:IsNPC() then
		if ply.RightArm < 1 then
			ply.pain = ply.pain + self.Primary.Damage / 30 * (self.NumBullet or 1)
		end

		if ply.LeftArm < 1 and self.TwoHands then
			ply.pain = ply.pain + self.Primary.Damage / 30 * (self.NumBullet or 1)
		end
	end

	if CLIENT and ply == LocalPlayer() then
		self.ZazhimYaycami = math.min(self.ZazhimYaycami + 1,self.Primary.ClipSize)
	end
	
	if CLIENT and (self:GetOwner() != LocalPlayer()) then
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	end
	
	self.lastShoot = CurTime()
	self:SetNWFloat("LastShoot",CurTime())

	if CLIENT and ply == LocalPlayer() then
		self.eyeSpray = self.eyeSpray or Angle(0,0,0)
		
		local func = self.ApplyEyeSpray
		if func then
			func(self)
		else
			self.eyeSpray:Add(Angle(math.Rand(-0.9,0.5) * self.Primary.Damage / 30 * math.max((self.ZazhimYaycami / self.Primary.ClipSize),0.2),math.Rand(-0.5,0.5) * self.Primary.Damage / 30 * math.max((self.ZazhimYaycami / self.Primary.ClipSize),0.2),0))
		end
	end
end

------------------------------------------

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(1,math.Rand(-0.5,0.5),0)
    self.NumBullet = math.random(1,3)
end

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb2/weapons/w_remington870police.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_remington870police.mdl"

SWEP.vbwPos = Vector(-8,-6,-6)

SWEP.addAng = Angle(0.4,0,0)
SWEP.addPos = Vector(0,0,0)
end