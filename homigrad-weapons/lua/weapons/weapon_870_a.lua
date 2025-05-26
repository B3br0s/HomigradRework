SWEP.Base = "homigrad_base"
SWEP.PrintName = "Remington 870-A"
SWEP.Category = "Оружие: Дробовики"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/arccw_go/v_shot_870.mdl"
SWEP.ViewModel = "models/weapons/arccw_go/v_shot_870.mdl"

SWEP.HoldType = "ar2"

SWEP.Primary.ReloadTime = 1.7
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Damage = 18
SWEP.Primary.Force = 20
SWEP.NumBullet = 8
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Sound = {"pwb2/weapons/ksg/shot1.wav","pwb2/weapons/ksg/shot2.wav","pwb2/weapons/ksg/shot3.wav","pwb2/weapons/ksg/shot4.wav"}//"zcitysnd/sound/weapons/firearms/shtg_berettasv10/beretta_fire_01.wav"
SWEP.InsertSound = "pwb2/weapons/m4super90/shell.wav"
SWEP.Pump = 0
SWEP.PumpEnd = false
SWEP.Pumped = true
SWEP.PumpTarg = 0
SWEP.Primary.ReloadTime = 0.15
SWEP.Primary.Wait = 0.5

SWEP.IsShotgun = true

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.WorldPos = Vector(-6,-1.5,-1)
SWEP.WorldAng = Angle(1,0,0)
SWEP.AttPos = Vector(37,4.3,-2.2)
SWEP.AttAng = Angle(0.2,-0.25,0)
SWEP.HolsterAng = Angle(0,-10,0)
SWEP.HolsterPos = Vector(-28,-1.5,4.5)
SWEP.HolsterBone = "ValveBiped.Bip01_Spine4"

SWEP.BoltBone = nil
SWEP.BoltVec = nil

SWEP.IconPos = Vector(130,-20,-4)
SWEP.IconAng = Angle(0,90,0)

SWEP.TwoHands = true

SWEP.ZoomPos = Vector(12,-4.25,-1.65)
SWEP.ZoomAng = Angle(-0.3,-0.2,0)

SWEP.RecoilForce = 2

SWEP.Animations = {
    ["pump"] = {
        Source = "cycle",
        Time = 0.3
    },
    ["draw"] = {
        Source = "draw",
        Time = 1
    },
    ["idle"] = {
        Source = "idle",
        Time = 1
    },
    ["insert"] = {
        Source = "insert",
        Time = 0.5
    },
    ["insert_start"] = {
        Source = "start_reload",
        Time = 0.5
    },
    ["insert_end"] = {
        Source = "end_reload",
        Time = 0.5
    },
}

SWEP.Reload1 = false
SWEP.Reload2 = false
SWEP.Reload3 = false
SWEP.Reload4 = false

function SWEP:Reload()
    self.AmmoChek = 5
    if !self.Pumped and self.PumpTarg == 0 then
        self.PumpTarg = 1
        self.PumpEnd = false
        if SERVER then
            timer.Simple(0,function()
                local angs = self:GetOwner():EyeAngles()
                angs:RotateAroundAxis(angs:Up(),-40)
                local pos,ang = self:GetTrace()
                local effect = EffectData()
                effect:SetOrigin(pos)
                effect:SetAngles(angs)
                effect:SetFlags(25)
        
                util.Effect( "ShotgunShellEject", effect )
            end)
        end
        if SERVER then
            sound.Play("pwb2/weapons/ksg/pumpback.wav",self:GetPos(),70,100,1,0)
        end
        hg.PlayAnim(self,"pump")
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

    if !self.isup then
        hg.PlayAnim(self,"insert_start")
        self.isup = true
    end

    //ply:SetAnimation(PLAYER_RELOAD)

    if not IsValid(self) or not IsValid(self:GetOwner()) then return end
        local wep = self:GetOwner():GetActiveWeapon()
        if IsValid(self) and IsValid(ply) and (IsValid(wep) and wep or self:GetOwner().ActiveWeapon) == self then
            self.AmmoChek = 5
            self:SetHoldType(self.HoldType)
            timer.Simple(self.Primary.ReloadTime,function()
                local pos,ang = self:WorldModel_Transform()
                hg.PlayAnim(self,"insert")
                self:SetClip1(math.Clamp(self:Clip1()+1,0,self:GetMaxClip1()))
                ply:SetAmmo(ply:GetAmmoCount( self:GetPrimaryAmmoType() )-1, self:GetPrimaryAmmoType())

                if SERVER then
                    sound.Play(self.InsertSound,pos,95,math.random(95,105),0.75)
                end

                timer.Simple(0.9,function()
                    if !ply:KeyDown(IN_RELOAD) or self:Clip1() == self:GetMaxClip1() or ply:GetAmmoCount( self:GetPrimaryAmmoType() ) == 0 then
                        hg.PlayAnim(self,"insert_end")
                        self.isup = false
                    end

                    self.reload = nil
                end)

                if ply:GetAmmoCount( self:GetPrimaryAmmoType()) != 0 and self:Clip1() != self:GetMaxClip1() then                    
                    //ply:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)

                    //ply:SetAnimation(PLAYER_IDLE)
                end
            end)
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