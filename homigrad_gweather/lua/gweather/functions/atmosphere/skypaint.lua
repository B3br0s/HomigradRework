gWeather.Sky=nil

function gWeather:GetSky()
	return gWeather.Sky
end

function gWeather:GetSkyParameters(ent)
if !IsValid(ent) then return end

local sun = ents.FindByClass( "env_sun" )[1]

	local tbl = {
		TopColor=ent:GetTopColor(),
		BottomColor=ent:GetBottomColor(),
		SunNormal=sun and sun:GetInternalVariable("sun_dir") or ent:GetSunNormal(),
		SunSize=sun and sun:GetInternalVariable("size") or ent:GetSunSize(),
		SunColor=ent:GetSunColor(),
		DuskColor=ent:GetDuskColor(),
		FadeBias=ent:GetFadeBias(),
		HDRScale=ent:GetHDRScale(),
		DuskScale=ent:GetDuskScale(),
		DuskIntensity=ent:GetDuskIntensity(),
		DrawStars=ent:GetDrawStars(),
		StarScale=ent:GetStarLayers(),
		StarFade=ent:GetStarFade(),
		StarSpeed=ent:GetStarSpeed(),
		StarTexture=ent:GetStarTexture(),
	}

	return tbl
end

local IsFlashing = false
function gWeather:SkyFlash(t)
	if CLIENT and GetConVar("gw_lightning_flash"):GetInt()<=0 then return end
	if IsFlashing==true then return end
	
	local self = gWeather:GetSky()
	if !IsValid(self) then return false end
	IsFlashing = true
	
	local sky = gWeatherDefaultSky or gWeather:GetSkyParameters(self)

	local newsky = Vector(1,1,1)
	local scale=25
	if !t then t=8 end
		
	for i=0,scale do
		
		local lerpscale= -( ( (i-(scale/2))^2 ) * ( 1 / (0.25*(scale^2)) ) ) + 1
		timer.Simple( (i/scale)/t,function()
			if !IsValid(self) then IsFlashing = false return false end

			self:SetTopColor( LerpVector(lerpscale,sky.TopColor,newsky ) )
			self:SetBottomColor( LerpVector(lerpscale,sky.BottomColor,newsky ) )
			
			if i==scale then IsFlashing = false end
			
		end)
	end
		
	return true
end

if CLIENT then return end

local gWeatherSkyName
local gWeatherDefaultSky, gWeatherDefaultSky_old

hook.Add( "InitPostEntity", "gWeather.GetSkyInfo", function()
	gWeatherSkyName=GetConVar("sv_skyname"):GetString()
end)

function gWeather:CreateSky()
	if gWeather.Sky!=nil then return false end

	local sky=ents.FindByClass("edit_sky")[#ents.FindByClass("edit_sky") or 1] or ents.FindByClass("env_skypaint")[1]
	gWeatherDefaultSky = gWeather:GetSkyParameters(sky)
	gWeatherDefaultSky_old = gWeatherDefaultSky

	local ent = ents.Create("gw_skypaint")
	ent:Spawn()	

	return true
end

function gWeather:RemoveSky()
	if (#ents.FindByClass("gw_skypaint")==0) then return false end

	if gWeatherDefaultSky_old then
		gWeather:SetNewSkyParameters(gWeatherDefaultSky_old)
	end

	for i=1,#ents.FindByClass("gw_skypaint") do
		if IsValid(ents.FindByClass("gw_skypaint")[i]) then ents.FindByClass("gw_skypaint")[i]:Remove() end
	end

	if (GetConVar("sv_skyname"):GetString()=="painted" and gWeatherSkyName!="painted") then
		RunConsoleCommand( "sv_skyname", gWeatherSkyName)		
	end
	
	return true
end

function gWeather:SetNewSkyParameters(tbl)
	local self = gWeather.Sky
	if !IsValid(self) then return false end
	local sky = gWeatherDefaultSky or gWeather:GetSkyParameters(self)

	self:SetTopColor(tbl.TopColor or sky.TopColor)
	self:SetBottomColor(tbl.BottomColor or sky.BottomColor )
	self:SetSunNormal(tbl.SunNormal or sky.SunNormal )
	self:SetSunSize(tbl.SunSize or sky.SunSize )
	self:SetSunColor(tbl.SunColor or sky.SunColor )
	self:SetDuskColor(tbl.DuskColor or sky.DuskColor )
	self:SetFadeBias(tbl.FadeBias or sky.FadeBias )
	self:SetHDRScale(tbl.HDRScale or sky.HDRScale )
	self:SetDuskScale(tbl.DuskScale or sky.DuskScale )
	self:SetDuskIntensity(tbl.DuskIntensity or sky.DuskIntensity )
	self:SetDrawStars(tbl.DrawStars or false )
	self:SetStarScale(tbl.StarScale or sky.StarScale )
	self:SetStarFade(tbl.StarFade or sky.StarFade )
	self:SetStarSpeed(tbl.StarSpeed or sky.StarSpeed  )
	self:SetStarTexture(tbl.StarTexture or sky.StarTexture )

	gWeatherDefaultSky=gWeather:GetSkyParameters(self)

	return true
end

function gWeather:SetLerpSkyParameters(tbl,t)
	local self = gWeather.Sky
	if !IsValid(self) then return false end
	local sky = gWeatherDefaultSky or gWeather:GetSkyParameters(self)

	local scale=100
	if !t then t=1 end
	
	for i=1,scale do
		local lerpscale=i*(1/scale)
		timer.Simple( (i/scale)/t,function()
			if !IsValid(self) then return false end

			self:SetTopColor( LerpVector(lerpscale,sky.TopColor,tbl.TopColor or sky.TopColor ) )
			self:SetBottomColor( LerpVector(lerpscale,sky.BottomColor,tbl.BottomColor or sky.BottomColor ) )
			self:SetSunNormal( LerpVector(lerpscale,sky.SunNormal,tbl.SunNormal or sky.SunNormal ) )
			self:SetSunSize( Lerp(lerpscale,sky.SunSize,tbl.SunSize or sky.SunSize ) )
			self:SetSunColor( LerpVector(lerpscale,sky.SunColor,tbl.SunColor or sky.SunColor ) )
			self:SetDuskColor( LerpVector(lerpscale,sky.DuskColor,tbl.DuskColor or sky.DuskColor ) )
			self:SetFadeBias( Lerp(lerpscale,sky.FadeBias,tbl.FadeBias or sky.FadeBias ) )
			self:SetHDRScale( Lerp(lerpscale,sky.HDRScale,tbl.HDRScale or sky.HDRScale ) )
			self:SetDuskScale( Lerp(lerpscale,sky.DuskScale,tbl.DuskScale or sky.DuskScale ) )
			self:SetDuskIntensity( Lerp(lerpscale,sky.DuskIntensity,tbl.DuskIntensity or sky.DuskIntensity  ) )
			self:SetDrawStars( tbl.DrawStars or false )
			self:SetStarScale( tbl.StarScale or sky.StarScale  ) -- this looks like shit lerped
			self:SetStarFade(  Lerp(lerpscale,sky.StarFade, tbl.StarFade or sky.StarFade ) )
			self:SetStarSpeed(  tbl.StarSpeed or sky.StarSpeed   ) -- this too
			self:SetStarTexture( tbl.StarTexture or sky.StarTexture )
			
			if i==scale then 
				gWeatherDefaultSky=gWeather:GetSkyParameters(self) 
			end
			
		end)
	end
	
	return true
end


function gWeather:SetSkyParameters(tbl,t)
	if gWeatherDefaultSky!=nil then
		gWeather:SetLerpSkyParameters(tbl,t)
	else
		gWeather:SetNewSkyParameters(tbl)
	end
end