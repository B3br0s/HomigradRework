AddCSLuaFile()
--[[
game.AddAmmoType({
	name = "50.Call"
})
]]
SWEP.Author				= "Ghoul"
SWEP.Purpose			= ""
SWEP.PrintName			= "Desert Deagle"
SWEP.Slot				= 1
SWEP.SlotPos			= 3
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.ViewModelFOV		= 60
SWEP.IconLetter			= "x"
	
SWEP.Base = "swep_base"
SWEP.Category 			= "Counter Strike: Source"
SWEP.ViewModel		= "models/weapons/cstrike/c_pist_deagle.mdl"	
SWEP.WorldModel		= "models/weapons/w_pist_deagle.mdl"
SWEP.UseHands = true
SWEP.ReloadSound		= "Weapon_SMG1.Reload"	
SWEP.HoldType		= "pistol"	
SWEP.CSMuzzleFlashes	= true		

SWEP.Weight		= 40		
SWEP.AutoSwitchTo		= true			
SWEP.Spawnable		= true		
		
SWEP.Primary.Sound			= Sound("weapons/deagle/deagle-1.wav")
SWEP.Primary.Damage		= 60
SWEP.Primary.NumShots		= 0	
SWEP.Primary.Recoil			= 3			
SWEP.Primary.Cone			= 0.02		
SWEP.Primary.Delay			= 0.3
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize		= 7		
SWEP.Primary.DefaultClip	= 7		
SWEP.Primary.Force			= 100
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "357"	
		
SWEP.Secondary.ClipSize		= -1	
SWEP.Secondary.DefaultClip	                  = -1
SWEP.Secondary.Automatic	   = false
SWEP.Secondary.Ammo		= "none"		
SWEP.IronSightsPos 		= Vector( -6.35, -2, 2.05 )
SWEP.IronSightsAng 		= Vector( 0.2, 0, 0 )

