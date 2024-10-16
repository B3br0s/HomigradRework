if CLIENT then
local cvar = CreateClientConVar("hg_organisminfodev","0",true,false,"Dev",0,1)
local white = Color(255,255,255)
local function drawStates(ply,x,y,align)
	if cvar:GetBool() then
	draw.SimpleText("health: " .. ply:Health(),"ChatFont",x,y,white,align)
	draw.SimpleText("pain: " .. ply:GetNWFloat("pain",0),"ChatFont",x,y + 25 * 1,white,align)
	draw.SimpleText("painlosing: " .. ply:GetNWFloat("painlosing",0),"ChatFont",x,y + 25 * 2,white,align)
	draw.SimpleText("adrenaline: " .. ply:GetNWFloat("adrenaline",0),"ChatFont",x,y + 25 * 3,white,align)
	draw.SimpleText("stamina: " .. ply:GetNWFloat("stamina",0),"ChatFont",x,y + 25 * 4,white,align)
	draw.SimpleText("bleed: " .. ply:GetNWFloat("Bloodlosing",0),"ChatFont",x,y + 25 * 5,white,align)
	draw.SimpleText("blood: " .. ply:GetNWFloat("blood",0),"ChatFont",x,y + 25 * 6,white,align)
	draw.SimpleText("pulse: " .. 1 / ply:GetNWFloat("pulse",0),"ChatFont",x,y + 25 * 7,white,align)
	draw.SimpleText("otrub: " .. tostring(ply:GetNWBool("Otrub",false)),"ChatFont",x,y + 25 * 8,white,align)
	draw.SimpleText("hungry: " .. tostring(ply:GetNWFloat("hungry",0)),"ChatFont",x,y + 25 * 9,white,align)
	draw.SimpleText("o2: " .. tostring(ply:GetNWFloat("o2",0)),"ChatFont",x,y + 25 * 10,white,align)
	draw.SimpleText("brain: " .. tostring(ply:GetNWFloat("brain",0)),"ChatFont",x,y + 25 * 11,white,align)
	draw.SimpleText("poison: " .. tostring(ply:GetNWFloat("poison",0)),"ChatFont",x,y + 25 * 12,white,align)
	draw.SimpleText("metabolizm: " .. tostring(ply:GetNWFloat("metabolizm",0)),"ChatFont",x,y + 25 * 13,white,align)
	draw.SimpleText("speed: " .. tostring(ply:GetNWFloat("speeed",0)),"ChatFont",x,y + 25 * 14,white,align)
	draw.SimpleText("paralizovan: " .. tostring(ply:GetNWBool("paraliz",false)),"ChatFont",x,y + 25 * 15,white,align)
	draw.SimpleText("inviter: " .. tostring(ply:GetNWEntity("InviterToTeam")),"ChatFont",x,y + 25 * 16,white,align)
	draw.SimpleText("inteam: " .. tostring(ply:GetNWBool("InTeam",false)),"ChatFont",x,y + 25 * 17,white,align)
	draw.SimpleText("nextthink: " .. tostring(ply:GetNWFloat("NextThinkGay",false)),"ChatFont",x,y + 25 * 18,white,align)
	draw.SimpleText("suffocating: " .. tostring(ply:GetNWBool("Suffocating",false)),"ChatFont",x,y + 25 * 19,white,align)
	draw.SimpleText("pose: " .. tostring(ply:GetNWFloat("PosaVistrela",false)),"ChatFont",x,y + 25 * 20,white,align)
	draw.SimpleText("statusfake: " .. tostring(ply:GetNWFloat("Status",false)),"ChatFont",x,y + 25 * 21,white,align)
	draw.SimpleText("canspawn: " .. tostring(ply:GetNWBool("CanSpawn",false)),"ChatFont",x,y + 25 * 22,white,align)
	end
end

hook.Add("HUDPaint","DevCheck",function()
	local ply = LocalPlayer()

	if not ply:IsSuperAdmin() then return end

	drawStates(ply,45,45)

	local ply = ply:GetEyeTrace().Entity
	if not IsValid(ply) then return end

	ply = RagdollOwner(ply) or ply 
	if not ply:IsPlayer() then return end

	drawStates(ply,ScrW() - 45,45,TEXT_ALIGN_RIGHT)
end)
end