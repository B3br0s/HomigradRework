if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "Remington 870"
SWEP.Author 				= "Homigrad"
SWEP.Category 				= "Оружие"
SWEP.IconkaInv = "vgui/weapon_csgo_sawedoff.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
SWEP.CanShoot = true
SWEP.Primary.Automatic		= false
SWEP.CanManipulatorKuklovod = true
SWEP.Primary.Ammo			= "12/70 gauge"
SWEP.Primary.Cone = 0.05
SWEP.Primary.Damage = 1.7 * 45
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/toz_shotgun/toz_tp.wav"
SWEP.Primary.SoundSupresor = "zcitysnd/sound/weapons/toz_shotgun/toz_suppressed_fp.wav"
SWEP.Primary.PumpSound = "csgo/weapons/sawedoff/sawedoff_pump.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_sht_far.wav"
SWEP.LoadSound = "csgo/weapons/sawedoff/sawedoff_insertshell_01"
SWEP.Primary.Force = 15
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.8
SWEP.RecoilNumber = 4
SWEP.NumBullet = 8
SWEP.Sight = true
SWEP.TwoHands = true
SWEP.shotgun = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'csgo/econ/weapons/base_weapons/weapon_sawedoff' )
SWEP.BounceWeaponIcon = false
end
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

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

SWEP.OtherModel				= "models/weapons/arccw_go/v_shot_870.mdl"
SWEP.ViewModel				= "models/bydistac/weapons/w_shot_m3juper90.mdl"
SWEP.WorldModel				= "models/bydistac/weapons/w_shot_m3juper90.mdl"

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(self.RecoilNumber,math.Rand(-2,2),0)
end

SWEP.vbwPos = Vector(-9,-5,-5)

SWEP.CLR_Scope = 0.05
SWEP.CLR = 0.025

SWEP.addAng = Angle(-4,-0.3,0)
SWEP.addPos = Vector(0,0,0)

SWEP.MuzzleFXPos = Vector(0,0,0)

SWEP.dwmModeScale = 1 -- pos
    SWEP.dwmForward = -13
    SWEP.dwmRight = 4.4
    SWEP.dwmUp = -1.5
    
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
    
        local slideBone = model:LookupBone("v_weapon.sawedoff_pump")
        if not slideBone then return end
        for i = 1, 450 do
            timer.Simple(0.0002 * i,function ()
                local slideOffset = LerpVector( 2, Vector(0,0,0),Vector(0,0,-i / 350) )
                model:ManipulateBonePosition(slideBone, slideOffset)
            end)
        end
    end

    function SWEP:ManipulateSlideBoneBac()
        if not IsValid(model) then return end
    
        local slideBone = model:LookupBone("v_weapon.sawedoff_pump")
        if not slideBone then return end
    
        for i = 0, 450 do
            timer.Simple(0.0002 * i,function ()
                local slideOffset = LerpVector( 2, Vector(0,0,0),Vector(0,0,-1 + i / 350))
                model:ManipulateBonePosition(slideBone, slideOffset)
            end)
        end
    end

    function PumpAnimForHandsFor()
        print("a")
    end

    function PumpAnimForHandsBac()
        print("b")
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