SWEP.Base = "weapon_base"
SWEP.PrintName = "База Еды"
SWEP.Category = "Еда"
SWEP.Spawnable = false

SWEP.WorldModel = "models/jordfood/canned_burger.mdl"

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true

SWEP.IconPos = Vector(18.5,80,-3)
SWEP.IconAng = Angle(0,90,10)
SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "slam"
SWEP.LastBite = 0
SWEP.Bites = 0
SWEP.Regens = 12
SWEP.ParticleColor = Color(221,107,0)
SWEP.ParticleMat = Material("particle/particle_noisesphere")

SWEP.BiteSounds = "Eat"

SWEP.DrinkSounds = {
    "snd_jack_hmcd_drink1.wav",
    "snd_jack_hmcd_drink2.wav",
    "snd_jack_hmcd_drink3.wav"
}

SWEP.EatSounds = {
    "snd_jack_hmcd_eat1.wav",
    "snd_jack_hmcd_eat2.wav",
    "snd_jack_hmcd_eat3.wav",
    "snd_jack_hmcd_eat4.wav"
}

SWEP.Beton = {
    "physics/concrete/concrete_break2.wav",
    "physics/concrete/concrete_break3.wav",
}

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	local WM = self.WorldModel

	if not IsValid(DrawingModel) then
		DrawingModel = ClientsideModel(self.WorldModel,RENDERGROUP_OPAQUE)
		DrawingModel:SetNoDraw(true)
	else
		DrawingModel:SetModel(self.WorldModel)
		local vec = Vector(18.7,150,-3)
		local ang = Vector(0,-90,0):Angle()

		cam.Start3D( vec, ang, 20, x, y+35, wide, tall, 5, 4096 )
			cam.IgnoreZ( true )
			render.SuppressEngineLighting( true )

			render.SetLightingOrigin( self:GetPos() )
			render.ResetModelLighting( 50/255, 50/255, 50/255 )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 255 )

			render.SetModelLighting( 4, 1, 1, 1 )

			DrawingModel:SetRenderAngles( self.IconAng )
			DrawingModel:SetRenderOrigin( self.IconPos)
			DrawingModel:DrawModel()
			DrawingModel:SetRenderAngles()

			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
		cam.End3D()
	end

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( self.WepSelectIcon2 )

	surface.DrawTexturedRect( x, y + 10,  256 * ScrW()/1920 , 128 * ScrH()/1080 )

	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )

end

function SWEP:Step_Anim()
    local ply = self:GetOwner()

    if self:IsAttacking(ply) then
        hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-50,0),1,0.125)
        hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(10,-20,0),1,0.125)
        hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(60,-20,-20),1,0.125)
    else
        hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,0,0),1,0.125)
        hg.bone.Set(ply,"r_forearm",Vector(0,0,0),Angle(0,0,0),1,0.125)
        hg.bone.Set(ply,"r_hand",Vector(0,0,0),Angle(0,0,0),1,0.125)
        self.LastBite = CurTime() + 0.5
    end
end

function SWEP:IsAttacking(ply)
    if SERVER then
        self:SetNWBool("in_attack",ply:KeyDown(IN_ATTACK))
        return ply:KeyDown(IN_ATTACK)
    else
        return self:GetNWBool("in_attack")
    end
end

function SWEP:Eat()
    local ply = self:GetOwner()
    if SERVER then
        ply.hunger = ply.hunger + self.Regens
    end
end

function SWEP:Step()
    local ply = self:GetOwner()

    if ply:GetActiveWeapon() != self then
        return
    end

    self:Step_Anim()

    if self:IsAttacking(ply) then
        if self.LastBite < CurTime() then
            self.LastBite = CurTime() + 1
            self:Eat()
            self.Bites = self.Bites - 1
            hg.bone.Set(ply,"r_upperarm",Vector(0,0,0),Angle(0,-40,0),1,0.1)
            if SERVER then
                local soundd = ((self.BiteSounds != "BETON" and (!self.BiteSounds and table.Random(self.DrinkSounds) or table.Random(self.EatSounds))) or table.Random(self.Beton))
                if isstring(soundd) then
                    sound.Play(soundd,self:GetPos(),75,100,1)
                end
            end
            if CLIENT and ply == LocalPlayer() then
                ViewPunch(Angle(5,0,0))
            end
            if SERVER and self.Bites <= 0 then
                self:Remove()
            end
        end
    end
end

function SWEP:Initialize()
    hg.Weapons[self] = true
    self:SetHoldType(self.HoldType)

    self.Bites = math.random(3,4)
end

function SWEP:Deploy()
    self:SetHoldType(self.HoldType)
end

function SWEP:Holster()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
    end
    return true
end

function SWEP:OnRemove()
    if IsValid(self.worldModel) then
        DropProp(self.WorldModel,1,self.worldModel:GetPos(),self.worldModel:GetAngles(),Vector(0,0,0) - self.worldModel:GetAngles():Up() * 150,VectorRand(-250,250))
        self.worldModel:Remove()
    end
end

function SWEP:OwnerChanged()
    if IsValid(self.worldModel) then
        self.worldModel:Remove()
    end
end

//govno
function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end