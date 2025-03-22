SWEP.AttPos = Vector(0,0,5)
SWEP.AttAng = Angle(-1,0,0)
function SWEP:GetEnt()
    return self.worldModel or self
end

function SWEP:SetupMuzzle()
    local Att = self:GetOwner():LookupAttachment('anim_attachment_rh')

    local Attachment = self:GetOwner():GetAttachment(Att)
    local Ang = Attachment.Ang
    Ang:Add(self.AttAng)
    self:SetNW2Angle("MuzzleAng",Ang)
    self:SetNW2Vector("MuzzlePos",Attachment.Pos + Attachment.Ang:Forward() * self.AttPos[1] + Attachment.Ang:Right() * self.AttPos[2] + Attachment.Ang:Up() * self.AttPos[3]) 
end

function SWEP:GetTrace()
    local APos = self.AttPos
    local AAng = self.AttAng
    local Att = {Ang=self:GetNW2Angle('MuzzleAng'), Pos=self:GetNW2Vector('MuzzlePos')}
    local tr = {}
    tr.start = Att.Pos - Att.Ang:Forward() * 20
    tr.endpos = Att.Pos + Att.Ang:Forward() * 60000
    tr.filter = {self:GetOwner(), self}
    return util.TraceLine(tr)
end

function SWEP:Shoot()
    if self:GetNextPrimaryFire() > CurTime() then return end
    if self.NextShoot and self.NextShoot > CurTime() then return end
    if CLIENT then
        RecoilVert = (RecoilVert and RecoilVert + 1 or 0)
        Recoil = (Recoil and Recoil + math.random(-1,1) or 0)
        RecoilHor = (RecoilHor and RecoilHor + math.random(-1,1) or 0)
    end
    --self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self.NextShoot = (CurTime() + (self.Primary.Delay or 0.1))

    if self.PrimaryAdd then
        self:PrimaryAdd()
    end

    self:SetNextPrimaryFire(CurTime() + (self.Primary.Delay or 0.1))

    self:TakePrimaryAmmo(1)

    self:SetupMuzzle()
    local Att = {Ang=self:GetNW2Angle('MuzzleAng'), Pos=self:GetNW2Vector('MuzzlePos')}
    local tr = self:GetTrace()
    self:EmitSound(self.Primary.Sound,100,math.random(95,110),1,CHAN_WEAPON)
    local Bullet = {}
    Bullet.Src = Att.Pos
    Bullet.Dir = Att.Ang:Forward()
    Bullet.Damage = self.Primary.Damage
    Bullet.Num = (self.Primary.NumBullet or 1)
    Bullet.Spread = Vector(0,0,0)
    Bullet.AmmoType = self.Primary.Ammo

    self:SetNWFloat("Bolt",1)

    if SERVER then
        self:FireBullets(Bullet)
    else
        self:FireLuaBullets(Bullet)
    end

    local effectdata = EffectData()

    if CLIENT then
        local tr = self:GetTrace()
        effectdata:SetOrigin(tr.HitPos + VectorRand(-1 * (self.NumBullet or 0), 1 * (self.NumBullet or 0)))
        effectdata:SetNormal(tr.Normal + VectorRand(-25 * (self.NumBullet or 0), 25 * (self.NumBullet or 0)))
        effectdata:SetStart(Att.Pos + Att.Ang:Forward() * 0)
        effectdata:SetEntity(self)
        effectdata:SetScale(1)
        util.Effect("eff_tracer", effectdata)

        local particle = ParticleEmitter(Att.Pos + Att.Ang:Forward() * 5):Add("effects/action-realismflash1", Att.Pos + Att.Ang:Forward() * 7)
        local particle2 = ParticleEmitter(Att.Pos + Att.Ang:Forward() * 5):Add("effects/badassflash2", Att.Pos + Att.Ang:Forward() * 7)
        local particle3 = ParticleEmitter(Att.Pos + Att.Ang:Forward() * 5):Add("effects/muzzleflashx_nemole", Att.Pos + Att.Ang:Forward() * 7)

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