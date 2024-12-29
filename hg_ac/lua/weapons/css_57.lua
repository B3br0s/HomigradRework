AddCSLuaFile()
--[[
game.AddAmmoType({
	name = "51.Call"
})
]]
SWEP.Author				= "Ghoul"
SWEP.Purpose			= ""
SWEP.PrintName			= "Five-Seven"
SWEP.Slot				= 1
SWEP.SlotPos			= 3
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.ViewModelFOV		= 60
SWEP.IconLetter			= "x"
	
SWEP.Base = "swep_base"
SWEP.Category 			= "Counter Strike: Source"
SWEP.PrintName = "Five-Seven"	
SWEP.ViewModel		= "models/weapons/cstrike/c_pist_fiveseven.mdl"	
SWEP.WorldModel		= "models/weapons/w_pist_fiveseven.mdl"
SWEP.UseHands = true
SWEP.ReloadSound		= "Weapon_SMG1.Reload"	
SWEP.HoldType		= "pistol"	
SWEP.CSMuzzleFlashes	= true		

SWEP.Weight		= 40		
SWEP.AutoSwitchTo		= true			
SWEP.Spawnable		= true		
		
SWEP.Primary.Sound			= Sound("weapons/fiveseven/fiveseven-1.wav")
SWEP.Primary.Damage		= 45
SWEP.Primary.NumShots		= 0	
SWEP.Primary.Recoil			= 1			
SWEP.Primary.Cone			= 0.02	
SWEP.Primary.Delay			= 0.12
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize		= 20	
SWEP.Primary.DefaultClip	= 20	
SWEP.Primary.Force			= 9
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "Pistol"	
		
SWEP.Secondary.ClipSize		= -1	
SWEP.Secondary.DefaultClip	                  = -1
SWEP.Secondary.Automatic	   = false
SWEP.Secondary.Ammo		= "none"		

SWEP.IronSightsPos 		= Vector( -5.9, -4, 2.9 )

