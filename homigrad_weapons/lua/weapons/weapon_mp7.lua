if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base 

SWEP.PrintName 				= "MP7"
SWEP.Instructions			= "Пистолет-пулемёт под калибр 4,6×30"
SWEP.Category 				= "Оружие"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.IconkaInv = "vgui/weapon_csgo_mp7.png"

------------------------------------------

SWEP.Primary.ClipSize		= 40
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "4.6×30 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 30
SWEP.Primary.Spread = 0
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/mp7' )
SWEP.BounceWeaponIcon = false
end
SWEP.Primary.Sound = "arccw_go/mp7/mp7_01.wav"
SWEP.Primary.SoundFar = "mp5k/mp5k_dist.wav"
SWEP.Primary.Force = 120/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.06
SWEP.MagOut = "arccw_go/mp7/mp7_clipout.wav"
SWEP.MagIn = "arccw_go/mp7/mp7_clipin.wav"
SWEP.BoltOut = "arccw_go/mp7/mp7_slideback.wav"
SWEP.BoltIn = "arccw_go/mp7/mp7_slideforward.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 0.9
SWEP.BoltOutWait = 1.2
SWEP.BoltInWait = 1.4
SWEP.ReloadSound = ""--"weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

							
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
SWEP.MagModel = "models/csgo/weapons/w_pist_tec9_mag.mdl"
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb2/weapons/w_mp7.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_mp7.mdl"
SWEP.OtherModel				= "models/weapons/arccw_go/v_smg_mp7.mdl"

SWEP.vbwPos = Vector(-2,-3.7,1)
SWEP.vbwAng = Angle(5,-30,0)

SWEP.addPos = Vector(0,0,-1)
SWEP.addAng = Angle(-4.5,-0.6,0)
SWEP.MuzzleFXPos = Vector(5,0,0)
    
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

    SWEP.dwmModeScale = 1 -- pos
    SWEP.dwmForward = -13
    SWEP.dwmRight = 6.15
    SWEP.dwmUp = -2.8
    
    SWEP.dwmAUp = 0 -- ang
    SWEP.dwmARight = -15
    SWEP.dwmAForward = 180
    
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