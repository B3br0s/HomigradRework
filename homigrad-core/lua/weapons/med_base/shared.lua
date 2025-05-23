SWEP.Base = "weapon_base"
SWEP.PrintName = "База Медицины"
SWEP.Category = "Медицина"
SWEP.Spawnable = true

SWEP.WorldModel = "models/w_models/weapons/w_eq_medkit.mdl"

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true

SWEP.Rarity = 2

SWEP.IconPos = Vector(50,0,0)
SWEP.IconAng = Angle(0,0,0)
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

SWEP.HoldType = "slam"
SWEP.LastUse = 0
SWEP.Uses = 0
SWEP.Regens = 12
SWEP.ParticleColor = Color(221,107,0)
SWEP.ParticleMat = Material("particle/particle_noisesphere")

SWEP.HealSound = "zcity/healing/bandage_loop_1.wav"
SWEP.HealSoundEnd = "zcity/healing/bandage_end_0.wav"

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
    hg.DrawWeaponSelection(self,x,y,wide,tall,alpha)
end

function SWEP:Step_Anim()
    local ply = self:GetOwner()

    if self:IsAttacking(ply) then
        hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(30,-20,-15),1,0.125)
        hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(-15,-20,0),1,0.125)
        hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(0,0,0),1,0.125)
    elseif self:IsSAttacking(ply) then
        hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-40,0),1,0.075)
        hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(10,25,0),1,0.125)
        hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(0,0,10),1,0.075)   
    else
        hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-40,0),1,0.075)
        hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(20,-10,0),1,0.075)
        hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(0,0,10),1,0.075)   
        self.LastUse = CurTime() + 0.5
    end
end

function SWEP:IsAttacking(ply)
    if SERVER then
        self:SetNWBool("in_attack",ply:KeyDown(IN_ATTACK))
        return ply:KeyDown(IN_ATTACK)
    else
        return self:GetNWBool("in_attack")
    end
end

function SWEP:IsSAttacking(ply)
    if SERVER then
        self:SetNWBool("in_sattack",ply:KeyDown(IN_ATTACK2))
        return ply:KeyDown(IN_ATTACK2)
    else
        return self:GetNWBool("in_sattack")
    end
end

function SWEP:Heal(ply)
    if !ply then
        ply = self:GetOwner()
    end
    if SERVER then
        ply:SetHealth(math.Clamp(ply:Health() + 5,0,ply:GetMaxHealth()))
    end
end

function SWEP:Step()
    local ply = self:GetOwner()

    if !IsValid(ply) then
        return
    end

    if ply:GetActiveWeapon() != self then
        return
    end

    self:Step_Anim()

    if self:IsAttacking(ply) then
        if self.LastUse < CurTime() then
            self.LastUse = CurTime() + 1
            self:Heal()
            self.Uses = self.Uses - 1
            if CLIENT and ply == LocalPlayer() then
                ViewPunch(Angle(-5,0,-5))
            end
            if SERVER and self.Uses <= 0 then
                sound.Play(self.HealSoundEnd,self:GetPos(),75,100,1)
                self:Remove()
            elseif SERVER then
                sound.Play(self.HealSound,self:GetPos(),75,100,1)
            end
        end
    end

    if self:IsSAttacking(ply) then
        if self.LastUse < CurTime() then
            self.LastUse = CurTime() + 1
            local tr = hg.eyeTrace(ply,50)
            if !IsValid(tr.Entity) or IsValid(tr.Entity) and !tr.Entity:IsPlayer() and !tr.Entity:IsRagdoll() then
                return
            end
            if tr.Entity:IsRagdoll() then
                local ply_rag = hg.RagdollOwner(tr.Entity)
                if IsValid(ply_rag) then
                    self.Uses = self.Uses - 1
                    self:Heal(ply_rag)
                end

                if CLIENT and ply == LocalPlayer() then
                    ViewPunch(Angle(-5,0,-5))
                end
                if SERVER and self.Uses <= 0 then
                    sound.Play(self.HealSoundEnd,self:GetPos(),75,100,1)
                    self:Remove()
                elseif SERVER then
                    sound.Play(self.HealSound,self:GetPos(),75,100,1)
                end
            else
                if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
                    self.Uses = self.Uses - 1
                    self:Heal(tr.Entity)
                end

                if CLIENT and ply == LocalPlayer() then
                    ViewPunch(Angle(-5,0,-5))
                end
                if SERVER and self.Uses <= 0 then
                    sound.Play(self.HealSoundEnd,self:GetPos(),75,100,1)
                    self:Remove()
                elseif SERVER then
                    sound.Play(self.HealSound,self:GetPos(),75,100,1)
                end
            end
        end 
    end
end

function SWEP:Initialize()
    hg.Weapons[self] = true
    self:SetHoldType(self.HoldType)

    self.Uses = math.random(3,4)
end

function SWEP:Deploy()
    self:SetHoldType(self.HoldType)
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

function SWEP:DrawHUD()
    local tr = hg.eyeTrace(self:GetOwner(),50)

    local pos = tr.HitPos:ToScreen()

    if IsValid(tr.Entity) and (tr.Entity:IsRagdoll() or tr.Entity:IsPlayer()) then
        draw.SimpleText(string.format(hg.GetPhrase("heal"),(tr.Entity:IsPlayer() and tr.Entity:Name() or tr.Entity:GetNWString("PlayerName","N/A"))),"H.18",pos.x,pos.y,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end