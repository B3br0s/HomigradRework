if SERVER then
local webhookURL = "https://discord.com/api/webhooks/1314702884549427272/WebQ4yS9QzFqDOnzh71IXGvICXmwX0E3Kvt8BFnYCWHglhG9Kvfs8VaOYw07MVqCCuti"

local function sendToDiscord(message, logType, nigger,hooka)
    if not webhookURL or webhookURL == "" then return end

    local payload = {
        ["content"] = nigger,
        ["username"] = "Homigrad:Rework",
        ["embeds"] = {{
            ["title"] = "Homigrad:Rework LOG",
            ["description"] = message,
            ["color"] = logType == "Error" and 15158332 or logType == "Warning" and 16747008 or 11534591,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    http.Post((hooka or webhookURL), {
        payload_json = util.TableToJSON(payload)
    }, function(result)
        print("[B3 SYS] Sent.")
    end, function(failReason)
        print("[B3 SYS] Error!  " .. failReason)
    end)
end

hook.Add("ULibPlayerKicked", "LogPlayerKicked", function(ply, stfu, admen)
    if string.find(stfu,"[ULX]") then
        stfu = "Нет причины."
    end
    logToDiscord(admen:Nick() .. " | " .. admen:SteamID() .. " кикнул " .. ply .. " по причине: " .. stfu, "Warning")
end)

hook.Add("ULibPlayerBanned", "LogPlayerBanned", function(ply, tableban)
    local time = tableban.time
    local admin = tableban.admin
    local reason = (tableban.reason or "нету причины")
    local adminName = IsValid(admin) and admin or "Console"
    local banTime = time == 1734075426 and "перманент баном" or "на " .. time .. " минут"
    logToDiscord(adminName .. " забанил " .. ply .. " | " .. ply .. " " .. banTime .. " по причине: " .. reason, "Error")
end)

hook.Add("ULibPlayerUnbanned", "LogPlayerUnbanned", function(steamID, admin)
    local adminName = IsValid(admin) and admin:Nick() or "Console"
    logToDiscord(adminName .. " разбанил " .. steamID, "Info")
end)

_G.logToDiscord = function(message, logType,nigger,hooka)
    logType = logType or "Info"
    --sendToDiscord(message, logType,(nigger or " "),(hooka or nil))
end

hook.Add("PlayerInitialSpawn", "LogPlayerSpawn", function(ply)
    logToDiscord(ply:Nick() .. " | " .. ply:SteamID() .. "   -   " .. " Зашёл на сервер.", "Info")
end)

hook.Add("PlayerDisconnected", "LogPlayerDisconnect", function(ply)
    logToDiscord(ply:Nick() .. " | " .. ply:SteamID() .. "   -   " .. " Вышел с сервера.", "Info")
end)

hook.Add("PlayerSpawnedProp", "LogPlayerSpawnedProp", function(ply, model)
    logToDiscord(ply:Nick() .. " | " .. ply:SteamID() .. "   -   " .. " Заспавнил проп: " .. model, "Info")
end)

hook.Add("PlayerSpawnedSENT", "LogPlayerSpawnedSENT", function(ply, ent)
    logToDiscord(ply:Nick() .. " | " .. ply:SteamID() .. "   -   " .. " Заспавнил энтити: " .. ent:GetClass(), "Info")
end)

hook.Add("PlayerSpawnedNPC", "LogPlayerSpawnedNPC", function(ply, npc)
    logToDiscord(ply:Nick() .. " | " .. ply:SteamID() .. "   -   " .. " Заспавнил НПС: " .. npc:GetClass(), "Info")
end)

hook.Add("PlayerSpawnedRagdoll", "LogPlayerSpawnedRagdoll", function(ply, model, ent)
    logToDiscord(ply:Nick() .. " | " .. ply:SteamID() .. "   -   " .. " Заспавнил рагдолл: " .. model, "Info")
end)

hook.Add("PlayerSpawnedVehicle", "LogPlayerSpawnedVehicle", function(ply, ent)
    logToDiscord(ply:Nick() .. " | " .. ply:SteamID() .. "   -   " .. " Заспавнил машину: " .. ent:GetClass(), "Info")
end)

hook.Add("PlayerSpawnedEffect", "LogPlayerSpawnedEffect", function(ply, model, ent)
    logToDiscord(ply:Nick() .. " | " .. ply:SteamID() .. "   -   " .. " Заспавнил эффект: " .. model, "Info")
end)

hook.Add("PlayerGiveSWEP", "LogPlayerGiveSWEP", function(ply, class, swep)
    logToDiscord(ply:Nick() .. " | " .. ply:SteamID() .. "   -   " .. " Выдал себе оружие: " .. class, "Info")
end)

hook.Add("PlayerSay", "LogPlayerChat", function(ply, text)
    if not string.find(text, "@everyone") and not string.find(text, "@here") and not string.find(text, "@игрок") and not string.find(text, "*drop") and not string.find(text, "!ddosnigga") and not string.find(text, "*inv") and not string.find(text, "@игрок") and not string.find(text, "!menu") and not string.find(text, "!forcepolice") then
        logToDiscord(ply:Nick() .. " | " .. ply:SteamID() .. "   -   " .. " Сказал: " .. text, "Info")
    end
end)
end