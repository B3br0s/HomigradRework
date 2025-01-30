AddCSLuaFile()

-- if ( CLIENT ) then return end

include("eft_s_precache.lua")

CreateConVar("eft_s_enable" , "1" , "","", 0 , 1)
CreateConVar("eft_s_enable_npcs" , "1" , "","", 0 , 1)
CreateConVar("eft_s_enable_combine_glass" , "1" , "","", 0 , 1)
CreateConVar("eft_s_volume_helmet" , "1" , "","", 0 , 10)
CreateConVar("eft_s_volume_headshot_noarmor" , "1" , "","", 0 , 10)
CreateConVar("eft_s_volume_headshot_kill" , "1" , "","", 0 , 10)
CreateConVar("eft_s_volume_bodyshot_kevlar" , "1" , "","", 0 , 10)
CreateConVar("eft_s_sparks" , "any" , "","")

eft_s_enable 					= GetConVar("eft_s_enable")
eft_s_enable_npcs 				= GetConVar("eft_s_enable_npcs")
eft_s_enable_combine_glass 		= GetConVar("eft_s_enable_combine_glass")
eft_s_volume_helmet				= GetConVar("eft_s_volume_helmet")
eft_s_volume_headshot_noarmor	= GetConVar("eft_s_volume_headshot_noarmor")
eft_s_volume_headshot_kill		= GetConVar("eft_s_volume_headshot_kill")
eft_s_volume_bodyshot_kevlar	= GetConVar("eft_s_volume_bodyshot_kevlar")
eft_s_sparks					= GetConVar("eft_s_sparks")

if SERVER then

	timer.Create( "eft_fx_jmod", 1 , 0, function()
		print("WAITING FOR JMOD")

		if JMod then

			print("GOT JMOD :D")					
		    function JMod.GetItemInSlot(armorTable, slot)
		        if not (armorTable and armorTable.items) then return nil end

		        for id, armorData in pairs(armorTable.items) do
		            local ArmorInfo = JMod.ArmorTable[armorData.name]
		            if ArmorInfo.slots[slot] then return id, armorData, ArmorInfo end
		        end

		        return nil
		    end
		    timer.Destroy("eft_fx_jmod")
							
		end
		
	end)

	local function IsHitToFace(ply, dmg)
		local FacingDir, DmgDir = ply:GetAimVector(), dmg:GetDamageForce():GetNormalized()
		local ApproachAngle = -math.deg(math.asin(DmgDir:Dot(FacingDir)))

		return ApproachAngle > 45
	end

	function EFT_S_NPC_HELMET_HEADSHOT( ent , hitgroup , dmginfo )
		if not IsValid( ent ) or ent:IsPlayer() == true or eft_s_enable:GetInt() == 0 or eft_s_sparks:GetString() == "combine only" then return 
		end
		
		local attacker					=	dmginfo:GetAttacker()
		local plyangle					=	attacker:GetAngles()
		local dmgpos					=	dmginfo:GetDamagePosition()
		
		if hitgroup == HITGROUP_HEAD then
			
			if not IsValid( attacker ) or attacker:IsPlayer() == true or attacker:IsNPC() and eft_s_enable_npcs:GetBool()  == true then
													
				ParticleEffect( "impact_helmet_headshot_csgo" , dmginfo:GetDamagePosition(), Angle(plyangle), nil)				
				local randomizer = math.random( 1 , 4 )
				ent:EmitSound( "eft/impact/impact_helmet_1p_" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_helmet:GetFloat() )			
								
			end
			
		end
		
	end

	function EFT_S_NPC_FLESH_HEADSHOT( ent , hitgroup , dmginfo )
		if not IsValid( ent ) or ent:IsPlayer() == true or eft_s_enable:GetInt() == 0 or ent:GetClass() == "npc_combine_s" or eft_s_sparks:GetString () == "any" then return 
		end
			
		-- print( "target health " .. ent:Health() .. " my damage " .. dmginfo:GetDamage()*2 )
		
		local attacker					=	dmginfo:GetAttacker()
		local plyangle					=	attacker:GetAngles()
		local dmgpos					=	dmginfo:GetDamagePosition()
		
		if hitgroup == HITGROUP_HEAD then
			
			if not IsValid( attacker ) or attacker:IsPlayer() == true or attacker:IsNPC() and eft_s_enable_npcs:GetBool() == true then
													
				if ent:Health() > dmginfo:GetDamage()*2 then
				
					local randomizer = math.random( 1 , 6 )
					--ent:EmitSound( "headshot_eft/headshot_nohelm" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_headshot_kill:GetFloat() )
					ent:EmitSound( "eft/impact/body" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_headshot_kill:GetFloat() )				
					
				end	
								
			end
			
		end
		
	end

	function EFT_S_NPC_COMBINE_HEADSHOT( ent , hitgroup , dmginfo )
		if not IsValid( ent ) or ent:IsPlayer() == true or eft_s_enable:GetInt() == 0 or eft_s_sparks:GetString() == "any" then return 
		end
		
		-- print("eft_s_sparks from npc comb " .. eft_s_sparks:GetString())
		
		local attacker					=	dmginfo:GetAttacker()
		local plyangle					=	attacker:GetAngles()
		local dmgpos					=	dmginfo:GetDamagePosition()
		
		if hitgroup == HITGROUP_HEAD && ent:GetClass() == "npc_combine_s" then
			local randomizer = math.random( 1 , 4 )

			if IsHitToFace(ent,dmginfo) == true and eft_s_enable_combine_glass:GetInt() == 1 then
					local particleSound		=	ents.Create( "env_spark" )					
					ParticleEffect( "impact_helmet_headshot_csgo" , dmginfo:GetDamagePosition(), Angle(plyangle), nil)																
					--ent:EmitSound( "headshot_eft/headshot_eft.wav" , 75 , 100 , eft_s_volume_helmet:GetFloat() )
					ent:EmitSound( "eft/impact/impact_glassshield_1p_" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_helmet:GetFloat() )

			end

			if not IsValid( attacker ) or attacker:IsPlayer() == true or attacker:IsNPC() and eft_s_enable_npcs:GetBool() == true then
													
				ParticleEffect( "impact_helmet_headshot_csgo" , dmginfo:GetDamagePosition(), Angle(plyangle), nil)																
				--ent:EmitSound( "headshot_eft/headshot_eft.wav" , 75 , 100 , eft_s_volume_helmet:GetFloat() )
				ent:EmitSound( "eft/impact/impact_helmet_1p_" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_helmet:GetFloat() )	
								
			end
			
		end
		
	end

	function EFT_S_NPC_COMBINE_BODYSHOT( ent , hitgroup , dmginfo )
		if not IsValid( ent ) or ent:IsPlayer() == true or eft_s_enable:GetInt() == 0 then return 
		end
		
		local attacker					=	dmginfo:GetAttacker()
		local plyangle					=	attacker:GetAngles()
		
		if hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_GEAR or HITGROUP_GENERIC  then
			
			-- print(ent:GetClass())
			if ( ent:GetClass() == "npc_combine_s" or ent:GetClass() == "npc_metropolice" ) then 
			
				if attacker:IsPlayer() == true or attacker:IsNPC() and eft_s_enable_npcs:GetBool() == true then
					
					
						local particleSound		=	ents.Create( "env_spark" )
						local randomizer = math.random( 1 , 4 )
						
						particleSound:SetPos( dmginfo:GetDamagePosition() )
						particleSound:Spawn()					
						--particleSound:EmitSound( "bodyshot_eft/kevlar" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_bodyshot_kevlar:GetFloat() )	
						particleSound:EmitSound( "eft/impact/bodyarmor" .. randomizer .. "_fp.wav" , 75 , 100 , eft_s_volume_bodyshot_kevlar:GetFloat() )	
						
						-- print("bodyshot random " .. randomizer )
						
						timer.Simple( 0.05 , function()
							
							if IsValid( particleSound ) then
								
								particleSound:Remove()
								
							end
							
						end)

				end
				
			end
			
		end
		
	end

	function EFT_S_ON_NPC_KILL_HEADSHOT( target , hitgroup , dmginfo )

		if not IsValid( target ) or target:IsPlayer() == true or eft_s_enable:GetInt() == 0 then return 
		end
		
		local attacker				=	dmginfo:GetAttacker()
		
		if hitgroup == HITGROUP_HEAD then
			
			-- print( "ogey 1" )
			
			if attacker:IsPlayer() == true or attacker:IsNPC() and eft_s_enable_npcs:GetBool() == true then
				
				-- local number = attacker:EntIndex()
				-- local targetnumber = target:EntIndex()
				
				-- -- print( "GetDamage() " .. dmginfo:GetDamage() )
				-- somehow dmginfo:GetDamage() number is halved??
				-- -- print( "Health() " .. target:Health() )
				-- -- print( "GetMaxHealth() " .. target:GetMaxHealth() )
				-- -- print( "GetDamageType() " .. dmginfo:GetDamageType() )
				-- -- print( "" )
				
				if dmginfo:GetDamage()*2 >= target:Health() then
				
					local randomizer = math.random( 1 , 6 )
					--target:EmitSound( "headshot_eft/headshot_nohelm" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_headshot_kill:GetFloat() )	
					target:EmitSound( "eft/impact/body" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_headshot_kill:GetFloat() )	
					-- -- print( "nohelm randomizer " .. randomizer )	
					
				end
				
			end
			
		end
		
	end

	function EFT_S_PLAYER_SHOTS( ply , hitgroup , dmginfo )
		if not IsValid( ply ) or eft_s_enable:GetInt() == 0 then return 
		end
		
		local attacker					=	dmginfo:GetAttacker()
		
		if hitgroup == HITGROUP_HEAD then


			local ItemID, ItemData, ItemInfo = JMod.GetItemInSlot( ply.EZarmor, "eyes" )
			local GlassShields = {"ent_jack_gmod_ezarmor_koplak1svisor", "ent_jack_gmod_ezarmor_fastmtshield", "ent_jack_gmod_ezarmor_caimanvisor", 
			"ent_jack_gmod_ezarmor_kivermshield", "ent_jack_gmod_ezarmor_lshz2dtmshield", "ent_jack_gmod_ezarmor_vulkan5shield", "ent_jack_gmod_ezarmor_altynface",
			"ent_jack_gmod_ezarmor_rystface", "ent_jack_gmod_ezarmor_fastmtvisor", "ent_jack_gmod_ezarmor_rioth", "ent_jack_gmod_ezarmor_riot"}
			local MetalShields = {"ent_jack_gmod_ezarmor_shlemmask", "ent_jack_gmod_ezarmor_shlemmaskkilla", "ent_jack_gmod_ezarmor_devtacronin", "ent_jack_gmod_ezarmor_weldinggorilla", 
			"ent_jack_gmod_ezarmor_weldingkill", "ent_jack_gmod_ezarmor_maska", "ent_jack_gmod_ezarmor_balmask"}

			if JMod.GetItemInSlot(ply.EZarmor, "eyes") != nil and IsHitToFace(ply,dmginfo) == true and ItemData.tgl == false then
					local particleSound		=	ents.Create( "env_spark" )
					local randomizer = math.random( 1 , 4 )
					
					particleSound:SetPos( dmginfo:GetDamagePosition() )
					particleSound:Spawn()
					ParticleEffect( "impact_helmet_headshot_csgo" , dmginfo:GetDamagePosition(), Angle(attacker:GetAngles()), nil)

					if table.HasValue(GlassShields, ItemInfo.ent)  then
						particleSound:EmitSound( "eft/impact/impact_glassshield_1p_" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_helmet:GetFloat() )	
					elseif table.HasValue(MetalShields, ItemInfo.ent) then
						particleSound:EmitSound( "eft/impact/impact_helmet_1p_" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_helmet:GetFloat() )
					else

					end

					timer.Simple( 0.05 , function()
						
						if IsValid( particleSound ) then
							
							particleSound:Remove()
							
						end
						
					end)
			end

			if attacker:IsPlayer() == true or attacker:IsNPC() and eft_s_enable_npcs:GetBool() == true then
				
				if ply:Armor() < 1 and JMod.GetItemInSlot(ply.EZarmor, "head") == nil then
					local particleSound		=	ents.Create( "env_spark" )
					local randomizer = math.random( 1 , 6 )
					
					particleSound:SetPos( dmginfo:GetDamagePosition() )
					particleSound:Spawn()
					-- ParticleEffect( "blood_impact_headshot_1" , dmginfo:GetDamagePosition(), Angle(plyangle), nil)	
					particleSound:EmitSound( "eft/impact/body" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_headshot_noarmor:GetFloat() )	
					
					timer.Simple( 0.05 , function()
						
						if IsValid( particleSound ) then
							
							particleSound:Remove()
							
						end
						
					end)												
					
				elseif ply:Armor() > 0 or (JMod.GetItemInSlot(ply.EZarmor, "head") != nil and IsHitToFace(ply,dmginfo) == false) then
				local particleSound		=	ents.Create( "env_spark" )
					local randomizer = math.random( 1 , 4 )
					
					particleSound:SetPos( dmginfo:GetDamagePosition() )
					particleSound:Spawn()
					ParticleEffect( "impact_helmet_headshot_csgo" , dmginfo:GetDamagePosition(), Angle(attacker:GetAngles()), nil)	
					particleSound:EmitSound( "eft/impact/impact_helmet_1p_" .. randomizer .. ".wav" , 75 , 100 , eft_s_volume_helmet:GetFloat() )	
					
					timer.Simple( 0.05 , function()
						
						if IsValid( particleSound ) then
							
							particleSound:Remove()
							
						end
						
					end)
				
				end							
																		
			end					
			
		elseif hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH then
			
				if attacker:IsPlayer() == true or attacker:IsNPC() and eft_s_enable_npcs:GetBool() == true then
					
					if ply:Armor() > 0 or (JMod.GetItemInSlot(ply.EZarmor, "chest") != nil or JMod.GetItemInSlot(ply.EZarmor, "abdomen ") != nil) then
						local particleSound		=	ents.Create( "env_spark" )
						local randomizer = math.random( 1 , 4 )
						
						particleSound:SetPos( dmginfo:GetDamagePosition() )
						particleSound:Spawn()
						ParticleEffect( "blood_impact_headshot_1" , dmginfo:GetDamagePosition(), Angle(plyangle), nil)	
						particleSound:EmitSound( "eft/impact/bodyarmor" .. randomizer .. "_fp.wav" , 75 , 100 , eft_s_volume_bodyshot_kevlar:GetFloat() )	
						
						-- print("bodyshot random " .. randomizer )
						
						timer.Simple( 0.05 , function()
							
							if IsValid( particleSound ) then
								
								particleSound:Remove()
								
							end
							
						end)
						
					else									
						
					end							
																		
				end
				
		end
		
	end

	function EFT_S_SAVE_CONVARS()

		local EFT_S_NewSaveFile = {
		
			eft_s_enable 					= GetConVar("eft_s_enable"):GetInt(),
			eft_s_enable_npcs 					= GetConVar("eft_s_enable"):GetBool(),
			eft_s_volume_helmet			= GetConVar("eft_s_volume_helmet"):GetFloat(),
			eft_s_volume_headshot_noarmor	= GetConVar("eft_s_volume_headshot_noarmor"):GetFloat(),
			eft_s_volume_headshot_kill		= GetConVar("eft_s_volume_headshot_kill"):GetFloat(),
			eft_s_volume_bodyshot_kevlar	= GetConVar("eft_s_volume_bodyshot_kevlar"):GetFloat(),
			eft_s_sparks					= GetConVar("eft_s_sparks"):GetString(),
			
		}
		
		file.Write( "eft_s_convars_data.txt" , util.TableToJSON( EFT_S_NewSaveFile ) )
		
		print( "saved !!!" )
		
	end

	function EFT_S_LOAD_DEFAULT_SETTINGS()
	
		eft_s_enable 					= GetConVar("eft_s_enable")
		eft_s_enable_npcs 					= GetConVar("eft_s_enable_npcs")
		eft_s_volume_helmet			= GetConVar("eft_s_volume_helmet")
		eft_s_volume_headshot_noarmor	= GetConVar("eft_s_volume_headshot_noarmor")
		eft_s_volume_headshot_kill		= GetConVar("eft_s_volume_headshot_kill")
		eft_s_volume_bodyshot_kevlar	= GetConVar("eft_s_volume_bodyshot_kevlar")
		eft_s_sparks					= GetConVar("eft_s_sparks")
		
		hook.Add( "ScaleNPCDamage" , "EFT_S_Npc_Helmet_Headshot" , EFT_S_NPC_HELMET_HEADSHOT )
		hook.Add( "ScaleNPCDamage" , "EFT_S_Npc_Flesh_Headshot" , EFT_S_NPC_FLESH_HEADSHOT )
		hook.Add( "ScaleNPCDamage" , "EFT_S_Npc_Combine_Headshot" , EFT_S_NPC_COMBINE_HEADSHOT )
		hook.Add( "ScaleNPCDamage" , "EFT_S_Npc_Combine_Bodyshot" , EFT_S_NPC_COMBINE_BODYSHOT )	
		hook.Add( "ScaleNPCDamage" , "EFT_S_On_Npc_Kill_Headshot" , EFT_S_ON_NPC_KILL_HEADSHOT )	
		hook.Add( "ScalePlayerDamage" , "EFT_S_Player_Shots" , EFT_S_PLAYER_SHOTS )	
		
		print("no save file, load default settings")
	
	end

	function EFT_S_LOAD_CONVARS()

		local EFT_SaveFile = file.Read( "eft_s_convars_data.txt" , "DATA" )
		
		if not isstring( EFT_SaveFile ) then
		
		EFT_S_LOAD_DEFAULT_SETTINGS()
		
		return end 
		
		EFT_SaveFile = util.JSONToTable( EFT_SaveFile )
		
		eft_s_enable 					= GetConVar("eft_s_enable")
		eft_s_enable_npcs 				= GetConVar("eft_s_enable_npcs")
		eft_s_volume_helmet			= GetConVar("eft_s_volume_helmet")
		eft_s_volume_headshot_noarmor	= GetConVar("eft_s_volume_headshot_noarmor")
		eft_s_volume_headshot_kill		= GetConVar("eft_s_volume_headshot_kill")
		eft_s_volume_bodyshot_kevlar	= GetConVar("eft_s_volume_bodyshot_kevlar")
		eft_s_sparks					= GetConVar("eft_s_sparks")
		
		-- PrintTable( EFT_SaveFile )
		
		eft_s_enable:SetInt(EFT_SaveFile[ "eft_s_enable" ])
		eft_s_enable_npcs:SetBool(EFT_SaveFile[ "eft_s_enable_npcs" ])
		eft_s_volume_helmet:SetFloat(EFT_SaveFile[ "eft_s_volume_helmet" ])
		eft_s_volume_headshot_noarmor:SetFloat(EFT_SaveFile[ "eft_s_volume_headshot_noarmor" ])
		eft_s_volume_headshot_kill:SetFloat(EFT_SaveFile[ "eft_s_volume_headshot_kill" ])
		eft_s_volume_bodyshot_kevlar:SetFloat(EFT_SaveFile[ "eft_s_volume_bodyshot_kevlar" ])
		eft_s_sparks:SetString(EFT_SaveFile[ "eft_s_sparks" ])
		
		print( "convars loaded" )

	end

	timer.Simple( 1 , EFT_S_LOAD_CONVARS )

	function EFT_S_HOOKS()
		
		hook.Add( "ScaleNPCDamage" , "EFT_S_Npc_Helmet_Headshot" , EFT_S_NPC_HELMET_HEADSHOT )
		hook.Add( "ScaleNPCDamage" , "EFT_S_Npc_Flesh_Headshot" , EFT_S_NPC_FLESH_HEADSHOT )
		hook.Add( "ScaleNPCDamage" , "EFT_S_Npc_Combine_Headshot" , EFT_S_NPC_COMBINE_HEADSHOT )
		hook.Add( "ScaleNPCDamage" , "EFT_S_Npc_Combine_Bodyshot" , EFT_S_NPC_COMBINE_BODYSHOT )	
		hook.Add( "ScaleNPCDamage" , "EFT_S_On_Npc_Kill_Headshot" , EFT_S_ON_NPC_KILL_HEADSHOT )	
		hook.Add( "ScalePlayerDamage" , "EFT_S_Player_Shots" , EFT_S_PLAYER_SHOTS )	
				
		-- print("eft headshots loaded ogeyy")
		
	end

	timer.Simple( 1 , EFT_S_HOOKS )
		
	concommand.Add( "EFT_S_Save" , EFT_S_SAVE_CONVARS )
	concommand.Add( "EFT_S_LoadSave" , EFT_S_LOAD_CONVARS )

end

if CLIENT then

	hook.Add( "PopulateToolMenu", "EFTShotFXSettings", function()

		spawnmenu.AddToolMenuOption( "Options", "EFT FX","Froze_Menu_EFTShotFX","EFT Shot FX", "","", function( panel ) 
		local panelEnable panel:CheckBox( "Enable EFT Shot FX" , "eft_s_enable" )
		local panelDisableNPC panel:CheckBox( "Enable for npcs" , "eft_s_enable_npcs" )
				
		local chooseSpark	= panel:ComboBox( "Sparks setting" , "eft_s_sparks" )
		chooseSpark:AddChoice("any")
		chooseSpark:AddChoice("combine only")
				
		panel:NumSlider( "Helmet Spark Volume", "eft_s_volume_helmet", 0, 1 )
		panel:NumSlider( "Headshot Player No Armor Volume", "eft_s_volume_headshot_noarmor", 0, 1 )
		panel:NumSlider( "Headshot Flesh Volume", "eft_s_volume_headshot_kill", 0, 1 )
		panel:NumSlider( "Kevlar Bodyshot Volume", "eft_s_volume_bodyshot_kevlar", 0, 1 )
		
		local button_eft_s_save = panel:Button( "Save" , "EFT_S_Save" , "" )
		local button_eft_s_load = panel:Button( "Load" , "EFT_S_LoadSave" , "" )
		
		end)

	end )
	
	-- print("ogey toolbear")

end


























