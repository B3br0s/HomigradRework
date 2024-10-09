 if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "M4A1"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Автоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "Оружие"


SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.IconkaInv = "vgui/weapon_csgo_m4a1.png"

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "arccw_go/m4a1/m4a1_01.wav"
SWEP.Primary.SoundFar = "m4a1/m4a1_dist.wav"
SWEP.Primary.Force = 160/3
SWEP.ReloadTime = 2
SWEP.MagModel = "models/csgo/weapons/w_rif_m4a1_mag.mdl"
SWEP.ShootWait = 0.07
SWEP.ReloadSound = ""
SWEP.TwoHands = true
SWEP.MagOut = "arccw_go/m4a1/m4a1_clipout.wav"
SWEP.MagIn = "arccw_go/m4a1/m4a1_clipin.wav"
SWEP.BoltOut = "zcitysnd/sound/weapons/m4a1/handling/m4a1_boltrelease.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.9
SWEP.BoltOutWait = 1.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.RecoilNumber = 0.4
SWEP.Secondary.Ammo			= "none"
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/smoke' )
SWEP.BounceWeaponIcon = false
end
------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

SWEP.addAng = Angle(11.5,1.1,0)
SWEP.addPos = Vector(0,0,0)

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb2/weapons/w_m4a1.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_m4a1.mdl"
SWEP.OtherModel				= "models/weapons/arccw_go/v_rif_m4a1.mdl"

SWEP.vbwPos = Vector(-2,-3.7,2)
SWEP.vbwAng = Angle(5,-30,0)

SWEP.OffsetVec = Vector(10,-2.6,2)

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(self.RecoilNumber,math.Rand(self.RecoilNumber*-1,self.RecoilNumber),0)
    self.Primary.Sound = ("arccw_go/m4a1/m4a1_0"..math.random(1,3)..".wav")
end

SWEP.dwmModeScale = 1 -- pos
SWEP.dwmForward = -10
SWEP.dwmRight = 5.8
SWEP.dwmUp = -8

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

        model:SetBodygroup(0, 0)
    else
            self:SetModel(self.WorldModel)
            self:DrawModel()
end
end
end