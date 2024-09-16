--[[SWEP.Base = "weapon_base"

SWEP.PrintName = "База Гаранаты"
SWEP.Author = "sadsalat"
SWEP.Purpose = "Бах Бам Бум, Бадабум!"

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.Spawnable = false

SWEP.ViewModel = "models/pwb/weapons/w_f1.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_f1.mdl"

SWEP.Granade = ""

SWEP.Primary.ClipSize		= -1
SWEP.LeverProebal = false
SWEP.Primary.DefaultClip	= -1
SWEP.PinOut = false
SWEP.RequiresPin = false
SWEP.a = 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.SpoonEnt = "ent_jack_spoon"
SWEP:SetNWBool("Leveractivatedon",false)

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

function SWEP:SpoonEffect()
    if self.SpoonEnt then
        local Spewn = ents.Create(self.SpoonEnt)

        if self.SpoonModel then
            Spewn.Model = self.SpoonModel
        end

        if self.SpoonScale then
            Spewn.ModelScale = self.SpoonScale
        end

        if self.SpoonSound then
            Spewn.Sound = self.SpoonSound
        end

        Spewn:SetPos(self:GetPos())
        Spewn:Spawn()
        Spewn:GetPhysicsObject():SetVelocity(VectorRand() * 250)
        self:EmitSound("snd_jack_spoonfling.wav", 60, math.random(90, 110))
    end
end

function TrownGranade(ply,force,granade)
    local granade = ents.Create(granade)
    granade:SetPos(ply:GetShootPos() +ply:GetAimVector()*10)
	granade:SetAngles(ply:EyeAngles()+Angle(45,45,0))
	granade:SetOwner(ply)
	granade:SetPhysicsAttacker(ply)
    granade:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	granade:Spawn()       
	granade:Arm()
	local phys = granade:GetPhysicsObject()              
	if not IsValid(phys) then granade:Remove() return end                         
	phys:SetVelocity(ply:GetVelocity() + ply:GetAimVector() * force)
	phys:AddAngleVelocity(VectorRand() * force/2)
end

function SWEP:Deploy()
    self:SetHoldType( "normal" )
end

function SWEP:Initialize()
    self:SetHoldType( "normal" )
end

function SWEP:PrimaryAttack()
    if SERVER then    
        if self.RequiresPin then
        if not self.PinOut then
        self.PinOut = true
        self:SetNWBool("PinOut",true)
        self:EmitSound("weapons/tfa_csgo/flashbang/pinpull.wav")
        self:SetHoldType( "melee" )
        timer.Simple(0.2,function ()
            self.PinDone = true
        end)
        else
        if not self.Leveractivatedonce then
        TrownGranade(self:GetOwner(),750,self.Granade)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")
        end
        end
    else
        TrownGranade(self:GetOwner(),750,self.Granade)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")   
    end
    elseif CLIENT then
    end
    if self.PinOut and self.PinDone then
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
        self:EmitSound("weapons/tfa_csgo/flashbang/grenade_throw.wav")
    end
    if not self:GetNWBool("PinOut") then
        self:EmitSound("weapons/tfa_csgo/flashbang/pinpull.wav")
    end
end

function SWEP:Reload()
    if SERVER then
    if not self.PinOut then
        if self.LeverProebal and not self.Leveractivatedonce then
            self.LeverProebal = true
            self.Leveractivatedonce = true
            self:SetNWBool("Leveractivated",true)
            timer.Simple(0.1,function ()
                self:SetNWBool("Leveractivatedon",true)
            end)
            self:SpoonEffect()
            timer.Simple(3,function ()
            local SelfPos = self:GetPos()
		    JMod.Sploom(self:GetOwner() or game.GetWorld(), SelfPos, 1700)
		    self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 100)
            end)
        elseif not self.Leveractivatedonce then
            self.LeverProebal = true
        end   
    end
if self:GetNWBool("Leveractivated") and self.a == 1 then
    self.a = 2
    self:EmitSound("snd_jack_spoonfling.wav", 60, math.random(90, 110))
end   
end
end

function SWEP:SecondaryAttack()
    if SERVER then    
        if self.RequiresPin then
        if self.PinOut then
        TrownGranade(self:GetOwner(),250,self.Granade)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")
        end
    end
    end
    if self.PinOut and self.PinDone then
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
        self:EmitSound("weapons/tfa_csgo/flashbang/grenade_throw.wav")
    end
end]]
SWEP.Base = "weapon_base"

SWEP.PrintName = "База Гаранаты"
SWEP.Author = "sadsalat"
SWEP.Purpose = "Бах Бам Бум, Бадабум!"

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.Spawnable = false

SWEP.ViewModel = "models/pwb/weapons/w_f1.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_f1.mdl"

SWEP.Granade = ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

function TrownGranade(ply,force,granade)
    local granade = ents.Create(granade)
    granade:SetPos(ply:GetShootPos() +ply:GetAimVector()*10)
	granade:SetAngles(ply:EyeAngles()+Angle(45,45,0))
	granade:SetOwner(ply)
	granade:SetPhysicsAttacker(ply)
    granade:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	granade:Spawn()       
	granade:Arm()
	local phys = granade:GetPhysicsObject()              
	if not IsValid(phys) then granade:Remove() return end                         
	phys:SetVelocity(ply:GetVelocity() + ply:GetAimVector() * force)
	phys:AddAngleVelocity(VectorRand() * force/2)
end

function SWEP:Deploy()
    self:SetHoldType( "melee" )
end

function SWEP:Initialize()
    self:SetHoldType( "melee" )
end

function SWEP:PrimaryAttack()
    if SERVER then    
        TrownGranade(self:GetOwner(),750,self.Granade)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")
    elseif CLIENT then
    end
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/m67/handling/m67_throw_01.wav")
end

function SWEP:SecondaryAttack()
    if SERVER then
        TrownGranade(self:GetOwner(),250,self.Granade)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")
    elseif CLIENT then
    end
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/m67/handling/m67_throw_01.wav")
end