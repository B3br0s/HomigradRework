local CLASS = player.RegClass("combine")
local adr = 0
local pain = 0
local stam = 0
local painlose = 0
local blood = 0
local bpm = 0
function CLASS.Off(self)
	if CLIENT then return end
	self.isCombine = nil
end

function CLASS.On(self)
	if CLIENT then return end
	self:SetHealth(125)
	self:SetMaxHealth(125)
	self:SetArmor(25)
	self:Give("weapon_hands")
	self.isCombine = true
	self:EmitSound("npc/combine_soldier/vo/gosharp.wav")
end

function CLASS.PlayerFootstep(self, pos, foot, name, volume, filter)
	if SERVER then return true end
	sound.Play(Sound("npc/combine_soldier/gear" .. math.random(1, 6) .. ".wav"), pos, 75, 100, 1)
	sound.Play(name, pos, 75, 100, volume)
	return true
end

local function getList(self)
	local list = {}
	for _, ply in RandomPairs(player.GetAll()) do
		if ply == self or not ply.isCombine then continue end
		local pos = ply:EyePos()
		local deathPos = self:GetPos()
		if pos:Distance(deathPos) > 1000 then continue end
		local trace = {
			start = pos
		}
		trace.endpos = deathPos
		trace.filter = ply
		if util.TraceLine(trace).HitPos:Distance(deathPos) <= 512 then
			list[#list + 1] = ply
		end
	end

	return list
end

function CLASS.PlayerDeath(self)
	sound.Play(Sound("npc/overwatch/radiovoice/die" .. math.random(1, 3) .. ".wav"), self:GetPos())
	for _, ply in RandomPairs(getList(self)) do
		ply:EmitSound(Sound("npc/combine_soldier/vo/ripcordripcord.wav"))
		break
	end

	self:SetPlayerClass()
end

function CLASS.Think(self)
	self.bleed = 0
end

function CLASS.PlayerStartVoice(self)
	for _, ply in player.Iterator() do
		if not ply.isCombine then continue end

		ply:EmitSound("npc/combine_soldier/vo/on" .. math.random(1, 3) .. ".wav")
	end
end

function CLASS.PlayerEndVoice(self)
	for _, ply in player.Iterator() do
		if not ply.isCombine then continue end

		ply:EmitSound("npc/combine_soldier/vo/off" .. math.random(1, 3) .. ".wav")
	end
end

function CLASS.CanLisenOutput(output, input, isChat)
	if not output:Alive() then return false end
end

function CLASS.CanLisenInput(input, output, isChat)
	if not output:Alive() then return false end
end

function CLASS.HomigradDamage(self, hitGroup, dmgInfo, rag)
	if (self.delaysoundpain or 0) > CurTime() then
		self.delaysoundpain = CurTime() + math.Rand(0.25, 0.5)

		self:EmitSound("npc/combine_soldier/pain" .. math.random(1, 3) .. ".wav")
	end
end

if CLIENT then

	surface.CreateFont("CMBFontDefault",{
        font = "Roboto Light",
        extended = true,
        size = ScreenScale(24),
        weight = 500,
        scanlines = 3,
        antialias = true
    })

	surface.CreateFont("CMBFontDefaultSmaller",{
        font = "Roboto Light",
        extended = true,
        size = ScreenScale(18),
        weight = 500,
        scanlines = 3,
        antialias = true
    })

    surface.CreateFont("CMBFontSmall",{
        font = "Roboto Light",
        extended = true,
        size = ScreenScale(7.5),
        weight = 1500,
        scanlines = 3,
        antialias = true
    })

	surface.CreateFont("CMBFontSmaller",{
        font = "Roboto Light",
        extended = true,
        size = ScreenScale(6.5),
        weight = 1500,
        scanlines = 3,
        antialias = true
    })

    surface.CreateFont("CMBFontSmallBG",{
        font = "Roboto Light",
        extended = true,
        size = ScreenScale(7.5),
        weight = 500,
        blursize = 1,
        scanlines = 3,
        antialias = true
    })

    surface.CreateFont("CMBFontDefaultBG",{
        font = "Roboto Light",
        extended = true,
        size = ScreenScale(24.5),
        weight = 1500,
        blursize = 1,
        scanlines = 3,
        antialias = true
    })


	    function draw.GlowingText(text, font, x, y, color, xalign, yalign )

	    local xalign = xalign or TEXT_ALIGN_LEFT
        
	    local yalign = yalign or TEXT_ALIGN_TOP

	    local initial_a = 10

	    local a_by_i = 2

	    local alpha_glow = 1

	    for i = 1, 5 do

	    	draw.SimpleTextOutlined( text, font, x, y, color, xalign, yalign, i, Color( color.r, color.g, color.b, ( initial_a - ( i * a_by_i ) ) * alpha_glow ) )

	    end

	    draw.SimpleText( text, font, x, y, color, xalign, yalign )

    end

    local hplerp = 0
    local armlerp = 0
    local stamlerp = 0
    local painlerp = 0
    local hptext = ""
    local armtext = ""
    local stamtext = ""
    local paintext = ""
    local adr = 0
    local pain = 0
    local stam = 0
    local painlose = 0
    local blood = 0
    local bpm = 0
    local color_sight_mul = 1

    local SightPos = {x = ScrW()/2,y = ScrH()/2}

	function CLASS.HUDPaint(self)
		local ply = self
		prevang = LerpAngleFT(0.04,prevang or Angle(0,0,0),ply:EyeAngles() + AngleRand(-3,3))

        if hplerp < 10 then
            hptext = "00"
        elseif hplerp <= 99 then
            hptext = "0"
        else
            hptext = ""
        end

        if armlerp < 10 then
            armtext = "00"
        elseif armlerp <= 99 then
            armtext = "0"
        else
            armtext = ""
        end

        if stamlerp < 10 then
            stamtext = "00"
        elseif stamlerp <= 99 then
            stamtext = "0"
        else
            stamtext = ""
        end

        if painlerp < 10 then
            paintext = "00"
        elseif painlerp <= 99 then
            paintext = "0"
        else
            paintext = ""
        end

		local ydiff = math.AngleDifference(prevang.y,ply:EyeAngles().y)
		local pdiff = math.AngleDifference(prevang.p,ply:EyeAngles().p)
		local y_diff_round = math.Round(ydiff,1)
		local p_diff_round = math.Round(pdiff,1)

		/*adr = LerpFT(0.1,adr or 0,self:GetNWFloat("adrenaline"))
		pain = LerpFT(0.1,pain or 0,self:GetNWFloat("pain"))
		stam = LerpFT(0.1,stam or 0,self:GetNWFloat("stamina"))
		painlose = LerpFT(0.1,painlose or 0,self:GetNWFloat("painlosing"))
		blood = LerpFT(0.1,blood or 0,self:GetNWFloat("blood"))
		bpm = LerpFT(0.1,bpm or 0,self:GetNWFloat("pulse"))*/

		local stimcolor = Color(21,96,189,220)
        local color_sight = Color(21,96,189)
		local hpcolor = Color(21,96,189)
        local bgcolor = Color(0,0,0)

		for _, ply in ipairs(player.GetAll()) do
					if ply == self then
						continue 
					end
				
					if ply:GetNWBool("IsCombine") then
						local ent = hg.GetCurrentCharacter(ply)
                        if !IsValid(ent) then
                            ent = ply
                        end
						local ts = (ent:GetPos() + ent:OBBCenter()):ToScreen()
						local ts2 = (ent:GetPos()):ToScreen()
						if !ply:Alive() then
						//continue 
							draw.SimpleText("NOT RESPONDING","CMBFontSmall",ts.x,ts2.y,Color(165,15,15,220),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
						else
							draw.SimpleText(ply:GetNWString("UNIT_NAME","UNDEFINED"),"CMBFontSmall",ts.x,ts2.y,ply:GetNWBool("IsCombineSuper") and Color(165,15,15) or Color(21,96,189),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
							halo.Add({ent},ply:GetNWBool("IsCombineSuper") and Color(165,15,15) or Color(21,96,189),1,1,1,true,true)
						end
					end
		end

		if !ply:GetNWBool("otrub") then
            --хачпэшки
            bgcolor.a = 205
            hplerp = math.min(hplerp + 1, self:Health())
            local pos = {ScrW() - ScrW()/1.15 - y_diff_round,ScrH()/1.1 + p_diff_round}
            surface.SetFont("CMBFontDefault")
            local XSize,YSize = surface.GetTextSize(hptext..hplerp)
            local XShitSize,YShitSize = surface.GetTextSize(hptext)
            draw.SimpleText(hptext,"CMBFontDefault",pos[1] - XSize,pos[2],bgcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.GlowingText(hplerp,"CMBFontDefault",pos[1] - XSize + XShitSize,pos[2],hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			
            draw.DrawText("Health","CMBFontSmall",pos[1]*1.01,pos[2]*1.005+1,hpcolor,TEXT_ALIGN_LEFT)
            draw.DrawText("Health","CMBFontSmall",pos[1]*1.01,pos[2]*1.005,hpcolor,TEXT_ALIGN_LEFT)

           --Армор
            local pos = {ScrW() - ScrW()/1.35 - y_diff_round,ScrH()/1.1 + p_diff_round}
            armlerp = math.min(armlerp + 1, self:Armor())

            surface.SetFont("CMBFontDefault")
            local XSize,YSize = surface.GetTextSize(armtext..armlerp)
            local XShitSize,YShitSize = surface.GetTextSize(armtext)
            draw.SimpleText(armtext,"CMBFontDefault",pos[1] - XSize,pos[2],bgcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.GlowingText(armlerp,"CMBFontDefault",pos[1] - XSize + XShitSize,pos[2],hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

            draw.DrawText("Armor","CMBFontSmall",pos[1]*1.01,pos[2]*1.005+1,hpcolor,TEXT_ALIGN_LEFT)
            draw.DrawText("Armor","CMBFontSmall",pos[1]*1.01,pos[2]*1.005,hpcolor,TEXT_ALIGN_LEFT)



            --Стамина
            local pos = {ScrW() - ScrW()/1.15 - y_diff_round,ScrH()/1.17 + p_diff_round}
            stamlerp = math.min(stamlerp + 1, math.Round(self:GetNWFloat("stamina",0)))

            surface.SetFont("CMBFontDefaultSmaller")
            local XSize,YSize = surface.GetTextSize(stamtext..stamlerp)
            local XShitSize,YShitSize = surface.GetTextSize(stamtext)
            draw.SimpleText(stamtext,"CMBFontDefaultSmaller",pos[1] - XSize,pos[2],bgcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.GlowingText(stamlerp,"CMBFontDefaultSmaller",pos[1] - XSize + XShitSize,pos[2],hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

            draw.DrawText("Stamina","CMBFontSmaller",pos[1]*1.01,pos[2]*1.005+1,hpcolor,TEXT_ALIGN_LEFT)
            draw.DrawText("Stamina","CMBFontSmaller",pos[1]*1.01,pos[2]*1.005,hpcolor,TEXT_ALIGN_LEFT)

            --Боль
            local pos = {ScrW() - ScrW()/1.35 - y_diff_round,ScrH()/1.17 + p_diff_round}
            painlerp = math.min(painlerp + 1, math.Round(self:GetNWFloat("pain",0)))

            surface.SetFont("CMBFontDefaultSmaller")
            local XSize,YSize = surface.GetTextSize(paintext..painlerp)
            local XShitSize,YShitSize = surface.GetTextSize(paintext)
            draw.SimpleText(paintext,"CMBFontDefaultSmaller",pos[1] - XSize,pos[2],bgcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.GlowingText(painlerp,"CMBFontDefaultSmaller",pos[1] - XSize + XShitSize,pos[2],hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

            draw.DrawText("Pain","CMBFontSmaller",pos[1]*1.01,pos[2]*1.005+1,hpcolor,TEXT_ALIGN_LEFT)
            draw.DrawText("Pain","CMBFontSmaller",pos[1]*1.01,pos[2]*1.005,hpcolor,TEXT_ALIGN_LEFT)

            surface.SetDrawColor(0,119,255,100)
			surface.SetMaterial(Material("sprites/mat_jack_helmoverlay_r"))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			surface.DrawTexturedRectRotated(ScrW()/2,ScrH()/1.9,ScrW(),ScrH()*1.1,180)

        else
			draw.DrawText("H.U.D CONNECTION LOST","CMBFontDefaultSmaller",ScrW() / 2 - y_diff_round,ScrH()/2.05 + p_diff_round,Color(200,0,0,255 * (1 - pain / 100)),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.DrawText("VISIBLITY LOST","CMBFontDefaultSmaller",ScrW() / 2 - y_diff_round,ScrH()/1.95 + p_diff_round,Color(200,0,0,255 * (1 - pain / 100)),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			//draw.DrawText("TRYING TO REBOOT"..string.rep(".", shit),"CMBFontDefaultSmaller",ScrW() / 2 - y_diff_round,ScrH()/1.9 + p_diff_round,Color(200,0,0,255 * (1 - pain / 100)),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end

end