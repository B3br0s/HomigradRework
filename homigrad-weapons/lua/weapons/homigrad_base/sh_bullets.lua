SWEP.MuzzleColor = Color(255,225,125)
SWEP.AttPos = Vector(21,2.775,-1.7)
SWEP.AttAng = Angle(0,0,0)
SWEP.MuzzlePos = Vector(0,0,0)
SWEP.MuzzleAng = Angle(0,0,0)
SWEP.NextShoot = 0

local Rand = math.Rand
local random = math.random

if CLIENT then
    local hg_show_hitposmuzzle = CreateClientConVar("hg_show_hitposmuzzle","0",false,false,"huy",0,1)

    hook.Add("HUDPaint","homigrad_wep_hit",function()
        if hg_show_hitposmuzzle:GetBool() and LocalPlayer():IsAdmin() and LocalPlayer():Alive() then
            local wep = LocalPlayer():GetActiveWeapon()

            if !hg.Weapons[wep] then
                return
            end

            if !wep.GetTrace then
                return
            end

            local self = wep
    
            local Pos,Ang = self:GetNWVector("Muzzle"),self:GetNW2Angle("Muzzle")
            local MuzzlePos,MuzzleAng = self:GetTraceMuzzle()
            local ClientPos,ClientAng = self:GetTrace()
            //Ang:Add(Angle(0.5,-0.7,0))
            local tr = util.QuickTrace(Pos,Ang:Forward() * 1000,LocalPlayer())
            local tr1 = util.QuickTrace(ClientPos,Ang:Forward() * 1000,LocalPlayer())
            local hit = tr.HitPos:ToScreen()
            local hit1 = tr1.HitPos:ToScreen()
            local start = Pos:ToScreen()
            local start1 = ClientPos:ToScreen()
            local muzzlestart = MuzzlePos:ToScreen()
            surface.SetDrawColor( 255, 255, 255, 100)
            surface.DrawRect(hit.x-2,hit.y+2,4,4)
            surface.SetDrawColor( 255, 51, 0)
            surface.DrawRect(start.x - 2,start.y - 2,4,4)
            surface.SetDrawColor( 238, 255, 0)
            surface.DrawRect(muzzlestart.x - 2,muzzlestart.y - 2,4,4)
            surface.SetDrawColor( 0, 0, 0)
            surface.DrawRect(ScrW() / 2 - 2,ScrH() / 2 - 2,4,4)

            surface.SetDrawColor( 0, 225, 255, 100)
            surface.DrawRect(hit1.x-2,hit1.y+2,4,4)
            surface.SetDrawColor( 0, 4, 255)
            surface.DrawRect(start1.x - 2,start1.y - 2,4,4)
        end
    end)
end

function SWEP:PostShoot(Pos,Ang)
    local Dir = Ang:Forward()

    local colorMuzzle = self.MuzzleColor

    if !self.BoltManual then
        self.animmul = 2
    end

    if CLIENT then
        if self:GetOwner() == LocalPlayer() then
            RecoilS = RecoilS + self.RecoilForce
            Recoil = Recoil + 0.2 + (self.Primary.Force / 512)
        end

        local Tr = {}
        Tr.start = Pos
        Tr.endpos = Pos + Ang:Forward() * 60000
        Tr.filter = {self:GetOwner(), self}
        local tr = util.TraceLine(Tr)

        /*local effectdata = EffectData()
        effectdata:SetOrigin(tr.HitPos + VectorRand(-1 * (self.NumBullet or 0), 1 * (self.NumBullet or 0)))
        effectdata:SetNormal(tr.Normal + VectorRand(-25 * (self.NumBullet or 0), 25 * (self.NumBullet or 0)))
        effectdata:SetStart(Pos)
        effectdata:SetEntity(self)
        effectdata:SetScale(1)
        util.Effect("eff_tracer", effectdata)*/

        local part = ParticleEmitter(Pos):Add("mat_jack_gmod_shinesprite", Pos)

        if part then
            part:SetDieTime(Rand(1 / 28,1 / 30))

	        part:SetColor(colorMuzzle.r,colorMuzzle.g,colorMuzzle.b)
	        part:SetLighting(false)
	        part:SetStartAlpha(Rand(75,155))
            part:SetEndAlpha(Rand(0,75))
	        part:SetStartSize(Rand(5,10) * 0.5)
	        part:SetEndSize(Rand(10,35))
	        part:SetRoll(Rand(-360,360))
	        part:SetVelocity(Dir * Rand(500,500) + self:GetOwner():GetVelocity() * 2)
	        part:SetAirResistance(Rand(1750,2000))
        end

        local part = ParticleEmitter(Pos):Add("sprites/spark",Pos + Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1)))

	    if part then--glow
	    	part:SetDieTime(0.075)
            part:SetColor(colorMuzzle.r,colorMuzzle.g,colorMuzzle.b)
	    	part:SetLighting(false)
	    	part:SetStartAlpha(20)
	    	part:SetEndAlpha(0)
        
	    	part:SetStartSize(Rand(6,8))
	    	part:SetEndSize(random(45,55))

	    	part:SetRoll(Rand(360,-360))
	    	part:SetVelocity(Dir * 125 + self:GetOwner():GetVelocity() * 2)
	    end
    end
end

function SWEP:Shoot()
    local primary = self.Primary

    self:GetTrace()

    self.NextShoot = CurTime() + primary.Wait

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
                    owner.FakeRagdoll.gib = {
                            ["Head"] = true,
                            ["LArm"] = false,
                            ["RArm"] = false,
                            ["Torso"] = false,
                            ["LLeg"] = false,
                            ["RLeg"] = false,
                            ["Full"] = false
                            }
                end
            end)
        end
    end

    if SERVER then
        self:EmitSound(istable(primary.Sound) and table.Random(primary.Sound) or primary.Sound,100,math.random(90,110),1,CHAN_WEAPON,SND_NOFLAGS)
    else
        if self:GetOwner() == LocalPlayer() then
            self:EmitSound(istable(primary.Sound) and table.Random(primary.Sound) or primary.Sound,100,math.random(90,110),1,CHAN_WEAPON,SND_NOFLAGS)
        end
    end

    local Pos,Ang = SERVER and self:GetTrace() or self:GetNWVector("Muzzle"),self:GetNW2Angle("Muzzle")

    local Num = self.NumBullet or 1

    local Bullet = {}
    Bullet.Src = Pos
    Bullet.Dir = Ang:Forward()
    Bullet.Damage = weapons.Get(self:GetClass()).Primary.Damage
    //Bullet.Num = (self.NumBullet or 1)
    Bullet.Spread = Vector(0,0,0)
    Bullet.Tracer = 0
    Bullet.AmmoType = self.Primary.Ammo

    self:GetTrace()//сколько можно нахуй

    self:PrimaryAdd()

    self:PrimarySpread()

    if SERVER then
        self:TakePrimaryAmmo(1)

        for i = 1, Num do
            Bullet.Spread = (i > 1 and VectorRand(-0.03 * (math.random(-1,2) - i),0.03 * (math.random(-3,2) - i)) or Vector(0,0,0))

            self:FireLuaBullets(Bullet)
        end
    end

    local Pos = CLIENT and self:GetTraceMuzzle() or self:GetTrace()

    self:PostShoot(Pos,Ang)
end