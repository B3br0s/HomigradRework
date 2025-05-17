//do return end
SWEP.Base = "homigrad_base"
SWEP.PrintName = "Remington 870"
SWEP.Spawnable = true
SWEP.Category = "Оружие: Дробовики"
//SWEP.WorldModel = "models/weapons/zcity/w_shot_m3juper90.mdl"
SWEP.WorldModel = "models/weapons/arccw_go/v_shot_870.mdl"

//SWEP.CorrectPos = Vector(-1.5,-0.5,-0.4)
//SWEP.CorrectAng = Angle(0,5,0)
SWEP.CorrectPos = Vector(-11,-5,5.5)
SWEP.CorrectAng = Angle(-2,6,0)
SWEP.HoldType = "ar2"

SWEP.EjectPos = Vector(0,0,0)
SWEP.EjectAng = Angle(0,0,0)
SWEP.Bodygroups = {[1] = 0,[2]=0,[3]=1,[4]=0,[5]=0}

//SWEP.HolsterPos = Vector(5,-8,-5)
//SWEP.HolsterAng = Angle(0,-25,180)
SWEP.HolsterPos = Vector(-19,-1,8)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine2"
SWEP.HoldType = "ar2"
//SWEP.BoltBone = "Slide"
SWEP.BoltBone = "v_weapon.sawedoff_pump"
SWEP.BoltVec = Vector(0,0,-3.2)
SWEP.BoltManual = true
SWEP.NumBullet = 8
SWEP.IsShotgun = true
SWEP.Pumped = true
SWEP.TwoHands = true

SWEP.Primary.ReloadTime = 1

SWEP.RecoilForce = 5

//SWEP.ZoomPos = Vector(-2,-0.425,7)
//SWEP.ZoomAng = Angle(0,4.5,0)
SWEP.ZoomPos = Vector(10,-4.33,-1.65)
SWEP.ZoomAng = Angle(0,2.85,0.13)
SWEP.AttPos = Vector(0,-0.07,0)
SWEP.AttAng = Angle(0,1,0)
SWEP.MuzzlePos = Vector(36,4.28,-2.9)

//SWEP.IconPos = Vector(10,30,-6.5)
//SWEP.IconAng = Angle(-15,0,0)
SWEP.IconPos = Vector(-5.75,50,1)
SWEP.IconAng = Angle(0,0,0)

SWEP.Weight = 2

SWEP.Primary.Damage = 30
SWEP.Primary.Force = 60
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Primary.Sound = {"pwb2/weapons/ksg/shot1.wav","pwb2/weapons/ksg/shot2.wav","pwb2/weapons/ksg/shot3.wav","pwb2/weapons/ksg/shot4.wav"}//"zcitysnd/sound/weapons/firearms/shtg_berettasv10/beretta_fire_01.wav"
SWEP.InsertSound = "pwb2/weapons/m4super90/shell.wav"
SWEP.Pump = 0
SWEP.PumpEnd = false
SWEP.PumpTarg = 0

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

    ply:SetAnimation(PLAYER_RELOAD)

    if not IsValid(self) or not IsValid(self:GetOwner()) then return end
        local wep = self:GetOwner():GetActiveWeapon()
        if IsValid(self) and IsValid(ply) and (IsValid(wep) and wep or self:GetOwner().ActiveWeapon) == self then
            self.AmmoChek = 5
            self:SetHoldType(self.HoldType)
            timer.Simple(self.Primary.ReloadTime,function()
                if self:Clip1() == 0 then
                    timer.Simple(0.3,function()
                        if SERVER then
                            sound.Play("pwb2/weapons/ksg/pumpback.wav",self:GetPos(),70,100,1,0)
                        end
                        if SERVER then
                            timer.Simple(0,function()
                                local effect = EffectData()
                                effect:SetOrigin(self.worldModel:GetPos())
                                effect:SetAngles(self:GetOwner():EyeAngles())
                                effect:SetFlags(25)
                        
                                util.Effect( "ShotgunShellEject", effect )
                            end)
                        end
                        self.PumpTarg = 1
                        timer.Simple(0.125,function()
                            if SERVER then
                                sound.Play("pwb2/weapons/ksg/pumpforward.wav",self:GetPos(),70,100,1,0)
                            end
                            self.PumpTarg = 0
                        end)
                    end)
                end
                self:SetClip1(math.Clamp(self:Clip1()+1,0,self:GetMaxClip1()))
                ply:SetAmmo(ply:GetAmmoCount( self:GetPrimaryAmmoType() )-1, self:GetPrimaryAmmoType())

                if SERVER then
                    sound.Play(self.InsertSound,self:GetPos(),95,math.random(95,105),0.75)
                end

                self.reload = nil

                if ply:GetAmmoCount( self:GetPrimaryAmmoType()) != 0 and self:Clip1() != self:GetMaxClip1() then                    
                    ply:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
    
                    ply:SetAnimation(PLAYER_IDLE)
                end
            end)
        end
end

local function easedLerp(fraction, from, to)
	return LerpFT(math.ease.InSine(fraction), from, to)
end

function SWEP:PostAnim()
    local ply = self:GetOwner()

    hg.bone.Set(ply,"l_upperarm",Vector(0,0,0),Angle(0,-20,0),1,0.1)
    
	if self.BoltBone and IsValid(self.worldModel) then
		local bone = self.worldModel:LookupBone(self.BoltBone)

		self.animmul = easedLerp(0.75,self.animmul,self.PumpTarg)

		self.worldModel:ManipulateBonePosition(bone,self.BoltVec * self.animmul)
	end

    if ply:GetNWBool("suiciding") then
        return
    end

    self.Pump = easedLerp(0.55,self.Pump,self.PumpTarg)

    if self.Pump > 0.1 then
        local p1,a1 = ply:GetBoneMatrix(11):GetTranslation(),ply:GetBoneMatrix(11):GetAngles()
        a1:RotateAroundAxis(a1:Up(),-10)
        a1:RotateAroundAxis(a1:Right(),-5)
        self.shitang = a1
    end

    local PumpAngs = Angle(-50,-30,0)

    if !self:IsSprinting() then
        hg.bone.Set(ply,"r_forearm",Vector(0,0,0),PumpAngs * self.Pump,1,0.7)
        hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,0),1,0.25)
        hg.bone.Set(ply,"r_clavicle",Vector(0,0,0),Angle(0,0,0),1,0.25)
    end
end

function SWEP:Reload()
    self.AmmoChek = 5
    if !self.Pumped and self.PumpTarg == 0 then
        self.PumpTarg = 1
        self.PumpEnd = false
        if SERVER then
            timer.Simple(0,function()
                local effect = EffectData()
                effect:SetOrigin(self.worldModel:GetPos())
                effect:SetAngles(self:GetOwner():EyeAngles())
                effect:SetFlags(25)
        
                util.Effect( "ShotgunShellEject", effect )
            end)
        end
        if SERVER then
            sound.Play("pwb2/weapons/ksg/pumpback.wav",self:GetPos(),70,100,1,0)
        end
        timer.Simple(0.125,function()
            if SERVER then
                sound.Play("pwb2/weapons/ksg/pumpforward.wav",self:GetPos(),70,100,1,0)
            end
            self.PumpTarg = 0
            self.Pumped = true
            self.NextShoot = CurTime() + 0.3
            timer.Simple(0.5,function()
                self.PumpEnd = true
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
    return (!self.Reloading and !self.Inspecting and self:Clip1() > 0 and self.Pumped and !self:IsSprinting() and !self:IsClose() and (self.Blank or 0) <= 0)
end

function SWEP:PrimaryAdd()
    self.Pumped = false
end

function SWEP:DrawHUDAdd()
    if !self.Pumped then
        draw.SimpleText(hg.GetPhrase("gun_r_pump"),"HS.14",ScrW()/2,ScrH()/1.5,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end