function string.GetNameFromFilename(value)
	return string.Split(string.GetFileFromFilename(value),".")[1]
end

function string.SplitQMark(line)
	local wait

	local list = {}

	for i,str in pairs(string.Split(line," ")) do
		if string.sub(str,1,1) == '"' then
			wait = string.sub(str,2,#str)
		   
			if string.sub(wait,#wait,#wait) == '"' then
				list[#list + 1] = string.sub(wait,1,#wait - 1)
				
				wait = nil
			end

			continue
		end

		if wait then
			if string.sub(str,#str,#str) == '"' then
				wait = wait .. " " .. string.sub(str,1,#str - 1)

				list[#list + 1] = wait

				wait = nil
			else
				wait = wait .. " " .. str
			end
		else
			list[#list + 1] = tonumber(str) or str
		end
	end

	return list
end