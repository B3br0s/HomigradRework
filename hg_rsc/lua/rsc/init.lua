--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
AddCSLuaFile()

RSC = RSC or {}
RSC.Config = RSC.Config or {}

RSC.CAMILoaded = RSC.CAMILoaded or false

local function IncludeClient(file)
    AddCSLuaFile(file)
    if CLIENT then include(file) end
end

local function IncludeServer(file)
    if SERVER then include(file) end
end

local function IncludeShared(file)
    AddCSLuaFile(file)
    include(file)
end

-- Config, and shared scripts
IncludeServer("rsc/config.lua")
IncludeShared("rsc/shared/sh_utils.lua")
IncludeShared("rsc/shared/sh_language.lua")
IncludeShared("rsc/shared/sh_net.lua")

-- Promise library
AddCSLuaFile("includes/modules/promise.lua")
require("promise")

-- Classes
IncludeShared("rsc/classes/event.lua")
IncludeShared("rsc/classes/service.lua")
IncludeShared("rsc/classes/capture_request.lua")

-- Loading services
for _, fileName in ipairs( file.Find("rsc/services/*", "LUA") ) do
    IncludeShared("rsc/services/" .. fileName)
end

-- Server side scripts
IncludeServer("rsc/server/sv_init.lua")
IncludeServer("rsc/server/sv_net.lua")
IncludeServer("rsc/server/sv_discord.lua")

-- Client side scripts
IncludeClient("rsc/client/cl_init.lua")
IncludeClient("rsc/client/cl_net.lua")
IncludeClient("rsc/client/cl_capture.lua")
IncludeClient("rsc/client/cl_gallery.lua")
IncludeClient("rsc/client/cl_admin.lua")

local function Init()
    if SERVER then
        -- Only server handles permission system
        if CAMI then
            if CAMI.Version < 20150704 then
                RSC.Log("error", "CAMI version is out of date. Please update your CAMI version or admin mod.")
            else
                local privilege = CAMI.RegisterPrivilege({
                    Name = "screengrab",
                    MinAccess = "superadmin",
                    Description = "Permission to screengrab someone using Retro's Screengrabber"
                })

                if privilege then
                    RSC.CAMILoaded = true
                end
            end
        end

        if not RSC.CAMILoaded and not RSC.Config.UseCustomRanks then
            RSC.Log("error", "Failed to load CAMI, please check your admin mod for CAMI support or submit a support ticket.")
            RSC.Log("warn", "Fallback to gmod permission system. Only superadmins can screengrab.")
        end
    end

    if CLIENT then
        local temporary_files = file.Find("rsc/temp/*", "DATA")
        for _, f in ipairs(temporary_files) do
            file.Delete("rsc/temp/" .. f)
        end
    end

    RSC.Log("info", "Done.")
end
hook.Add("Initialize", "RSC.Initialzie", Init)

concommand.Add("rsc", promise.Async(function(ply, _, args)
    if #args == 0 then
        if IsValid(ply) then ply:ConCommand("rsc_menu") end
    return end
    if IsValid(ply) and not RSC.AsyncHasAccess(ply):Await() then return end

    local victim = RSC.FindPlayer(args[1])
    if not victim then
        print(RSC.GetPhrase("#rsc.errors.invalid_victim"))
    return end
    if IsValid(ply) and not RSC.AsyncCanScreengrab(ply, victim) then return end

    local request = RSC.CaptureRequest.New()
    request:Capture(victim, args[2], tonumber(args[3])):Await()

    print("You can find screengrab here: ", request:GetDownloadURL():Await())
end))
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801