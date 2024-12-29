local ments
local radialOpen = false
local prevSelected, prevSelectedVertex
local PhraseDelay = 0
function GM:OpenRadialMenu(elements)
	if not LocalPlayer():Alive() then return end
	radialOpen = true
	LocalPlayer():SetNWBool("radialopen", true)
	gui.EnableScreenClicker(true)
	ments = elements or {}
	prevSelected = nil
end

function GM:CloseRadialMenu()
	radialOpen = false
	LocalPlayer():SetNWBool("radialopen", false)
	gui.EnableScreenClicker(false)
end

local function getSelected()
	local mx, my = gui.MousePos()
	local sw, sh = ScrW(), ScrH()
	local total = #ments
	local w = math.min(sw * 0.45, sh * 0.33)
	local sx, sy = sw / 2, sh / 2
	local x2, y2 = mx - sx, my - sy
	local ang = 0
	local dis = math.sqrt(x2 ^ 2 + y2 ^ 2)
	if dis / w <= 1 then
		if y2 <= 0 and x2 <= 0 then
			ang = math.acos(x2 / dis)
		elseif x2 > 0 and y2 <= 0 then
			ang = -math.asin(y2 / dis)
		elseif x2 <= 0 and y2 > 0 then
			ang = math.asin(y2 / dis) + math.pi
		else
			ang = math.pi * 2 - math.acos(x2 / dis)
		end

		return math.floor((1 - (ang - math.pi / 2 - math.pi / total) / (math.pi * 2) % 1) * total) + 1
	end
end

local function hasWeapon(ply, weaponName)
    if not IsValid(ply) or not ply:IsPlayer() then return false end
    
    for _, weapon in pairs(ply:GetWeapons()) do
        if IsValid(weapon) and weapon:GetClass() == weaponName then
            return true
        end
    end
    
    return false 
end

function GM:RadialMousePressed(code, vec)
	if radialOpen then
		local selected = getSelected()
		if selected and selected > 0 and code == MOUSE_LEFT then
			if selected and ments[selected] then
				if ments[selected].Code == "changeposition" then
					RunConsoleCommand("hg_changepos")
				elseif ments[selected].Code == "menuammo" then
					RunConsoleCommand("hg_ammomenu")
				elseif ments[selected].Code == "tphrase" then
					if PhraseDelay < CurTime() then
					PhraseDelay = CurTime() + 0.5
					net.Start("TraitorPhrase")
					net.SendToServer()
					end
				elseif ments[selected].Code == "scream" then
					if PhraseDelay < CurTime() then
					PhraseDelay = CurTime() + 1.5
					net.Start("ScreamPhrase")
					net.SendToServer()
					end
				elseif ments[selected].Code == "menuarmor" then
					RunConsoleCommand("hg_inv")
				elseif ments[selected].Code == "modweapon" then
					RunConsoleCommand("hg_attmenu")
				elseif ments[selected].Code == "unloadwep" then
					local lply = LocalPlayer()
        			local wep = lply:GetActiveWeapon()
                	net.Start("Unload")
                	net.WriteEntity(wep)
                	net.SendToServer()
				elseif ments[selected].Code == "holdbreath" then
					local lply = LocalPlayer()
					lply:ConCommand("hold_breath")
				elseif ments[selected].Code == "drop" then
					local lply = LocalPlayer()
					lply:ConCommand("say *drop")
				elseif ments[selected].Code == "medmenu" then
					local lply = LocalPlayer()
					lply:ConCommand("+medkit")
				elseif ments[selected].Code == "phrase" then
					if PhraseDelay < CurTime() then
					PhraseDelay = CurTime() + 1.5
					net.Start("RandomPhrase")
					net.SendToServer()
					end
				end
			end
		end

		self:CloseRadialMenu()
	end
end

local elements
local function addElement(transCode, code)
	local t = {}
	t.TransCode = transCode
	t.Code = code
	table.insert(elements, t)
end

local isCKeyPressed = false

hook.Add("Think", "CheckCKey", function()
    local client = LocalPlayer()

    if input.IsKeyDown(KEY_C) then
        if not isCKeyPressed then
            isCKeyPressed = true

            if client:Alive() then
                local Wep = client:GetActiveWeapon()
                elements = {}
                addElement("Ammo Menu", "menuammo")
                addElement("RandomPhrase", "phrase")
                addElement("ScreamPhrase", "scream")
                addElement("Armor Menu", "menuarmor")
                if IsValid(Wep) then
                    if Wep:GetClass() ~= "weapon_hands" and Wep:GetClass() ~= "weapon_096" then addElement("Drop", "drop") end
                    if client.roleT then addElement("Traitor Phrase", "tphrase") end
                    if Wep.Base == "b3bros_base" then
                        addElement("Modifywep", "modweapon")
                    end
                    if Wep:Clip1() > 0 and (Wep.Base == 'b3bros_base' or Wep.Base == 'swep_base') then
                        addElement("UnloadWep", "unloadwep")
                    end
                end
                GAMEMODE:OpenRadialMenu(elements)
            end
        end
    else
        if isCKeyPressed then
            isCKeyPressed = false

            GAMEMODE:RadialMousePressed(MOUSE_LEFT)
        end
    end
end)

local tex = surface.GetTextureID("VGUI/white.vmt")
local function drawShadow(n, f, x, y, color, pos)
	draw.DrawText(n, f, x + 1, y + 1, color_black, pos)
	draw.DrawText(n, f, x, y, color, pos)
end

local function DrawCenteredText(text, font, x, y, color, outlineColor)
    surface.SetFont(font)
    local textWidth, textHeight = surface.GetTextSize(text)
    surface.SetTextColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
    surface.SetTextPos(x - textWidth / 2, y - textHeight / 2)
    surface.SetDrawColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
    surface.DrawText(text)

    surface.SetTextColor(color.r, color.g, color.b, color.a)
    surface.SetTextPos(x - textWidth / 2 + 1, y - textHeight / 2 + 1)
    surface.DrawText(text)
end

local function DrawAmmoIcon(material, x, y, widght, height)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( material )
    surface.DrawTexturedRect( x, y, widght, height)
end

local circleVertex
local fontHeight = 5

function GM:DrawRadialMenu()
	if radialOpen then
		local sw, sh = ScrW(), ScrH()
		local total = #ments
		local w = math.min(sw * 0.45, sh * 0.33)
		local h = w
		local sx, sy = sw / 2, sh / 2
		local selected = getSelected() or -1
		if not circleVertex then
			circleVertex = {}
			local max = 50
			for i = 0, max do
				local vx, vy = math.cos((math.pi * 2) * i / max), math.sin((math.pi * 2) * i / max)
				table.insert(
					circleVertex,
					{
						x = sx + w * 1 * vx,
						y = sy + h * 1 * vy
					}
				)
			end
		end

		surface.SetTexture(tex)
		local defaultTextCol = color_white
		if selected <= 0 or selected ~= selected then
			surface.SetDrawColor(20, 20, 20, 180)
		else
			surface.SetDrawColor(20, 20, 20, 120)
			defaultTextCol = Color(150, 150, 150)
		end

		surface.DrawPoly(circleVertex)
		local add = math.pi * 1.5 + math.pi / total
		local add2 = math.pi * 1.5 - math.pi / total
		for k, ment in pairs(ments) do
			local x, y = math.cos((k - 1) / total * math.pi * 2 + math.pi * 1.5), math.sin((k - 1) / total * math.pi * 2 + math.pi * 1.5)
			local lx, ly = math.cos((k - 1) / total * math.pi * 2 + add), math.sin((k - 1) / total * math.pi * 2 + add)
			local textCol = defaultTextCol
			if selected == k then
				local vertexes = prevSelectedVertex -- uhh, you mean VERTICES? Dumbass.
				if prevSelected ~= selected then
					prevSelected = selected
					vertexes = {}
					prevSelectedVertex = vertexes
					local lx2, ly2 = math.cos((k - 1) / total * math.pi * 2 + add2), math.sin((k - 1) / total * math.pi * 2 + add2)
					table.insert(
						vertexes,
						{
							x = sx,
							y = sy
						}
					)

					table.insert(
						vertexes,
						{
							x = sx + w * 1 * lx2,
							y = sy + h * 1 * ly2
						}
					)

					local max = math.floor(50 / total)
					for i = 0, max do
						local addv = (add - add2) * i / max + add2
						local vx, vy = math.cos((k - 1) / total * math.pi * 2 + addv), math.sin((k - 1) / total * math.pi * 2 + addv)
						table.insert(
							vertexes,
							{
								x = sx + w * 1 * vx,
								y = sy + h * 1 * vy
							}
						)
					end

					table.insert(
						vertexes,
						{
							x = sx + w * 1 * lx,
							y = sy + h * 1 * ly
						}
					)
				end

				
				surface.SetTexture(tex)
				surface.SetDrawColor(129, 129, 129, 120)
				if ment.Code == "tphrase" then
					surface.SetTexture(tex)
					surface.SetDrawColor(255, 0, 0, 120)
				end

				surface.DrawPoly(vertexes)
				textCol = color_white
			end
			local ply = LocalPlayer()
			local Main, Sub

			local weapon = LocalPlayer():GetActiveWeapon()
			if ment.TransCode == "ChangePosition" then
				Main = "Сменить Позицию"
				Sub = ""
			elseif ment.TransCode == "Ammo Menu" then
				Main = "Аммуниция"
				Sub = ""
			elseif ment.TransCode == "Armor Menu" then
				Main = "Инвентарь"
				Sub = ""
			elseif ment.TransCode == "UnloadWep" then
				Main = "Разрядить"
				Sub = ""
			elseif ment.TransCode == "Drop" then
				Main = "Выкинуть"
				Sub = ""
			elseif ment.TransCode == "RandomPhrase" then
				Main = "Сказать что то"
				Sub = ""
			elseif ment.TransCode == "ScreamPhrase" then
				Main = "Кричать"
				Sub = ""
			elseif ment.TransCode == "Modifywep" then
				Main = "Модифицировать Оружие"
				Sub = ""
			elseif ment.TransCode == "Traitor Phrase" then
				Main = "Фраза Предателя"
				Sub = ""
			else
    			Main = "?"
    			Sub = "?"
			end

			drawShadow(Main, "MersRadialSmall", sx + w * 0.6 * x, sy + h * 0.6 * y - fontHeight, textCol, 1)
		end
	end
end