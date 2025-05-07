-- sh_hg_ammo.lua"

--
hg.ammotypes = {
	["5.56x45mm"] = {
		name = "5.56x45 mm",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 100,
		maxcarry = 120,
		minsplash = 10,
		maxsplash = 5
	},
	["7.62x39mm"] = {
		name = "7.62x39 mm",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 160,
		maxcarry = 120,
		minsplash = 10,
		maxsplash = 5
	},
	["12/70gauge"] = {
		name = "12/70 gauge",
		dmgtype = DMG_BUCKSHOT,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 350,
		maxcarry = 46,
		minsplash = 10,
		maxsplash = 5
	},
	["12/70beanbag"] = {
		name = "12/70 beanbag",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 100,
		maxcarry = 46,
		minsplash = 10,
		maxsplash = 5
	},
	["9x19mmparabellum"] = {
		name = "9x19 mm Parabellum",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 100,
		maxcarry = 80,
		minsplash = 10,
		maxsplash = 5
	},
	[".50actionexpress"] = {
		name = ".50 Action Express",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 200,
		maxcarry = 150,
		minsplash = 10,
		maxsplash = 5
	}
}

local ammotypes = hg.ammotypes
--[[
name = "5.56x45 mm",

name = "7.62x39 mm",

name = "5.45x39 mm",

name = "12/70 gauge",

name = "12/70 beanbag",

name = "9x19 mm Parabellum",

name = ".45 ACP",

name = "4.6×30 mm",

name = "5.7×28 mm",

name = ".44 Remington Magnum",

name = "9x39 mm",

name = ".50 Action Express",

name = "7.62x51 mm",

name = "7.62x54 mm",

name = ".338 Lapua Magnum"
]]
local ammoents = {
	["5.56x45mm"] = {
		Material = "models/hmcd_ammobox_556",
		Scale = 1
	},
	["7.62x39mm"] = {
		Scale = 1
	},
	["12/70gauge"] = {
		Material = "models/hmcd_ammobox_12",
		Scale = 1.1,
	},
	["12/70beanbag"] = {
		Material = "models/hmcd_ammobox_12",
		Scale = 1.1,
	},
	["9x19mmparabellum"] = {
		Material = "models/hmcd_ammobox_9",
		Scale = 0.8,
	},
	[".50actionexpress"] = {
		Material = "models/hmcd_ammobox_22",
		Scale = 1,
		Color = Color(255, 255, 125)
	},
}

local function addAmmoTypes()
	for name, tbl in pairs(ammotypes) do
		game.AddAmmoType(tbl)
		if CLIENT then language.Add(tbl.name .. "_ammo", tbl.name) end
		local ammoent = {}
		ammoent.Base = "ammo_base"
		ammoent.PrintName = tbl.name
		ammoent.Category = "HG Ammo"
		ammoent.Spawnable = true
		ammoent.AmmoCount = 30
		ammoent.AmmoType = tbl.name
		ammoent.Model = ammoents[name].Model or "models/props_lab/box01a.mdl"
		ammoent.ModelMaterial = ammoents[name].Material or ""
		ammoent.ModelScale = ammoents[name].Scale or 1
		ammoent.Color = ammoents[name].Color or Color(255, 255, 255)
		scripted_ents.Register(ammoent, "ent_ammo_" .. name)
	end

	game.BuildAmmoTypes()
	--PrintTable(game.GetAmmoTypes())
end

addAmmoTypes()
hook.Add("Initialize", "init-ammo", addAmmoTypes)

if CLIENT then
    local blurMat = Material("pp/blurscreen")
    local Dynamic = 0
	local red = Color(75,25,25)
	local redselected = Color(150,0,0)

    local function BlurBackground(panel)
        if not((IsValid(panel))and(panel:IsVisible()))then return end
        local layers,density,alpha=1,1,255
        local x,y=panel:LocalToScreen(0,0)
        surface.SetDrawColor(255,255,255,alpha)
        surface.SetMaterial(blurMat)
        local FrameRate,Num,Dark=1/FrameTime(),5,150
        for i=1,Num do
            blurMat:SetFloat("$blur",(i/layers)*density*Dynamic)
            blurMat:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(-x,-y,ScrW(),ScrH())
        end
        surface.SetDrawColor(0,0,0,Dark*Dynamic)
        surface.DrawRect(0,0,panel:GetWide(),panel:GetTall())
        Dynamic=math.Clamp(Dynamic+(1/FrameRate)*7,0,1)
    end

    function AmmoMenu(ply)
        local ammodrop = 0
        if !ply:Alive() then return end
        local Frame = vgui.Create( "DFrame" )
        Frame:SetTitle( "Ammunition" )
        Frame:SetSize( 200,300 )
        Frame:Center()			
        Frame:MakePopup()
        Frame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
            draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 0, 0, 0, 140) )
            BlurBackground(Frame)
			surface.SetDrawColor( 255, 0, 0, 128)
            surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
        end
        local DPanel = vgui.Create( "DScrollPanel", Frame )
        DPanel:SetPos( 5, 30 ) -- Set the position of the panel
        DPanel:SetSize( 190, 215 ) -- Set the size of the panel
        DPanel.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 140) )
        end

        local DermaNumSlider = vgui.Create( "DNumSlider", Frame )
        DermaNumSlider:SetPos( 10, 245 )				
        DermaNumSlider:SetSize( 210, 25 )			
        DermaNumSlider:SetText( "Count " )	
        DermaNumSlider:SetMin( 0 )				 	
        DermaNumSlider:SetMax( 60 )				
        DermaNumSlider:SetDecimals( 0 )				

        -- If not using convars, you can use this hook + Panel.SetValue()
        DermaNumSlider.OnValueChanged = function( self, value )
            ammodrop = math.Round(value)
        end

        local ammos = LocalPlayer():GetAmmo()

        for k,v in pairs(ammos) do
            local DermaButton = vgui.Create( "DButton", DPanel ) 
            DermaButton:SetText( game.GetAmmoName( k )..": "..v )	
            DermaButton:SetTextColor( Color(255,255,255) )	
            DermaButton:SetPos( 0, 0 )	
            DermaButton:Dock( TOP )
            DermaButton:DockMargin( 2, 2.5, 2, 0 )	
            DermaButton:SetSize( 120, 25 )

            DermaButton.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
                DermaButton.a = Lerp(0.1,DermaButton.a or 100,DermaButton:IsHovered() and 255 or 150)
				draw.RoundedBox(0, 0, 0, w, h, Color(red.r,red.g,red.b,DermaButton.a))
                --BlurBackground(DermaButton)
            end				
            DermaButton.DoClick = function()
                --print( math.min(ammodrop,v),game.GetAmmoName( k ))				
                net.Start( "drop_ammo" )
                    net.WriteFloat( k )
                    net.WriteFloat( math.min(ammodrop,v) )
                net.SendToServer()
                Frame:Close()
            end

            DermaButton.DoRightClick = function()
                net.Start( "drop_ammo" )
                    net.WriteFloat( k )
                    net.WriteFloat( math.min(v,v) )
                net.SendToServer()
                Frame:Close()	
            end
        end
        local DLabel = vgui.Create( "DLabel", Frame )
        DLabel:SetPos( 10, 268 )
		DLabel:SetTextColor(Color(255,255,255))
        DLabel:SetText( "LMB - Drop count\nRMB - Drop all" )
        DLabel:SizeToContents()

    end

    concommand.Add( "hg_ammomenu", function( ply, cmd, args )
        AmmoMenu(ply)
    end )

	hook.Add("radialOptions", "hg-ammomenu", function() if not LocalPlayer().otrub then hg.radialOptions[#hg.radialOptions + 1] = {function() RunConsoleCommand("hg_ammomenu") end, "Drop Ammo"} end end)
end

if SERVER then
    util.AddNetworkString( "drop_ammo" )

    net.Receive( "drop_ammo", function( len, ply )
        if !ply:Alive() or ply.otrub then return end
        local ammotype = net.ReadFloat()
        local count = net.ReadFloat()
        local pos = ply:EyePos()+ply:EyeAngles():Forward()*15
        if ply:GetAmmoCount(ammotype)-count < 0 then ply:ChatPrint(((math.random(1,100) == 100 or 1) and "I need mor booolets!!!" ) or "You don't have enogh ammo") return end
        if count < 1 then ply:ChatPrint("You can't drop zero ammo") return end
			--if not ammolistent[ammotype] then ply:ChatPrint("Invalid entitytype...") return end
			--print(game.GetAmmoName(ammotype))
        local AmmoEnt = ents.Create( "ent_ammo_"..string.lower( string.Replace(game.GetAmmoName(ammotype)," ", "") ) )
		if not IsValid(AmmoEnt) then return ply:ChatPrint("Invalid entitytype...") end
        AmmoEnt:SetPos( pos )
        AmmoEnt:Spawn()
        AmmoEnt.AmmoCount = count
        ply:SetAmmo(ply:GetAmmoCount(ammotype)-count,ammotype)
        ply:EmitSound("snd_jack_hmcd_ammobox.wav", 75, math.random(80,90), 1, CHAN_ITEM )
		ply.inventory.Ammo = ply:GetAmmo()
		//ply:SetNetVar("Inventory",ply.inventory)
    end)
end