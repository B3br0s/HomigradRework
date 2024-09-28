zombieinfection.GetTeamName = tdm.GetTeamName

local colorSpec = ScoreboardSpec
function zombieinfection.Scoreboard_Status(ply)
	local lply = LocalPlayer()
	if not lply:Alive() or lply:Team() == 1002 then return true end

	return "Неизвестно",colorSpec
end

surface.CreateFont("CenterTextFont", {
    font = "Trebuchet24", -- Font name
    size = 48,            -- Font size
    weight = 500,         -- Font weight (thickness)
    antialias = true,     -- Enable antialiasing
})


local AM = 12
local aABASDBASDBABDSB = true
local aABASDBASDBABDSBa = true
local aABASDBASDBABDSBaa = true

local green = Color(0,125,0)
local white = Color(255,255,255)

    local flashDuration = 13  -- Flash duration in seconds
    local flashStartTime = 0
    local isFlashing = false

    -- Function to trigger the screen flash
function FlashScreen()
        flashStartTime = CurTime()  -- Set the start time of the flash
        flashBrightness = 2.0       -- Set initial brightness level for flash
        isFlashing = true
end

    -- Hook to handle the color correction and brightness effect
    hook.Add("RenderScreenspaceEffects", "FlashScreenEffect", function()
        if isFlashing then
            -- Calculate how much time has passed since the flash started
            local elapsedTime = CurTime() - flashStartTime

            -- If the flash is still within the duration, reduce brightness over time
            if elapsedTime <= flashDuration then
                local brightness = flashBrightness * (1 - (elapsedTime / flashDuration))
                
                -- Apply the color correction effect with the calculated brightness
                DrawColorModify({
                    ["$pp_colour_addr"] = 0,
                    ["$pp_colour_addg"] = 0,
                    ["$pp_colour_addb"] = 0,
                    ["$pp_colour_brightness"] = brightness,
                    ["$pp_colour_contrast"] = 1,
                    ["$pp_colour_colour"] = 1,
                    ["$pp_colour_mulr"] = 0,
                    ["$pp_colour_mulg"] = 0,
                    ["$pp_colour_mulb"] = 0
                })
            else
                -- Stop the flash after the duration is over
                isFlashing = false
            end
        end
    end)

function zombieinfection.HUDPaint_RoundLeft(white2,time)
	local time = math.Round(roundTimeStart + roundTime - CurTime())
	local acurcetime = string.FormattedTime(time,"%02i:%02i")
	local lply = LocalPlayer()
	local name,color = zombieinfection.GetTeamName(lply)

	local startRound = roundTimeStart + 2 - CurTime()
    if startRound > 0 and lply:Alive() then
		if time >= 595 then
			if aABASDBASDBABDSB == true then
                AM = 12
				aABASDBASDBABDSB = false
				surface.PlaySound("infectionround/infectionroundstart.wav")
				timer.Simple(10,function() aABASDBASDBABDSB = true end )
				timer.Simple(14.2,function() FlashScreen() surface.PlaySound("weapons/underwater_explode3.wav") surface.PlaySound("weapons/underwater_explode3.wav") surface.PlaySound("weapons/underwater_explode3.wav")surface.PlaySound("weapons/underwater_explode3.wav") surface.PlaySound("weapons/underwater_explode3.wav") surface.PlaySound("weapons/underwater_explode3.wav") surface.PlaySound("weapons/underwater_explode3.wav") surface.PlaySound("weapons/underwater_explode3.wav") end )
			end
		end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.1,0.1)

		lply:SetNWBool("INFECTED",false)
        return
    end
	if time > 0 then
		draw.SimpleText(AM.." AM","HomigradFont",ScrW() / 2,ScrH()-25,white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
    --draw.SimpleText("До рассвета : ","HomigradFont",ScrW() / 2 - 200,ScrH()-25,white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        if time == 500 then
			if aABASDBASDBABDSBaa == true then
                AM = 1
				aABASDBASDBABDSBaa = false
                timer.Simple(10,function() aABASDBASDBABDSBaa = true end )
				surface.PlaySound("ambient/alarms/warningbell1.wav")
			end
		end
        if time == 400 then
			if aABASDBASDBABDSBaa == true then
                AM = 2
				aABASDBASDBABDSBaa = false
                timer.Simple(10,function() aABASDBASDBABDSBaa = true end )
				surface.PlaySound("ambient/alarms/warningbell1.wav")
			end
		end
        if time == 300 then
			if aABASDBASDBABDSBaa == true then
                AM = 3
				aABASDBASDBABDSBaa = false
                timer.Simple(10,function() aABASDBASDBABDSBaa = true end )
				surface.PlaySound("ambient/alarms/warningbell1.wav")
			end
		end
        if time == 200 then
			if aABASDBASDBABDSBaa == true then
                AM = 4
				aABASDBASDBABDSBaa = false
                timer.Simple(10,function() aABASDBASDBABDSBaa = true end )
				surface.PlaySound("ambient/alarms/warningbell1.wav")
			end
		end
        if time == 100 then
			if aABASDBASDBABDSBaa == true then
                AM = 5
				aABASDBASDBABDSBaa = false
                timer.Simple(10,function() aABASDBASDBABDSBaa = true end )
				surface.PlaySound("ambient/alarms/warningbell1.wav")
			end
		end
    elseif time <= 1 then
        if aABASDBASDBABDSBaa == true then
            AM = 6
            aABASDBASDBABDSBaa = false
            timer.Simple(10,function() aABASDBASDBABDSBaa = true AM = 12 end )
            surface.PlaySound("ambient/alarms/warningbell1.wav")
             timer.Simple(2,function() surface.PlaySound("ambient/alarms/warningbell1.wav") end )
             timer.Simple(4,function() surface.PlaySound("ambient/alarms/warningbell1.wav") end )
             timer.Simple(6,function() surface.PlaySound("ambient/alarms/warningbell1.wav") end )
        end
	end
	green.a = white2.a


end

function zombieinfection.PlayerClientSpawn()
	if LocalPlayer():Team() ~= 3 then return end

	showRoundInfo = CurTime() + 5
end