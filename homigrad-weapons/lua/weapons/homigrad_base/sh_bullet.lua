SWEP.AttPos = Vector(0,0,0)
SWEP.AttAng = Angle(0,0,0)

SWEP.SubSoundVolume = 0.85
SWEP.SoundVolume = 1

SWEP.MuzzleColor = Color(255,225,125)

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
    
            local Pos,Ang = self:GetTrace()
            local tr = util.QuickTrace(Pos,Ang:Forward() * 1000,LocalPlayer())
            local hit = tr.HitPos:ToScreen()
            local start = Pos:ToScreen()
            surface.SetDrawColor( 255, 255, 255, 100)
            surface.DrawRect(hit.x-2,hit.y+2,4,4)
            surface.SetDrawColor( 255, 51, 0)
            surface.DrawRect(start.x-2,start.y+2,4,4)
            surface.SetDrawColor( 0, 0, 0)
            surface.DrawRect(ScrW() / 2 - 2,ScrH() / 2 - 2,4,4)

            self:IsClose()
        end
    end)
end

function SWEP:GetTrace(nomod)
    local ply = self:GetOwner()

    local ent = hg.GetCurrentCharacter(ply)

    if !IsValid(ent) then
        return ply:GetPos(),ply:GetAngles()
    end

    local head_index = ent:LookupBone("ValveBiped.Bip01_Head1")

    local mat = ent:GetBoneMatrix(head_index)

    local Pos,Ang = self:WorldModel_Transform(nomod)

    if !self.AttPos then
        return Pos,Ang
    end

    if !Ang then
        Ang = Angle(0,0,0)
    end
    
    if !Pos then
        Pos = Vector(0,0,0)
    end

    Pos = Pos + Ang:Forward() * self.AttPos[1]
    Pos = Pos + Ang:Right() * self.AttPos[2]
    Pos = Pos + Ang:Up() * self.AttPos[3]

    Ang:RotateAroundAxis(Ang:Right(),self.AttAng[1])
    Ang:RotateAroundAxis(Ang:Up(),self.AttAng[2])
    Ang:RotateAroundAxis(Ang:Forward(),self.AttAng[3])

    return Pos,Ang
end

function SWEP:Shoot()
    if self:GetNextShoot() > CurTime() then
        return
    end

    local primary = self.Primary
    
    self:SetNextShoot(CurTime() + primary.Wait)

    if !IsValid(self:GetOwner()) then
        return
    end

    if self:GetOwner():GetNWBool("otrub") then
        return
    end

    local high_recoil = (self:IsPistolHoldType() and self:GetOwner():GetNWInt("post") == 2)

    self:PrimaryAdd()

    self:PrimarySpread()

    if self:IsLocal() then
        vis_recoil = vis_recoil + primary.Force / 15 * self.RecoilForce * (high_recoil and 3 or 1)
        Recoil = Recoil + 0.25 + primary.Force / 100 * (high_recoil and 3 or 1)
    end

    local ply = self:GetOwner()

    local ent = hg.GetCurrentCharacter(ply)

    local Pos,Ang = self:GetTrace()

    if self.Animations["fire"] then
        hg.PlayAnim(self,"fire")
    end

    if SERVER then
        net.Start("hg shoot")
        net.WriteEntity(self)
        net.SendPVS(Pos)
    end

    if SERVER then
        if self.Attachments['barrel'][1] and hg.GetAtt(self.Attachments['barrel'][1]).IsSupp then
            sound.Play(self.SuppressedSound,Pos,100,math.random(90,110),1)
        else
            sound.Play(istable(self.Sound) and self.Sound[math.random(1,#self.Sound)] or self.Sound,Pos,100,math.random(90,110),self.SoundVolume)
            if self.SubSound then
                sound.Play(self.SubSound,Pos,75,math.random(90,110),self.SubSoundVolume)
            end
        end
    end

    local tr_tbl = {
        start = Pos,
        endpos = Pos+Ang:Forward() * 100000,
        filter = {ply,self,self.worldModel}
    }   

    local tr = util.TraceLine(tr_tbl)

    local dist = Pos:Distance(tr.HitPos)

    if self.HitCallBack then
        self:HitCallBack(tr)
    end

    if self:GetOwner():IsSuperAdmin() then
        if CLIENT then
            //debugoverlay.Line(Pos,Pos + Ang:Forward() * dist,2,Color(255,0,0))
            debugoverlay.SweptBox(Pos + Ang:Right() * 1.25 - Ang:Up() * 0.75,Pos + Ang:Forward() * dist,Vector(1,1,1),Vector(1.5,1.5,1.5),Ang,2,Color(255,255,0))
            debugoverlay.BoxAngles(Pos+Ang:Forward()*dist,Vector(0,0,0),Vector(2,2,2),Ang,5,Color(255,0,0))
        else
            debugoverlay.BoxAngles(Pos+Ang:Forward()*dist,Vector(0,0,0),Vector(2,2,2),Ang,5,Color(0,0,255))
        end
    end

    local Num = self.NumBullet or 1

    local index = ply:LookupBone("ValveBiped.Bip01_Head1")

    if !IsValid(ent) then
        return  
    end

    local mat = ent:GetBoneMatrix(index)

    if !mat then
        return
    end

    if SERVER then
        if ply:GetNWBool("suiciding") and !ply.Fake then
            hg.Faking(ply,ply:EyeAngles():Forward() * - 100)
            timer.Simple(0,function() //ее крутое падение назад
                local rag = ply.FakeRagdoll

                if IsValid(rag) then
                    local s1 = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(3) )

                    s1:AddAngleVelocity(ply:EyeAngles():Up() * -2500)
                end
            end)
        end
    end

    local Bullet = {}
    Bullet.Src = (ply:GetNWBool("suiciding") and mat:GetTranslation() or Pos)
    Bullet.Dir = Ang:Forward()
    Bullet.Damage = weapons.Get(self:GetClass()).Primary.Damage * (ply:GetNWBool("suiciding") and 25 or 1)
    Bullet.IgnoreEntity = nil
    //Bullet.Num = (self.NumBullet or 1)
    Bullet.Spread = Vector(0,0,0)
    Bullet.Tracer = 0
    Bullet.AmmoType = self.Primary.Ammo
    if ply:GetNWBool("suiciding") then
        Bullet.Filter = {}
    else
        Bullet.Filter = {hg.GetCurrentCharacter(ply)}
    end

    //self:PrimarySpread()

    if SERVER then
        self:TakePrimaryAmmo(1)

        if ply:GetNWBool("suiciding") then
            ply:DropWep(nil,nil,vector_up * -5000,false)
        end

        for i = 1, Num do
            Bullet.Spread = (i > 1 and VectorRand(-0.03 * (math.random(-1,2) - i),0.03 * (math.random(-3,2) - i)) or Vector(0,0,0))
            
            self:FireLuaBullets(Bullet)
            self:SetNextShoot(CurTime() + primary.Wait)
            //self:FireBullets(Bullet)
        end
    else
        //self:FireBullets(Bullet)
    end

    self:PostShoot(Pos,Ang)
end

function SWEP:PostShoot(Pos,Ang)
    local Dir = Ang:Forward()

    local colorMuzzle = self.MuzzleColor

    if !self.BoltManual then
        self.animmul = 2
    end

    if CLIENT then
        if !IsValid(hg.GetCurrentCharacter(self:GetOwner())) then
            return
        end
        local Tr = {}
        Tr.start = Pos
        Tr.endpos = Pos + Ang:Forward() * 60000
        Tr.filter = {hg.GetCurrentCharacter(self:GetOwner()), self}
        local tr = util.TraceLine(Tr)

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
	        part:SetVelocity(Dir * Rand(500,500) + hg.GetCurrentCharacter(self:GetOwner()):GetVelocity() * 2)
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