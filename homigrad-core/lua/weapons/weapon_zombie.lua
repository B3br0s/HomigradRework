SWEP.PrintName = "Zombie"
SWEP.Category = "Остальное"
SWEP.Spawnable = true

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = ""
SWEP.HoldType = "fist"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 20

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.SwapAnims = false

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_IDLE)
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

    self:SetNextPrimaryFire(CurTime() + 1)

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
            
            if constraint.HasConstraints(tr.Entity) and math.random(1,3) == 3 then
                local cons_r = {}
                local cons_w = {}
                for _, cons in ipairs(constraint.FindConstraints(tr.Entity,"Weld")) do
                    table.insert(cons_w,cons)
                end
                for _, cons in ipairs(constraint.FindConstraints(tr.Entity,"Rope")) do
                    table.insert(cons_r,cons)
                end
            
                if #cons_r > 0 then
                    local cons = table.Random(cons_r)
                    constraint.Find(cons.Ent1,cons.Ent2,"Rope",cons.Bone1,cons.Bone2):Remove()
                end
            
                if #cons_w > 0 then
                    local cons = table.Random(cons_w)
                    constraint.Find(cons.Ent1,cons.Ent2,"Weld",cons.Bone1,cons.Bone2):Remove()
                end
            end
        
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

function SWEP:SecondaryAttack()
end

function SWEP:Think()
    self:SetHoldType(self.HoldType)
end