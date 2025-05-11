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
	self:SetHealth(200)
	self:SetMaxHealth(200)
	self:Give("weapon_hands")
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
        size = ScreenScale(12),
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


	function CLASS.HUDPaint(self)
		local ply = self
		prevang = LerpAngleFT(0.04,prevang or Angle(0,0,0),ply:EyeAngles() + AngleRand(-3,3))

		local ydiff = math.AngleDifference(prevang.y,ply:EyeAngles().y)
		local pdiff = math.AngleDifference(prevang.p,ply:EyeAngles().p)
		local y_diff_round = math.Round(ydiff,1)
		local p_diff_round = math.Round(pdiff,1)

		adr = LerpFT(0.1,adr or 0,self:GetNWFloat("adrenaline"))
		pain = LerpFT(0.1,pain or 0,self:GetNWFloat("pain"))
		stam = LerpFT(0.1,stam or 0,self:GetNWFloat("stamina"))
		painlose = LerpFT(0.1,painlose or 0,self:GetNWFloat("painlosing"))
		blood = LerpFT(0.1,blood or 0,self:GetNWFloat("blood"))
		bpm = LerpFT(0.1,bpm or 0,self:GetNWFloat("pulse"))

		local cum = math.Clamp((1.5 - adr),0,1)
		local hpcum = math.Clamp((self:Health() / 200),0,1)

		stimcolor = Color(15 * adr * 5,165 * cum * 2,165 * cum * 2,220 * (1 - pain / 50))
		hpcolor = Color(15 * (1 - hpcum) * 5,165 * hpcum * 2,165 * hpcum * 2,220 * (1 - pain / 50))

		if !ply:GetNWBool("otrub") then
			surface.SetMaterial(Material("arc9/shadow.png"))
			surface.SetDrawColor(0,0,0,50)
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())

			surface.SetMaterial(Material("arc9/bgvignette.png"))
			surface.SetDrawColor(0,0,0,250)
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())

			draw.DrawText("HEALTH:"..self:Health(),"CMBFontDefaultSmaller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.1 + p_diff_round,hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.DrawText("ADRENALINE:"..math.Round(adr,2)..(adr > 2.5 and " DANGEROUS VALUE!" or ""),"CMBFontDefaultSmaller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.14 + p_diff_round,stimcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.DrawText("PAIN:"..math.Round(pain,2),"CMBFontDefaultSmaller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.18 + p_diff_round,stimcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

			draw.DrawText("MORPHINE:"..math.Round(painlose,2),"CMBFontDefaultSmaller",ScrW()/1.04 - y_diff_round,ScrH()/1.1 + p_diff_round,Color(15,165,165,220),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			draw.DrawText("BLOOD:"..math.Round(blood,2),"CMBFontDefaultSmaller",ScrW()/1.04 - y_diff_round,ScrH()/1.14 + p_diff_round,Color(15,165,165,220),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			draw.DrawText("HEARTBEAT PER MINUTE:"..math.Round(bpm,2),"CMBFontDefaultSmaller",ScrW()/1.04 - y_diff_round,ScrH()/1.18 + p_diff_round,Color(15,165,165,220),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			if ply:GetActiveWeapon().ishgwep then
				draw.DrawText("CLIP:"..ply:GetActiveWeapon():Clip1(),"CMBFontDefault",ScrW()/1.44 - y_diff_round,ScrH()/1.34 + p_diff_round,Color(15,165,165,220),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
				draw.DrawText("AMMO:"..ply:GetAmmoCount( ply:GetActiveWeapon():GetPrimaryAmmoType() ),"CMBFontDefault",ScrW()/1.44 - y_diff_round,ScrH()/1.22 + p_diff_round,Color(15,165,165,220),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			end
			//draw.RoundedBox(0,ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.18 + p_diff_round,250,110,Color(0,0,0,100))
		else
			draw.DrawText("H.U.D CONNECTION LOST","CMBFontDefaultSmaller",ScrW() / 2 - y_diff_round,ScrH()/2.05 + p_diff_round,Color(200,0,0,255 * (1 - pain / 100)),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.DrawText("VISIBLITY LOST","CMBFontDefaultSmaller",ScrW() / 2 - y_diff_round,ScrH()/1.95 + p_diff_round,Color(200,0,0,255 * (1 - pain / 100)),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			//draw.DrawText("TRYING TO REBOOT"..string.rep(".", shit),"CMBFontDefaultSmaller",ScrW() / 2 - y_diff_round,ScrH()/1.9 + p_diff_round,Color(200,0,0,255 * (1 - pain / 100)),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end

end