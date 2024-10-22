if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "АWP"
    SWEP.Author 				= "Homigrad"
    SWEP.Instructions			= "Автоматическая винтовка под калибр 7,62х39"
    SWEP.Category 				= "Оружие"
    SWEP.IconkaInv = "vgui/weapon_csgo_ak47.png"
    
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    
    ------------------------------------------
    
    SWEP.Primary.ClipSize		= 10
    SWEP.Primary.DefaultClip	= 10
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "7.62x54 mm"
    SWEP.Primary.Cone = 0
    SWEP.MagModel = "models/csgo/weapons/w_rif_ak47_mag.mdl"
    SWEP.Primary.Damage = 1.7 * 250
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = "arccw_go/awp/awp_01.wav"
    SWEP.Primary.SoundFar = "ak74/ak74_dist.wav"
    SWEP.Primary.SoundSupresor = "zcitysnd/sound/weapons/ak74/ak74_suppressed_fp.wav"
    SWEP.Primary.Force = 500
    SWEP.ReloadTime = 2
    SWEP.ShootWait = 1
    SWEP.ReloadSound = ""
    SWEP.TwoHands = true
    SWEP.RequiresBolt = true
    if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID( 'csgo/econ/weapons/base_weapons/weapon_ak47' )
    SWEP.BounceWeaponIcon = false
    end
    SWEP.MagOut = "arccw_go/awp/awp_clipout.wav"
    SWEP.MagIn = "arccw_go/awp/awp_clipin.wav"
    SWEP.BoltOut = "arccw_go/awp/awp_boltforward.wav"
    SWEP.BoltIn = "arccw_go/awp/awp_boltback.wav"
    SWEP.Primary.PumpForward = "arccw_go/awp/awp_boltforward.wav"
    SWEP.Primary.PumpBack = "arccw_go/awp/awp_boltback.wav"
    SWEP.MagOutWait = 0.2
    SWEP.MagInWait = 0.9
    SWEP.BoltInWait = 1.2
    SWEP.BoltOutWait = 1.5
    
    SWEP.Secondary.ClipSize		= -1
    SWEP.Secondary.DefaultClip	= -1
    SWEP.Secondary.Automatic	= false
    SWEP.Secondary.Ammo			= "none"
    
    ------------------------------------------
    
    SWEP.Weight					= 5
    SWEP.AutoSwitchTo			= false
    SWEP.CanManipulatorKuklovod = true
    SWEP.AutoSwitchFrom			= false
    
    SWEP.HoldType = "ar2"
    SWEP.PumpDB = true
    SWEP.Type = "Pump"
    SWEP.shotgun = true
    SWEP.Pumped = true

function SWEP:Reload()
    if !self.Pumped and self.PumpDB and not self:GetOwner():KeyDown(IN_ATTACK) then
        if CLIENT then
        local ply = self:GetOwner()
		net.Start("RifleShellVFX")
        net.WriteEntity(ply)
        net.SendToServer()
        if self.CanManipulatorKuklovod then
        self:ManipulateSlideBoneForAng()
        timer.Simple(0.1,function ()
            self:ManipulateSlideBoneFor()
        end)
	    timer.Simple(0.25,function ()
	    	self:ManipulateSlideBoneBac()
            timer.Simple(0.1,function ()
                self:ManipulateSlideBoneBacAng()
            end)
	    end)
        end
        end
        self.PumpDB = false
        self:EmitSound(self.Primary.PumpBack)
        timer.Simple(0.3,function ()
        self:EmitSound(self.Primary.PumpForward)
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
        if self.MagOut then
			timer.Simple(self.MagOutWait,function ()
				self:EmitSound(self.MagOut,60,100,0.8,CHAN_AUTO)
			end)
		end
		if self.MagIn then
			timer.Simple(self.MagInWait,function ()
				self:EmitSound(self.MagIn,60,100,0.8,CHAN_AUTO)
			end)
		end
		if self:Clip1() == 0 and not self.Baraban then
			if self.BoltOut then
				timer.Simple(self.BoltOutWait,function ()
					self:EmitSound(self.BoltOut,60,100,0.8,CHAN_AUTO)
				end)
			end
			if self.BoltIn then
				timer.Simple(self.BoltInWait,function ()
					self:EmitSound(self.BoltIn,60,100,0.8,CHAN_AUTO)
				end)
			end
		elseif self.Baraban then
			if self.BoltOut then
				timer.Simple(self.BoltOutWait,function ()
					self:EmitSound(self.BoltOut,60,100,0.8,CHAN_AUTO)
				end)
			end
			if self.BoltIn then
				timer.Simple(self.BoltInWait,function ()
					self:EmitSound(self.BoltIn,60,100,0.8,CHAN_AUTO)
				end)
			end
		end
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
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0
    SWEP.DrawAmmo				= true
    SWEP.DrawCrosshair			= false
    
    SWEP.ViewModel				= "models/pwb/weapons/w_akm.mdl"
    SWEP.WorldModel				= "models/pwb/weapons/w_sv98.mdl"
    SWEP.OtherModel				= "models/weapons/arccw_go/v_snip_awp.mdl"
    
    SWEP.vbwPos = Vector(5,-6,-6)
    
    SWEP.addAng = Angle(-4.3,-0.45,0)
    SWEP.addPos = Vector(0,3,0)

    function SWEP:ApplyEyeSpray()
        self.eyeSpray = self.eyeSpray - Angle(5,math.Rand(-0.5,0.5),0)
    end 
    
    SWEP.dwmModeScale = 1 -- pos
        SWEP.dwmForward = -10
        SWEP.dwmRight = 5.8
        SWEP.dwmUp = -2.9
        
        SWEP.dwmAUp = 0 -- ang
        SWEP.dwmARight = -15
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
        
            local slideBone = model:LookupBone("v_weapon.awp_bolt_rail")
            if not slideBone then return end
            for i = 1, 120 do
                timer.Simple(0.0006 * i,function ()
                    local slideOffset = LerpVector( 2, Vector(0,0,0),Vector(0,0,-i / 100) )
                    model:ManipulateBonePosition(slideBone, slideOffset)   
                end)
            end
        end
    
        function SWEP:ManipulateSlideBoneBac()
            if not IsValid(model) then return end
        
            local slideBone = model:LookupBone("v_weapon.awp_bolt_rail")
            if not slideBone then return end
        
            for i = 0, 120 do
                timer.Simple(0.0006 * i,function ()
                    local slideOffset = LerpVector( 2, Vector(0,0,0),Vector(0,0,-1.2 + i / 100))
                    model:ManipulateBonePosition(slideBone, slideOffset)
                end)
            end
        end

        function SWEP:ManipulateSlideBoneBacAng()
            if not IsValid(model) then return end
        
            local slideBone = model:LookupBone("v_weapon.awp_bolt_action")
            if not slideBone then return end
        
            for i = 1, 150 do
                timer.Simple(0.001 * i,function ()
                    local slideOffset = LerpAngle( 1.5, Angle(0,0,0),Angle(0,50 - math.Round(i) / 3,0) )
                    model:ManipulateBoneAngles(slideBone, slideOffset)   
                end)
            end
        end
    
        function SWEP:ManipulateSlideBoneForAng()
            if not IsValid(model) then return end
        
            local slideBone = model:LookupBone("v_weapon.awp_bolt_action")
            if not slideBone then return end
        
            for i = 1, 150 do
                timer.Simple(0.001 * i,function ()
                    local slideOffset = LerpAngle( 1.5, Angle(0,0,0),Angle(0,i / 3,0) )
                    model:ManipulateBoneAngles(slideBone, slideOffset)   
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
end