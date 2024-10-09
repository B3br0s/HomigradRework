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
SWEP.Primary.Damage = 1.7 * 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/firearms/rifle_win1892/win1892_fire_01.wav"
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
end