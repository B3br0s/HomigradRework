local SWEP = oop.Get("hg_wep")
if not SWEP then return end

local hg_volume_shoot

local random,Rand = math.random,math.Rand

local mat_smoke = Material("mat_jack_gmod_shinesprite")
local mat_smoke2 = {
	Material("particle/smokesprites_0009"),
	Material("particle/smokesprites_0010"),
	Material("particle/smokesprites_0011")
}

local mat_sprak = Material("sprites/spark")
local mat_muzzle = Material("mat_jack_gmod_shinesprite")

local hg_best_weaponlight
cvars.CreateOption("hg_best_weaponlight","-1",function(value) hg_best_weaponlight = tonumber(value) end,-2,1)

local cos,sin = math.cos,math.sin

local hg_dlight_max

cvars.Hook("hg_dlight_max",function(value) hg_dlight_max = tonumber(value) end,"bullet")

local table_Count = table.Count//херово наверное, но мне похуй

function SWEP:ShootLight(pos,dir,color)
	if hg_best_weaponlight == 1 then
		if table_Count(LightMapList) + 1 <= hg_dlight_max then
			DynamicLamp(pos + Vector(2,0,4):Rotate(dir:Angle()),math.Rand(485,545),math.min(1 / 24,self.Primary.Wait,0.7)):SetBrightness(math.Rand(0.025,0.05) * 6):SetColor(color):SetTexture("effects/flashlight/soft"):Spawn()
		end
	elseif hg_best_weaponlight == 0 then
		local dlight = DynamicLight(self:EntIndex())
		dlight.Pos = pos
		dlight.r = color.r
		dlight.g = color.g
		dlight.b = color.b
		dlight.Brightness = 0.001
        
        local t = (1 / Rand(18,24)) / 8

		dlight.Decay = 1
		dlight.Size = Rand(480,512)
		dlight.DieTime = CurTime() + t

		dlight.ignoreLimit = true
		dlight:Spawn()

		/*ParticleLightEmit(dlight)
		timer.Simple(time,function() ParticleLightEmit(dlight) end)*/
	end
end

function SWEP:ShootEffect(pos,dir)
    local color = Color(255,225,125)

    self:ShootLight(pos,dir,color)
    self:ShootEffect_Manual(pos,dir,color)
end

function SWEP:ShootEffect_Manual(pos,dir,colorMuzzle,settings)
	settings = settings or {}

	if hg_best_weaponlight == -2 then return end
	
    local ang = dir:Angle()
	local emitter = ParticleEmitter(pos)

	local flashScale = settings.flashScale or 1
	
	local Time = RealTime()
	
	for i = 1,random(2,3) do--sparks
		local part = emitter:Add(mat_muzzle,pos - dir * Rand(4,6))
		if part then
			part:SetDieTime(Rand(1 / 28,1 / 30))

			part:SetColor(colorMuzzle.r,colorMuzzle.g,colorMuzzle.b)

			part:SetStartAlpha(Rand(75,155))
            part:SetEndAlpha(Rand(0,25))

			part:SetStartSize(Rand(5,10) * flashScale / 2)
			part:SetEndSize(Rand(30,35) * flashScale)
			part:SetRoll(Rand(-360,360))

			part:SetVelocity(dir * Rand(500,500))

			part:SetAirResistance(Rand(1750,2000))
		end
	end

	for i = 1,random(6,8) do--sparks lebgth
		local ang = ang:Clone():Rotate(Angle(Rand(-180,180),Rand(-180,180)))

		local part = emitter:Add(mat_smoke,pos + Vector(Rand(0,1),0,0):Rotate(ang))
		if part then
			part:SetDieTime(1 / Rand(18,24) * 1)

			part:SetColor(colorMuzzle.r,colorMuzzle.g,colorMuzzle.b)

			part:SetStartAlpha(Rand(225,255))
			part:SetEndAlpha(Rand(0,25) * flashScale)

			part:SetStartSize(Rand(0.1,0.175) * flashScale)
			part:SetEndSize(Rand(0.2,0.3) * flashScale)

			part:SetStartLength(Rand(2,4) * flashScale)
			part:SetEndLength(Rand(6,7) * flashScale)

			part:SetVelocity(Vector(Rand(125,300),0,0):Rotate(ang))
		end
	end

	--

	local part = emitter:Add(mat_sprak,pos + Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1)))
	if part then--glow
		part:SetDieTime(0.075)
        part:SetColor(colorMuzzle.r,colorMuzzle.g,colorMuzzle.b)
		part:SetStartAlpha(15)
		part:SetLighting(false)

		part:SetStartSize(Rand(6,8))
		part:SetEndSize(random(45,55) * flashScale)

		part:SetRoll(Rand(360,-360))
		part:SetVelocity(dir * 125)
	end

	local part = emitter:Add(mat_sprak,pos + Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1)))
	if part then--glow alpha
		part:SetDieTime(0.035)
        part:SetColor(colorMuzzle.r,colorMuzzle.g,colorMuzzle.b)
		part:SetStartAlpha(5)
		part:SetLighting(false)

		part:SetStartSize(Rand(12,13))
		part:SetEndSize(random(125,145) * flashScale)

		part:SetRoll(Rand(360,-360))
		part:SetVelocity(dir * 75)
	end

	--

	for i = 1,random(1,3) do--very alpha black smoke
		local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],(pos + Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
		if part then
			part:SetDieTime(Rand(0.5,1))

			local p = random(35,45)
			part:SetColor(p,p,random(25,35))

			part:SetStartAlpha(Rand(20,25))
			part:SetEndAlpha(0)

			part:SetStartSize(Rand(6,8))
			part:SetEndSize(12)
			part:SetRoll(Rand(128,360))

			part:SetVelocity((dir * Rand(5,10)):Rotate(Angle(0,cos(Time * 36) * 50,0)) + Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1)))
		end
	end

	local timeScale = settings.gasTimeScale or 1
	local gasSideScale = settings.gasSideScale or 1

	for i = 1,random(1,3) do--side gas
		local part = emitter:Add(mat_smoke,pos + Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1)))
		if part then
			part:SetDieTime(Rand(0.5,1) * timeScale)

			local p = random(30,35)
			part:SetColor(p,p,p)

			part:SetStartAlpha(Rand(25,35))
			part:SetEndAlpha(0)

			part:SetStartSize(Rand(6,8))
			part:SetEndSize(Rand(75,90) * gasSideScale)

			part:SetStartLength(Rand(7,8))
			part:SetEndLength(Rand(45,85) * gasSideScale)

			part:SetAirResistance(Rand(500,750))

            local ang = ang:Clone()
            ang:RotateAroundAxis(ang:Up(),90 + cos(Time * 25) * 7 + cos(Rand(0,100)) * Rand(25,45))
            ang:RotateAroundAxis(ang:Right(),sin(Time * 25) * 7)

			part:SetVelocity(Vector(Rand(75,300),0,0):Rotate(ang):Add(Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
		end

		local part = emitter:Add(mat_smoke,pos + Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1)))
		if part then
			part:SetDieTime(Rand(0.5,1) * timeScale)

			local p = random(30,35)
			part:SetColor(p,p,p)

			part:SetStartAlpha(Rand(25,35))
			part:SetEndAlpha(0)

			part:SetStartSize(Rand(6,8))
			part:SetEndSize(Rand(75,90) * gasSideScale)

			part:SetStartLength(Rand(7,8))
			part:SetEndLength(Rand(45,85) * gasSideScale)

			part:SetAirResistance(Rand(500,750))

            local ang = ang:Clone()
            ang:RotateAroundAxis(ang:Up(),-90 + cos(Time * 25) * 7 + cos(Rand(0,100)) * Rand(25,45))
            ang:RotateAroundAxis(ang:Right(),sin(Time * 25) * 7)

			part:SetVelocity(Vector(Rand(75,300),0,0):Rotate(ang):Add(Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
		end
	end

	local gasForwardScale = settings.gasForwardScale or 1

	for i = 1,random(3,4) do--forward gass
		local part = emitter:Add(mat_smoke,pos - dir:Clone():Mul(12):Add(Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
		if part then
			part:SetDieTime(Rand(0.25,0.5) * timeScale)

			local p = random(30,35)
			part:SetColor(p,p,p)

			part:SetStartAlpha(Rand(25,35))
			part:SetEndAlpha(0)

			part:SetStartSize(Rand(6,8))
			part:SetEndSize(Rand(30,45) * gasForwardScale)

            part:SetStartLength(Rand(4,5))
			part:SetEndLength(Rand(55,75) * gasForwardScale)

			part:SetAirResistance(Rand(1000,1750))

            local ang = ang:Clone()
            ang:RotateAroundAxis(ang:Up(),sin(Time * 75 + i) * Rand(0.5,1.5) * 8,0)
            ang:RotateAroundAxis(ang:Right(),cos(Time * 75 + i) * Rand(0.5,1.5) * 3)

			part:SetVelocity(Vector(Rand(255,750),0,0):Rotate(ang):Add(Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
		end
	end

	if self.Shell then
		local gun,isFake = self:GetGun()
		local pos,ang = self:GetRejectShell(gun)

		local dirShell = Vector(1,0,0):Rotate(ang)

		local dirGravity = dir:Clone()
		dirGravity[3] = 0
		dirGravity:Normalize()

		for i = 1,random(3,4) do--shell gass fast
			local part = emitter:Add(mat_smoke,pos - dirShell:Clone():Mul(12):Add(Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
			if part then
				part:SetDieTime(Rand(0.1,0.2) * timeScale)

				local p = random(25,35)
				part:SetColor(p,p,p)

				part:SetStartAlpha(Rand(35,90))
				part:SetEndAlpha(0)

				part:SetStartSize(Rand(6,8))
				part:SetEndSize(Rand(45,55))

				part:SetStartLength(Rand(30,35))
				part:SetEndLength(Rand(35,45))

				part:SetAirResistance(Rand(800,900))

				local ang = ang:Clone()
				ang:RotateAroundAxis(ang:Up(),sin(Time * 75 + i) * Rand(0.5,1.5) * 45,0)
				ang:RotateAroundAxis(ang:Right(),cos(Time * 75 + i) * Rand(0.5,1.5) * 6)

				part:SetVelocity(Vector(Rand(255,400),0,0):Rotate(ang):Add(Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
				part:SetGravity(-dirGravity * 1000)
			end
		end

		for i = 1,random(3,4) do--shell gass
			local part = emitter:Add(mat_smoke,pos + dirShell:Clone():Add(Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
			if part then
				part:SetDieTime(Rand(0.5,1) * timeScale)

				local p = random(15,35)
				part:SetColor(p,p,p)

				part:SetStartAlpha(Rand(25,35))
				part:SetEndAlpha(0)

				part:SetStartSize(Rand(1,2))
				part:SetEndSize(Rand(45,75))

				part:SetRoll(Rand(-1000,1000))

				part:SetAirResistance(Rand(150,250))

				local ang = ang:Clone()
				ang:RotateAroundAxis(ang:Up(),sin(Time * 75 + i) - 25 * Rand(0.9,1.1) + Rand(-25,75))
				ang:RotateAroundAxis(ang:Right(),cos(Time * 75 + i) - 25 * Rand(0.9,1.1) + Rand(-45,45))

				part:SetVelocity(Vector(Rand(95,125),0,0):Rotate(ang):Add(Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))))
				part:SetGravity(-dirGravity * 250)
			end
		end
	end

	emitter:Finish()
end

//

local hg_volume_shoot
cvars.CreateOption("hg_volume_shoot","1",function(value) hg_volume_shoot = tonumber(value) or 0 end,0,1)

local min,max = math.min,math.max

local TraceLine = util.TraceLine

function SWEP:ShootSound(pos,dir,entIndex)
	local ent = sound.GetEmitEntity(entIndex)//нужно если объект вне зоны pvs, даже если в зоне pvs всеравно его юзаем тк переход между виртуальным и настоящим может навести проблем..
	//например как мы звуки уберём

	ent:SetPos(pos)

	//

	local dis = pos:Distance(EyePos())

	local snd = self.Primary.Sound
	if TypeID(snd) == TYPE_TABLE then snd = snd[math.random(1,#snd)] end

	local sndFar = self.Primary.SoundFar
	if TypeID(sndFar) == TYPE_TABLE then sndFar = sndFar[math.random(1,#sndFar)] end

	ent:StopSound(snd)

	local v = Lerp(1 - min(max(dis - 2000,0) / 1000,1),0,hg_volume_shoot)
	local pitch = (self.Primary.SoundPitch or 100)

	local dsp = 0

	/*if not DWR_TracableToSky(pos,0,0) then//DWR_PositionState(pos) == "indoors" then
		local tr = {
			start = pos,
			endpos = pos + Vector(0,0,SOUNDHIGHROOFDISTANCE),
			filter = FilterFunctionSND,
			mask = MASK_GLOBAL
		}

		local ang = dir:Angle()

		tr.endpos = pos + Vector(0,400,0):Rotate(ang)
		local result = util.TraceLine(tr)

		if result.Hit then
			local v = result.Fraction

			v = max(v - 0.2,0) / 0.8

			dsp = 104
		else
			tr.endpos = pos + Vector(0,-400,0):Rotate(ang)
			local result = util.TraceLine(tr)

			if result.Hit then
				local v = result.Fraction

				v = max(v - 0.2,0) / 0.8

				dsp = 104
			end
		end
	end*/

	sound.Emit(ent,snd,140,v,pitch,pos,dsp)
	sound.Emit(ent,sndFar,140,Lerp(min(max(dis -1000) / 1000,1),0,hg_volume_shoot),pitch,pos)
	
	//

	//

	local ammotype = self.Primary.AmmoDWR or self.Primary.Ammo

	DWR_PlayReverb(pos,ammotype,nil,self)

	if not self.dwr_cracksDisable and self.GetOwner and self:GetOwner() ~= LocalPlayer() then
		local spread = self.Primary.Spread

		DWR_PlayBulletCrack(pos,dir,SOUNDSPEED,nil,ammotype)
	end
end
