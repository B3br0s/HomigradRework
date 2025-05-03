SWEP.AttPos = Vector(0,0,0)
SWEP.AttAng = Angle(0,0,0)
SWEP.NextShoot = 0
SWEP.RecoilForce = 1
SWEP.RecoilMul = 1

function SWEP:GetEnt()
    return self.worldModel or self
end

function SWEP:SetupMuzzle()
    local ply = self:GetOwner()
    local Att = self:GetOwner():LookupAttachment('anim_attachment_rh') or 8
    local Attachment = self:GetOwner():GetAttachment(Att)
    local Ang = Attachment.Ang

    local plyang = ply:EyeAngles()
	plyang:RotateAroundAxis(plyang:Forward(),0)

	local _,newAng = LocalToWorld(vector_origin,self.localAng or angle_zero,vector_origin,plyang)
	local ang = Angle(newAng[1],newAng[2],newAng[3])
    ang:Add(self.AttAng)
    --print(Ang)
    local att_shit = self:GetOwner():GetBoneMatrix(11)
    self:SetNW2Angle("MuzzleAng",ang)
    self:SetNW2Vector("MuzzlePos",Attachment.Pos + Ang:Forward() * self.AttPos[1] + Ang:Right() * self.AttPos[2] + Ang:Up() * self.AttPos[3] + Ang:Up() * (SERVER and (!self:IsPistolHoldType() and -2 or -1) or 0)) 
end

function SWEP:GetTrace()
    self:SetupMuzzle()
    local APos = self.AttPos
    local AAng = self.AttAng
    local Att = {Ang=self:GetNW2Angle('MuzzleAng'), Pos=self:GetNW2Vector('MuzzlePos')}
    local tr = {}
    tr.start = Att.Pos - Att.Ang:Forward() * 20
    tr.endpos = Att.Pos + Att.Ang:Forward() * 60000
    tr.filter = {self:GetOwner(), self}
    return util.TraceLine(tr)
end

function SWEP:Shoot(isfake)
    local owner = self:GetOwner()
    if owner.suiciding and SERVER then
        if owner.Fake and owner:KeyDown(IN_USE) or !owner.Fake then
            owner:DropWep(nil,nil,vector_up * -50,true)
            local SuicideInfo = DamageInfo()
            local head = owner:GetBoneMatrix(6)
            SuicideInfo:SetDamagePosition(head:GetTranslation() - vector_up * 6)
            SuicideInfo:SetDamageForce(vector_up * 64)
            SuicideInfo:SetDamage(120)
            SuicideInfo:SetDamageType(DMG_BULLET)
            SuicideInfo:SetAttacker(owner)
            SuicideInfo:SetInflictor(self)
            owner.LastInfo = SuicideInfo
            owner.LastBone = "ValveBiped.Bip01_Head1"
            owner:TakeDamageInfo(SuicideInfo)
            owner:SetHealth(owner:Health() - SuicideInfo:GetDamage() * 7)
            net.Start("bp headshoot explode")
            net.WriteVector(head:GetTranslation())
            net.WriteVector(vector_up * 3)
            net.Broadcast()
            net.Start("bp buckshoot")
            net.WriteVector(head:GetTranslation())
            net.WriteVector(vector_up * 3)
            net.Broadcast()

            timer.Simple(0,function()
                if IsValid(owner.FakeRagdoll) then
                    owner.FakeRagdoll:ManipulateBoneScale(owner.FakeRagdoll:LookupBone("ValveBiped.Bip01_Head1"),Vector(0.0001,0.0001,0.0001))
                end
            end)
        end
    end
    if self.NextShoot and self.NextShoot > CurTime() then return end
    if self.reload then
        return
    end
    local primary = self.Primary
    if CLIENT and self:GetOwner() == LocalPlayer() then
        self:PrimarySpread()
        Recoil = Recoil + (self.Primary.Automatic and 0.5 or 2)
        RecoilS = RecoilS + self.RecoilForce
    elseif SERVER then
        self:PrimarySpread()
    end

    //self.RecoilMul = self.RecoilMul + self.RecoilForce
    if CLIENT and !self.BoltManual then
        self.animmul = 2
    end
    --self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self.NextShoot = (CurTime() + (self.Primary.Wait or 0.1))

    if self.PrimaryAdd then
        self:PrimaryAdd()
    end

    self:SetNextPrimaryFire(CurTime() + (self.Primary.Wait or 0.1))
    
    self:SetupMuzzle()
    local Att = {Ang=self:GetNW2Angle('MuzzleAng'), Pos=self:GetNW2Vector('MuzzlePos')}
    local tr = self:GetTrace()
    if !isfake then
        self:EmitSound((!istable(self.Primary.Sound) and self.Primary.Sound or table.Random(self.Primary.Sound)),100,math.random(95,110),0.5,CHAN_WEAPON)
        self:TakePrimaryAmmo(1)
    end

    local Num = self.NumBullet or 1

    local Bullet = {}
    Bullet.Src = Att.Pos - Att.Ang:Forward() * 10 + (SERVER and Att.Ang:Up() * 5 or vector_up * 0)
    Bullet.Dir = Att.Ang:Forward()
    Bullet.Damage = self.Primary.Damage
    //Bullet.Num = (self.NumBullet or 1)
    Bullet.Spread = Vector(0,0,0)
    Bullet.Tracer = 0
    Bullet.AmmoType = self.Primary.Ammo

    for i = 1,Num do
        //Bullet.Callback = self.BulletCallBack

        Bullet.Spread = (Num > 1 and VectorRand(-i / 64,i / 32) or Vector(0,0,0))

        if SERVER then
          self:FireLuaBullets(Bullet)
        end
    
        local effectdata = EffectData()
    
        if CLIENT then
            local tr = self:GetTrace()
            effectdata:SetOrigin(tr.HitPos + VectorRand(-1 * (self.NumBullet or 0), 1 * (self.NumBullet or 0)))
            effectdata:SetNormal(tr.Normal + VectorRand(-25 * (self.NumBullet or 0), 25 * (self.NumBullet or 0)))
            effectdata:SetStart(tr.StartPos)
            effectdata:SetEntity(self)
            effectdata:SetScale(1)
            util.Effect("eff_tracer", effectdata)
    
            local particle = ParticleEmitter(tr.StartPos):Add("effects/action-realismflash1", tr.StartPos)
            local particle2 = ParticleEmitter(tr.StartPos):Add("effects/badassflash2", tr.StartPos)
            local particle3 = ParticleEmitter(tr.StartPos):Add("effects/muzzleflashx_nemole", tr.StartPos)
    
            if particle then
                particle:SetVelocity( 1.05 * self:GetOwner():GetVelocity())
                particle:SetLifeTime(0)
                particle:SetDieTime(math.Rand(0.05 ,0.1))
                particle:SetStartAlpha(math.Rand(155, 255))
                particle:SetEndAlpha(0)
                particle:SetStartSize(math.Rand(3, 5))
                particle:SetEndSize(math.Rand(5, 10))
                particle:SetLighting(false)
                particle:SetColor(255, 179, 126)
            end
            if particle2 then
                particle2:SetVelocity( 1.05 * self:GetOwner():GetVelocity())
                particle2:SetLifeTime(0)
                particle2:SetDieTime(math.Rand(0.05 ,0.1))
                particle2:SetStartAlpha(math.Rand(155, 255))
                particle2:SetEndAlpha(0)
                particle2:SetStartSize(math.Rand(2, 3))
                particle2:SetEndSize(math.Rand(5, 10))
                particle2:SetLighting(false)
                particle2:SetColor(255, 179, 126)
            end
            if particle3 then
                particle3:SetVelocity( 1.05 * self:GetOwner():GetVelocity())
                particle3:SetLifeTime(0)
                particle3:SetDieTime(math.Rand(0.05 ,0.1))
                particle3:SetStartAlpha(math.Rand(155, 255))
                particle3:SetEndAlpha(0)
                particle3:SetStartSize(math.Rand(2, 3))
                particle3:SetEndSize(math.Rand(5, 10))
                particle3:SetLighting(false)
                particle3:SetColor(255, 179, 126)
            end
        end
    end
end