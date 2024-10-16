if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'b3bros_base' -- base

SWEP.PrintName 				= "HK USP-S"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Пистолет под калибр 9х19"
SWEP.Category 				= "Оружие"
SWEP.IconkaInv = "vgui/weapon_csgo_usp_silencer.png"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "arccw_go/usp/usp2.wav"
SWEP.Primary.Force = 70/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.14
SWEP.Efect = "PhyscannonImpact"
if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/smoke' )
SWEP.BounceWeaponIcon = false
end
SWEP.MagModel = "models/csgo/weapons/w_pist_223_mag.mdl"
SWEP.MagOut = "zcitysnd/sound/weapons/m45/handling/m45_magout.wav"
SWEP.MagIn = "zcitysnd/sound/weapons/m45/handling/m45_maghit.wav"
SWEP.BoltIn = "zcitysnd/sound/weapons/m45/handling/m45_boltrelease.wav"
SWEP.MagOutWait = 0.2
SWEP.MagInWait = 1.5
SWEP.BoltInWait = 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
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

SWEP.ViewModel				= "models/weapons/v_bean_beansmusp.mdl"
SWEP.WorldModel				= "models/weapons/w_bean_beansmusp.mdl"

SWEP.vbwPos = Vector(7.5,0.1,-6)

SWEP.Supressed = true

SWEP.dwmModeScale = 1
SWEP.dwmForward = 0
SWEP.dwmRight = 1
SWEP.dwmUp = 0

SWEP.dwmAUp = 4
SWEP.dwmARight = -5.5
SWEP.dwmAForward = -90

SWEP.addAng = Angle(1.1,1.3,0)
SWEP.addPos = Vector(0,4,-0.7)

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
end
end
--[[if engine.ActiveGamemode() == "homigrad" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "HK USP-S"
    SWEP.Author 				= "Homigrad"
    SWEP.Instructions			= "Пистолет под калибр 9х19"
    SWEP.Category 				= "Оружие"
    SWEP.IconkaInv = "vgui/weapon_csgo_usp_silencer.png"
    
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    
    ------------------------------------------
    
    SWEP.Primary.ClipSize		= 12
    SWEP.Primary.DefaultClip	= 12
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "9х19 mm Parabellum"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.7 * 25
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = "arccw_go/usp/usp2.wav"
    SWEP.Primary.Force = 70/3
    SWEP.ReloadTime = 2
    SWEP.ShootWait = 0.14
    SWEP.Efect = "PhyscannonImpact"
    if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID( 'pwb/sprites/smoke' )
    SWEP.BounceWeaponIcon = false
    end
    SWEP.MagModel = "models/csgo/weapons/w_pist_223_mag.mdl"
    SWEP.MagOut = "zcitysnd/sound/weapons/m45/handling/m45_magout.wav"
    SWEP.MagIn = "zcitysnd/sound/weapons/m45/handling/m45_maghit.wav"
    SWEP.BoltIn = "zcitysnd/sound/weapons/m45/handling/m45_boltrelease.wav"
    SWEP.MagOutWait = 0.2
    SWEP.MagInWait = 1.5
    SWEP.BoltInWait = 2
    
    SWEP.Secondary.ClipSize		= -1
    SWEP.Secondary.DefaultClip	= -1
    SWEP.Secondary.Automatic	= false
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
    
    SWEP.ViewModel				= "models/weapons/v_bean_beansmusp.mdl"
    SWEP.WorldModel				= "models/weapons/w_bean_beansmusp.mdl"
    
    SWEP.vbwPos = Vector(7.5,0.1,-6)
    
    SWEP.Supressed = true
    
    SWEP.dwmModeScale = 1
    SWEP.dwmForward = 0
    SWEP.dwmRight = 1
    SWEP.dwmUp = 0
    
    SWEP.dwmAUp = 4
    SWEP.dwmARight = -5.5
    SWEP.dwmAForward = -90
    
    SWEP.addAng = Angle(1.1, 1.3, 0)
    SWEP.addPos = Vector(0, 4, -0.7)
    
    if CLIENT then
        function SWEP:SetPosAng(Pos,Ang)
            self.Pos = Pos
            self.Ang = Ang
        end
        function SWEP:GetPosAng()
            return self.Pos,self.Ang
        end
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
    end
    if CLIENT then
        function SWEP:Initialize()
            self:CreateClientsideModel()
        end
    
        function SWEP:CreateClientsideModel()
            -- Create a ClientsideModel for the SWEP
            if not IsValid(self.ClientModel) then
                self.ClientModel = ClientsideModel(self.WorldModel, RENDER_GROUP_OPAQUE_ENTITY)
                self.ClientModel:SetNoDraw(true) -- Ensure the model is drawn manually
            end
        end
    
        function SWEP:OnRemove()
            -- Clean up the model when the weapon is removed
            if IsValid(self.ClientModel) then
                self.ClientModel:Remove()
            end
        end
    
        function SWEP:DrawWorldModel()
            local owner = self:GetOwner()
    
            -- If there's no valid owner, draw the default model
            if not IsValid(owner) then
                self:DrawModel()
                return
            end
    
            -- Ensure the clientside model exists
            if not IsValid(self.ClientModel) then
                self:CreateClientsideModel()
            end
    
            -- Get the hand bone position and angle
            local boneIndex = owner:LookupBone("ValveBiped.Bip01_R_Hand")
            if not boneIndex then return end
    
            local Pos, Ang = owner:GetBonePosition(boneIndex)
            if not Pos or not Ang then return end
    
            -- Adjust position
            Pos:Add(Ang:Forward() * self.dwmForward)
            Pos:Add(Ang:Right() * self.dwmRight)
            Pos:Add(Ang:Up() * self.dwmUp)
    
            -- Adjust angles
            Ang:RotateAroundAxis(Ang:Up(), self.dwmAUp)
            Ang:RotateAroundAxis(Ang:Right(), self.dwmARight)
            Ang:RotateAroundAxis(Ang:Forward(), self.dwmAForward)

            self:SetPosAng(Pos,Ang)
    
            -- Set the position and angles for the clientside model
            self.ClientModel:SetPos(Pos)
            self.ClientModel:SetAngles(Ang)
    
            -- Set model scale and draw the model
            self.ClientModel:SetModelScale(self.dwmModeScale)
            self.ClientModel:DrawModel()
        end
    end
    
    end]]