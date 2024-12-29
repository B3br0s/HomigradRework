AddCSLuaFile()
--[[
game.AddAmmoType({
	name = "75.Call"
})
]]
SWEP.Author				= "Ghoul"
SWEP.Purpose			= ""
SWEP.PrintName			= "Glock 18"
SWEP.Slot				= 1
SWEP.SlotPos			= 3
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.ViewModelFOV		= 54
SWEP.IconLetter			= "x"
	
SWEP.Base = "swep_base"
SWEP.Category 			= "Counter Strike: Source"
SWEP.ViewModel		= "models/weapons/cstrike/c_pist_glock18.mdl"	
SWEP.WorldModel		= "models/weapons/w_pist_glock18.mdl"	
SWEP.UseHands = true
SWEP.ReloadSound		= "Weapon_SMG1.Reload"	
SWEP.HoldType		= "pistol"	
SWEP.CSMuzzleFlashes	= true		

SWEP.Weight		= 40		
SWEP.AutoSwitchTo		= true			
SWEP.Spawnable		= true		

SWEP.Primary.Sound			= Sound("weapons/glock/glock18-1.wav")
SWEP.Primary.Damage		= 23
SWEP.Primary.NumShots		= 0	
SWEP.Primary.Recoil			= 10.5			
SWEP.Primary.Cone			= 0.01	
SWEP.Primary.Delay			= 0.2
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize		= 20		
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Force			= 3
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "Pistol"

SWEP.data 				= {}
SWEP.mode 				= "semi"
		
SWEP.Secondary.ClipSize		= -1	
SWEP.Secondary.DefaultClip	                  = -1
SWEP.Secondary.Automatic	   = false
SWEP.Secondary.Ammo		= "none"	

SWEP.IronSightsPos = Vector(-5.78, -2.52, 2.712)
SWEP.IronSightsAng = Vector(0.712, 0.018, 0)
