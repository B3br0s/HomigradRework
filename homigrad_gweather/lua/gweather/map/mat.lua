if CLIENT then 

gWeather.Terrain={}

local maptex = {}
local matstofind={"grass","dirt","gravel","cliff"} -- sand
for _, mat in ipairs( game.GetWorld():GetBrushSurfaces() ) do
	if (mat:IsWater() or mat:IsSky() or mat:IsNoDraw()) then continue end
	
	local name=mat:GetMaterial():GetName()
	maptex[name] = true
end

local oldtex={}
local oldcol={}
function gWeather.Terrain.SetBaseTexture(m,m2)
	if GetConVar("gw_matchange"):GetInt()==0 then return end
	local getmat=Material(m)
	local newmat=getmat:GetTexture("$basetexture")
	local newmat2=newmat 

	if m2 then
		local getmat2=Material(m2)
		if getmat2 and (not (getmat2:GetTexture("$basetexture"):IsError() or getmat2:GetTexture("$basetexture"):IsErrorTexture())) then 
			newmat2=getmat2:GetTexture("$basetexture")
		end
	end
	
	if (not newmat) or (not newmat2) then return end

	for name in pairs( maptex ) do
        local mat = Material(name)
		if mat:IsError() then continue end
		for _,f in ipairs(matstofind) do
		
			if mat:GetTexture("$basetexture") then
				if string.find(mat:GetTexture("$basetexture"):GetName(),f) then
					oldtex[mat]= oldtex[mat] or {mat:GetTexture("$basetexture"):GetName(),mat:GetTexture("$basetexture2"):GetName(),mat:GetFloat("$detailblendfactor")}
					mat:SetTexture( "$basetexture", newmat )
					if mat:GetTexture("$detail") then mat:SetFloat("$detailblendfactor",0) end
				end
			end
			
			if mat:GetTexture("$basetexture2") then
				if string.find(mat:GetTexture("$basetexture2"):GetName(),f) then	
					oldtex[mat]= oldtex[mat] or {mat:GetTexture("$basetexture"):GetName(),mat:GetTexture("$basetexture2"):GetName(),mat:GetFloat("$detailblendfactor")}
					mat:SetTexture( "$basetexture2", newmat2 )
					if mat:GetTexture("$detail") then mat:SetFloat("$detailblendfactor",0) end
				end
			end
			
		end	
	end
	
end

function gWeather.Terrain.SetColor(c)
	if GetConVar("gw_matchange"):GetInt()==0 then return end
	
	for name in pairs( maptex ) do
        local mat = Material(name)
		if mat:IsError() then continue end
		for _,f in ipairs(matstofind) do
		
			if ((mat:GetTexture("$basetexture") and string.find(mat:GetTexture("$basetexture"):GetName(),f)) or (mat:GetTexture("$basetexture2") and string.find(mat:GetTexture("$basetexture2"):GetName(),f))) or oldtex[mat]!=nil then
				oldcol[mat]= oldcol[mat] or mat:GetVector("$color")
				mat:SetVector( "$color", c )
			end
			
		end	
	end
	
end


function gWeather.Terrain.ReloadAllOldTextures()
	for mat,btx in pairs(oldtex) do	
		if btx[1] then mat:SetTexture( "$basetexture", btx[1] ) end
		if btx[2] then mat:SetTexture( "$basetexture2", btx[2] ) end
		if btx[3] then mat:SetFloat( "$detailblendfactor", btx[3] ) end
	end
	for mat,col in pairs(oldcol) do	
		if col then mat:SetVector( "$color", col ) end
	end
end

hook.Add("ShutDown", "gWeather.Terrain.TextureRestore.ShutDown", gWeather.Terrain.ReloadAllOldTextures) -- don't mess with this
hook.Add("OnCleanup", "gWeather.Terrain.TextureRestore.OnCleanup", gWeather.Terrain.ReloadAllOldTextures) -- or this 

end