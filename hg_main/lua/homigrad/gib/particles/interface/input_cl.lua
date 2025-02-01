local Rand,random = math.Rand,math.random

ParticleGravity = Vector(0,0,-400)

net.Receive("blood particle",function()
	blood_Bleed(net.ReadVector(),net.ReadVector())
end)

net.Receive("bleed artery",function()
	blood_BleedArtery(net.ReadVector(),net.ReadVector())
end)

net.Receive("blood particle more",function()
	local pos,vel = net.ReadVector(),net.ReadVector()

	for i = 1,random(10,15) do
		blood_Bleed(pos,vel + Vector(Rand(-15,15),Rand(-15,15)))
	end
end)

net.Receive("blood particle explode",function()
	local pos = net.ReadVector()
	local posEmit = net.ReadVector()
	local dir = pos - posEmit
	dir:Normalize()

	local emitter = ParticleEmitter(pos)

	for i = 1,random(25,35) do
		local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
		if not part then continue end

		local dir = dir:Clone():Mul(1000)
		dir:Rotate(Angle(Rand(-75,75),Rand(-125,125),0))

		part:SetColor(Rand(125,205),0,0)
		part:SetDieTime(Rand(0.5,1))

		part:SetStartAlpha(random(125,155)) part:SetEndAlpha(0)
		part:SetStartSize(Rand(10,15)) part:SetEndSize(Rand(125,175))

		part.Pos = pos
		part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)

		part:SetRoll(Rand(-300,300))
		part:SetVelocity(dir) part:SetAirResistance(Rand(155,300))
		part:SetPos(pos)
	end

	for i = 1,random(8,15) do
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		local dir = dir:Clone():Mul(-1000)
		dir:Rotate(Angle(Rand(-75,15),Rand(-125,125),0))

		part:SetDieTime(Rand(0.1,0.2))

		part:SetStartAlpha(random(125,155)) part:SetEndAlpha(0)
		part:SetStartSize(Rand(10,15)) part:SetEndSize(Rand(55,75))

		part.Pos = pos
		part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)

		part:SetRoll(Rand(-300,300))
		part:SetVelocity(dir)
		part:SetPos(pos)
	end

	for i = 1,random(15,25) do
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		local dir = dir:Clone():Mul(1555)
		dir:Rotate(Angle(Rand(-90,15),Rand(-125,125),0))

		part:SetDieTime(Rand(0.5,1))

		part:SetStartAlpha(random(125,155)) part:SetEndAlpha(0)
		part:SetStartSize(Rand(10,15)) part:SetEndSize(Rand(55,75))

		part.Pos = pos
		part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)

		part:SetGravity(ParticleGravity)
		part:SetStartLength(dir:Length() / 10)
		part:SetEndLength(0)

		part:SetVelocity(dir)
		part:SetPos(pos)
	end

	for i = 1,random(15,25) do
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		local dir = dir:Clone():Mul(Rand(300,500))
		dir:Rotate(Angle(Rand(-90,15),Rand(-125,125),0))
		dir[3] = dir[3] + Rand(555,1000)

		part:SetDieTime(Rand(3,4))

		part:SetStartAlpha(random(125,155)) part:SetEndAlpha(0)
		part:SetStartSize(Rand(10,15)) part:SetEndSize(Rand(55,75))

		part.Pos = pos
		part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)

		part:SetGravity(ParticleGravity * 4)
		part:SetStartLength(dir:Length() / 25)
		part:SetEndLength(0)

		part:SetVelocity(dir)
		part:SetPos(pos)
	end

	for i = 1,random(25,30) do
		local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
		if not part then continue end

		local dir = dir:Clone():Mul(Rand(555,666))
		dir:Rotate(Angle(Rand(-75,75),Rand(-75,75),0))

		part:SetDieTime(Rand(2,3))

		part:SetStartAlpha(random(25,55)) part:SetEndAlpha(0)
		part:SetStartSize(Rand(25,55)) part:SetEndSize(Rand(125,175))

		part.Pos = pos
		part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)
		part:SetColor(Rand(75,155),0,0)

		part:SetRoll(Rand(-300,300))
		part:SetVelocity(dir) part:SetAirResistance(Rand(200,300))
		part:SetPos(pos)
	end

	for i = 1,random(15,25) do
		local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
		if not part then continue end

		local dir = dir:Clone():Mul(-Rand(555,666))
		dir:Rotate(Angle(Rand(-75,75),Rand(-75,75),0))

		part:SetDieTime(Rand(2,3))

		part:SetStartAlpha(random(25,55)) part:SetEndAlpha(0)
		part:SetStartSize(Rand(25,55)) part:SetEndSize(Rand(125,175))

		part.Pos = pos
		part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)
		part:SetColor(Rand(75,155),0,0)

		part:SetRoll(Rand(-300,300))
		part:SetVelocity(dir) part:SetAirResistance(Rand(200,300))
		part:SetPos(pos)
	end

	emitter:Finish()

	sound.Emit(nil,"physics/flesh/flesh_bloody_impact_hard1.wav",75,1,50,pos)
	sound.Emit(nil,"physics/flesh/flesh_bloody_break.wav",75,1,80,pos)
	sound.Emit(nil,"physics/flesh/flesh_strider_impact_bullet3.wav",75,1,100,pos)
	sound.Emit(nil,"physics/body/body_medium_break3.wav",75,1,100,pos)

	local dir = dir:Clone():Mul(Rand(75,125))
	dir[3] = dir[3] + Rand(200,400)
	DropProp("models/Gibs/HGIBS.mdl",1,pos,Angle(),dir,Vector(Rand(-180,180),Rand(-180,180),Rand(-180,180)))
	for i = 1,2 do
		dir:Rotate(Angle(Rand(-75,75),Rand(-75,75),0))
		DropProp("models/Gibs/HGIBS_rib.mdl",1,pos,Angle(),dir,Vector(Rand(-180,180),Rand(-180,180),Rand(-180,180)))

		dir:Rotate(Angle(Rand(-75,75),Rand(-75,75),0))
		DropProp("models/Gibs/HGIBS_scapula.mdl",1,pos,Angle(),dir,Vector(Rand(-180,180),Rand(-180,180),Rand(-180,180)))
	end

	dir:Rotate(Angle(Rand(-75,75),Rand(-75,75),0))
	DropProp("models/Gibs/HGIBS_spine.mdl",1,pos,Angle(),dir,Vector(Rand(-180,180),Rand(-180,180),Rand(-180,180)))
end)

net.Receive("bp headshoot explode",function()
	local pos,dir = net.ReadVector(),net.ReadVector()

	local l1,l2 = pos - dir / 2,pos + dir / 2

	local r = random(10,15)

	local emitter = ParticleEmitter(pos)

	for i = 1,r do//back smoke
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.5,1))

        part:SetStartAlpha(random(35,75)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(10,15)) part:SetEndSize(Rand(125,175))

        part:SetGravity(ParticleGravity)
        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)

		local dir = dir:Clone():Mul(1000 * Rand(0.25,1))
		dir:Rotate(Angle(Rand(-35,35) * Rand(0.9,1.1),Rand(-35,35) * Rand(0.9,1.1)))
		dir:Mul(Rand(0.9,1.1))
		
		part:SetRoll(Rand(-360,360))
		part:SetVelocity(dir) part:SetAirResistance(25)
		part:SetPos(LerpVector(i / r * Rand(0.9,1.1),l1,l2))
	end

	for i = 1,r do//back strine
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.5,0.5))

        part:SetStartAlpha(random(155,175)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(10,15)) part:SetEndSize(Rand(15,15))

        part:SetGravity(ParticleGravity)
        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)

		local dir = dir:Clone():Mul(1000 * Rand(0.25,1))
		dir:Rotate(Angle(Rand(-25,25) * Rand(0.9,1.1),Rand(-55,55) * Rand(0.9,1.1)))
		dir:Mul(Rand(0.9,1.1))

		part:SetStartLength(dir:Length() / 10)--wooooooow
		part:SetEndLength(0)

		part:SetVelocity(dir) part:SetAirResistance(25)
		part:SetPos(LerpVector(i / r * Rand(0.9,1.1),l1,l2))
	end

	for i = 1,random(5,6) do//center smoke
		local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.25,0.5))

        part:SetStartAlpha(random(15,25)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(10,15)) part:SetEndSize(Rand(125,175))

		part:SetColor(125,0,0)

		local dir = dir:Clone():Mul(-500)
		dir:Rotate(Angle(Rand(-125,125) * Rand(0.9,1.1),Rand(125,180) * Rand(0.9,1.1) * math.randAbs()))

		part:SetVelocity(dir) part:SetAirResistance(250)
		part:SetPos(pos,l1,l2)
	end

	for i = 1,random(23,33) do//up strine
		local part = emitter:Add(ParticleMatBlood[random(1,#ParticleMatBlood)],pos)
		if not part then continue end

		part:SetDieTime(Rand(10,15))

        part:SetStartAlpha(random(25,75)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(5,7)) part:SetEndSize(Rand(5,7))

		part:SetGravity(ParticleGravity)
        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)
		part:SetColor(125,0,0)

		local dir = dir:Clone():Mul(75)
		dir:Rotate(Angle(Rand(-90,90) * Rand(0.9,1.1),Rand(90,230) * Rand(0.25,1.1) * math.randAbs()))
		dir[3] = dir[3] + Rand(75,333)

		part:SetStartLength(dir:Length() / 22)--wooooooow
		part:SetEndLength(0)

		part:SetVelocity(dir)
		part:SetPos(pos,l1,l2)
	end

	emitter:Finish()
	
	sound.Emit(nil,"homigrad/player/headshot" .. random(1,2) .. ".wav",75,0.75,85,pos)
	sound.Emit(nil,"homigrad/headshoot.wav",75,1,100,pos)
	sound.Emit(nil,"physics/flesh/flesh_strider_impact_bullet2.wav",75,1,75,pos)
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

			local dir = dir:Clone():Mul(1000 * Rand(0.5,1.5))
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

        part:SetGravity(ParticleGravity)
        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)

		local dir = dir:Clone():Mul(1000 * Rand(0.25,1))
		dir:Rotate(Angle(Rand(-25,25) * Rand(0.9,1.1),Rand(-55,55) * Rand(0.9,1.1)))
		dir:Mul(Rand(0.9,1.1))

		part:SetStartLength(dir:Length() / 10)--wooooooow
		part:SetEndLength(0)

		part:SetVelocity(dir) part:SetAirResistance(25)
		part:SetPos(LerpVector(i / r * Rand(0.9,1.1),l1,l2))
	end

	emitter:Finish()
	
	sound.Emit(nil,"physics/flesh/flesh_bloody_break.wav",75,0.5,75,pos)
	sound.Emit(nil,"physics/flesh/flesh_bloody_break.wav",75,0.25,100,pos)
	sound.Emit(nil,"physics/flesh/flesh_strider_impact_bullet3.wav",75,1,75,pos)
	for i = 1,3 do sound.Emit(nil,"homigrad/blood_splash.wav",75,1,100,pos) end
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

        part:SetGravity(ParticleGravity)
        part:SetCollide(true)

		local dir = dir:Clone():Mul(-75 * Rand(0.25,1))
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

        part:SetGravity(ParticleGravity)
        part:SetCollide(true)

		local dir = dir:Clone():Mul(-125 * Rand(0.25,1))
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

        part:SetGravity(ParticleGravity)
        part:SetCollide(true)

		local dir = dir:Clone():Mul(512 * Rand(0.75,1.25))
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

        part:SetGravity(ParticleGravity)
        part:SetCollide(true)

		local dir = dir:Clone():Mul(512 * Rand(0.25,0.5))
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

		part:SetGravity(ParticleGravity)
        part:SetCollide(true)
		part:SetColor(75,0,0)

		local dir = dir:Clone():Mul(512 * Rand(0.25,1))
		dir:Add(dirAngle:Right() * Rand(-1,1) * 25)
		dir:Add(dirAngle:Up() * Rand(-0.5,-0.25) * 25)

		part:SetRoll(Rand(-360,360))
		part:SetVelocity(dir) part:SetAirResistance(1024)
		part:SetPos(pos)
	end

	emitter:Finish()
	
	local ent = net.ReadEntity()
	sound.Emit(nil,"physics/flesh/flesh_squishy_impact_hard" .. 1 .. ".wav",75,1,100,pos,nil,ent)
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
        part:SetStartSize(Rand(33,45)) part:SetEndSize(Rand(75,90))

        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)

		local dir = dir:Clone():Mul(400 * Rand(0.25,1))
		dir:Rotate(Angle(Rand(-45,45) * Rand(0.9,1.1),Rand(-45,45) * Rand(0.9,1.1)))
		dir:Mul(Rand(0.9,1.1))

		part:SetRoll(Rand(-360,360))
		part:SetVelocity(dir) part:SetAirResistance(5)
		part:SetGravity(ParticleGravity)
	end

	for i = 1,random(5,6) do//smoke lite
		local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
		if not part then continue end

		part:SetDieTime(Rand(0.7,1))

        part:SetStartAlpha(random(15,25)) part:SetEndAlpha(0)
        part:SetStartSize(Rand(10,15)) part:SetEndSize(Rand(300,400))

        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)
		part:SetColor(125,0,0)

		local dir = dir:Clone():Mul(4000 * Rand(0.25,1))
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
        part:SetStartSize(Rand(5,8)) part:SetEndSize(Rand(15,15))

        part:SetGravity(ParticleGravity)
        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)

		local dir = dir:Clone():Mul(1000 * Rand(0.25,1))
		dir:Rotate(Angle(Rand(-45,45) * Rand(0.9,1.1),Rand(-90,90) * Rand(0.9,1.1)))
		dir:Mul(Rand(0.9,1.1))

		part:SetStartLength(dir:Length() / 8 * Rand(0.5,1))--wooooooow
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

		part:SetGravity(ParticleGravity)
        part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)
		part:SetColor(125,0,0)

		part:SetPos(pos + dir:Clone():Rotate(Angle(Rand(80,89),Rand(-180,180),0)):Mul(Rand(15,25)))

		local dir = dir:Clone():Mul(Rand(75,400))
		dir:Rotate(Angle(Rand(-45,45) * Rand(0.9,1.1),Rand(-90,90) * Rand(0.25,1.1)))

		part:SetStartLength(dir:Length() / 23 * Rand(0.7,1.75))--wooooooow
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
				part:SetStartSize(Rand(5,8)) part:SetEndSize(Rand(15,15))
		
				part:SetGravity(ParticleGravity)
				part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc)
		
				local dir = dir:Clone():Mul(1000 * Rand(0.25,1))
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

	sound.Emit(nil,"homigrad/player/headshot" .. random(1,2) .. ".wav",75,0.25,100,pos)
	sound.Emit(nil,"physics/flesh/flesh_strider_impact_bullet3.wav",75,1,100,pos)
	sound.Emit(nil,"physics/flesh/flesh_strider_impact_bullet2.wav",75,1,100,pos)
	sound.Emit(nil,"snd_jack_fragsplodeclose.wav",140,0.05,200,pos)
end)