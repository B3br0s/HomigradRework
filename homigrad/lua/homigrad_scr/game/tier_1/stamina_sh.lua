if not engine.ActiveGamemode() == "hgrework" then return end
local value,gg

if CLIENT then
	value = 1

	net.Receive("info_staminamul",function()
		value = net.ReadFloat()
	end)
end

local jmod
if CLIENT then
	hook.Add("Move","homigrad",function(ply,mv)
		gg(ply,mv,value)
	end)
else
	hook.Add("Move","homigrad",function(ply,mv)
		gg(ply,mv,(ply.staminamul or 1))
	end)
end


gg = function(ply,mv,value)
	value = mv:GetMaxSpeed() * value


	if roundActiveName == "deathrun" or roundActiveName == "nextbots" or roundActiveName == "eft" then
	else
		if ply.isDOZER == true then return end
		ply:SetRunSpeed(Lerp((ply:IsSprinting() and mv:GetForwardSpeed() > 1) and 0.05 or 1,ply:GetRunSpeed(),(ply:IsSprinting()) and 350 or ply:GetWalkSpeed()) + 3.5)
	end

	mv:SetMaxSpeed(value)
	mv:SetMaxClientSpeed(value)


	if ply.IsProne and ply:IsProne() then return end

	local value = ply.EZarmor
	value = value and ply.EZarmor.speedfrac

	if value and value ~= 1 then
		value = mv:GetMaxSpeed() * math.max(value,0.75)
		mv:SetMaxSpeed(value)
		mv:SetMaxClientSpeed(value)
	end
end

hook.Remove("Move","JMOD_ARMOR_MOVE")