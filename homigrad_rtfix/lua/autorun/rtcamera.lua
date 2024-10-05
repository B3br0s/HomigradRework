AddCSLuaFile()

rtcam = {}
include '_rtcamera_settings.lua'


-- this is broken? 
-- It throws a lua error instead of actually being a diagnostic tool.
--[[
if SERVER then
	rtcam.addon:addDiagnostic('RTCam config is valid', function(callback)
		-- CompileString is used here to validate the _rtcamera_settings.lua file and check it for errors
		local config = CompileString(file.Read('_rtcamera_settings.lua', 'LUA'), '_rtcamera_settings.lua', false)
		if type(config) == 'string' then
			error("Error in config file: " .. tostring(config))
			return
		end
		config()
		callback(true)
	end)
end
]]-- 

if CLIENT then
	local targets = {}
	id_to_target = {}
	function rtcam.getTarget(id)
		if id then
			for k,v in ipairs(targets) do
				if v.id == id then
					v.count = v.count + 1
					return v
				end
			end
		end

		local index = 1
		while targets[index] do
			if targets[index].count == 0 then
				break
			end
			index = index + 1
		end
		
		if targets[index] == nil or GetConVarNumber("prtcamera_scrollLines", 0) then
			print("created a new render target")
			local rtid = 'prtcam-'..index
			local rt = GetRenderTarget(rtid, GetConVarNumber("prtcamera_resolution", 512), GetConVarNumber("prtcamera_resolution", 512), false)
			--local rt = GetRenderTarget(rtid, rtcam.resWidth, rtcam.resHeight, false)
			local mat
			if (GetConVarNumber("prtcamera_scrollLines") == 1) then
				mat = CreateMaterial("prtcam-mat-"..index..'-scr', "UnlitTwoTexture",{
					['$basetexture'] = rt,
					['$translucent'] = 1,
					['%tooltexture'] = "dev/dev_monitor",
					["$texture2"] = "dev/dev_scanline",
					['$ignorez'] = 0,
					['$vertexcolor'] = 1,
					['$nolod'] = 1,
					['Proxies'] = {
						['TextureScroll'] = {
							['texturescrollvar'] = '$texture2transform',
							['texturescrollrate'] = 0.3,
							['texturescrollangle'] = 270,
						}
					}
				})
			elseif (GetConVarNumber("prtcamera_scrollLines") == 0) then
				mat = CreateMaterial("prtcam-mat-"..index..'-one', "UnlitGeneric",{
					['$basetexture'] = rt,
					['$ignorez'] = 0,
					['$vertexcolor'] = 1,
					['$nolod'] = 1,
				})
			end
			targets[index] = {
				count = 0,
				id = rtid,
				rt = rt,
				mat = mat,
			}
		else
			print("recycled existing render target")
		end
		targets[index].count = targets[index].count + 1
		targets[index].id = id
		return targets[index]
	end

	function rtcam.releaseTarget(target)
		target.count = target.count - 1
		if target.count == 0 then
			target.id = nil
		end
	end
end
