if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "MP7-CMB"
SWEP.Instructions			= "Настоящий гэнгста носит только УЗИ!"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.IconkaInv = "vgui/pineapple.png"

------------------------------------------

SWEP.Primary.ClipSize		= 45
SWEP.Primary.DefaultClip	= 45
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "4.6×30 mm"
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/uzi' )
SWEP.BounceWeaponIcon = false
end
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 30
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/smg1/smg1_fire1.wav"
SWEP.Primary.SoundFar = "weapons/ump45/ump45_dist.wav"
SWEP.Primary.Force = 85/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.08
SWEP.TwoHands = true
SWEP.MagOut = "weapons/smg1/smg1_clipout.wav"
SWEP.MagIn = "weapons/smg1/smg1_clipin.wav"
SWEP.BoltIn = "weapons/smg1/smg1_boltforward.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.85
SWEP.BoltInWait = 1.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "smg"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.Model = nil
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/w_smg1.mdl"
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"
SWEP.OtherModel				= "models/sirgibs/hl2/weapons/smg1.mdl"

SWEP.vbwPos = Vector(-2,-4,-4)
SWEP.addAng = Angle(4.5,-0.3,0)
SWEP.addPos = Vector(0,0,0)
SWEP.MuzzleFXPos = Vector(0,-2,0)

SWEP.OtherModelBodygroups = {
    [3] = 1
}

function SWEP:ApplyEyeSpray()
    self.Primary.Sound = ("weapons/smg1/smg1_fire"..math.random(1,3)..".wav")
    self.eyeSpray = self.eyeSpray - Angle(0.2,math.Rand(-0.1,0.1),0)
end

SWEP.dwmModeScale = 1 -- pos
SWEP.dwmForward = 5
SWEP.dwmRight = 1
SWEP.dwmUp = -0.3

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
        
        self.Model = model

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