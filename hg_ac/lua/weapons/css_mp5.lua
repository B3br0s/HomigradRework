AddCSLuaFile()
--[[
game.AddAmmoType({
	name = "9mm"
})
]]
SWEP.Author				= "Ghoul"
SWEP.Purpose			= ""
SWEP.PrintName			= "HK MP5"
SWEP.Slot				= 2
SWEP.SlotPos			= 3
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.ViewModelFOV		= 60
SWEP.IconLetter			= "x"
	
SWEP.Base = "swep_base"
SWEP.Category 			= "Counter Strike: Source"
SWEP.PrintName = "MP5"	
SWEP.ViewModel		= "models/weapons/cstrike/c_smg_mp5.mdl"	
SWEP.WorldModel		= "models/weapons/w_smg_mp5.mdl"
SWEP.UseHands = true
SWEP.ReloadSound		= "Weapon_SMG1.Reload"	
SWEP.HoldType		= "smg"	
SWEP.CSMuzzleFlashes	= true		

SWEP.Weight		= 40		
SWEP.AutoSwitchTo		= true			
SWEP.Spawnable		= true		
		
SWEP.Primary.Sound			= Sound("weapons/mp5navy/mp5-1.wav")
SWEP.Primary.Damage		= 35
SWEP.Primary.NumShots		= 1	
SWEP.Primary.Recoil			= 2		
SWEP.Primary.Cone			= 0.025	
SWEP.Primary.Delay			= 0.08
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize		= 30		
SWEP.Primary.DefaultClip	= 30		
SWEP.Primary.Force			= 3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "SMG1"	
		
SWEP.Secondary.ClipSize		= -1	
SWEP.Secondary.DefaultClip	                  = -1
SWEP.Secondary.Automatic	   = false
SWEP.Secondary.Ammo		= "none"		

SWEP.IronSightsPos = Vector(-5.3, -6.662, 2.0)
SWEP.IronSightsAng = Vector( 1, 0, 0 )

