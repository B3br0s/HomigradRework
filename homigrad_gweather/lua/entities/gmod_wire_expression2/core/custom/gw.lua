E2Lib.RegisterExtension("gWeather", true, "gWeather functions")

__e2setcost( 8 )

e2function number getWindSpeed()
	return gWeather:GetWindSpeed() or 0
end
	
e2function vector getWindDirection()
	return gWeather:GetWindDirection()
end
	
e2function number getTemperature()
	return gWeather:GetTemperature() or 0
end
	
e2function number getHumidity()
	return gWeather:GetHumidity() or 0
end

e2function number getDewPoint()
	return gWeather:GetDewPoint() or 0
end

e2function number getPrecipitation()
	return gWeather:GetPrecipitation() or 0
end

__e2setcost( 10 )

e2function number isRaining()
	return gWeather:IsRaining() and 1 or 0
end

e2function number isSnowing()
	return gWeather:IsSnowing() and 1 or 0
end

