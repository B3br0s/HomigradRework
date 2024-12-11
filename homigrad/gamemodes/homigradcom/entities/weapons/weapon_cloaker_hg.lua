SWEP.PrintName = "Клокер"
SWEP.Author = "Homigrad"
SWEP.Instructions = "ЛКМ - Включить режим КЛОКЕРА"
SWEP.Category = "Разное"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true  
SWEP.AdminOnly = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.UseHands = true
SWEP.HoldType = "normal"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false

SWEP.ChargeSound = "cloaker/CloakerLoopNVG.wav"
SWEP.HitSound = "cloaker/CloakerEndNVG.wav"
SWEP.TurnOnSound = "nvg/nvg_on1.wav"
SWEP.TurnOffSound = "nvg/nvg_off1.wav"

local owner

local prevjump

local prevhealth

SWEP.HitDistance = 75

function SWEP:Initialize() 
    self:SetHoldType("normal")
end

function SWEP:Deploy() 
    self:SetHoldType("normal")
end

function SWEP:PrimaryAttack() 
    if CLIENT then return end
    owner = self:GetOwner()

    if not self:GetOwner().Charged then
        self:GetOwner().Charged = true

        prevhealth = owner:Health()
        prevjump = owner:GetJumpPower()

        owner:EmitSound(self.TurnOnSound)

        owner:SetSkin(1)

        if owner:GetModel() == "models/payday2/units/splinter_cell_cloaker_player.mdl" then
            owner:SetBodygroup(0,1)
            owner:SetBodygroup(1,0)
        end

        if owner.IsCloaker then
        owner:EmitSound(self.ChargeSound)
        end

        owner:SetHealth(200)
        owner:SetJumpPower(prevjump + 50)

        self:SetNextPrimaryFire(CurTime() + 20)
    end
end

function SWEP:SecondaryAttack()
    if CLIENT then return end
    owner = self:GetOwner()

    if self:GetOwner().Charged then
        self:GetOwner().Charged = false

        owner:StopSound(self.ChargeSound)

        if owner.IsCloaker then
        owner:EmitSound(self.HitSound)
        end

        owner:EmitSound(self.TurnOffSound)

        owner:SetSkin(0)

        owner:SetHealth(prevhealth)
        owner:SetJumpPower(prevjump)

        self:SetNextPrimaryFire(CurTime() + 20)
    end
end

function SWEP:Think()
    if CLIENT then return end
    if IsValid(owner) and not owner:Alive() and not owner.fake and not owner.otrub then owner:StopSound(self.ChargeSound) owner.Charged = false return end
    if not self:GetOwner().Charged then return end
    local tr = util.TraceHull({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
        filter = owner,
        mins = Vector(-10, -10, -40),
        maxs = Vector(10, 10, 40),
        mask = MASK_SHOT_HULL
    })

    local hitEntity = tr.Entity

    if IsValid(hitEntity) and hitEntity:IsPlayer() then

        self:GetOwner().Charged = false

        local startAngle = Angle(0, 0, 0)
            local endAngle = Angle(0, 0, -90)
            local duration = 0.3
            local ratio = 0
            local bone = owner:LookupBone("ValveBiped.Bip01_Pelvis")
        
            if bone then
                timer.Create("BoneLerpTimer", 0.01, duration * 100, function()
                    ratio = math.Clamp(ratio + 0.1, 0, 1)
                    local lerpedAngle = LerpAngle(ratio, startAngle, endAngle)
                    owner:ManipulateBoneAngles(bone, lerpedAngle)
        
                    if ratio >= 1 then
                        timer.Remove("BoneLerpTimer")
                    end
                end)
            end

        hitEntity:TakeDamage(15)

        Faking(hitEntity)
        owner:SetHealth(prevhealth)
        owner:SetJumpPower(prevjump)

        owner:EmitSound(self.TurnOffSound)

        owner:SetSkin(0)

        if owner.IsCloaker then
        owner:EmitSound(self.HitSound)

        owner:StopSound(self.ChargeSound)
        end

        timer.Simple(0.8, function()
            if owner.IsCloaker then
            owner:EmitSound("cloaker/taunt" .. math.random(1, 8) .. ".wav")
            end
            
            local startAngle = Angle(0, 0, -90)
            local endAngle = Angle(0, 0, 0)
            local duration = 0.3
            local ratio = 0
            local bone = owner:LookupBone("ValveBiped.Bip01_Pelvis")
        
            if bone then
                timer.Create("BoneLerpTimer", 0.01, duration * 100, function()
                    ratio = math.Clamp(ratio + 0.1, 0, 1)
                    local lerpedAngle = LerpAngle(ratio, startAngle, endAngle)
                    owner:ManipulateBoneAngles(bone, lerpedAngle)
        
                    if ratio >= 1 then
                        timer.Remove("BoneLerpTimer")
                    end
                end)
            end
        end)
        
        

        owner:Freeze(true)
        owner:GodEnable()

        if owner.IsCloaker then
        hitEntity:ChatPrint("На тебя напал клокер.")
        end

        hitEntity.Paralizovan = true
        
        local ragdoll = hitEntity:GetNWEntity("Ragdoll")

        ragdoll:EmitSound("physics/body/body_medium_impact_soft"..math.random(1,7)..".wav")

        ragdoll:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
        ragdoll:EmitSound("physics/flesh/flesh_strider_impact_bullet2.wav")
        ragdoll:EmitSound("physics/flesh/flesh_strider_impact_bullet2.wav")
        ragdoll:EmitSound("physics/flesh/flesh_strider_impact_bullet3.wav")
        ragdoll:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")

        timer.Simple(2,function ()
            owner:GodDisable()
            owner:Freeze(false)
        end)

        timer.Simple(7,function ()
            hitEntity.Paralizovan = false
        end)
                
        local numPhysObjs = ragdoll:GetPhysicsObjectCount()

        for i = 1, 50 do
            timer.Simple(0.01 * i, function()
                for physIndex = 0, numPhysObjs - 1 do
                    local physObj = ragdoll:GetPhysicsObjectNum(physIndex)
                    if IsValid(physObj) then
                        physObj:ApplyForceCenter(owner:GetAimVector() * 80)
                    end
                end
            end)
        end
    end
end
