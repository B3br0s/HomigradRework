AddCSLuaFile()

DeriveGamemode("sandbox")

GM.Name 		= "Homigrad Rework"
GM.Author 		= "3 dauna"
GM.Email 		= ""
GM.Website 		= ""

hg = hg or {}

hg.IncludeDir("hgrework/gamemode/game")
hg.IncludeDir("homigrad")

include("loader.lua")
AddCSLuaFile("loader.lua")

function ReadPoint(point)
	if TypeID(point) == TYPE_VECTOR then
		return {point,Angle(0,0,0)}
	elseif type(point) == "table" then
		if type(point[2]) == "number" then
			point[3] = point[2]
			point[2] = Angle(0,0,0)
		end

		return point
	end
end