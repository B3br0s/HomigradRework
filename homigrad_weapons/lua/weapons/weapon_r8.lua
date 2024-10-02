if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "R8"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Револьвер под калибр .44 Remington Magnum"
SWEP.Category 				= "Оружие"
SWEP.IconkaInv = "vgui/weapon_csgo_revolver.png"
SWEP.CanManipulatorKuklovodAngle = true

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".44 Remington Magnum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 60
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "csgo/weapons/revolver/revolver-1_01.wav"
SWEP.Primary.HammerSound = "arccw_go/revolver/revolver_prepare.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 90/3
SWEP.Baraban = true
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.3
SWEP.MagOut = "csgo/weapons/revolver/revolver_clipout.wav"
SWEP.MagIn = "csgo/weapons/revolver/revolver_clipin.wav"
SWEP.BoltOut = "csgo/weapons/revolver/revolver_siderelease.wav"
SWEP.BoltIn = "csgo/weapons/revolver/revolver_sideback.wav"
SWEP.MagOutWait = 0.6
SWEP.MagInWait = 1.5
SWEP.BoltInWait = 2
SWEP.Primary.Delay = 1
SWEP.BoltOutWait = 0.3
SWEP.ShootDelay = 0.17
SWEP.revolver = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/smoke' )
SWEP.BounceWeaponIcon = false
end
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

------------------------------------------

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(3,math.Rand(-0.1,0.1),0)
end

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/csgo/weapons/w_pist_revolver.mdl"
SWEP.WorldModel				= "models/csgo/weapons/w_pist_revolver.mdl"
SWEP.OtherModel				= "models/weapons/arccw_go/v_pist_r8.mdl"

SWEP.vbwPos = Vector(8.5,-10,-8)

SWEP.addPos = Vector(0,0,-1)
SWEP.addAng = Angle(-4.4,0.5,0)

SWEP.MuzzleFXPos = Vector(0,1,0)

    SWEP.dwmModeScale = 1 -- pos
    SWEP.dwmForward = -13
    SWEP.dwmRight = 5.3
    SWEP.dwmUp = -1.47
    
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

    --смуф
    function SWEP:ManipulateSlideBoneForAng()
        if not IsValid(model) then return end
    
        local slideBone = model:LookupBone("v_weapon.hammer")
        if not slideBone then return end
    
        for i = 1, 60 do
            timer.Simple(0.0001 * i,function ()
                local slideOffset = LerpAngle( 1.5, Angle(0,0,0),Angle(0,0,-30 + i / 2) )
                model:ManipulateBoneAngles(slideBone, slideOffset)   
            end)
        end
    end

    function SWEP:ManipulateSlideBoneBacAng()
        if not IsValid(model) then return end
    
        local slideBone = model:LookupBone("v_weapon.hammer")
        if not slideBone then return end
    
        for i = 1, 60 do
            timer.Simple(0.001 * i,function ()
                local slideOffset = LerpAngle( 1.5, Angle(0,0,0),Angle(0,0,-i / 2) )
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

function SWEP:PrimaryAttack()
    if self.CanManipulatorKuklovodAngle then
		self:ManipulateSlideBoneBacAng()

        sound.Play(self.Primary.HammerSound,self:GetPos(),65,100)
            
                self.ShootNext = self.NextShot or NextShot
            
            
                if not IsFirstTimePredicted() then return end
            
                if self.NextShot > CurTime() then return end
                if timer.Exists("reload"..self:EntIndex()) then return end
            
                local canfire = self:CanFireBullet()
                --self:GetOwner():ChatPrint(tostring(canfire)..(CLIENT and " client" or " server"))
                if self:Clip1() <= 0 or not canfire and self.NextShot < CurTime() then
                    if SERVER then
                        timer.Simple(self.ShootDelay,function ()
                        sound.Play("snd_jack_hmcd_click.wav",self:GetPos(),65,100)
                        end)
                    end
                    timer.Simple(self.ShootDelay,function ()
                    self:ManipulateSlideBoneForAng()
                    end)
                    self.NextShot = CurTime() + self.ShootWait
                    self.AmmoChek = 3
                    return
                end
            
                self:PrePrimaryAttack()
            
                if self.isClose or not self:GetOwner():IsNPC() and self:GetOwner():IsSprinting() then return end
            
                local ply = self:GetOwner() -- а ну да
                self.NextShot = CurTime() + self.ShootWait
                timer.Simple(self.ShootDelay,function ()
                self:ManipulateSlideBoneForAng()
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
                        self:EmitSound(self.Primary.Sound,511,math.random(100,120),1,CHAN_VOICE_BASE,0,0)
                    
                        if self.Primary.PumpSound then
                            timer.Simple(0.2,function ()
                                sound.Play(self.Primary.PumpSound,self:GetOwner():GetPos(),1000,100)
                            end)
                        end
                    else
                        self.Efect = "PhyscannonImpact"
                        self:EmitSound(self.Primary.SoundSupresor,511,math.random(100,120),1,CHAN_VOICE_BASE,0,0)
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
            end)

	end
end
end