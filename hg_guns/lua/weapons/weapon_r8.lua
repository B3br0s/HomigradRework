SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "R8"
SWEP.Author = "Homigrad"
SWEP.Instructions = "\n5 выстрелов в секунду\n50 Урона\n0.001 Разброс"
SWEP.Category = "Оружие - Пистолеты"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/arccw_go/v_pist_r8.mdl"

SWEP.weaponInvCategory = 2
SWEP.ShellEject = "EjectBrass_9mm"
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ".44 Remington Magnum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 50
SWEP.Primary.Sound = {"arccw_go/revolver/revolver-1_01.wav", 75, 100, 100}
SWEP.Primary.Force = 45
SWEP.Primary.Spread = 0.001
SWEP.Primary.Wait = 1 / 5
SWEP.ReloadTime = 2.3
SWEP.DeploySnd = {"homigrad/weapons/draw_pistol.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/holster_pistol.mp3", 55, 100, 110}
SWEP.HoldType = "revolver"
SWEP.ZoomPos = Vector(0, -0.02, 20)
SWEP.RHandPos = Vector(-12, -4.9, 5)
SWEP.LHandPos = false
SWEP.SprayRand = {Angle(-1.03, -0.03, 0), Angle(-1.05, 0.03, 0)}
SWEP.Ergonomics = 1.2
SWEP.Penetration = 7
SWEP.WorldPos = Vector(-13, -5.1, -7.1)
SWEP.WorldAng = Angle(0,  0, 0)
SWEP.attPos = Vector(3.8, 0.9, 25)
SWEP.attAng = Angle(0,0.55,0)
SWEP.UseCustomWorldModel = true
SWEP.lengthSub = 25
SWEP.DistSound = "arccw_go/revolver/revolver-1_distant.wav"
SWEP.holsteredBone = "ValveBiped.Bip01_Pelvis"
SWEP.holsteredPos = Vector(12, 20, -3.5)
SWEP.holsteredAng = Angle(0, -90, -90)
SWEP.RecoilAnim = 3
SWEP.CustomShoot = true
SWEP.EjectPos = Vector(-2281337,-2281337,-2281337)
SWEP.EjectAng = Angle(-2281337,-2281337,-2281337)
SWEP.LastHammerClick = 0
SWEP.HammerProgress = 0
SWEP.Shooted = false
SWEP.IconAng = Angle(-25,0,0)
SWEP.IconPos = Vector(0.7,100,-7)

SWEP.BoltBone = "v_weapon.hammer"
SWEP.BoltMul = Vector(0,0,0)

SWEP.DrumBone = "v_weapon.cylinder"

if SERVER then
    util.AddNetworkString("r8_shoot")
else
    net.Receive("r8_shoot",function()
        local wep = net.ReadEntity()

        wep:Shoot()
    end)
end

function SWEP:AddThinkNigga()
    local ply = self:GetOwner()
    if ply.Fake then return end
    if SERVER then
        self:SetNWFloat("r8_progress",self.HammerProgress)
    else
        self.HammerProgress = LerpFT(0.35,self.HammerProgress,self:GetNWFloat("r8_progress"))
        if GetConVar("hg_boltanims"):GetBool() != true then return end
            self.worldModel:ManipulateBoneAngles(self.worldModel:LookupBone(self.BoltBone),Angle(0,0,-45 * self.HammerProgress)) --без неток(((
            self.worldModel:ManipulateBoneAngles(self.worldModel:LookupBone(self.DrumBone),Angle(-45 * self.HammerProgress,0,0))
    end
    if ply:KeyDown(IN_ATTACK) then
        if self.LastHammerClick < CurTime() then
            if SERVER then
                sound.Play("arccw_go/revolver/revolver_prepare.wav",self:GetPos(),75,100,1,0)
            end
        end
        if SERVER and not self.Shooted then
        self.HammerProgress = math.Round(LerpFT(0.25,self.HammerProgress,1),2)

            if self.HammerProgress > 0.985 and not self.Shooted then
                self.Shooted = true
                self:Shoot()
                net.Start("r8_shoot")--баланда колючая ограда,мокрый черенок швабры 
                net.WriteEntity(self)
                net.Broadcast()
            end
        elseif SERVER and self.Shooted then
            self.HammerProgress = 0
        end
        self.LastHammerClick = CurTime() + 0.05
    else
        if SERVER then
            self.HammerProgress = math.Round(LerpFT(0.25,self.HammerProgress,0.0001),2)
        
            self.Shooted = false
        end
    end
end