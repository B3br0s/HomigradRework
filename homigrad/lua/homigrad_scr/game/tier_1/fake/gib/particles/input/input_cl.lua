if engine.ActiveGamemode() == "homigrad" then
local mats = {}
for i = 1,8 do mats[i] = Material("decals/blood" .. i) end
local countmats = #mats

local random = math.random
local Rand = math.Rand

local bloodparticels1 = bloodparticels1
local bloodparticels2 = bloodparticels2

local vecZero = Vector(0,0,0)

local function addBloodPart(pos,vel,mat,w,h)
	pos = pos + vecZero
	vel = vel + vecZero 
	local pos2 = Vector()
	pos2:Set(pos)
	
	bloodparticels1[#bloodparticels1 + 1] = {pos,pos2,vel,mat,w,h}
end

local function addBloodPartCrazy(pos,vel,mat,w,h)
	pos = pos + vecZero
	vel = vel * 5 + vecZero 
	local pos2 = Vector()
	pos2:Set(pos)
	
	bloodparticels1[#bloodparticels1 + 1] = {pos,pos2,vel,mat,w,h}
end

net.Receive("blood particle",function()
	addBloodPart(net.ReadVector(),net.ReadVector(),mats[random(1,#mats)],random(4,5),random(4,5))
end)

local Rand = math.Rand

net.Receive("blood particle more",function()
	local pos,vel = net.ReadVector(),net.ReadVector()

	for i = 1,random(2,15) do
		addBloodPart(pos,vel + Vector(Rand(-15,15),Rand(-15,15)),mats[random(1,#mats)],random(10,15),random(10,15))
	end
end)

local function addBloodPart2(pos,vel,mat,w,h,time)
	pos = pos + vecZero
	vel = vel + vecZero
	local pos2 = Vector()
	pos2:Set(pos)
	
	bloodparticels2[#bloodparticels2 + 1] = {pos,pos2,vel * 15,mat,w,h,CurTime() + time,time}
end


local function explode(pos)
	local xx,yy = 40,90
	local w,h = 360 / xx,360 / yy

	for x = 1,xx do
		for y = 1,yy do
			local dir = Vector(math.random(-1,1),math.random(-1,1),-500)
			dir:Rotate(Angle(h * y * Rand(0.9,1.1),w * x * Rand(0.9,1.1),0))
			dir[3] = dir[3] + Rand(-0.5,2.5)
			dir:Mul(math.random(0,150))

			addBloodPartCrazy(pos,dir,mats[random(1,#mats)],random(1,20),random(10,20))
		end
	end
end

net.Receive("blood particle explode",function()
	explode(net.ReadVector())
end)

local vecR = Vector(10,10,2)

net.Receive("blood particle headshoot",function()
	local pos,vel = net.ReadVector(),net.ReadVector()
	local dir = Vector()
	dir:Set(vel)
	dir:Normalize()
	dir:Mul(2)

	local l1,l2 = pos - dir / 2,pos + dir / 2

	local r = random(20,25)

	addBloodPart(pos,dir,mats[random(1,#mats)],r,r)
end)

concommand.Add("testpart",function()
    local pos = Vector(1200.543579,699.216309,300.834564)
	local vel = Vector(1024,0,0)
	local dir = Vector()
	dir:Set(vel)
	dir:Normalize()
	dir:Mul(25)

	local l1,l2 = pos - dir / 2,pos + dir / 2

	local r = random(10,15)

	for i = 1,r do
		local vel = Vector(vel[1],vel[2],vel[3])
		vel:Rotate(Angle(Rand(-15,15) * Rand(0.9,1.1),Rand(-15,15) * Rand(0.9,1.1)))

		addBloodPart(Lerp(i / r * Rand(0.9,1.1),l1,l2),vel,mats[random(1,#mats)],random(10,15),random(10,15))
	end

	for i = 1,8 do
		addBloodPart2(pos + VectorRand(-vecR,vecR),VectorRand(-vecR,vecR),mats[random(1,#mats)],random(30,45),random(30,45),Rand(1,2))
	end
end)

concommand.Add("freecamera",function(ply)
	if not ply:IsAdmin() then return end

	freecameraPos = ply:EyePos()
	freecameraAng = ply:EyeAngles()

	freecamera = not freecamera
end)

hook.Add("Move","FreeCamera",function(mv)
	if not freecamera then return end

end)

local view = {}

hook.Add("PreCalcView","!",function(ply,pos,ang)
	if not freecamera then return end

	view.origin = freecameraPos
	view.angles = freecameraAng
	view.fov = CameraLerpFOV
	view.drawviewer = true

	return view
end)
end