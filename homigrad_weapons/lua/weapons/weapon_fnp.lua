if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "Tec-9"
    SWEP.Author 				= "Homigrad"
    SWEP.Category 				= "Оружие"
    SWEP.WepSelectIcon			= "pwb/sprites/glock17"
    SWEP.MagModel = "models/weapons/arc9/darsu_eft/mods/mag_glock_std_17.mdl"
    SWEP.IconkaInv = "vgui/weapon_csgo_tec9.png"
    
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    
    ------------------------------------------
    
    SWEP.Primary.ClipSize		= 19
    SWEP.Primary.DefaultClip	= 19
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.7 * 130
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = "arccw_go/tec9/tec9-1.wav"
    SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
    SWEP.Primary.Force = 90/3
    SWEP.ReloadSound = ""
    SWEP.ReloadTime = 2
    SWEP.ShootWait = 0.09
    SWEP.MagOut = "arccw_go/tec9/tec9_clipout.wav"
    SWEP.MagIn = "arccw_go/tec9/tec9_clipin.wav"
    SWEP.BoltIn = "arccw_go/tec9/tec9_boltpull.wav"
    SWEP.BoltOut = "arccw_go/tec9/tec9_boltrelease.wav"
    SWEP.MagOutWait = 0.2
    SWEP.MagInWait = 1
    SWEP.BoltInWait = 1.2
    SWEP.BoltOutWait = 1.4
    SWEP.Instructions			= "Пистолет с охуенной бронебойностью под калибр .50 Action Express"
    
    
    SWEP.Secondary.ClipSize		= -1
    SWEP.Secondary.DefaultClip	= -1
    SWEP.Secondary.Automatic	= false
    SWEP.Secondary.Ammo			= "none"
    
    ------------------------------------------
    
    SWEP.Weight					= 5
    SWEP.AutoSwitchTo			= false
    SWEP.AutoSwitchFrom			= false
    
    SWEP.HoldType = "ar2"
    
    ------------------------------------------
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 1
    SWEP.DrawAmmo				= true
    SWEP.DrawCrosshair			= false
    
    SWEP.ViewModel				= "models/csgo/weapons/w_pist_tec9.mdl"
    SWEP.WorldModel				= "models/csgo/weapons/w_pist_tec9.mdl"
    SWEP.OtherModel				= "models/weapons/arccw_go/v_pist_tec9.mdl"
    
    
    SWEP.addPos = Vector(0,0,-0.9)
    SWEP.addAng = Angle(-5,-0.6,0)
    if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/smoke' )
    SWEP.BounceWeaponIcon = false
    end

    function SWEP:ApplyEyeSpray()
        self.eyeSpray = Angle(-0.5,math.Rand(-0.1,0.1),0)
    end
    
    SWEP.MuzzleFXPos = Vector(0,1,0)
    SWEP.vbwPos = Vector(7,-10,-6)

    SWEP.dwmModeScale = 1 -- pos
    SWEP.dwmForward = -13
    SWEP.dwmRight = 6.3
    SWEP.dwmUp = -2.3
    
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