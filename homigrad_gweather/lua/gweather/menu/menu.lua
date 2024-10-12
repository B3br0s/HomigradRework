if !CLIENT then return end

hook.Add( "PopulateGWeather", "AddGWeatherContent", function( pnlContent, tree, node )

	local WeatherCategories = {}
	local SpawnableEntities = list.Get( "gWeather_Weather" )
	if ( SpawnableEntities ) then
		for k, v in pairs( SpawnableEntities ) do

			WeatherCategories[ v.Category ] = WeatherCategories[ v.Category ] or {}
			table.insert( WeatherCategories[ v.Category ], v )

		end
	end

	for CategoryName, v in SortedPairs( WeatherCategories ) do
	
		local node = tree:AddNode( CategoryName, "materials/icons/cloud_f.png" )

		node.DoPopulate = function( self )

			if ( self.PropPanel ) then return end

			-- Create the container panel
			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )

			for name, ent in SortedPairsByMemberValue( v, "PrintName" ) do

				spawnmenu.CreateContentIcon( "entity", self.PropPanel, {
					nicename	= ent.Name or ent.PrintName,
					spawnname	= ent.Class,
					material	= "entities/" .. ent.Class .. ".png",
					admin		= ent.AdminOnly
				} )

			end

		end

		node.DoClick = function( self )

			self:DoPopulate()
			pnlContent:SwitchPanel( self.PropPanel )

		end

	end

end )

search.AddProvider( function( str )
		local results = {}

		for k, v in pairs( list.Get("gWeather_Weather") ) do -- gmod do the rest please
		
			v.ClassName = k
			v.PrintName = v.PrintName or v.Name
		
			if ( !v.PrintName ) then continue end
			if ( v.PrintName && v.PrintName:lower():find( str, nil, true ) ) then

				local entry = {
					text = v.PrintName or v.ClassName,
					icon = spawnmenu.CreateContentIcon( "entity", nil, {
						nicename = v.PrintName or v.ClassName,
						spawnname = v.ClassName,
						material = "entities/" .. v.ClassName .. ".png",
						admin = v.AdminOnly
					} ),
					words = { v }
				}
				table.insert( results, entry )
			end

			if ( #results >= GetConVar("sbox_search_maxresults"):GetInt() / 4 ) then break end
			
		end

		table.SortByMember( results, "text", true )
		return results

end, "gW_SearchList" )

spawnmenu.AddCreationTab( "gWeather", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "gW_SearchList", "PopulateGWeather" )
	ctrl:CallPopulateHook( "PopulateGWeather" )
	return ctrl

end, "materials/icons/gweather.png", 70 )

----

local function AddgW(name,class,category,adminonly,off) -- how to list it
	list.Set( "gWeather_Weather", class, {Name = name,Class = class,Category = category,AdminOnly =(adminonly or false)} )
end

-- T1

AddgW("Snow","gw_t1_snow","Tier 1")
AddgW("Aurora Borealis","gw_t1_auroraborealis","Tier 1")
AddgW("Light Snow","gw_t1_lightsnow","Tier 1")
AddgW("Light Rain","gw_t1_lightrain","Tier 1")
AddgW("Sleet","gw_t1_sleet","Tier 1")
AddgW("Heavy Fog","gw_t1_heavyfog","Tier 1")
AddgW("Sunny","gw_t1_sunny","Tier 1")
AddgW("Night","gw_t1_night","Tier 1")
AddgW("Cloudy","gw_t1_cloudy","Tier 1")
AddgW("Partly Cloudy","gw_t1_partlycloudy","Tier 1")
AddgW("Warm Front","gw_t1_warmfront","Tier 1")
AddgW("Quarter-Sized Hail","gw_t1_quarter_hail","Tier 1")
AddgW("Light Wind","gw_t1_lightwind","Tier 1")

-- T2

AddgW("Heavy Rain","gw_t2_heavyrain","Tier 2")
AddgW("Tropical Storm","gw_t2_tropicalstorm","Tier 2")
AddgW("Heavy Snow","gw_t2_heavysnow","Tier 2")
AddgW("Haboob","gw_t2_haboob","Tier 2")
AddgW("Ash Storm","gw_t2_ashstorm","Tier 2")
AddgW("Cold Front","gw_t2_coldfront","Tier 2")
AddgW("Golfball-Sized Hail","gw_t2_golfball_hail","Tier 2")
AddgW("Gale-Force Wind","gw_t2_moderatewind","Tier 2")
AddgW("Cold Freeze","gw_t2_coldfreeze","Tier 2")
AddgW("Heat Wave","gw_t2_heatwave","Tier 2")

-- T3

AddgW("Blizzard","gw_t3_blizzard","Tier 3")
AddgW("Extreme Heavy Rain","gw_t3_extheavyrain","Tier 3")
AddgW("Acid Rain","gw_t3_acidrain","Tier 3")
AddgW("Baseball-Sized Hail","gw_t3_baseball_hail","Tier 3")
AddgW("Severe Wind","gw_t3_severewind","Tier 3")
AddgW("Category 1 Hurricane","gw_t3_c1hurricane","Tier 3")

-- T4

AddgW("Grapefruit-Sized Hail","gw_t4_grapefruit_hail","Tier 4")
AddgW("Hurricane Wind","gw_t4_hurricanewind","Tier 4")
AddgW("Derecho","gw_t4_derecho","Tier 4")
AddgW("Category 2 Hurricane","gw_t4_c2hurricane","Tier 4")

-- T5

AddgW("Radiation Storm","gw_t5_radiationstorm","Tier 5")
AddgW("Major Hurricane Wind","gw_t5_mhurricanewind","Tier 5")
AddgW("Downburst","gw_t5_downburst","Tier 5")
AddgW("Category 3 Hurricane","gw_t5_c3hurricane","Tier 5")

-- T6

AddgW("Firestorm","gw_t6_firestorm","Tier 6")
AddgW("Arctic Blast","gw_t6_arcticblast","Tier 6")
AddgW("Category 4 Hurricane","gw_t6_c4hurricane","Tier 6")
AddgW("Unfathomable Wind","gw_t6_unfathomablewind","Tier 6")

-- T7

AddgW("Vacuum of Space","gw_t7_space","Tier 7")
AddgW("Pyroclastic Flow","gw_t7_pyroclastic_flow","Tier 7")
AddgW("Permian Extinction","gw_t7_permian_extinction","Tier 7")
AddgW("Category 5 Hurricane","gw_t7_c5hurricane","Tier 7")

AddgW("Category 6 Hurricane","gw_t8_c6hurricane","Tier 8")

-- misc

AddgW("Wind Editor","gw_editwind","Misc",true)
AddgW("Lightning Bolt","gw_lightningbolt","Misc")
AddgW("Lava Bomb","gw_lavabomb","Misc")
AddgW("Lightning Storm","gw_lightning_storm","Misc")
AddgW("Hailstone","gw_hailstone","Misc")
AddgW("Weather Screen","gw_weatherscreen","Misc")