local VECTOR = FindMetaTable("Vector")

function VECTOR:AddRotate(pos,ang)
	pos:Rotate(ang)
	
	self:Add(pos)

	return self
end

VectorRotate = VectorRotate or VECTOR.Rotate

function VECTOR:Rotate(ang)
	VectorRotate(self,ang)

	return self
end

function VECTOR:Clone() return Vector(self[1],self[2],self[3]) end

function VECTOR:Add(vec)
	self[1] = self[1] + vec[1]
	self[2] = self[2] + vec[2]
	self[3] = self[3] + vec[3]

	return self
end

function VECTOR:Sub(vec)
	self[1] = self[1] - vec[1]
	self[2] = self[2] - vec[2]
	self[3] = self[3] - vec[3]

	return self
end

function VECTOR:Div(value)
	self[1] = self[1] / value
	self[2] = self[2] / value
	self[3] = self[3] / value

	return self
end

function VECTOR:Mul(value)
	self[1] = self[1] * value
	self[2] = self[2] * value
	self[3] = self[3] * value

	return self
end

function VECTOR:Set(value)
	self[1] = value[1]
	self[2] = value[2]
	self[3] = value[3]

	return self
end

local vecZero = Vector()

function VECTOR:LerpFT(value,to)
	self:Set(LerpVectorFT(value,self,to or vecZero))
end

function VECTOR:Lerp(value,to)
	self:Set(LerpVector(value,self,to or vecZero))
end

local Clamp = math.Clamp

function VECTOR:Clamp(min1,max1,min2,max2,min3,max3)
	self[1] = Clamp(self[1],min1,max1)
	self[2] = Clamp(self[2],min2,max2)
	self[3] = Clamp(self[3],min3,max3)

	return self
end
