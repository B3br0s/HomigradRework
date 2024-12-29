AddCSLuaFile()
--[[
game.AddAmmoType({
	name = "7.66"
})
]]
SWEP.Author				= "Ghoul"
SWEP.Purpose			= ""
SWEP.PrintName			= "Ingram Mac10"
SWEP.Slot				= 2
SWEP.SlotPos			= 3
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.ViewModelFOV		= 60
SWEP.IconLetter			= "x"

SWEP.Base = "swep_base"
SWEP.Category 			= "Counter Strike: Source"
SWEP.PrintName = "Mac10"	
SWEP.ViewModel		= "models/weapons/cstrike/c_smg_mac10.mdl"	
SWEP.WorldModel		= "models/weapons/w_smg_mac10.mdl"
SWEP.UseHands = true
SWEP.ReloadSound		= "Weapon_SMG1.Reload"	
SWEP.HoldType		= "pistol"	
SWEP.CSMuzzleFlashes	= true		

SWEP.Weight		= 40		
SWEP.AutoSwitchTo		= true			
SWEP.Spawnable		= true		

SWEP.Primary.Sound			= Sound("weapons/mac10/mac10-1.wav")
SWEP.Primary.Damage		= 12
SWEP.Primary.NumShots		= 0	
SWEP.Primary.Recoil			= 2			
SWEP.Primary.Cone			= 0.01
SWEP.Primary.Delay			= 0.08
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize		= 50		
SWEP.Primary.DefaultClip	= 50		
SWEP.Primary.Force			= 3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "Pistol"	
		
SWEP.Secondary.ClipSize		= -1	
SWEP.Secondary.DefaultClip	                  = -1
SWEP.Secondary.Automatic	   = true
SWEP.Secondary.Ammo		= "none"		
SWEP.IronSightsPos = Vector(-9.5, -3.116, 2.799)
SWEP.IronSightsAng = Vector(1.263, -5.1, -6.87)

