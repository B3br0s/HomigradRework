local graddown = Material( "vgui/gradient-u" )
local gradup = Material( "vgui/gradient-d" )
local gradright = Material( "vgui/gradient-l" )
local gradleft = Material( "vgui/gradient-r" )
local agony_mat = Material( "effects/shaders/zb_grain" )
local pain_mat = Material( "effects/shaders/zb_vignette" )
local pain_mat2 = Material( "effects/shaders/zb_grainwhite" )
local math_Clamp = math.Clamp
local k = 0
local k4 = 0
local agony = 0
local pulseStart = 0
gradshit = gradshit or nil

local shake = 0
local dark = 0

hook.Add("Think","DumalkaOstalnix",function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetNWBool("suiciding") != nil then
            ply.suiciding = ply:GetNWBool("suiciding")
        end
    end
end)

hook.Add("PainShit","LOBOTOMY_AHAHAHAHAHAH",function(mul,isotrub,w,h)  
    mul = mul
    local tab_otrub = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1 - (isotrub and 1 or mul / 1.5),
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
    }
    DrawColorModify(tab_otrub)
	render.UpdateScreenEffectTexture()
    pain_mat:SetFloat("$c0_y", mul)
	pain_mat:SetFloat("$c0_z", mul)
	pain_mat:SetFloat("$c1_x", mul)
	pain_mat:SetFloat("$c1_y", mul)
	pain_mat:SetFloat("$c2_x", CurTime() + 10000)
    pain_mat2:SetFloat("$c0_y", 0.5)
	pain_mat2:SetFloat("$c0_z", 0.1)
	pain_mat2:SetFloat("$c1_x", math.Clamp(mul, 0, 4))
	pain_mat2:SetFloat("$c1_y", mul * 15)
	pain_mat2:SetFloat("$c2_x", CurTime() + 10000)
    render.SetMaterial(pain_mat)
    render.DrawScreenQuad()

    render.SetMaterial(pain_mat2)
    render.DrawScreenQuad()
end)

hook.Add("Lobotomy","LOBOTOMY_AHAHAHAHAHAH",function(mul,isotrub,w,h)  
    mul = mul
	render.UpdateScreenEffectTexture()
    agony_mat:SetFloat("$c0_y", 1 - mul)
	agony_mat:SetFloat("$c0_z", 0.2)
	agony_mat:SetFloat("$c1_x", math.Clamp(mul, 0, 4))
	agony_mat:SetFloat("$c1_y", 1)
	agony_mat:SetFloat("$c2_x", CurTime() + 10000)
    render.SetMaterial(agony_mat)
    render.DrawScreenQuad()
end)

hook.Add("RenderScreenspaceEffects","Homigrad_Pain_HUD",function()
    local ply = LocalPlayer()
    if !IsValid(gradshit) then
        gradshit = vgui.Create("DImage")
        gradshit:Center()
        gradshit:SetImage('gui/center_gradient')
        gradshit:SetImageColor(Color(0,0,0,0))
    end
    if ROUND_NAME == "dr" then
        return
    end
    --RunConsoleCommand("slot5")
    if not ply:Alive() then k = 0 ply:SetDSP(0) gradshit:SetImageColor(Color(0,0,0,0)) return end
    
    local painlosing = ply:GetNWFloat("painlosing")
    local pain = ply:GetNWFloat("pain")
    local stam = ply:GetNWFloat("stamina")
    local critical = ply:GetNWBool("crit",false)
    local incapacitated = ply:GetNWBool("incap",false)

    /*if painlosing > 0 then
        DrawMotionBlur(0.9,painlosing / 3,0.016)
    end*/

    local active = ply:GetNWBool("otrub")

    cam.Start2D()

    render.ClearStencil()

    local w,h = ScrW(),ScrH()
    k = Lerp(0.02,k,math_Clamp(ply:GetNWFloat("pain")  / 50,0,15))
    agony = Lerp(0.02,agony,1 - stam/30)

    hook.Run("Lobotomy",math_Clamp(agony*2,0,100),active,w,h)

    hook.Run("PainShit",k,active,w,h)

    if ply.PlayerClassName == "combine" then cam.End2D() return end

    /*if stam < 30 then
        surface.SetDrawColor(100,0,0,100)

        surface.SetMaterial(graddown)
        surface.DrawTexturedRect(0,0,w,h * agony)

        surface.SetMaterial(gradup)
        surface.DrawTexturedRect(0,h - h * agony,w,h * agony + 1)

        surface.SetMaterial(gradright)
        surface.DrawTexturedRect(0,0,w * agony,h)

        surface.SetMaterial(gradleft)
        surface.DrawTexturedRect(w - w * agony,0,w * agony + 1,h)
    end*/

    if active then
        ply:SetDSP(16)

        //draw.RoundedBox(0,0,0,w,h,Color(0,0,0))

        dark = LerpFT(0.025,dark,1)

        shake = LerpFT(0.1,shake,0)

        local pulse = ply:GetNWFloat("pulse")

        surface.SetFont("HS.45")
        local shit_size = surface.GetTextSize(hg.GetPhrase("uncon"))
        //local size = shit_size

        if IsValid(gradshit) then
            gradshit:SetImageColor(Color(255,0,0,15 * dark))
            gradshit:SetWide(shit_size * 1.3 * dark)
            gradshit:SetHeight(50)
            gradshit:Center()
        end

        draw.SimpleText(hg.GetPhrase("uncon"),"HS.45",ScrW()/2 + (math.random(-5,5) * shake),ScrH()/2 + (math.random(-5,5) * shake),Color(161,0,0,255 * dark),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        if pulse != 0 and pulseStart + pulse * 60 < RealTime() then
            pulseStart = RealTime()

            dark = 0

            shake = 66

            surface.PlaySound("snd_jack_hmcd_heartpound.wav")
        end
    else
        surface.SetMaterial(graddown)
    surface.SetDrawColor(0,0,0,255)
    surface.DrawTexturedRect(0,0,w,h * k)

    surface.SetMaterial(gradup)
    surface.SetDrawColor(0, 0, 0, 255 )
    surface.DrawTexturedRect(0,h - h * k,w,h * k + 1)

    surface.SetMaterial(gradright)
    surface.SetDrawColor(0,0,0,255)
    surface.DrawTexturedRect(0,0,w * k,h)

    surface.SetMaterial(gradleft)
    surface.SetDrawColor(0,0,0,255)
    surface.DrawTexturedRect(w - w * k,0,w * k + 1,h)

        if IsValid(gradshit) then
            gradshit:SetImageColor(Color(0,0,0,0))
        end
        dark = 0
        shake = 0
        ply:SetDSP(0)
        pulseStart = 0
    end

    cam.End2D()
end)

hook.Add("InitPostEntity","idk",function()
    if !IsValid(gradshit) then
        gradshit = vgui.Create("DImage")
        gradshit:Center()
        gradshit:SetImage('gui/center_gradient')
        gradshit:SetImageColor(Color(0,0,0,0))
    end
end)