if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "SPAS-12"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Полуавтоматический дробовик под калибр 12/70"
SWEP.Category 				= "Оружие"
SWEP.IconkaInv = "vgui/weapon_pwb_spas_12.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12/70 gauge"
SWEP.Primary.Cone = 0.05
SWEP.Primary.Damage = 1.7 * 120
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/shotgun/shotgun_dbl_fire7.wav"
SWEP.Primary.SoundFar = "toz_shotgun/toz_dist.wav"
SWEP.LoadSound = "csgo/weapons/sawedoff/sawedoff_insertshell_01"
SWEP.Primary.Force = 15
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/spas_12' )
SWEP.BounceWeaponIcon = false
end
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.3
SWEP.NumBullet = 12
SWEP.Sight = true
SWEP.TwoHands = true
SWEP.CanManipulatorKuklovod = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"
SWEP.shotgun = false

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_spas_12.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_spas_12.mdl"
SWEP.OtherModel				= "models/sirgibs/hl2/weapons/shotgun.mdl"

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(5,math.Rand(-2,2),0)
end

SWEP.vbwPos = Vector(4,-3.5,-5)
SWEP.vbwAng = Angle(5,-30,0)

SWEP.CLR_Scope = 0.05
SWEP.CLR = 0.025


SWEP.vbwPos = Vector(-9,-5,-5)

SWEP.CLR_Scope = 0.05
SWEP.CLR = 0.025

SWEP.addAng = Angle(2,0,0)
SWEP.addPos = Vector(0,0,0)

SWEP.dwmModeScale = 1 -- pos
    SWEP.dwmForward = 0
    SWEP.dwmRight = 1
    SWEP.dwmUp = 0
    
    SWEP.dwmAUp = 0 -- ang
    SWEP.dwmARight = -8
    SWEP.dwmAForward = 180
    
    local model 
    if CLIENT then
        model = GDrawWorldModel or ClientsideModel(SWEP.WorldModel,RENDER_GROUP_OPAQUE_ENTITY)
        GDrawWorldModel = model
        model:SetNoDraw(true)
    end
    
    if SERVER then
        function SWEP:GetPosAng()
            local owner = self:GetOwner()
            local Pos,Ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
            if not Pos then return end
            
            Pos:Add(Ang:Forward() * self.dwmForward)
            Pos:Add(Ang:Right() * self.dwmRight)
            Pos:Add(Ang:Up() * self.dwmUp)
    
            Ang:RotateAroundAxis(Ang:Up(),self.dwmAUp)
            Ang:RotateAroundAxis(Ang:Right(),self.dwmARight)
            Ang:RotateAroundAxis(Ang:Forward(),self.dwmAForward)
    
            return Pos,Ang
        end
    else
        function SWEP:SetPosAng(Pos,Ang)
            self.Pos = Pos
            self.Ang = Ang
        end
        function SWEP:GetPosAng()
            return self.Pos,self.Ang
        end
    end
    
    function SWEP:ManipulateSlideBoneFor()
        if not IsValid(model) then return end
    
        local slideBone = model:LookupBone("Bolt")
        if not slideBone then return end
        for i = 1, 450 do
            timer.Simple(0.0001 * i,function ()
                local slideOffset = LerpVector( 2, Vector(0,0,0),Vector(0,0,-i / 350) )
                model:ManipulateBonePosition(slideBone, slideOffset)
            end)
        end
    end

    function SWEP:ManipulateSlideBoneBac()
        if not IsValid(model) then return end
    
        local slideBone = model:LookupBone("Bolt")
        if not slideBone then return end
    
        for i = 0, 450 do
            timer.Simple(0.0001 * i,function ()
                local slideOffset = LerpVector( 2, Vector(0,0,0),Vector(0,0,-1 + i / 350))
                model:ManipulateBonePosition(slideBone, slideOffset)
            end)
        end
    end
    
    function SWEP:DrawWorldModel()
        local owner = self:GetOwner()
        if LocalPlayer() == owner then
        if not IsValid(owner) then
            self:DrawModel()
            return
        end
            model:SetModel(self.OtherModel)
        

        local Pos,Ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
        if not Pos then return end
        
        Pos:Add(Ang:Forward() * self.dwmForward)
        Pos:Add(Ang:Right() * self.dwmRight)
        Pos:Add(Ang:Up() * self.dwmUp)
    
        Ang:RotateAroundAxis(Ang:Up(),self.dwmAUp)
        Ang:RotateAroundAxis(Ang:Right(),self.dwmARight)
        Ang:RotateAroundAxis(Ang:Forward(),self.dwmAForward)
        
        self:SetPosAng(Pos,Ang)
    
        model:SetPos(Pos)
        model:SetAngles(Ang)
    
        model:SetModelScale(self.dwmModeScale)
    
        model:DrawModel()
    else
            self:SetModel(self.WorldModel)
            self:DrawModel()
end
end
function SWEP:PrimaryAttack()
	if self.CanManipulatorKuklovodAngle then
		self:ManipulateSlideBoneForAng()
		timer.Simple(0.2,function ()
			self:ManipulateSlideBoneBacAng()
		end)
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
	
	if SERVER then
		net.Start("huysound")
		net.WriteEntity(self)
		net.WriteVector(self:GetPos())
		net.WriteString(self.Primary.Sound)
		net.WriteString(self.Primary.SoundFar)
		net.WriteEntity(self:GetOwner())
		net.Broadcast()
	else
		if self:GetNWBool("Suppressor", false) != true then
			self:EmitSound(self.Primary.Sound,511,math.random(100,110),1,CHAN_VOICE_BASE,0,0)
			if self:Clip1() != 0 then
				if self.CanManipulatorKuklovod and not self.shotgun then
					self:ManipulateSlideBoneFor()
					timer.Simple(0.05,function ()
						self:ManipulateSlideBoneBac()
					end)
				elseif self.CanManipulatorKuklovod and self.shotgun then
					timer.Simple(0.3,function ()
					self:ManipulateSlideBoneFor()
					timer.Simple(0.2,function ()
						self:ManipulateSlideBoneBac()
					end)
				end)
				end
				end
		
			if self.Primary.PumpSound then
				timer.Simple(0.2,function ()
					sound.Play(self.Primary.PumpSound,self:GetOwner():GetPos(),1000,100)
				end)
			end
		else
			self.Efect = "PhyscannonImpact"
			self:EmitSound(self.Primary.SoundSupresor,511,math.random(100,120),1,CHAN_VOICE_BASE,0,0)
			if self.CanManipulatorKuklovod then
				self:ManipulateSlideBoneFor()
				timer.Simple(0.01,function ()
					self:ManipulateSlideBoneBac()
				end)
			end
			if self.Primary.PumpSound then
				timer.Simple(0.2,function ()
					sound.Play(self.Primary.PumpSound,self:GetOwner():GetPos(),1000,100)
				end)
			end
		end
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
end