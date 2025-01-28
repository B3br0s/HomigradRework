-- "addons\\homigrad\\lua\\homigrad\\liquid_drum\\particles\\cl_gasoline.lua"

gasparticles = gasparticles or {}
gasparticles_hook = gasparticles_hook or {}
local gasparticles_hook = gasparticles_hook
local mats = {}
for i = 1, 3 do
	mats[i] = Material("homigrad/decals/blood" .. i)
end

local mats_huy = {}
for i = 1, 3 do
	mats_huy[i] = Material("homigrad/decals/bld" .. i + 3)
end

local tr = {
	filter = function(ent) return not ent:IsPlayer() and not ent:IsRagdoll() and not IsValid(ent:GetPhysicsObject()) end
}
local mat = Material("effects/blooddrop")
local vecDown = Vector(0, 0, -40)
local vecZero = Vector(0, 0, 0)
local LerpVector = LerpVector
local math_random = math.random
local table_remove = table.remove
local util_Decal = util.Decal
local util_TraceLine = util.TraceLine
local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local col = Color( 131, 70, 21, 250)
gasparticles_hook[1] = function(anim_pos)
	for i = 1, #gasparticles do
		local part = gasparticles[i]
		local pos = LerpVector(anim_pos, part[2], part[1])
		render_SetMaterial(mat)
		--render_DrawSprite(pos, part[5], part[6])
		render.DrawBeam(pos - (part[2] - part[1]) * 2,pos + (part[2] - part[1]) * 2, 10, 0, 1, col)
	end
end

local paint = Color(255, 255, 255, 255)
local function decalGas(pos, normal, hitTexture)
	paint.r = 14
	paint.g = 6
	paint.b = 3
	paint.a = math.random(250, 250)
	local w = math.Rand(1, 1.5) / math.random(8, 16)
	local h = w
	util.Decal("BeerSplash", pos + normal, pos - normal)
	if hitTexture == "**displacement**" then
		--util.DecalEx(mats_huy[math.random(#mats_huy)], game.GetWorld(), pos + normal, -normal * 20, paint, w * 16, h * 16)
	else
		--util.DecalEx(mats[math.random(#mats)], game.GetWorld(), pos + normal, -normal * 20, paint, w, h)
	end
end

gasparticles_hook[2] = function(mul)
	for i = 1, #gasparticles do
		local part = gasparticles[i]
		if not part then break end
		local pos = part[1]
		local posSet = part[2]
		tr.start = posSet
		tr.endpos = tr.start + part[3] * mul
		tr.filter = part[7]
		result = util_TraceLine(tr)
		local hitPos = result.HitPos
		if result.Hit then
			table_remove(gasparticles, i)
			local dir = result.HitNormal
			decalGas(result.HitPos, dir, result.HitTexture, part[7])
			sound.Play("homigrad/blooddrip" .. math_random(1, 4) .. ".wav", hitPos, math.random(10, 60), math.random(80, 120))
			continue
		else
			pos:Set(posSet)
			posSet:Set(hitPos)
		end

		part[3] = LerpVector(0.25 * mul, part[3], vecZero)
		part[3]:Add(vecDown)
	end
end