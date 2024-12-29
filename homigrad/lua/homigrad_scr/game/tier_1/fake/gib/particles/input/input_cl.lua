local Rand,random = math.Rand,math.random

ParticleMatBlood = {}
for i = 1,8 do ParticleMatBlood[i] = Material("decals/blood" .. i) end

matblood = {}
    for i = 1,10 do 
        matblood[i] = Material("decals/blood" .. i) 
    end

local mats = {}
for i = 1,8 do mats[i] = Material("decals/blood" .. i) end
local countmats = #mats

ParticleMatSmoke = {}
for i = 1,6 do ParticleMatSmoke[i] = Material("particle/smokesprites_000" .. i) end

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
	
	for i = 1,3 do
	bloodparticels1[#bloodparticels1 + 1] = {pos,pos2,vel,mat,w,h}
	end
end

local function addBloodPartartery(pos,vel,mat,w,h)
	pos = pos + vecZero
	vel = vel / 5 + vecZero
	local pos2 = Vector()
	pos2:Set(pos)
	
	for i = 1,6 do
		bloodparticels1[#bloodparticels1 + 1] = {pos,pos2,vel,mat,w,h}
	end
end

local function TimedBleed(pos,vel,mat,w,h)
	pos = pos + vecZero
	vel = vel / 5 + vecZero
	local pos2 = Vector()
	pos2:Set(pos)
	
	bloodparticels1[#bloodparticels1 + 1] = {pos,pos2,vel,mat,w,h}
end

net.Receive("blood particle",function()
	local pos,vel = net.ReadVector(),net.ReadVector()
	for i = 1,5 do
		timer.Simple(0.02 * i,function()
			addBloodPart(pos,vel,mats[random(1,#mats)],1.5,2.5)
		end)
	end
end)

net.Receive("blood particleHead",function()
	for i = 1,150 do
		addBloodPart(net.ReadVector() + Vector(math.random(-27,26),math.random(-27,26),0),net.ReadVector() + Vector(0,0,10),mats[random(1,#mats)],5,5)
	end
end)


net.Receive("TimedBleeding",function()

end)

net.Receive("blood particleartery",function()
	addBloodPartartery(net.ReadVector(),net.ReadVector(),mats[random(1,#mats)],1,1)
end)

local function addBloodPartCrazy(pos,vel,mat,w,h)
	pos = pos + vecZero
	vel = vel * 50 + vecZero 
	local pos2 = Vector()
	for i = 1,30 do
	pos2:Set(pos + Vector(0,0,math.random(10,100)))	
	end
	
	bloodparticels1[#bloodparticels1 + 1] = {pos + Vector(0,0,math.random(5,45)),pos2 + Vector(0,0,math.random(5,45)),vel,ParticleMatBlood[math.random(#ParticleMatBlood)],w,h}
end

net.Receive("bleed artery",function()
	addBloodPartartery(net.ReadVector(),net.ReadVector())
end)

net.Receive("blood particle more",function()
	local pos,vel = net.ReadVector(),net.ReadVector()

	for i = 1,random(10,15) do
		addBloodPart(pos,vel + Vector(Rand(-15,15),Rand(-15,15)))
	end
end)

net.Receive("blood particle explode", function()
    local pos = net.ReadVector()
    local posEmit = net.ReadVector()
    local dir = pos - posEmit
    dir:Normalize()

    local emitter = ParticleEmitter(pos)

    for i = 1, math.random(25, 30) do
        local part = emitter:Add(ParticleMatBlood[math.random(1, #ParticleMatBlood)], pos)
        if not part then continue end

		for ii = 1,random(10,30) do
			addBloodPartCrazy(pos,posEmit + Vector(Rand(-300,300),Rand(-300,300)),ParticleMatBlood[math.random(#ParticleMatBlood)],random(10,15),random(10,15))
		end

        local particleDir = Vector(dir.x, dir.y, dir.z) * 1000
        particleDir:Rotate(Angle(math.Rand(-75, 75), math.Rand(-125, 125), 0))

        part:SetDieTime(math.Rand(0.5, 1))
        part:SetStartAlpha(math.random(125, 155))
        part:SetEndAlpha(0)
        part:SetStartSize(math.Rand(7, 15))
        part:SetEndSize(math.Rand(30, 40))

        part:SetCollide(true)
        if isfunction(blood_CollideFunc2) then
            part:SetCollideCallback(blood_CollideFunc2)
        end

        part:SetRoll(math.Rand(-300, 300))
        part:SetVelocity(particleDir)
        part:SetAirResistance(math.Rand(155, 300))
        part:SetPos(pos)
    end

    for i = 1,random(5,7) do
        local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
        if not part then continue end

        local dirCopy = Vector(dir.x, dir.y, dir.z) * -1000
        dirCopy:Rotate(Angle(Rand(-75,15),Rand(-125,125),0))

        part:SetDieTime(Rand(0.1,0.2))
        part:SetStartAlpha(random(125,155)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(2,5)) part:SetEndSize(Rand(5,7))

        part.Pos = pos
        --part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)

        part:SetRoll(Rand(-300,300))
        part:SetVelocity(dirCopy)
        part:SetPos(pos)
    end

    for i = 1,random(15,25) do
        local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
        if not part then continue end

        local dirCopy = Vector(dir.x, dir.y, dir.z) * 1555
        dirCopy:Rotate(Angle(Rand(-90,15),Rand(-125,125),0))

        part:SetDieTime(Rand(0.5,1))
        part:SetStartAlpha(random(125,155)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(2,5)) part:SetEndSize(Rand(5,7))

        part.Pos = pos
        --part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)
        --part:SetGravity(ParticleGravity)
        part:SetStartLength(dirCopy:Length() / 10)
        part:SetEndLength(0)

        part:SetVelocity(dirCopy)
        part:SetPos(pos)
    end

    for i = 1,random(15,25) do
        local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
        if not part then continue end

        local dirCopy = Vector(dir.x, dir.y, dir.z) * Rand(300,500)
        dirCopy:Rotate(Angle(Rand(-90,15),Rand(-125,125),0))
        dirCopy[3] = dirCopy[3] + Rand(555,1000)

        part:SetDieTime(Rand(3,4))
        part:SetStartAlpha(random(125,155)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(2,5)) part:SetEndSize(Rand(5,7))

        part.Pos = pos
        --part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)
        --part:SetGravity(ParticleGravity * 4)
        part:SetStartLength(dirCopy:Length() / 25)
        part:SetEndLength(0)

        part:SetVelocity(dirCopy)
        part:SetPos(pos)
    end

    for i = 1,random(25,30) do
        local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
        if not part then continue end

        local dirCopy = Vector(dir.x, dir.y, dir.z) * Rand(555,666)
        dirCopy:Rotate(Angle(Rand(-75,75),Rand(-75,75),0))

        part:SetDieTime(Rand(2,3))
        part:SetStartAlpha(random(55,85)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(55,75)) part:SetEndSize(Rand(75,125))

        part.Pos = pos
        --part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)
        part:SetColor(Rand(75,155),0,0)

        part:SetRoll(Rand(-300,300))
        part:SetVelocity(dirCopy) part:SetAirResistance(Rand(200,300))
        part:SetPos(pos)
    end

    for i = 1,random(15,25) do
        local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
        if not part then continue end

        local dirCopy = Vector(dir.x, dir.y, dir.z) * -Rand(555,666)
        dirCopy:Rotate(Angle(Rand(-75,75),Rand(-75,75),0))

        part:SetDieTime(Rand(2,3))
        part:SetStartAlpha(random(25,55)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(5,25)) part:SetEndSize(Rand(25,35))

        part.Pos = pos
        --part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)
        part:SetColor(Rand(75,155),0,0)

        part:SetRoll(Rand(-300,300))
        part:SetVelocity(dirCopy) part:SetAirResistance(Rand(200,300))
        part:SetPos(pos)
    end

    emitter:Finish()

    local dirCopy = Vector(dir.x, dir.y, dir.z) * Rand(75,125)
    dirCopy[3] = dirCopy[3] + Rand(200,400)

    dirCopy:Rotate(Angle(Rand(-75,75),Rand(-75,75),0))
end)

net.Receive("bp buckshoot",function()
	local pos,dir = net.ReadVector(),net.ReadVector()

	local l1,l2 = pos - dir / 2,pos + dir / 2

	local r = random(15,25)

	local emitter = ParticleEmitter(pos)

	timer.Simple(0.016,function()
		local emitter = ParticleEmitter(pos)
		
		for i = 1,r do//smokes
			local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
			if not part then continue end

			part:SetDieTime(Rand(0.5,1))

			part:SetStartAlpha(random(25,75)) part:SetEndAlpha(0)
			part:SetStartSize(Rand(10,15)) part:SetEndSize(Rand(125,175))

			part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)

			local dir = dir:Mul(1000 * Rand(0.5,1.5))
			dir:Rotate(Angle(Rand(-35,35) * Rand(0.9,1.1),Rand(-35,35) * Rand(0.9,1.1)))
			dir:Mul(Rand(0.9,1.1))

			part:SetRoll(Rand(-360,360))
			part:SetVelocity(dir) part:SetAirResistance(225)
			part:SetGravity((pos - (pos + dir)):Mul(0.5))
			part:SetPos(LerpVector(i / r * Rand(0.9,1.1),l1,l2))
		end

		emitter:Finish()
	end)

	r = random(25,35)

	for i = 1,r do//strine
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.5,0.5))

        part:SetStartAlpha(random(155,175)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(10,15)) part:SetEndSize(Rand(15,15))

        --part:SetGravity(ParticleGravity)
        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)

		local dir = dir:Mul(1000 * Rand(0.25,1))
		dir:Rotate(Angle(Rand(-25,25) * Rand(0.9,1.1),Rand(-55,55) * Rand(0.9,1.1)))
		dir:Mul(Rand(0.9,1.1))

		part:SetStartLength(dir:Length() / 10)--wooooooow
		part:SetEndLength(0)

		part:SetVelocity(dir) part:SetAirResistance(25)
		part:SetPos(LerpVector(i / r * Rand(0.9,1.1),l1,l2))
	end

	emitter:Finish()
	
	sound.Emit(nil,"physics/flesh/flesh_bloody_break.wav",125,0.5,75,pos)
	sound.Emit(nil,"physics/flesh/flesh_bloody_break.wav",125,0.25,100,pos)
	sound.Emit(nil,"physics/flesh/flesh_strider_impact_bullet3.wav",125,1,75,pos)
	for i = 1,3 do sound.Emit(nil,"homigrad/blood_splash.wav",125,1,100,pos) end
end)

net.Receive("bp hit",function()
	local pos,dir = net.ReadVector(),net.ReadVector()

	local r = random(2,3)

	local emitter = ParticleEmitter(pos)

	local dirAngle = dir:Angle()

	for i = 1,r do
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.5,1))

        part:SetStartAlpha(random(95,125)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(2,4)) part:SetEndSize(Rand(5,7))

        --part:SetGravity(ParticleGravity)
        part:SetCollide(true)

		local dir = dir:Mul(-75 * Rand(0.25,1))
		dir:Add(dirAngle:Right() * Rand(-1,1) * 45)
		dir:Add(dirAngle:Up() * Rand(-0.5,0.5) * 75)

		part:SetStartLength(12)--wooooooow
		part:SetEndLength(0)

		part:SetRoll(Rand(-360,360))
		part:SetVelocity(dir) part:SetAirResistance(55)
		part:SetPos(pos)
	end

	r = random(1,2)

	for i = 1,r do
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.5,1))

        part:SetStartAlpha(random(95,125)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(2,4)) part:SetEndSize(Rand(15,25))

        --part:SetGravity(ParticleGravity)
        part:SetCollide(true)

		local dir = dir:Mul(-125 * Rand(0.25,1))
		dir:Add(dirAngle:Right() * Rand(-1,1) * 25)
		dir:Add(dirAngle:Up() * Rand(-0.5,0.5) * 125)

		part:SetRoll(Rand(-360,360))
		part:SetVelocity(dir) part:SetAirResistance(125)
		part:SetPos(pos)
		part:SetColor(75,0,0)
	end
	
	--

	r = random(1,2)

	for i = 1,r do
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.5,1))

        part:SetStartAlpha(random(95,125)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(2,4)) part:SetEndSize(Rand(15,25))

        --part:SetGravity(ParticleGravity)
        part:SetCollide(true)

		local dir = dir:Mul(512 * Rand(0.75,1.25))
		dir:Add(dirAngle:Right() * Rand(-1,1) * 25)
		dir:Add(dirAngle:Up() * Rand(-0.5,0.5) * 125)

		part:SetStartLength(25)
		part:SetEndLength(0)

		part:SetRoll(Rand(-360,360))
		part:SetVelocity(dir) part:SetAirResistance(125)
		part:SetPos(pos)
	end

	r = random(1,2)

	for i = 1,r do
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.5,1))

        part:SetStartAlpha(random(95,125)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(2,4)) part:SetEndSize(Rand(15,25))

        --part:SetGravity(ParticleGravity)
        part:SetCollide(true)

		local dir = dir:Mul(512 * Rand(0.25,0.5))
		dir:Add(dirAngle:Right() * Rand(-1,1) * 25)
		dir:Add(dirAngle:Up() * Rand(-0.5,0.5) * 125)

		part:SetStartLength(15)
		part:SetEndLength(0)

		part:SetRoll(Rand(-360,360))
		part:SetVelocity(dir) part:SetAirResistance(125)
		part:SetPos(pos)
	end

	--

	r = random(1,2)

	for i = 1,r do
		local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.5,1))

        part:SetStartAlpha(random(75,125)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(2,4)) part:SetEndSize(Rand(25,35))

		----part:SetGravity(ParticleGravity)
        part:SetCollide(true)
		part:SetColor(75,0,0)

		local dir = dir:Mul(512 * Rand(0.25,1))
		dir:Add(dirAngle:Right() * Rand(-1,1) * 25)
		dir:Add(dirAngle:Up() * Rand(-0.5,-0.25) * 25)

		part:SetRoll(Rand(-360,360))
		part:SetVelocity(dir) part:SetAirResistance(1024)
		part:SetPos(pos)
	end

	emitter:Finish()
	
	local ent = net.ReadEntity()
	sound.Emit(ent:EntIndex(),"physics/flesh/flesh_squishy_impact_hard" .. 1 .. ".wav",75,1,100,pos,nil,ent)
end)

--

net.Receive("bp fall",function()
	local pos,dir = net.ReadVector(),net.ReadVector()

	local r = random(10,15)

	local emitter = ParticleEmitter(pos)

	for i = 1,r do//smoke
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(2,3))

        part:SetStartAlpha(random(25,55)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(1,2)) part:SetEndSize(Rand(2,4))

        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)

		local dir = dir:Mul(400 * Rand(0.25,1))
		dir:Rotate(Angle(Rand(-45,45) * Rand(0.9,1.1),Rand(-45,45) * Rand(0.9,1.1)))
		dir:Mul(Rand(0.9,1.1))

		part:SetRoll(Rand(-360,360))
		part:SetVelocity(dir) part:SetAirResistance(5)
		----part:SetGravity(ParticleGravity)
	end

	for i = 1,random(5,6) do//smoke lite
		local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.7,1))

        part:SetStartAlpha(random(15,25)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(1,2)) part:SetEndSize(Rand(2,4))

        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)
		part:SetColor(125,0,0)

		local dir = dir:Mul(4000 * Rand(0.25,1))
		dir:Rotate(Angle(Rand(-45,45) * Rand(0.9,1.1),Rand(-45,45) * Rand(0.9,1.1)))
		dir:Mul(Rand(0.9,1.1))

		part:SetVelocity(dir) part:SetAirResistance(1000)
		part:SetPos(pos)
	end

	for i = 1,r do//strine
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(2,3))

        part:SetStartAlpha(random(155,175)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(1,2)) part:SetEndSize(Rand(2,4))

        --part:SetGravity(ParticleGravity)
        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)

		local dir = dir:Mul(1000 * Rand(0.25,1))
		dir:Rotate(Angle(Rand(-45,45) * Rand(0.9,1.1),Rand(-90,90) * Rand(0.9,1.1)))
		dir:Mul(Rand(0.9,1.1))

		part:SetStartLength(dir:Length() / 52 * Rand(0.1,0.3))--wooooooow
		part:SetEndLength(0)

		part:SetVelocity(dir) part:SetAirResistance(25)
		part:SetPos(pos)
	end

	for i = 1,random(25,30) do//strine up
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(10,15))

        part:SetStartAlpha(random(125,200)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(5,7)) part:SetEndSize(Rand(5,7))

		----part:SetGravity(ParticleGravity)
        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)
		part:SetColor(125,0,0)

		part:SetPos(pos + dir:Rotate(Angle(Rand(80,89),Rand(-180,180),0)):Mul(Rand(15,25)))

		local dir = dir:Mul(Rand(75,400))
		dir:Rotate(Angle(Rand(-45,45) * Rand(0.9,1.1),Rand(-90,90) * Rand(0.25,1.1)))

		part:SetStartLength(dir:Length() / 23 * Rand(0.2,0.75))--wooooooow
		part:SetEndLength(0)

		part:SetVelocity(dir)
	end

	for i = 1,10 do//circle strine
		timer.Simple(i / 75,function()
			local emitter = ParticleEmitter(pos)

			for i = 1,random(1,3) do//strine
				local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
				if not part then continue end
		
				part:SetDieTime(Rand(2,3))
		
				part:SetStartAlpha(random(155,175)) part:SetEndAlpha(0)
				part:SetStartSize(Rand(1,3)) part:SetEndSize(Rand(3,6))
		
				----part:SetGravity(ParticleGravity)
				part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)
		
				local dir = dir:Mul(1000 * Rand(0.25,1))
				dir:Rotate(Angle(90 + Rand(-10,-2) * Rand(0.9,1.1),Rand(-180,180) * Rand(0.9,1.1)))
				dir:Mul(Rand(0.9,1.1))
		
				part:SetStartLength(dir:Length() / 8 * Rand(0.5,1))--wooooooow
				part:SetEndLength(0)
		
				part:SetVelocity(dir) part:SetAirResistance(25)
				part:SetPos(pos)
			end

			emitter:Finish()
		end)
	end

	emitter:Finish()
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