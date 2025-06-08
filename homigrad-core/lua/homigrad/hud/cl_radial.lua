local radialOpen = false
local prevSelected, prevSelectedVertex
local elmss = {}
local elements = {
    [1] = {Name = "hg_posture", Action = function() LocalPlayer():ConCommand("hg_change_posture") end},
    //[2] = {Name = "hg_suicide", Action = function() if !LocalPlayer():GetNWBool("suiciding") then RunConsoleCommand("suicide") end RunConsoleCommand("+attack") timer.Simple(0,function() RunConsoleCommand("-attack") end) end}
    [2] = {Name = "hg_resetposture", Action = function() LocalPlayer():ConCommand("hg_change_posture 1") end},
    [3] = {Name = "hg_unload", Action = function() LocalPlayer():ConCommand("hg_unload") end},
    [4] = {Name = "hg_drop", Action = function() LocalPlayer():ConCommand("say *drop") end}
}
function OpenRadialMenu(elms)
	if not LocalPlayer():Alive() then return end
	elmss = elms
	radialOpen = true
	LocalPlayer():SetNWBool("radialopen", true)
	gui.EnableScreenClicker(true)
	prevSelected = nil
end

function CloseRadialMenu()
	radialOpen = false
	LocalPlayer():SetNWBool("radialopen", false)
	gui.EnableScreenClicker(false)
end

local function getSelected()
	local mx, my = gui.MousePos()
	local sw, sh = ScrW(), ScrH()
	local total = #elmss
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

function RadialMousePressed(code, vec)
	if radialOpen then
		local selected = getSelected()
		if selected and selected > 0 and code == MOUSE_LEFT then
            //print(ments)
			if selected and elmss[selected] then
                //PrintTable(elmss[selected])
				elmss[selected]:Action()
			end
		end

		CloseRadialMenu()
	end
end

local tex = surface.GetTextureID("VGUI/white.vmt")
local function drawShadow(n, f, x, y, color, pos)
	local colorr_black = Color(0,0,0,color.a)
	draw.DrawText(n, f, x + 1, y + 1, colorr_black, pos)
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
local fontHeight = draw.GetFontHeight("hg_HomicideMedium")
local anim = 0
function DrawRadialMenu()
	anim = LerpFT(math.ease.OutBounce(radialOpen and 0.1 or 0.15),anim,radialOpen and 1 or 0)
	//if radialOpen then
		local sw, sh = ScrW(), ScrH()
		local total = #elmss
		local w = math.min(sw * 0.6, sh * 0.45) *  anim
		local h = w
		local sx, sy = sw / 2, sh / 2
		local selected = getSelected() or -1
		//if not circleVertex then
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
		//end

		surface.SetTexture(tex)
		local defaultTextCol = Color(255,255,255)
		if selected <= 0 or selected ~= selected then
			local col = LocalPlayer():GetPlayerColor():ToColor()
			surface.SetDrawColor(col.r, col.g, col.b, 180)
		else
			local col = LocalPlayer():GetPlayerColor():ToColor()
			surface.SetDrawColor(col.r, col.g, col.b, 120)
			defaultTextCol = Color(col.r * 1.5, col.g * 1.5, col.b * 2, 180)
		end

		surface.DrawPoly(circleVertex)
		local add = math.pi * 1.5 + math.pi / total
		local add2 = math.pi * 1.5 - math.pi / total
		for k, ment in ipairs(elmss) do
			local x, y = math.cos((k - 1) / total * math.pi * 2 + math.pi * 1.5), math.sin((k - 1) / total * math.pi * 2 + math.pi * 1.5)
			local lx, ly = math.cos((k - 1) / total * math.pi * 2 + add), math.sin((k - 1) / total * math.pi * 2 + add)
			local textCol = defaultTextCol
			if selected == k and radialOpen then
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

				surface.DrawPoly(vertexes)
				textCol = Color(255,255,255)
			end
			local ply = LocalPlayer()
			local Main, Sub

			local weapon = LocalPlayer():GetActiveWeapon()
			if hg.GetPhrase(ment.Name) != ment.Name then
				Main = hg.GetPhrase(ment.Name)
				Sub = ""    
			else
    			Main = "?"
    			Sub = "?"
			end

			textCol.a = 255 * anim

			drawShadow(Main, "hg_HomicideMedium", sx + w * 0.6 * x, sy + h * 0.6 * y - fontHeight, textCol, 1)
		end
	//end
end

hook.Add("HUDPaint","Draw_Radial",function()
    DrawRadialMenu()
end)

hook.Add("PlayerBindPress","Radial_shit",function(ply,bind,is)
    if string.match(bind, (ply:IsAdmin() and "+menu_context" or "+menu")) then
        local canopen = (ply:IsAdmin() and !ply:KeyDown(IN_USE) or !ply:IsAdmin())

		local elms = table.Copy(elements)

		if !ply:GetActiveWeapon().ishgwep then
            table.remove(elms,1)
            table.remove(elms,2)
            table.remove(elms,3)
            table.remove(elms,1)
			PrintTable(elms)
        end

        if is and canopen then
			OpenRadialMenu(elms)
        else
            RadialMousePressed(MOUSE_LEFT)
        end

        return canopen
    end
end)