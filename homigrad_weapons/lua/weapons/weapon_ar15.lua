if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "AR-15"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Полуавтоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "pwb2/vgui/weapons/m4a1"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/galil/galil_fp.wav"
SWEP.Primary.SoundFar = "m4a1/m4a1_dist.wav"
SWEP.Primary.Force = 160/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.08
SWEP.ReloadSound = ""
SWEP.TwoHands = true
SWEP.MagOut = "zcitysnd/sound/weapons/m4a1/handling/m4a1_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/m4a1/handling/m4a1_magin.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/m4a1/handling/m4a1_boltrelease.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.9
SWEP.BoltOutWait = 1.2

SWEP.Secondary.ClipSize		= -1
SWEP.MagModel = "models/csgo/weapons/w_rif_m4a1_mag.mdl"
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.SubMaterial = {
    [1] = "null"
}
------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.OtherModel				= "models/pwb2/weapons/w_m4a1.mdl"
SWEP.ViewModel				= "models/weapons/arccw_go/v_rif_car15.mdl"
SWEP.WorldModel				= "models/weapons/arccw_go/v_rif_car15.mdl"

SWEP.addAng = Angle(0,0,0)
SWEP.addPos = Vector(20,-4.9,-1.5)

SWEP.MuzzleFXPos = Vector(20,-1,-3)
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
    
        local slideBone = model:LookupBone("v_weapon.AK47_bolt")
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
    
        local slideBone = model:LookupBone("v_weapon.AK47_bolt")
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