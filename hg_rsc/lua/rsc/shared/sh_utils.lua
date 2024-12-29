--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801
function RSC.Log(level, msg, ...)
    level = level or "info"
    msg = msg or ""
    MsgN("[RSC] ", level:upper(), " - ", msg:format(...))
end

if CLIENT then
    RSC.AccessRequests = {}
end

function RSC.HasAccess(ply, cb)
    if SERVER and not IsValid(ply) then return cb(false) end

    -- Clients need to ask server about access
    if CLIENT then
        table.insert(RSC.AccessRequests, cb)

        if #RSC.AccessRequests == 1 then
            net.Start("RSC.NetworkV2")
                net.WriteUInt(RSC.NET_OP_CHECK_ACCESS, 4)
            net.SendToServer()
        end
    return end

    -- Custom Rank System
    if RSC.Config.UseCustomRanks then
        local can = RSC.Config.CustomRanks[ ply:GetUserGroup() ]
        cb(tobool(can))
    return end

    -- CAMI access system
    if RSC.CAMILoaded then
        CAMI.PlayerHasAccess(ply, "screengrab", cb)
    return end

    -- Fallback access system
    cb(ply:IsSuperAdmin())
end

function RSC.AsyncHasAccess(ply)
    return promise.New(function(resolve)
        RSC.HasAccess(ply, resolve)
    end)
end

function RSC.CanScreengrab(receiver, victim, cb)
    RSC.HasAccess(receiver, function(can)
        if not can or not IsValid(victim) or victim:IsBot() then return cb(false) end
        if receiver:IsSuperAdmin() then return cb(true) end
        if receiver == victim or receiver:GetUserGroup() == victim:GetUserGroup() then return cb(true) end

        if RSC.Config.UseCustomRanks then
            cb( victim:IsAdmin() and not receiver:IsSuperAdmin() )
        return end

        if RSC.CAMILoaded then
            cb( not CAMI.UsergroupInherits(victim:GetUserGroup(), receiver:GetUserGroup()) )
        return end

        cb(false)
    end)
end

function RSC.AsyncCanScreengrab(receiver, victim)
    return promise.New(function(resolve)
        RSC.CanScreengrab(receiver, victim, resolve)
    end)
end

-- Returns image format and quality
function RSC.ParseQuality(quality)
    return quality == 2 and "png" or "jpeg", quality == 0 and 60 or 80
end

-- Returns player if found by a search string
function RSC.FindPlayer(str)
    if not isstring(str) then return end
    if str:match("^STEAM_%d:[01]:%d+$") then -- Find by SteamID
        local ply = player.GetBySteamID(str)
        if ply then return ply end
    end
    if str:match("^7%d+$") then -- Find by SteamID64
        local ply = player.GetBySteamID64(str)
        if ply then return ply end
    end

    -- Find by name
    str = str:lower()
    for _, ply in ipairs( player.GetHumans() ) do
        if ply:GetName():lower():match(str) then
            return ply
        end

        if DarkRP and ply:SteamName():lower():match(str) then
            return ply
        end
    end
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher#5801