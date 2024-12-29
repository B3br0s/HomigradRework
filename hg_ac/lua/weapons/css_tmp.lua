AddCSLuaFile()
--[[
game.AddAmmoType({
	name = "7.64"
})
]]
SWEP.Author				= "Ghoul"
SWEP.Purpose			= ""
SWEP.PrintName			= "Steyr TMP"
SWEP.Slot				= 3
SWEP.SlotPos			= 3
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.ViewModelFOV		= 54
SWEP.IconLetter			= "x"

SWEP.Base = "swep_base"
SWEP.Category 			= "Counter Strike: Source"
SWEP.PrintName = "TMP"	
SWEP.ViewModel		= "models/weapons/cstrike/c_smg_tmp.mdl"	
SWEP.WorldModel		= "models/weapons/w_smg_tmp.mdl"
SWEP.UseHands = true
SWEP.ReloadSound		= "Weapon_SMG1.Reload"	
SWEP.HoldType		= "ar2"	
SWEP.CSMuzzleFlashes	= true		

SWEP.Weight		= 40		
SWEP.AutoSwitchTo		= true			
SWEP.Spawnable		= true		

SWEP.Primary.Sound			= Sound("weapons/tmp/tmp-1.wav")
SWEP.Primary.Damage		= 35
SWEP.Primary.NumShots		= 0	
SWEP.Primary.Recoil			= 1			
SWEP.Primary.Cone			= 0.01	
SWEP.Primary.Delay			= 0.09
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
SWEP.IronSightsPos = Vector(-6.93, -3.837, 2.3)
SWEP.IronSightsAng = Vector(1.0, 0, 0)


