if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "HK USP Match"
    SWEP.Author 				= "Homigrad"
    SWEP.Category 				= "Оружие"
    SWEP.WepSelectIcon			= "entities/weapon_insurgencymakarov.png"
    SWEP.IconkaInv = "vgui/weapon_pwb2_usptactical.png"
    
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    
    ------------------------------------------
    
    SWEP.Primary.ClipSize		= 13
    SWEP.Primary.DefaultClip	= 13
    SWEP.NeedToChange = true
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.7 * 35
    SWEP.RubberBullets = false
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = "weapons/pistol/pistol_fire2.wav"
    SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
    SWEP.Primary.Force = 0.1
    SWEP.ReloadTime = 2
    SWEP.ShootWait = 0.12
    SWEP.MagOut = "weapons/pistol/pistol_clipout.wav"
    SWEP.MagIn = "weapons/pistol/pistol_clipin.wav"
    SWEP.BoltOut = "weapons/pistol/pistol_sliderelease.wav"
    SWEP.MagOutWait = 0.2
    SWEP.MagInWait = 1.5
    SWEP.BoltOutWait = 2
    
    SWEP.Secondary.ClipSize		= -1
    SWEP.Secondary.DefaultClip	= -1
    SWEP.Secondary.Automatic	= false
    SWEP.CanManipulatorKuklovod = true
    SWEP.Secondary.Ammo			= "none"
    
    ------------------------------------------
    
    SWEP.Weight					= 5
    SWEP.AutoSwitchTo			= false
    SWEP.AutoSwitchFrom			= false
    
    SWEP.HoldType = "revolver"
    
    ------------------------------------------
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1
    SWEP.DrawAmmo				= true
    SWEP.DrawCrosshair			= false
    SWEP.MuzzleFXPos = Vector(0,0,0)
    if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/smoke' )
    SWEP.BounceWeaponIcon = false
    end
    
    SWEP.ViewModel				= "models/weapons/w_pistol.mdl"
    SWEP.WorldModel				= "models/weapons/w_pistol.mdl"
    SWEP.OtherModel = "models/sirgibs/hl2/weapons/9mmpistol.mdl"
    
    SWEP.vbwPos = Vector(0,0,0)
    SWEP.addPos = Vector(0,0,1)
    SWEP.addAng = Angle(4.7,-1.7,0)
    SWEP.AimPosition = Vector(3.85,10,1.45)
    SWEP.AimAngle = Angle(0,0,0)
    
    SWEP.dwmModeScale = 1 -- pos
    SWEP.dwmForward = 3
    SWEP.dwmRight = 1.6
    SWEP.dwmUp = 0.2
    
    SWEP.dwmAUp = 0 -- ang
    SWEP.dwmARight = 0
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
    
        local slideBone = model:LookupBone("SlideCharger")
        if not slideBone then return end
        for i = 1, 150 do
            timer.Simple(0.0002 * i,function ()
                local slideOffset = LerpVector( 2, Vector(0,0,0),Vector(0,0,-i / 100) )
                model:ManipulateBonePosition(slideBone, slideOffset)   
            end)
        end
    end

    function SWEP:ManipulateSlideBoneBac()
        if not IsValid(model) then return end
    
        local slideBone = model:LookupBone("SlideCharger")
        if not slideBone then return end
    
        for i = 0, 150 do
            timer.Simple(0.0002 * i,function ()
                local slideOffset = LerpVector( 2, Vector(0,0,0),Vector(0,0,-1.5 + i / 100))
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
end
    