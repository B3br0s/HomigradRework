SWEP.PrintName = "Zombie Ghoul"
SWEP.Category = "Остальное"
SWEP.Spawnable = true

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = ""
SWEP.HoldType = "fist"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 40

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.SwapAnims = false

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_IDLE)
end

function SWEP:SecondaryAttack()
    local ply = self:GetOwner()

    if self:GetNextSecondaryFire() > CurTime() then
        return
    end

    self:SetNextSecondaryFire(CurTime() + 10)

    if SERVER then
        ply:SetVelocity(ply:EyeAngles():Forward() * 450)

        sound.Play("npc/strider/striderx_pain8.wav",ply:GetPos())
    end
end

function SWEP:SendAttackAnim(owner)
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims

	owner:GetViewModel():SetPlaybackRate(1.65)
end

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()

    if self:GetNextPrimaryFire() > CurTime() then
        return
    end

    self:SetNextPrimaryFire(CurTime() + 2)

    if !IsValid(ply) or !ply:IsPlayer() then
        return
    end

    local tr = ply:GetEyeTrace()

    timer.Simple(0.3,function()
        if SERVER and tr.Hit and ply:EyePos():Distance(tr.HitPos) < 200 and IsValid(tr.Entity) and tr.Entity != Entity(0) then
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(self.Primary.Damage)
            dmginfo:SetAttacker(ply)
            dmginfo:SetInflictor(self)
            dmginfo:SetDamageType(DMG_SLASH)
            dmginfo:SetDamageForce(ply:EyeAngles():Forward() * 100)
            dmginfo:SetDamagePosition(tr.HitPos)
                if IsValid(tr.Entity) then
                    tr.Entity:TakeDamageInfo(dmginfo)
                
                    sound.Play("npc/zombie/claw_strike"..math.random(1,3)..".wav",ply:GetPos() + ply:OBBCenter())
                    ply:SetAnimation(PLAYER_ATTACK1)
                end
            else
                sound.Play("npc/zombie/claw_miss"..math.random(1,2)..".wav",ply:GetPos() + ply:OBBCenter())
                ply:SetAnimation(PLAYER_ATTACK1)
        end
    end)

	self:SendAttackAnim(ply)
end

function SWEP:Think()
    self:SetHoldType(self.HoldType)
end