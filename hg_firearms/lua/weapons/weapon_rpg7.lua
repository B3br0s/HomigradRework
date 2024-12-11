if engine.ActiveGamemode() == "homigradcom" then
    SWEP.Base = 'b3bros_base' -- base
    
    SWEP.PrintName 				= "РПГ-7"
    SWEP.Author 				= "HG:R"
    SWEP.Category 				= "Оружие: Взрывчатое"
    SWEP.Spawnable 				= true
    SWEP.AdminOnly 				= false
    SWEP.ViewModel				= "models/weapons/tfa_ins2/c_rpg.mdl"
    SWEP.CorrectModel           = "models/weapons/tfa_ins2/c_rpg.mdl"
    SWEP.WorldModel				= "models/weapons/tfa_ins2/w_rpg.mdl"
    
    SWEP.Primary.ClipSize		= 1
    SWEP.Primary.DefaultClip	= 1
    SWEP.Primary.Automatic		= false
    SWEP.Primary.Ammo			= "RPG_Round"
    SWEP.Primary.Cone = 0
    SWEP.Primary.Damage = 1.5 * 75
    SWEP.Primary.Spread = 0
    SWEP.Primary.Sound = {"zcitysnd/sound/weapons/rpg7/rpg7_fp.wav"}
    SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/rpg7/rpg7_dist.wav"
    SWEP.ReloadTime = 2
    SWEP.TwoHands = true
    SWEP.ShootWait = 0.1
    SWEP.HoldType = "rpg"
    SWEP.EmptyBoltOut = true
    SWEP.ShellType = nil
    SWEP.AdminOnly = true
    SWEP.AdminSpawnable = true

    SWEP.SlideBone = "RPG_Warhead"
    SWEP.SlideVector = Vector(0, 0, -99999) 

    SWEP.CameraPos = Vector(8,6,-0.05)
    
    SWEP.Slot					= 2
    SWEP.SlotPos				= 0

    SWEP.Reload1 = ""
    SWEP.Reload2 = "zcitysnd/sound/weapons/rpg7/handling/rpg7_load1.wav"
    SWEP.Reload3 = ""
    SWEP.Reload4 = "zcitysnd/sound/weapons/rpg7/handling/rpg7_load2.wav"

    SWEP.DeploySound = "zcitysnd/sound/weapons/ak47/handling/ak47_rattle.wav"

    SWEP.SlideBone = nil    
    
    SWEP.CorrectPosX = -3
    SWEP.CorrectPosY = 4.52
    SWEP.CorrectPosZ = -6.7
    
    SWEP.CorrectAngPitch = -5
    SWEP.CorrectAngYaw = 0
    SWEP.CorrectAngRoll = 180

    SWEP.MuzzleFXPos = Vector(28,0,0)
    SWEP.UsingVM = true
    SWEP.addAng = Angle(-4.7,-0.4,0)
    SWEP.addPos = Vector(0,-1.6,5.2)

    SWEP.Fake1 = Vector(5,0,0)
    SWEP.Fake2 = Vector(17,0,0)

    function SWEP:CustomThink()
        if SERVER then return end
        if self:Clip1() < 1 then
            self.ClientModel:ManipulateBonePosition(self.ClientModel:LookupBone("RPG_Warhead"),Vector(0,0,-999))
        else
            self.ClientModel:ManipulateBonePosition(self.ClientModel:LookupBone("RPG_Warhead"),Vector(0,0,0)) 
        end
    end

    function SWEP:PrimaryAttack()
        if self.isClose then
            return
        end
        if self:Clip1() <= 0 then return end
        self:EmitSound(self.Primary.Sound[1])
        local shotpos = self:GetOwner():GetAttachment(self:GetOwner():LookupAttachment("anim_attachment_RH")).Pos

        if SERVER then 
            local rocket = ents.Create( "gb_rocket_rp3" )
            rocket:SetPos(shotpos)
            rocket:SetAngles(self:GetOwner():EyeAngles()-Angle(-7,0,0))
            rocket:Spawn()
            rocket:Launch()
            --rocket:SetAngles(self:GetOwner():EyeAngles()+Angle(-7,0,0))
            rocket:SetNoDraw(true)
            timer.Simple(0.23,function()
                rocket:SetNoDraw(false)
            end)
        end
        self:TakePrimaryAmmo(1)
    end
end