SWEP.Base = "weapon_base"

SWEP.PrintName = "База Гранаты"
SWEP.Category = "Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.Spawnable = true

SWEP.ViewModel = "models/pwb/weapons/w_f1.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_f1.mdl"

SWEP.Granade = ""

SWEP.Rarity = 5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IconAng = Angle(-10,0,0)
SWEP.IconPos = Vector(40,-0.5,-0.5)

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
    hg.DrawWeaponSelection(self,x,y,wide,tall,alpha)
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
    self:SetHoldType( "slam" )
end

function SWEP:Initialize()
    self:SetHoldType( "slam" )

    hg.Weapons[self] = true
end

function SWEP:Step()
    local ply = self:GetOwner()

    if ply:GetActiveWeapon() != self then
        return
    end

    //ply:ConCommand("slot5")

	hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(0,0,30),1,0.1)
	hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(10,-10,20),1,0.1)
	hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(20,-50,0),1,0.1)
end

function SWEP:PrimaryAttack()
    self:SetHoldType( "melee" )
    if self.Thrown then
        return
    end
    self.Thrown = true
    sound.Play("weapons/pinpull.wav",self:GetPos())
    timer.Simple(0,function()
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    end)
    timer.Simple(0.18,function()
        if SERVER then    
            TrownGranade(self:GetOwner(),750,self.Granade)
            self:Remove()
        elseif CLIENT then
        end
        self:EmitSound("weapons/m67/handling/m67_throw_01.wav")
    end)
end

function SWEP:SecondaryAttack()
    if self.Thrown then
        return
    end
    self.Thrown = true
    if SERVER then
        TrownGranade(self:GetOwner(),250,self.Granade)
        self:Remove()
    elseif CLIENT then
    end
    self:EmitSound("weapons/m67/handling/m67_throw_01.wav")
end