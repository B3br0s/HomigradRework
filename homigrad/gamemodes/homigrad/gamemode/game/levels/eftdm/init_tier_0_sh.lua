table.insert(LevelList,"eft")
eft = {}
eft.Name = "EFT"

eft.red = {"BEAR",Color(125,95,60),
	weapons = {"weapon_hands","weapon_kabar"},
	main_weapon = {"weapon_ar15","weapon_civil_famas","weapon_mp40","weapon_mp5","weapon_galil","weapon_mk18","weapon_ump","weapon_fal","weapon_m1garand","weapon_m3super","weapon_m4a1","weapon_mag7","weapon_mp7","weapon_remington870","weapon_beanbag","weapon_m1a1","weapon_spas12","weapon_l1a1","weapon_m14","weapon_xm1014","weapon_akm","weapon_ak74u","weapon_galilsar","weapon_rpk","weapon_sks","weapon_saiga12"},
	secondary_weapon = {"weapon_p220","weapon_glock18","weapon_glock","weapon_hk_usp","weapon_hk_usps","weapon_beretta","weapon_fiveseven","weapon_r8","weapon_makarov","weapon_deagle"},
	models = {"models/eft/pmcs/bear_extended_pm.mdl"}
}


eft.blue = {"USEC",Color(75,75,125),
	weapons = {"weapon_hands","weapon_kabar"},
	main_weapon = {"weapon_ar15","weapon_civil_famas","weapon_mp40","weapon_mp5","weapon_galil","weapon_mk18","weapon_ump","weapon_fal","weapon_m1garand","weapon_m3super","weapon_m4a1","weapon_mag7","weapon_mp7","weapon_remington870","weapon_beanbag","weapon_m1a1","weapon_spas12","weapon_l1a1","weapon_m14","weapon_xm1014","weapon_akm","weapon_ak74u","weapon_galilsar","weapon_rpk","weapon_sks","weapon_saiga12"},
	secondary_weapon = {"weapon_p220","weapon_glock18","weapon_glock","weapon_hk_usp","weapon_hk_usps","weapon_beretta","weapon_fiveseven","weapon_r8","weapon_makarov","weapon_deagle"},
	models = {"models/eft/pmcs/bear_extended_pm.mdl"}
}

eft.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function eft.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,eft.red[2])
	team.SetColor(2,eft.blue[2])

	if CLIENT then

		eft.StartRoundCL()
		return
	end

	eft.StartRoundSV()
end
eft.RoundRandomDefalut = 2
eft.SupportCenter = true
