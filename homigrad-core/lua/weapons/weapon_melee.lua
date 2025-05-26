SWEP.Base = "weapon_base"

SWEP.Category = "Оружие: Ближний Бой"
SWEP.Author = "Homigrad"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.WorldModel = "models/weapons/combatknife/tactical_knife_iw7_wm.mdl"
SWEP.ViewModel = "models/weapons/combatknife/tactical_knife_iw7_vm.mdl"

SWEP.HoldAng = Angle(-90,0,0)
SWEP.HoldPos = Vector(3,1.75,-0.5)

SWEP.AnimAng = Angle(0,0,0)
SWEP.AnimPos = Vector(-9,-2,0)

SWEP.ModelScale = 1.2

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Rarity = 2

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.IconAng = Angle(0,90,0)
SWEP.IconPos = Vector(60,-4.25,0)

function SWEP:DrawWeaponSelection(x,y,w,h,a)
    hg.DrawWeaponSelection(self,x,y,w,h,a)
end

SWEP.AnimWait = 0.8
SWEP.AttackTime = 0.2
SWEP.AttackAng = Angle(0,-50,0)
SWEP.AttackWait = 0.2
SWEP.AttackDist = 70
SWEP.AttackDamage = 25
SWEP.AttackType = DMG_SLASH
SWEP.isTakeSlot = true

SWEP.AttackHitFlesh = "snd_jack_hmcd_knifestab.wav"
SWEP.AttackHit = "snd_jack_hmcd_knifehit.wav"
SWEP.DeploySnd = "snd_jack_hmcd_knifedraw.wav"

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = false
SWEP.isMelee = true
SWEP.SupportTPIK = true
SWEP.NoLHand = true
SWEP.Hit = false
SWEP.HoldType = "knife"
SWEP.IKAnimationProxy = {}
SWEP.Animations = {
	["idle"] = {
        Source = "idle",
    },
	["draw"] = {
        Source = "vm_knifeonly_raise",
        MinProgress = 0.5,
        Time = 0.5
    },
    ["attack"] = {
        Source = "vm_knifeonly_stab",
        MinProgress = 0.5,
        Time = 0.8
    },
}

function SWEP:Attack(ent,tr)
    local dmgTab = DamageInfo()
    dmgTab:SetAttacker(self:GetOwner())
    dmgTab:SetDamage(self.AttackDamage)
    local ang = self:GetOwner():GetAngles()
    ang.p = 0
    dmgTab:SetDamageForce(ang:Forward() * 200)
    dmgTab:SetInflictor(self)
    dmgTab:SetDamagePosition(tr.HitPos)
    dmgTab:SetDamageType(self.AttackType)

    if IsValid(ent) and ent.TakeDamageInfo then
        ent:TakeDamageInfo(dmgTab)
    end
end

function SWEP:Step()
    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    if ply:GetActiveWeapon() != self then
        if IsValid(self.fakeWorldModel) then
            self.fakeWorldModel:Remove()
        end
    end

    if SERVER then
        self:SetHoldType(self.HoldType)
        self:SetAttack(self:GetAttackTime() > CurTime())
    end

    local isAttacking = self:GetAttack()
    if not isAttacking then
        self.Hit = false
        return
    end

    if self.Hit then return end

    local progress = -((self:GetAttackTime() - CurTime()) / (self.AttackTime * 0.5) - 1)
    local progress_fix = 1 - (self:GetAttackTime() - CurTime()) / self.AttackTime

    local ang_attack = Angle(
        self.AttackAng[1] * progress,
        self.AttackAng[2] * progress,
        self.AttackAng[3] * progress
    )

    local ang = ply:EyeAngles()
    local fixed = Angle()
    fixed:Set(ang:Forward():Angle())
    fixed:RotateAroundAxis(ang:Forward(), ang_attack.p)
    fixed:RotateAroundAxis(ang:Right(), ang_attack.y)
    fixed:RotateAroundAxis(ang:Up(), ang_attack.r)

    local eye_tr = hg.eyeTrace(ply, self.AttackDist * 2)

    local tr = util.TraceLine({
        start = eye_tr.StartPos,
        endpos = eye_tr.StartPos + fixed:Forward() * (self.AttackDist * 1.25) * progress_fix,
        filter = hg.GetCurrentCharacter(ply),
        mask = MASK_SHOT_HULL
    })

    local ent = tr.Entity

    debugoverlay.Line(
        tr.StartPos, tr.HitPos, 2,
        (IsValid(ent) and (ent:IsPlayer() or ent:IsRagdoll() or ent:IsNPC())) and Color(0, 255, 0) or Color(255, 38, 0),
        false
    )

    if not tr.Hit then return end

    self.Hit = true
    self:SetAttack(false)
    self:SetAttackTime(0)

    local isFlesh = ent:IsPlayer() or ent:IsNPC() or ent:IsRagdoll() or (
        IsValid(ent:GetPhysicsObject()) and (
            string.find(ent:GetPhysicsObject():GetMaterial(), "flesh") or
            string.find(ent:GetPhysicsObject():GetMaterial(), "player")
        )
    )

    local ent_ply = hg.GetCurrentCharacter(ply)
    self:Attack(ent, tr)

    if SERVER then
        if isFlesh then
            local snd = istable(self.AttackHitFlesh) and self.AttackHitFlesh[math.random(#self.AttackHitFlesh)] or self.AttackHitFlesh
            sound.Play(snd, ent_ply:GetPos(), 75, 100, 1)
            util.Decal("blood", tr.HitPos + tr.HitNormal * 15, tr.HitPos - tr.HitNormal * 15, ply)
            util.Decal("blood", ply:GetPos(), ply:GetPos(), ply)
        else
            local snd = istable(self.AttackHit) and self.AttackHit[math.random(#self.AttackHit)] or self.AttackHit
            sound.Play(snd, ent_ply:GetPos(), 75, 100, 1)
            return
        end
    end
end


function SWEP:DrawWorldModel(mat)
    local ply = self:GetOwner()

    if !IsValid(ply) then
        self:DrawModel()
        if IsValid(self.worldModel) then
            self.worldModel:Remove()
        end
        if IsValid(self.fakeWorldModel) then
            self.fakeWorldModel:Remove()
        end
        return
    else
        if CLIENT then
            if !IsValid(self.worldModel) then
                self:CreateWM()
            end
            if !IsValid(self.fakeWorldModel) then
                self:CreateFakeWM()
            end
        end
    end

    if !ismatrix(mat) then
        return
    end

	if ply:GetActiveWeapon() == self then
        local ent = hg.GetCurrentCharacter(ply)

		if IsValid(self.worldModel) then
			local angs = ply:EyeAngles()
            local _,ang = LocalToWorld(vector_origin,(self.AnimAng or angle_zero),vector_origin,angs)
			angs[1] = math.Clamp(angs[1],-89,40)
			local pos = ent:GetBonePosition(6) + ply:EyeAngles():Forward() * self.AnimPos[1] + ply:EyeAngles():Right() * self.AnimPos[2] + ply:EyeAngles():Up() * self.AnimPos[3]

			self.worldModel:SetPos(pos)
			self.worldModel:SetRenderOrigin(pos)
			self.worldModel:SetAngles(ang)
			self.worldModel.IsIcon = true
			self.worldModel:SetRenderAngles(ang)
		end

        if IsValid(self.fakeWorldModel) then
            local pos,ang = mat:GetTranslation(),mat:GetAngles()
			local angs = ang
            local _,ang = LocalToWorld(vector_origin,(self.HoldAng or angle_zero),vector_origin,angs)
			angs[1] = math.Clamp(angs[1],-89,40)
			local pos = mat:GetTranslation() + mat:GetAngles():Forward() * self.HoldPos[1] + mat:GetAngles():Right() * self.HoldPos[2] + mat:GetAngles():Up() * self.HoldPos[3]

			self.fakeWorldModel:SetPos(pos)
			self.fakeWorldModel:SetRenderOrigin(pos)
			self.fakeWorldModel:SetAngles(ang)
			self.fakeWorldModel.IsIcon = true
			self.fakeWorldModel:SetRenderAngles(ang)

            if ply:IsSuperAdmin() then
                self.fakeWorldModel:SetMaterial("models/mat_jack_gmod_brightwhite")
                self.fakeWorldModel:SetColor(Color(255,0,0))
            end
		end
	end

	if !IsValid(ply) then
		return 
	end
end

function SWEP:CreateFakeWM()
	self.fakeWorldModel = ClientsideModel(self.WorldModel)

    local wm = self.fakeWorldModel

	wm:SetModelScale(self.ModelScale)

	self:CallOnRemove("removeshit",function() wm:Remove() end)

	wm:SetNoDraw(false)
    wm:SetPredictable(true)
    wm:SetupBones()
    //wm:SetParent(self:GetOwner())
end

function SWEP:CreateWM()
	self.worldModel = ClientsideModel(self.ViewModel)

    local wm = self.worldModel

	//wm:SetModelScale(self.ModelScale)

	self:CallOnRemove("removeshit",function() wm:Remove() end)

	//wm:SetNoDraw(false)
    wm:SetNoDraw(true)
    //wm:SetParent(self:GetOwner())
end

function SWEP:GetWM()
    if !IsValid(self.worldModel) then
        self:CreateWM()
    end
	return self.worldModel
end

function SWEP:Initialize()
    if CLIENT then
		self:CreateWM()
		self:CreateFakeWM()
	end

    hg.Weapons[self] = true

	timer.Simple(0,function()
		self:Deploy()
	end)
end

function SWEP:Deploy()
    hg.PlayAnim(self,"draw")
    self:EmitSound(self.DeploySnd)
end

function SWEP:CanPrimaryAttack()
    return self:GetNextPrimaryFire() < CurTime()
end

function SWEP:PrimaryAttack()
    if !self:CanPrimaryAttack() then
        return
    end
    self.Hit = false
    if SERVER then
        self:SetNextPrimaryFire(CurTime() + self.AnimWait)

        timer.Simple(self.AttackWait,function()
            if !IsValid(self:GetOwner()) then
                return
            end
            self:SetAttackTime(CurTime() + self.AttackTime)
            sound.Play("weapons/melee/swing_light_sharp_0"..math.random(1,3)..".wav",hg.GetCurrentCharacter(self:GetOwner()):GetPos(),75,math.random(100,125))
        end)
    else
        timer.Simple(self.AttackWait,function()
            if CLIENT and self:GetOwner() == LocalPlayer() then
                local ang = Angle(self.AttackAng[2] * -0.05,self.AttackAng[3] * 0.25,0)
                ViewPunch(ang)
            end
        end)
    end
    hg.PlayAnim(self,"attack")
end

function SWEP:SecondaryAttack()
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