AddCSLuaFile()
--[[
game.AddAmmoType({
	name = "90.Call"
})
]]
SWEP.Author				= "Ghoul"
SWEP.Purpose			= ""
SWEP.PrintName			= "M249 Para"
SWEP.Slot				= 2
SWEP.SlotPos			= 3
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.ViewModelFOV		= 63
SWEP.IconLetter			= "x"

SWEP.Base = "swep_base"
SWEP.Category 			= "Counter Strike: Source"
SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"
SWEP.UseHands = true
SWEP.ReloadSound		= "Weapon_SMG1.Reload"	
SWEP.HoldType 					= "ar2"	
SWEP.CSMuzzleFlashes	= true		

SWEP.Weight		= 40		
SWEP.AutoSwitchTo		= true			
SWEP.Spawnable		= true		
	
SWEP.Primary.Sound			= Sound("weapons/m249/m249-1.wav")
SWEP.Primary.UnsilSound	 	= Sound( "Weapon_AK47.Single" )
SWEP.Primary.SilSound	 	= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Damage		= 38
SWEP.Primary.NumShots		= 0	
SWEP.Primary.Recoil			= 1			
SWEP.Primary.Cone			= 0.02		
SWEP.Primary.Delay			= 0.07
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Force			= 3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "AR2"
		
SWEP.Secondary.ClipSize		= -1	
SWEP.Secondary.DefaultClip	                  = -1
SWEP.Secondary.Automatic	   = false
SWEP.Secondary.Ammo		= "none"	

SWEP.UseHands = true	

SWEP.IronSightsPos = Vector(-6.0, -4.85, 1.9)
SWEP.IronSightsAng = Vector(1, -0, -0)
