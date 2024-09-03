zombieinfection.GetTeamName = tdm.GetTeamName

local colorSpec = ScoreboardSpec
function zombieinfection.Scoreboard_Status(ply)
	local lply = LocalPlayer()
	if not lply:Alive() or lply:Team() == 1002 then return true end

	return "Неизвестно",colorSpec
end

local aABASDBASDBABDSB = true
local aABASDBASDBABDSBa = true

local green = Color(0,125,0)
local white = Color(255,255,255)

    local flashBrightness = 5
    local flashDuration = 10  -- Flash duration in seconds
    local flashStartTime = 0
    local isFlashing = false

    -- Function to trigger the screen flash
function FlashScreen()
        flashStartTime = CurTime()  -- Set the start time of the flash
        flashBrightness = 1.0       -- Set initial brightness level for flash
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
				aABASDBASDBABDSB = false
				surface.PlaySound("infectionround/infectionroundstart.wav")
				timer.Simple(10,function() aABASDBASDBABDSB = true end )
				timer.Simple(14.5,function() FlashScreen() end )
			end
		end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.1,0.1)

		lply:SetNWBool("INFECTED",false)
        return
    end
	if time > 0 then
		draw.SimpleText("До рассвета : ","HomigradFont",ScrW() / 2 - 200,ScrH()-25,white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText(acurcetime,"HomigradFont",ScrW() / 2 + 200,ScrH()-25,white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	end
	green.a = white2.a


end

function zombieinfection.PlayerClientSpawn()
	if LocalPlayer():Team() ~= 3 then return end

	showRoundInfo = CurTime() + 18
end