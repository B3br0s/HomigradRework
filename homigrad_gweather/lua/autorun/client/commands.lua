AddCSLuaFile()

surface.CreateFont( "gWeatherFont", {
	font = "HudHintTextLarge",
	extended = false,
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


concommand.Add("gw_lookforward", function(ply, cmd, args)

	local tr = util.TraceLine( { start = ply:EyePos(), endpos = ply:EyePos() + ply:EyeAngles():Forward() * 1000^2, filter = ply } )

	print(tr.HitPos,tr.HitSky)
end)

concommand.Add("gw_skytest", function(ply, cmd, args)
	local sky = ents.FindByClass("env_skypaint")[1]
	if sky then 
		local tbl = {
			TopColor=sky:GetTopColor(),
			BottomColor=sky:GetBottomColor(),
			SunNormal=sky:GetSunNormal(),
			SunSize=sky:GetSunSize(),
			SunColor=sky:GetSunColor(),
			DuskColor=sky:GetDuskColor(),
			FadeBias=sky:GetFadeBias(),
			HDRScale=sky:GetHDRScale(),
			DuskScale=sky:GetDuskScale(),
			DuskIntensity=sky:GetDuskIntensity(),
			DrawStars=sky:GetDrawStars(),
			StarScale=sky:GetStarLayers(),
			StarFade=sky:GetStarFade(),
			StarSpeed=sky:GetStarSpeed(),
			StarTexture=sky:GetStarTexture(),
		}
	PrintTable(tbl)
	end

end)
