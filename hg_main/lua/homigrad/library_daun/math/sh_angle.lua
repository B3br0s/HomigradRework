local ANGLE = FindMetaTable("Angle")
function ANGLE:Clone() return Angle(self[1],self[2],self[3]) end

function ANGLE:Add(vec)
	self[1] = self[1] + vec[1]
	self[2] = self[2] + vec[2]
	self[3] = self[3] + vec[3]

	return self
end

function ANGLE:Sub(vec)
	self[1] = self[1] - vec[1]
	self[2] = self[2] - vec[2]
	self[3] = self[3] - vec[3]

	return self
end

function ANGLE:Div(value)
	self[1] = self[1] / value
	self[2] = self[2] / value
	self[3] = self[3] / value

	return self
end

function ANGLE:Mul(value)
	self[1] = self[1] * value
	self[2] = self[2] * value
	self[3] = self[3] * value

	return self
end

function ANGLE:Set(value)
	self[1] = value[1]
	self[2] = value[2]
	self[3] = value[3]

	return self
end

function ANGLE:SetRoll(value) self[3] = value return self end//for vr

local abs = math.abs

function ANGLE:Length()
	return (abs(self[1]) + abs(self[2]) + abs(self[3])) / 3
end

ANGLE.Rotate = ANGLE.RotateAroundAxis

local angZero = Angle()

function ANGLE:LerpFT(value,to)
	self:Set(LerpAngleFT(value,self,to or angZero))
end

function ANGLE:Lerp(value,to)
	self:Set(LerpAngle(value,self,to or angZero))
end

if not HRotateAroundAxis then HRotateAroundAxis = ANGLE.RotateAroundAxis end

function ANGLE:RotateAroundAxis(axis,rot)
	HRotateAroundAxis(self,axis,rot)

	return self
end

function ANGLE:Rotate(ang)
	self:RotateAroundAxis(self:Up(),ang[1])
	self:RotateAroundAxis(self:Right(),ang[2])
	self:RotateAroundAxis(self:Forward(),ang[3])

	return self
end