local CLASS = player.RegClass("gordon")
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
    self:SetArmor(100)
	//self:SetModel("models/gordon_mkv.mdl")
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
	//self.bleed = 0
    /*if self.bleed > 15 and !bleeed then
        bleeed = true
		self:EmitSound("hl1/fvox/hev_dmg6.wav",75,100,0.5,CHAN_BODY)
    elseif self.bleed <= 0 then
        bleeed = false
        self.blood = math.Clamp(self.blood+0.5,0,5000)
    end*/
    if !self:Alive() then
        return
    end
    if self.bleed > 0 then
        self.bleed = math.Clamp(self.bleed - 1.25,0,1000)
    end
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
		self:EmitSound("hl1/fvox/hev_hlth1.wav",75,100,0.5,CHAN_BODY)
	elseif self:Health() > 100 then
		damaged = false
	end
	if self.pain > 20 and !morphine then
		morphine = true
		self.painlosing = 8
		self:EmitSound("hl1/fvox/hev_heal7.wav",75,100,0.5,CHAN_BODY)
	elseif self.pain == 0 then
		morphine = false
	end
end

function CLASS.FallDamage(self,dmg)
    if dmg < 20 then
        self:EmitSound("hl1/fvox/hev_dmg4.wav",75,100,0.5,CHAN_BODY)
    elseif dmg < 40 then
        self:EmitSound("hl1/fvox/hev_dmg5.wav",75,100,0.5,CHAN_BODY)
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

	surface.CreateFont("HEVFontDefaultSmaller",{
        font = "Bahnschrift",
        extended = true,
        size = ScreenScale(18),
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

    surface.CreateFont("HEVFontSmaller",{
        font = "Bahnschrift",
        extended = true,
        size = ScreenScale(5.5),
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

		local stimcolor = Color(255,155,0)
        local color_sight = Color(255,155,0)
		local hpcolor = Color(255,155,0)
        local bgcolor = Color(0,0,0)

		if !ply:GetNWBool("otrub") then
            --хачпэшки
            bgcolor.a = 205
            hplerp = math.min(hplerp + 1, self:Health())
            local pos = {ScrW() - ScrW()/1.15 - y_diff_round,ScrH()/1.1 + p_diff_round}
            surface.SetFont("HEVFontDefault")
            local XSize,YSize = surface.GetTextSize(hptext..hplerp)
            local XShitSize,YShitSize = surface.GetTextSize(hptext)
            draw.SimpleText(hptext,"HEVFontDefault",pos[1] - XSize,pos[2],bgcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.GlowingText(hplerp,"HEVFontDefault",pos[1] - XSize + XShitSize,pos[2],hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			
            draw.DrawText("Health","HEVFontSmall",pos[1]*1.01,pos[2]*1.005+1,hpcolor,TEXT_ALIGN_LEFT)
            draw.DrawText("Health","HEVFontSmall",pos[1]*1.01,pos[2]*1.005,hpcolor,TEXT_ALIGN_LEFT)

           --Армор
            local pos = {ScrW() - ScrW()/1.35 - y_diff_round,ScrH()/1.1 + p_diff_round}
            armlerp = math.min(armlerp + 1, self:Armor())

            surface.SetFont("HEVFontDefault")
            local XSize,YSize = surface.GetTextSize(armtext..armlerp)
            local XShitSize,YShitSize = surface.GetTextSize(armtext)
            draw.SimpleText(armtext,"HEVFontDefault",pos[1] - XSize,pos[2],bgcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.GlowingText(armlerp,"HEVFontDefault",pos[1] - XSize + XShitSize,pos[2],hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

            draw.DrawText("Armor","HEVFontSmall",pos[1]*1.01,pos[2]*1.005+1,hpcolor,TEXT_ALIGN_LEFT)
            draw.DrawText("Armor","HEVFontSmall",pos[1]*1.01,pos[2]*1.005,hpcolor,TEXT_ALIGN_LEFT)



            --Стамина
            local pos = {ScrW() - ScrW()/1.15 - y_diff_round,ScrH()/1.17 + p_diff_round}
            stamlerp = math.min(stamlerp + 1, math.Round(self:GetNWFloat("stamina",0)))

            surface.SetFont("HEVFontDefaultSmaller")
            local XSize,YSize = surface.GetTextSize(stamtext..stamlerp)
            local XShitSize,YShitSize = surface.GetTextSize(stamtext)
            draw.SimpleText(stamtext,"HEVFontDefaultSmaller",pos[1] - XSize,pos[2],bgcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.GlowingText(stamlerp,"HEVFontDefaultSmaller",pos[1] - XSize + XShitSize,pos[2],hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

            draw.DrawText("AUX Power","HEVFontSmaller",pos[1]*1.01,pos[2]*1.005+1,hpcolor,TEXT_ALIGN_LEFT)
            draw.DrawText("AUX Power","HEVFontSmaller",pos[1]*1.01,pos[2]*1.005,hpcolor,TEXT_ALIGN_LEFT)

            --Боль
            local pos = {ScrW() - ScrW()/1.35 - y_diff_round,ScrH()/1.17 + p_diff_round}
            painlerp = math.min(painlerp + 1, math.Round(self:GetNWFloat("pain",0)))

            surface.SetFont("HEVFontDefaultSmaller")
            local XSize,YSize = surface.GetTextSize(paintext..painlerp)
            local XShitSize,YShitSize = surface.GetTextSize(paintext)
            draw.SimpleText(paintext,"HEVFontDefaultSmaller",pos[1] - XSize,pos[2],bgcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.GlowingText(painlerp,"HEVFontDefaultSmaller",pos[1] - XSize + XShitSize,pos[2],hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

            draw.DrawText("Pain","HEVFontSmaller",pos[1]*1.01,pos[2]*1.005+1,hpcolor,TEXT_ALIGN_LEFT)
            draw.DrawText("Pain","HEVFontSmaller",pos[1]*1.01,pos[2]*1.005,hpcolor,TEXT_ALIGN_LEFT)

            --Прицел

            local wep = self:GetActiveWeapon()
            if IsValid(wep) and wep.ishgwep then
                local self = wep
    
                local Pos,Ang = self:GetTrace()
                local tr = util.QuickTrace(Pos,Ang:Forward() * 10000,LocalPlayer())

                local hit = tr.HitPos:ToScreen()

                SightPos.x = LerpFT(0.175,SightPos.x,hit.x)
                SightPos.y = LerpFT(0.175,SightPos.y,hit.y + 3)

                local istransp = (wep:IsSprinting() or wep.reload != nil or ply:KeyDown(IN_ATTACK2) or ply:GetNWBool("suiciding"))

                color_sight_mul = LerpFT(istransp and 0.3 or 0.15,color_sight_mul,istransp and 0 or 1)

                //print(color_sight_mul)

                color_sight.a = 255 * color_sight_mul
                
                draw.RoundedBox(0, SightPos.x - 1, SightPos.y + 2, 2, 6, color_sight)
                draw.RoundedBox(0, SightPos.x - 1, SightPos.y - 8, 2, 6, color_sight)
                draw.RoundedBox(0, SightPos.x + 2, SightPos.y - 1, 6, 2, color_sight)
                draw.RoundedBox(0, SightPos.x - 8, SightPos.y - 1, 6, 2, color_sight)
                //surface.DrawCircle(SightPos.x + 1.5,SightPos.y+1.75,5,color_sight.r,color_sight.g,color_sight.b,255 * (1 - color_sight_mul))
            else
                SightPos.x = ScrW()
                SightPos.y = ScrH()
            end

            surface.SetDrawColor(255,132,0,100)
			surface.SetMaterial(Material("sprites/mat_jack_helmoverlay_r"))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			surface.DrawTexturedRectRotated(ScrW()/2,ScrH()/1.9,ScrW(),ScrH()*1.1,180)

            /*draw.DrawText("HEALTH:"..self:Health(),"HEVFontDefaultSmalller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.1 + p_diff_round,hpcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.DrawText("ADRENALINE:"..math.Round(adr,2)..(adr > 2.5 and " DANGEROUS VALUE!" or ""),"HEVFontDefaultSmalller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.14 + p_diff_round,stimcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.DrawText("PAIN:"..math.Round(pain,2),"HEVFontDefaultSmalller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.18 + p_diff_round,stimcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.DrawText("STAMINA:"..math.Round(stam,2),"HEVFontDefaultSmalller",ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.22 + p_diff_round,stimcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

			draw.DrawText("MORPHINE:"..math.Round(painlose,2),"HEVFontDefaultSmalller",ScrW()/1.04 - y_diff_round,ScrH()/1.1 + p_diff_round,hpcolor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			draw.DrawText("BLOOD:"..math.Round(blood,2),"HEVFontDefaultSmalller",ScrW()/1.04 - y_diff_round,ScrH()/1.14 + p_diff_round,hpcolor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			draw.DrawText("HEARTBEAT PER MINUTE:"..math.Round(bpm,2),"HEVFontDefaultSmalller",ScrW()/1.04 - y_diff_round,ScrH()/1.18 + p_diff_round,hpcolor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			if ply:GetActiveWeapon().ishgwep then
				draw.DrawText("CLIP:"..ply:GetActiveWeapon():Clip1(),"HEVFontDefault",ScrW()/1.44 - y_diff_round,ScrH()/1.34 + p_diff_round,hpcolor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
				draw.DrawText("AMMO:"..ply:GetAmmoCount( ply:GetActiveWeapon():GetPrimaryAmmoType() ),"HEVFontDefault",ScrW()/1.44 - y_diff_round,ScrH()/1.22 + p_diff_round,hpcolor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			end*/
			//draw.RoundedBox(0,ScrW() - ScrW()/1.04 - y_diff_round,ScrH()/1.18 + p_diff_round,250,110,Color(0,0,0,100))
		end
	end

end