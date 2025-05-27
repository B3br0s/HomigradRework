SWEP.Base = "homigrad_base"
SWEP.PrintName = "RPG-7"
SWEP.Category = "Оружие: Гранатомёты"
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/w_rpg7_scoped.mdl"
SWEP.WorldModelReal = "models/weapons/fml/rs2/c_rpg.mdl"
SWEP.ViewModel = "models/weapons/fml/rs2/c_rpg.mdl"

SWEP.HoldType = "ar2"

SWEP.PistolRun = true

SWEP.holdtypes = {
    ["ar2"] = {[1] = 0.8,[2] = 1.25,[3] = 1.4,[4] = 0},
}

SWEP.Primary.ReloadTime = 0.7
SWEP.Primary.MagTime = 2.2
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Damage = 0
SWEP.Primary.Force = 230
SWEP.Primary.Ammo = "RPG-7 Projectile"
SWEP.Primary.Wait = 0.1
SWEP.Sound = "zcitysnd/sound/weapons/rpg7/rpg7_fp.wav"

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.RecoilForce = 1.5

SWEP.WorldPos = Vector(3,-1,2)
SWEP.WorldAng = Angle(0,0,9)
SWEP.AttPos = Vector(30,5.15,-2.5)
SWEP.AttAng = Angle(0.2,-0.1,0)
SWEP.HolsterAng = Angle(0,-90,0)
SWEP.HolsterPos = Vector(-16,4,2)

SWEP.BoltBone = "Weapon_Mag_Real"
SWEP.BoltVec = Vector(1 ,1,1)

SWEP.IconPos = Vector(160,-8,-3.5)
SWEP.IconAng = Angle(0,90,0)

SWEP.Rarity = 6

SWEP.TwoHands = true
SWEP.CanSuicide = false

SWEP.ZoomPos = Vector(2,-4.025,-0.11)
SWEP.ZoomAng = Angle(-0.4,-0.18,-9)

function SWEP:PostAnim()
    if self.BoltBone and self.BoltVec and CLIENT then
        local bone = self:GetWM():LookupBone(self.BoltBone)

        if self:Clip1() == 0 then 
            self.animmul = 0
        else
            self.animmul = 1
        end

        if bone then
            self:GetWM():ManipulateBoneScale(bone,self.BoltVec * self.animmul)
        end
    end
end

function SWEP:Shoot()
    if self:GetNextShoot() > CurTime() then
        return
    end

    if self:GetOwner():GetNWBool("otrub") then
        return
    end

    self:PrimaryAdd()

    self:PrimarySpread()

    local primary = self.Primary

    if self:IsLocal() then
        vis_recoil = vis_recoil + primary.Force / 15 * self.RecoilForce
        Recoil = Recoil + 0.25
    end

    local ply = self:GetOwner()

    local ent = hg.GetCurrentCharacter(ply)

    self:SetNextShoot(CurTime() + primary.Wait)

    local Pos,Ang = self:GetTrace()

    if self.Animations["fire"] then
        hg.PlayAnim(self,"fire")
    end

    if SERVER then
        net.Start("hg shoot")
        net.WriteEntity(self)
        net.SendPVS(Pos)

        local proj = ents.Create("ent_rpg7_projectile")
        proj:SetPos(Pos)
        proj:SetAngles(Ang)
        proj:Spawn()
        proj:Launch(Ang:Forward() * 1e8)
        proj:SetOwner(ply)
    end

    if SERVER then
        //print(ent:GetPhysicsObject())
        if IsValid(ent:GetPhysicsObject()) and !ent:IsPlayer() then
            ent:GetPhysicsObject():ApplyForceCenter(-Ang:Forward() * 50)
            ent:GetPhysicsObject():SetVelocity(-Ang:Forward() * 450)
        else
            ent:SetVelocity(-Ang:Forward() * 250)
        end
    end

    if SERVER then
        sound.Play(istable(self.Sound) and self.Sound[math.random(1,#self.Sound)] or self.Sound,Pos,100,math.random(90,110),1)
        sound.Play("pwb/weapons/remington_870/shoot.wav",Pos,100,math.random(90,110),1)
        sound.Play("pwb/weapons/spas_12/shoot.wav",Pos,100,math.random(90,110),1)
    end

    if CLIENT then
        debugoverlay.Line(Pos,Pos + Ang:Forward() * 10000,2,Color(255,255,0))
    end

    local Num = self.NumBullet or 1

    local index = ply:LookupBone("ValveBiped.Bip01_Head1")

    if !IsValid(ent) then
        return  
    end

    if SERVER then
        self:TakePrimaryAmmo(1)
    end

    self:PostShoot(Pos,Ang)
end

SWEP.Animations = {
	["idle"] = {
        Source = "idle",
    },
	["draw"] = {
        Source = "draw",
        MinProgress = 0.5,
        Time = 1
    },
    ["fire"] = {
        Source = "fire",
        MinProgress = 0.5,
        Time = 1
    },
    ["reload"] = {
        Source = "reload",
        MinProgress = 0.5,
        Time = 3
    }
}

SWEP.Reload1 = "weapons/universal/uni_weapon_draw_01.wav"
SWEP.Reload2 = "zcitysnd/sound/weapons/rpg7/handling/rpg7_load2.wav"
SWEP.Reload3 = "weapons/tfa_inss/asval/bash1.wav"
SWEP.Reload4 = false