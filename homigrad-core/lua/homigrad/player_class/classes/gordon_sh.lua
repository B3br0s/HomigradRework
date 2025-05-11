local CLASS = player.RegClass("gordon")
local morphine = false
local antitoxine = false
local rad = false
local on_dead = false
local critical = false
local damaged = false
local adr = 0
local pain = 0
local stam = 0
local painlose = 0
local blood = 0
local bpm = 0
//hl1/fvox/hev_hlth3.wav
//hl1/fvox/hev_hlth1.wav
//hl1/fvox/hev_hlth2.wav

if SERVER then
	util.AddNetworkString("gordon_suit")
end

function CLASS.Off(self)
	if CLIENT then return end
	self.isGordon = nil
end

function CLASS.On(self)
	if CLIENT then return end
	self:SetHealth(150)
	self:SetMaxHealth(150)
	self:SetModel("models/gordon_mkv.mdl")
	self:Give("weapon_hands")
	self.isGordon = true
	net.Start("gordon_suit")
	net.Send(self)

	morphine = false
	antitoxine = false
	rad = false
	on_dead = false
	damaged = false
end

function CLASS.Think(self)
	self.bleed = 0
	if self:Health() <= 25 and !on_dead then
		on_dead = true
		self:EmitSound("hl1/fvox/hev_hlth3.wav",75,100,0.5,CHAN_BODY)
	elseif self:Health() > 50 then
		on_dead = false
	end
	if self:Health() < 50 and !critical then
		critical = true
		self:EmitSound("hl1/fvox/hev_hlth2.wav",75,100,0.5,CHAN_BODY)
	elseif self:Health() > 50 then
		critical = false
	end
	if self:Health() < 100 and !damaged then
		damaged = true
	elseif self:Health() > 100 then
		damaged = false
		self:EmitSound("hl1/fvox/hev_hlth1.wav",75,100,0.5,CHAN_BODY)
	end
	if self.pain > 40 and !morphine then
		morphine = true
		self.painlosing = 8
		self:EmitSound("hl1/fvox/hev_heal7.wav",75,100,0.5,CHAN_BODY)
	elseif self.pain == 0 then
		morphine = false
	end
end

if CLIENT then

	surface.CreateFont("HEVFontDefault",{
        font = "Bahnschrift",
        extended = true,
        size = ScreenScale(24),
        weight = 500,
        blursize = 0,
        scanlines = 2,
        antialias = true
    })

	surface.CreateFont("HEVFontDefaultSmalller",{
        font = "Bahnschrift",
        extended = true,
        size = ScreenScale(12),
        weight = 500,
        blursize = 0,
        scanlines = 2,
        antialias = true
    })

    surface.CreateFont("HEVFontSmall",{
        font = "Bahnschrift",
        extended = true,
        size = ScreenScale(7.5),
        weight = 1500,
        blursize = 0,
        scanlines = 2,
        antialias = true
    })

    surface.CreateFont("HEVFontSmallBG",{
        font = "Bahnschrift",
        extended = true,
        size = ScreenScale(7.5),
        weight = 500,
        blursize = 1,
        scanlines = 2,
        antialias = true
    })

    surface.CreateFont("HEVFontDefaultBG",{
        font = "Bahnschrift",
        extended = true,
        size = ScreenScale(24.5),
        weight = 1500,
        blursize = 1,
        scanlines = 2,
        antialias = true
    })

	net.Receive("gordon_suit",function()
		morphine = false
		antitoxine = false
		rad = false
		on_dead = false
		critical = false
		damaged = false
	end)

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

		local stimcolor = Color(255,155,0)
		local hpcolor = Color(255,155,0)

		if !ply:GetNWBool("otrub") then
			draw.DrawText("HEALTH:"..self:Health(),"HEVFontDefaultSmalller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.1 + p_diff_round,hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.DrawText("ADRENALINE:"..math.Round(adr,2)..(adr > 2.5 and " DANGEROUS VALUE!" or ""),"HEVFontDefaultSmalller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.14 + p_diff_round,stimcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.DrawText("PAIN:"..math.Round(pain,2),"HEVFontDefaultSmalller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.18 + p_diff_round,stimcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.DrawText("STAMINA:"..math.Round(stam,2),"HEVFontDefaultSmalller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.22 + p_diff_round,stimcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

			draw.DrawText("MORPHINE:"..math.Round(painlose,2),"HEVFontDefaultSmalller",ScrW()/1.04 - y_diff_round,ScrH()/1.1 + p_diff_round,hpcolor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			draw.DrawText("BLOOD:"..math.Round(blood,2),"HEVFontDefaultSmalller",ScrW()/1.04 - y_diff_round,ScrH()/1.14 + p_diff_round,hpcolor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			draw.DrawText("HEARTBEAT PER MINUTE:"..math.Round(bpm,2),"HEVFontDefaultSmalller",ScrW()/1.04 - y_diff_round,ScrH()/1.18 + p_diff_round,hpcolor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			if ply:GetActiveWeapon().ishgwep then
				draw.DrawText("CLIP:"..ply:GetActiveWeapon():Clip1(),"HEVFontDefault",ScrW()/1.44 - y_diff_round,ScrH()/1.34 + p_diff_round,hpcolor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
				draw.DrawText("AMMO:"..ply:GetAmmoCount( ply:GetActiveWeapon():GetPrimaryAmmoType() ),"HEVFontDefault",ScrW()/1.44 - y_diff_round,ScrH()/1.22 + p_diff_round,hpcolor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			end
			//draw.RoundedBox(0,ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.18 + p_diff_round,250,110,Color(0,0,0,100))
		end
	end

end