SWEP.Base = "weapon_base"
SWEP.PrintName = "База TPIK Гранат"
SWEP.Category = "Гранаты"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/molotov/w_molotov.mdl"
SWEP.WorldModel = "models/weapons/molotov/w_molotov.mdl"
SWEP.WorldModelReal = "models/weapons/molotov/c_molotov.mdl"

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.SupportTPIK = true

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.Rarity = 2

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true

SWEP.IconPos = Vector(55,0,0)
SWEP.IconAng = Angle(0,180,0)
SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Animations = {
	["idle"] = {
        Source = "idle",
    },
	["draw"] = {
        Source = "draw",
        MinProgress = 0.5,
        Time = 1
    },
    ["reload"] = {
        Source = "reload",
        MinProgress = 0.5,
        Time = 2
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        MinProgress = 0.5,
        Time = 2.5
    }
}

SWEP.RHand = Vector(0,0,0)
SWEP.RHandAng = Angle(0,0,0)

SWEP.LHand = Vector(0,0,0)
SWEP.LHandAng = Angle(0,0,0)

SWEP.HoldType = "slam"

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
    hg.DrawWeaponSelection(self,x,y,wide,tall,alpha)
end

function SWEP:Step_Anim()
    local ply = self:GetOwner()
end

function SWEP:Initialize()
    hg.Weapons[self] = true
    self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
    self:SetHoldType(self.HoldType)

    hg.PlayAnim(self,"draw")
end

function SWEP:Holster()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
    end
    return true
end

function SWEP:OnRemove()
    if IsValid(self.worldModel) then
        DropProp(self.WorldModel,1,self.worldModel:GetPos(),self.worldModel:GetAngles(),Vector(0,0,0) - self.worldModel:GetAngles():Up() * 150,VectorRand(-250,250))
        self.worldModel:Remove()
    end
end

function SWEP:OwnerChanged()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
    end
end

//govno
function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:GetWM()
    return self.worldModel or self
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 1, "SequenceIndex")
	self:NetworkVar("Float", 2, "SequenceProxy")
	self:NetworkVar("Float", 3, "IKTimeLineStart")
    self:NetworkVar("Float", 4, "IKTime")
    self:NetworkVar("Float", 5, "SequenceSpeed")
    self:NetworkVar("Float", 6, "ProcessedValue")
    self:NetworkVar("Float", 7, "AttackTime")
    self:NetworkVar("Bool", 0, "Attack")

	self:NetworkVar("String", 0, "IKAnimation")
end