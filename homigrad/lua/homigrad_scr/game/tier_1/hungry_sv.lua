if not engine.ActiveGamemode() == "homigrad" then return end
local math_Clamp = math.Clamp

local furrypedik = {
}

local veipbasic = {
	"STEAM_1:1:461500228",
	"STEAM_0:1:526713154",
	"STEAM_1:1:129496181"
}

local medved = {
	"STEAM_1:1:768063411"
}



hook.Add("Player Think","homigrad-hungry",function(ply,time)
	if not ply:Alive() or ply:HasGodMode() then return end

	if (ply.hungryNext or time) > time then return end
	ply.hungryNext = time + 1

	ply.hungryregen = math_Clamp((ply.hungryregen or 0) - 0.03,-0.01,50)
	ply.hungry = math_Clamp((ply.hungry or 0) + ply.hungryregen,0,100)
	if table.HasValue( furrypedik, ply:Nick() ) then
		--print("huy")
		uwo(ply)
		timer.Simple(1,function()
			ply:SetModel(table.Random(FurryModels))
		end)
	end

	if ply.hungry < 5 then
		ply:SetHealth(ply:Health() - 1)
		if ply:Health() <= 0 then
			ply.KillReason = "hungry"
			ply:Kill()
			return
		end
	end

	if ply.hungry < 80 then
		if ply.hungry < 40 and ply.hungryMessage ~= 1 then
			ply.hungryMessage = 1

			ply:ChatPrint("Ты голоден")
		end

		if ply.hungry > 40 and ply.hungry < 65 and ply.hungryMessage ~= 2 then
			ply.hungryMessage = 2

			ply:ChatPrint("Ты проголодался")
		end
	end

--	ply:SetHealth(not ply.heartstop and (math.min(ply:Health() + math.max(math.ceil(ply.hungryregen),1),150)) or ply:Health())
end)

local sounds = {
	"wowozela/samples/meow.wav",
	"wowozela/samples/woof.wav",
	"bullshitfuck/cute-uwu.mp3",
	"bullshitfuck/owo_oj0bqgj.mp3",
	"bullshitfuck/uwudaddy.mp3"
}

local function uwo(ply)
	furry = ply
	furry:EmitSound( table.Random(sounds), 75, 100, 5, CHAN_WEAPON )
	timer.Create("furry"..furry:EntIndex(),math.random(2,15),1,function()
		if furrypedik[furry:SteamID()] and furry:Alive() then
			uwo(furry)
		else
			timer.Destroy("furry"..furry:EntIndex())
		end
	end)
end

local FurryModels = {
	"models/player/furry/wolfy.mdl"
}

hook.Add("PlayerSpawn","homigrad-hungry",function(ply)
	if PLYSPAWN_OVERRIDE then return end
	ply.hungry = 89
	ply.hungryregen = 0
	ply.hungryNext = 0
	ply.hungryMessage = nil
	local steamID = ply:SteamID()

	if table.HasValue(furrypedik, steamID) then
        --print("huy")
		uwo(ply)
		timer.Simple(0.1,function()
			ply:SetModel(table.Random(FurryModels))
		end)
    end
	if table.HasValue(medved, steamID) then
		timer.Simple(0.1,function()
			ply:SetModel("models/player/open season/boog.mdl")
		end)
    end
	if table.HasValue(veipbasic, steamID) then
		if ply:Alive() then
			ply:Give("weapon_vape")
		end
    end
end)

concommand.Add("hg_hungryinfo",function(ply)
	if not ply:IsAdmin() then return end

	ply:ChatPrint("hungry: " .. ply.hungry)
	ply:ChatPrint("hungryregen: " .. ply.hungryregen)
end)