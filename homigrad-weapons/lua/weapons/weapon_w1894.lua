SWEP.Base = "homigrad_base"
SWEP.PrintName = "Winchester 1894"
SWEP.Category = "Оружие: Снайперские Винтовки"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/tfa_ins2/w_winchester_1894.mdl"
SWEP.ViewModel = "models/weapons/tfa_ins2/w_winchester_1894.mdl"

SWEP.HoldType = "ar2"

SWEP.Primary.Automatic = false
SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Damage = 125
SWEP.Primary.Ammo = ".30-30 Winchester"
SWEP.Primary.Wait = 0.09
SWEP.Primary.ReloadTime = 0.1
SWEP.Sound = "zcitysnd/sound/weapons/firearms/rifle_jae700/jae_fire_01.wav"
SWEP.InsertSound = "weapons/tfa_ins2/winchester_1894/winchester_round_insert_2.wav"

SWEP.WorldPos = Vector(6,2,-4)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(33,-0.45,1.85)
SWEP.AttAng = Angle(0.55,-0.12,0)
SWEP.HolsterAng = Angle(0,-90,0)
SWEP.HolsterPos = Vector(-16,4,2)

SWEP.RHand = Vector(-3,0,-2.5)
SWEP.RHandAng = Angle(0,-20,0)
SWEP.LHand = Vector(13,-4.2,-1.5)
SWEP.LHandAng = Angle(0,0,0)

SWEP.AttachBone = nil

SWEP.IsRevolver = true

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.IconPos = Vector(160,-8.5,-1)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.TPIK_Anims = false

SWEP.ZoomPos = Vector(0,0.44,2.5)
SWEP.ZoomAng = Angle(-0.2,-0.08,0)

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Pump = 0
SWEP.Pump2 = 0
SWEP.Pump3 = 0
SWEP.PumpEnd = false
SWEP.Pumped = true
SWEP.PumpTarg = 0
SWEP.ReloadShit = 0

SWEP.Reload1 = false
SWEP.Reload2 = false
SWEP.Reload3 = false
SWEP.Reload4 = false

function smooth(value)
    return math.ease.InOutBounce(value) + math.max(math.ease.InBounce(value) - 0.6,0)
end

function SWEP:PostReloadAnim()
    self.ReloadShit = LerpFT(0.2,self.ReloadShit,self.reload and 1 or 0)

    if self.reload then
        self.RHand = Vector(-3,0,-2.5) + Vector(5,2.8,2.5) * self.ReloadShit
        self.RHandAng = Angle(0,-20,0) + Angle(15,0,0) * self.ReloadShit
    end
end

function SWEP:PostAnim()
    self.Pump = LerpFT(smooth(self.PumpTarg > 0 and 0.2 or 0.2),self.Pump,self.PumpTarg)
    self.Pump2 = LerpFT(smooth(self.PumpTarg > 0 and 0.15 or 0.2),self.Pump2,self.PumpTarg)
    self.Pump3 = LerpFT(self.PumpTarg > 0 and 0.4 or 0.3,self.Pump3,self.PumpTarg)

    if self.Pump2 > 0.7 then
        self.PumpTarg = 0
    end

    self.RHand = Vector(-3,0,-2.5) * (1 - self.Pump3) + Vector(0,0,-4) * self.Pump3
    self.RHandAng = Angle(0,-20,0) * (1 - self.Pump3) + Angle(0,10,0) * self.Pump3

    self.DWorldPos = Vector(6,2,-4) + Vector(2,0,-12) * self.Pump2
    self.DWorldAng = Angle(1,0,0) + Angle(55,0,0) * self.Pump2

    self:PostReloadAnim()
end

//zcitysnd/sound/weapons/mosin/handling/mosin_boltrelease.wav
//zcitysnd/sound/weapons/mosin/handling/mosin_boltback.wav
//zcitysnd/sound/weapons/mosin/handling/mosin_boltforward.wav
//zcitysnd/sound/weapons/mosin/handling/mosin_boltlatch.wav

function SWEP:ReloadFunc()
    self.AmmoChek = 5
    if self.reload then
        self.NextShoot = CurTime() + 1
        return
    end
    local ply = self:GetOwner()
    if ply:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then
        return
    end
    if self:Clip1() >= self.Primary.ClipSize or self:Clip1() >= self:GetMaxClip1() then
        return
    end

    self.reload = CurTime() + self.Primary.ReloadTime

    self.NextShoot = CurTime() + 1
    
    if SERVER then
        net.Start("hg reload")
        net.WriteEntity(self)
        net.Broadcast()
    end

    //ply:SetAnimation(PLAYER_RELOAD)

    if not IsValid(self) or not IsValid(self:GetOwner()) then return end
        local wep = self:GetOwner():GetActiveWeapon()
        if IsValid(self) and IsValid(ply) and (IsValid(wep) and wep or self:GetOwner().ActiveWeapon) == self then
            self.AmmoChek = 5
            self:SetHoldType(self.HoldType)
            timer.Simple(self.Primary.ReloadTime,function()
                local pos,ang = self:WorldModel_Transform()
                self:SetClip1(math.Clamp(self:Clip1()+1,0,self:GetMaxClip1()))
                ply:SetAmmo(ply:GetAmmoCount( self:GetPrimaryAmmoType() )-1, self:GetPrimaryAmmoType())

                if SERVER then
                    sound.Play(self.InsertSound,pos,95,math.random(95,105),0.75)
                end

                timer.Simple(0.9,function()
                    if !ply:KeyDown(IN_RELOAD) or self:Clip1() == self:GetMaxClip1() or ply:GetAmmoCount( self:GetPrimaryAmmoType() ) == 0 then
                        self.isup = false
                    end

                    self.reload = nil
                end)
            end)
        end
end

function SWEP:EmitReload()
    local pos,ang = self:WorldModel_Transform()
    if SERVER then
        sound.Play("snds_jack_gmod/ez_weapons/ssr/open.ogg",pos,95,math.random(95,105),0.75)
    end
end

function SWEP:Reload()
    self.AmmoChek = 5
    if !self.Pumped and self.PumpTarg == 0 then
        self:EmitReload()
        self.PumpTarg = 1
        self.PumpEnd = false
        //self.RHandAng = Angle(0,90,-90)
        //self.RHand = Vector(-4,2,-2)
        if SERVER then
            timer.Simple(0,function()
                local angs = self:GetOwner():EyeAngles()
                angs:RotateAroundAxis(angs:Up(),-40)
                local pos,ang = self:GetTrace()
                local effect = EffectData()
                effect:SetOrigin(pos)
                effect:SetAngles(angs)
                effect:SetFlags(25)
        
                util.Effect( "RifleShellEject", effect )
            end)
        end
        timer.Simple(0.1,function()
            self.PumpTarg = 0
            self.Pumped = true
            self.NextShoot = CurTime() + 0.3
            timer.Simple(0.5,function()
                self.PumpEnd = true
                self.AttachBone = nil
            end)
        end)
    elseif self.Pumped and self.PumpTarg == 0 and self.PumpEnd then
        self:ReloadFunc()
    end

    if SERVER then
        net.Start("hg reload")
        net.WriteEntity(self)
        net.Broadcast()
    end
end

function SWEP:CanShoot()
    if self.Blank != nil then
		self.Blank = self.Blank - 1
		if self.Blank > 0 then
			self.Pumped = false
			self:TakePrimaryAmmo(1)
		end
		if SERVER and self:GetOwner().suiciding and self:Clip1() > 0 and self.Pumped then
			self:GetOwner().adrenaline = self:GetOwner().adrenaline + 1.5
		end
    end
    return (!self.reload and !self.Inspecting and self:Clip1() > 0 and self.Pumped and !self:IsSprinting() and (self.Blank or 0) <= 0 and !self.isup)
end

function SWEP:PrimaryAdd()
    self.Pumped = false
end

function SWEP:DrawHUDAdd()
    if !self.Pumped then
        draw.SimpleText(hg.GetPhrase("gun_r_pump"),"HS.14",ScrW()/2,ScrH()/1.5,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end