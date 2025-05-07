SWEP.MuzzleColor = Color(255,225,125)
SWEP.AttPos = Vector(21,2.775,-1.7)
SWEP.AttAng = Angle(0,0,0)
SWEP.MuzzlePos = Vector(0,0,0)
SWEP.MuzzleAng = Angle(0,0,0)

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
            //Ang:Add(Angle(0.5,-0.7,0))
            local tr = util.QuickTrace(Pos,Ang:Forward() * 1000,LocalPlayer())
            local hit = tr.HitPos:ToScreen()
            local start = Pos:ToScreen()
            local muzzlestart = MuzzlePos:ToScreen()
            surface.SetDrawColor( 255, 255, 255, 100)
            surface.DrawRect(hit.x-2,hit.y+2,4,4)
            surface.SetDrawColor( 255, 51, 0)
            surface.DrawRect(start.x - 2,start.y - 2,4,4)
            surface.SetDrawColor( 238, 255, 0)
            surface.DrawRect(muzzlestart.x - 2,muzzlestart.y - 2,4,4)
            surface.SetDrawColor( 0, 0, 0)
            surface.DrawRect(ScrW() / 2 - 2,ScrH() / 2 - 2,4,4)
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
            Recoil = Recoil + self.Primary.Force / 256 + 0.5
        end

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
	        part:SetVelocity(Dir * Rand(500,500))
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
	    	part:SetVelocity(Dir * 125)
	    end
    end
end

function SWEP:Shoot()
    local primary = self.Primary

    self:EmitSound(istable(primary.Sound) and table.Random(primary.Sound) or primary.Sound,100,math.random(90,110),1,CHAN_WEAPON,SND_NOFLAGS)

    local Pos,Ang = SERVER and self:GetTrace() or self:GetNWVector("Muzzle"),self:GetNW2Angle("Muzzle")

    local Num = self.NumBullet or 1

    local Bullet = {}
    Bullet.Src = Pos
    Bullet.Dir = Ang:Forward()
    Bullet.Damage = self.Primary.Damage
    //Bullet.Num = (self.NumBullet or 1)
    Bullet.Spread = Vector(0,0,0)
    Bullet.Tracer = 0
    Bullet.AmmoType = self.Primary.Ammo

    self:PrimaryAdd()

    self:PrimarySpread()

    if SERVER then
        self:TakePrimaryAmmo(1)

        for i = 1, Num do
            Bullet.Spread = (i > 1 and VectorRand(-0.06 * (math.random(-1,1) - i),0.05 * (math.random(-1,2) - i)) or Vector(0,0,0))

            self:FireLuaBullets(Bullet)
        end
    end

    local Pos = CLIENT and self:GetTraceMuzzle() or self:GetTrace()

    self:PostShoot(Pos,Ang)
end