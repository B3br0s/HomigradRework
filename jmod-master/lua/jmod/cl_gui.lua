local blurMat = Material("pp/blurscreen")
local Dynamic = 0
local FriendMenuOpen = false
local SelectionMenuOpen = false
local CurrentColor = Color(255, 255, 255)
local YesMat = Material("icon16/accept.png")
local NoMat = Material("icon16/cancel.png")
local FavMat = Material("icon16/star.png")
local FriendMat = Material("icon16/user_green.png")
local NotFriendMat = Material("icon16/user_red.png")

local SpecialIcons = {
	["geothermal"] = Material("ez_resource_icons/geothermal.png"),
	["warning"] = Material("ez_misc_icons/warning.png")
}

local RankIcons = {Material("ez_rank_icons/grade_1.png"), Material("ez_rank_icons/grade_2.png"), Material("ez_rank_icons/grade_3.png"), Material("ez_rank_icons/grade_4.png"), Material("ez_rank_icons/grade_5.png")}

JMod.SelectionMenuIcons = {}
local LocallyAvailableResources = nil -- this is here solely for caching and efficieny purposes, i sure hope it doesn't bite me in the ass
local QuestionMarkIcon = Material("question_mark.png")

local JModIcon, JModLegacyIcon = "jmod_icon", "jmod_icon_legacy.png"
list.Set( "ContentCategoryIcons", "JMod - EZ Armor", JModIcon.."_armor.png" )
list.Set( "ContentCategoryIcons", "JMod - EZ Explosives", JModIcon.."_explosives.png" )
list.Set( "ContentCategoryIcons", "JMod - EZ Machines", JModIcon.."_machines.png" )
list.Set( "ContentCategoryIcons", "JMod - EZ Misc.", JModIcon..".png" )
list.Set( "ContentCategoryIcons", "JMod - EZ Resources", JModIcon.."_resources.png" )
list.Set( "ContentCategoryIcons", "JMod - EZ Special Ammo", JModIcon.."_specialammo.png" )
list.Set( "ContentCategoryIcons", "JMod - EZ Weapons", JModIcon.."_weapons.png" )
--
list.Set( "ContentCategoryIcons", "JMod - LEGACY Armor", JModLegacyIcon )
list.Set( "ContentCategoryIcons", "JMod - LEGACY Explosives", JModLegacyIcon )
list.Set( "ContentCategoryIcons", "JMod - LEGACY Sentries", JModLegacyIcon )
list.Set( "ContentCategoryIcons", "JMod - LEGACY Misc.", JModLegacyIcon )
list.Set( "ContentCategoryIcons", "JMod - LEGACY NPCs", JModLegacyIcon )
list.Set( "ContentCategoryIcons", "JMod - LEGACY Weapons", JModLegacyIcon )

local function BlurBackground(panel)
	if not (IsValid(panel) and panel:IsVisible()) then return end
	local layers, density, alpha = 1, 1, 255
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(blurMat)
	local FrameRate, Num, Dark = 1 / FrameTime(), 5, 150

	for i = 1, Num do
		blurMat:SetFloat("$blur", (i / layers) * density * Dynamic)
		blurMat:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end

	surface.SetDrawColor(0, 0, 0, Dark * Dynamic)
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	Dynamic = math.Clamp(Dynamic + (1 / FrameRate) * 7, 0, 1)
end

local function PopulateList(parent, friendList, myself, W, H)
	parent:Clear()
	local Y = 0

	for k, playa in player.Iterator() do
		if playa != myself then
			playa.JModFriends = playa.JModFriends or {}
			local IsFriendBool = table.HasValue(playa.JModFriends, myself)
			local Panel = parent:Add("DPanel")
			Panel:SetSize(W - 35, 20)
			Panel:SetPos(0, Y)

			function Panel:Paint(w, h)
				surface.SetDrawColor(0, 0, 0, 100)
				surface.DrawRect(0, 0, w, h)
				draw.SimpleText((playa:IsValid() and playa:Nick()) or "DISCONNECTED", "DermaDefault", 5, 3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end

			local Buttaloney = vgui.Create("DButton", Panel)
			Buttaloney:SetPos(Panel:GetWide() - 25, 0)
			Buttaloney:SetSize(20, 20)
			Buttaloney:SetText("")
			local InLikeFlynn = table.HasValue(friendList, playa)

			function Buttaloney:Paint(w, h)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial((InLikeFlynn and YesMat) or NoMat)
				surface.DrawTexturedRect(2, 2, 16, 16)
			end

			function Buttaloney:DoClick()
				surface.PlaySound("garrysmod/ui_click.wav")

				if InLikeFlynn then
					table.RemoveByValue(friendList, playa)
				else
					table.insert(friendList, playa)
				end

				PopulateList(parent, friendList, myself, W, H)
			end

			local IsFriendIcon = vgui.Create("DSprite", Panel)
			IsFriendIcon:SetPos(Panel:GetWide() - 50, 0)
			IsFriendIcon:SetSize(20, 20)
			IsFriendIcon:SetText("")

			function IsFriendIcon:Paint(w, h)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial((IsFriendBool and FriendMat) or NotFriendMat)
				surface.DrawTexturedRect(2, 2, 16, 16)
			end

			Y = Y + 25
		end
	end
end

function JMod.StandardResourceDisplay(typ, amt, maximum, x, y, siz, vertical, font, opacity, rateDisplay, brite)
	font = font or "JMod-Stencil"
	opacity = opacity or 150
	brite = brite or 200
	surface.SetDrawColor(255, 255, 255, opacity)
	surface.SetMaterial(JMod.EZ_RESOURCE_TYPE_ICONS[typ] or SpecialIcons[typ])
	surface.DrawTexturedRect(x - siz / 2, y - siz / 2, siz, siz)
	local Col = Color(brite, brite, brite, opacity)
	local UnitText = tostring(amt) .. " UNITS"

	if rateDisplay then
		UnitText = tostring(amt) .. " PER SECOND"
	end

	if vertical then
		draw.SimpleText(typ, font, x, y - siz / 2 - 10, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(UnitText, font, x, y + siz / 2 + 10, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	else
		draw.SimpleText(typ, font, x - siz / 2 - 10, y, Col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(UnitText, font, x + siz / 2 + 10, y, Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

function JMod.StandardRankDisplay(rank, x, y, siz, opacity)
	opacity = opacity or 150
	surface.SetDrawColor(255, 255, 255, opacity)
	surface.SetMaterial(RankIcons[rank])
	surface.DrawTexturedRect(x - siz / 2, y - siz / 2, siz, siz)
end

function JMod.HoloGraphicDisplay(ent, relPos, relAng, scale, renderDist, renderFunc, absolutePositions)
	if absolutePositions then
		if EyePos():Distance(relPos) < renderDist then
			cam.Start3D2D(relPos, relAng, scale)
			renderFunc()
			cam.End3D2D()
		end

		return
	end

	local Ang, Pos = Angle(0, 0, 0), Vector(0, 0, 0)

	if IsValid(ent) and ent.GetAngles then
		Ang = ent:GetAngles()
		Pos = ent:GetPos()
	else -- we're using world coordinates
		Pos = relPos
		Ang = relAng
	end

	local Right, Up, Forward = Ang:Right(), Ang:Up(), Ang:Forward()

	if EyePos():Distance(Pos) < renderDist then
		if ent then
			Ang:RotateAroundAxis(Right, relAng.p)
			Ang:RotateAroundAxis(Up, relAng.y)
			Ang:RotateAroundAxis(Forward, relAng.r)
		end

		local RenderPos = Pos + relPos.x * Right + relPos.y * Forward + relPos.z * Up

		-- world coords
		if not ent then
			RenderPos = Pos + Vector(0, 0, 50)
		end

		cam.Start3D2D(RenderPos, Ang, scale)
		renderFunc()
		cam.End3D2D()
	end
end

local OldMouseX, OldMouseY = 0, 0
net.Receive("JMod_ColorAndArm", function()
	local Ent, UpdateColor, NextColorCheck = net.ReadEntity(), net.ReadBool(), 0

	if UpdateColor == true then
		CurrentColor = Ent:GetColor()
		input.SetCursorPos(OldMouseX, OldMouseY)
	end
	if not IsValid(Ent) then return end
	local Frame = vgui.Create("hg_frame")
	Frame:SetSize(200, 300)
	Frame:SetPos(ScrW() * .4 - 200, ScrH() * .5)
	Frame:SetDraggable(true)
	Frame:ShowCloseButton(true)
	Frame:SetTitle(Ent.PrintName or "Select Color")
	Frame:MakePopup()
	local Picker

	Picker = vgui.Create("DColorMixer", Frame)
	Picker:SetPos(5, 25)
	Picker:SetSize(190, 215)
	Picker:SetAlphaBar(false)
	Picker:SetWangs(false)
	Picker:SetPalette(true)
	Picker:SetColor(Ent:GetColor())
	local Butt = vgui.Create("hg_button", Frame)
	Butt:SetPos(5, 245)
	Butt:SetSize(95, 50)
	Butt:SetText(" ")
	Butt.Text = "ARM"
	Butt.TextFont = "HS.14"

	function Butt:DoClick()
		local Col = Picker:GetColor()
		net.Start("JMod_ColorAndArm")
		net.WriteEntity(Ent)
		net.WriteBit(false)
		net.WriteColor(Color(Col.r, Col.g, Col.b))
		net.WriteBit(true)
		net.SendToServer()
		Frame:Close()
	end

	local ButtWhat = vgui.Create("hg_button", Frame)
	ButtWhat:SetPos(100, 245)
	ButtWhat:SetSize(95, 50)
	ButtWhat:SetText(" ")
	ButtWhat.Text = "AUTO-COLOR"
	ButtWhat.TextFont = "HS.14"

	function ButtWhat:DoClick()
		net.Start("JMod_ColorAndArm")
		net.WriteEntity(Ent)
		net.WriteBit(true)
		net.WriteColor(Color(255, 255, 255))
		net.WriteBit(false)
		net.SendToServer()
		OldMouseX, OldMouseY = input.GetCursorPos()
		Frame:Close()
	end
end)

--[[
if #JMod.ClientConfig.BuildKitFavs > 0 then
	local Tab={}
	for k,v in pairs(JMod.ClientConfig.BuildKitFavs)do
		table.insert(Tab,v)
	end
	Categories["Favourites"]=Tab
end
--]]

net.Receive("JMod_EZtimeBomb", function()
	local ent = net.ReadEntity()
	local frame = vgui.Create("hg_frame")
	frame:SetSize(300, 120)
	frame:SetTitle("Time Bomb")
	frame:SetDraggable(true)
	frame:Center()
	frame:MakePopup()

	local bg = vgui.Create("DPanel", frame)
	bg:SetPos(90, 30)
	bg:SetSize(200, 25)

	function bg:Paint(w, h)
	end

	local tim = vgui.Create("DNumSlider", frame)
	tim:SetText("Set Time")
	tim:SetSize(280, 20)
	tim:SetPos(10, 30)
	tim:SetMin(10)
	tim:SetMax(600)
	tim:SetValue(10)
	tim:SetDecimals(0)
	local apply = vgui.Create("hg_button", frame)
	apply:SetSize(100, 30)
	apply:SetPos(100, 75)
	apply:SetText(" ")
	apply.Text = "ARM"

	apply.DoClick = function()
		net.Start("JMod_EZtimeBomb")
		net.WriteEntity(ent)
		net.WriteInt(tim:GetValue(), 16)
		net.SendToServer()
		frame:Close()
	end
end)

local function GetAvailPts(specs)
	local Pts = 0

	for k, v in pairs(specs) do
		if isnumber(v) then
			Pts = Pts - v
		end
	end

	return Pts
end

local OpenDropdown = nil

local function CreateCommandButton(parent, commandTbl, x, y, num)
	local Buttalony, Ply = vgui.Create("hg_button", parent), LocalPlayer()
	Buttalony:SetSize(180, 20)
	Buttalony:SetPos(x, y)
	Buttalony:SetText("")
	Buttalony:SetCursor("hand")

	function Buttalony:SubPaint(w, h)
		self.Text = (num..": "..commandTbl.name)
	end

	local HelpStr = commandTbl.helpTxt
	if commandTbl.adminOnly then
		HelpStr = "ADMIN ONLY!\n"..commandTbl.helpTxt
	end
		
	Buttalony:SetTooltip(HelpStr)

	function Buttalony:DoClick()
		Ply:ConCommand("jmod_ez_"..commandTbl.name)
		if IsValid(parent) then
			parent:Close()
		end
	end
end

local Yeps = {"Yes", "yep", "Of course", "Leave me alone", ">:)"}