if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "AR-15"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Полуавтоматическая винтовка под калибр 5,56х45"
SWEP.Category 				= "Оружие"
SWEP.WepSelectIcon			= "pwb2/vgui/weapons/m4a1"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1.7 * 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "m4a1/m4a1_fp.wav"
SWEP.Primary.SoundFar = "m4a1/m4a1_dist.wav"
SWEP.Primary.Force = 160/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.08
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

------------------------------------------

function SWEP:Initialize()
    if CLIENT then return end -- Only run on server side

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    -- Check if the SWEP already has an attached silencer
    if IsValid(self.SilencerModel) then
        ply:ChatPrint("Silencer is already attached.")
        return
    end

    -- Spawn the silencer model
    local silencer = ents.Create("prop_physics")
    if not IsValid(silencer) then return end
    silencer:SetModel(modelPath)
    silencer:SetMoveType(MOVETYPE_NONE) -- Prevents the prop from moving
    silencer:SetSolid(SOLID_NONE) -- Make it non-solid, just for visual attachment
    silencer:Spawn()

    -- Attach the silencer to the SWEP
    silencer:SetParent(self) -- Attach it to the SWEP itself
    silencer:FollowBone(self, self:LookupBone("ValveBiped.Bip01_R_Hand") or 0) -- Attach to the SWEP's hand bone

    -- Adjust the local position and angles for proper placement on the weapon
    silencer:SetLocalPos(Vector(25, 0, -5)) -- Adjust these values to position it correctly
    silencer:SetLocalAngles(Angle(0, 0, 0)) -- Adjust these angles if needed

    -- Save a reference to the silencer so we can check if it's already attached
    self.SilencerModel = silencer

    ply:ChatPrint("Silencer attached to weapon.")
        end

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb2/weapons/w_m4a1.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_m4a1.mdl"

SWEP.vbwPos = Vector(-4,-4.2,1)
SWEP.vbwAng = Angle(7,-30,0)
end