AddCSLuaFile()
--[[
game.AddAmmoType({
	name = "7.62"
})
]]
SWEP.Author				= "Ghoul"
SWEP.Purpose			= ""
SWEP.PrintName			= "AK-47"
SWEP.Slot				= 2
SWEP.SlotPos			= 3
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.ViewModelFOV		= 60
SWEP.IconLetter			= "x"

if (CLIENT) then
	killicon.AddFont( "weapon_ak47", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end
	
SWEP.Base = "swep_base"
SWEP.Category 			= "Counter Strike: Source"
SWEP.PrintName = "AK-47"	
SWEP.ViewModel		= "models/weapons/cstrike/c_rif_ak47.mdl"	
SWEP.WorldModel		= "models/weapons/w_rif_ak47.mdl"	
SWEP.UseHands				= true;
SWEP.ReloadSound		= "Weapon_SMG1.Reload"	
SWEP.HoldType 					= "ar2"
SWEP.CSMuzzleFlashes	= true		

SWEP.Weight		= 40		
SWEP.AutoSwitchTo		= true			
SWEP.Spawnable		= true		
		
SWEP.Primary.Sound			= Sound("weapons/ak47/ak47-1.wav")
SWEP.Primary.Damage		= 45
SWEP.Primary.NumShots		= 0	
SWEP.Primary.Recoil			= 1			
SWEP.Primary.Cone			= 0.02	
SWEP.Primary.Delay			= 0.1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize		= 30		
SWEP.Primary.DefaultClip	= 30	
SWEP.Primary.Force			= 3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "AR2"	
	
SWEP.Secondary.ClipSize		= -1	
SWEP.Secondary.DefaultClip	                  = -1
SWEP.Secondary.Automatic	   = false
SWEP.Secondary.Ammo		= "none"		
SWEP.IronSightsPos 		= Vector( -6.65, -15, 2.75 )
SWEP.IronSightsAng 		= Vector( 2.6, 0, 0 )

SWEP.UseHands = true	

