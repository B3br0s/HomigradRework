local max,min = math.max,math.min

function math.halfValue(value,maxvalue,k)
	k = maxvalue * k
	return max(value - k,0) / k
end

function math.halfValue2(value,maxvalue,k)
	k = maxvalue * k
	return min(value / k,1)
end

function math.safeDiv(a,b)
	if a == 0 and b == 0 then return 0 else return a / b end
end--pizdes

local random = math.random

function math.randAbs(value) return (random(0,1) == 0 and -1 or 1) end

function math.pointInBox(px,py,x,y,w,h)
	return (px >= x and px < x + w) and (py >= y and py < y + h)
end

function math.pointInBox3D(px,py,pz,x,y,z,w,h,l)
	return (px >= x and px < x + w) and (py >= y and py < y + h) and (pz >= z and pz < z + l)
end

if CLIENT then
	/*hook.Add("HUDPaint","Nigga",function()
		if not Nigga then return end

		for id,info in pairs(Nigga) do
			debugoverlay.Box(info[1],info[2],info[3],0.1,Color(255,255,255,0))
			debugoverlay.Text(info[1],info[4].damage,0.1)
		end
	end)*/
end