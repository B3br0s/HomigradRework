-- \lua\\homigrad\\cl_hud.lua"

hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = false,
	["CHudSecondaryAmmo"] = true,
	["CHudCrosshair"] = true
}

hook.Add("HUDShouldDraw", "homigrad", function(name) if hide[name] then return false end end)
hook.Add("HUDDrawTargetID", "homigrad", function() return false end)
hook.Add("DrawDeathNotice", "homigrad", function() return false end)
surface.CreateFont("HomigradFont", {
	font = "Roboto",
	size = ScreenScale(10),
	weight = 1100,
	outline = false
})

surface.CreateFont("HomigradFontBig", {
	font = "Roboto",
	size = 35,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("HomigradFontLarge", {
	font = "Roboto",
	size = 40,
	weight = 1100,
	outline = false
})

surface.CreateFont("HomigradFontSmall", {
	font = "Roboto",
	size = 17,
	weight = 1100,
	outline = false
})

local w, h
local lply = LocalPlayer()
hook.Add("HUDPaint", "homigrad-dev", function()
	if engine.ActiveGamemode() ~= "sandbox" then return end
	w, h = ScrW(), ScrH()
end)

--draw.SimpleText(lply:Health(),"HomigradFontBig",100,h - 50,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
function draw.CirclePart(x, y, radius, seg, parts, pos)
	local cir = {}
	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad((i / seg) * -360 / parts - pos * 360 / parts)
		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
		--draw.DrawText("asd","HomigradFontBig",x + math.sin(a) * radius,y + math.cos(a) * radius)
	end

	--local a = math.rad(0)
	--table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})
	surface.DrawPoly(cir)
end

local menuPanel
hg.radialOptions = hg.radialOptions or {}
local colBlack = Color(0, 0, 0, 122)
local colWhite = Color(255, 255, 255, 255)
local colWhiteTransparent = Color(255, 255, 255, 122)
local colTransparent = Color(0, 0, 0, 0)
local matHuy = Material("vgui/white")
local vecXY = Vector(0, 0)
local vecDown = Vector(0, 1)
local isMouseIntersecting = false
local isMouseOnRadial = false
local current_option = 1
local current_option_select = 1
local hook_Run = hook.Run
local function dropWeapon()
	RunConsoleCommand("say", "*drop")
end

hook.Add("radialOptions", "!Main", function()
	if not LocalPlayer().organism.otrub then
		local tbl = {dropWeapon, "Drop Weapon"}
		hg.radialOptions[#hg.radialOptions + 1] = tbl
	end
end)

local function CreateRadialMenu()
	local sizeX, sizeY = ScrW(), ScrH()
	hg.radialOptions = {}
	hook_Run("radialOptions")
	local options = hg.radialOptions
	if IsValid(menuPanel) then
		menuPanel:Remove()
		menuPanel = nil
	end

	menuPanel = vgui.Create("DPanel")
	menuPanel:SetPos(ScrW() / 2 - sizeX / 2, ScrH() / 2 - sizeY / 2)
	menuPanel:SetSize(sizeX, sizeY)
	menuPanel:MakePopup()
	menuPanel:SetKeyBoardInputEnabled(false)
	input.SetCursorPos(sizeX / 2, sizeY / 2)
	menuPanel.Paint = function(self, w, h)
		local x, y = input.GetCursorPos()
		x = x - sizeX / 2
		y = y - sizeY / 2
		vecXY.x = x
		vecXY.y = y
		local deg = (vecXY:GetNormalized() - vecDown):Angle()
		deg = (deg[2] - 180) * 2
		for num, option in pairs(options) do
			local num = num - 1
			local r = 400
			local partDeg = 360 / #options
			local sqrt = math.sqrt(x ^ 2 + y ^ 2)
			isMouseOnRadial = sqrt <= r and sqrt > 4
			isMouseIntersecting = isMouseOnRadial and deg > num * partDeg and deg < (num + 1) * partDeg
			if isMouseIntersecting then current_option = num + 1 end
			if option[3] then
				surface.SetMaterial(matHuy)
				surface.SetDrawColor(isMouseIntersecting and colBlack or colBlack)
				draw.CirclePart(w / 2, h / 2, r, 30, #options, num)
				local count = #option[4]
				local selectedPart = math.floor((r - sqrt) / (r / count)) + 1
				current_option_select = selectedPart
				for i, opt in pairs(option[4]) do
					local selected = selectedPart == i
					surface.SetMaterial(matHuy)
					surface.SetDrawColor((selected and isMouseIntersecting) and colWhiteTransparent or colTransparent)
					draw.CirclePart(w / 2, h / 2, r / i, 30, #options, num)
					local a = -partDeg * num - partDeg / 2
					a = math.rad(a)
					draw.DrawText(opt, "HomigradFontBig", ScrW() / 2 + math.sin(a) * r / i / 1.5, ScrH() / 2 + math.cos(a) * r / i / 1.5, colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				continue
			end

			surface.SetMaterial(matHuy)
			surface.SetDrawColor(isMouseIntersecting and colWhiteTransparent or colBlack)
			draw.CirclePart(w / 2, h / 2, r, 30, #options, num)
			local a = -partDeg * num - partDeg / 2
			a = math.rad(a)
			draw.DrawText(option[2], "HomigradFontBig", ScrW() / 2 + math.sin(a) * r / 1.5, ScrH() / 2 + math.cos(a) * r / 1.5, colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

local function PressRadialMenu()
	local options = hg.radialOptions
	--print(options[current_option][1])
	if IsValid(menuPanel) and options[current_option] and isMouseOnRadial then
		local func = options[current_option][1]
		if isfunction(func) then func(current_option_select) end
	end

	if IsValid(menuPanel) then
		menuPanel:Remove()
		menuPanel = nil
	end
end

local firstTime = true
local firstTime2 = true
local firstTime3 = true
local firstTime4 = true
hook.Add("Think", "hg-radial-menu", function()
	if (engine.ActiveGamemode() ~= "sandbox" and input.IsKeyDown(KEY_C)) or (engine.ActiveGamemode() == "sandbox" and input.IsKeyDown(KEY_C)) then
		if firstTime then
			firstTime = false
			CreateRadialMenu()
		end

		firstTime4 = true
	else
		if firstTime4 then
			firstTime4 = false
			PressRadialMenu()
		end

		firstTime = true
	end

	if input.IsMouseDown(MOUSE_LEFT) then
		if firstTime2 then
			firstTime2 = false
			--print("pressed")
		end

		firstTime3 = true
	else
		if firstTime3 then
			firstTime3 = false
			--print("released")
			PressRadialMenu()
		end

		firstTime2 = true
	end
end)

local list = {{"arteria", 1, true}, {"bleed", 200, true}, {"hurt", 1, true}, {"brain", 0.25, true}, {"skull", 0.25, true}, {"jaw", 0.5, true}, {"spine1", 1, true}, {"spine2", 1, true}, {"spine3", 1, true}, {"chest", 1, true}, {"pelvis", 1, true}, {"heart", 0.25, true}, {"stomach", 1, true}, {"intestines", 1, true}, {"trachea", 0.5, true}, {"lleg", 2, true}, {"rleg", 2, true}, {"larm", 2, true}, {"rarm", 2, true}}
local function getEye()
	local lply = LocalPlayer()
	local att = lply:LookupAttachment("eyes")
	if not att then return lply:GetEyeTrace() end
	att = lply:GetAttachment(att)
	local tr = {}
	tr.start = att.Pos
	tr.endpos = att.Pos + lply:GetAimVector() * 75
	tr.filter = {lply}
	return util.TraceLine(tr)
end

local wound4Bones = {
	["ValveBiped.Bip01_Head1"] = "головы",
	["ValveBiped.Bip01_L_UpperArm"] = "левого плеча",
	["ValveBiped.Bip01_L_Forearm"] = "Левого предплечья",
	["ValveBiped.Bip01_L_Hand"] = "Левой кисти",
	["ValveBiped.Bip01_R_UpperArm"] = "Правого плеча",
	["ValveBiped.Bip01_R_Forearm"] = "Правого предплечья",
	["ValveBiped.Bip01_R_Hand"] = "Правой руки",
	["ValveBiped.Bip01_Pelvis"] = "живота",
	["ValveBiped.Bip01_Spine2"] = "груди",
	["ValveBiped.Bip01_L_Thigh"] = "левого бедра",
	["ValveBiped.Bip01_L_Calf"] = "левой голени",
	["ValveBiped.Bip01_L_Foot"] = "левой ступни",
	["ValveBiped.Bip01_R_Thigh"] = "правого бедро",
	["ValveBiped.Bip01_R_Calf"] = "правой голени",
	["ValveBiped.Bip01_R_Foot"] = "правой ступни"
}

local bleeds, ent, org, entr
local infoTime = 0
net.Receive("receive_org", function()
	ent = net.ReadEntity()
	entr = net.ReadEntity()
	bleeds = net.ReadTable()
	org = net.ReadTable()
	infoTime = CurTime()
end)

local font_size = 50
surface.CreateFont("HG_font", {
	font = "Arial",
	extended = false,
	size = font_size,
	weight = 500,
	outline = true
})

local severityList = {
	[1] = "Незначительное",
	[2] = "Незначительное",
	[3] = "Малое",
	[4] = "Малое",
	[5] = "Малое",
	[6] = "Среднее",
	[7] = "Среднее",
	[8] = "Среднее",
	[9] = "Обильное",
	[10] = "Обильное",
}

local stateList = {
	[0] = "Нормальное",
	[1] = "Малые ранения",
	[2] = "Малые ранения",
	[3] = "Средние ранения",
	[4] = "Средние ранения",
	[5] = "Средние ранения",
	[6] = "Обильные ранения",
	[7] = "Обильные ранения",
	[8] = "Критическое",
	[9] = "Критическое",
	[10] = "Критическое"
}

local paint = Color(0, 0, 0, 0)
local CurTime = CurTime
local gradient = Material("homigrad/vgui/gradient_left.png")
local enta
hook.Add("RenderScreenspaceEffects", "homigrad-healthcheck", function()
	if true then return end
	local lply = LocalPlayer()
	if lply.FakeRagdoll then return end
	local time = CurTime()
	local key = lply:KeyDown(IN_USE)
	if key then
		timeHold = timeHold or time
		enta = IsValid(enta) and enta or getEye().Entity
		if (timeHold or time) + 2 < time and enta then
			net.Start("receive_org")
			net.WriteEntity(enta)
			net.SendToServer()
			enta = nil
			timeHold = nil
		elseif getEye().Entity:IsRagdoll() or getEye().Entity:IsPlayer() then
			surface.SetMaterial(gradient)
			surface.DrawTexturedRect(ScrW() / 2 - 100, ScrH() / 1.5, (time - timeHold) * 100, 20)
			surface.SetFont("HG_font")
			surface.SetTextColor(255, 255, 255, (1 - math.abs((time - timeHold) - 1)) * 255)
			surface.SetTextPos(ScrW() / 2 - font_size * 2, ScrH() / 1.4)
			surface.DrawText("Осмотр...")
		end
	else
		enta = nil
		timeHold = nil
	end

	local show = bleeds and entr == getEye().Entity
	lerpActive = Lerp(0.1, lerpActive or 0, show and (key and 1) or (3 - (time - infoTime)) or 0)
	if IsValid(ent) then
		if bleeds then
			local len = #bleeds
			local count = 0
			for bone, bleed in SortedPairsByValue(bleeds, true) do
				count = count + 1
				paint.r = 255
				paint.g = bleed and math.Clamp(200 - bleed, 0, 255) or 255
				paint.b = bleed and math.Clamp(200 - bleed, 0, 255) or 255
				paint.a = lerpActive * 255
				local severityBleed = math.Clamp(math.Round(bleed / 10), 1, 10)
				local severity = severityList[severityBleed]
				surface.SetFont("HG_font")
				surface.SetTextColor(paint.r, paint.g, paint.b, paint.a)
				surface.SetTextPos(50, 20 + count * font_size)
				surface.DrawText(severity .. " кровотечение из " .. wound4Bones[ent:GetBoneName(bone)]) --.." "..math.Round(bleed,1))
				--draw.DrawText(wound4Bones[ent:GetBoneName(bone)].." "..math.Round(bleed,1),"HG_font",ScrW() / 2 - font_size * 2,ScrH() / 2 - count * font_size,paint)
			end
		end

		local middle = 0
		for i, v in pairs(list) do
			local max = isbool(v[2]) and (v[2] and 1 or 0) or v[2]
			local orgval = isbool(org[v[1]]) and (org[v[1]] and 1 or 0) or org[v[1]]
			local k = orgval ~= 0 and max ~= 0 and orgval / max or 0
			--print(v[1],k,orgval)
			middle = Lerp(0.1, middle, k)
			--print(middle)
		end

		--local state = math.Clamp(math.Round(middle,1) * 10,0,10)
		local state = 10 - math.Clamp(math.Round((ent:IsPlayer() and ent:Health() or 0) / 10), 0, 10)
		--state = hurt
		--state = org.alive and state or 10
		surface.SetFont("HG_font")
		surface.SetTextColor(255, 255, 255, lerpActive * 255)
		surface.SetTextPos(ScrW() / 2 - font_size * 2 - 150, ScrH() / 1.1)
		surface.DrawText("Состояние: " .. stateList[state])
	end
end)