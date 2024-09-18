if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Five-Seven"
    SWEP.Author 				= "Homigrad"
    SWEP.Instructions			= "Бронебойный пистолет. Пробьёт даже дыру в твоей жопе."
    SWEP.Category 				= "Оружие"
    SWEP.WepSelectIcon			= "entities/weapon_insurgencymakarov.png"
    
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    
    ------------------------------------------
    
    SWEP.Primary.ClipSize		= 20
    SWEP.Primary.DefaultClip	= 20
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "5.7×28 mm"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.7 * 20
    SWEP.RubberBullets = false
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = "csgo/weapons/fiveseven/fiveseven_01.wav"
    SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
    SWEP.Primary.Force = 0.1
    SWEP.ReloadTime = 2
    SWEP.ShootWait = 0.12
    SWEP.MagOut = "zcitysnd/sound/weapons/m9/handling/m9_magout.wav"
    SWEP.MagIn = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav"
    SWEP.BoltOut = "zcitysnd/sound/weapons/m1911/handling/m1911_boltrelease.wav"
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
    SWEP.MuzzleFXPos = Vector(10,0,-2)
    
    SWEP.ViewModel				= "models/weapons/arccw_go/v_pist_fiveseven.mdl"
    SWEP.WorldModel				= "models/weapons/arccw_go/v_pist_fiveseven.mdl"
    SWEP.OtherModel = "models/csgo/weapons/w_pist_fiveseven.mdl"
    
    SWEP.vbwPos = Vector(0,0,0)
    SWEP.addPos = Vector(13,-3.5,0)
    SWEP.addAng = Angle(1,0,0)
    SWEP.AimPosition = Vector(3.85,10,1.45)
    SWEP.AimAngle = Angle(0,0,0)
    
    SWEP.dwmModeScale = 1 -- pos
    SWEP.dwmForward = -13
    SWEP.dwmRight = 4.4
    SWEP.dwmUp = -0.78
    
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
    
        local slideBone = model:LookupBone("v_weapon.fiveSeven_slide")
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
    
        local slideBone = model:LookupBone("v_weapon.fiveSeven_slide")
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
            model:SetModel(self.WorldModel)
        

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
            self:SetModel(self.OtherModel)
            self:DrawModel()
end
end
end
    